Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0409D13FEC
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690564970;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IKJRceVcUKrNQDrK7aoEas9zsEEXxPktnwifXagrkq4=;
	b=d4M6Wg2sszdT0YKWyS4DiPDZpTatmIB8jeKFkMEs2l+EyQ9ONhuXbTuPjg5U4lAISyMtul
	Kw8ZbZIadytlssjvswCo2FSlb6CW69axKt5FuCjsPqORHgD4wbTv1HK17f2h0fFcgxTI8t
	VbTHhTdDKlAOumq4pfoWeZDWaK7YUAI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-YTPVcL-GOwKzPhPI4r6D3w-1; Fri, 28 Jul 2023 13:22:49 -0400
X-MC-Unique: YTPVcL-GOwKzPhPI4r6D3w-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3178e3f46b1so342698f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 10:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690564968; x=1691169768;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IKJRceVcUKrNQDrK7aoEas9zsEEXxPktnwifXagrkq4=;
        b=ODdMx3QKvt+14Xyxm0q3s4OxLvIKUxn0J2XZNRkVN6fe8lpy9a5+QX0HHZD+5kgKup
         zPyBbWLR++5G37mG5X/pex+TvIQsbRtInI1uBJQSH9PvOglo4j5QPThhudLa4mkPwRjW
         pZp2UiUnSWxIxNxPFnEYbZ10mo3XYdvY5HvKsj/weRk/Z6GSlpGfJ5CkFD/Jt1ootAKw
         Y9qac1+AbzAzThXIMupKglNDXqs//D992tIpHnMKBNEwxaY5B024CLx+khF2CdEK+RMU
         w57tca2USTm3+cY7BjGM0RIiTGTNvtuNFnnZtVpdtkl5zJXWEL5vGkP+Kf4c8i+zHNyd
         WLnQ==
X-Gm-Message-State: ABy/qLaWbR+X8gsGXJWJaUCvo+9kyTY/0FFS8jQDNK4OTN+/4E0f7Zbn
	NXfpEptzYbR7uI7fp2G0Ws5ngymkQONidfTTYb1WbkqbK7LTbta+ow7YLk9C6hWb2hgyFS7ckXF
	Js9SAE9/61C7+0Vw+
X-Received: by 2002:a05:6000:cd:b0:313:f399:6cea with SMTP id q13-20020a05600000cd00b00313f3996ceamr2397519wrx.4.1690564968179;
        Fri, 28 Jul 2023 10:22:48 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFfjDcEL2bxwzWB0WuuKEw2SMYRtpbPpJIjJe51Xa171Bn6C8SOHMg3uxabkTC9j/2+shDEdA==
X-Received: by 2002:a05:6000:cd:b0:313:f399:6cea with SMTP id q13-20020a05600000cd00b00313f3996ceamr2397500wrx.4.1690564967791;
        Fri, 28 Jul 2023 10:22:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id r5-20020a056000014500b00314367cf43asm5244845wrx.106.2023.07.28.10.22.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jul 2023 10:22:46 -0700 (PDT)
Message-ID: <33b99895-8727-756f-549b-3ee6b751b691@redhat.com>
Date: Fri, 28 Jul 2023 19:22:45 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 14/27] KVM: arm64: Restructure FGT register switching
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-15-maz@kernel.org>
 <fd0d93ae-1ae5-b53e-ccb7-04d78f7c31d9@redhat.com>
 <87y1j3qgpu.wl-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <87y1j3qgpu.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 7/26/23 09:23, Marc Zyngier wrote:
> On Tue, 25 Jul 2023 17:39:52 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Marc,
>>
>> On 7/12/23 16:57, Marc Zyngier wrote:
>>> As we're about to majorly extend the handling of FGT registers,
>>> restructure the code to actually save/restore the registers
>>> as required. This is made easy thanks to the previous addition
>>> of the EL2 registers, allowing us to use the host context for
>>> this purpose.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  arch/arm64/include/asm/kvm_arm.h        | 21 ++++++++++
>>>  arch/arm64/kvm/hyp/include/hyp/switch.h | 55 +++++++++++++------------
>>>  2 files changed, 49 insertions(+), 27 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>>> index 028049b147df..85908aa18908 100644
>>> --- a/arch/arm64/include/asm/kvm_arm.h
>>> +++ b/arch/arm64/include/asm/kvm_arm.h
>>> @@ -333,6 +333,27 @@
>>>  				 BIT(18) |		\
>>>  				 GENMASK(16, 15))
>>>  
>>> +/*
>>> + * FGT register definitions
>>> + *
>>> + * RES0 and polarity masks as of DDI0487J.a, to be updated as needed.
>>> + * We're not using the generated masks as they are usually ahead of
>>> + * the published ARM ARM, which we use as a reference.
>>> + *
>>> + * Once we get to a point where the two describe the same thing, we'll
>>> + * merge the definitions. One day.
>>> + */
>>> +#define __HFGRTR_EL2_RES0	(GENMASK(63, 56) | GENMASK(53, 51))
>>> +#define __HFGRTR_EL2_MASK	GENMASK(49, 0)
>>> +#define __HFGRTR_EL2_nMASK	(GENMASK(55, 54) | BIT(50))
>>> +
>>> +#define __HFGWTR_EL2_RES0	(GENMASK(63, 56) | GENMASK(53, 51) |	\
>>> +				 BIT(46) | BIT(42) | BIT(40) | BIT(28) | \
>>> +				 GENMASK(26, 25) | BIT(21) | BIT(18) |	\
>>> +				 GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
>>> +#define __HFGWTR_EL2_MASK	GENMASK(49, 0)
>>> +#define __HFGWTR_EL2_nMASK	(GENMASK(55, 54) | BIT(50))
>>> +
>>>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>>>  #define HPFAR_MASK	(~UL(0xf))
>>>  /*
>>> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
>>> index 4bddb8541bec..9781e79a5127 100644
>>> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
>>> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
>>> @@ -70,20 +70,19 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>>>  	}
>>>  }
>>>  
>>> -static inline bool __hfgxtr_traps_required(void)
>>> -{
>>> -	if (cpus_have_final_cap(ARM64_SME))
>>> -		return true;
>>> -
>>> -	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
>>> -		return true;
>>>  
>>> -	return false;
>>> -}
>>>  
>>> -static inline void __activate_traps_hfgxtr(void)
>>> +static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>>>  {
>>> +	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
>>>  	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
>>> +	u64 r_val, w_val;
>>> +
>>> +	if (!cpus_have_final_cap(ARM64_HAS_FGT))
>>> +		return;
>>> +
>>> +	ctxt_sys_reg(hctxt, HFGRTR_EL2) = read_sysreg_s(SYS_HFGRTR_EL2);
>>> +	ctxt_sys_reg(hctxt, HFGWTR_EL2) = read_sysreg_s(SYS_HFGWTR_EL2);
>>>  
>>>  	if (cpus_have_final_cap(ARM64_SME)) {
>>>  		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
>>> @@ -98,26 +97,30 @@ static inline void __activate_traps_hfgxtr(void)
>>>  	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
>>>  		w_set |= HFGxTR_EL2_TCR_EL1_MASK;
>>>  
>>> -	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
>>> -	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
>>> +
>>> +	r_val = __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
>> I don't get why you do
>>
>> & ~HFGxTR_EL2_nACCDATA_EL1 as this latter also has a negative polarity. 
>>
>> Please could you explain what is special with this bit/add a comment?
> Nothing is really special with this bit.
>
> But it is currently always cleared (we blindly write a big fat zero),
> and I wanted to explicitly show all the instructions for which we
> enable trapping for (ACCDATA_EL1 being the only one that is currently
> documented in the ARM ARM, although there are more already).
>
> So the construct I came up with is the above, initialising the
> register value with the nMASK bits (i.e. not trapping the
> corresponding instructions), and then clearing the bit for the stuff
> we want to trap. Maybe adding something like:
>
> /* Default to no trapping anything but ACCDATA_EL1 */
>
> would help?
thank you for the explanation. Yes it does.

Eric
>
> Thanks,
>
> 	M.
>

