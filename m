Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87CFD16F270
	for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 07:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718956585; cv=none; b=tIWKxvvXFc82YGCy5jDsTPJMLD3dPv0+MHlEGw4w2plYfKjoSww3yiBrnsI9dgSihrF1rOvegIXelS5+6UPHFiMUFmrYHgZkWvRnCjKT9oRi19XnYlikpclRwi2VQpe7HzmWLh+RdeLE0K0u75YHp3wkd5eweHvC1P9QjHHkY9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718956585; c=relaxed/simple;
	bh=EqkW8U9qaG/rNrFe2QZIhkSQ8hcYKQ5yfoYTrzM/kO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OQjoFq+SOMZouxeqZXNoyLe8C9LrF7RrUpN9Yj+oVd6kyZDnzFwpIGCMwfP1n/C9oSFR8plS3CgwKdbYQpn/RbVXFbiKQwKS9E+U0dYWpKlwBE+DbL2l9hgMGJKpauWtleQ9/vpyAE2lQAKV3U5CmlmO5NirlSw9Uu7R2rykGMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3D84339;
	Fri, 21 Jun 2024 00:56:46 -0700 (PDT)
Received: from [10.162.16.41] (a077893.blr.arm.com [10.162.16.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFA7B3F64C;
	Fri, 21 Jun 2024 00:56:18 -0700 (PDT)
Message-ID: <4d256df7-1ec7-4300-b5c8-355f46c0e869@arm.com>
Date: Fri, 21 Jun 2024 13:26:15 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 10/10] KVM: arm64: nv: Add new HDFGRTR2_GROUP &
 HDFGRTR2_GROUP based FGU handling
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240620065807.151540-1-anshuman.khandual@arm.com>
 <20240620065807.151540-11-anshuman.khandual@arm.com>
 <865xu3kh4r.wl-maz@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <865xu3kh4r.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/20/24 16:36, Marc Zyngier wrote:
> On Thu, 20 Jun 2024 07:58:07 +0100,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>> This adds new HDFGRTR2_GROUP and HDFGWTR2_GROUP groups in enum fgt_group_id
>> for FGU handling managed with HDFGRTR2_EL2 and HDFGWTR2_EL2 registers.
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
>>  arch/arm64/include/asm/kvm_arm.h        |  8 +++++
>>  arch/arm64/include/asm/kvm_host.h       |  2 ++
>>  arch/arm64/kvm/emulate-nested.c         | 14 ++++++++
>>  arch/arm64/kvm/hyp/include/hyp/switch.h | 10 ++++++
>>  arch/arm64/kvm/nested.c                 | 36 ++++++++++++++++++++
>>  arch/arm64/kvm/sys_regs.c               | 45 +++++++++++++++++++++++++
>>  6 files changed, 115 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index b2adc2c6c82a..b3fb368bcadb 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -354,6 +354,14 @@
>>  #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
>>  #define __HFGRTR_EL2_nMASK	~(__HFGRTR_EL2_RES0 | __HFGRTR_EL2_MASK)
>>  
>> +#define __HDFGRTR2_EL2_RES0	HDFGRTR2_EL2_RES0
>> +#define __HDFGRTR2_EL2_MASK	(GENMASK(22, 22) | GENMASK(20, 0))
> 
> How about bit 23? How comes you are considering all these bits as positive?

It had 23 earlier looking into DDI0601 2024-03 but then referred into ARM
ARM DDI 0487K.A which changed it as 22 - which was wrong, will change this
again if required.

> 
>> +#define __HDFGRTR2_EL2_nMASK	~(__HDFGRTR2_EL2_RES0 | __HDFGRTR2_EL2_MASK)
> 
> Note the *nMASK* here. 'n' is for *negative*. Just look at how
> __HDFGRTR_EL2_MASK and __HDFGRTR_EL2_nMASK are written.

Still trying to understand what does these three masks represent
for a given FGT register XXXX

	- __XXXX_RES0
	- __XXXX_MASK
	- __XXXX_nMASK

But from the mentioned example for HDFGRTR_EL2.

#define __HDFGRTR_EL2_RES0      HDFGRTR_EL2_RES0
#define __HDFGRTR_EL2_MASK      (BIT(63) | GENMASK(58, 50) | GENMASK(48, 43) | \
                                 GENMASK(41, 40) | GENMASK(37, 22) | \
                                 GENMASK(19, 9) | GENMASK(7, 0))
#define __HDFGRTR_EL2_nMASK     ~(__HDFGRTR_EL2_RES0 | __HDFGRTR_EL2_MASK)

Looking at HDFGRTR_EL2 definition inside arch/arm64/tools/sysreg

HDFGRTR_EL2_RES0 = BIT(49) | GENMASK(39, 38) | GENMASK(21, 20) | BIT(8)

is representing the entire mask in the register which are RES0. But then what
does __HDFGRTR_EL2_MASK signify ? Positive trap bits mask ?

The following bits belong in __HDFGRTR_EL2_MASK

HDFGRTR_EL2.PMBIDR_EL1    (63)
HDFGRTR_EL2.PMCEIDn_EL0   (58)

Where as the following bits belong in __HDFGRTR_EL2_nMASK

HDFGRTR_EL2.nPMSNEVFR_EL1 (61)
HDFGRTR_EL2.nBRBCTL	  (60) 

Reworking proposed HDFGRTR2_EL2 and HDFGWTR2_EL2. 

#define __HDFGRTR2_EL2_RES0     HDFGRTR2_EL2_RES0
#define __HDFGRTR2_EL2_MASK     0
#define __HDFGRTR2_EL2_nMASK    ~(__HDFGRTR2_EL2_RES0 | __HDFGRTR2_EL2_MASK)

#define __HDFGWTR2_EL2_RES0     HDFGWTR2_EL2_RES0
#define __HDFGWTR2_EL2_MASK     0
#define __HDFGWTR2_EL2_nMASK    ~(__HDFGWTR2_EL2_RES0 | __HDFGWTR2_EL2_MASK)

Please note that all trap bits in both these registers are negative ones
hence __HDFGRTR2_EL2_MASK/__HDFGWTR2_EL2_MASK should be 0.

> 
>> +
>> +#define __HDFGWTR2_EL2_RES0	HDFGWTR2_EL2_RES0
>> +#define __HDFGWTR2_EL2_MASK	(GENMASK(22, 19) | GENMASK(16, 7) | GENMASK(5, 0))
> 
> Again, how about bit 23? Same remark for the polarity.
> 
>> +#define __HDFGWTR2_EL2_nMASK	~(__HDFGWTR2_EL2_RES0 | __HDFGWTR2_EL2_MASK)
>> +
>>  /*
>>   * The HFGWTR bits are a subset of HFGRTR bits. To ensure we don't miss any
>>   * future additions, define __HFGWTR* macros relative to __HFGRTR* ones.
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 7b44e96e7270..d6fbd6ebc32d 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -239,6 +239,8 @@ enum fgt_group_id {
>>  	HDFGWTR_GROUP = HDFGRTR_GROUP,
>>  	HFGITR_GROUP,
>>  	HAFGRTR_GROUP,
>> +	HDFGRTR2_GROUP,
>> +	HDFGWTR2_GROUP = HDFGRTR2_GROUP,
>>  
>>  	/* Must be last */
>>  	__NR_FGT_GROUP_IDS__
>> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
>> index 54090967a335..bc5ea1e60a0a 100644
>> --- a/arch/arm64/kvm/emulate-nested.c
>> +++ b/arch/arm64/kvm/emulate-nested.c
>> @@ -1724,6 +1724,9 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
>>  	SR_FGT(SYS_AMEVCNTR0_EL0(2),	HAFGRTR, AMEVCNTR02_EL0, 1),
>>  	SR_FGT(SYS_AMEVCNTR0_EL0(1),	HAFGRTR, AMEVCNTR01_EL0, 1),
>>  	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
>> +
>> +	/* HDFGRTR2_EL2 */
>> +	SR_FGT(SYS_MDSELR_EL1,		HDFGRTR2, nMDSELR_EL1, 1),
> 
> No. See the 'n' prefix on this bit?

Right, that should be a 0 instead.

> 
> Also, where are all the other bits for the HDFRxTR2 registers?

This will require a number of new registers being added into tools sysreg
expanding the series further, but will go ahead add all that is required.
Although I had asked about this in the cover letter.

- Probably an entry is needed for SYS_MDSELR_EL1 in encoding_to_fgt[] table
  inside the file arch/arm64/kvm/emulate-nested.c, but while trying to test
  features for all individual bits in HDFGRTR2_EL2, it seemed a lot of new
  register definitions from various features need to be added as well, thus
  expanding the scope further. Should all required new system registers be
  added for completeness ?

> 
>>  };
>>  
>>  static union trap_config get_trap_config(u32 sysreg)
>> @@ -1979,6 +1982,10 @@ static bool check_fgt_bit(struct kvm *kvm, bool is_read,
>>  		sr = is_read ? HDFGRTR_EL2 : HDFGWTR_EL2;
>>  		break;
>>  
>> +	case HDFGRTR2_GROUP:
>> +		sr = is_read ? HDFGRTR2_EL2 : HDFGWTR2_EL2;
>> +		break;
>> +
>>  	case HAFGRTR_GROUP:
>>  		sr = HAFGRTR_EL2;
>>  		break;
>> @@ -2053,6 +2060,13 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
>>  			val = __vcpu_sys_reg(vcpu, HDFGWTR_EL2);
>>  		break;
>>  
>> +	case HDFGRTR2_GROUP:
>> +		if (is_read)
>> +			val = __vcpu_sys_reg(vcpu, HDFGRTR2_EL2);
>> +		else
>> +			val = __vcpu_sys_reg(vcpu, HDFGWTR2_EL2);
>> +		break;
>> +
>>  	case HAFGRTR_GROUP:
>>  		val = __vcpu_sys_reg(vcpu, HAFGRTR_EL2);
>>  		break;
>> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
>> index 0c4de44534b7..b5944aa6d9c8 100644
>> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
>> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
>> @@ -89,6 +89,10 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>>  		case HDFGWTR_EL2:					\
>>  			id = HDFGRTR_GROUP;				\
>>  			break;						\
>> +		case HDFGRTR2_EL2:					\
>> +		case HDFGWTR2_EL2:					\
>> +			id = HDFGRTR2_GROUP;				\
>> +			break;						\
>>  		case HAFGRTR_EL2:					\
>>  			id = HAFGRTR_GROUP;				\
>>  			break;						\
>> @@ -160,6 +164,8 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>>  	CHECK_FGT_MASKS(HDFGWTR_EL2);
>>  	CHECK_FGT_MASKS(HAFGRTR_EL2);
>>  	CHECK_FGT_MASKS(HCRX_EL2);
>> +	CHECK_FGT_MASKS(HDFGRTR2_EL2);
>> +	CHECK_FGT_MASKS(HDFGWTR2_EL2);
>>  
>>  	if (!cpus_have_final_cap(ARM64_HAS_FGT))
>>  		return;
>> @@ -171,6 +177,8 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>>  	update_fgt_traps(hctxt, vcpu, kvm, HFGITR_EL2);
>>  	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR_EL2);
>>  	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR_EL2);
>> +	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR2_EL2);
>> +	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR2_EL2);
>>  
>>  	if (cpu_has_amu())
>>  		update_fgt_traps(hctxt, vcpu, kvm, HAFGRTR_EL2);
>> @@ -200,6 +208,8 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>>  	__deactivate_fgt(hctxt, vcpu, kvm, HFGITR_EL2);
>>  	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR_EL2);
>>  	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR_EL2);
>> +	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR2_EL2);
>> +	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR2_EL2);
>>  
>>  	if (cpu_has_amu())
>>  		__deactivate_fgt(hctxt, vcpu, kvm, HAFGRTR_EL2);
>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>> index bae8536cbf00..ebe4e3972fed 100644
>> --- a/arch/arm64/kvm/nested.c
>> +++ b/arch/arm64/kvm/nested.c
>> @@ -384,6 +384,42 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
>>  		res0 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
>>  	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | HDFGRTR_EL2_RES0, res1);
>>  
>> +	/* HDFG[RW]TR2_EL2 */
>> +	res0 = res1 = 0;
>> +
>> +	/* FEAT_TRBE_MPAM is not exposed to the guest */
>> +	res0 |= HDFGRTR2_EL2_nTRBMPAM_EL1;
> 
> No. We are moving away from hard-coded features, so you have to
> explicitly check it.

The above code was just temporary for this RFC. But you are right, these
features need to be checked properly but there is a challenge. As I have
mentioned in the cover letter

- TRBIDR_EL1.MPAM needs to be probed for setting HDFGRTR2_EL2_nTRBMPAM_EL1
  but kvm_has_feat() does not operate a non-ID register which causes build
  warnings. The same problem exists for probing PMSIDR_EL1.FDS which is
  needed for setting HDFGRTR2_EL2_nPMSDSFR_EL1 as well. Currently both the
  bits mentioned earlier are set, assuming the features are not present in
  nested virtualization. Do we need some new helpers to probe these non-ID
  registers as well ?

How do you suggest we proceed on this - testing features in TRBIDR_EL1 and
PMSIDR_EL1 ?

> 
>> +
>> +	/* FEAT_SPE_FDS is not exposed to the guest */
>> +	res0 |= HDFGRTR2_EL2_nPMSDSFR_EL1;
> 
> Same thing.

Got it.

> 
>> +
>> +	if (!kvm_has_feat_enum(kvm, ID_AA64DFR2_EL1, STEP, IMP))
>> +		res0 |= HDFGRTR2_EL2_nMDSTEPOP_EL1;
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, ITE, IMP))
>> +		res0 |= HDFGRTR2_EL2_nTRCITECR_EL1;
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, SPMU, IMP))
>> +		res0 |= (HDFGRTR2_EL2_nSPMDEVAFF_EL1 | HDFGRTR2_EL2_nSPMID |
>> +			 HDFGRTR2_EL2_nSPMSCR_EL1 | HDFGRTR2_EL2_nSPMACCESSR_EL1 |
>> +			 HDFGRTR2_EL2_nSPMCR_EL0 | HDFGRTR2_EL2_nSPMOVS |
>> +			 HDFGRTR2_EL2_nSPMINTEN | HDFGRTR2_EL2_nSPMSELR_EL0 |
>> +			 HDFGRTR2_EL2_nSPMEVTYPERn_EL0 | HDFGRTR2_EL2_nSPMEVCNTRn_EL0 |
>> +			 HDFGRTR2_EL2_nPMSSCR_EL1 | HDFGRTR2_EL2_nPMSSDATA);
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, V8P9))
>> +		res0 |= HDFGRTR2_EL2_nMDSELR_EL1;
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9))
>> +		res0 |= HDFGRTR2_EL2_nPMUACR_EL1;
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP))
>> +		res0 |= HDFGRTR2_EL2_nPMICFILTR_EL0;
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP))
>> +		res0 |= HDFGRTR2_EL2_nPMICNTR_EL0;
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, SEBEP, IMP))
>> +		res0 |= HDFGRTR2_EL2_nPMIAR_EL1;
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, EBEP, IMP) &&
>> +	    !kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
>> +		res0 |= HDFGRTR2_EL2_nPMECR_EL1;
> 
> And all of that suffers from the same issue as in
> https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=next&id=eb9d53d4a949c6d6d7c9f130e537f6b5687fedf9

Alright, will set res1 instead for all these negative trap bits.
 
> 
> 
>> +	set_sysreg_masks(kvm, HDFGRTR2_EL2, res0 | HDFGRTR2_EL2_RES0, res1);
>> +	set_sysreg_masks(kvm, HDFGWTR2_EL2, res0 | HDFGWTR2_EL2_RES0, res1);
> 
> How about the HDFGxTR2_EL2_RES1 bits?

I assume you are suggesting something like this.

-       set_sysreg_masks(kvm, HDFGRTR2_EL2, res0 | HDFGRTR2_EL2_RES0, res1);
-       set_sysreg_masks(kvm, HDFGWTR2_EL2, res0 | HDFGWTR2_EL2_RES0, res1);
+       set_sysreg_masks(kvm, HDFGRTR2_EL2, res0 | HDFGRTR2_EL2_RES0, res1 | HDFGRTR2_EL2_RES1);
+       set_sysreg_masks(kvm, HDFGWTR2_EL2, res0 | HDFGWTR2_EL2_RES0, res1 | HDFGWTR2_EL2_RES1);

But guess both HDFGRTR2_EL2_RES1 and HDFGWTR2_EL2_RES1 will be empty (0) as there
are no res1 bit positions in either of these registers. But will change as above.

> 
>> +
>>  	/* Reuse the bits from the read-side and add the write-specific stuff */
>>  	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
>>  		res0 |= (HDFGWTR_EL2_PMCR_EL0 | HDFGWTR_EL2_PMSWINC_EL0);
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index f921af014d0c..8029f408855d 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -4110,6 +4110,51 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>>  		kvm->arch.fgu[HAFGRTR_GROUP] |= ~(HAFGRTR_EL2_RES0 |
>>  						  HAFGRTR_EL2_RES1);
>>  
>> +	/* FEAT_TRBE_MPAM is not exposed to the guest */
>> +	kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nTRBMPAM_EL1);
> 
> Same thing about dynamic configuration.
> 
> But more importantly, you are disabling anything *but* MPAM.  Does it
> seem right to you?

Did not get that, should the inverse ~ be dropped here and also for all
other negative trap bits across the register ?

> 
>> +
>> +	/* FEAT_SPE_FDS is not exposed to the guest */
>> +	kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nPMSDSFR_EL1);
> 
> Same thing.

As mentioned earlier there is a challenge in checking for the features
via non-ID registers i.e TRBIDR_EL1.MPAM and PMSIDR_EL1.FDS.

> 
>> +
>> +	if (!kvm_has_feat_enum(kvm, ID_AA64DFR2_EL1, STEP, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nMDSTEPOP_EL1);
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, ITE, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nTRCITECR_EL1);
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, SPMU, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nSPMDEVAFF_EL1		|
>> +						   HDFGRTR2_EL2_nSPMID			|
>> +						   HDFGRTR2_EL2_nSPMSCR_EL1		|
>> +						   HDFGRTR2_EL2_nSPMACCESSR_EL1		|
>> +						   HDFGRTR2_EL2_nSPMCR_EL0		|
>> +						   HDFGRTR2_EL2_nSPMOVS			|
>> +						   HDFGRTR2_EL2_nSPMINTEN		|
>> +						   HDFGRTR2_EL2_nSPMSELR_EL0		|
>> +						   HDFGRTR2_EL2_nSPMEVTYPERn_EL0	|
>> +						   HDFGRTR2_EL2_nSPMEVCNTRn_EL0		|
>> +						   HDFGRTR2_EL2_nPMSSCR_EL1		|
>> +						   HDFGRTR2_EL2_nPMSSDATA);
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, V8P9))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nMDSELR_EL1);
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nPMUACR_EL1);
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nPMICFILTR_EL0);
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nPMICNTR_EL0);
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, SEBEP, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nPMIAR_EL1);
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, EBEP, IMP) &&
>> +	    !kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nPMECR_EL1);
>> +
> 
> Overall, this looks completely broken.

I am re-working this patch as suggested. Thanks for the pointers.
