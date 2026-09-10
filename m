Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756CF47D46D;
	Thu, 10 Sep 2026 12:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789042669; cv=none; b=WAJihb8Z4D/Man8nVxVVGQvKWUCkUCIZADD85MWFrEh3tdWjR16hycG7MVOQ877BFntRFCq/DGXXGRaKQ0NbDe15hHn3Woi7KHqJxjmJjhFmZ2emKnBjErP03k2Td0sFaNsnlDya0XW0mLKFWjjE7t0Nh8c4ne4YsG5S4NADXCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789042669; c=relaxed/simple;
	bh=quBGQJld4Q6tF7xap2paZPslvrUtR8+sOj/CyNhImAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iOUeox/OO7azJQaKxZAIyXyjd8RoSbB6fnWDbQZdgME6CQ67FTvtZw3TsW5lkavimXMVp43HVGGa+Z6yhOSYcBp8BxTs56+VzhPl1zNHqiW3rPpxFqCKPv8BgLfGJKnxKVz32V484eYdxEXIhEEqtbCG6sjNdWe1Vmd4oVi7Njk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DoVUjd2O; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DoVUjd2O"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA8CE153B;
	Thu, 10 Sep 2026 05:17:40 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA6BF3F7B4;
	Thu, 10 Sep 2026 05:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789042664; bh=quBGQJld4Q6tF7xap2paZPslvrUtR8+sOj/CyNhImAU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DoVUjd2OdcnJ7cU8iMHFy2BdOJWDO/bf4He/p7qlB31iLtoTFa+na4qNPlxqAtKZ+
	 aep5Emvx5sBq12WNKUH/TJ5D9VLIXNIsXMDilozad41qPWneipx4YQNvUodOpOKlsh
	 8ZQ7o27NcePDoCgaUSq2FnoivBurqEkx5d0lcRTw=
Message-ID: <0a75dfc9-17c7-4917-94b4-0b0b38db847a@arm.com>
Date: Thu, 10 Sep 2026 13:17:42 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 17/20] KVM: arm64: CCA: Provide an accurate register
 list
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-18-suzuki.poulose@arm.com>
 <20260908170026.B47BF1F00A3A@smtp.kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260908170026.B47BF1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/09/2026 18:00, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] KVM_GET_REG_LIST fails to restrict core registers to the 9 GP registers for Realm VMs, exposing all core registers instead.
> - [Medium] Realm VM system register restrictions are only applied to KVM_GET_REG_LIST, allowing userspace to bypass them via KVM_SET_ONE_REG and KVM_GET_ONE_REG.
> --
> 
> commit 1a82d37b0064cc3f1fa34c6757432fa355d160a3
> Author: Jean-Philippe Brucker <jpb@kernel.org>
> 
> KVM: arm64: CCA: Provide an accurate register list
>      
> Userspace can set a few registers with KVM_SET_ONE_REG (9 GP registers
> at runtime, and 3 system registers during initialization). Update the
> register list returned by KVM_GET_REG_LIST.
> 
>> Userspace can set a few registers with KVM_SET_ONE_REG (9 GP registers
>> at runtime, and 3 system registers during initialization). Update the
>> register list returned by KVM_GET_REG_LIST.
> 
> [Severity: Medium]
> Does KVM_GET_REG_LIST successfully restrict core registers to just the 9 GP
> registers for Realm VMs?
> 
> Looking at copy_core_reg_indices(), it loops over the entire kvm_regs array
> without checking vcpu_is_rec(vcpu):
> 
> arch/arm64/kvm/guest.c:copy_core_reg_indices() {
> 	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
> 		u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
> 		int size = core_reg_size_from_offset(vcpu, i);
> 
> 		if (size < 0)
> 			continue;
>          ...
> }
> 
> This appears to expose all core registers to the userspace array rather than
> limiting it to the 9 GP registers mentioned in the commit message.

That is correct, but a later patch actually restricts this for set_reg()
calls. I will pull that into this series and will also fixup the commit
description, potentially folding that one here.

> 
> [ ... ]
> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 44aae52c473d7..a58c1fc13ea17 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
> 
> [ ... ]
> 
>> @@ -5693,11 +5693,26 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
>>   	return true;
>>   }
>>   
>> +static inline bool kvm_realm_sys_reg_hidden_user(const struct kvm_vcpu *vcpu,
>> +						 u64 reg)
>> +{
>> +	switch (reg) {
>> +	case SYS_ID_AA64DFR0_EL1:
>> +	case SYS_PMCR_EL0:
>> +		return false;
>> +	}
>> +	return true;
>> +}
>> +
>>   static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
>>   			    const struct sys_reg_desc *rd,
>>   			    u64 __user **uind,
>>   			    unsigned int *total)
>>   {
>> +	if (vcpu_is_rec(vcpu) &&
>> +	    kvm_realm_sys_reg_hidden_user(vcpu, reg_to_encoding(rd)))
>> +		return 0;
>> +
> 
> [Severity: Medium]
> Are the Realm system register restrictions bypassed by KVM_SET_ONE_REG and
> KVM_GET_ONE_REG?
> 
> While this patch correctly hides the registers from KVM_GET_REG_LIST by
> checking kvm_realm_sys_reg_hidden_user() in walk_one_sys_reg(), it doesn't
> appear to add a similar check to the ioctl handlers for setting or getting
> individual registers.
> 
> For example, in kvm_sys_reg_set_user(), the code only checks sysreg_hidden():

As above, this is in a separate patch, I will fix this in next version.


Suzuki

