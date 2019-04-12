From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 02/14] KVM: arm/arm64: Demote kvm_arm_init_arch_resources() to
 just set up SVE
Date: Fri, 12 Apr 2019 17:28:06 +0100
Message-ID: <1555086498-26691-3-git-send-email-Dave.Martin@arm.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA3E54A4B9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 12:29:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U1GTNYapJKDy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Apr 2019 12:29:11 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 349A44A4BC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 12:29:10 -0400 (EDT)
In-Reply-To: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
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

The introduction of kvm_arm_init_arch_resources() looks like
premature factoring, since nothing else uses this hook yet and it
is not clear what will use it in the future.

For now, let's not pretend that this is a general thing:

This patch simply renames the function to kvm_arm_init_sve(),
retaining the arm stub version under the new name.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 2 +-
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/reset.c            | 2 +-
 virt/kvm/arm/arm.c                | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index e80cfc1..d956273 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -54,7 +54,7 @@
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
-static inline int kvm_arm_init_arch_resources(void) { return 0; }
+static inline int kvm_arm_init_sve(void) { return 0; }
 
 u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
 int __attribute_const__ kvm_target_cpu(void);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9d57cf8..6adf08b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -59,7 +59,7 @@
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern unsigned int kvm_sve_max_vl;
-int kvm_arm_init_arch_resources(void);
+int kvm_arm_init_sve(void);
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f13378d..8847f38 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -110,7 +110,7 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 
 unsigned int kvm_sve_max_vl;
 
-int kvm_arm_init_arch_resources(void)
+int kvm_arm_init_sve(void)
 {
 	if (system_supports_sve()) {
 		kvm_sve_max_vl = sve_max_virtualisable_vl;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 9edbf0f..7039c99c 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1682,7 +1682,7 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		return err;
 
-	err = kvm_arm_init_arch_resources();
+	err = kvm_arm_init_sve();
 	if (err)
 		return err;
 
-- 
2.1.4
