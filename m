From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v3 19/24] KVM: arm: Move detection of invalid VM type bits
 to generic code
Date: Tue, 11 Dec 2018 23:28:56 +0000
Message-ID: <1544570941-7377-20-git-send-email-Dave.Martin@arm.com>
References: <1544570941-7377-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5959D4A370
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2HaEEQ2qvQQq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 18:30:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1665B4A394
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:27 -0500 (EST)
In-Reply-To: <1544570941-7377-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently, the detection of invalid bits in the KVM_CREATE_VM type
argument is done in the kvm_arm_setup_stage2() backend.

In order to make it easier to add type flags with independent
meanings, this patch moves the logic for rejecting invalid bits to
kvm_arch_init_vm().  Backend functions are now responsible for
clearing bits they know about from type, so that if any remain
after all such functions are called, we know they are invalid.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Changes since RFC v2:

 * New patch.

   **Discussion required**

   This change facilitates the addition of special-purpose flags in the
   KVM_CREATE_VM type argument, which may be used to control API
   features at VM granularity.

   This is currently one of two main options I can see for
   controlling the sequencing of the KVM_ARM_VCPU_INIT ioctl, since
   KVM_CREATE_VCPU has no spare argument bits and there is no obvious
   place to hook in.  (The other, perhaps better option is to alter
   KVM_ARM_VCPU_INIT's behaviour with a feature flag in struct
   kvm_vcpu_init.)

   If API behaviour does not need to diverge before KVM_VCPU_INIT,
   then we can get away without this patch.

   The API presented in this series _does_ require divergence however:
   it requires KVM_ARM_SVE_CONFIG_SET before KVM_VCPU_INIT.

   It remains up for discussion whether this change is appropriate/
   needed.
---
 arch/arm/include/asm/kvm_host.h   | 6 +++---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/reset.c            | 8 +++-----
 virt/kvm/arm/arm.c                | 6 +++++-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 5ca5d9a..8d385ec 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -354,13 +354,13 @@ static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
-static inline int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
+static inline int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long *type)
 {
 	/*
 	 * On 32bit ARM, VMs get a static 40bit IPA stage2 setup,
-	 * so any non-zero value used as type is illegal.
+	 * so any non-zero value used in the IPA size field is illegal.
 	 */
-	if (type)
+	if (*type & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
 		return -EINVAL;
 	return 0;
 }
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f36cfc0..9fd8729 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -534,6 +534,6 @@ void kvm_set_ipa_limit(void);
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
-int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
+int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long *type);
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b72a3dd..9503fec 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -188,16 +188,14 @@ void kvm_set_ipa_limit(void)
  * all CPUs, as it is safe to run with or without the feature and
  * the bit is RES0 on CPUs that don't support it.
  */
-int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
+int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long *type)
 {
 	u64 vtcr = VTCR_EL2_FLAGS;
 	u32 parange, phys_shift;
 	u8 lvls;
 
-	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
-		return -EINVAL;
-
-	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
+	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(*type);
+	*type &= ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK;
 	if (phys_shift) {
 		if (phys_shift > kvm_ipa_limit ||
 		    phys_shift < 32)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 2377497..f7bf43a 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -120,10 +120,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret, cpu;
 
-	ret = kvm_arm_setup_stage2(kvm, type);
+	ret = kvm_arm_setup_stage2(kvm, &type);
 	if (ret)
 		return ret;
 
+	/* Fail if there are type bits that nobody understood: */
+	if (type)
+		return -EINVAL;
+
 	kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
 	if (!kvm->arch.last_vcpu_ran)
 		return -ENOMEM;
-- 
2.1.4
