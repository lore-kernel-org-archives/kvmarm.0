Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3F7C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 10:46:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4777F64E1F
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 10:46:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4777F64E1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA2DA4B58E;
	Mon, 15 Mar 2021 06:46:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UqQV6h-jsfGT; Mon, 15 Mar 2021 06:46:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6D704B567;
	Mon, 15 Mar 2021 06:46:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 186514B4FB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 06:46:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QnUL-OT0+j7V for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 06:46:15 -0400 (EDT)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F9654B44D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 06:46:15 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DzY2D4q84z8xmQ;
 Mon, 15 Mar 2021 18:44:20 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 18:46:06 +0800
Subject: Re: [PATCH 4/4] KVM: arm64: Don't retrieve memory slot again in page
 fault handler
To: Gavin Shan <gshan@redhat.com>, <kvmarm@lists.cs.columbia.edu>
References: <20210315041844.64915-1-gshan@redhat.com>
 <20210315041844.64915-5-gshan@redhat.com>
 <30073114-339f-33dd-0168-b4d6bfbe88bc@huawei.com>
 <7a29ac43-ef11-e990-e08c-c5e97ea7d78d@redhat.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <b3a175ca-67a7-7371-44ac-e17c8616badc@huawei.com>
Date: Mon, 15 Mar 2021 18:46:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <7a29ac43-ef11-e990-e08c-c5e97ea7d78d@redhat.com>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org, will@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com
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

Hi Gavin,

On 2021/3/15 17:56, Gavin Shan wrote:
> Hi Keqian,
> 
> On 3/15/21 7:25 PM, Keqian Zhu wrote:
>> On 2021/3/15 12:18, Gavin Shan wrote:
>>> We needn't retrieve the memory slot again in user_mem_abort() because
>>> the corresponding memory slot has been passed from the caller. This
>> I think you are right, though fault_ipa will be adjusted when we try to use block mapping,
>> the fault_supports_stage2_huge_mapping() makes sure we're not trying to map anything
>> not covered by the memslot, so the adjusted fault_ipa still belongs to the memslot.
>>
> 
> Yeah, it's correct. Besides, the @logging_active is determined
> based on the passed memory slot. It means user_mem_abort() can't
> support memory range which spans multiple memory slot.
> 
>>> would save some CPU cycles. For example, the time used to write 1GB
>>> memory, which is backed by 2MB hugetlb pages and write-protected, is
>>> dropped by 6.8% from 928ms to 864ms.
>>>
>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>> ---
>>>   arch/arm64/kvm/mmu.c | 5 +++--
>>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index a5a8ade9fde4..4a4abcccfafb 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -846,7 +846,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>        */
>>>       smp_rmb();
>>>   -    pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
>>> +    pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
>>> +                   write_fault, &writable, NULL);
>> It's better to update the code comments at same time.
>>
> 
> I guess you need some comments here? If so, I would add something
> like below in v2:
> 
>     /*
>      * gfn_to_pfn_prot() can be used either with unnecessary overhead
>      * introduced to locate the memory slot because the memory slot is
>      * always fixed even @gfn is adjusted for huge pages.
>      */
Looks good.

See comments above "smp_rmb();", and actually my meaning is that we should change "gfn_to_pfn_prot"
to "__gfn_to_pfn_memslot" :)

Thanks,
Keqian

> 
>>>       if (pfn == KVM_PFN_ERR_HWPOISON) {
>>>           kvm_send_hwpoison_signal(hva, vma_shift);
>>>           return 0;
>>> @@ -912,7 +913,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>       /* Mark the page dirty only if the fault is handled successfully */
>>>       if (writable && !ret) {
>>>           kvm_set_pfn_dirty(pfn);
>>> -        mark_page_dirty(kvm, gfn);
>>> +        mark_page_dirty_in_slot(kvm, memslot, gfn);
>>>       }
>>>     out_unlock:
>>>
> 
> Thanks,
> Gavin
> 
> 
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
