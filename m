From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v4 22/25] KVM: arm64/sve: Allow userspace to enable SVE for
 vcpus
Date: Thu, 17 Jan 2019 20:33:36 +0000
Message-ID: <1547757219-19439-23-git-send-email-Dave.Martin@arm.com>
References: <1547757219-19439-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4B324A34E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jan 2019 15:35:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OkAQbU5ahZdA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jan 2019 15:35:15 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95BE44A3B7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jan 2019 15:35:15 -0500 (EST)
In-Reply-To: <1547757219-19439-1-git-send-email-Dave.Martin@arm.com>
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

Now that all the pieces are in place, this patch offers a new flag
KVM_ARM_VCPU_SVE that userspace can pass to KVM_ARM_VCPU_INIT to
turn on SVE for the guest, on a per-vcpu basis.

As part of this, support for initialisation and reset of the SVE
vector length set and registers is added in the appropriate places.
Allocation SVE registers is deferred until kvm_arm_vcpu_finalize(),
by which time the size of the registers is known.

Setting the vector lengths supported by the vcpu is considered
configuration of the emulated hardware rather than runtime
configuration, so no support is offered for changing the vector
lengths of an existing vcpu across reset.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 arch/arm64/kvm/reset.c            | 78 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 82a99f6..f77b780 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -45,7 +45,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 4
+#define KVM_VCPU_MAX_FEATURES 5
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 6dfbfa3..fc613af 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -102,6 +102,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
 #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
+#define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
 
 struct kvm_vcpu_init {
 	__u32 target;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 1379fb2..5ff2360 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -23,11 +23,13 @@
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/slab.h>
 
 #include <kvm/arm_arch_timer.h>
 
 #include <asm/cpufeature.h>
 #include <asm/cputype.h>
+#include <asm/fpsimd.h>
 #include <asm/ptrace.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
@@ -98,11 +100,77 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+static size_t vcpu_sve_state_size(struct kvm_vcpu *vcpu)
+{
+	if (WARN_ON(!sve_vl_valid(vcpu->arch.sve_max_vl)))
+		return 0;
+
+	return SVE_SIG_REGS_SIZE(sve_vq_from_vl(vcpu->arch.sve_max_vl));
+}
+
+static int kvm_reset_sve(struct kvm_vcpu *vcpu)
+{
+	unsigned int vq;
+
+	if (!system_supports_sve())
+		return -EINVAL;
+
+	/* If resetting an already-configured vcpu, just zero the SVE regs: */
+	if (vcpu->arch.sve_state) {
+		size_t size = vcpu_sve_state_size(vcpu);
+
+		if (!size)
+			return -EINVAL;
+
+		if (WARN_ON(!vcpu_has_sve(vcpu)))
+			return -EINVAL;
+
+		memset(vcpu->arch.sve_state, 0, size);
+		return 0;
+	}
+
+	if (WARN_ON(!sve_vl_valid(sve_max_vl)))
+		return -EINVAL;
+
+	/* If the full set of host vector lengths cannot be used, give up: */
+	if (sve_max_virtualisable_vl < sve_max_vl)
+		return -EINVAL;
+
+	/* Default to the set of vector lengths supported by the host */
+	vcpu->arch.sve_max_vl = sve_max_vl;
+	for (vq = SVE_VQ_MIN; vq <= sve_vq_from_vl(sve_max_vl); ++vq) {
+		unsigned int i = vq - SVE_VQ_MIN;
+
+		if (sve_vq_available(vq))
+			vcpu->arch.sve_vqs[i / 64] |= (u64)1 << (i % 64);
+	}
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
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu)
 {
 	if (likely(kvm_arm_vcpu_finalized(vcpu)))
 		return 0;
 
+	if (vcpu_has_sve(vcpu)) {
+		size_t size = vcpu_sve_state_size(vcpu);
+
+		if (!size)
+			return -EINVAL;
+
+		vcpu->arch.sve_state = kzalloc(size, GFP_KERNEL);
+		if (!vcpu->arch.sve_state)
+			return -ENOMEM;
+	}
+
 	vcpu->arch.flags |= KVM_ARM64_VCPU_FINALIZED;
 	return 0;
 }
@@ -113,12 +181,20 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu)
  *
  * This function finds the right table above and sets the registers on
  * the virtual CPU struct to their architecturally defined reset
- * values.
+ * values, except for registers whose reset is deferred until
+ * kvm_arm_vcpu_finalize().
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
+	int ret;
 	const struct kvm_regs *cpu_reset;
 
+	if (test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features)) {
+		ret = kvm_reset_sve(vcpu);
+		if (ret)
+			return ret;
+	}
+
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
-- 
2.1.4
