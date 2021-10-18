Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586F5C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 17:26:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C1DD86103B
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 17:26:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C1DD86103B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EEC84B256;
	Mon, 18 Oct 2021 13:26:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SY1DJT7C1bD9; Mon, 18 Oct 2021 13:26:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1741E4B24B;
	Mon, 18 Oct 2021 13:26:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAAFB4B1F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 13:26:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qYdOIbet5rkI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 13:26:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46D8A4B1DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 13:26:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D48A82F;
 Mon, 18 Oct 2021 10:26:35 -0700 (PDT)
Received: from [10.1.196.28] (eglon.cambridge.arm.com [10.1.196.28])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 29CB73F694;
 Mon, 18 Oct 2021 10:26:35 -0700 (PDT)
Subject: Re: [RFC PATCH 1/7] KVM: arm64: Detect and enable PBHA for stage2
To: Marc Zyngier <maz@kernel.org>
References: <20211015161416.2196-1-james.morse@arm.com>
 <20211015161416.2196-2-james.morse@arm.com> <87ee8lumkc.wl-maz@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <6db32553-8343-2018-3f58-7dcd025d195e@arm.com>
Date: Mon, 18 Oct 2021 18:26:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <87ee8lumkc.wl-maz@kernel.org>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 16/10/2021 14:27, Marc Zyngier wrote:
> On Fri, 15 Oct 2021 17:14:10 +0100,
> James Morse <james.morse@arm.com> wrote:
>>
>> Page Based Hardware Attributes (PBHA, aka HPDS2) allow a page table entry
>> to specify up to four bits that can be used by the hardware for some
>> implementation defined purpose.
>>
>> This is a problem for KVM guests as the host may swap guest memory using
>> a different combination of PBHA bits than the guest used when writing the
>> data. Without knowing what the PBHA bits do, its not possible to know if
>> this will corrupt the guest's data.
>>
>> The arm-arm doesn't describe how the PBHA bits are combined between stage1
>> and stage2. Arm's Cortex CPUs appear to all do the same thing: stage2 wins.
>>
>> Enable PBHA for stage2, where the configured value is zero. This has no
>> effect if PBHA isn't in use. On Cortex cores that have the 'stage2 wins'
>> behaviour, this disables whatever the guest may be doing. For any other
>> core with a sensible combination policy, it should be harmless.

> So the other side of the above is whether it has the potential to be
> harmful on systems that combine PBHA bits differently. Specially if
> they use VTCR_EL2.PBHA bits as a indication that they can OR S1 and S2
> instead of a direct S2 override, thus letting the S1 bits that would
> otherwise not being conveyed outside of the core.

xor-ing them together would be more fun - and equally valid in this imp-def world!


> I guess we have no way to know until someone reports really bad memory
> corruption and loss of data. The architecture is totally broken here.

The alternative is to make this depend on the list of CPUs where we know the combining
behaviour. That isn't great either, as its an unmaintainable-and-outdated list of
all-cortex-cores.


>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index f8ceebe4982e..7bd90ea1c61f 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -540,6 +540,15 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
>>  	 */
>>  	vtcr |= VTCR_EL2_HA;
>>  
>> +	/*
>> +	 * Enable PBHA for stage2 on systems that support it. The configured
>> +	 * value will always be 0, which is defined as the safe default
>> +	 * setting. On Cortex cores, enabling PBHA for stage2 effectively
>> +	 * disables it for stage1.
>> +	 */
>> +	if (cpus_have_final_cap(ARM64_HAS_PBHA))
>> +		vtcr = FIELD_PREP(VTCR_EL2_PBHA_MASK, 0xf);

> Err... Surely you mean 'vtcr |= FIELD_PREP(...)' here, right?

Gah!. I'm off to the stationery cupboard for a brown paper bag....



Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
