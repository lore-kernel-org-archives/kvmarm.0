From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 21/27] KVM: arm/arm64: Add hook for arch-specific KVM
 initialisation
Date: Tue, 19 Mar 2019 17:52:12 +0000
Message-ID: <1553017938-710-22-git-send-email-Dave.Martin@arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F1144A4E0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:53:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NCzYN-Pb1ute for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Mar 2019 13:53:53 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A01D4A4B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:53:52 -0400 (EDT)
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

This patch adds a kvm_arm_init_arch_resources() hook to perform
subarch-specific initialisation when starting up KVM.

This will be used in a subsequent patch for global SVE-related
setup on arm64.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 2 ++
 arch/arm64/include/asm/kvm_host.h | 2 ++
 virt/kvm/arm/arm.c                | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 770d732..a49ee01 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -53,6 +53,8 @@
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
+static inline int kvm_arm_init_arch_resources(void) { return 0; }
+
 u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 205438a..3e89509 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -58,6 +58,8 @@
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
+static inline int kvm_arm_init_arch_resources(void) { return 0; }
+
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 99c3738..c69e137 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1664,6 +1664,10 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		return err;
 
+	err = kvm_arm_init_arch_resources();
+	if (err)
+		return err;
+
 	if (!in_hyp_mode) {
 		err = init_hyp_mode();
 		if (err)
-- 
2.1.4
