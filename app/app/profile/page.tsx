import {
  changePasswordAction,
  logoutAction,
  updateProfileAction,
} from "@/app/actions";
import { PageHeader } from "@/components/layout/PageHeader";
import { Card } from "@/components/ui/Card";
import { requireSession } from "@/lib/auth";
import { listCategories } from "@/modules/question-bank/question-bank.service";
import { getProfile } from "@/modules/profile/profile.service";

export const dynamic = "force-dynamic";

interface ProfilePageProps {
  searchParams: Promise<{
    saved?: string;
    error?: string;
  }>;
}

function getProfileBanner(params: { saved?: string; error?: string }) {
  if (params.saved === "profile") {
    return "Profile updated.";
  }

  if (params.saved === "password") {
    return "Password changed.";
  }

  if (params.error === "email") {
    return "That email is already in use. Please choose another one.";
  }

  if (params.error === "current_password") {
    return "Current password is incorrect.";
  }

  if (params.error === "password") {
    return "Password update failed. Please review the form and try again.";
  }

  if (params.error === "profile") {
    return "Profile update failed. Please review the form and try again.";
  }

  return null;
}

export default async function ProfilePage({ searchParams }: ProfilePageProps) {
  const session = await requireSession();
  const [profile, categories, params] = await Promise.all([
    getProfile(session.user.id),
    listCategories(),
    searchParams,
  ]);
  const banner = getProfileBanner(params);

  return (
    <div className="page-stack">
      {banner ? <div className="demo-banner">{banner}</div> : null}
      <PageHeader
        title="Profile"
        description="Keep this page small in Version 1: account info, preferred tracks, and password management."
      />

      <section className="profile-grid">
        <Card title="Account">
          <form action={updateProfileAction} className="form-grid">
            <label className="field-full">
              Display Name
              <input
                type="text"
                name="displayName"
                defaultValue={profile.displayName}
              />
            </label>
            <label className="field-full">
              Email
              <input type="email" name="email" defaultValue={profile.email} />
            </label>
            <div className="field-full">
              <span>Preferred Tracks</span>
              <div className="selection-grid">
                {categories.map((category) => (
                  <label key={category.id} className="checkbox-option">
                    <input
                      type="checkbox"
                      name="preferredTracks"
                      value={category.name}
                      defaultChecked={profile.preferredTracks.includes(category.name)}
                    />
                    <span>{category.name}</span>
                  </label>
                ))}
              </div>
            </div>
            <div className="field-full">
              <button type="submit" className="button-primary">
                Save Changes
              </button>
            </div>
          </form>
        </Card>

        <Card title="Security">
          <form action={changePasswordAction} className="form-grid">
            <label className="field-full">
              Current Password
              <input type="password" name="currentPassword" />
            </label>
            <label className="field-full">
              New Password
              <input type="password" name="newPassword" />
            </label>
            <label className="field-full">
              Confirm New Password
              <input type="password" name="confirmPassword" />
            </label>
            <div className="field-full button-row">
              <button type="submit" className="button-primary">
                Change Password
              </button>
            </div>
          </form>
          <form action={logoutAction} className="inline-form">
            <button type="submit" className="button-secondary">
              Log Out
            </button>
          </form>
        </Card>
      </section>
    </div>
  );
}
