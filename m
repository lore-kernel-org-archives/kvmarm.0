From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v2 20/23] KVM: arm64: Add arch vm ioctl hook
Date: Fri, 28 Sep 2018 14:39:24 +0100
Message-ID: <1538141967-15375-21-git-send-email-Dave.Martin@arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A4E04A2A2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YeFZaElzaLiy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Sep 2018 09:40:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CCEE4A20F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:55 -0400 (EDT)
In-Reply-To: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
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

To enable arm64-specific vm ioctls to be added cleanly, this patch
adds a kvm_arm_arch_vm_ioctl() hook so that these don't pollute the
common code.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 6 ++++++
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/guest.c            | 6 ++++++
 virt/kvm/arm/arm.c                | 2 +-
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index df2659d..0850fcd 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -285,6 +285,12 @@ static inline int kvm_arm_arch_vcpu_ioctl(struct vcpu *vcpu,
 	return -EINVAL;
 }
 
+static inline int kvm_arm_arch_vm_ioctl(struct kvm *kvm,
+	unsigned int ioctl, unsigned long arg)
+{
+	return -EINVAL;
+}
+
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5225485..ae25f14 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -63,6 +63,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
 int kvm_arm_arch_vcpu_ioctl(struct kvm_vcpu *vcpu,
 			    unsigned int ioctl, unsigned long arg);
+int kvm_arm_arch_vm_ioctl(struct kvm *kvm,
+			  unsigned int ioctl, unsigned long arg);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
 
 struct kvm_arch {
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index d96145a..f066b17 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -714,6 +714,12 @@ int kvm_arm_arch_vcpu_ioctl(struct kvm_vcpu *vcpu,
 	}
 }
 
+int kvm_arm_arch_vm_ioctl(struct kvm *kvm,
+			  unsigned int ioctl, unsigned long arg)
+{
+	return -EINVAL;
+}
+
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	return -EINVAL;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 6e894a8..6582a38 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1279,7 +1279,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		return 0;
 	}
 	default:
-		return -EINVAL;
+		return kvm_arm_arch_vm_ioctl(kvm, ioctl, arg);
 	}
 }
 
-- 
2.1.4
