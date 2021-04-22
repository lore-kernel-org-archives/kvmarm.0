Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8242BC433ED
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 00:12:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E14D26144E
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 00:12:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E14D26144E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 693144B4DF;
	Wed, 21 Apr 2021 20:12:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V43tx553mdsn; Wed, 21 Apr 2021 20:12:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41E734B431;
	Wed, 21 Apr 2021 20:12:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1BC04B431
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 20:12:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2x6FbQBecciC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 20:12:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F6864B409
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 20:12:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619050327;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=M/J8IWhEGs6k/tx/BlrhqUV6+bSTGhNVblRiZYUIZ5M=;
 b=NQQYWMR0iOQ0q1yDXEz3xEMDAlLQv9cNxP8uJ0pHKKyova8G86IK2pi+PArg0cYN4ktort
 TqrtBvr0Zc+QfeNaNSaTwhlODgjM0tebV5pFHIXcnCMn/RcbWwlKVJoDDvZi/gEs0mdf2f
 /Ii4xwKo1SBVmlFwsKApYvHElvohsNw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-MmiDiyKwMmig7-nSkxAmyA-1; Wed, 21 Apr 2021 20:12:03 -0400
X-MC-Unique: MmiDiyKwMmig7-nSkxAmyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7542681746C;
 Thu, 22 Apr 2021 00:12:02 +0000 (UTC)
Received: from [10.64.54.94] (vpn2-54-94.bne.redhat.com [10.64.54.94])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 76F9060871;
 Thu, 22 Apr 2021 00:11:59 +0000 (UTC)
Subject: Re: [PATCH v4 1/2] kvm/arm64: Remove the creation time's mapping of
 MMIO regions
To: Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Santosh Shukla <sashukla@nvidia.com>
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-2-zhukeqian1@huawei.com>
 <ad39c796-2778-df26-b0c6-231e7626a747@redhat.com>
 <bd4d2cfc-37b9-f20a-5a5c-ed352d1a46dc@huawei.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <f13bfc39-bee6-4562-fefc-76051bbf9735@redhat.com>
Date: Thu, 22 Apr 2021 12:12:10 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <bd4d2cfc-37b9-f20a-5a5c-ed352d1a46dc@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

On 4/21/21 4:28 PM, Keqian Zhu wrote:
> On 2021/4/21 14:38, Gavin Shan wrote:
>> On 4/16/21 12:03 AM, Keqian Zhu wrote:
>>> The MMIO regions may be unmapped for many reasons and can be remapped
>>> by stage2 fault path. Map MMIO regions at creation time becomes a
>>> minor optimization and makes these two mapping path hard to sync.
>>>
>>> Remove the mapping code while keep the useful sanity check.
>>>
>>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>>> ---
>>>    arch/arm64/kvm/mmu.c | 38 +++-----------------------------------
>>>    1 file changed, 3 insertions(+), 35 deletions(-)
>>>
>>
>> After removing the logic to create stage2 mapping for VM_PFNMAP region,
>> I think the "do { } while" loop becomes unnecessary and can be dropped
>> completely. It means the only sanity check is to see if the memory slot
>> overflows IPA space or not. In that case, KVM_MR_FLAGS_ONLY can be
>> ignored because the memory slot's base address and length aren't changed
>> when we have KVM_MR_FLAGS_ONLY.
> Maybe not exactly. Here we do an important sanity check that we shouldn't
> log dirty for memslots with VM_PFNMAP.
> 

Yeah, Sorry that I missed that part. Something associated with Santosh's
patch. The flag can be not existing until the page fault happened on
the vma. In this case, the check could be not working properly.

   [PATCH] KVM: arm64: Correctly handle the mmio faulting

[...]

Thanks,
Gavin

>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 8711894db8c2..c59af5ca01b0 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -1301,7 +1301,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>>    {
>>>        hva_t hva = mem->userspace_addr;
>>>        hva_t reg_end = hva + mem->memory_size;
>>> -    bool writable = !(mem->flags & KVM_MEM_READONLY);
>>>        int ret = 0;
>>>          if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
>>> @@ -1318,8 +1317,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>>        mmap_read_lock(current->mm);
>>>        /*
>>>         * A memory region could potentially cover multiple VMAs, and any holes
>>> -     * between them, so iterate over all of them to find out if we can map
>>> -     * any of them right now.
>>> +     * between them, so iterate over all of them.
>>>         *
>>>         *     +--------------------------------------------+
>>>         * +---------------+----------------+   +----------------+
>>> @@ -1330,50 +1328,20 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>>         */
>>>        do {
>>>            struct vm_area_struct *vma = find_vma(current->mm, hva);
>>> -        hva_t vm_start, vm_end;
>>>              if (!vma || vma->vm_start >= reg_end)
>>>                break;
>>>    -        /*
>>> -         * Take the intersection of this VMA with the memory region
>>> -         */
>>> -        vm_start = max(hva, vma->vm_start);
>>> -        vm_end = min(reg_end, vma->vm_end);
>>> -
>>>            if (vma->vm_flags & VM_PFNMAP) {
>>> -            gpa_t gpa = mem->guest_phys_addr +
>>> -                    (vm_start - mem->userspace_addr);
>>> -            phys_addr_t pa;
>>> -
>>> -            pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
>>> -            pa += vm_start - vma->vm_start;
>>> -
>>>                /* IO region dirty page logging not allowed */
>>>                if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
>>>                    ret = -EINVAL;
>>> -                goto out;
>>> -            }
>>> -
>>> -            ret = kvm_phys_addr_ioremap(kvm, gpa, pa,
>>> -                            vm_end - vm_start,
>>> -                            writable);
>>> -            if (ret)
>>>                    break;
>>> +            }
>>>            }
>>> -        hva = vm_end;
>>> +        hva = min(reg_end, vma->vm_end);
>>>        } while (hva < reg_end);
>>>    -    if (change == KVM_MR_FLAGS_ONLY)
>>> -        goto out;
>>> -
>>> -    spin_lock(&kvm->mmu_lock);
>>> -    if (ret)
>>> -        unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
>>> -    else if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
>>> -        stage2_flush_memslot(kvm, memslot);
>>> -    spin_unlock(&kvm->mmu_lock);
>>> -out:
>>>        mmap_read_unlock(current->mm);
>>>        return ret;
>>>    }
>>>
>>
>> .
>>
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
