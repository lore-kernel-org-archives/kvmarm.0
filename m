From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v4 20/25] KVM: arm/arm64: Add hook to finalize the vcpu
 configuration
Date: Thu, 17 Jan 2019 20:33:34 +0000
Message-ID: <1547757219-19439-21-git-send-email-Dave.Martin@arm.com>
References: <1547757219-19439-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A570B4A214
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jan 2019 15:35:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YZtLM20zzvMt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jan 2019 15:35:11 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FD3A4A36C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jan 2019 15:35:11 -0500 (EST)
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

Some aspects of vcpu configuration can't be completed inside
KVM_VCPU_INIT, but still change API behaviour visible to userspace.

Where such configuration choices affect the register list visible
to userspace, we will need to track whether we have made a
commitment to userspace regarding the list of vcpu registers.

This patch adds a new hook kvm_arm_vcpu_finalize() to capture this
commitment, along with a corresponding check
kvm_arm_vcpu_finalized().  We commit to the register list when
userspace reads it via KVM_GET_REG_LIST, or when the vcpu is fired
up via KVM_RUN.

kvm_arm_vcpu_finalize() is currently a no-op, but future patches
will amend this to handle SVE on arm64.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 4 ++++
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 virt/kvm/arm/arm.c                | 8 ++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index ca56537..ab7c76b 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -360,4 +360,8 @@ static inline int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
 	return 0;
 }
 
+/* Commit to the set of vcpu registers currently configured: */
+static inline int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu) { return 0; }
+#define kvm_arm_vcpu_finalized(vcpu) true
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 77b6f3e..55bf9d0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -539,4 +539,8 @@ void kvm_arch_free_vm(struct kvm *kvm);
 
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
 
+/* Commit to the set of vcpu registers currently configured: */
+static inline int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu) { return 0; }
+#define kvm_arm_vcpu_finalized(vcpu) true
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 9e350fd3..12f9dc2 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -560,6 +560,10 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (likely(vcpu->arch.has_run_once))
 		return 0;
 
+	ret = kvm_arm_vcpu_finalize(vcpu);
+	if (ret)
+		return ret;
+
 	vcpu->arch.has_run_once = true;
 
 	if (likely(irqchip_in_kernel(kvm))) {
@@ -1121,6 +1125,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (unlikely(!kvm_vcpu_initialized(vcpu)))
 			break;
 
+		r = kvm_arm_vcpu_finalize(vcpu);
+		if (r)
+			break;
+
 		r = -EFAULT;
 		if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
 			break;
-- 
2.1.4
