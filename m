Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 757A8146587
	for <kvmarm@lists.linux.dev>; Tue, 25 Jun 2024 09:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719306220; cv=none; b=FUU943dnqjrsUj383jwols5fGQoR0f7UOE0SDfNd3Ri4D90BZAe4niRRwWb7M5Negjt1aX29wqiCNISFXNmnPi2ZezZkbGr03C0awPY/g2Dho3a0xW9nu4tKl3kMCsSOtBNUCHG5pfTxujuCp88IJSJMCP60zCATojJmsKfn3uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719306220; c=relaxed/simple;
	bh=QrwJ74v8Zrv3NZnUfa3biKI6h3sTNdlkXa3zZ8ujJT4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=MkImJIyvfUogg8+wkCWS3PAnixQ2ZKEoMxwlr3qv/2Xv2No5RdcIq17P+2JFXz2NK4X2Iz4y6uNnMqMnfcSUStLNzBW24e8rvYHSKtml1nmbeJkVohpEFhhW1lE8xt4b35Y/Drjf8RdOj8/DiSnQ6GU+KybH3I4W16/TrfWB054=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A851339;
	Tue, 25 Jun 2024 02:04:01 -0700 (PDT)
Received: from [10.163.47.172] (unknown [10.163.47.172])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 23DDD3F6A8;
	Tue, 25 Jun 2024 02:03:32 -0700 (PDT)
Message-ID: <47dc4299-52cc-4f98-929b-fb86bd9757ae@arm.com>
Date: Tue, 25 Jun 2024 14:33:29 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [RFC 10/10] KVM: arm64: nv: Add new HDFGRTR2_GROUP &
 HDFGRTR2_GROUP based FGU handling
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240620065807.151540-1-anshuman.khandual@arm.com>
 <20240620065807.151540-11-anshuman.khandual@arm.com>
 <865xu3kh4r.wl-maz@kernel.org> <4d256df7-1ec7-4300-b5c8-355f46c0e869@arm.com>
 <878qyy35e5.wl-maz@kernel.org>
Content-Language: en-US
In-Reply-To: <878qyy35e5.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/21/24 16:54, Marc Zyngier wrote:
> On Fri, 21 Jun 2024 08:56:15 +0100,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>> On 6/20/24 16:36, Marc Zyngier wrote:
>>> On Thu, 20 Jun 2024 07:58:07 +0100,
>>> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>>>
>>>> This adds new HDFGRTR2_GROUP and HDFGWTR2_GROUP groups in enum fgt_group_id
>>>> for FGU handling managed with HDFGRTR2_EL2 and HDFGWTR2_EL2 registers.
>>>>
>>>> Cc: Marc Zyngier <maz@kernel.org>
>>>> Cc: Oliver Upton <oliver.upton@linux.dev>
>>>> Cc: James Morse <james.morse@arm.com>
>>>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> Cc: kvmarm@lists.linux.dev
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>> ---
>>>>  arch/arm64/include/asm/kvm_arm.h        |  8 +++++
>>>>  arch/arm64/include/asm/kvm_host.h       |  2 ++
>>>>  arch/arm64/kvm/emulate-nested.c         | 14 ++++++++
>>>>  arch/arm64/kvm/hyp/include/hyp/switch.h | 10 ++++++
>>>>  arch/arm64/kvm/nested.c                 | 36 ++++++++++++++++++++
>>>>  arch/arm64/kvm/sys_regs.c               | 45 +++++++++++++++++++++++++
>>>>  6 files changed, 115 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>>>> index b2adc2c6c82a..b3fb368bcadb 100644
>>>> --- a/arch/arm64/include/asm/kvm_arm.h
>>>> +++ b/arch/arm64/include/asm/kvm_arm.h
>>>> @@ -354,6 +354,14 @@
>>>>  #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
>>>>  #define __HFGRTR_EL2_nMASK	~(__HFGRTR_EL2_RES0 | __HFGRTR_EL2_MASK)
>>>>  
>>>> +#define __HDFGRTR2_EL2_RES0	HDFGRTR2_EL2_RES0
>>>> +#define __HDFGRTR2_EL2_MASK	(GENMASK(22, 22) | GENMASK(20, 0))
>>>
>>> How about bit 23? How comes you are considering all these bits as positive?
>>
>> It had 23 earlier looking into DDI0601 2024-03 but then referred into ARM
>> ARM DDI 0487K.A which changed it as 22 - which was wrong, will change this
>> again if required.
> 
> I guess we're past that point now, and we should delete the comment
> that limits it to K.a. Anything that is published as part of the XML
> drop (DDI 0602) is now fair game.

Sure.

> 
>>
>>>
>>>> +#define __HDFGRTR2_EL2_nMASK	~(__HDFGRTR2_EL2_RES0 | __HDFGRTR2_EL2_MASK)
>>>
>>> Note the *nMASK* here. 'n' is for *negative*. Just look at how
>>> __HDFGRTR_EL2_MASK and __HDFGRTR_EL2_nMASK are written.
>>
>> Still trying to understand what does these three masks represent
>> for a given FGT register XXXX
>>
>> 	- __XXXX_RES0
> 
> RES0 bits.
> 
>> 	- __XXXX_MASK
> 
> Positive trap bits.
> 
>> 	- __XXXX_nMASK
> 
> Negative trap bits.

Right, figured that eventually but these were not very clear at first.

> 
>>
>> But from the mentioned example for HDFGRTR_EL2.
>>
>> #define __HDFGRTR_EL2_RES0      HDFGRTR_EL2_RES0
>> #define __HDFGRTR_EL2_MASK      (BIT(63) | GENMASK(58, 50) | GENMASK(48, 43) | \
>>                                  GENMASK(41, 40) | GENMASK(37, 22) | \
>>                                  GENMASK(19, 9) | GENMASK(7, 0))
>> #define __HDFGRTR_EL2_nMASK     ~(__HDFGRTR_EL2_RES0 | __HDFGRTR_EL2_MASK)
>>
>> Looking at HDFGRTR_EL2 definition inside arch/arm64/tools/sysreg
>>
>> HDFGRTR_EL2_RES0 = BIT(49) | GENMASK(39, 38) | GENMASK(21, 20) | BIT(8)
>>
>> is representing the entire mask in the register which are RES0. But then what
>> does __HDFGRTR_EL2_MASK signify ? Positive trap bits mask ?
>>
>> The following bits belong in __HDFGRTR_EL2_MASK
>>
>> HDFGRTR_EL2.PMBIDR_EL1    (63)
>> HDFGRTR_EL2.PMCEIDn_EL0   (58)
>>
>> Where as the following bits belong in __HDFGRTR_EL2_nMASK
>>
>> HDFGRTR_EL2.nPMSNEVFR_EL1 (61)
>> HDFGRTR_EL2.nBRBCTL	  (60) 
>>
>> Reworking proposed HDFGRTR2_EL2 and HDFGWTR2_EL2. 
>>
>> #define __HDFGRTR2_EL2_RES0     HDFGRTR2_EL2_RES0
>> #define __HDFGRTR2_EL2_MASK     0
>> #define __HDFGRTR2_EL2_nMASK    ~(__HDFGRTR2_EL2_RES0 | __HDFGRTR2_EL2_MASK)
>>
>> #define __HDFGWTR2_EL2_RES0     HDFGWTR2_EL2_RES0
>> #define __HDFGWTR2_EL2_MASK     0
>> #define __HDFGWTR2_EL2_nMASK    ~(__HDFGWTR2_EL2_RES0 | __HDFGWTR2_EL2_MASK)
>>
>> Please note that all trap bits in both these registers are negative ones
>> hence __HDFGRTR2_EL2_MASK/__HDFGWTR2_EL2_MASK should be 0.
> 
> That's because you're looking at the XML, and not the ARM ARM this was
> written against.

Did not follow that. Both in ddi0601/2024-03 XML and ARM ARM DDI 0487K.a
there are no positive trap bits, either in HDFGRTR2_EL2 or HDFGWTR2_EL2.
OR did I miss something here.

> 
>>
>>>
>>>> +
>>>> +#define __HDFGWTR2_EL2_RES0	HDFGWTR2_EL2_RES0
>>>> +#define __HDFGWTR2_EL2_MASK	(GENMASK(22, 19) | GENMASK(16, 7) | GENMASK(5, 0))
>>>
>>> Again, how about bit 23? Same remark for the polarity.
>>>
>>>> +#define __HDFGWTR2_EL2_nMASK	~(__HDFGWTR2_EL2_RES0 | __HDFGWTR2_EL2_MASK)
>>>> +
>>>>  /*
>>>>   * The HFGWTR bits are a subset of HFGRTR bits. To ensure we don't miss any
>>>>   * future additions, define __HFGWTR* macros relative to __HFGRTR* ones.
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>> index 7b44e96e7270..d6fbd6ebc32d 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -239,6 +239,8 @@ enum fgt_group_id {
>>>>  	HDFGWTR_GROUP = HDFGRTR_GROUP,
>>>>  	HFGITR_GROUP,
>>>>  	HAFGRTR_GROUP,
>>>> +	HDFGRTR2_GROUP,
>>>> +	HDFGWTR2_GROUP = HDFGRTR2_GROUP,
>>>>  
>>>>  	/* Must be last */
>>>>  	__NR_FGT_GROUP_IDS__
>>>> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
>>>> index 54090967a335..bc5ea1e60a0a 100644
>>>> --- a/arch/arm64/kvm/emulate-nested.c
>>>> +++ b/arch/arm64/kvm/emulate-nested.c
>>>> @@ -1724,6 +1724,9 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
>>>>  	SR_FGT(SYS_AMEVCNTR0_EL0(2),	HAFGRTR, AMEVCNTR02_EL0, 1),
>>>>  	SR_FGT(SYS_AMEVCNTR0_EL0(1),	HAFGRTR, AMEVCNTR01_EL0, 1),
>>>>  	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
>>>> +
>>>> +	/* HDFGRTR2_EL2 */
>>>> +	SR_FGT(SYS_MDSELR_EL1,		HDFGRTR2, nMDSELR_EL1, 1),
>>>
>>> No. See the 'n' prefix on this bit?
>>
>> Right, that should be a 0 instead.
>>
>>>
>>> Also, where are all the other bits for the HDFRxTR2 registers?
>>
>> This will require a number of new registers being added into tools sysreg
>> expanding the series further, but will go ahead add all that is required.
> 
> Please do.

Sure, will add the following new registers in arch/arm64/tools/sysreg format
except for the ones that require a formula based enumeration. Those will be
added into arch/arm64/include/asm/sysreg.h directly e.g

+#define SYS_SPMEVCNTR_EL0(m)           sys_reg(2, 3, 14, (0 | (m >> 3)), (m & 7))
+#define SYS_SPMEVTYPER_EL0(m)          sys_reg(2, 3, 14, (2 | (m >> 3)), (m & 7))
+#define SYS_SPMEVFILTR_EL0(m)          sys_reg(2, 3, 14, (4 | (m >> 3)), (m & 7))
+#define SYS_SPMEVFILT2R_EL0(m)         sys_reg(2, 3, 14, (6 | (m >> 3)), (m & 7))

9d93fc432f1a arm64/sysreg: Add remaining debug registers affected by HDFGxTR2_EL2
56b8830f0a5e arm64/sysreg: Add register fields for SPMCGCR1_EL1
ad674ae52178 arm64/sysreg: Add register fields for SPMCGCR0_EL1
8538a282d208 arm64/sysreg: Add register fields for PMZR_EL0
c88f0b8d898e arm64/sysreg: Add register fields for PMSSCR_EL1
8788ad49b7b6 arm64/sysreg: Add register fields for SPMCFGR_EL1
142de2bc3d7b arm64/sysreg: Add register fields for SPMDEVARCH_EL1
3d903ba35e8c arm64/sysreg: Add register fields for SPMIIDR_EL1
1a4db0b8b100 arm64/sysreg: Add register fields for PMICNTSVR_EL1
6bee8f139ba5 arm64/sysreg: Add register fields for SPMSELR_EL0
b208ab4cd54d arm64/sysreg: Add register fields for SPMCNTENSET_EL0
644abf522c8a arm64/sysreg: Add register fields for SPMCNTENCLR_EL0
fad9b7751359 arm64/sysreg: Add register fields for SPMINTENSET_EL1
c28299b8df76 arm64/sysreg: Add register fields for SPMINTENCLR_EL1
b9c283b27980 arm64/sysreg: Add register fields for SPMOVSSET_EL0
03dd01a26c46 arm64/sysreg: Add register fields for SPMOVSCLR_EL0
c8a2f1b688de arm64/sysreg: Add register fields for SPMCR_EL0
422ca4026aa7 arm64/sysreg: Add register fields for SPMACCESSR_EL1
d790b2570461 arm64/sysreg: Add register fields for SPMSCR_EL1
c2cdd0fecdcb arm64/sysreg: Add register fields for PMCCNTSVR_EL1
3b793f3f07b8 arm64/sysreg: Add register fields for PMUACR_EL1
a1804742ee8c arm64/sysreg: Add register fields for PMICFILTR_EL0
c88476b9c52c arm64/sysreg: Add register fields for PMICNTR_EL0
6d1520f3477b arm64/sysreg: Add register fields for PMECR_EL1
257ea3ec7950 arm64/sysreg: Add register fields for PMIAR_EL1
a29f787102f0 arm64/sysreg: Add register fields for SPMDEVAFF_EL1
3b7c4d4cf0eb arm64/sysreg: Add register fields for PMSDSFR_EL1
2a14e5dc1903 arm64/sysreg: Add register fields for TRBMPAM_EL1

> 
>> Although I had asked about this in the cover letter.
>>
>> - Probably an entry is needed for SYS_MDSELR_EL1 in encoding_to_fgt[] table
>>   inside the file arch/arm64/kvm/emulate-nested.c, but while trying to test
>>   features for all individual bits in HDFGRTR2_EL2, it seemed a lot of new
>>   register definitions from various features need to be added as well, thus
>>   expanding the scope further. Should all required new system registers be
>>   added for completeness ?
> 
> Anything on which you expect KVM to interact with *must* be fully
> described.  I don't want to have to second guess the exception routing
> tables when we add support for a feature.> 
> In short, this is the end of half baked feature support in KVM. When
> you add support for a trap register, it comes with everything it
> traps, recursively.

Understood.
 
> 
> [...]
> 
>>>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>>>> index bae8536cbf00..ebe4e3972fed 100644
>>>> --- a/arch/arm64/kvm/nested.c
>>>> +++ b/arch/arm64/kvm/nested.c
>>>> @@ -384,6 +384,42 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
>>>>  		res0 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
>>>>  	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | HDFGRTR_EL2_RES0, res1);
>>>>  
>>>> +	/* HDFG[RW]TR2_EL2 */
>>>> +	res0 = res1 = 0;
>>>> +
>>>> +	/* FEAT_TRBE_MPAM is not exposed to the guest */
>>>> +	res0 |= HDFGRTR2_EL2_nTRBMPAM_EL1;
>>>
>>> No. We are moving away from hard-coded features, so you have to
>>> explicitly check it.
>>
>> The above code was just temporary for this RFC. But you are right, these
>> features need to be checked properly but there is a challenge. As I have
>> mentioned in the cover letter
> 
> You are wasting everybody's time with these RFCs. Either you *try* do
> the right thing from the first post, or you don't bother posting the
> patches. What's the point of posting them if you know this isn't
> right?
> 
> Writing these reviews take time and energy, and there is no shortage
> of this I'd rather do instead of having to write these emails. If you
> have questions, just ask. You don't need to dump 10 patches on the
> list for that.

Alright, as you prefer, in future will keep the questions in separate
emails instead, rather than with some RFC patches.

> 
>>
>> - TRBIDR_EL1.MPAM needs to be probed for setting HDFGRTR2_EL2_nTRBMPAM_EL1
>>   but kvm_has_feat() does not operate a non-ID register which causes build
>>   warnings. The same problem exists for probing PMSIDR_EL1.FDS which is
>>   needed for setting HDFGRTR2_EL2_nPMSDSFR_EL1 as well. Currently both the
>>   bits mentioned earlier are set, assuming the features are not present in
>>   nested virtualization. Do we need some new helpers to probe these non-ID
>>   registers as well ?
>>
>> How do you suggest we proceed on this - testing features in TRBIDR_EL1 and
>> PMSIDR_EL1 ?
> 
> Let's look at the spec.
> 
> For TRBMPAM_EL1 being implemented (from K.a):
> 
> * This register is present only when FEAT_TRBE_MPAM is
>   implemented. Otherwise, direct accesses to TRBMPAM_EL1 are
>   UNDEFINED.
> 
> * If FEAT_TRBE_MPAM is implemented, then FEAT_TRBE_EXT is implemented.
> 
> * The following fields identify the presence of FEAT_TRBE_EXT:
>   * ID_AA64DFR0_EL1.ExtTrcBuff.
> 
> This allows you do shortcut it one level above the particular MPAM
> requirement, which is good enough (I don't expect external traces to
> be exposed to a VM). Therefore no need to look at TRBIDR_EL1.

Sure, will check ID_AA64DFR0_EL1.ExtTrcBuff for FEAT_TRBE_MPAM instead.

> 
> For PMSDSFR_EL1 being implemented (from K.a):
> 
> * This register is present only when FEAT_SPE_FDS is
>   implemented. Otherwise, direct accesses to PMSDSFR_EL1 are
>   UNDEFINED.
> 
> * If FEAT_SPE_FDS is implemented, then FEAT_SPEv1p4 is implemented.
> 
> * The following field identifies the presence of FEAT_SPEv1p4:
>   * ID_AA64DFR0_EL1.PMSVer.
> 
> So again that's your cut-off point. Until we support this level of SPE
> in KVM, we're pretty safe (and I seriously doubt we'll get there in my
> lifetime, given the current pace of progress).

Okay, will check ID_AA64DFR0_EL1.PMSVer for FEAT_SPE_FDS instead.

Thanks for pointing out the feature check work arounds.

> 
> If at some point we need to support ID registers that are not in the
> feature range, we'll do that (Oliver has some stuff already for
> CTR_EL0).  But don't hardcode things.
> 
> [...]
> 
>>>> +	set_sysreg_masks(kvm, HDFGRTR2_EL2, res0 | HDFGRTR2_EL2_RES0, res1);
>>>> +	set_sysreg_masks(kvm, HDFGWTR2_EL2, res0 | HDFGWTR2_EL2_RES0, res1);
>>>
>>> How about the HDFGxTR2_EL2_RES1 bits?
>>
>> I assume you are suggesting something like this.
>>
>> -       set_sysreg_masks(kvm, HDFGRTR2_EL2, res0 | HDFGRTR2_EL2_RES0, res1);
>> -       set_sysreg_masks(kvm, HDFGWTR2_EL2, res0 | HDFGWTR2_EL2_RES0, res1);
>> +       set_sysreg_masks(kvm, HDFGRTR2_EL2, res0 | HDFGRTR2_EL2_RES0, res1 | HDFGRTR2_EL2_RES1);
>> +       set_sysreg_masks(kvm, HDFGWTR2_EL2, res0 | HDFGWTR2_EL2_RES0, res1 | HDFGWTR2_EL2_RES1);
>>
>> But guess both HDFGRTR2_EL2_RES1 and HDFGWTR2_EL2_RES1 will be empty (0) as there
>> are no res1 bit positions in either of these registers. But will change as above.
> 
> I don't care about these values being 0. I want the reassuring feeling
> that we're not missing anything, because debugging this is hell if you
> have a guest that sets/clears random bits.

Understood.

> 
> [...]
> 
>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>> index f921af014d0c..8029f408855d 100644
>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>> @@ -4110,6 +4110,51 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>>>>  		kvm->arch.fgu[HAFGRTR_GROUP] |= ~(HAFGRTR_EL2_RES0 |
>>>>  						  HAFGRTR_EL2_RES1);
>>>>  
>>>> +	/* FEAT_TRBE_MPAM is not exposed to the guest */
>>>> +	kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nTRBMPAM_EL1);
>>>
>>> Same thing about dynamic configuration.
>>>
>>> But more importantly, you are disabling anything *but* MPAM.  Does it
>>> seem right to you?
>>
>> Did not get that, should the inverse ~ be dropped here and also for all
>> other negative trap bits across the register ?
> 
> Look at the way FGU works. A bit set to 1 means that if we have
> trapped because of this bit (as per the FGT table), we inject an
> UNDEF.

Seems like positive and negative trap bits do not make any difference
here, while setting respective bits in kvm->arch.fgu[HDFGRTR2_GROUP]. 
In this case the inverse should be dropped for all bits.

Should the lone trap bit (nPMZR_EL0) which is present in HDFGWTR2_EL2
but not in HDFGRTR2_EL2, be set in kvm->arch.fgu[HDFGWTR2_GROUP] as
well ?

if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9)) {
	kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMUACR_EL1;
	kvm->arch.fgu[HDFGWTR2_GROUP] |= HDFGWTR2_EL2_nPMZR_EL0;
}

> 
>>
>>>
>>>> +
>>>> +	/* FEAT_SPE_FDS is not exposed to the guest */
>>>> +	kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nPMSDSFR_EL1);
>>>
>>> Same thing.
>>
>> As mentioned earlier there is a challenge in checking for the features
>> via non-ID registers i.e TRBIDR_EL1.MPAM and PMSIDR_EL1.FDS.
> 
> As I wrote, there is no problem. You always get enough ID-reg
> information to do something sensible. And if we need to eventually add
> the infrastructure for that, so be it.

Okay.

Thanks for the review and the related pointers.
