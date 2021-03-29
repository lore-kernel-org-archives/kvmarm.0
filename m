Return-Path: <SRS0=05AC=I3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AEEC433C1
	for <kvmarm@archiver.kernel.org>; Mon, 29 Mar 2021 15:55:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 784F66195B
	for <kvmarm@archiver.kernel.org>; Mon, 29 Mar 2021 15:55:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 784F66195B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF6A74B23E;
	Mon, 29 Mar 2021 11:55:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ujf6CnRwYZXv; Mon, 29 Mar 2021 11:55:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78E894B241;
	Mon, 29 Mar 2021 11:55:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7BED4B16D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Mar 2021 11:55:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S-cEhJ2sPAOh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Mar 2021 11:55:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 653B84B241
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Mar 2021 11:55:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0F36142F;
 Mon, 29 Mar 2021 08:55:30 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BAA313F719;
 Mon, 29 Mar 2021 08:55:27 -0700 (PDT)
Subject: Re: [PATCH v10 1/6] arm64: mte: Sync tags for pages where PTE is
 untagged
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20210312151902.17853-1-steven.price@arm.com>
 <20210312151902.17853-2-steven.price@arm.com> <20210326185653.GG5126@arm.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <21842e4d-7935-077c-3d6f-fced89b7f2bb@arm.com>
Date: Mon, 29 Mar 2021 16:55:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210326185653.GG5126@arm.com>
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

On 26/03/2021 18:56, Catalin Marinas wrote:
> Hi Steven,
> 
> On Fri, Mar 12, 2021 at 03:18:57PM +0000, Steven Price wrote:
>> A KVM guest could store tags in a page even if the VMM hasn't mapped
>> the page with PROT_MTE. So when restoring pages from swap we will
>> need to check to see if there are any saved tags even if !pte_tagged().
>>
>> However don't check pages which are !pte_valid_user() as these will
>> not have been swapped out.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h |  2 +-
>>   arch/arm64/kernel/mte.c          | 16 ++++++++++++----
>>   2 files changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index e17b96d0e4b5..84166625c989 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -312,7 +312,7 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
>>   		__sync_icache_dcache(pte);
>>   
>>   	if (system_supports_mte() &&
>> -	    pte_present(pte) && pte_tagged(pte) && !pte_special(pte))
>> +	    pte_present(pte) && pte_valid_user(pte) && !pte_special(pte))
>>   		mte_sync_tags(ptep, pte);
> 
> With the EPAN patches queued in for-next/epan, pte_valid_user()
> disappeared as its semantics weren't very clear.

Thanks for pointing that out.

> So this relies on the set_pte_at() being done on the VMM address space.
> I wonder, if the VMM did an mprotect(PROT_NONE), can the VM still access
> it via stage 2? If yes, the pte_valid_user() test wouldn't work. We need
> something like pte_present() && addr <= user_addr_max().

AFAIUI the stage 2 matches the VMM's address space (for the subset that 
has memslots). So mprotect(PROT_NONE) would cause the stage 2 mapping to 
be invalidated and a subsequent fault would exit to the VMM to sort out. 
This sort of thing is done for the lazy migration use case (i.e. pages 
are fetched as the VM tries to access them).

> BTW, ignoring virtualisation, can we ever bring a page in from swap on a
> PROT_NONE mapping (say fault-around)? It's not too bad if we keep the
> metadata around for when the pte becomes accessible but I suspect we
> remove it if the page is removed from swap.

There are two stages of bringing data from swap. First is populating the 
swap cache by doing the physical read from swap. The second is actually 
restoring the page table entries.

Clearly the first part can happen even with PROT_NONE (the simple case 
is there's another mapping which is !PROT_NONE).

For the second I'm a little hazy on exactly what happens when you do a 
'swapoff' - that may cause a page to be re-inserted into a page table 
without a fault. If you follow the chain down from try_to_unuse() you 
end up at a call to set_pte_at(). So we need set_pte_at() to handle a 
PROT_NONE mapping. So I guess the test we really want here is just 
(pte_val() & PTE_USER).

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
