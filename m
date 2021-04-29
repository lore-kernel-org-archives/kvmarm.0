Return-Path: <SRS0=jtxo=J2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B0DC433ED
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 16:06:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 221D561469
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 16:06:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 221D561469
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78A8B4B363;
	Thu, 29 Apr 2021 12:06:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ypNjAezkVMzw; Thu, 29 Apr 2021 12:06:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B5634B36A;
	Thu, 29 Apr 2021 12:06:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A425C4B35C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 12:06:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uZl0fyT98ov9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Apr 2021 12:06:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C93604B338
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 12:06:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 288011FB;
 Thu, 29 Apr 2021 09:06:13 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DA9B3F70D;
 Thu, 29 Apr 2021 09:06:10 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v11 1/6] arm64: mte: Sync tags for pages where PTE is
 untagged
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20210416154309.22129-1-steven.price@arm.com>
 <20210416154309.22129-2-steven.price@arm.com>
 <20210427174357.GA17872@arm.com>
Message-ID: <0ab0017c-1eaf-201e-587f-101e03da6b80@arm.com>
Date: Thu, 29 Apr 2021 17:06:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210427174357.GA17872@arm.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 27/04/2021 18:43, Catalin Marinas wrote:
> On Fri, Apr 16, 2021 at 04:43:04PM +0100, Steven Price wrote:
>> A KVM guest could store tags in a page even if the VMM hasn't mapped
>> the page with PROT_MTE. So when restoring pages from swap we will
>> need to check to see if there are any saved tags even if !pte_tagged().
>>
>> However don't check pages which are !pte_valid_user() as these will
>> not have been swapped out.
> 
> You should remove the pte_valid_user() mention from the commit log as
> well.

Good spot - sorry about that. I really must get better at reading my own 
commit messages.

>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index e17b96d0e4b5..cf4b52a33b3c 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -312,7 +312,7 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
>>   		__sync_icache_dcache(pte);
>>   
>>   	if (system_supports_mte() &&
>> -	    pte_present(pte) && pte_tagged(pte) && !pte_special(pte))
>> +	    pte_present(pte) && (pte_val(pte) & PTE_USER) && !pte_special(pte))
> 
> I would add a pte_user() macro here or, if we restore the tags only when
> the page is readable, use pte_access_permitted(pte, false). Also add a
> comment why we do this.

pte_access_permitted() looks like it describes what we want (user space 
can access the memory). I'll add the following comment:

  /*
   * If the PTE would provide user space will access to the tags
   * associated with it then ensure that the MTE tags are synchronised.
   * Exec-only mappings don't expose tags (instruction fetches don't
   * check tags).
   */

> There's also the pte_user_exec() case which may not have the PTE_USER
> set (exec-only permission) but I don't think it matters. We don't do tag
> checking on instruction fetches, so if the user adds a PROT_READ to it,
> it would go through set_pte_at() again. I'm not sure KVM does anything
> special with exec-only mappings at stage 2, I suspect they won't be
> accessible by the guest (but needs checking).

It comes down to the behaviour of get_user_pages(). AFAICT that will 
fail if the memory is exec-only, so no stage 2 mapping will be created. 
Which of course means the guest can't do anything with that memory. That 
certainly seems like the only sane behaviour even without MTE.

>>   		mte_sync_tags(ptep, pte);
>>   
>>   	__check_racy_pte_update(mm, ptep, pte);
>> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
>> index b3c70a612c7a..e016ab57ea36 100644
>> --- a/arch/arm64/kernel/mte.c
>> +++ b/arch/arm64/kernel/mte.c
>> @@ -26,17 +26,23 @@ u64 gcr_kernel_excl __ro_after_init;
>>   
>>   static bool report_fault_once = true;
>>   
>> -static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap)
>> +static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap,
>> +			       bool pte_is_tagged)
>>   {
>>   	pte_t old_pte = READ_ONCE(*ptep);
>>   
>>   	if (check_swap && is_swap_pte(old_pte)) {
>>   		swp_entry_t entry = pte_to_swp_entry(old_pte);
>>   
>> -		if (!non_swap_entry(entry) && mte_restore_tags(entry, page))
>> +		if (!non_swap_entry(entry) && mte_restore_tags(entry, page)) {
>> +			set_bit(PG_mte_tagged, &page->flags);
>>   			return;
>> +		}
>>   	}
>>   
>> +	if (!pte_is_tagged || test_and_set_bit(PG_mte_tagged, &page->flags))
>> +		return;
> 
> I don't think we need another test_bit() here, it was done in the
> caller (bar potential races which need more thought).

Good point - I'll change that to a straight set_bit().

>> +
>>   	page_kasan_tag_reset(page);
>>   	/*
>>   	 * We need smp_wmb() in between setting the flags and clearing the
>> @@ -54,11 +60,13 @@ void mte_sync_tags(pte_t *ptep, pte_t pte)
>>   	struct page *page = pte_page(pte);
>>   	long i, nr_pages = compound_nr(page);
>>   	bool check_swap = nr_pages == 1;
>> +	bool pte_is_tagged = pte_tagged(pte);
>>   
>>   	/* if PG_mte_tagged is set, tags have already been initialised */
>>   	for (i = 0; i < nr_pages; i++, page++) {
>> -		if (!test_and_set_bit(PG_mte_tagged, &page->flags))
>> -			mte_sync_page_tags(page, ptep, check_swap);
>> +		if (!test_bit(PG_mte_tagged, &page->flags))
>> +			mte_sync_page_tags(page, ptep, check_swap,
>> +					   pte_is_tagged);
>>   	}
>>   }
> 
> You were right in the previous thread that if we have a race, it's
> already there even without your patches KVM patches.
> 
> If it's the same pte in a multithreaded app, we should be ok as the core
> code holds the ptl (the arch code also holds the mmap_lock during
> exception handling but only as a reader, so you can have multiple
> holders).
> 
> If there are multiple ptes to the same page, for example mapped with
> MAP_ANONYMOUS | MAP_SHARED, metadata recovery is done via
> arch_swap_restore() before we even set the pte and with the page locked.
> So calling lock_page() again in mte_restore_tags() would deadlock.
> 
> I can see that do_swap_page() also holds the page lock around
> set_pte_at(), so I think we are covered.
> 
> Any other scenario I may have missed? My understanding is that if the
> pte is the same, we have the ptl. Otherwise we have the page lock for
> shared pages.

That is my understanding - either the PTL is held or the page is locked. 
But I am aware I was partly basing that on an assumption that the 
existing code is correct. If there's a way that a new PTE can be created 
which races with the arch_swap_restore() path then there is a problem. 
I'm not aware of how that would happen though.

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
