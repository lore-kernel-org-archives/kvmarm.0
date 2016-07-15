From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v3 04/10] arm/arm64: add some delay routines
Date: Fri, 15 Jul 2016 15:00:35 +0200
Message-ID: <1468587641-7300-5-git-send-email-drjones@redhat.com>
References: <1468587641-7300-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1468587641-7300-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Allow a thread to wait some specified amount of time. Can
specify in cycles, usecs, and msecs.

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/processor.h   | 19 +++++++++++++++++++
 lib/arm/processor.c       | 15 +++++++++++++++
 lib/arm64/asm/processor.h | 19 +++++++++++++++++++
 lib/arm64/processor.c     | 15 +++++++++++++++
 4 files changed, 68 insertions(+)

diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index d2048f5f5f7e6..afc903ca7d4ab 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -5,7 +5,9 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#include <libcflat.h>
 #include <asm/ptrace.h>
+#include <asm/barrier.h>
=20
 enum vector {
 	EXCPTN_RST,
@@ -51,4 +53,21 @@ extern int mpidr_to_cpu(unsigned long mpidr);
 extern void start_usr(void (*func)(void *arg), void *arg, unsigned lon=
g sp_usr);
 extern bool is_user(void);
=20
+static inline u64 get_cntvct(void)
+{
+	u64 vct;
+	isb();
+	asm volatile("mrrc p15, 1, %Q0, %R0, c14" : "=3Dr" (vct));
+	return vct;
+}
+
+extern void delay(u64 cycles);
+extern void udelay(unsigned long usecs);
+
+static inline void mdelay(unsigned long msecs)
+{
+	while (msecs--)
+		udelay(1000);
+}
+
 #endif /* _ASMARM_PROCESSOR_H_ */
diff --git a/lib/arm/processor.c b/lib/arm/processor.c
index 54fdb87ef0196..c2ee360df6884 100644
--- a/lib/arm/processor.c
+++ b/lib/arm/processor.c
@@ -9,6 +9,7 @@
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
+#include <asm/barrier.h>
=20
 static const char *processor_modes[] =3D {
 	"USER_26", "FIQ_26" , "IRQ_26" , "SVC_26" ,
@@ -141,3 +142,17 @@ bool is_user(void)
 {
 	return current_thread_info()->flags & TIF_USER_MODE;
 }
+
+void delay(u64 cycles)
+{
+	u64 start =3D get_cntvct();
+	while ((get_cntvct() - start) < cycles)
+		cpu_relax();
+}
+
+void udelay(unsigned long usec)
+{
+	unsigned int frq;
+	asm volatile("mrc p15, 0, %0, c14, c0, 0" : "=3Dr" (frq));
+	delay((u64)usec * frq / 1000000);
+}
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 7e448dc81a6aa..94f7ce35b65c1 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -17,8 +17,10 @@
 #define SCTLR_EL1_M	(1 << 0)
=20
 #ifndef __ASSEMBLY__
+#include <libcflat.h>
 #include <asm/ptrace.h>
 #include <asm/esr.h>
+#include <asm/barrier.h>
=20
 enum vector {
 	EL1T_SYNC,
@@ -89,5 +91,22 @@ extern int mpidr_to_cpu(unsigned long mpidr);
 extern void start_usr(void (*func)(void *arg), void *arg, unsigned lon=
g sp_usr);
 extern bool is_user(void);
=20
+static inline u64 get_cntvct(void)
+{
+	u64 vct;
+	isb();
+	asm volatile("mrs %0, cntvct_el0" : "=3Dr" (vct));
+	return vct;
+}
+
+extern void delay(u64 cycles);
+extern void udelay(unsigned long usecs);
+
+static inline void mdelay(unsigned long msecs)
+{
+	while (msecs--)
+		udelay(1000);
+}
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index deeab4ec9c8ac..50fa835c6f1e3 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -9,6 +9,7 @@
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
+#include <asm/barrier.h>
=20
 static const char *vector_names[] =3D {
 	"el1t_sync",
@@ -253,3 +254,17 @@ bool is_user(void)
 {
 	return current_thread_info()->flags & TIF_USER_MODE;
 }
+
+void delay(u64 cycles)
+{
+	u64 start =3D get_cntvct();
+	while ((get_cntvct() - start) < cycles)
+		cpu_relax();
+}
+
+void udelay(unsigned long usec)
+{
+	unsigned int frq;
+	asm volatile("mrs %0, cntfrq_el0" : "=3Dr" (frq));
+	delay((u64)usec * frq / 1000000);
+}
--=20
2.7.4

