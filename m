From: Wei Huang <wei@redhat.com>
Subject: [kvm-unit-tests PATCH v13 1/4] arm: Define macros for accessing system registers
Date: Wed, 30 Nov 2016 23:16:39 -0600
Message-ID: <1480569402-8848-2-git-send-email-wei@redhat.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1480569402-8848-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: cov@codeaurora.org
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org, drjones@redhat.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch defines four macros to assist creating system register
accessors under both ARMv7 and AArch64:
   * DEFINE_GET_SYSREG32(name, ...)
   * DEFINE_SET_SYSREG32(name, ...)
   * DEFINE_GET_SYSREG64(name, ...)
   * DEFINE_SET_SYSREG64(name, ...)
These macros are translated to inline functions with consistent naming,
get_##name() and set_##name(), which can be used by C code directly.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Wei Huang <wei@redhat.com>
---
 lib/arm/asm/processor.h   | 37 ++++++++++++++++++++++++++++++++-----
 lib/arm64/asm/processor.h | 35 ++++++++++++++++++++++++++++-------
 2 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index f25e7ee..3ca6b42 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -33,13 +33,40 @@ static inline unsigned long current_cpsr(void)
 
 #define current_mode() (current_cpsr() & MODE_MASK)
 
-static inline unsigned int get_mpidr(void)
-{
-	unsigned int mpidr;
-	asm volatile("mrc p15, 0, %0, c0, c0, 5" : "=r" (mpidr));
-	return mpidr;
+#define DEFINE_GET_SYSREG32(name, opc1, crn, crm, opc2)			\
+static inline uint32_t get_##name(void)					\
+{									\
+	uint32_t reg;							\
+	asm volatile("mrc p15, " #opc1 ", %0, " #crn ", " #crm ", "	\
+		     #opc2 : "=r" (reg));				\
+	return reg;							\
+}
+
+#define DEFINE_SET_SYSREG32(name, opc1, crn, crm, opc2)			\
+static inline void set_##name(uint32_t value)				\
+{									\
+	asm volatile("mcr p15, " #opc1 ", %0, " #crn ", " #crm ", "	\
+		     #opc2 :: "r" (value));				\
+}
+
+#define DEFINE_GET_SYSREG64(name, opc, crm)				\
+static inline uint64_t get_##name(void)					\
+{									\
+	uint32_t lo, hi;						\
+	asm volatile("mrrc p15, " #opc ", %0, %1, " #crm		\
+		     : "=r" (lo), "=r" (hi));				\
+	return (uint64_t)hi << 32 | lo;					\
+}
+
+#define DEFINE_SET_SYSREG64(name, opc, crm)				\
+static inline void set_##name(uint64_t value)				\
+{									\
+	asm volatile("mcrr p15, " #opc ", %0, %1, " #crm		\
+		     :: "r" (value & 0xffffffff), "r" (value >> 32));	\
 }
 
+DEFINE_GET_SYSREG32(mpidr, 0, c0, c0, 5)
+
 /* Only support Aff0 for now, up to 4 cpus */
 #define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
 
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 84d5c7c..dfa75eb 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -66,14 +66,35 @@ static inline unsigned long current_level(void)
 	return el & 0xc;
 }
 
-#define DEFINE_GET_SYSREG32(reg)				\
-static inline unsigned int get_##reg(void)			\
-{								\
-	unsigned int reg;					\
-	asm volatile("mrs %0, " #reg "_el1" : "=r" (reg));	\
-	return reg;						\
+#define DEFINE_GET_SYSREG32(reg, el)					\
+static inline uint32_t get_##reg(void)					\
+{									\
+	uint32_t reg;							\
+	asm volatile("mrs %0, " #reg "_" #el : "=r" (reg));		\
+	return reg;							\
 }
-DEFINE_GET_SYSREG32(mpidr)
+
+#define DEFINE_SET_SYSREG32(reg, el)					\
+static inline void set_##reg(uint32_t value)				\
+{									\
+	asm volatile("msr " #reg "_" #el ", %0" :: "r" (value));	\
+}
+
+#define DEFINE_GET_SYSREG64(reg, el)					\
+static inline uint64_t get_##reg(void)					\
+{									\
+	uint64_t reg;							\
+	asm volatile("mrs %0, " #reg "_" #el : "=r" (reg));		\
+	return reg;							\
+}
+
+#define DEFINE_SET_SYSREG64(reg, el)					\
+static inline void set_##reg(uint64_t value)				\
+{									\
+	asm volatile("msr " #reg "_" #el ", %0" :: "r" (value));	\
+}
+
+DEFINE_GET_SYSREG32(mpidr, el1)
 
 /* Only support Aff0 for now, gicv2 only */
 #define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
-- 
1.8.3.1

