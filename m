Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED465C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 02:49:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 305E661242
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 02:49:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 305E661242
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92FB04B6D3;
	Tue, 13 Apr 2021 22:49:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sRUVnNFsD5KJ; Tue, 13 Apr 2021 22:49:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5222E4B73A;
	Tue, 13 Apr 2021 22:49:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F27E4B72A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Apr 2021 22:49:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k6tS5D-qCb6O for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Apr 2021 22:49:02 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E21F4B6B6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Apr 2021 22:49:02 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FKn0Z05DMzpXFS;
 Wed, 14 Apr 2021 10:46:06 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 10:48:50 +0800
Subject: Re: [RFC PATCH v2 2/2] kvm/arm64: Try stage2 block mapping for host
 device MMIO
To: Marc Zyngier <maz@kernel.org>
References: <20210316134338.18052-1-zhukeqian1@huawei.com>
 <20210316134338.18052-3-zhukeqian1@huawei.com> <878s5up71v.wl-maz@kernel.org>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <a72d4b34-1088-70b8-2cf9-628119fbbb74@huawei.com>
Date: Wed, 14 Apr 2021 10:48:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <878s5up71v.wl-maz@kernel.org>
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, lushenming@huawei.com,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

I think I have fully tested this patch. The next step is to do some restriction on
HVA in vfio module, so we can build block mapping for it with a higher probability.

Is there anything to improve? If not, could you apply it? ^_^

Thanks,
Keqian

On 2021/4/7 21:18, Marc Zyngier wrote:
> On Tue, 16 Mar 2021 13:43:38 +0000,
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>
>> The MMIO region of a device maybe huge (GB level), try to use
>> block mapping in stage2 to speedup both map and unmap.
>>
>> Compared to normal memory mapping, we should consider two more
>> points when try block mapping for MMIO region:
>>
>> 1. For normal memory mapping, the PA(host physical address) and
>> HVA have same alignment within PUD_SIZE or PMD_SIZE when we use
>> the HVA to request hugepage, so we don't need to consider PA
>> alignment when verifing block mapping. But for device memory
>> mapping, the PA and HVA may have different alignment.
>>
>> 2. For normal memory mapping, we are sure hugepage size properly
>> fit into vma, so we don't check whether the mapping size exceeds
>> the boundary of vma. But for device memory mapping, we should pay
>> attention to this.
>>
>> This adds device_rough_page_shift() to check these two points when
>> selecting block mapping size.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>
>> Mainly for RFC, not fully tested. I will fully test it when the
>> code logic is well accepted.
>>
>> ---
>>  arch/arm64/kvm/mmu.c | 42 ++++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 38 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index c59af5ca01b0..224aa15eb4d9 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -624,6 +624,36 @@ static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
>>  	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
>>  }
>>  
>> +/*
>> + * Find a mapping size that properly insides the intersection of vma and
>> + * memslot. And hva and pa have the same alignment to this mapping size.
>> + * It's rough because there are still other restrictions, which will be
>> + * checked by the following fault_supports_stage2_huge_mapping().
> 
> I don't think these restrictions make complete sense to me. If this is
> a PFNMAP VMA, we should use the biggest mapping size that covers the
> VMA, and not more than the VMA.
> 
>> + */
>> +static short device_rough_page_shift(struct kvm_memory_slot *memslot,
>> +				     struct vm_area_struct *vma,
>> +				     unsigned long hva)
>> +{
>> +	size_t size = memslot->npages * PAGE_SIZE;
>> +	hva_t sec_start = max(memslot->userspace_addr, vma->vm_start);
>> +	hva_t sec_end = min(memslot->userspace_addr + size, vma->vm_end);
>> +	phys_addr_t pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
>> +
>> +#ifndef __PAGETABLE_PMD_FOLDED
>> +	if ((hva & (PUD_SIZE - 1)) == (pa & (PUD_SIZE - 1)) &&
>> +	    ALIGN_DOWN(hva, PUD_SIZE) >= sec_start &&
>> +	    ALIGN(hva, PUD_SIZE) <= sec_end)
>> +		return PUD_SHIFT;
>> +#endif
>> +
>> +	if ((hva & (PMD_SIZE - 1)) == (pa & (PMD_SIZE - 1)) &&
>> +	    ALIGN_DOWN(hva, PMD_SIZE) >= sec_start &&
>> +	    ALIGN(hva, PMD_SIZE) <= sec_end)
>> +		return PMD_SHIFT;
>> +
>> +	return PAGE_SHIFT;
>> +}
>> +
>>  static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>>  					       unsigned long hva,
>>  					       unsigned long map_size)
>> @@ -769,7 +799,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  		return -EFAULT;
>>  	}
>>  
>> -	/* Let's check if we will get back a huge page backed by hugetlbfs */
>> +	/*
>> +	 * Let's check if we will get back a huge page backed by hugetlbfs, or
>> +	 * get block mapping for device MMIO region.
>> +	 */
>>  	mmap_read_lock(current->mm);
>>  	vma = find_vma_intersection(current->mm, hva, hva + 1);
>>  	if (unlikely(!vma)) {
>> @@ -780,11 +813,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  
>>  	if (is_vm_hugetlb_page(vma))
>>  		vma_shift = huge_page_shift(hstate_vma(vma));
>> +	else if (vma->vm_flags & VM_PFNMAP)
>> +		vma_shift = device_rough_page_shift(memslot, vma, hva);
>>  	else
>>  		vma_shift = PAGE_SHIFT;
>>  
>> -	if (logging_active ||
>> -	    (vma->vm_flags & VM_PFNMAP)) {
>> +	if (logging_active) {
>>  		force_pte = true;
>>  		vma_shift = PAGE_SHIFT;
> 
> But why should we downgrade to page-size mappings if logging? This is
> a device, and you aren't moving the device around, are you? Or is your
> device actually memory with a device mapping that you are trying to
> migrate?
> 
>>  	}
>> @@ -855,7 +889,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  
>>  	if (kvm_is_device_pfn(pfn)) {
>>  		device = true;
>> -		force_pte = true;
>> +		force_pte = (vma_pagesize == PAGE_SIZE);
>>  	} else if (logging_active && !write_fault) {
>>  		/*
>>  		 * Only actually map the page as writable if this was a write
>> -- 
>> 2.19.1
>>
>>
> 
> Thanks,
> 
> 	M.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
