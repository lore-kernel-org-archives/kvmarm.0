From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 01/23] arm/arm64: KVM: Add hook for C-based stage2 init
Date: Thu, 11 Feb 2016 18:39:42 +0000
Message-ID: <1455216004-19499-2-git-send-email-marc.zyngier@arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAEA749BE8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wrVBWwPunY63 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 13:34:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB23249BEA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:15 -0500 (EST)
In-Reply-To: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

As we're about to move the stage2 init to C code, introduce some
C hooks that will later be populated with arch-specific implementations.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 4 ++++
 arch/arm/kvm/arm.c                | 1 +
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 3 files changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index f9f2779..f1e86f1 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -220,6 +220,10 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
 	kvm_call_hyp((void*)hyp_stack_ptr, vector_ptr, pgd_ptr);
 }
 
+static inline void __cpu_init_stage2(void)
+{
+}
+
 static inline int kvm_arch_dev_ioctl_check_extension(long ext)
 {
 	return 0;
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index dda1959..6b76e01 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -985,6 +985,7 @@ static void cpu_init_hyp_mode(void *dummy)
 	vector_ptr = (unsigned long)__kvm_hyp_vector;
 
 	__cpu_init_hyp_mode(boot_pgd_ptr, pgd_ptr, hyp_stack_ptr, vector_ptr);
+	__cpu_init_stage2();
 
 	kvm_arm_init_debug();
 }
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 689d4c9..fe86cf9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -332,6 +332,10 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
 		     hyp_stack_ptr, vector_ptr);
 }
 
+static inline void __cpu_init_stage2(void)
+{
+}
+
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-- 
2.1.4
