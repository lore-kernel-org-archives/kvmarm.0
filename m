From: Jia He <hejianet@gmail.com>
Subject: [PATCH v2 2/2] KVM: arm/arm64: harden unmap_stage2_ptes in case end is not PAGE_SIZE aligned
Date: Fri, 18 May 2018 17:27:10 +0800
Message-ID: <1526635630-18917-2-git-send-email-hejianet@gmail.com>
References: <1526635630-18917-1-git-send-email-hejianet@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526635630-18917-1-git-send-email-hejianet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Suzuki.Poulose@arm.com, linux-kernel@vger.kernel.org, Jia He <hejianet@gmail.com>, jia.he@hxt-semitech.com
List-Id: kvmarm@lists.cs.columbia.edu

If it passes addr=0x202920000,size=0xfe00 to unmap_stage2_range->
...->unmap_stage2_ptes, unmap_stage2_ptes will get addr=0x202920000,
end=0x20292fe00. After first while loop addr=0x202930000, end=0x20292fe00,
then addr!=end. Thus it will touch another pages by put_pages() in the
2nd loop.

This patch fixes it by hardening the break condition of while loop.

Signed-off-by: jia.he@hxt-semitech.com
---
v2: newly added

 virt/kvm/arm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 8dac311..45cd040 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -217,7 +217,7 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 
 			put_page(virt_to_page(pte));
 		}
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+	} while (pte++, addr += PAGE_SIZE, addr < end);
 
 	if (stage2_pte_table_empty(start_pte))
 		clear_stage2_pmd_entry(kvm, pmd, start_addr);
-- 
1.8.3.1
