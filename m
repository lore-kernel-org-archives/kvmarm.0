Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC0E13AEE
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707127852; cv=none; b=Vd1GIC7lDlti0jIrIiNehcAyjsITK571AUGYdgLY/3TAk17EnphLBpbEjKLJczDA1bGEacWquWY3Uc1zWQ6xr6vhubnnxEGYVJyEoK78fZwS1WidJ3yoSfurNmdSSADBjxuiS0vLamBZU4hTguuU+E8siAGZOcGyjmJFjYxrMpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707127852; c=relaxed/simple;
	bh=WaloIgBi3+p3imbkonjpJbY8Hk5urEmsonWsjvvYIhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QL8tmJ/0TYQ2qavzBVEKhhCCUj/4M7wpUGJKTAf+WU95go9zEdqRLJZvbIj5zbD3J465yylDFrzG7HDtJGAODC+dThVkAl2mcS6+TpLQPI5egUHsBVnUB56u5YtA5jlJzB+pnAA7k5xe3Lst9+xI1lgqdjWxTewcZjWJENRXFa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D7721FB;
	Mon,  5 Feb 2024 02:11:27 -0800 (PST)
Received: from [10.57.9.25] (unknown [10.57.9.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 53D243F762;
	Mon,  5 Feb 2024 02:10:43 -0800 (PST)
Message-ID: <5abfe1dc-bf52-4cbc-9d3d-6f5b83c1e48f@arm.com>
Date: Mon, 5 Feb 2024 10:10:41 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/25] KVM: arm64: Add feature checking helpers
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Mark Brown <broonie@kernel.org>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-3-maz@kernel.org>
 <f47909b1-5e10-4149-8d2a-330bd0ceb2e0@arm.com> <87mssgwkoy.wl-maz@kernel.org>
 <87le80wj0l.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <87le80wj0l.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/02/2024 11:44, Marc Zyngier wrote:
> On Sun, 04 Feb 2024 11:08:45 +0000,
> Marc Zyngier <maz@kernel.org> wrote:
>>
>> On Fri, 02 Feb 2024 17:13:07 +0000,
>> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>>
>>> Hi Marc,
>>>
>>> On 30/01/2024 20:45, Marc Zyngier wrote:
>>>> In order to make it easier to check whether a particular feature
>>>> is exposed to a guest, add a new set of helpers, with kvm_has_feat()
>>>> being the most useful.
>>>>
>>>> Let's start making use of them in the PMU code (courtesy of Oliver).
>>>> Follow-up work will intricude additional use patterns.
>>>
>>> I think there is a bit of inconsistency in the macros for signed
>>> and unsigned. The unsigned fields are extracted (i.e., as if they
>>> were shifted to bit 0). But the signed fields are not shifted
>>> completely to bit '0' (in fact to different positions) and eventually
>>> we compare wrong things.
>>>
>>> Using ID_AA64PFR0_EL1, fld=EL2, val=IMP for unsigned and
>>> ID_AA64PFR0_EL1, AdvSIMD, NI for signed.
>>>
>>>>
>>>> Co-developed--by: Oliver Upton <oliver.upton@linux.dev>
>>>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>> ---
>>>>    arch/arm64/include/asm/kvm_host.h | 53 +++++++++++++++++++++++++++++++
>>>>    arch/arm64/kvm/pmu-emul.c         | 11 ++++---
>>>>    arch/arm64/kvm/sys_regs.c         |  6 ++--
>>>>    include/kvm/arm_pmu.h             | 11 -------
>>>>    4 files changed, 61 insertions(+), 20 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>> index 21c57b812569..c0cf9c5f5e8d 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -1233,4 +1233,57 @@ static inline void kvm_hyp_reserve(void) { }
>>>>    void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
>>>>    bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
>>>>    +#define __expand_field_sign_unsigned(id, fld, val)
>>>> \
>>>> +	((u64)(id##_##fld##_##val))
>>>
>>> For unsigned features we get the actual "field" value, not the value
>>> in position. e.g,: ID_AA64PFR0_EL1_EL2_IMP = (0x1)
>>>
>>>> +
>>>> +#define __expand_field_sign_signed(id, fld, val)			\
>>>> +	({								\
>>>> +		s64 __val = id##_##fld##_##val;				\
>>>> +		__val <<= 64 - id##_##fld##_WIDTH;			\
>>>> +		__val >>= 64 - id##_##fld##_SHIFT - id##_##fld##_WIDTH;	\
>>>
>>> But for signed fields, we shift them back into the "position" as in
>>> the ID_REG. e.g.,
>>>
>>> ID_AA64PFR0_EL1, AdvSIMD, NI we get:
>>>
>>> 	__val = ID_AA64PFR0_EL1_AdvSIMD_NI; /* = 0xf */
>>> 	__val <<= 64 - 4;		/* 0xf0_00_00_00_00_00_00_00 */
>>> 	__val >>= 64 - 20 - 4;		/* 0xff_ff_ff_ff_ff_f0_00_00 */
>>>
>>> I think the last line instead should be:
>>> 	__val >>= 64 - id##_##fld##_WIDTH;
>>
>> Huh, you're absolutely right.
>>
>>>
>>>> +									\
>>>> +		__val;							\
>>>> +	})
>>>> +
>>>> +#define expand_field_sign(id, fld, val)					\
>>>> +	(id##_##fld##_SIGNED ?						\
>>>> +	 __expand_field_sign_signed(id, fld, val) :			\
>>>> +	 __expand_field_sign_unsigned(id, fld, val))
>>>> +
>>>> +#define get_idreg_field_unsigned(kvm, id, fld)				\
>>>> +	({								\
>>>> +		u64 __val = IDREG(kvm, SYS_##id);			\
>>>> +		__val &= id##_##fld##_MASK;				\
>>>> +		__val >>= id##_##fld##_SHIFT;				\
>>>> +									\
>>>
>>> We extract the field value for unsigned field, i.e., shifted to bit"0"
>>> and that matches the expand_field_sign().
>>>
>>>> +		__val;							\
>>>> +	})
>>>> +
>>>> +#define get_idreg_field_signed(kvm, id, fld)				\
>>>> +	({								\
>>>> +		s64 __val = IDREG(kvm, SYS_##id);			\
>>>> +		__val <<= 64 - id##_##fld##_SHIFT - id##_##fld##_WIDTH;	\
>>>> +		__val >>= id##_##fld##_SHIFT;				\
>>>
>>> However, here we get (assuming value ID_AA64PFR0_EL1_ASIMD = 0xf, and
>>> all other fields are 0 for clarity)
>>> 	
>>> 	__val = IDREG(kvm, SYS_ID_AA64PFR0_EL1); = 0xf0_00_00; 	/* 0xf << 20 */
>>> 	__val <<= 64 - 20 - 4;	/* = 0xf0_00_00_00_00_00_00_00 */
>>> 	__val >>= 20;		/* = 0xff_ff_ff_00_00_00_00_00 */
>>
>> Gah... again!
>>
>>>
>>> Thus they don;t match. Instead the last line should be :
>>>
>>> 	__val >>= id##_##fld##_WIDTH;
>>
>> Shouldn't this be (64 - WIDTH) instead, since we want the value to be
>> shifted to bit 0? Otherwise, you get 0xff_00_00_00_00_00_00_00 (as per
>> your example).

Bah, You're right. See, its so easy to mess it up ;-)

>>
>> Thanks a lot for spotting those, much appreciated.
> 
> And since it is now obvious to anyone that I can't shift properly,
> let's just not do that. As it turns out, the kernel already has the
> required macros, and I can stop being clever with these:
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ea8acc1914aa..3457fa313bad 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1290,11 +1290,8 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
>   
>   #define __expand_field_sign_signed(id, fld, val)			\
>   	({								\
> -		s64 __val = id##_##fld##_##val;				\
> -		__val <<= 64 - id##_##fld##_WIDTH;			\
> -		__val >>= 64 - id##_##fld##_SHIFT - id##_##fld##_WIDTH;	\
> -									\
> -		__val;							\
> +		u64 __val = id##_##fld##_##val;				\
> +		sign_extend64(__val, id##_##fld##_WIDTH - 1);		\
>   	})
> 



>   #define expand_field_sign(id, fld, val)					\
> @@ -1313,11 +1310,9 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
>   
>   #define get_idreg_field_signed(kvm, id, fld)				\
>   	({								\
> -		s64 __val = IDREG(kvm, SYS_##id);			\
> -		__val <<= 64 - id##_##fld##_SHIFT - id##_##fld##_WIDTH;	\
> -		__val >>= id##_##fld##_SHIFT;				\
> -									\
> -		__val;							\
> +		u64 __val = IDREG(kvm, SYS_##id);			\
> +		__val = FIELD_GET(id##_##fld##_MASK, __val);		\
> +		sign_extend64(__val, id##_##fld##_WIDTH - 1);		\
>   	})
>   
>   #define get_idreg_field_enum(kvm, id, fld)				\
> 
> Thoughts?

Thats much much better and saves you some staring at the screen. Didn't
know that existed. Thanks for that.

Suzuki


> 
> 	M.
> 

