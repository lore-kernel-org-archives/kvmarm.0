Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76ED19D890
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 10:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734518249; cv=none; b=gzH97cxKIVU1VUyFefKFHmQRyLzFQ/OygYzJuB2R4HfB7/rH5Q50b25OYNmbIPlUAa882XvksItZwKonxZNrse/kZfmzXicXkRDtwZmJKwNso6+aUttOFC2bDtO0WWBz4Z8qOny3dMC1EFM8IkpkRjMMCu4U2jXv7oAQGWA555c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734518249; c=relaxed/simple;
	bh=WJNXJKzA/b6x9plEPZkTJp+zSNsg+HF/epkmMs3T/7s=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=IcgHpoal774oLnxVsvpzuP+qx5yJOoQSISSYJSVohGhINP6lu5vrWxEnT2UGig3OsE9DTG5Ut/BYKECLHZVKA3LJAR9tbXDrQMqns8nPLYAAWtSmE3Xr6emgMFyaaDou98ih6FyxlgdOuaYILCADA4XggdV8BNuofUYTQ057G98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53D26FEC;
	Wed, 18 Dec 2024 02:37:54 -0800 (PST)
Received: from [10.163.50.37] (unknown [10.163.50.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4226E3F720;
	Wed, 18 Dec 2024 02:37:23 -0800 (PST)
Message-ID: <ca5d8db3-b980-464f-8069-86bf769128e0@arm.com>
Date: Wed, 18 Dec 2024 16:07:21 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH V2 46/46] KVM: arm64: nv: Add trap forwarding for
 FEAT_FGT2 described registers
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-47-anshuman.khandual@arm.com>
 <87frmvsya0.wl-maz@kernel.org>
Content-Language: en-US
In-Reply-To: <87frmvsya0.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/10/24 14:35, Marc Zyngier wrote:
> On Tue, 10 Dec 2024 05:53:11 +0000,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>> Describe remaining MDCR_EL2 register, and associate that with all FEAT_FGT2
>> exposed system registers it allows to trap.
> 
> MDCR_EL2 register *bits*? How is that related to FGT2 at all?
> 
>>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Oliver Upton <oliver.upton@linux.dev>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: kvmarm@lists.linux.dev
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> Changes in V2:
>>
>> - Dropped check_cntr_accessible_N and CGT_CNTR_ACCESSIBLE_N constructs
>> - SYS_PMEVCNTSVR_EL1(N) access traps have been forwarded to CGT_MDCR_HPMN
>> - Updated check_mdcr_hpmn() to handle SYS_PMEVCNTSVR_EL1(N) registers
>> - Changed behaviour as BEHAVE_FORWARD_RW for CGT_MDCR_EnSPM
>>
>>  arch/arm64/include/asm/kvm_host.h |   2 +
>>  arch/arm64/kvm/emulate-nested.c   | 158 ++++++++++++++++++++++++++++++
>>  2 files changed, 160 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index c80c07be3358..4cdce62642d1 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -441,6 +441,7 @@ enum vcpu_sysreg {
>>  	PMINTENSET_EL1,	/* Interrupt Enable Set Register */
>>  	PMOVSSET_EL0,	/* Overflow Flag Status Set Register */
>>  	PMUSERENR_EL0,	/* User Enable Register */
>> +	SPMSELR_EL0,	/* System PMU Select Register */
> 
> How could a system PMU be relevant to a VM?  What is the point of
> bloating the vcpu for something that we will hopefully *never* make
> visible to guests?
> 
>>  
>>  	/* Pointer Authentication Registers in a strict increasing order. */
>>  	APIAKEYLO_EL1,
>> @@ -501,6 +502,7 @@ enum vcpu_sysreg {
>>  	CNTHP_CVAL_EL2,
>>  	CNTHV_CTL_EL2,
>>  	CNTHV_CVAL_EL2,
>> +	SPMACCESSR_EL2, /* System PMU Access Register */
> 
> Same here. It is pretty striking that these registers are never
> saved/restored or handled as traps, which is a good indication that
> this is pretty pointless.
> 
>>  
>>  	/* Anything from this can be RES0/RES1 sanitised */
>>  	MARKER(__SANITISED_REG_START__),
>> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
>> index 6c63cbfc11ea..c7d6d2034f27 100644
>> --- a/arch/arm64/kvm/emulate-nested.c
>> +++ b/arch/arm64/kvm/emulate-nested.c
>> @@ -79,6 +79,7 @@ enum cgt_group_id {
>>  	CGT_MDCR_TDRA,
>>  	CGT_MDCR_E2PB,
>>  	CGT_MDCR_TPMS,
>> +	CGT_MDCR_EnSPM,
>>  	CGT_MDCR_TTRF,
>>  	CGT_MDCR_E2TB,
>>  	CGT_MDCR_TDCC,
>> @@ -125,6 +126,7 @@ enum cgt_group_id {
>>  	CGT_CNTHCTL_EL1PCTEN = __COMPLEX_CONDITIONS__,
>>  	CGT_CNTHCTL_EL1PTEN,
>>  
>> +	CGT_SPMSEL_SPMACCESS,
>>  	CGT_CPTR_TTA,
>>  	CGT_MDCR_HPMN,
>>  
>> @@ -351,6 +353,12 @@ static const struct trap_bits coarse_trap_bits[] = {
>>  		.mask		= MDCR_EL2_TPMS,
>>  		.behaviour	= BEHAVE_FORWARD_RW,
>>  	},
>> +	[CGT_MDCR_EnSPM] = {
>> +		.index		= MDCR_EL2,
>> +		.value		= MDCR_EL2_EnSPM,
>> +		.mask		= MDCR_EL2_EnSPM,
>> +		.behaviour	= BEHAVE_FORWARD_RW,
>> +	},
>>  	[CGT_MDCR_TTRF] = {
>>  		.index		= MDCR_EL2,
>>  		.value		= MDCR_EL2_TTRF,
>> @@ -509,6 +517,7 @@ static enum trap_behaviour check_mdcr_hpmn(struct kvm_vcpu *vcpu)
>>  	switch (sysreg) {
>>  	case SYS_PMEVTYPERn_EL0(0) ... SYS_PMEVTYPERn_EL0(30):
>>  	case SYS_PMEVCNTRn_EL0(0) ... SYS_PMEVCNTRn_EL0(30):
>> +	case SYS_PMEVCNTSVR_EL1(0) ... SYS_PMEVCNTSVR_EL1(30):
>>  		idx = (sys_reg_CRm(sysreg) & 0x3) << 3 | sys_reg_Op2(sysreg);
>>  		break;
>>  	case SYS_PMXEVTYPER_EL0:
>> @@ -528,6 +537,22 @@ static enum trap_behaviour check_mdcr_hpmn(struct kvm_vcpu *vcpu)
>>  	return BEHAVE_HANDLE_LOCALLY;
>>  }
>>  
>> +static enum trap_behaviour check_spmsel_spmaccess(struct kvm_vcpu *vcpu)
>> +{
>> +	u64 spmaccessr_el2, spmselr_el2;
>> +	int syspmusel;
>> +
>> +	if (__vcpu_sys_reg(vcpu, MDCR_EL2) & MDCR_EL2_EnSPM) {
> 
> I don't mind the test, but I don't see any sanitising of MDCR_EL2 to
> make EnSPM as RES0 when FEAT_SPMU is not implemented, which will be
> 100% of the cases.
> 
>> +		spmselr_el2 = __vcpu_sys_reg(vcpu, SPMSELR_EL0);
>> +		spmaccessr_el2 = __vcpu_sys_reg(vcpu, SPMACCESSR_EL2);
> 
> So these two values are *guaranteed* to be zero. At this stage, what
> is the point?
> 
>> +		syspmusel = FIELD_GET(SPMSELR_EL0_SYSPMUSEL_MASK, spmselr_el2);
>> +
>> +		if (((spmaccessr_el2 >> (syspmusel * 2)) & 0x3) == 0x0)
>> +			return BEHAVE_FORWARD_RW;
> 
> What about value 0b01, which causes *writes* to be trapped?
> 
>> +	}
>> +	return BEHAVE_HANDLE_LOCALLY;
> 
> And then what? How do we handle this locally?
> 
> Honestly, short of any additional handling, we would be better off
> just injecting an UNDEF back into the guest.
> 
> 	M.
> 

Hello Marc,

Thanks for your review and apologies for the delayed response. I am still
processing some of your review comments, and need some more time to fully
understand them in the given context. I will get back to you after doing
some more reading.

- Anshuman
