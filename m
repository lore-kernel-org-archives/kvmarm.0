From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests v8 01/10] arm/arm64: yield on cpu_relax
Date: Thu,  8 Dec 2016 18:50:21 +0100
Message-ID: <20161208175030.12269-2-drjones@redhat.com>
References: <20161208175030.12269-1-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161208175030.12269-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peter.maydell@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

In many tests one or more cpus wait for events from other cpus. However,
with TCG, if the event triggering cpus then continue without first
informing TCG it should schedule other cpus, then those other cpus may
never get scheduled, and never see their events. This is because the
TCG scheduler relies on either the currently running cpu to invoke an
instruction that results in scheduling or for some I/O event to occur,
and then to do scheduling while handling the I/O. kvm-unit-tests do not
have external I/O events, so we must invoke a yielding instruction
wherever needed. cpu_relax() is almost always a place it's needed.

While this change is mostly for TCG, it's fine to do for KVM as well.
The Linux kernel made the same change with 1baa82f4803 for armv8. As
the yield instruction is also available on armv7, we make the change
for both.

Signed-off-by: Andrew Jones <drjones@redhat.com>

---

v8: new patch that drastically speeds up the tests with tcg,
    actually allowing it to complete at all after adding
    -nodefaults to the qemu command line...
---
 lib/arm/asm/barrier.h   | 5 +++--
 lib/arm64/asm/barrier.h | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/arm/asm/barrier.h b/lib/arm/asm/barrier.h
index 394a4a2da26f..927cd3801dfb 100644
--- a/lib/arm/asm/barrier.h
+++ b/lib/arm/asm/barrier.h
@@ -1,13 +1,14 @@
 #ifndef _ASMARM_BARRIER_H_
 #define _ASMARM_BARRIER_H_
 /*
- * Adapted form arch/arm/include/asm/barrier.h
+ * Adapted from arch/arm/include/asm/barrier.h
  */
 
 #define sev()		asm volatile("sev" : : : "memory")
 #define wfe()		asm volatile("wfe" : : : "memory")
 #define wfi()		asm volatile("wfi" : : : "memory")
-#define cpu_relax()	asm volatile(""    : : : "memory")
+#define yield()		asm volatile("yield" : : : "memory")
+#define cpu_relax()	yield()
 
 #define isb(option) __asm__ __volatile__ ("isb " #option : : : "memory")
 #define dsb(option) __asm__ __volatile__ ("dsb " #option : : : "memory")
diff --git a/lib/arm64/asm/barrier.h b/lib/arm64/asm/barrier.h
index dbdac9d339c7..4f7bb97c2279 100644
--- a/lib/arm64/asm/barrier.h
+++ b/lib/arm64/asm/barrier.h
@@ -7,7 +7,8 @@
 #define sev()		asm volatile("sev" : : : "memory")
 #define wfe()		asm volatile("wfe" : : : "memory")
 #define wfi()		asm volatile("wfi" : : : "memory")
-#define cpu_relax()	asm volatile(""    : : : "memory")
+#define yield()		asm volatile("yield" : : : "memory")
+#define cpu_relax()	yield()
 
 #define isb()		asm volatile("isb" : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
-- 
2.9.3

