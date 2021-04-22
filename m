Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A637FC43460
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 00:25:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D906D61459
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 00:25:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D906D61459
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B7B24B325;
	Wed, 21 Apr 2021 20:25:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A1I-VITcel1E; Wed, 21 Apr 2021 20:25:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E232B4B4D5;
	Wed, 21 Apr 2021 20:25:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73F664B4AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 20:25:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6tkndAz+IJoX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 20:25:20 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C34B4B325
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 20:25:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619051120;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=iJ1/DVIqYO6+cVlh7hmQ/FIT2MrvC33b9kkUd/QtjuU=;
 b=MHQO9PMa8XAdmOUeDOp5mLhVCSfiNpS05Z8zMSr5yTUwP93D+Bvj3qT6DIQir3xJacBwVI
 w2Rv06XXqdleN692Nl1wGduE2czMnRwBjtJTbNWE+SczXn1hwkOJkaXwxkn3QbtF3lHU4y
 XzZ/c8C2hDYT5RNpA5qV6BNuG6pOLOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-fWoU0mMeMs2ncBbX-eb-jg-1; Wed, 21 Apr 2021 20:25:16 -0400
X-MC-Unique: fWoU0mMeMs2ncBbX-eb-jg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C05D801814;
 Thu, 22 Apr 2021 00:25:14 +0000 (UTC)
Received: from [10.64.54.94] (vpn2-54-94.bne.redhat.com [10.64.54.94])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 019EC5D769;
 Thu, 22 Apr 2021 00:25:11 +0000 (UTC)
Subject: Re: [PATCH v4 2/2] kvm/arm64: Try stage2 block mapping for host
 device MMIO
To: Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-3-zhukeqian1@huawei.com>
 <960e097d-818b-00bc-b2ee-0da17857f862@redhat.com>
 <105a403a-e48b-15bc-44ff-0ff34f7d2194@huawei.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <46606f3e-ef41-6520-6647-88c0f76a83e0@redhat.com>
Date: Thu, 22 Apr 2021 12:25:23 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <105a403a-e48b-15bc-44ff-0ff34f7d2194@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: Marc Zyngier <maz@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Keqian,

On 4/21/21 4:36 PM, Keqian Zhu wrote:
> On 2021/4/21 15:52, Gavin Shan wrote:
>> On 4/16/21 12:03 AM, Keqian Zhu wrote:
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
>>>    arch/arm64/kvm/mmu.c | 61 ++++++++++++++++++++++++++++++++++++--------
>>>    1 file changed, 51 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index c59af5ca01b0..5a1cc7751e6d 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -738,6 +738,35 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>>>        return PAGE_SIZE;
>>>    }
>>>    +static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
>>> +{
>>> +    unsigned long pa;
>>> +
>>> +    if (is_vm_hugetlb_page(vma) && !(vma->vm_flags & VM_PFNMAP))
>>> +        return huge_page_shift(hstate_vma(vma));
>>> +
>>> +    if (!(vma->vm_flags & VM_PFNMAP))
>>> +        return PAGE_SHIFT;
>>> +
>>> +    VM_BUG_ON(is_vm_hugetlb_page(vma));
>>> +
>>
>> I don't understand how VM_PFNMAP is set for hugetlbfs related vma.
>> I think they are exclusive, meaning the flag is never set for
>> hugetlbfs vma. If it's true, VM_PFNMAP needn't be checked on hugetlbfs
>> vma and the VM_BUG_ON() becomes unnecessary.
> Yes, but we're not sure all drivers follow this rule. Add a BUG_ON() is
> a way to catch issue.
> 

I think I didn't make things clear. What I meant is VM_PFNMAP can't
be set for hugetlbfs VMAs. So the checks here can be simplified as
below if you agree:

     if (is_vm_hugetlb_page(vma))
         return huge_page_shift(hstate_vma(vma));

     if (!(vma->vm_flags & VM_PFNMAP))
         return PAGE_SHIFT;

     VM_BUG_ON(is_vm_hugetlb_page(vma));       /* Can be dropped */

>>
>>> +    pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
>>> +
>>> +#ifndef __PAGETABLE_PMD_FOLDED
>>> +    if ((hva & (PUD_SIZE - 1)) == (pa & (PUD_SIZE - 1)) &&
>>> +        ALIGN_DOWN(hva, PUD_SIZE) >= vma->vm_start &&
>>> +        ALIGN(hva, PUD_SIZE) <= vma->vm_end)
>>> +        return PUD_SHIFT;
>>> +#endif
>>> +
>>> +    if ((hva & (PMD_SIZE - 1)) == (pa & (PMD_SIZE - 1)) &&
>>> +        ALIGN_DOWN(hva, PMD_SIZE) >= vma->vm_start &&
>>> +        ALIGN(hva, PMD_SIZE) <= vma->vm_end)
>>> +        return PMD_SHIFT;
>>> +
>>> +    return PAGE_SHIFT;
>>> +}
>>> +
>>
>> There is "switch(...)" fallback mechanism in user_mem_abort(). PUD_SIZE/PMD_SIZE
>> can be downgraded accordingly if the addresses fails in the alignment check
>> by fault_supports_stage2_huge_mapping(). I think it would make user_mem_abort()
>> simplified if the logic can be moved to get_vma_page_shift().
>>
>> Another question if we need the check from fault_supports_stage2_huge_mapping()
>> if VM_PFNMAP area is going to be covered by block mapping. If so, the "switch(...)"
>> fallback mechanism needs to be part of get_vma_page_shift().
> Yes, Good suggestion. My idea is that we can keep this series simpler and do further
> optimization in another patch series. Do you mind to send a patch?
> 

Yeah, It's fine to keep this series as of being. There are 3 checks applied
here for MMIO region: hva/hpa/ipa and they're distributed in two functions,
making the code a bit hard to follow. I can post patch to simplify it after
your series gets merged :)

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
