From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 18/20] arm/arm64: KVM: Simplify __cpu_reset_hyp_mode
Date: Fri, 17 Feb 2017 15:44:27 +0000
Message-ID: <20170217154429.5000-19-marc.zyngier@arm.com>
References: <20170217154429.5000-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170217154429.5000-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

__cpu_reset_hyp_mode doesn't need to be passed any argument now,
as the hyp-stub implementations are self-contained.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 3 +--
 arch/arm/kvm/arm.c                | 3 +--
 arch/arm64/include/asm/kvm_host.h | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 1962c5086897..370d7c6d6e7a 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -274,8 +274,7 @@ static inline void __cpu_init_stage2(void)
 	kvm_call_hyp(__init_stage2_translation);
 }
 
-static inline void __cpu_reset_hyp_mode(unsigned long vector_ptr,
-					phys_addr_t phys_idmap_start)
+static inline void __cpu_reset_hyp_mode(void)
 {
 	extern void __hyp_reset_vectors(void);
 	__hyp_reset_vectors();
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9d7446456e0c..00b5205e8955 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1122,8 +1122,7 @@ static void cpu_hyp_reinit(void)
 static void cpu_hyp_reset(void)
 {
 	if (!is_kernel_in_hyp_mode())
-		__cpu_reset_hyp_mode(hyp_default_vectors,
-				     kvm_get_idmap_start());
+		__cpu_reset_hyp_mode();
 }
 
 static void _kvm_arch_hardware_enable(void *discard)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2e493e9a671e..8c8aae7cfe19 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -361,8 +361,7 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr);
 }
 
-static inline void __cpu_reset_hyp_mode(unsigned long vector_ptr,
-					phys_addr_t phys_idmap_start)
+static inline void __cpu_reset_hyp_mode(void)
 {
 	extern void __hyp_reset_vectors(void);
 	__hyp_reset_vectors();
-- 
2.11.0
