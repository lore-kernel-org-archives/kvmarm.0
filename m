Return-Path: <SRS0=B0kT=CR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08119C43461
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 12:22:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D9E322204
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 12:22:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D9E322204
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80BA24B5CD;
	Tue,  8 Sep 2020 08:22:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tZgAP5ZoT708; Tue,  8 Sep 2020 08:22:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 537A44B5CE;
	Tue,  8 Sep 2020 08:22:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 139DC4B5C8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 08:22:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GS2tE5CEtskz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Sep 2020 08:22:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A49FB4B576
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 08:22:15 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 100E331B;
 Tue,  8 Sep 2020 05:22:15 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 408423F73C;
 Tue,  8 Sep 2020 05:22:14 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: arm64: Try PMD block mappings if PUD mappings
 are not supported
To: Marc Zyngier <maz@kernel.org>
References: <20200901133357.52640-1-alexandru.elisei@arm.com>
 <20200901133357.52640-3-alexandru.elisei@arm.com>
 <87sgbx7ti5.wl-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4002ad2c-59a2-00a6-2bb5-797cf62763c9@arm.com>
Date: Tue, 8 Sep 2020 13:23:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87sgbx7ti5.wl-maz@kernel.org>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 9/4/20 10:58 AM, Marc Zyngier wrote:
> Hi Alex,
>
> On Tue, 01 Sep 2020 14:33:57 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> When userspace uses hugetlbfs for the VM memory, user_mem_abort() tries to
>> use the same block size to map the faulting IPA in stage 2. If stage 2
>> cannot use the same size mapping because the block size doesn't fit in the
>> memslot or the memslot is not properly aligned, user_mem_abort() will fall
>> back to a page mapping, regardless of the block size. We can do better for
>> PUD backed hugetlbfs by checking if a PMD block mapping is possible before
>> deciding to use a page.
>>
>> vma_pagesize is an unsigned long, use 1UL instead of 1ULL when assigning
>> its value.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arch/arm64/kvm/mmu.c | 19 ++++++++++++++-----
>>  1 file changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 25e7dc52c086..f590f7355cda 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1871,15 +1871,24 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	else
>>  		vma_shift = PAGE_SHIFT;
>>  
>> -	vma_pagesize = 1ULL << vma_shift;
>>  	if (logging_active ||
>> -	    (vma->vm_flags & VM_PFNMAP) ||
>> -	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
>> +	    (vma->vm_flags & VM_PFNMAP)) {
>>  		force_pte = true;
>> -		vma_pagesize = PAGE_SIZE;
>>  		vma_shift = PAGE_SHIFT;
>>  	}
>>  
>> +	if (vma_shift == PUD_SHIFT &&
>> +	    !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
>> +		vma_shift = PMD_SHIFT;
>> +
>> +	if (vma_shift == PMD_SHIFT &&
>> +	    !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
>> +		force_pte = true;
>> +		vma_shift = PAGE_SHIFT;
>> +	}
>> +
>> +	vma_pagesize = 1UL << vma_shift;
>> +
>>  	/*
>>  	 * The stage2 has a minimum of 2 level table (For arm64 see
>>  	 * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
>> @@ -1889,7 +1898,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	 */
>>  	if (vma_pagesize == PMD_SIZE ||
>>  	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
>> -		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
>> +		gfn = (fault_ipa & ~(vma_pagesize - 1)) >> PAGE_SHIFT;
>>  	mmap_read_unlock(current->mm);
>>  
>>  	/* We need minimum second+third level pages */
> Although this looks like a sensible change, I'm a reluctant to take it
> at this stage, given that we already have a bunch of patches from Will
> to change the way we deal with PTs.
>
> Could you look into how this could fit into the new code instead?

Sure, that sounds very sensible. I'm in the process of reviewing Will's series,
and after I'm done I'll rebase this on top of his patches and send it as v2. Does
that sound ok to you? Or do you want me to base this patch on one of your branches?

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
