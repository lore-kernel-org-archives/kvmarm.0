Return-Path: <SRS0=bsip=JS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C17C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 06:28:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B35861158
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 06:28:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B35861158
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E87204B4A9;
	Wed, 21 Apr 2021 02:28:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r7S6JAtiOwaT; Wed, 21 Apr 2021 02:28:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FE6A4B4AD;
	Wed, 21 Apr 2021 02:28:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE8EC4B4AB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 02:28:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3pe1WLMy1hKR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 02:28:17 -0400 (EDT)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A4004B4A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 02:28:17 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FQ9Xt2LtZz7wjD;
 Wed, 21 Apr 2021 14:25:50 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Wed, 21 Apr 2021 14:28:08 +0800
Subject: Re: [PATCH v4 1/2] kvm/arm64: Remove the creation time's mapping of
 MMIO regions
To: Gavin Shan <gshan@redhat.com>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-2-zhukeqian1@huawei.com>
 <ad39c796-2778-df26-b0c6-231e7626a747@redhat.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <bd4d2cfc-37b9-f20a-5a5c-ed352d1a46dc@huawei.com>
Date: Wed, 21 Apr 2021 14:28:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <ad39c796-2778-df26-b0c6-231e7626a747@redhat.com>
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
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

On 2021/4/21 14:38, Gavin Shan wrote:
> Hi Keqian,
> 
> On 4/16/21 12:03 AM, Keqian Zhu wrote:
>> The MMIO regions may be unmapped for many reasons and can be remapped
>> by stage2 fault path. Map MMIO regions at creation time becomes a
>> minor optimization and makes these two mapping path hard to sync.
>>
>> Remove the mapping code while keep the useful sanity check.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 38 +++-----------------------------------
>>   1 file changed, 3 insertions(+), 35 deletions(-)
>>
> 
> After removing the logic to create stage2 mapping for VM_PFNMAP region,
> I think the "do { } while" loop becomes unnecessary and can be dropped
> completely. It means the only sanity check is to see if the memory slot
> overflows IPA space or not. In that case, KVM_MR_FLAGS_ONLY can be
> ignored because the memory slot's base address and length aren't changed
> when we have KVM_MR_FLAGS_ONLY.
Maybe not exactly. Here we do an important sanity check that we shouldn't
log dirty for memslots with VM_PFNMAP.


> 
> It seems the patch isn't based on "next" branch because find_vma() was
> replaced by find_vma_intersection() by one of my patches :)
Yep, I remember it. I will replace it at next merge window...

Thanks,
Keqian

> 
> Thanks,
> Gavin
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 8711894db8c2..c59af5ca01b0 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1301,7 +1301,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>   {
>>       hva_t hva = mem->userspace_addr;
>>       hva_t reg_end = hva + mem->memory_size;
>> -    bool writable = !(mem->flags & KVM_MEM_READONLY);
>>       int ret = 0;
>>         if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
>> @@ -1318,8 +1317,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>       mmap_read_lock(current->mm);
>>       /*
>>        * A memory region could potentially cover multiple VMAs, and any holes
>> -     * between them, so iterate over all of them to find out if we can map
>> -     * any of them right now.
>> +     * between them, so iterate over all of them.
>>        *
>>        *     +--------------------------------------------+
>>        * +---------------+----------------+   +----------------+
>> @@ -1330,50 +1328,20 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>        */
>>       do {
>>           struct vm_area_struct *vma = find_vma(current->mm, hva);
>> -        hva_t vm_start, vm_end;
>>             if (!vma || vma->vm_start >= reg_end)
>>               break;
>>   -        /*
>> -         * Take the intersection of this VMA with the memory region
>> -         */
>> -        vm_start = max(hva, vma->vm_start);
>> -        vm_end = min(reg_end, vma->vm_end);
>> -
>>           if (vma->vm_flags & VM_PFNMAP) {
>> -            gpa_t gpa = mem->guest_phys_addr +
>> -                    (vm_start - mem->userspace_addr);
>> -            phys_addr_t pa;
>> -
>> -            pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
>> -            pa += vm_start - vma->vm_start;
>> -
>>               /* IO region dirty page logging not allowed */
>>               if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
>>                   ret = -EINVAL;
>> -                goto out;
>> -            }
>> -
>> -            ret = kvm_phys_addr_ioremap(kvm, gpa, pa,
>> -                            vm_end - vm_start,
>> -                            writable);
>> -            if (ret)
>>                   break;
>> +            }
>>           }
>> -        hva = vm_end;
>> +        hva = min(reg_end, vma->vm_end);
>>       } while (hva < reg_end);
>>   -    if (change == KVM_MR_FLAGS_ONLY)
>> -        goto out;
>> -
>> -    spin_lock(&kvm->mmu_lock);
>> -    if (ret)
>> -        unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
>> -    else if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
>> -        stage2_flush_memslot(kvm, memslot);
>> -    spin_unlock(&kvm->mmu_lock);
>> -out:
>>       mmap_read_unlock(current->mm);
>>       return ret;
>>   }
>>
> 
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
