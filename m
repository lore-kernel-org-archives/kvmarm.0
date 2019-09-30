Return-Path: <SRS0=6KZ/=XZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34994C32792
	for <kvmarm@archiver.kernel.org>; Mon, 30 Sep 2019 15:10:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E159215EA
	for <kvmarm@archiver.kernel.org>; Mon, 30 Sep 2019 15:10:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E159215EA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F276A4A587;
	Mon, 30 Sep 2019 11:09:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9quJnTQFp-My; Mon, 30 Sep 2019 11:09:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C55144A6F6;
	Mon, 30 Sep 2019 11:09:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C98D04A6A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Sep 2019 11:09:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WieicZf+MllH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Sep 2019 11:09:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7555F4A587
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Sep 2019 11:09:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 289D728;
 Mon, 30 Sep 2019 08:09:56 -0700 (PDT)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 38C553F706;
 Mon, 30 Sep 2019 08:09:55 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 2/3] lib: arm/arm64: Add function to clear
 the PTE_USER bit
To: Andrew Jones <drjones@redhat.com>
References: <20190930142508.25102-1-alexandru.elisei@arm.com>
 <20190930142508.25102-3-alexandru.elisei@arm.com>
 <20190930145357.o7pq5ysttui2pjjm@kamzik.brq.redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a33705e8-fd12-86db-be64-dca9900a5555@arm.com>
Date: Mon, 30 Sep 2019 16:09:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190930145357.o7pq5ysttui2pjjm@kamzik.brq.redhat.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

Hi,

On 9/30/19 3:53 PM, Andrew Jones wrote:

> On Mon, Sep 30, 2019 at 03:25:07PM +0100, Alexandru Elisei wrote:
>> The PTE_USER bit (AP[1]) in a page entry means that lower privilege levels
>> (EL0, on arm64, or PL0, on arm) can read and write from that memory
>> location [1][2]. On arm64, it also implies PXN (Privileged execute-never)
>> when is set [3]. Add a function to clear the bit which we can use when we
>> want to execute code from that page or the prevent access from lower
>> exception levels.
>>
>> Make it available to arm too, in case someone needs it at some point.
>>
>> [1] ARM DDI 0406C.d, Table B3-6
>> [2] ARM DDI 0487E.a, table D5-28
>> [3] ARM DDI 0487E.a, table D5-33
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>   lib/arm/asm/mmu-api.h |  1 +
>>   lib/arm/mmu.c         | 15 +++++++++++++++
>>   2 files changed, 16 insertions(+)
>>
>> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
>> index df3ccf7bc7e0..8fe85ba31ec9 100644
>> --- a/lib/arm/asm/mmu-api.h
>> +++ b/lib/arm/asm/mmu-api.h
>> @@ -22,4 +22,5 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>>   extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
>>   			       phys_addr_t phys_start, phys_addr_t phys_end,
>>   			       pgprot_t prot);
>> +extern void mmu_clear_user(unsigned long vaddr);
>>   #endif
>> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
>> index 3d38c8397f5a..78db22e6af14 100644
>> --- a/lib/arm/mmu.c
>> +++ b/lib/arm/mmu.c
>> @@ -217,3 +217,18 @@ unsigned long __phys_to_virt(phys_addr_t addr)
>>   	assert(!mmu_enabled() || __virt_to_phys(addr) == addr);
>>   	return addr;
>>   }
>> +
>> +void mmu_clear_user(unsigned long vaddr)
>> +{
>> +	pgd_t *pgtable;
>> +	pteval_t *pte;
>> +
>> +	if (!mmu_enabled())
>> +		return;
>> +
>> +	pgtable = current_thread_info()->pgtable;
>> +	pte = get_pte(pgtable, vaddr);
>> +
>> +	*pte &= ~PTE_USER;
>> +	flush_tlb_page(vaddr);
>> +}
>> -- 
>> 2.20.1
>>
> This is fine, but I think you could just export get_pte() and then
> implement the PTE_USER clearing in the cache unit test instead. Anyway,

I thought about that, but I opted to make this a library function 
because I would like to modify it to also act on block mappings and use 
it in patch #4 from the EL2 series (the patch that adds the prefetch 
abort test), and send that change as part of the EL2 series. I am 
assuming that this patch set will get merged before the EL2 series.

>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
