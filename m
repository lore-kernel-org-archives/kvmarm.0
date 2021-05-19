Return-Path: <SRS0=M1+/=KO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057A9C43460
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 09:32:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6FB156139A
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 09:32:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FB156139A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D442F4B427;
	Wed, 19 May 2021 05:32:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3F+m4WArniNg; Wed, 19 May 2021 05:32:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2AD4B5E0;
	Wed, 19 May 2021 05:32:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 308D24B5C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 05:32:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9JRT4Zo8qcWZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 May 2021 05:32:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51CE54B427
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 05:32:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9B69101E;
 Wed, 19 May 2021 02:32:05 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 402773F73D;
 Wed, 19 May 2021 02:32:03 -0700 (PDT)
Subject: Re: [PATCH v12 3/8] arm64: mte: Sync tags for pages where PTE is
 untagged
To: Marc Zyngier <maz@kernel.org>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-4-steven.price@arm.com> <87y2cdtk09.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <f3a3f560-4d2b-9cd3-bbf4-ea8135ab4d17@arm.com>
Date: Wed, 19 May 2021 10:32:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87y2cdtk09.wl-maz@kernel.org>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
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

On 17/05/2021 17:14, Marc Zyngier wrote:
> On Mon, 17 May 2021 13:32:34 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> A KVM guest could store tags in a page even if the VMM hasn't mapped
>> the page with PROT_MTE. So when restoring pages from swap we will
>> need to check to see if there are any saved tags even if !pte_tagged().
>>
>> However don't check pages for which pte_access_permitted() returns false
>> as these will not have been swapped out.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/include/asm/pgtable.h |  9 +++++++--
>>  arch/arm64/kernel/mte.c          | 16 ++++++++++++++--
>>  2 files changed, 21 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 0b10204e72fc..275178a810c1 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -314,8 +314,13 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
>>  	if (pte_present(pte) && pte_user_exec(pte) && !pte_special(pte))
>>  		__sync_icache_dcache(pte);
>>  
>> -	if (system_supports_mte() &&
>> -	    pte_present(pte) && pte_tagged(pte) && !pte_special(pte))
>> +	/*
>> +	 * If the PTE would provide user space access to the tags associated
>> +	 * with it then ensure that the MTE tags are synchronised.  Exec-only
>> +	 * mappings don't expose tags (instruction fetches don't check tags).
> 
> I'm not sure I understand this comment. Of course, execution doesn't
> match tags. But the memory could still have tags associated with
> it. Does this mean such a page would lose its tags is swapped out?

Hmm, I probably should have reread that - the context of the comment is
lost.

I added the comment when changing to pte_access_permitted(), and the
comment on pte_access_permitted() explains a potential gotcha:

 * p??_access_permitted() is true for valid user mappings (PTE_USER
 * bit set, subject to the write permission check). For execute-only
 * mappings, like PROT_EXEC with EPAN (both PTE_USER and PTE_UXN bits
 * not set) must return false. PROT_NONE mappings do not have the
 * PTE_VALID bit set.

So execute-only mappings return false even though that is effectively a
type of user access. However, because MTE checks are not performed by
the PE for instruction fetches this doesn't matter. I'll update the
comment, how about:

/*
 * If the PTE would provide user space access to the tags associated
 * with it then ensure that the MTE tags are synchronised.  Although
 * pte_access_permitted() returns false for exec only mappings, they
 * don't expose tags (instruction fetches don't check tags).
 */

Thanks,

Steve

> Thanks,
> 
> 	M.
> 
>> +	 */
>> +	if (system_supports_mte() && pte_present(pte) &&
>> +	    pte_access_permitted(pte, false) && !pte_special(pte))
>>  		mte_sync_tags(ptep, pte);
>>  
>>  	__check_racy_pte_update(mm, ptep, pte);
>> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
>> index c88e778c2fa9..a604818c52c1 100644
>> --- a/arch/arm64/kernel/mte.c
>> +++ b/arch/arm64/kernel/mte.c
>> @@ -33,11 +33,15 @@ DEFINE_STATIC_KEY_FALSE(mte_async_mode);
>>  EXPORT_SYMBOL_GPL(mte_async_mode);
>>  #endif
>>  
>> -static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap)
>> +static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap,
>> +			       bool pte_is_tagged)
>>  {
>>  	unsigned long flags;
>>  	pte_t old_pte = READ_ONCE(*ptep);
>>  
>> +	if (!is_swap_pte(old_pte) && !pte_is_tagged)
>> +		return;
>> +
>>  	spin_lock_irqsave(&tag_sync_lock, flags);
>>  
>>  	/* Recheck with the lock held */
>> @@ -53,6 +57,9 @@ static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap)
>>  		}
>>  	}
>>  
>> +	if (!pte_is_tagged)
>> +		goto out;
>> +
>>  	page_kasan_tag_reset(page);
>>  	/*
>>  	 * We need smp_wmb() in between setting the flags and clearing the
>> @@ -76,10 +83,15 @@ void mte_sync_tags(pte_t *ptep, pte_t pte)
>>  	bool check_swap = nr_pages == 1;
>>  	bool pte_is_tagged = pte_tagged(pte);
>>  
>> +	/* Early out if there's nothing to do */
>> +	if (!check_swap && !pte_is_tagged)
>> +		return;
>> +
>>  	/* if PG_mte_tagged is set, tags have already been initialised */
>>  	for (i = 0; i < nr_pages; i++, page++) {
>>  		if (!test_bit(PG_mte_tagged, &page->flags))
>> -			mte_sync_page_tags(page, ptep, check_swap);
>> +			mte_sync_page_tags(page, ptep, check_swap,
>> +					   pte_is_tagged);
>>  	}
>>  }
>>  
>> -- 
>> 2.20.1
>>
>>
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
