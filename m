Return-Path: <SRS0=JEd/=JO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07989C433ED
	for <kvmarm@archiver.kernel.org>; Sat, 17 Apr 2021 01:05:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4170F610FC
	for <kvmarm@archiver.kernel.org>; Sat, 17 Apr 2021 01:05:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4170F610FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2DC64B426;
	Fri, 16 Apr 2021 21:05:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hij0Bh3lRLRd; Fri, 16 Apr 2021 21:05:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0783C4B3C7;
	Fri, 16 Apr 2021 21:05:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 878E94B38B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Apr 2021 21:05:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RDQWnqBMTOvz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Apr 2021 21:05:17 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C4BA4B420
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Apr 2021 21:05:17 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FMZYP6ZQxzpZ7j;
 Sat, 17 Apr 2021 09:02:17 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Sat, 17 Apr 2021 09:05:05 +0800
Subject: Re: [PATCH v4 2/2] kvm/arm64: Try stage2 block mapping for host
 device MMIO
To: Marc Zyngier <maz@kernel.org>
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-3-zhukeqian1@huawei.com>
 <8f55b64f-b4dd-700e-c997-8de9c5ea282f@huawei.com>
 <87a6py2ss9.wl-maz@kernel.org>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <d8af7360-ee96-2344-336d-bfaf8828fc8e@huawei.com>
Date: Sat, 17 Apr 2021 09:05:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <87a6py2ss9.wl-maz@kernel.org>
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2021/4/16 22:44, Marc Zyngier wrote:
> On Thu, 15 Apr 2021 15:08:09 +0100,
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>
>> Hi Marc,
>>
>> On 2021/4/15 22:03, Keqian Zhu wrote:
>>> The MMIO region of a device maybe huge (GB level), try to use
>>> block mapping in stage2 to speedup both map and unmap.
>>>
>>> Compared to normal memory mapping, we should consider two more
>>> points when try block mapping for MMIO region:
>>>
>>> 1. For normal memory mapping, the PA(host physical address) and
>>> HVA have same alignment within PUD_SIZE or PMD_SIZE when we use
>>> the HVA to request hugepage, so we don't need to consider PA
>>> alignment when verifing block mapping. But for device memory
>>> mapping, the PA and HVA may have different alignment.
>>>
>>> 2. For normal memory mapping, we are sure hugepage size properly
>>> fit into vma, so we don't check whether the mapping size exceeds
>>> the boundary of vma. But for device memory mapping, we should pay
>>> attention to this.
>>>
>>> This adds get_vma_page_shift() to get page shift for both normal
>>> memory and device MMIO region, and check these two points when
>>> selecting block mapping size for MMIO region.
>>>
>>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>>> ---
>>>  arch/arm64/kvm/mmu.c | 61 ++++++++++++++++++++++++++++++++++++--------
>>>  1 file changed, 51 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index c59af5ca01b0..5a1cc7751e6d 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -738,6 +738,35 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>>>  	return PAGE_SIZE;
>>>  }
>>>  
[...]

>>> +	/*
>>> +	 * logging_active is guaranteed to never be true for VM_PFNMAP
>>> +	 * memslots.
>>> +	 */
>>> +	if (logging_active) {
>>>  		force_pte = true;
>>>  		vma_shift = PAGE_SHIFT;
>>> +	} else {
>>> +		vma_shift = get_vma_page_shift(vma, hva);
>>>  	}
>> I use a if/else manner in v4, please check that. Thanks very much!
> 
> That's fine. However, it is getting a bit late for 5.13, and we don't
> have much time to left it simmer in -next. I'll probably wait until
> after the merge window to pick it up.
OK, no problem. Thanks! :)

BRs,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
