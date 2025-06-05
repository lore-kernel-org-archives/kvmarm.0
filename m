Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0792144B4
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749119606; cv=none; b=Lk93MfcMzUnLIqcg5AQY3LM8xakQRoOAHCojbTPsFOuw0vqtdw7uT8Vqwne5ldMZtmLM+8GNvDyImMLrDe2f3M6RNTqDan9o+RZ9iC+Y4ID/jXnYc6SnKsXuWgWqoODG1Pp7CnvtCn7vk0ObQuEhRZmJ55q61T8BWAAXJt9Tss0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749119606; c=relaxed/simple;
	bh=a22MTugVqXJqn2rVeTYu08Ru3J9spYEy5/2EYGhxPUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HTH/0STBoMCmQ14UWBGzjzZ+45ExccfQ5oJ2idchjg+Cl857foq3uGAAXVnUmLXc/YopZx1zeZor5kY61tvIbhrqcCJqOWyaOFQxrDms9eE6QiBXTxnBoOLy9g9vwHtsXI/pGNNNZl4iuElTUv9Ja1eTkhDwNYQ7hU6ldtmEyl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ntPV4JmZ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ntPV4JmZ"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-450cf0120cdso7892445e9.2
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749119603; x=1749724403; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CcvdK+kUqsSYXK1dvlLkx29YE1Y4FdRzYsL+M29q+YQ=;
        b=ntPV4JmZQpGi9QGs8x3jzuzlKD643e7MKgZZ35zzcGae5dTJx0bgYikLP4iuuFcIIQ
         pynGg2GoVdx8Lfocg5m/vE/WBRxo8kvAXwFeYSwUSj/4/MC9hHrxu1vLrKVaLaJBZ0Tk
         EByL8On3WCILoAdOla0ANySmg2pLsjzlQ/C8bwu072ePcYlgN5U3K7ZH3uyuLMVAaVGC
         rNiCry4wce4j8fa3Uk1Xl5LAejeghDSO8/63ULPnW2MPxQRXJ4XwqAv1oCXTMFywBm54
         GFJo1G+07q30f8vWCAK0de0+j6IAPVFENrMH/S/WchnM5Rhhpo8xUuKWsU2Rx2IHyv9v
         AN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749119603; x=1749724403;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CcvdK+kUqsSYXK1dvlLkx29YE1Y4FdRzYsL+M29q+YQ=;
        b=Y6QBd57SJkQsnVNAGgCvL0kBcnMVY+WNFZuiA/tcJLBrgUcSexcqnY7Khb6GBoOQjh
         62Y/d+cy/lkLVQTf8L1btq8CAY/WeZVLWfqTayPofmOT2IGs/9vz7uYW12gtLporZYYP
         iyFMZARblzbULIgrABst69GH2IprQkV+32d0/jriEJCdTDtMiFBiwkKh/VdC/PemOrco
         Zcfb+HPr2JnWHN1qXbBU+4hMw56svish+rM3Gt77vaRdMK3qHguk7ZM4DFdXn3PKNxzr
         pbQJsBHapntT/G4QBeOyzM+yLND3f2FUNxnawR4ML5ePC50Sx/SzqzDGx/4CNkEv0VFK
         lsYA==
X-Forwarded-Encrypted: i=1; AJvYcCWv91XhhOdaiJhDOSexmC1pV0+KPqkZKsthJyqk3QT5J4zzDfvyWypH4PIT5Bq2cZeQ4D9HNgA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxrJ21LuYKzn/UNnljcmyUmI9mSHlHyyV2P8rOZfC/c0ZnybgXG
	VJTCcQuG0CNsj3wav/WSgCZ47euRzODpCM+OqTZ9Fa0rwqtyRnkU7aolUViaJVwKuKM=
X-Gm-Gg: ASbGncsCcg07bqMzvQ/9fI9mb08ES5jgje40PWNbvz2XS6LPPuRiQRC70H13C49+JUk
	G6OPdebQFgpuhZVpEcsSnPAPU2WpV+v121pS1gvVI+A4kn+LUq3mw2T6yw+gEsivnqj3PxyPuvg
	j+1EqyRM05XnqGCOJTqgxMsCf6LRtPXhL3h6jZG0mYrg/zejUBZsYWbhXwgmqsXKWQvGLkKuc3k
	STUvHTccQhux1BkaZ7OrEnwXKTbHVb60GTvmS1QuusP6FC6ywbXzZe3Omo78/fHKPKBmxx/642B
	dg17KAHt+kO9vIE6yKkm6Kvd0TN41xdtd7feXIwzW467wUg/19ZSNVhq
X-Google-Smtp-Source: AGHT+IG/pYQASQpxqALpdTzyKn6tGv+QxqdbmbGFod1wFV2dwtYmyNkB99H/KuhQnFWYsX9U2WTL4A==
X-Received: by 2002:a05:600c:8112:b0:43d:1b95:6d0e with SMTP id 5b1f17b1804b1-451f0b3ce3fmr54377325e9.23.1749119603114;
        Thu, 05 Jun 2025 03:33:23 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe6ca08sm24967656f8f.33.2025.06.05.03.33.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jun 2025 03:33:22 -0700 (PDT)
Message-ID: <632eadac-e5fd-4e50-9ced-cd4f2b9e6c82@linaro.org>
Date: Thu, 5 Jun 2025 11:33:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] KVM: arm64: Add trap configs for PMSDSFR_EL1
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org>
 <20250529-james-perf-feat_spe_eft-v2-6-a01a9baad06a@linaro.org>
 <867c1ze4pg.wl-maz@kernel.org>
 <2fb1965b-bef9-4a8e-a1c7-c8a77d957b23@linaro.org>
 <87a56ned6r.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <87a56ned6r.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 04/06/2025 4:31 pm, Marc Zyngier wrote:
> On Tue, 03 Jun 2025 10:50:23 +0100,
> James Clark <james.clark@linaro.org> wrote:
>>
>>
>>
>> On 29/05/2025 5:56 pm, Marc Zyngier wrote:
>>> On Thu, 29 May 2025 12:30:27 +0100,
>>> James Clark <james.clark@linaro.org> wrote:
>>>>
>>>> SPE data source filtering (SPE_FEAT_FDS) adds a new register
>>>> PMSDSFR_EL1, add the trap configs for it.
>>>>
>>>> Signed-off-by: James Clark <james.clark@linaro.org>
>>>> ---
>>>>    arch/arm64/kvm/emulate-nested.c | 1 +
>>>>    arch/arm64/kvm/sys_regs.c       | 1 +
>>>>    2 files changed, 2 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
>>>> index 0fcfcc0478f9..05d3e6b93ae9 100644
>>>> --- a/arch/arm64/kvm/emulate-nested.c
>>>> +++ b/arch/arm64/kvm/emulate-nested.c
>>>> @@ -1169,6 +1169,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
>>>>    	SR_TRAP(SYS_PMSIRR_EL1,		CGT_MDCR_TPMS),
>>>>    	SR_TRAP(SYS_PMSLATFR_EL1,	CGT_MDCR_TPMS),
>>>>    	SR_TRAP(SYS_PMSNEVFR_EL1,	CGT_MDCR_TPMS),
>>>> +	SR_TRAP(SYS_PMSDSFR_EL1,	CGT_MDCR_TPMS),
>>>>    	SR_TRAP(SYS_TRFCR_EL1,		CGT_MDCR_TTRF),
>>>>    	SR_TRAP(SYS_TRBBASER_EL1,	CGT_MDCR_E2TB),
>>>>    	SR_TRAP(SYS_TRBLIMITR_EL1,	CGT_MDCR_E2TB),
>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>> index 5dde9285afc8..9f544ac7b5a6 100644
>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>> @@ -2956,6 +2956,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>>>>    	{ SYS_DESC(SYS_PMBLIMITR_EL1), undef_access },
>>>>    	{ SYS_DESC(SYS_PMBPTR_EL1), undef_access },
>>>>    	{ SYS_DESC(SYS_PMBSR_EL1), undef_access },
>>>> +	{ SYS_DESC(SYS_PMSDSFR_EL1), undef_access },
>>>
>>> PMSDSFR_EL1 has an offset in the VNCR page (0x858), and must be
>>> described as such. This is equally true for a bunch of other
>>> SPE-related registers, so you might as well fix those while you're at
>>> it.
>>>
>>> Thanks,
>>>
>>> 	M.
>>>
>>
>> I got a bit stuck with what that would look like with registers that
>> are only undef in case there was something that I missed, but do I
>> just document the offsets?
>>
>> +++ b/arch/arm64/include/asm/vncr_mapping.h
>> @@ -87,6 +87,8 @@
>>   #define VNCR_PMSICR_EL1         0x838
>>   #define VNCR_PMSIRR_EL1         0x840
>>   #define VNCR_PMSLATFR_EL1       0x848
>> +#define VNCR_PMSNEVFR_EL1       0x850
>> +#define VNCR_PMSDSFR_EL1        0x858
>>
> 
> This should be enough.
> 

Thanks, I'll resend with these added.

>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -596,6 +596,16 @@ enum vcpu_sysreg {
>>          VNCR(ICH_HCR_EL2),
>>          VNCR(ICH_VMCR_EL2),
>>
>> +       /* SPE Registers */
>> +       VNCR(PMBLIMITR_EL1),
>> +       VNCR(PMBPTR_EL1),
>> +       VNCR(PMBSR_EL1),
>> +       VNCR(PMSCR_EL1),
>> +       VNCR(PMSEVFR_EL1),
>> +       VNCR(PMSICR_EL1),
>> +       VNCR(PMSIRR_EL1),
>> +       VNCR(PMSLATFR_EL1),
> 
> I don't see a point in having those until we actually have SPE support
> for guests, if ever, as these will potentially increase the size of
> the vcpu sysreg array for no good reason.
> 
>> And then sys_reg_descs[] remain as "{ SYS_DESC(SYS_PMBLIMITR_EL1),
>> undef_access }," rather than EL2_REG_VNCR() because we don't actually
>> want to change to bad_vncr_trap()?
> 
> This seem OK for now. We may want to refine this in the future though,
> as these registers cannot trap when NV is enabled. Yes, this is a bug
> in the architecture.
> 
>> There are some other parts about fine grained traps and res0 bits for
>> NV, but they all already look to be setup correctly. Except
>> HDFGRTR2_EL2.nPMSDSFR_EL1, but it's inverted, none of the FGT2 traps
>> are configured currently and PMSDSFR_EL1 is already trapped by
>> MDCR_EL2 anyway.
> 
> Can you elaborate on that? We have:
> 
> 	SR_FGT(SYS_PMSDSFR_EL1,		HDFGRTR2, nPMSDSFR_EL1, 0),
> 
> which seems to match the spec.
> 
> We also have full support for FEAT_FGT2 already (even if we have no
> support for the stuff they trap).

Oh I think that was misleading, the version I was poking around on 
didn't have the FEAT_FGT2 stuff applied yet but I see it now. And yes, 
as you say, what's there matches the spec.

> 
> Thanks,
> 
> 	M.
> 

