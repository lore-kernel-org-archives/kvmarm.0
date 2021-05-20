Return-Path: <SRS0=DM5G=KP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5B0C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 13:03:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BEF8F61184
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 13:03:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEF8F61184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51CCE4B36F;
	Thu, 20 May 2021 09:03:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8OB3a8qN8AU6; Thu, 20 May 2021 09:03:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAFCF4B3C9;
	Thu, 20 May 2021 09:03:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA2834B373
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 09:03:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TYbBgNQcA9Qf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 May 2021 09:03:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 267C84B2F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 09:03:51 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A401011D4;
 Thu, 20 May 2021 06:03:50 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C6E2C3F73B;
 Thu, 20 May 2021 06:03:47 -0700 (PDT)
Subject: Re: [PATCH v12 3/8] arm64: mte: Sync tags for pages where PTE is
 untagged
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-4-steven.price@arm.com> <20210519180610.GE21619@arm.com>
 <3bac3a47-9f96-c7bf-e401-fdef60dcc9d8@arm.com>
 <20210520122550.GD12251@arm.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <85946169-3670-c33e-bd49-abd16dce3fa1@arm.com>
Date: Thu, 20 May 2021 14:03:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520122550.GD12251@arm.com>
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

On 20/05/2021 13:25, Catalin Marinas wrote:
> On Thu, May 20, 2021 at 12:55:21PM +0100, Steven Price wrote:
>> On 19/05/2021 19:06, Catalin Marinas wrote:
>>> On Mon, May 17, 2021 at 01:32:34PM +0100, Steven Price wrote:
>>>> A KVM guest could store tags in a page even if the VMM hasn't mapped
>>>> the page with PROT_MTE. So when restoring pages from swap we will
>>>> need to check to see if there are any saved tags even if !pte_tagged().
>>>>
>>>> However don't check pages for which pte_access_permitted() returns false
>>>> as these will not have been swapped out.
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>>  arch/arm64/include/asm/pgtable.h |  9 +++++++--
>>>>  arch/arm64/kernel/mte.c          | 16 ++++++++++++++--
>>>>  2 files changed, 21 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>>> index 0b10204e72fc..275178a810c1 100644
>>>> --- a/arch/arm64/include/asm/pgtable.h
>>>> +++ b/arch/arm64/include/asm/pgtable.h
>>>> @@ -314,8 +314,13 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
>>>>  	if (pte_present(pte) && pte_user_exec(pte) && !pte_special(pte))
>>>>  		__sync_icache_dcache(pte);
>>>>  
>>>> -	if (system_supports_mte() &&
>>>> -	    pte_present(pte) && pte_tagged(pte) && !pte_special(pte))
>>>> +	/*
>>>> +	 * If the PTE would provide user space access to the tags associated
>>>> +	 * with it then ensure that the MTE tags are synchronised.  Exec-only
>>>> +	 * mappings don't expose tags (instruction fetches don't check tags).
>>>> +	 */
>>>> +	if (system_supports_mte() && pte_present(pte) &&
>>>> +	    pte_access_permitted(pte, false) && !pte_special(pte))
>>>>  		mte_sync_tags(ptep, pte);
>>>
>>> Looking at the mte_sync_page_tags() logic, we bail out early if it's the
>>> old pte is not a swap one and the new pte is not tagged. So we only need
>>> to call mte_sync_tags() if it's a tagged new pte or the old one is swap.
>>> What about changing the set_pte_at() test to:
>>>
>>> 	if (system_supports_mte() && pte_present(pte) && !pte_special(pte) &&
>>> 	    (pte_tagged(pte) || is_swap_pte(READ_ONCE(*ptep))))
>>> 		mte_sync_tags(ptep, pte);
>>>
>>> We can even change mte_sync_tags() to take the old pte directly:
>>>
>>> 	if (system_supports_mte() && pte_present(pte) && !pte_special(pte)) {
>>> 		pte_t old_pte = READ_ONCE(*ptep);
>>> 		if (pte_tagged(pte) || is_swap_pte(old_pte))
>>> 			mte_sync_tags(old_pte, pte);
>>> 	}
>>>
>>> It would save a function call in most cases where the page is not
>>> tagged.
>>
>> Yes that looks like a good optimisation - although you've missed the
>> pte_access_permitted() part of the check ;)
> 
> I was actually wondering if we could remove it. I don't think it buys us
> much as we have a pte_present() check already, so we know it is pointing
> to a valid page. Currently we'd only get a tagged pte on user mappings,
> same with swap entries.

Actually the other way round makes more sense surely?
pte_access_permitted() is true if both PTE_VALID & PTE_USER are set.
pte_present() is true if *either* PTE_VALID or PTE_PROT_NONE are set. So
the pte_present() is actually redundant.

> When vmalloc kasan_hw will be added, I think we have a set_pte_at() with
> a tagged pte but init_mm and high address (we might as well add a
> warning if addr > TASK_SIZE_64 on the mte_sync_tags path so that we
> don't forget).

While we might not yet have tagged kernel pages - I'm not sure there's
much point weakening the check to have to then check addr as well in the
future.

>> The problem I hit is one of include dependencies:
>>
>> is_swap_pte() is defined (as a static inline) in
>> include/linux/swapops.h. However the definition depends on
>> pte_none()/pte_present() which are defined in pgtable.h - so there's a
>> circular dependency.
>>
>> Open coding is_swap_pte() in set_pte_at() works, but it's a bit ugly.
>> Any ideas on how to improve on the below?
>>
>> 	if (system_supports_mte() && pte_present(pte) &&
>> 	    pte_access_permitted(pte, false) && !pte_special(pte)) {
>> 		pte_t old_pte = READ_ONCE(*ptep);
>> 		/*
>> 		 * We only need to synchronise if the new PTE has tags enabled
>> 		 * or if swapping in (in which case another mapping may have
>> 		 * set tags in the past even if this PTE isn't tagged).
>> 		 * (!pte_none() && !pte_present()) is an open coded version of
>> 		 * is_swap_pte()
>> 		 */
>> 		if (pte_tagged(pte) || (!pte_none(pte) && !pte_present(pte)))
>> 			mte_sync_tags(old_pte, pte);
>> 	}
> 
> That's why I avoided testing my suggestion ;). I think we should just
> add !pte_none() in there with a comment that it may be a swap pte and
> use the is_swap_pte() again on the mte_sync_tags() path. We already have
> the pte_present() check.

Well of course I didn't test the above beyond building - and I've
screwed up because the open coded is_swap_pte() should have been called
on old_pte not pte!

So the pte_present() check above (which I've just removed...) is for the
*new* PTE. So I think we need to keep both here.

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
