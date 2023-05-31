Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD7C3C0A5
	for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 20:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685564123;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wy2VTDOFfBFfIv996qVHfxz/WlxaTNdab27HpFP+20g=;
	b=i5OpERdMOP7PWEy7T8Z1zGtMKBfhdPaFqOa9U94b/vDkpAx5qbyRrDagfSvQTODwOys7XM
	KWbWUUyw0lMNlhTHrxDdD1V3xqX3x+5vw1L+pAxKvytunhqI21xHCFJaz5NBwffErYUpvG
	YtCnmaB5deknx5X2iYJvhiL6RY2T/0s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-zxJ7uJvOO3KQrB6JLhohYw-1; Wed, 31 May 2023 16:15:18 -0400
X-MC-Unique: zxJ7uJvOO3KQrB6JLhohYw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f6ffc45209so874425e9.0
        for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 13:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685564117; x=1688156117;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wy2VTDOFfBFfIv996qVHfxz/WlxaTNdab27HpFP+20g=;
        b=Dap9Fkx6yWZ/rDlj+25EYJiJ+1LRoBDXlopQQ0VWPXvOThuG64oSX9GvbZPvjJ6wyo
         0NuztVKEcnqCvslMh+4scPWoRY3oRivXmOPohhZxR3tg7fAftE9a2ZHexbKPOpJJt4qD
         4Nn0hEicPVBU9naK9Tv3NlOTxaw2fKQWCNeaC5Fq3nynSf4MCL7qU5aFNTcD8yTJXAKM
         p1w0qRwTtzT1ml2kduDM+cuhmxIxfXF7hOSFdGGHjGg9je3vfZXvoJapJab2Z0pbG4lU
         384IVbPJ2eOwUgQHscoysQ5koeW/vzAedgZTzaMEnslM+sCVOZOkU8Sl6j2FQk2hszei
         Y0qQ==
X-Gm-Message-State: AC+VfDy/NQ+8WsUvpdoNJndbIU42LAhAJAFLLCsTOq8S2oI4+HFIrT+U
	/+f3HvXnnFkIvLNnDyLhNrrDxwFJzbY/wLZ0LY7CrCy6jWWmZPBouLvwZqQSKzrJrOQxWpkrN5R
	9kKJHyDx1JNZWnzXo
X-Received: by 2002:a05:600c:4195:b0:3f7:1021:9312 with SMTP id p21-20020a05600c419500b003f710219312mr232731wmh.19.1685564117784;
        Wed, 31 May 2023 13:15:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4S13U+4ejs/ejiQ8pAkmUas8XkrMsPXuoBlFznJd8Pg9nDfoPXEOC2FYrrYcsFWmF6KTD4Xg==
X-Received: by 2002:a05:600c:4195:b0:3f7:1021:9312 with SMTP id p21-20020a05600c419500b003f710219312mr232724wmh.19.1685564117387;
        Wed, 31 May 2023 13:15:17 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id bg22-20020a05600c3c9600b003f4283f5c1bsm5701802wmb.2.2023.05.31.13.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 13:15:16 -0700 (PDT)
Message-ID: <b868258d-9467-be87-0e3a-db9fa322e117@redhat.com>
Date: Wed, 31 May 2023 22:15:15 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 4/6] arm: pmu: Fix chain counter
 enable/disable sequences
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
 oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <20230315110725.1215523-5-eric.auger@redhat.com>
 <ZEJq_XNHi8Mx3CBy@monolith.localdoman>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZEJq_XNHi8Mx3CBy@monolith.localdoman>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alexandru,

On 4/21/23 12:52, Alexandru Elisei wrote:
> Hi,
>
> On Wed, Mar 15, 2023 at 12:07:23PM +0100, Eric Auger wrote:
>> In some ARM ARM ddi0487 revisions it is said that
>> disabling/enabling a pair of counters that are paired
>> by a CHAIN event should follow a given sequence:
>>
>> Disable the low counter first, isb, disable the high counter
>> Enable the high counter first, isb, enable low counter
>>
>> This was the case in Fc. However this is not written anymore
>> in Ia revision.
>>
>> Introduce 2 helpers to execute those sequences and replace
>> the existing PMCNTENCLR/ENSET calls.
>>
>> Also fix 2 write_sysreg_s(0x0, PMCNTENSET_EL0) in subtest 5 & 6
>> and replace them by PMCNTENCLR writes since writing 0 in
>> PMCNTENSET_EL0 has no effect.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arm/pmu.c | 37 ++++++++++++++++++++++++++++---------
>>  1 file changed, 28 insertions(+), 9 deletions(-)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index dde399e2..af679667 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -730,6 +730,22 @@ static void test_chained_sw_incr(bool unused)
>>  		    read_regn_el0(pmevcntr, 0), \
>>  		    read_sysreg(pmovsclr_el0))
>>  
>> +static void enable_chain_counter(int even)
>> +{
>> +	write_sysreg_s(BIT(even), PMCNTENSET_EL0); /* Enable the high counter first */
>> +	isb();
>> +	write_sysreg_s(BIT(even + 1), PMCNTENSET_EL0); /* Enable the low counter */
>> +	isb();
>> +}
> In ARM DDI 0487F.b, at the bottom of page D7-2727:
>
> "When enabling a pair of counters that are paired by a CHAIN event,
> software must:
>
> 1. Enable the high counter, by setting PMCNTENCLR_EL0[n+1] to 0 and, if
> necessary, setting PMCR_EL0.E to 1.
> 2. Execute an ISB instruction, or perform another Context synchronization
> event.
> 3. Enable the low counter by setting PMCNTENCLR_EL0[n] to 0."
>
> Which matches the commit message, but not the code above. Am I
> misunderstanding what is the high and low counter? In the example from the
> Arm ARM, just before the snippet above, the odd numbered countered is
> called the high counter.
>
> CHAIN is also defined as:
>
> [..] the odd-numbered event counter n+1 increments when an event increments
> the preceding even-numbered counter n on the same PE and causes an unsigned
> overflow of bits [31:0] of event counter n.
>
> So it would make sense to enable the odd counter first, then the even, so
> no overflows are missed if the sequence was the other way around (even
> counter enabled; overflow missed because odd counter disabled; odd counter
> enabled).
>
> Same observation with disable_chain_counter().

yeah you're right, I mixed up. Comments were right but does not match
the code.
I corrected this.

As for Marc's comment that this is not documented anymore that's correct
and was mentionned in the commit msg. Introducing those helpers make the
code a little bit simpler and I guess that executing those 'arbitrary'
sequences cannot do any harm so I kept them.

>
>> +
>> +static void disable_chain_counter(int even)
>> +{
>> +	write_sysreg_s(BIT(even + 1), PMCNTENCLR_EL0); /* Disable the low counter first*/
>> +	isb();
>> +	write_sysreg_s(BIT(even), PMCNTENCLR_EL0); /* Disable the high counter */
>> +	isb();
>> +}
>> +
>>  static void test_chain_promotion(bool unused)
>>  {
>>  	uint32_t events[] = {MEM_ACCESS, CHAIN};
>> @@ -768,16 +784,17 @@ static void test_chain_promotion(bool unused)
>>  	/* 1st COUNT with CHAIN enabled, next COUNT with CHAIN disabled */
>>  	report_prefix_push("subtest3");
>>  	pmu_reset();
>> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
>> -	isb();
>> +	enable_chain_counter(0);
>>  	PRINT_REGS("init");
>>  
>>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 1st loop");
>>  
>>  	/* disable the CHAIN event */
>> -	write_sysreg_s(0x2, PMCNTENCLR_EL0);
>> +	disable_chain_counter(0);
>> +	write_sysreg_s(0x1, PMCNTENSET_EL0); /* Enable the low counter */
>> +	isb();
>>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 2d loop");
>>  	report(read_sysreg(pmovsclr_el0) == 0x1,
>> @@ -798,9 +815,11 @@ static void test_chain_promotion(bool unused)
>>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 1st loop");
>>  
>> -	/* enable the CHAIN event */
>> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
>> +	/* Disable the even counter and enable the chain counter */
>> +	write_sysreg_s(0x1, PMCNTENCLR_EL0); /* Disable the low counter first */
> The comment says disable the even counter, but the odd counter is disabled.
> Which Arm ARM refers to as the high counter. I'm properly confused about
> the naming.

fixed by using the 'low' terminology

Thanks

Eric
>
> Thanks,
> Alex
>
>>  	isb();
>> +	enable_chain_counter(0);
>> +
>>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  
>>  	PRINT_REGS("After 2d loop");
>> @@ -824,10 +843,10 @@ static void test_chain_promotion(bool unused)
>>  	PRINT_REGS("After 1st loop");
>>  
>>  	/* 0 becomes CHAINED */
>> -	write_sysreg_s(0x0, PMCNTENSET_EL0);
>> +	write_sysreg_s(0x3, PMCNTENCLR_EL0);
>>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  	write_regn_el0(pmevcntr, 1, 0x0);
>> +	enable_chain_counter(0);
>>  
>>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 2d loop");
>> @@ -843,13 +862,13 @@ static void test_chain_promotion(bool unused)
>>  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
>> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
>> +	enable_chain_counter(0);
>>  	PRINT_REGS("init");
>>  
>>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 1st loop");
>>  
>> -	write_sysreg_s(0x0, PMCNTENSET_EL0);
>> +	disable_chain_counter(0);
>>  	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  
>> -- 
>> 2.38.1
>>
>>

