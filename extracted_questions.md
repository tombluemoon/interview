# Interview Questions Extracted from Notion

## PAGE: Week 1: JVM / Core Java / Collections / Concurrency
Total blocks fetched: 60+ (has_more: true)

### Part 1: JVM / GC / Memory

**Q1. When CPU usage is high in production, how do you decide whether GC is the real problem?**
Answer:
- I would not blame GC just because CPU is high.
- I would correlate CPU, GC pause time, allocation rate, old-gen usage after GC, and request latency.
- If CPU is high but GC is quiet, the issue is more likely serialization, regex, encryption, logging, or inefficient application code.
- If Full GC increased and old-gen usage stays high after collection, I would investigate object retention or cache growth.

**Q2. Why does increasing heap size not always fix OOM?**
Answer:
- If the problem is a memory leak, more heap only delays failure.
- If traffic increased and the workload legitimately needs more memory, increasing heap may help.
- The key question is whether memory comes down after GC. If it does not, that points more to retention than capacity.

**Q3. What is the most common fake "GC issue" you see in backend services?**
Answer:
- Slow database or remote dependency calls are often blamed on JVM first.
- Another common false alarm is excessive logging or large JSON payloads driving CPU and allocation pressure.
- In many incidents, GC is a symptom, not the root cause.

**Q4. Which JVM metrics do you check first besides heap usage?**
Answer:
- GC frequency and pause time
- Old-gen usage after GC
- Allocation rate
- Thread count
- Metaspace usage
- Safepoint time
- Process RSS and container memory limit

**Q5. How do you choose between G1GC and ZGC?**
Answer:
- I start with G1GC for most normal business services because it is stable and operationally simple.
- I consider ZGC when low latency matters and heap size is large enough that GC pauses affect tail latency.
- I would not choose ZGC because it sounds advanced. I would choose it because measured pause behavior justifies it.

**Q6. Full GC suddenly became frequent after a release. What is your first instinct?**
Answer:
- Compare the release diff before touching JVM flags.
- Look for new caches, larger payloads, more temporary objects, background jobs, ThreadLocal retention, or proxy/class generation growth.
- If the problem started right after a code change, I investigate allocation behavior before I tune GC.

**Q7. How do you actually investigate a Java memory leak?**
Answer:
1. Check whether old-gen usage after GC keeps climbing.
2. Capture a heap dump.
3. Use MAT or a similar tool to inspect dominator tree and retained heap.
4. Identify which objects are retaining memory.
5. Trace that back to business code and reference chains.

**Q8. What real scenarios can cause Metaspace OOM?**
Answer:
- Dynamic proxies or excessive class generation
- ClassLoader leaks in plugin or hot-reload systems
- Framework-heavy applications that create many generated classes
- This is especially relevant in Spring, CGLIB, ByteBuddy, or custom loading environments.

**Q9. When do you proactively enable heap dumps and GC logs?**
Answer:
- I usually enable OOM heap dump in production by default.
... (continues)

---

## PAGE: Week 2: Spring / MySQL / Redis / Transactions
Structure: Similar to Week 1, with heading_2 for parts (Spring, MySQL, Redis, Transactions) and heading_3 for questions.

---

## PAGE: Week 3: System Design / Microservices (week3-expanded-question-bank)
Correct ID: 32d71c6c-d06e-8169-ac3b-d96e2e0ae587
Structure: Similar format

---

## PAGE: Week 4: Behavioral
Structure: Similar format

---

## PAGE: AI Expanded Question Bank
Structure: Similar format

---

## PAGE: AI Engineering & Backend Question Bank
Structure: Similar format
