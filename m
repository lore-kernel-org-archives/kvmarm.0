From: Peng Hao <peng.hao2@zte.com.cn>
Subject: [PATCH]  kvm/arm: return 0 when the number of objects is not less than min
Date: Wed, 5 Dec 2018 09:15:51 +0800
Message-ID: <1543972551-60951-1-git-send-email-peng.hao2@zte.com.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@arm.com, marc.zyngier@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Peng Hao <peng.hao2@zte.com.cn>
List-Id: kvmarm@lists.cs.columbia.edu

Return 0 when there is enough kvm_mmu_memory_cache object.

Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
---
 virt/kvm/arm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ed162a6..fcda0ce 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -127,7 +127,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 	while (cache->nobjs < max) {
 		page = (void *)__get_free_page(PGALLOC_GFP);
 		if (!page)
-			return -ENOMEM;
+			return cache->nobjs >= min ? 0 : -ENOMEM;
 		cache->objects[cache->nobjs++] = page;
 	}
 	return 0;
-- 
1.8.3.1
