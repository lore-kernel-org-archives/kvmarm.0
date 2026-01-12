Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2F12D7DD1
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 11:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768218850; cv=none; b=P1H6bVGYLnBy8kH/wG2fwi2IXsBk3x8eW0E6MDefUzclK+62R2EBnGxzy771XbTCNqsi0kOb7+X2vUPkhA+bqijF/eWGduTD4asmeXo2/MRo3W+TE/VZzPLY/4r9Vd0s8AC4Rg4gfFu4TzJKFXeOY+2ATV0gM7bAiKLUfoUsaqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768218850; c=relaxed/simple;
	bh=m3lSldEfRyC50t/kPCa1n87VX38ATt4LyNO0RNXPUjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ksTjfkiNQwvIYoAcIGjPOiKuEk7vXtB/uH/6lg/wapVt4UJOiy6bbNLaiqdn657+zQhRjjrzXJ+OLJ5mlEFQMjrqK1gm6fAxTn3nDoAZ+KwzwFp1+yNNiPC7IdUkIzCSYSWIMKEt1R9vnt1PXqYRFMOtBoGNYA8Uhm5lM7LAZlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=y2ECdQA+; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y2ECdQA+"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42fbc305552so4617260f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 03:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768218847; x=1768823647; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YWii3J6C1NMQBmfiw8z1OVB/aGlQS9lfRhCmvYhOn4I=;
        b=y2ECdQA+YNFsJIMjzc8b2H1UMrULHe8zSyAIhsY2njRQ6JDacLX4bTNQnLNHaOm8wK
         9XfumZl0IDdjKnKprQHMvSTf+la+jKoNXK3W38ok2pu1HmxKF3ejRgWVSOc5rT2xzaZK
         zvdBDciQ/WROyf/mitCC22yFgC5c+TMgyIpHPeficaIO9bQXU+0vfBZlH44WSFG+fOdg
         zf9lIq3YQ8aPdKnHe9oQkH+xYYiYXYMtc+31DgU9XuE94gC3fm3EhqfuvxPai3tkDFF0
         c+9ah01KXQYR4Y/eECUXxgTcQik1kIAB1FHtZzcFp1J4xx51kfpPCGrZBXADGz7t9dui
         yfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768218847; x=1768823647;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YWii3J6C1NMQBmfiw8z1OVB/aGlQS9lfRhCmvYhOn4I=;
        b=sCA5LaohfVZohTWrnkUKURkB4xduTHznXy5yl8A+gn/uZ+w/Or38ZQzNWIPYk+DJ+F
         hbjfgMvguPC/9QNjSb3qAf2JuQL9KnZKsmAtmJ4Iq9lHe6cbxB3A9AtwwWC7Ogdfuw+6
         jGhBlngy4r9O06d9jqplLDKRnxIEO7MoTcc9+i4e4E/F7Rj3tVpWQH+62Rh/ZCRjYbs9
         7WzajI7W5I+M8GL4MBjX2I6xHJoG08XYP1mTD/ulUzTi1DrXCFp/HUCbzCY7FS8Aa1Oq
         oibZ6X6mXp45dY3kIm1bdCNcTdY+Ez0h5jA36ruagZIyZm1ArsrssLz+maIfswTxllhb
         My4g==
X-Forwarded-Encrypted: i=1; AJvYcCULas6gAeMEyIvnWF1nad8XrEGordRn16xDKCmnkP0PGyZd1a/HPkGbzy2kbXC2vtXL0qaIPf4=@lists.linux.dev
X-Gm-Message-State: AOJu0YypMO3WDbXoUdyshjCnkfcbB1FKLzt5L2SucU8v+4Mmqlrs6l2g
	r1qGWuBdNaFiQCZUgI5rJp6q9iP1g5hTBzi46h2L3esOUqLlI0+wMVO4EoKbOpuFjIwq8GxYOc0
	1qAeS
X-Gm-Gg: AY/fxX4yFupHH2BhwlWpyhtUl7pnJbdC2c+A8uL/y50Mgk79ngH949xCkOxB5/WqRIx
	EiHPCMKfdTPZ4Q0KdJmydQIIQ8+IqdBXnFIEDkoKmznjAnP4XQY2X8awd23v86Er9I5vhQkl1PG
	DXfDEotIeR1w5cq+mQAjpwv4ZH3uJRb2NifaH7Q0+6Db5/xUyNcJPfIbha/6y2dKAiudcWDXrug
	OUdxG2qWJfWDAOt0JQwyO2jOHbiWLV3B1hjDZ1giXRLEzktqWvcZNBGPTbki0GF3i1Bce108vPT
	lS27z8hS7yIxVnUFBHRHFE+xJFaLpuqkdjYdI2z+hIZsW+8LmkRS3CLIfTmvyfx26kbT2RzaGKB
	vN1ho5n23p+sIMDBwaIjT6vkAFiQWM/iQh9JhpUzAFNa63RISKA532IyaVY2O91n29OxAMnnNBf
	YMSIHeapQTZ+1nbqq9
X-Google-Smtp-Source: AGHT+IEsjn+zK0lCbsdK1N0GQkVVBrmVbqGLvj60sSFEXUeA30O5MzdZ36mYjp8mtJBulQAHIaZUdA==
X-Received: by 2002:a5d:6a8c:0:b0:432:dd71:8f2c with SMTP id ffacd0b85a97d-432dd71908bmr8978495f8f.10.1768218847107;
        Mon, 12 Jan 2026 03:54:07 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5df9c5sm39252935f8f.22.2026.01.12.03.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 03:54:06 -0800 (PST)
Message-ID: <adacaff6-c6c7-47a5-993a-29f006fe1b86@linaro.org>
Date: Mon, 12 Jan 2026 11:54:05 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 19/35] KVM: arm64: Trap PMBIDR_EL1 and PMSIDR_EL1
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-20-alexandru.elisei@arm.com>
 <f7d73dc3-aa4a-4c32-aabb-21a61a2f773f@linaro.org> <aWTa76KXpIwzPh4k@raptor>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aWTa76KXpIwzPh4k@raptor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/01/2026 11:28 am, Alexandru Elisei wrote:
> Hi James,
> 
> On Fri, Jan 09, 2026 at 04:29:37PM +0000, James Clark wrote:
>>
>>
>> On 14/11/2025 4:07 pm, Alexandru Elisei wrote:
>>> PMBIDR_EL1 and PMSIDR_EL1 are read-only registers that describe the SPE
>>> implementation. Trap reads to allow KVM to control how SPE is described to
>>> a virtual machine. In particular, this is needed to:
>>>
>>> - Advertise the maximum buffer size set by userspace in
>>>     PMBIDR_EL1.MaxBuffSize.
>>> - Hide in PMSIDR_EL1, if necessary, the presence of FEAT_SPE_FDS and
>>>     FEAT_SPE_FnE, both of which add new registers which are already
>>>     trapped via the FGU mechanism.
>>>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>    arch/arm64/include/asm/kvm_spe.h |  4 +-
>>>    arch/arm64/kvm/config.c          | 13 ++++-
>>>    arch/arm64/kvm/spe.c             | 82 +++++++++++++++++++++++++++++++-
>>>    arch/arm64/kvm/sys_regs.c        | 13 +++--
>>>    4 files changed, 103 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
>>> index 3506d8c4c661..47b94794cc5f 100644
>>> --- a/arch/arm64/include/asm/kvm_spe.h
>>> +++ b/arch/arm64/include/asm/kvm_spe.h
>>> @@ -40,7 +40,7 @@ int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>>>    int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>>>    bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
>>> -u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg);
>>> +u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg, u32 encoding);
>>>    #else
>>>    struct kvm_spe {
>>>    };
>>> @@ -78,7 +78,7 @@ static inline bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>>>    {
>>>    	return true;
>>>    }
>>> -static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
>>> +static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg, u32 encoding)
>>>    {
>>>    	return 0;
>>>    }
>>> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
>>> index 24bb3f36e9d5..ed6b167b7aa8 100644
>>> --- a/arch/arm64/kvm/config.c
>>> +++ b/arch/arm64/kvm/config.c
>>> @@ -6,6 +6,7 @@
>>>    #include <linux/kvm_host.h>
>>>    #include <asm/kvm_emulate.h>
>>> +#include <asm/kvm_spe.h>
>>>    #include <asm/kvm_nested.h>
>>>    #include <asm/sysreg.h>
>>> @@ -1489,6 +1490,16 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
>>>    		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
>>>    }
>>> +static void __compute_hdfgrtr(struct kvm_vcpu *vcpu)
>>> +{
>>> +	__compute_fgt(vcpu, HDFGRTR_EL2);
>>> +
>>> +	if (vcpu_has_spe(vcpu)) {
>>> +		*vcpu_fgt(vcpu, HDFGRTR_EL2) |= HDFGRTR_EL2_PMBIDR_EL1;
>>> +		*vcpu_fgt(vcpu, HDFGRTR_EL2) |= HDFGRTR_EL2_PMSIDR_EL1;
>>> +	}
>>> +}
>>> +
>>>    static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
>>>    {
>>>    	__compute_fgt(vcpu, HDFGWTR_EL2);
>>> @@ -1505,7 +1516,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
>>>    	__compute_fgt(vcpu, HFGRTR_EL2);
>>>    	__compute_hfgwtr(vcpu);
>>>    	__compute_fgt(vcpu, HFGITR_EL2);
>>> -	__compute_fgt(vcpu, HDFGRTR_EL2);
>>> +	__compute_hdfgrtr(vcpu);
>>>    	__compute_hdfgwtr(vcpu);
>>>    	__compute_fgt(vcpu, HAFGRTR_EL2);
>>> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
>>> index 5b3dc622cf82..92eb46276c71 100644
>>> --- a/arch/arm64/kvm/spe.c
>>> +++ b/arch/arm64/kvm/spe.c
>>> @@ -22,10 +22,16 @@ struct arm_spu_entry {
>>>    	struct arm_spe_pmu *arm_spu;
>>>    };
>>> +static u64 max_buffer_size_to_pmbidr_el1(u64 size);
>>> +
>>>    void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
>>>    {
>>>    	struct arm_spu_entry *entry;
>>> +	/* PMBIDR_EL1 cannot be trapped without FEAT_FGT. */
>>> +	if (!cpus_have_final_cap(ARM64_HAS_FGT))
>>> +		return;
>>> +
>>
>> Isn't this only required if you want to report a different PMBIDR value? If
>> the value in hardware is already what you want to give to guests then it's
>> not strictly required. Maybe it's something we can do as an addition later
>> to make it usable in more places.
> 
> The maximum buffer size is advertised in PMBIDR_EL1.
> 
> Thanks,
> Alex
> 

I know, but 0 "unlimited" is a valid value, and that's what's already in 
PMBIDR. You only need to trap if the value doesn't match what's already 
there.

You can also "probe" the maximum buffer size without this by attempting 
to set the limit pointer and looking at the buffer management error code.

The first thing I did when I went to use this was comment this out 
because my hardware doesn't support FGT. But the rest of it works fine 
without, maybe other people could benefit in the future too.

>>
>>>    	/* TODO: pKVM and nVHE support */
>>>    	if (is_protected_kvm_enabled() || !has_vhe())
>>>    		return;
>>> @@ -86,9 +92,81 @@ bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>>>    	return true;
>>>    }
>>> -u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
>>> +static bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
>>> +{
>>> +	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.arm_spu;
>>> +
>>> +	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4) &&
>>> +	       FIELD_GET(PMSIDR_EL1_FDS, spe_pmu->pmsidr_el1);
>>> +}
>>> +
>>> +static bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
>>> +{
>>> +	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.arm_spu;
>>> +
>>> +	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2) &&
>>> +	       FIELD_GET(PMSIDR_EL1_FnE, spe_pmu->pmsidr_el1);
>>> +}
>>> +
>>> +static u64 kvm_spe_get_pmsidr_el1(struct kvm_vcpu *vcpu)
>>>    {
>>> -	return __vcpu_sys_reg(vcpu, reg);
>>> +	struct kvm *kvm = vcpu->kvm;
>>> +	u64 pmsidr = kvm->arch.kvm_spe.arm_spu->pmsidr_el1;
>>> +
>>> +	/* Filter out known RES0 bits. */
>>> +	pmsidr &= ~GENMASK_ULL(63, 33);
>>> +
>>> +	if (!kvm_spe_has_feat_spe_fne(kvm))
>>> +		pmsidr &= ~PMSIDR_EL1_FnE;
>>> +
>>> +	if (!kvm_spe_has_feat_spe_fds(kvm))
>>> +		pmsidr &= ~PMSIDR_EL1_FDS;
>>> +
>>> +	return pmsidr;
>>> +}
>>> +
>>> +static u64 kvm_spe_get_pmbidr_el1(struct kvm_vcpu *vcpu)
>>> +{
>>> +	struct kvm *kvm = vcpu->kvm;
>>> +	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
>>> +	u64 max_buffer_size = kvm_spe->max_buffer_size;
>>> +	u64 pmbidr_el1 = kvm_spe->arm_spu->pmbidr_el1;
>>> +
>>> +	/* Filter out known RES0 bits. */
>>> +	pmbidr_el1 &= ~(GENMASK_ULL(63, 48) | GENMASK_ULL(31, 12));
>>> +
>>> +	if (!kvm_has_feat(kvm, ID_AA64DFR2_EL1, SPE_nVM, IMP)) {
>>> +		pmbidr_el1 &= ~PMBIDR_EL1_AddrMode;
>>> +		pmbidr_el1 |= PMBIDR_EL1_AddrMode_VM_ONLY;
>>> +	}
>>> +
>>> +	pmbidr_el1 &= ~PMBIDR_EL1_MaxBuffSize;
>>> +	pmbidr_el1 |= max_buffer_size_to_pmbidr_el1(max_buffer_size);
>>> +
>>> +	return pmbidr_el1;
>>> +}
>>> +
>>> +u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg, u32 encoding)
>>> +{
>>> +	u64 val = 0;
>>> +
>>> +	switch (encoding) {
>>> +	case SYS_PMBIDR_EL1:
>>> +		val = kvm_spe_get_pmbidr_el1(vcpu);
>>> +		break;
>>> +	case SYS_PMSIDR_EL1:
>>> +		val = kvm_spe_get_pmsidr_el1(vcpu);
>>> +		break;
>>> +	case SYS_PMBLIMITR_EL1:
>>> +	case SYS_PMBPTR_EL1:
>>> +	case SYS_PMBSR_EL1:
>>> +		val = __vcpu_sys_reg(vcpu, reg);
>>> +		break;
>>> +	default:
>>> +		WARN_ON_ONCE(1);
>>> +	}
>>> +
>>> +	return val;
>>>    }
>>>    static u64 max_buffer_size_to_pmbidr_el1(u64 size)
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 5eeea229b46e..db86d1dcd148 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -1386,13 +1386,18 @@ static unsigned int spe_visibility(const struct kvm_vcpu *vcpu,
>>>    static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>>    			   const struct sys_reg_desc *r)
>>>    {
>>> +	u32 encoding = reg_to_encoding(r);
>>>    	u64 val = p->regval;
>>>    	int reg = r->reg;
>>> -	if (p->is_write)
>>> +	if (p->is_write) {
>>> +		if (WARN_ON_ONCE(encoding == SYS_PMBIDR_EL1 ||
>>> +				 encoding == SYS_PMSIDR_EL1))
>>> +			return write_to_read_only(vcpu, p, r);
>>>    		return kvm_spe_write_sysreg(vcpu, reg, val);
>>> +	}
>>> -	p->regval = kvm_spe_read_sysreg(vcpu, reg);
>>> +	p->regval = kvm_spe_read_sysreg(vcpu, reg, encoding);
>>>    	return true;
>>>    }
>>> @@ -3360,12 +3365,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>>>    	{ SPE_UNTRAPPED_REG(PMSFCR_EL1) },
>>>    	{ SPE_UNTRAPPED_REG(PMSEVFR_EL1) },
>>>    	{ SPE_UNTRAPPED_REG(PMSLATFR_EL1) },
>>> -	{ SYS_DESC(SYS_PMSIDR_EL1), .access = undef_access },
>>> +	{ SYS_DESC(SYS_PMSIDR_EL1), .access = access_spe_reg, .visibility = spe_visibility },
>>>    	{ SPE_TRAPPED_REG(PMBLIMITR_EL1) },
>>>    	{ SPE_TRAPPED_REG(PMBPTR_EL1) },
>>>    	{ SPE_TRAPPED_REG(PMBSR_EL1) },
>>>    	{ SPE_UNTRAPPED_REG(PMSDSFR_EL1) },
>>> -	{ SYS_DESC(SYS_PMBIDR_EL1), .access = undef_access },
>>> +	{ SYS_DESC(SYS_PMBIDR_EL1), .access = access_spe_reg, .visibility = spe_visibility },
>>>    	{ PMU_SYS_REG(PMINTENSET_EL1),
>>>    	  .access = access_pminten, .reg = PMINTENSET_EL1,
>>

