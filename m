Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C0CB33C1B4
	for <kvmarm@lists.linux.dev>; Mon, 23 Feb 2026 18:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771870712; cv=none; b=RLHt1bJQJ+S7NbbiOTPFFMAR6QikG6HgblbU2yn3cmGJCGqFUX2DQQB3tGvB/ECUG4hkx/md9m7Ch8pCKW23a9hl2PfwUarK0QrUQxkuyA7paaOlZfxynXfu9vgAvBgSz4bsyIgXtpdUsoHD8scZaR4D3pBqtcbCbnLiXBYgscU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771870712; c=relaxed/simple;
	bh=oRooVzL0odVAx0H62vIHfOswFtnNubdRa3Ya0uG2MG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PufbkPR7mXd8apOrT0FbGDOtFjCnVr4TKvr+fjU2YVYa0t2CNyOlS/SYNiFwtvw3D5ffzgkylb/dUCrqjM6tJ/vFq58mLkdx+wLb+54JjJi/sfJnEayqWr8zbpBYpbgyONZvw6GTQwsdP4MzMOHe5Q/uqeuBbv8XNHwgFbZZ8Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 048A5339;
	Mon, 23 Feb 2026 10:18:22 -0800 (PST)
Received: from [10.57.13.34] (unknown [10.57.13.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFDBE3F62B;
	Mon, 23 Feb 2026 10:18:26 -0800 (PST)
Message-ID: <f62d7cab-883c-44a8-9714-251af1b20eff@arm.com>
Date: Mon, 23 Feb 2026 18:18:25 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] arm64: Add logic to fully remove features from
 sanitised id registers
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
References: <20260219195533.2455736-1-maz@kernel.org>
 <20260219195533.2455736-2-maz@kernel.org>
 <CA+EHjTzVRq3r-7UR-MJYvv-Aw4kHQDHEmwtqY9is-fRDm-J06A@mail.gmail.com>
 <86v7frafpx.wl-maz@kernel.org>
 <CA+EHjTzj9wEm7oBKBXF8sYpK60FYeLOJwEapxDiO1HxK5e6Y6g@mail.gmail.com>
 <86tsvba2nc.wl-maz@kernel.org>
 <CA+EHjTyiHALTEgA7tuqQZ2ZLW3_vFdTU=vUb7+vn1T4OoMjgsw@mail.gmail.com>
 <86pl5vaizb.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86pl5vaizb.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23/02/2026 09:48, Marc Zyngier wrote:
> Hi Fuad,
> 
> On Fri, 20 Feb 2026 15:36:37 +0000,
> Fuad Tabba <tabba@google.com> wrote:
>>
>>> I think we must prevent this downgrade the same way, meaning that
>>> ALL_HIDDEN and FTR_HIGHER are mutually exclusive.
>>>
>>> How about that:
>>>
>>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>>> index d58931e63a0b6..2cae00b4b0c5f 100644
>>> --- a/arch/arm64/kernel/cpufeature.c
>>> +++ b/arch/arm64/kernel/cpufeature.c
>>> @@ -1067,7 +1067,14 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
>>>                          user_mask |= ftr_mask;
>>>                          break;
>>>                  case FTR_ALL_HIDDEN:
>>> -                       val = arm64_ftr_set_value(ftrp, val, ftrp->safe_val);
>>> +                       /*
>>> +                        * ALL_HIDDEN and HIGHER_SAFE are incompatible.
>>> +                        * Only hide from userspace, and log the oddity.
>>> +                        */
>>> +                       if (WARN_ON(ftrp->type == FTR_HIGHER_SAFE))
>>> +                               val = arm64_ftr_set_value(ftrp, val, ftr_new);
>>> +                       else
>>> +                               val = arm64_ftr_set_value(ftrp, val, ftrp->safe_val);
>>>                          reg->user_val = arm64_ftr_set_value(ftrp,
>>>                                                              reg->user_val,
>>>                                                              ftrp->safe_val);
>>>
>>
>> Yes, I think WARN_ON() here is the right call.
>>
>> That said, I still think you should explicitly short-circuit
>> update_cpu_ftr_reg() for FTR_ALL_HIDDEN features, in addition to the
>> WARN_ON(). Relying on arm64_ftr_safe_value() to naturally preserve the
>> safe_val during secondary CPU boot seems mathematically fragile.
>>
>> Take MTE_frac as an example. It uses S_ARM64_FTR_BITS and
>> FTR_LOWER_SAFE with a safe_val of 0. If it were marked FTR_ALL_HIDDEN,
>> init_cpu_ftr_reg() would prime sys_val with 0. But if a secondary CPU
>> boots and reports -1 (NI), arm64_ftr_safe_value() will execute min(-1,
>> 0) and return -1. update_cpu_ftr_reg() will then overwrite the primed
>> safe_val (0) with -1. The "hidden" state established by the boot CPU
>> is gone, and the feature's hardware state is now exposed globally.
>>
>> Note that MTE is currently ALL_HIDDEN when configured out, so it's not
>> totally inconceivable that someone decides to make MTE_frac ALL_HIDDEN
>> as well. Explicitly short-circuiting for FTR_ALL_HIDDEN features in
>> update_cpu_ftr_reg() seems to be the safer bet here.
> 
> Right, the signed feature is a pretty compelling argument. And we
> should do the same thing for overrides, probably as a preliminary
> patch.
> 

Suggestions look good to me and I was thinking on similar lines with the 
FTR_CONFIG() (Was away last week, now back from holidays).

One minor nit: Given we now have more uses
of arm64_ftr_set_value(ftrp, x, ftrp->safe_value) , could we wrap it
into something like :

static inline s64 arm64_ftr_set_safe_value(... *ftrp, s64 val);
{
	return arm64_ftr_set_value(ftrp, val, ftrp->safe_val);
}

To me that makes it way easier to comprehend what we are doing.

Suzuki


  Thanks,
> 
> 	M.
> 

