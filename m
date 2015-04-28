From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v13 01/12] linux-headers: update headers according to 4.1-rc0
Date: Tue, 28 Apr 2015 17:51:02 +0100
Message-ID: <1430239873-31950-2-git-send-email-eric.auger@linaro.org>
References: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DADB4ED87
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:42:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OKpTjByhAQEh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 12:42:56 -0400 (EDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
 [209.85.212.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 117FF4ED89
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:42:55 -0400 (EDT)
Received: by wiun10 with SMTP id n10so36392179wiu.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 09:51:22 -0700 (PDT)
In-Reply-To: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com, agraf@suse.de, pbonzini@redhat.com, peter.crosthwaite@xilinx.com
Cc: patches@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This includes, among other things, VFIO platform driver and
irqfd/arm.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v12 -> v13:
- update for 4.1-rc0 headers

v10 -> v11:
- only includes header modifications related to vfio platform
  driver v14 and not those related to
  "vfio: type1: support for ARM SMMUS with VFIO_IOMMU_TYPE1"
---
 include/standard-headers/linux/virtio_blk.h |   8 +-
 linux-headers/asm-arm/kvm.h                 |   3 +
 linux-headers/asm-arm64/kvm.h               |   3 +
 linux-headers/asm-mips/kvm.h                | 164 +++++++++++++++++-----------
 linux-headers/asm-s390/kvm.h                |   4 +
 linux-headers/linux/kvm.h                   |  65 ++++++++++-
 linux-headers/linux/vfio.h                  |   2 +
 7 files changed, 183 insertions(+), 66 deletions(-)

diff --git a/include/standard-headers/linux/virtio_blk.h b/include/standard-headers/linux/virtio_blk.h
index 12016b4..cd601f4 100644
--- a/include/standard-headers/linux/virtio_blk.h
+++ b/include/standard-headers/linux/virtio_blk.h
@@ -58,7 +58,7 @@ struct virtio_blk_config {
 	uint32_t size_max;
 	/* The maximum number of segments (if VIRTIO_BLK_F_SEG_MAX) */
 	uint32_t seg_max;
-	/* geometry the device (if VIRTIO_BLK_F_GEOMETRY) */
+	/* geometry of the device (if VIRTIO_BLK_F_GEOMETRY) */
 	struct virtio_blk_geometry {
 		uint16_t cylinders;
 		uint8_t heads;
@@ -117,7 +117,11 @@ struct virtio_blk_config {
 #define VIRTIO_BLK_T_BARRIER	0x80000000
 #endif /* !VIRTIO_BLK_NO_LEGACY */
 
-/* This is the first element of the read scatter-gather list. */
+/*
+ * This comes first in the read scatter-gather list.
+ * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated,
+ * this is the first element of the read scatter-gather list.
+ */
 struct virtio_blk_outhdr {
 	/* VIRTIO_BLK_T* */
 	__virtio32 type;
diff --git a/linux-headers/asm-arm/kvm.h b/linux-headers/asm-arm/kvm.h
index 0db25bc..2499867 100644
--- a/linux-headers/asm-arm/kvm.h
+++ b/linux-headers/asm-arm/kvm.h
@@ -198,6 +198,9 @@ struct kvm_arch_memory_slot {
 /* Highest supported SPI, from VGIC_NR_IRQS */
 #define KVM_ARM_IRQ_GIC_MAX		127
 
+/* One single KVM irqchip, ie. the VGIC */
+#define KVM_NR_IRQCHIPS          1
+
 /* PSCI interface */
 #define KVM_PSCI_FN_BASE		0x95c1ba5e
 #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index 3ef77a4..c154c0b 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -191,6 +191,9 @@ struct kvm_arch_memory_slot {
 /* Highest supported SPI, from VGIC_NR_IRQS */
 #define KVM_ARM_IRQ_GIC_MAX		127
 
+/* One single KVM irqchip, ie. the VGIC */
+#define KVM_NR_IRQCHIPS          1
+
 /* PSCI interface */
 #define KVM_PSCI_FN_BASE		0x95c1ba5e
 #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
diff --git a/linux-headers/asm-mips/kvm.h b/linux-headers/asm-mips/kvm.h
index 2c04b6d..6985eb5 100644
--- a/linux-headers/asm-mips/kvm.h
+++ b/linux-headers/asm-mips/kvm.h
@@ -36,77 +36,85 @@ struct kvm_regs {
 
 /*
  * for KVM_GET_FPU and KVM_SET_FPU
- *
- * If Status[FR] is zero (32-bit FPU), the upper 32-bits of the FPRs
- * are zero filled.
  */
 struct kvm_fpu {
-	__u64 fpr[32];
-	__u32 fir;
-	__u32 fccr;
-	__u32 fexr;
-	__u32 fenr;
-	__u32 fcsr;
-	__u32 pad;
 };
 
 
 /*
- * For MIPS, we use KVM_SET_ONE_REG and KVM_GET_ONE_REG to access CP0
+ * For MIPS, we use KVM_SET_ONE_REG and KVM_GET_ONE_REG to access various
  * registers.  The id field is broken down as follows:
  *
- *  bits[2..0]   - Register 'sel' index.
- *  bits[7..3]   - Register 'rd'  index.
- *  bits[15..8]  - Must be zero.
- *  bits[31..16] - 1 -> CP0 registers.
- *  bits[51..32] - Must be zero.
  *  bits[63..52] - As per linux/kvm.h
+ *  bits[51..32] - Must be zero.
+ *  bits[31..16] - Register set.
+ *
+ * Register set = 0: GP registers from kvm_regs (see definitions below).
+ *
+ * Register set = 1: CP0 registers.
+ *  bits[15..8]  - Must be zero.
+ *  bits[7..3]   - Register 'rd'  index.
+ *  bits[2..0]   - Register 'sel' index.
+ *
+ * Register set = 2: KVM specific registers (see definitions below).
+ *
+ * Register set = 3: FPU / MSA registers (see definitions below).
  *
  * Other sets registers may be added in the future.  Each set would
  * have its own identifier in bits[31..16].
- *
- * The registers defined in struct kvm_regs are also accessible, the
- * id values for these are below.
  */
 
-#define KVM_REG_MIPS_R0 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 0)
-#define KVM_REG_MIPS_R1 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 1)
-#define KVM_REG_MIPS_R2 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 2)
-#define KVM_REG_MIPS_R3 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 3)
-#define KVM_REG_MIPS_R4 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 4)
-#define KVM_REG_MIPS_R5 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 5)
-#define KVM_REG_MIPS_R6 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 6)
-#define KVM_REG_MIPS_R7 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 7)
-#define KVM_REG_MIPS_R8 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 8)
-#define KVM_REG_MIPS_R9 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 9)
-#define KVM_REG_MIPS_R10 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 10)
-#define KVM_REG_MIPS_R11 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 11)
-#define KVM_REG_MIPS_R12 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 12)
-#define KVM_REG_MIPS_R13 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 13)
-#define KVM_REG_MIPS_R14 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 14)
-#define KVM_REG_MIPS_R15 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 15)
-#define KVM_REG_MIPS_R16 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 16)
-#define KVM_REG_MIPS_R17 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 17)
-#define KVM_REG_MIPS_R18 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 18)
-#define KVM_REG_MIPS_R19 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 19)
-#define KVM_REG_MIPS_R20 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 20)
-#define KVM_REG_MIPS_R21 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 21)
-#define KVM_REG_MIPS_R22 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 22)
-#define KVM_REG_MIPS_R23 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 23)
-#define KVM_REG_MIPS_R24 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 24)
-#define KVM_REG_MIPS_R25 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 25)
-#define KVM_REG_MIPS_R26 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 26)
-#define KVM_REG_MIPS_R27 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 27)
-#define KVM_REG_MIPS_R28 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 28)
-#define KVM_REG_MIPS_R29 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 29)
-#define KVM_REG_MIPS_R30 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 30)
-#define KVM_REG_MIPS_R31 (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 31)
-
-#define KVM_REG_MIPS_HI (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 32)
-#define KVM_REG_MIPS_LO (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 33)
-#define KVM_REG_MIPS_PC (KVM_REG_MIPS | KVM_REG_SIZE_U64 | 34)
-
-/* KVM specific control registers */
+#define KVM_REG_MIPS_GP		(KVM_REG_MIPS | 0x0000000000000000ULL)
+#define KVM_REG_MIPS_CP0	(KVM_REG_MIPS | 0x0000000000010000ULL)
+#define KVM_REG_MIPS_KVM	(KVM_REG_MIPS | 0x0000000000020000ULL)
+#define KVM_REG_MIPS_FPU	(KVM_REG_MIPS | 0x0000000000030000ULL)
+
+
+/*
+ * KVM_REG_MIPS_GP - General purpose registers from kvm_regs.
+ */
+
+#define KVM_REG_MIPS_R0		(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 |  0)
+#define KVM_REG_MIPS_R1		(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 |  1)
+#define KVM_REG_MIPS_R2		(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 |  2)
+#define KVM_REG_MIPS_R3		(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 |  3)
+#define KVM_REG_MIPS_R4		(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 |  4)
+#define KVM_REG_MIPS_R5		(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 |  5)
+#define KVM_REG_MIPS_R6		(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 |  6)
+#define KVM_REG_MIPS_R7		(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 |  7)
+#define KVM_REG_MIPS_R8		(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 |  8)
+#define KVM_REG_MIPS_R9		(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 |  9)
+#define KVM_REG_MIPS_R10	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 10)
+#define KVM_REG_MIPS_R11	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 11)
+#define KVM_REG_MIPS_R12	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 12)
+#define KVM_REG_MIPS_R13	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 13)
+#define KVM_REG_MIPS_R14	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 14)
+#define KVM_REG_MIPS_R15	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 15)
+#define KVM_REG_MIPS_R16	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 16)
+#define KVM_REG_MIPS_R17	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 17)
+#define KVM_REG_MIPS_R18	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 18)
+#define KVM_REG_MIPS_R19	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 19)
+#define KVM_REG_MIPS_R20	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 20)
+#define KVM_REG_MIPS_R21	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 21)
+#define KVM_REG_MIPS_R22	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 22)
+#define KVM_REG_MIPS_R23	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 23)
+#define KVM_REG_MIPS_R24	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 24)
+#define KVM_REG_MIPS_R25	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 25)
+#define KVM_REG_MIPS_R26	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 26)
+#define KVM_REG_MIPS_R27	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 27)
+#define KVM_REG_MIPS_R28	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 28)
+#define KVM_REG_MIPS_R29	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 29)
+#define KVM_REG_MIPS_R30	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 30)
+#define KVM_REG_MIPS_R31	(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 31)
+
+#define KVM_REG_MIPS_HI		(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 32)
+#define KVM_REG_MIPS_LO		(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 33)
+#define KVM_REG_MIPS_PC		(KVM_REG_MIPS_GP | KVM_REG_SIZE_U64 | 34)
+
+
+/*
+ * KVM_REG_MIPS_KVM - KVM specific control registers.
+ */
 
 /*
  * CP0_Count control
@@ -118,8 +126,7 @@ struct kvm_fpu {
  *        safely without losing time or guest timer interrupts.
  * Other: Reserved, do not change.
  */
-#define KVM_REG_MIPS_COUNT_CTL		(KVM_REG_MIPS | KVM_REG_SIZE_U64 | \
-					 0x20000 | 0)
+#define KVM_REG_MIPS_COUNT_CTL	    (KVM_REG_MIPS_KVM | KVM_REG_SIZE_U64 | 0)
 #define KVM_REG_MIPS_COUNT_CTL_DC	0x00000001
 
 /*
@@ -131,15 +138,46 @@ struct kvm_fpu {
  * emulated.
  * Modifications to times in the future are rejected.
  */
-#define KVM_REG_MIPS_COUNT_RESUME	(KVM_REG_MIPS | KVM_REG_SIZE_U64 | \
-					 0x20000 | 1)
+#define KVM_REG_MIPS_COUNT_RESUME   (KVM_REG_MIPS_KVM | KVM_REG_SIZE_U64 | 1)
 /*
  * CP0_Count rate in Hz
  * Specifies the rate of the CP0_Count timer in Hz. Modifications occur without
  * discontinuities in CP0_Count.
  */
-#define KVM_REG_MIPS_COUNT_HZ		(KVM_REG_MIPS | KVM_REG_SIZE_U64 | \
-					 0x20000 | 2)
+#define KVM_REG_MIPS_COUNT_HZ	    (KVM_REG_MIPS_KVM | KVM_REG_SIZE_U64 | 2)
+
+
+/*
+ * KVM_REG_MIPS_FPU - Floating Point and MIPS SIMD Architecture (MSA) registers.
+ *
+ *  bits[15..8]  - Register subset (see definitions below).
+ *  bits[7..5]   - Must be zero.
+ *  bits[4..0]   - Register number within register subset.
+ */
+
+#define KVM_REG_MIPS_FPR	(KVM_REG_MIPS_FPU | 0x0000000000000000ULL)
+#define KVM_REG_MIPS_FCR	(KVM_REG_MIPS_FPU | 0x0000000000000100ULL)
+#define KVM_REG_MIPS_MSACR	(KVM_REG_MIPS_FPU | 0x0000000000000200ULL)
+
+/*
+ * KVM_REG_MIPS_FPR - Floating point / Vector registers.
+ */
+#define KVM_REG_MIPS_FPR_32(n)	(KVM_REG_MIPS_FPR | KVM_REG_SIZE_U32  | (n))
+#define KVM_REG_MIPS_FPR_64(n)	(KVM_REG_MIPS_FPR | KVM_REG_SIZE_U64  | (n))
+#define KVM_REG_MIPS_VEC_128(n)	(KVM_REG_MIPS_FPR | KVM_REG_SIZE_U128 | (n))
+
+/*
+ * KVM_REG_MIPS_FCR - Floating point control registers.
+ */
+#define KVM_REG_MIPS_FCR_IR	(KVM_REG_MIPS_FCR | KVM_REG_SIZE_U32 |  0)
+#define KVM_REG_MIPS_FCR_CSR	(KVM_REG_MIPS_FCR | KVM_REG_SIZE_U32 | 31)
+
+/*
+ * KVM_REG_MIPS_MSACR - MIPS SIMD Architecture (MSA) control registers.
+ */
+#define KVM_REG_MIPS_MSA_IR	 (KVM_REG_MIPS_MSACR | KVM_REG_SIZE_U32 |  0)
+#define KVM_REG_MIPS_MSA_CSR	 (KVM_REG_MIPS_MSACR | KVM_REG_SIZE_U32 |  1)
+
 
 /*
  * KVM MIPS specific structures and definitions
diff --git a/linux-headers/asm-s390/kvm.h b/linux-headers/asm-s390/kvm.h
index c5a93eb..512d8f1 100644
--- a/linux-headers/asm-s390/kvm.h
+++ b/linux-headers/asm-s390/kvm.h
@@ -150,6 +150,7 @@ struct kvm_guest_debug_arch {
 #define KVM_SYNC_CRS    (1UL << 3)
 #define KVM_SYNC_ARCH0  (1UL << 4)
 #define KVM_SYNC_PFAULT (1UL << 5)
+#define KVM_SYNC_VRS    (1UL << 6)
 /* definition of registers in kvm_run */
 struct kvm_sync_regs {
 	__u64 prefix;	/* prefix register */
@@ -164,6 +165,9 @@ struct kvm_sync_regs {
 	__u64 pft;	/* pfault token [PFAULT] */
 	__u64 pfs;	/* pfault select [PFAULT] */
 	__u64 pfc;	/* pfault compare [PFAULT] */
+	__u64 vrs[32][2];	/* vector registers */
+	__u8  reserved[512];	/* for future vector expansion */
+	__u32 fpc;	/* only valid with vector registers */
 };
 
 #define KVM_REG_S390_TODPR	(KVM_REG_S390 | KVM_REG_SIZE_U32 | 0x1)
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 60a54c8..7039166 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -147,6 +147,16 @@ struct kvm_pit_config {
 
 #define KVM_PIT_SPEAKER_DUMMY     1
 
+struct kvm_s390_skeys {
+	__u64 start_gfn;
+	__u64 count;
+	__u64 skeydata_addr;
+	__u32 flags;
+	__u32 reserved[9];
+};
+#define KVM_S390_GET_SKEYS_NONE   1
+#define KVM_S390_SKEYS_MAX        1048576
+
 #define KVM_EXIT_UNKNOWN          0
 #define KVM_EXIT_EXCEPTION        1
 #define KVM_EXIT_IO               2
@@ -172,6 +182,7 @@ struct kvm_pit_config {
 #define KVM_EXIT_S390_TSCH        22
 #define KVM_EXIT_EPR              23
 #define KVM_EXIT_SYSTEM_EVENT     24
+#define KVM_EXIT_S390_STSI        25
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -309,6 +320,15 @@ struct kvm_run {
 			__u32 type;
 			__u64 flags;
 		} system_event;
+		/* KVM_EXIT_S390_STSI */
+		struct {
+			__u64 addr;
+			__u8 ar;
+			__u8 reserved;
+			__u8 fc;
+			__u8 sel1;
+			__u16 sel2;
+		} s390_stsi;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -324,7 +344,7 @@ struct kvm_run {
 	__u64 kvm_dirty_regs;
 	union {
 		struct kvm_sync_regs regs;
-		char padding[1024];
+		char padding[2048];
 	} s;
 };
 
@@ -365,6 +385,24 @@ struct kvm_translation {
 	__u8  pad[5];
 };
 
+/* for KVM_S390_MEM_OP */
+struct kvm_s390_mem_op {
+	/* in */
+	__u64 gaddr;		/* the guest address */
+	__u64 flags;		/* flags */
+	__u32 size;		/* amount of bytes */
+	__u32 op;		/* type of operation */
+	__u64 buf;		/* buffer in userspace */
+	__u8 ar;		/* the access register number */
+	__u8 reserved[31];	/* should be set to 0 */
+};
+/* types for kvm_s390_mem_op->op */
+#define KVM_S390_MEMOP_LOGICAL_READ	0
+#define KVM_S390_MEMOP_LOGICAL_WRITE	1
+/* flags for kvm_s390_mem_op->flags */
+#define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
+#define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
+
 /* for KVM_INTERRUPT */
 struct kvm_interrupt {
 	/* in */
@@ -520,6 +558,13 @@ struct kvm_s390_irq {
 	} u;
 };
 
+struct kvm_s390_irq_state {
+	__u64 buf;
+	__u32 flags;
+	__u32 len;
+	__u32 reserved[4];
+};
+
 /* for KVM_SET_GUEST_DEBUG */
 
 #define KVM_GUESTDBG_ENABLE		0x00000001
@@ -760,6 +805,14 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_ENABLE_HCALL 104
 #define KVM_CAP_CHECK_EXTENSION_VM 105
 #define KVM_CAP_S390_USER_SIGP 106
+#define KVM_CAP_S390_VECTOR_REGISTERS 107
+#define KVM_CAP_S390_MEM_OP 108
+#define KVM_CAP_S390_USER_STSI 109
+#define KVM_CAP_S390_SKEYS 110
+#define KVM_CAP_MIPS_FPU 111
+#define KVM_CAP_MIPS_MSA 112
+#define KVM_CAP_S390_INJECT_IRQ 113
+#define KVM_CAP_S390_IRQ_STATE 114
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1135,6 +1188,16 @@ struct kvm_s390_ucas_mapping {
 #define KVM_ARM_VCPU_INIT	  _IOW(KVMIO,  0xae, struct kvm_vcpu_init)
 #define KVM_ARM_PREFERRED_TARGET  _IOR(KVMIO,  0xaf, struct kvm_vcpu_init)
 #define KVM_GET_REG_LIST	  _IOWR(KVMIO, 0xb0, struct kvm_reg_list)
+/* Available with KVM_CAP_S390_MEM_OP */
+#define KVM_S390_MEM_OP		  _IOW(KVMIO,  0xb1, struct kvm_s390_mem_op)
+/* Available with KVM_CAP_S390_SKEYS */
+#define KVM_S390_GET_SKEYS      _IOW(KVMIO, 0xb2, struct kvm_s390_skeys)
+#define KVM_S390_SET_SKEYS      _IOW(KVMIO, 0xb3, struct kvm_s390_skeys)
+/* Available with KVM_CAP_S390_INJECT_IRQ */
+#define KVM_S390_IRQ              _IOW(KVMIO,  0xb4, struct kvm_s390_irq)
+/* Available with KVM_CAP_S390_IRQ_STATE */
+#define KVM_S390_SET_IRQ_STATE	  _IOW(KVMIO, 0xb5, struct kvm_s390_irq_state)
+#define KVM_S390_GET_IRQ_STATE	  _IOW(KVMIO, 0xb6, struct kvm_s390_irq_state)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index 95ba870..0508d0b 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -160,6 +160,8 @@ struct vfio_device_info {
 	__u32	flags;
 #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
+#define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
+#define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
-- 
1.8.3.2
