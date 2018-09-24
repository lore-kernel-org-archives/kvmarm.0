From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH 1/2] arm/arm64: KVM: rename function
 kvm_arch_dev_ioctl_check_extension()
Date: Mon, 24 Sep 2018 21:29:59 +0800
Message-ID: <20180924133000.10244-2-gengdongjiu@huawei.com>
References: <20180924133000.10244-1-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 814CA4A205
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Sep 2018 09:31:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Eq9kIqlOeELi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Sep 2018 09:31:09 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E01D4A230
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Sep 2018 09:31:09 -0400 (EDT)
In-Reply-To: <20180924133000.10244-1-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@arm.com, marc.zyngier@arm.com, james.morse@arm.com, drjones@redhat.com, peter.maydell@linaro.org, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc: gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Rename kvm_arch_dev_ioctl_check_extension() to
kvm_arch_vm_ioctl_check_extension(), because it does
not have any relationship with device.

Cc: James Morse <james.morse@arm.com> 
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
I remeber James also mentioned that rename this function.

---
 arch/arm/include/asm/kvm_host.h   | 2 +-
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/reset.c            | 4 ++--
 virt/kvm/arm/arm.c                | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 3ad482d..3ee29db 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -273,7 +273,7 @@ static inline void __cpu_init_stage2(void)
 	kvm_call_hyp(__init_stage2_translation);
 }
 
-static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
+static inline int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	return 0;
 }
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3d6d733..c20537f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -53,7 +53,7 @@
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
-int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
+int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
 
 struct kvm_arch {
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index e37c78b..fd37c53 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -55,12 +55,12 @@ static bool cpu_has_32bit_el1(void)
 }
 
 /**
- * kvm_arch_dev_ioctl_check_extension
+ * kvm_arch_vm_ioctl_check_extension
  *
  * We currently assume that the number of HW registers is uniform
  * across all CPUs (see cpuinfo_sanity_check).
  */
-int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
+int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index c92053b..40e79ea 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -240,7 +240,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = 1;
 		break;
 	default:
-		r = kvm_arch_dev_ioctl_check_extension(kvm, ext);
+		r = kvm_arch_vm_ioctl_check_extension(kvm, ext);
 		break;
 	}
 	return r;
-- 
1.9.1
