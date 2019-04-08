Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6ADC282DD
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 03:53:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5CA9820880
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 03:53:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CA9820880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D21F34A484;
	Sun,  7 Apr 2019 23:53:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OjZ+4FHkj5OE; Sun,  7 Apr 2019 23:53:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A4E84A477;
	Sun,  7 Apr 2019 23:53:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CDFB4A474
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 23:53:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kKDknEN8AwkZ for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Apr 2019 23:53:45 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AED44A46F
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 23:53:45 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 12AFFC4684C4C3C99DD1;
 Mon,  8 Apr 2019 11:53:42 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.408.0; Mon, 8 Apr 2019
 11:53:32 +0800
Subject: Re: [PATCH] kvm: arm: Skip stage2 huge mappings for unaligned ipa
 backed by THP
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 <linux-arm-kernel@lists.infradead.org>
References: <1554203176-3958-1-git-send-email-suzuki.poulose@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <2ea55b9c-09da-c3d0-3616-aa6be85b5a46@huawei.com>
Date: Mon, 8 Apr 2019 11:50:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <1554203176-3958-1-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408035058.FNtK7xLKAuc7esrMaREu7KhJ-1Ps1Vy3EE-e4gP-nPs@z>



On 2019/4/2 19:06, Suzuki K Poulose wrote:
> With commit a80868f398554842b14, we no longer ensure that the
> THP page is properly aligned in the guest IPA. Skip the stage2
> huge mapping for unaligned IPA backed by transparent hugepages.
> 
> Fixes: a80868f398554842b14 ("KVM: arm/arm64: Enforce PTE mappings at stage2 when needed")
> Reported-by: Eric Auger <eric.auger@redhat.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Chirstoffer Dall <christoffer.dall@arm.com>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Zheng Xiang <zhengxiang9@huawei.com>
> Tested-by: Eric Auger <eric.auger@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Hi Suzuki,

Why not making use of fault_supports_stage2_huge_mapping()?  Let it do
some checks for us.

fault_supports_stage2_huge_mapping() was intended to do a *two-step*
check to tell us that can we create stage2 huge block mappings, and this
check is both for hugetlbfs and THP.  With commit a80868f398554842b14,
we pass PAGE_SIZE as "map_size" for normal size pages (which turned out
to be almost meaningless), and unfortunately the THP check no longer
works.

So we want to rework *THP* check process.  Your patch fixes the first
checking-step, but the second is still missed, am I wrong?

Can you please give a look at the below diff?


thanks,

zenghui

> ---
>   virt/kvm/arm/mmu.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 27c9583..4a22f5b 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1412,7 +1412,9 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
>   		 * page accordingly.
>   		 */
>   		mask = PTRS_PER_PMD - 1;
> -		VM_BUG_ON((gfn & mask) != (pfn & mask));
Somehow, I'd prefer keeping the VM_BUG_ON() here, let it report some
potential issues in the future (of course I hope none:) )
> +		/* Skip memslots with unaligned IPA and user address */
> +		if ((gfn & mask) != (pfn & mask))
> +			return false;
>   		if (pfn & mask) {
>   			*ipap &= PMD_MASK;
>   			kvm_release_pfn_clean(pfn);
> 

---8>---

Rework fault_supports_stage2_huge_mapping(), let it check THP again.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
  virt/kvm/arm/mmu.c | 11 ++++++++++-
  1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 27c9583..5e1b258 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1632,6 +1632,15 @@ static bool 
fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
  	uaddr_end = uaddr_start + size;

  	/*
+	 * If the memslot is _not_ backed by hugetlbfs, then check if it
+	 * can be backed by transparent hugepages.
+	 *
+	 * Currently only PMD_SIZE THPs are supported, revisit it later.
+	 */
+	if (map_size == PAGE_SIZE)
+		map_size = PMD_SIZE;
+
+	/*
  	 * Pages belonging to memslots that don't have the same alignment
  	 * within a PMD/PUD for userspace and IPA cannot be mapped with stage-2
  	 * PMD/PUD entries, because we'll end up mapping the wrong pages.
@@ -1643,7 +1652,7 @@ static bool 
fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
  	 *    |abcde|fgh  Stage-1 block  |    Stage-1 block tv|xyz|
  	 *    +-----+--------------------+--------------------+---+
  	 *
-	 *    memslot->base_gfn << PAGE_SIZE:
+	 *    memslot->base_gfn << PAGE_SHIFT:
  	 *      +---+--------------------+--------------------+-----+
  	 *      |abc|def  Stage-2 block  |    Stage-2 block   |tvxyz|
  	 *      +---+--------------------+--------------------+-----+
-- 



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
