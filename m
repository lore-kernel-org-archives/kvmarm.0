Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DBA94398F2;
	Tue, 15 Sep 2026 17:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789494721; cv=none; b=QeOf5vbudACVSE/0vlc3OzKwO+Hfj5o5uRzH6NAUZRJQZcApmVmH60QoucyemOWkaQHeH55G8LmNR4Af+xxiWIUBavRCebHuNmCYBK2i37AK2Z8BFZgId5NLhhhiJEk/Re8xgbaBTUGKfnoiK4xSELAv0pzzZ9nG+s2wst4jtIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789494721; c=relaxed/simple;
	bh=zjV2zQ6578Cea/PcaJJwVuCoXIsKb8OLzDKalNpaJ5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wl9nN4ymAWMAGDyxwly7HJ7ocNmmh9TytWxLxLxsZtATIQeAoq2bSWoQAySk9focVpCBR3FylbIsi9uItO3YSy9TjpQuOOi2jsWp7dvzxU8wXaP9ffHz+uhSf6TPIVb+3eyJaWQPg/dACnH60Ki+59S1Wn85VLqMPT73rjsEAtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mxRm45AN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mxRm45AN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA970153B;
	Tue, 15 Sep 2026 10:51:48 -0700 (PDT)
Received: from [192.168.1.148] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A87A53F7B4;
	Tue, 15 Sep 2026 10:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789494712; bh=zjV2zQ6578Cea/PcaJJwVuCoXIsKb8OLzDKalNpaJ5g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mxRm45ANNZ8yc+jBzPCsl0QdxLoUHDn0VsO6ObX13Vg5vrD/rFWpCLxMXJIw5P/r1
	 raW0H3Ihc23Q5KWcCKwytQNkzK7QOjyRvPY5fFAJRYXkEqlMoAyU5Fv4gA5bCpLPiB
	 LlUO2ByTjpuRqFQ32p2awHclC8LJApo9bw1ge+M4=
Message-ID: <fe2830b4-d044-48ea-91b5-3ff705023d8c@arm.com>
Date: Tue, 15 Sep 2026 18:51:50 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 23/23] KVM: arm64: CCA: Control user register access
 for Realms
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-24-suzuki.poulose@arm.com>
 <20260915164907.9729B1F000FF@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260915164907.9729B1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/09/2026 17:49, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] arm64: kvm: KVM_SET_ONE_REG rejects PMCR_EL0 for Realm VMs breaking PMU config
> --
> 
> commit 2d966a4231d9ac9707a0d74a6ba5b743ae7b69b3
> Author: Jean-Philippe Brucker <jpb@kernel.org>
> 
> KVM: arm64: CCA: Control user register access for Realms
> 
> This commit restricts user register access for Realm VMs by limiting which
> registers the VMM can read or modify. KVM explicitly allows access to
> ID_AA64DFR0_EL1 and SVE_VLS for Realm parameter configuration before the Realm
> Descriptor is created.
> 
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
> [ ... ]
>> +static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
>> +				   const struct kvm_one_reg *reg)
>> +{
>> +	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE) {
>> +		u64 off = core_reg_offset_from_id(reg->id);
>> +
>> +		return kvm_realm_validate_core_reg(off);
>> +	} else {
>> +		switch (reg->id) {
>> +		case KVM_REG_ARM_ID_AA64DFR0_EL1:
>> +		case KVM_REG_ARM64_SVE_VLS:
>> +			return true;
>> +		}
>> +	}
>> +
>> +	return false;
>> +}
> 
> [Severity: High]
> Does this logic unconditionally reject KVM_SET_ONE_REG calls for PMCR_EL0?
> 
> When the VMM attempts to restore or configure the PMU, kvm_arm_set_reg()
> calls validate_realm_set_reg(). Because the UAPI equivalent of SYS_PMCR_EL0
> is missing from this whitelist, the VMM is prevented from configuring the
> number of PMU counters for Realm VMs, breaking VM initialization.
> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
> [ ... ]
>> +static inline bool kvm_realm_sys_reg_hidden_user(const struct kvm_vcpu *vcpu,
>> +						 u64 reg)
>> +{
>> +	if (!vcpu_is_rec(vcpu))
>> +		return false;
>> +
>> +	switch (reg) {
>> +	case SYS_ID_AA64DFR0_EL1:
>> +	case SYS_PMCR_EL0:
>> +		return false;
>> +	}
>> +	return true;
>> +}
> 
> [Severity: High]
> This explicitly unhides SYS_PMCR_EL0 in kvm_realm_sys_reg_hidden_user(),
> meaning it is returned to the VMM via KVM_GET_REG_LIST.
> 
> Since validate_realm_set_reg() in arch/arm64/kvm/guest.c rejects writes to
> the PMU register, does this create an ABI inconsistency where the register
> is listed but cannot be set?
> 
> Could this mismatch in configuration flow be corrected to allow PMU support
> for Realm VMs?

Yep, this is the idea. We don't have the PMU support in the current 
integration branch. That said, I will remove the PMCR_EL0 from the 
validate_realm_set_reg().

Cheers
Suzuki


> 

