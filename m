Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0157BC07E94
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 12:51:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 520606108D
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 12:51:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 520606108D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 996D84B0F6;
	Fri,  4 Jun 2021 08:51:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YQQ5Clqwvurs; Fri,  4 Jun 2021 08:51:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B082340821;
	Fri,  4 Jun 2021 08:51:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 293DD40821
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 08:51:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ttkM3YcxqtSm for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jun 2021 08:51:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92891406DD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 08:51:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB57D2B;
 Fri,  4 Jun 2021 05:51:41 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AA943F774;
 Fri,  4 Jun 2021 05:51:39 -0700 (PDT)
Subject: Re: [PATCH v13 4/8] KVM: arm64: Introduce MTE VM feature
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20210524104513.13258-1-steven.price@arm.com>
 <20210524104513.13258-5-steven.price@arm.com>
 <20210603160031.GE20338@arm.com>
 <a0810f3b-4f13-e8b5-7057-a9de1201887a@arm.com>
 <20210604113658.GD31173@arm.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <2265cbf6-d643-9122-79a8-90198ea16c64@arm.com>
Date: Fri, 4 Jun 2021 13:51:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210604113658.GD31173@arm.com>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 04/06/2021 12:36, Catalin Marinas wrote:
> On Fri, Jun 04, 2021 at 11:42:11AM +0100, Steven Price wrote:
>> On 03/06/2021 17:00, Catalin Marinas wrote:
>>> On Mon, May 24, 2021 at 11:45:09AM +0100, Steven Price wrote:
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index c5d1f3c87dbd..226035cf7d6c 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -822,6 +822,42 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>>>>  	return PAGE_SIZE;
>>>>  }
>>>>  
>>>> +static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
>>>> +			     unsigned long size)
>>>> +{
>>>> +	if (kvm_has_mte(kvm)) {
>>>> +		/*
>>>> +		 * The page will be mapped in stage 2 as Normal Cacheable, so
>>>> +		 * the VM will be able to see the page's tags and therefore
>>>> +		 * they must be initialised first. If PG_mte_tagged is set,
>>>> +		 * tags have already been initialised.
>>>> +		 * pfn_to_online_page() is used to reject ZONE_DEVICE pages
>>>> +		 * that may not support tags.
>>>> +		 */
>>>> +		unsigned long i, nr_pages = size >> PAGE_SHIFT;
>>>> +		struct page *page = pfn_to_online_page(pfn);
>>>> +
>>>> +		if (!page)
>>>> +			return -EFAULT;
>>>> +
>>>> +		for (i = 0; i < nr_pages; i++, page++) {
>>>> +			/*
>>>> +			 * There is a potential (but very unlikely) race
>>>> +			 * between two VMs which are sharing a physical page
>>>> +			 * entering this at the same time. However by splitting
>>>> +			 * the test/set the only risk is tags being overwritten
>>>> +			 * by the mte_clear_page_tags() call.
>>>> +			 */
>>>
>>> And I think the real risk here is when the page is writable by at least
>>> one of the VMs sharing the page. This excludes KSM, so it only leaves
>>> the MAP_SHARED mappings.
>>>
>>>> +			if (!test_bit(PG_mte_tagged, &page->flags)) {
>>>> +				mte_clear_page_tags(page_address(page));
>>>> +				set_bit(PG_mte_tagged, &page->flags);
>>>> +			}
>>>> +		}
>>>
>>> If we want to cover this race (I'd say in a separate patch), we can call
>>> mte_sync_page_tags(page, __pte(0), false, true) directly (hopefully I
>>> got the arguments right). We can avoid the big lock in most cases if
>>> kvm_arch_prepare_memory_region() sets a VM_MTE_RESET (tag clear etc.)
>>> and __alloc_zeroed_user_highpage() clears the tags on allocation (as we
>>> do for VM_MTE but the new flag would not affect the stage 1 VMM page
>>> attributes).
>>
>> To be honest I'm coming round to just exporting a
>> mte_prepare_page_tags() function which does the clear/set with the lock
>> held. I doubt it's such a performance critical path that it will cause
>> any noticeable issues. Then if we run into performance problems in the
>> future we can start experimenting with extra VM flags etc as necessary.
> 
> It works for me.
> 
>> And from your later email:
>>> Another idea: if VM_SHARED is found for any vma within a region in
>>> kvm_arch_prepare_memory_region(), we either prevent the enabling of MTE
>>> for the guest or reject the memory slot if MTE was already enabled.
>>>
>>> An alternative here would be to clear VM_MTE_ALLOWED so that any
>>> subsequent mprotect(PROT_MTE) in the VMM would fail in
>>> arch_validate_flags(). MTE would still be allowed in the guest but in
>>> the VMM for the guest memory regions. We can probably do this
>>> irrespective of VM_SHARED. Of course, the VMM can still mmap() the
>>> memory initially with PROT_MTE but that's not an issue IIRC, only the
>>> concurrent mprotect().
>>
>> This could work, but I worry that it's potential fragile. Also the rules
>> for what user space can do are not obvious and may be surprising. I'd
>> also want to look into the likes of mremap() to see how easy it would be
>> to ensure that we couldn't end up with VM_SHARED (or VM_MTE_ALLOWED)
>> memory sneaking into a memslot.
>>
>> Unless you think it's worth complicating the ABI in the hope of avoiding
>> the big lock overhead I think it's probably best to stick with the big
>> lock at least until we have more data on the overhead.
> 
> It's up to Marc but I think for now just make it safe and once we get
> our hands on hardware, we can assess the impact. For example, starting
> multiple VMs simultaneously will contend on such big lock but we have an
> option to optimise it by setting PG_mte_tagged on allocation via a new
> VM_* flag.
> 
> For my last suggestion above, changing the VMM ABI afterwards is a bit
> tricky, so we could state now that VM_SHARED and MTE are not allowed
> (though it needs a patch to enforce it). That's assuming that mprotect()
> in the VMM cannot race with the user_mem_abort() on another CPU which
> makes the lock necessary anyway.
> 
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>>>>  			  unsigned long fault_status)
>>>> @@ -971,8 +1007,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>  	if (writable)
>>>>  		prot |= KVM_PGTABLE_PROT_W;
>>>>  
>>>> -	if (fault_status != FSC_PERM && !device)
>>>> +	if (fault_status != FSC_PERM && !device) {
>>>> +		ret = sanitise_mte_tags(kvm, pfn, vma_pagesize);
>>>> +		if (ret)
>>>> +			goto out_unlock;
>>>
>>> Maybe it was discussed in a previous version, why do we need this in
>>> addition to kvm_set_spte_gfn()?
>>
>> kvm_set_spte_gfn() is only used for the MMU notifier path (e.g. if a
>> memslot is changed by the VMM). For the initial access we will normally
>> fault the page into stage 2 with user_mem_abort().
> 
> Right. Can we move the sanitise_mte_tags() call to
> kvm_pgtable_stage2_map() instead or we don't have the all the
> information needed?

I tried that before: kvm_pgtable_stage2_map() is shared with the
hypervisor so sadly we can't go poking around in the host as this breaks
on nVHE. I mentioned it in the v12 cover letter but it was in a wall of
text:

 * Move the code to sanitise tags out of user_mem_abort() into its own
   function. Also call this new function from kvm_set_spte_gfn() as that
   path was missing the sanitising.

   Originally I was going to move the code all the way down to
   kvm_pgtable_stage2_map(). Sadly as that also part of the EL2
   hypervisor this breaks nVHE as the code needs to perform actions in
   the host.

The only other option I could see would be to provide a wrapper for
kvm_pgtable_stage2_map() in mmu.c which could do the sanitising as
necessary. But considering we know the call site in
kvm_phys_addr_ioremap() doesn't need handling (PROT_DEVICE is always
specified) and there's only two more, it seemed easier just to add the
two calls necessary to the new sanitise_mte_tags().

We also have a direct pointer to 'kvm' this way which is much nicer than
pointer chasing it out of the kvm_pgtable structure.

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
