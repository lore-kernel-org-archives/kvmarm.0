From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 19/22] arm/arm64: KVM: Use __hyp_reset_vectors() directly
Date: Thu, 23 Feb 2017 10:26:54 +0000
Message-ID: <20170223102657.23100-20-marc.zyngier@arm.com>
References: <20170223102657.23100-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B6E240DEB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Feb 2017 05:27:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dMEz1ZSbqrJM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Feb 2017 05:27:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 644F841002
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Feb 2017 05:27:01 -0500 (EST)
In-Reply-To: <20170223102657.23100-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

__cpu_reset_hyp_mode doesn't need to be passed any argument now,
as the hyp-stub implementations are self-contained, and is now
reduced to just calling __hyp_reset_vectors(). Let's drop the
wrapper and use the stub hypercall directly.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 6 ------
 arch/arm/kvm/arm.c                | 3 +--
 arch/arm64/include/asm/kvm_host.h | 6 ------
 3 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 42774c6f458d..435dc837e5b0 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -274,12 +274,6 @@ static inline void __cpu_init_stage2(void)
 	kvm_call_hyp(__init_stage2_translation);
 }
 
-static inline void __cpu_reset_hyp_mode(unsigned long vector_ptr,
-					phys_addr_t phys_idmap_start)
-{
-	__hyp_reset_vectors();
-}
-
 static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	return 0;
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9d7446456e0c..7c3abeb49554 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1122,8 +1122,7 @@ static void cpu_hyp_reinit(void)
 static void cpu_hyp_reset(void)
 {
 	if (!is_kernel_in_hyp_mode())
-		__cpu_reset_hyp_mode(hyp_default_vectors,
-				     kvm_get_idmap_start());
+		__hyp_reset_vectors();
 }
 
 static void _kvm_arch_hardware_enable(void *discard)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7076ecae2bf0..4bd242f11f1b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -361,12 +361,6 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr);
 }
 
-static inline void __cpu_reset_hyp_mode(unsigned long vector_ptr,
-					phys_addr_t phys_idmap_start)
-{
-	__hyp_reset_vectors();
-}
-
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
-- 
2.11.0
