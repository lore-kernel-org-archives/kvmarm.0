From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 02/28] ARM: KVM: Remove
 __kvm_hyp_code_start/__kvm_hyp_code_end
Date: Thu,  4 Feb 2016 11:00:19 +0000
Message-ID: <1454583645-10144-3-git-send-email-marc.zyngier@arm.com>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A15F841390
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 05:55:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fZojE8dBlzoW for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2016 05:55:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85C9D412F3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 05:55:25 -0500 (EST)
In-Reply-To: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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
index 6b76e01..fcf6c13 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1075,7 +1075,7 @@ static int init_hyp_mode(void)
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
