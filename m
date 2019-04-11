Return-Path: <SRS0=Fx/F=SN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B48C10F11
	for <kvmarm@archiver.kernel.org>; Thu, 11 Apr 2019 01:49:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE432217D4
	for <kvmarm@archiver.kernel.org>; Thu, 11 Apr 2019 01:49:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE432217D4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 433C94A4C1;
	Wed, 10 Apr 2019 21:49:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fTxaF2dj3ppA; Wed, 10 Apr 2019 21:49:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C2B54A475;
	Wed, 10 Apr 2019 21:49:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86E354A475
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 21:49:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bFj1NTdbY7vi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Apr 2019 21:49:33 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3232F4A420
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 21:49:33 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 47F8E66AB9F82B187527;
 Thu, 11 Apr 2019 09:49:30 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.408.0; Thu, 11 Apr 2019
 09:49:24 +0800
Subject: Re: [PATCH 1/2] kvm: arm: Clean up the checking for huge mapping
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 <linux-arm-kernel@lists.infradead.org>
References: <1554909297-6753-1-git-send-email-suzuki.poulose@arm.com>
 <1554909832-7169-1-git-send-email-suzuki.poulose@arm.com>
 <1554909832-7169-2-git-send-email-suzuki.poulose@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <529f8515-a069-948b-cb63-96fa35b291a6@huawei.com>
Date: Thu, 11 Apr 2019 09:48:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <1554909832-7169-2-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
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
Message-ID: <20190411014833.spv5inhDN_IWz6M_ZtPYmDyprhEDNFJSIP8qciDKRYU@z>


On 2019/4/10 23:23, Suzuki K Poulose wrote:
> If we are checking whether the stage2 can map PAGE_SIZE,
> we don't have to do the boundary checks as both the host
> VMA and the guest memslots are page aligned. Bail the case
> easily.
> 
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   virt/kvm/arm/mmu.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index a39dcfd..6d73322 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1624,6 +1624,10 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>   	hva_t uaddr_start, uaddr_end;
>   	size_t size;
>   
> +	/* The memslot and the VMA are guaranteed to be aligned to PAGE_SIZE */
> +	if (map_size == PAGE_SIZE)
> +		return true;
> +
>   	size = memslot->npages * PAGE_SIZE;
>   
>   	gpa_start = memslot->base_gfn << PAGE_SHIFT;
> 
We can do a comment clean up as well in this patch.

s/<< PAGE_SIZE/<< PAGE_SHIFT/


thanks,
zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
