From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/27] ARM: KVM: Remove __kvm_hyp_code_start/__kvm_hyp_code_end
Date: Mon, 25 Jan 2016 16:38:18 +0000
Message-ID: <1453739923-17846-3-git-send-email-marc.zyngier@arm.com>
References: <1453739923-17846-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1453739923-17846-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that we've unified the way we refer to the HYP text between
arm and arm64, drop __kvm_hyp_code_start/end, and just use the
__hyp_text_start/end symbols.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_asm.h   | 3 ---
 arch/arm/kvm/arm.c               | 2 +-
 arch/arm64/include/asm/kvm_asm.h | 3 ---
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index fa2fd25..4841225 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -93,9 +93,6 @@ extern char __kvm_hyp_exit_end[];
 
 extern char __kvm_hyp_vector[];
 
-#define	__kvm_hyp_code_start	__hyp_text_start
-#define __kvm_hyp_code_end	__hyp_text_end
-
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index dda1959..0a26d20 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1074,7 +1074,7 @@ static int init_hyp_mode(void)
 	/*
 	 * Map the Hyp-code called directly from the host
 	 */
-	err = create_hyp_mappings(__kvm_hyp_code_start, __kvm_hyp_code_end);
+	err = create_hyp_mappings(__hyp_text_start, __hyp_text_end);
 	if (err) {
 		kvm_err("Cannot map world-switch code\n");
 		goto out_free_mappings;
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 52b777b..2ad8930 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -35,9 +35,6 @@ extern char __kvm_hyp_init_end[];
 
 extern char __kvm_hyp_vector[];
 
-#define	__kvm_hyp_code_start	__hyp_text_start
-#define	__kvm_hyp_code_end	__hyp_text_end
-
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
-- 
2.1.4

