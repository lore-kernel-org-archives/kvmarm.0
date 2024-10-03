Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8A21EA80
	for <kvmarm@lists.linux.dev>; Thu,  3 Oct 2024 04:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727928975; cv=none; b=u7kol6UsF5SAB6cHX/ecQp9UcmEZhTw2w/8xDoBeMcK97ygL0J+aBH8qCQ3PXzRdzdzhzQNiqWXqWLHJPtHypSF00d8a9CVEO+yE6dhbDOSAv66het25RCrMeEml3qOhuK01lHPE0p8EFuwCuAhun/dQNfzYM+JZ2KLu56yE8w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727928975; c=relaxed/simple;
	bh=4xDnWeCuXcvVb2LMvsZGEYaX9TMiLXgcTBGSPn5XnCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DARjE3tOZy7q1fpKyYK79K09Zu2AGvRxybHUrtjnDwtRQiCuSr2s45lwby3h2A8nNKHjOzwOtvN9nFXU+sGyf9hnEegX8Qf2DQ6dRtLr2uijtfHnfUc4PloWuD7T3tnxPWSsXmAOfzx7mQKMma7YMXr43Fg8ZpC4O1FvHFIjGnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83F5E339;
	Wed,  2 Oct 2024 21:16:42 -0700 (PDT)
Received: from [10.163.37.202] (unknown [10.163.37.202])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16D3B3F64C;
	Wed,  2 Oct 2024 21:16:09 -0700 (PDT)
Message-ID: <cae8c6ca-d999-4b93-a82d-7a1f9924fcee@arm.com>
Date: Thu, 3 Oct 2024 09:46:08 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 47/47] KVM: arm64: nv: Add trap forwarding for FEAT_FGT2
 described registers
To: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241001024356.1096072-1-anshuman.khandual@arm.com>
 <20241001024356.1096072-48-anshuman.khandual@arm.com>
 <ZvwLRWOKpggCvmH4@linux.dev>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <ZvwLRWOKpggCvmH4@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/1/24 20:16, Oliver Upton wrote:
> Hi Anshuman,
> 
> On Tue, Oct 01, 2024 at 08:13:56AM +0530, Anshuman Khandual wrote:
>> +#define check_cntr_accessible(num)						\
>> +static enum trap_behaviour check_cntr_accessible_##num(struct kvm_vcpu *vcpu)	\
>> +{										\
>> +	u64 mdcr_el2 = __vcpu_sys_reg(vcpu, MDCR_EL2);				\
>> +	int cntr = FIELD_GET(MDCR_EL2_HPMN_MASK, mdcr_el2);			\
>> +										\
>> +	if (num >= cntr)							\
>> +		return BEHAVE_FORWARD_ANY;					\
>> +	return BEHAVE_HANDLE_LOCALLY;						\
>> +}										\
>> +
>> +check_cntr_accessible(0)
>> +check_cntr_accessible(1)
>> +check_cntr_accessible(2)
>> +check_cntr_accessible(3)
>> +check_cntr_accessible(4)
>> +check_cntr_accessible(5)
>> +check_cntr_accessible(6)
>> +check_cntr_accessible(7)
>> +check_cntr_accessible(8)
>> +check_cntr_accessible(9)
>> +check_cntr_accessible(10)
>> +check_cntr_accessible(11)
>> +check_cntr_accessible(12)
>> +check_cntr_accessible(13)
>> +check_cntr_accessible(14)
>> +check_cntr_accessible(15)
>> +check_cntr_accessible(16)
>> +check_cntr_accessible(17)
>> +check_cntr_accessible(18)
>> +check_cntr_accessible(19)
>> +check_cntr_accessible(20)
>> +check_cntr_accessible(21)
>> +check_cntr_accessible(22)
>> +check_cntr_accessible(23)
>> +check_cntr_accessible(24)
>> +check_cntr_accessible(25)
>> +check_cntr_accessible(26)
>> +check_cntr_accessible(27)
>> +check_cntr_accessible(28)
>> +check_cntr_accessible(29)
>> +check_cntr_accessible(30)
> 
> I'd rather we not use templates for this problem. It bloats the kernel text
> as well as the trap encoding space.

Alright, fair point.

> 
> I have a patch in the nested PMU series that uses a single complex trap
> ID to evaluate HPMN, and derives the index from ESR_EL2. I think it
> could also be extended to the PMEVCNTSVR<n> range as well.

Just for reference - the mentioned complex trap ID function from the
given link below.

static enum trap_behaviour check_mdcr_hpmn(struct kvm_vcpu *vcpu)
{
	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
	unsigned int idx;


	switch (sysreg) {
	case SYS_PMEVTYPERn_EL0(0) ... SYS_PMEVTYPERn_EL0(30):
	case SYS_PMEVCNTRn_EL0(0) ... SYS_PMEVCNTRn_EL0(30):

---------------------------------------------------------------------
Just add the new system register range here ?

+	case SYS_PMEVCNTSVR_EL1(0)... SYS_PMEVCNTSVR_EL1(31):
---------------------------------------------------------------------

		idx = (sys_reg_CRm(sysreg) & 0x3) << 3 | sys_reg_Op2(sysreg);
		break;
	case SYS_PMXEVTYPER_EL0:
	case SYS_PMXEVCNTR_EL0:
		idx = __vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_PMU_COUNTER_MASK;
		break;
	default:
		/* Someone used this trap helper for something else... */
		KVM_BUG_ON(1, vcpu->kvm);
		return BEHAVE_HANDLE_LOCALLY;
	}

	/*
	 * Programming HPMN=0 is CONSTRAINED UNPREDICTABLE if FEAT_HPMN0 isn't
	 * implemented. Since KVM's ability to emulate HPMN=0 does not directly
	 * depend on hardware (all PMU registers are trapped), make the
	 * implementation choice that all counters are included in the second
	 * range reserved for EL2/EL3.
	 */
	return !(BIT(idx) & mask) ? (BEHAVE_FORWARD_RW | BEHAVE_IN_HOST_EL0) :
			BEHAVE_HANDLE_LOCALLY;
}

> 
> Also, keep in mind that the HPMN trap is annoying since it affects Host
> EL0 in addition to 'guest' ELs.

Does this require any more special handling other than the above complex trap
ID function ?

> 
> [*]: https://lore.kernel.org/kvmarm/20240827002235.1753237-9-oliver.upton@linux.dev/
> 
