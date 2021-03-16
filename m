Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 626F5C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 04:20:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C583D650EF
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 04:20:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C583D650EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 518254B4DB;
	Tue, 16 Mar 2021 00:20:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b+WlC7AaK-hm; Tue, 16 Mar 2021 00:20:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DA414B4EF;
	Tue, 16 Mar 2021 00:20:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E642C4B400
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 00:20:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pIcaT-glH0Or for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 00:20:25 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78AD54B39B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 00:20:25 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F00Qw4RtQzkZKl;
 Tue, 16 Mar 2021 12:18:48 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Tue, 16 Mar 2021 12:20:16 +0800
Subject: Re: [PATCH 2/4] KVM: arm64: Use find_vma_intersection()
To: Gavin Shan <gshan@redhat.com>, <kvmarm@lists.cs.columbia.edu>
References: <20210315041844.64915-1-gshan@redhat.com>
 <20210315041844.64915-3-gshan@redhat.com>
 <65dfdca3-af94-7d5a-86fe-24825301655b@huawei.com>
 <2eef2b42-13bd-2414-f748-551039677bf5@redhat.com>
 <d46320a2-7381-a46a-42e5-6bfa75321d31@redhat.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <05f08046-9c18-bbef-f502-47733000e9ff@huawei.com>
Date: Tue, 16 Mar 2021 12:20:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <d46320a2-7381-a46a-42e5-6bfa75321d31@redhat.com>
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

On 2021/3/16 11:52, Gavin Shan wrote:
> Hi Keqian,
> 
> On 3/15/21 8:42 PM, Gavin Shan wrote:
>> On 3/15/21 7:04 PM, Keqian Zhu wrote:
>>> On 2021/3/15 12:18, Gavin Shan wrote:
>>>> find_vma_intersection() has been existing to search the intersected
>>>> vma. This uses the function where it's applicable, to simplify the
>>>> code.
>>>>
>>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>>> ---
>>>>   arch/arm64/kvm/mmu.c | 10 ++++++----
>>>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index 84e70f953de6..286b603ed0d3 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -421,10 +421,11 @@ static void stage2_unmap_memslot(struct kvm *kvm,
>>>>        *     +--------------------------------------------+
>>>>        */
>>>>       do {
>>>> -        struct vm_area_struct *vma = find_vma(current->mm, hva);
>>>> +        struct vm_area_struct *vma;
>>>>           hva_t vm_start, vm_end;
>>>> -        if (!vma || vma->vm_start >= reg_end)
>>>> +        vma = find_vma_intersection(current->mm, hva, reg_end);
>>> Nit: Keep a same style may be better(Assign vma when declare it).
>>> Other looks good to me.
>>>
>>
>> Yeah, I agree. I will adjust the code in v2 and included your r-b.
>> Thanks for your time to review.
>>
> 
> After rechecking the code, I think it'd better to keep current style
> because there is a follow-on validation on @vma. Keeping them together
> seems a good idea. I think it wouldn't a big deal to you. So I will
> keep current style with your r-b in v2.
Sure, both is OK. ;-)

Thanks,
Keqian
> 
>     vma = find_vma_intersection(current->mm, hva, reg_end);
>         if (!vma)
>              break;
> Thanks,
> Gavin
>  
>>>> +        if (!vma)
>>>>               break;
>>>>           /*
>>>> @@ -1330,10 +1331,11 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>>>        *     +--------------------------------------------+
>>>>        */
>>>>       do {
>>>> -        struct vm_area_struct *vma = find_vma(current->mm, hva);
>>>> +        struct vm_area_struct *vma;
>>>>           hva_t vm_start, vm_end;
>>>> -        if (!vma || vma->vm_start >= reg_end)
>>>> +        vma = find_vma_intersection(current->mm, hva, reg_end);
>>>> +        if (!vma)
>>>>               break;
>>>>           /*
>>>>
>>>
>>
> 
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
