From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5 18/18] kvm: arm64: Allow tuning the physical address size for VM
Date: Mon, 17 Sep 2018 11:41:40 +0100
Message-ID: <20180917104144.19188-19-suzuki.poulose@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917104144.19188-1-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, dave.martin@arm.com, julien.grall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, Peter Maydel <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Allow specifying the physical address size limit for a new
VM via the kvm_type argument for the KVM_CREATE_VM ioctl. This
allows us to finalise the stage2 page table as early as possible
and hence perform the right checks on the memory slots
without complication. The size is ecnoded as Log2(PA_Size) in
bits[7:0] of the type field. For backward compatibility the
value 0 is reserved and implies 40bits. Also, lift the limit
of the IPA to host limit and allow lower IPA sizes (e.g, 32).

The userspace could check the extension KVM_CAP_ARM_VM_PHYS_SHIFT
for the availability of this feature. The cap check returns the
maximum limit for the physical address shift supported by the host.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Cc: Peter Maydel <peter.maydell@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v4:
 - Fold the introduction of the KVM_CAP_ARM_VM_PHYS_SHIFT to this
   patch to allow detection of the availability of the feature for
   userspace.
 - Document the API
 - Restrict the feature only to arm64.
Changes since V3:
 - Switch to a CAP, that can be checkd via EXTENSIONS on KVM device
   fd, rather than a dedicated ioctl.
---
 Documentation/virtual/kvm/api.txt       |  8 ++++++++
 arch/arm64/include/asm/stage2_pgtable.h | 20 --------------------
 arch/arm64/kvm/reset.c                  | 20 ++++++++++++++++----
 include/uapi/linux/kvm.h                | 10 ++++++++++
 4 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index c664064f76fb..f860251ff27c 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -122,6 +122,14 @@ the default trap & emulate implementation (which changes the virtual
 memory layout to fit in user mode), check KVM_CAP_MIPS_VZ and use the
 flag KVM_VM_MIPS_VZ.
 
+To configure the physical address space size for a VM (IPA size) on arm64,
+check KVM_CAP_ARM_VM_PHYS_SHIFT (which returns the maximum limit for the
+IPA shift) and use KVM_VM_TYPE_ARM_PHYS_SHIFT(PHYS_SHIFT). Bits[7-0] of the
+machine type has been reserved for specifying the PHYS_SHIFT.
+The supported range is [32...IPA_LIMIT], where IPA_LIMIT could be
+identified by checking KVM_CAP_ARM_VM_PHYS_SHIFT. For backward compatibility
+a value of 0 selects 40bits.
+
 
 4.3 KVM_GET_MSR_INDEX_LIST, KVM_GET_MSR_FEATURE_INDEX_LIST
 
diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index 6a56fdff0823..0b339f5a4a7c 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -42,28 +42,8 @@
  * the range (IPA_SHIFT, IPA_SHIFT - 4).
  */
 #define stage2_pgtable_levels(ipa)	ARM64_HW_PGTABLE_LEVELS((ipa) - 4)
-#define STAGE2_PGTABLE_LEVELS		stage2_pgtable_levels(KVM_PHYS_SHIFT)
 #define kvm_stage2_levels(kvm)		VTCR_EL2_LVLS(kvm->arch.vtcr)
 
-/*
- * With all the supported VA_BITs and 40bit guest IPA, the following condition
- * is always true:
- *
- *       STAGE2_PGTABLE_LEVELS <= CONFIG_PGTABLE_LEVELS
- *
- * We base our stage-2 page table walker helpers on this assumption and
- * fall back to using the host version of the helper wherever possible.
- * i.e, if a particular level is not folded (e.g, PUD) at stage2, we fall back
- * to using the host version, since it is guaranteed it is not folded at host.
- *
- * If the condition breaks in the future, we can rearrange the host level
- * definitions and reuse them for stage2. Till then...
- */
-#if STAGE2_PGTABLE_LEVELS > CONFIG_PGTABLE_LEVELS
-#error "Unsupported combination of guest IPA and host VA_BITS."
-#endif
-
-
 /* stage2_pgdir_shift() is the size mapped by top-level stage2 entry for the VM */
 #define stage2_pgdir_shift(kvm)		pt_levels_pgdir_shift(kvm_stage2_levels(kvm))
 #define stage2_pgdir_size(kvm)		(1ULL << stage2_pgdir_shift(kvm))
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 0393bb974b23..c9640159e11f 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -89,6 +89,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_EVENTS:
 		r = 1;
 		break;
+	case KVM_CAP_ARM_VM_PHYS_SHIFT:
+		r = kvm_ipa_limit;
+		break;
 	default:
 		r = 0;
 	}
@@ -190,16 +193,25 @@ int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
 {
 	u64 vtcr = VTCR_EL2_FLAGS;
 	u64 parange;
-	u8 lvls;
+	u8 lvls, ipa_shift;
 
-	if (type)
+	if (type & ~KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK)
 		return -EINVAL;
 
+	ipa_shift = KVM_VM_TYPE_ARM_PHYS_SHIFT(type);
+	if (ipa_shift) {
+		if (ipa_shift > kvm_ipa_limit ||
+		    ipa_shift < 32)
+			return -EINVAL;
+	} else {
+		ipa_shift = KVM_PHYS_SHIFT;
+	}
+
 	/*
 	 * Use a minimum 2 level page table to prevent splitting
 	 * host PMD huge pages at stage2.
 	 */
-	lvls = stage2_pgtable_levels(KVM_PHYS_SHIFT);
+	lvls = stage2_pgtable_levels(ipa_shift);
 	if (lvls < 2)
 		lvls = 2;
 
@@ -221,7 +233,7 @@ int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
 		VTCR_EL2_VS_8BIT;
 
 	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
-	vtcr |= VTCR_EL2_T0SZ(KVM_PHYS_SHIFT);
+	vtcr |= VTCR_EL2_T0SZ(ipa_shift);
 
 	kvm->arch.vtcr = vtcr;
 	return 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 07548de5c988..2a6b29c446db 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -750,6 +750,15 @@ struct kvm_ppc_resize_hpt {
 
 #define KVM_S390_SIE_PAGE_OFFSET 1
 
+/*
+ * On arm64, machine type can be used to request the physical
+ * address size for the VM. Bits[7-0] has been reserved for the PA
+ * size shift (i.e, log2(PA_Size)). For backward compatibility,
+ * value 0 implies the default IPA size, 40bits.
+ */
+#define KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK	0xffULL
+#define KVM_VM_TYPE_ARM_PHYS_SHIFT(x)		\
+	((x) & KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK)
 /*
  * ioctls for /dev/kvm fds:
  */
@@ -952,6 +961,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_HPAGE_1M 156
 #define KVM_CAP_NESTED_STATE 157
 #define KVM_CAP_ARM_INJECT_SERROR_ESR 158
+#define KVM_CAP_ARM_VM_PHYS_SHIFT 159 /* returns maximum PA shift for a VM */
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.19.0
