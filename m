From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 06/29] kvm-arm: Remove kvm_pud_huge()
Date: Wed, 11 May 2016 15:29:59 +0200
Message-ID: <1462973422-10021-7-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22D6D49B60
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4UWSALUmjIiV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:29:00 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C4FE49B45
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:28:58 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id n129so219943347wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 06:31:56 -0700 (PDT)
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Get rid of kvm_pud_huge() which falls back to pud_huge. Use
pud_huge instead.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/kvm/mmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 7837f0a..d0c0ee9 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -45,8 +45,6 @@ static phys_addr_t hyp_idmap_vector;
 
 #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
 
-#define kvm_pud_huge(_x)	pud_huge(_x)
-
 #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
 #define KVM_S2_FLAG_LOGGING_ACTIVE	(1UL << 1)
 
@@ -1077,7 +1075,7 @@ static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
 		next = kvm_pud_addr_end(addr, end);
 		if (!pud_none(*pud)) {
 			/* TODO:PUD not supported, revisit later if supported */
-			BUG_ON(kvm_pud_huge(*pud));
+			BUG_ON(pud_huge(*pud));
 			stage2_wp_pmds(pud, addr, next);
 		}
 	} while (pud++, addr = next, addr != end);
-- 
2.1.2.330.g565301e.dirty
