From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] kvmtool: headers: update to Linux v4.6 release
Date: Mon, 16 May 2016 14:43:58 +0100
Message-ID: <1463406238-2718-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 870C3411BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 09:40:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SlV1vAh2L3f9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 09:40:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A2CD40FA6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 09:40:25 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Update our copy of the KVM header files to match the kernel's v4.6.0.
This fixes the ARM PMU support, where the feature identifier was
changed during the merge window due to a merge conflict.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/linux/kvm.h       | 21 ++++++++++++++++++---
 powerpc/include/asm/kvm.h |  9 +++++++++
 x86/include/asm/kvm.h     | 14 +++++++++++++-
 3 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 50f44a2..a7f1f80 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -157,6 +157,7 @@ struct kvm_s390_skeys {
 
 struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
+#define KVM_EXIT_HYPERV_HCALL          2
 	__u32 type;
 	union {
 		struct {
@@ -165,6 +166,11 @@ struct kvm_hyperv_exit {
 			__u64 evt_page;
 			__u64 msg_page;
 		} synic;
+		struct {
+			__u64 input;
+			__u64 result;
+			__u64 params[2];
+		} hcall;
 	} u;
 };
 
@@ -541,7 +547,13 @@ struct kvm_s390_pgm_info {
 	__u8 exc_access_id;
 	__u8 per_access_id;
 	__u8 op_access_id;
-	__u8 pad[3];
+#define KVM_S390_PGM_FLAGS_ILC_VALID	0x01
+#define KVM_S390_PGM_FLAGS_ILC_0	0x02
+#define KVM_S390_PGM_FLAGS_ILC_1	0x04
+#define KVM_S390_PGM_FLAGS_ILC_MASK	0x06
+#define KVM_S390_PGM_FLAGS_NO_REWIND	0x08
+	__u8 flags;
+	__u8 pad[2];
 };
 
 struct kvm_s390_prefix_info {
@@ -850,8 +862,9 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_IOEVENTFD_ANY_LENGTH 122
 #define KVM_CAP_HYPERV_SYNIC 123
 #define KVM_CAP_S390_RI 124
-#define KVM_CAP_ARM_PMU_V3 125
-#define KVM_CAP_VCPU_ATTRIBUTES 126
+#define KVM_CAP_SPAPR_TCE_64 125
+#define KVM_CAP_ARM_PMU_V3 126
+#define KVM_CAP_VCPU_ATTRIBUTES 127
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1144,6 +1157,8 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_PPC_ALLOC_HTAB */
 #define KVM_PPC_ALLOCATE_HTAB	  _IOWR(KVMIO, 0xa7, __u32)
 #define KVM_CREATE_SPAPR_TCE	  _IOW(KVMIO,  0xa8, struct kvm_create_spapr_tce)
+#define KVM_CREATE_SPAPR_TCE_64	  _IOW(KVMIO,  0xa8, \
+				       struct kvm_create_spapr_tce_64)
 /* Available with KVM_CAP_RMA */
 #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
 /* Available with KVM_CAP_PPC_HTAB_FD */
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index ab4d473..c93cf35 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -333,6 +333,15 @@ struct kvm_create_spapr_tce {
 	__u32 window_size;
 };
 
+/* for KVM_CAP_SPAPR_TCE_64 */
+struct kvm_create_spapr_tce_64 {
+	__u64 liobn;
+	__u32 page_shift;
+	__u32 flags;
+	__u64 offset;	/* in pages */
+	__u64 size;	/* in pages */
+};
+
 /* for KVM_ALLOCATE_RMA */
 struct kvm_allocate_rma {
 	__u64 rma_size;
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index d7dcef5..cd54147 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -106,6 +106,8 @@ struct kvm_ioapic_state {
 #define KVM_IRQCHIP_IOAPIC       2
 #define KVM_NR_IRQCHIPS          3
 
+#define KVM_RUN_X86_SMM		 (1 << 0)
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 	/* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
@@ -281,6 +283,7 @@ struct kvm_reinject_control {
 #define KVM_VCPUEVENT_VALID_NMI_PENDING	0x00000001
 #define KVM_VCPUEVENT_VALID_SIPI_VECTOR	0x00000002
 #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
+#define KVM_VCPUEVENT_VALID_SMM		0x00000008
 
 /* Interrupt shadow states */
 #define KVM_X86_SHADOW_INT_MOV_SS	0x01
@@ -309,7 +312,13 @@ struct kvm_vcpu_events {
 	} nmi;
 	__u32 sipi_vector;
 	__u32 flags;
-	__u32 reserved[10];
+	struct {
+		__u8 smm;
+		__u8 pending;
+		__u8 smm_inside_nmi;
+		__u8 latched_init;
+	} smi;
+	__u32 reserved[9];
 };
 
 /* for KVM_GET/SET_DEBUGREGS */
@@ -345,4 +354,7 @@ struct kvm_xcrs {
 struct kvm_sync_regs {
 };
 
+#define KVM_X86_QUIRK_LINT0_REENABLED	(1 << 0)
+#define KVM_X86_QUIRK_CD_NW_CLEARED	(1 << 1)
+
 #endif /* _ASM_X86_KVM_H */
-- 
2.8.2
