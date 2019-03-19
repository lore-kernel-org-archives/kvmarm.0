From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 24/27] KVM: arm64/sve: Allow userspace to enable SVE for
 vcpus
Date: Tue, 19 Mar 2019 17:52:15 +0000
Message-ID: <1553017938-710-25-git-send-email-Dave.Martin@arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 369A94A46F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:54:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ux-J0ERKzZIv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Mar 2019 13:53:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD7D44A494
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:53:58 -0400 (EDT)
In-Reply-To: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Now that all the pieces are in place, this patch offers a new flag
KVM_ARM_VCPU_SVE that userspace can pass to KVM_ARM_VCPU_INIT to
turn on SVE for the guest, on a per-vcpu basis.

As part of this, support for initialisation and reset of the SVE
vector length set and registers is added in the appropriate places,
as well as finally setting the KVM_ARM64_GUEST_HAS_SVE vcpu flag,
to turn on the SVE support code.

Allocation of the SVE register storage in vcpu->arch.sve_state is
deferred until the SVE configuration is finalized, by which time
the size of the registers is known.

Setting the vector lengths supported by the vcpu is considered
configuration of the emulated hardware rather than runtime
configuration, so no support is offered for changing the vector
lengths available to an existing vcpu across reset.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Changes since v5:

 * Refactored to make the code flow clearer and clarify responsiblity
   for the various initialisation phases/checks.

   In place of the previous, confusingly dual-purpose kvm_reset_sve(),
   enabling and resetting of SVE are split into separate functions and
   called as appropriate from kvm_reset_vcpu().

   To avoid interactions with preempt_disable(), memory allocation is
   done in the kvm_vcpu_first_fun_init() path instead.  To achieve
   this, the SVE memory allocation is moved to kvm_arm_vcpu_finalize(),
   which now takes on the role of actually doing deferred setup instead
   of just setting a flag to indicate that the setup was done.

 * Add has_vhe() sanity-check into kvm_vcpu_enable_sve(), since it
   makes more sense here than when resetting the vcpu.

 * When checking for SVE finalization in kvm_reset_vcpu(), call the new
   SVE-specific function kvm_arm_vcpu_sve_finalized().  The new generic
   check kvm_arm_vcpu_is_finalized() is unnecessarily broad here: using
   the appropriate specific check makes the code more self-describing.

 * Definition of KVM_ARM_VCPU_SVE moved to KVM: arm64/sve: Add pseudo-
   register for the guest's vector lengths (which needs it for the
   KVM_ARM_VCPU_FINALIZE ioctl).
---
 arch/arm64/include/asm/kvm_host.h |  3 +--
 arch/arm64/kvm/reset.c            | 45 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5475cc4..9d57cf8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -49,8 +49,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-/* Will be incremented when KVM_ARM_VCPU_SVE is fully implemented: */
-#define KVM_VCPU_MAX_FEATURES 4
+#define KVM_VCPU_MAX_FEATURES 5
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index e7f9c06..4f04dbf 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -20,10 +20,12 @@
  */
 
 #include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/types.h>
 
 #include <kvm/arm_arch_timer.h>
@@ -37,6 +39,7 @@
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/virt.h>
 
 /* Maximum phys_shift supported for any VM on this host */
 static u32 kvm_ipa_limit;
@@ -130,6 +133,27 @@ int kvm_arm_init_arch_resources(void)
 	return 0;
 }
 
+static int kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
+{
+	if (!system_supports_sve())
+		return -EINVAL;
+
+	/* Verify that KVM startup enforced this when SVE was detected: */
+	if (WARN_ON(!has_vhe()))
+		return -EINVAL;
+
+	vcpu->arch.sve_max_vl = kvm_sve_max_vl;
+
+	/*
+	 * Userspace can still customize the vector lengths by writing
+	 * KVM_REG_ARM64_SVE_VLS.  Allocation is deferred until
+	 * kvm_arm_vcpu_finalize(), which freezes the configuration.
+	 */
+	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_SVE;
+
+	return 0;
+}
+
 /*
  * Finalize vcpu's maximum SVE vector length, allocating
  * vcpu->arch.sve_state as necessary.
@@ -188,13 +212,20 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 	kfree(vcpu->arch.sve_state);
 }
 
+static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_has_sve(vcpu))
+		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
+}
+
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
  *
  * This function finds the right table above and sets the registers on
  * the virtual CPU struct to their architecturally defined reset
- * values.
+ * values, except for registers whose reset is deferred until
+ * kvm_arm_vcpu_finalize().
  *
  * Note: This function can be called from two paths: The KVM_ARM_VCPU_INIT
  * ioctl or as part of handling a request issued by another VCPU in the PSCI
@@ -217,6 +248,18 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	if (loaded)
 		kvm_arch_vcpu_put(vcpu);
 
+	if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
+		/* KVM_ARM_VCPU_INIT: enable features needing deferred setup */
+		if (test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features)) {
+			ret = kvm_vcpu_enable_sve(vcpu);
+			if (ret)
+				goto out;
+		}
+	} else {
+		/* KVM_RUN: reset deferred features' state */
+		kvm_vcpu_reset_sve(vcpu);
+	}
+
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
-- 
2.1.4
