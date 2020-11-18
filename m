Return-Path: <SRS0=VMV7=EY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B53C6369E
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 16:01:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3420247C4
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 16:01:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3420247C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63D454B9CE;
	Wed, 18 Nov 2020 11:01:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wL0WuaardYsv; Wed, 18 Nov 2020 11:01:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25C124B996;
	Wed, 18 Nov 2020 11:01:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 252254B4FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 11:01:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id esmHl0q+LF+a for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Nov 2020 11:01:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D01174B625
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 11:01:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AC33139F;
 Wed, 18 Nov 2020 08:01:28 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B25AA3F719;
 Wed, 18 Nov 2020 08:01:25 -0800 (PST)
Subject: Re: [PATCH v4 2/2] arm64: kvm: Introduce MTE VCPU feature
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20201026155727.36685-1-steven.price@arm.com>
 <20201026155727.36685-3-steven.price@arm.com> <X7P1VLZhBh045tsr@trantor>
From: Steven Price <steven.price@arm.com>
Message-ID: <f34b3d16-8bc7-af9d-c0e0-fb114d2465aa@arm.com>
Date: Wed, 18 Nov 2020 16:01:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <X7P1VLZhBh045tsr@trantor>
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

On 17/11/2020 16:07, Catalin Marinas wrote:
> Hi Steven,
> 
> On Mon, Oct 26, 2020 at 03:57:27PM +0000, Steven Price wrote:
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 19aacc7d64de..38fe25310ca1 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -862,6 +862,26 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	if (vma_pagesize == PAGE_SIZE && !force_pte)
>>   		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
>>   							   &pfn, &fault_ipa);
>> +
>> +	/*
>> +	 * The otherwise redundant test for system_supports_mte() allows the
>> +	 * code to be compiled out when CONFIG_ARM64_MTE is not present.
>> +	 */
>> +	if (system_supports_mte() && kvm->arch.mte_enabled && pfn_valid(pfn)) {
>> +		/*
>> +		 * VM will be able to see the page's tags, so we must ensure
>> +		 * they have been initialised.
>> +		 */
>> +		struct page *page = pfn_to_page(pfn);
>> +		long i, nr_pages = compound_nr(page);
>> +
>> +		/* if PG_mte_tagged is set, tags have already been initialised */
>> +		for (i = 0; i < nr_pages; i++, page++) {
>> +			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
>> +				mte_clear_page_tags(page_address(page));
>> +		}
>> +	}
> 
> If this page was swapped out and mapped back in, where does the
> restoring from swap happen?

Restoring from swap happens above this in the call to gfn_to_pfn_prot()

> I may have asked in the past, is user_mem_abort() the only path for
> mapping Normal pages into stage 2?
> 

That is my understanding (and yes you asked before) and no one has 
corrected me! ;)

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
