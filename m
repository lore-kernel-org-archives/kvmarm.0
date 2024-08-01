Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA610184536
	for <kvmarm@lists.linux.dev>; Thu,  1 Aug 2024 10:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722509193; cv=none; b=ZXJpPY80fvdtck8tQsWoOC8dRE5XgzfvsJVoMCoUHEU1BDiGqCuA6Kcxq9N9TLeVvu01o0fE0aNwmcF+fDddbfyhDE2jSMeUYNh5N4NB3hx9RB0pR7zWWH8YBifCM60G6BHx75W3wbAZgffiSf47xUCEeA/RZy9/anppldoBJt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722509193; c=relaxed/simple;
	bh=ygHwOj6pdGYHoaElzgefmef1wCC54a/cmBCbRmEUr0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PmyZU3Gz8bmbS0pVAa7c8SkJ6LykbvaY567SyZ4SlPnV1ARmkVqmWfxilp6fEoMt/5IleTeMF4hORMQePdSh1mMMUGOehCvTEIb/F4MsT6VG6k3Cz4SFkbeEYS2fY/O+PaHx2TP8DODF65ByPpybyBaj2a4eqb0+J9q3BRXBDik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B60EF15A1;
	Thu,  1 Aug 2024 03:46:53 -0700 (PDT)
Received: from [10.163.56.112] (unknown [10.163.56.112])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 657C73F5A1;
	Thu,  1 Aug 2024 03:46:24 -0700 (PDT)
Message-ID: <c84d0081-5afa-4bc2-82f4-a6dd07b8ab87@arm.com>
Date: Thu, 1 Aug 2024 16:16:22 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
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
 <878qyy35e5.wl-maz@kernel.org> <47dc4299-52cc-4f98-929b-fb86bd9757ae@arm.com>
 <86tthhi0nz.wl-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <86tthhi0nz.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/25/24 19:28, Marc Zyngier wrote:
> On Tue, 25 Jun 2024 10:03:29 +0100,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>>>>>> +#define __HDFGRTR2_EL2_nMASK	~(__HDFGRTR2_EL2_RES0 | __HDFGRTR2_EL2_MASK)
>>>>>
>>>>> Note the *nMASK* here. 'n' is for *negative*. Just look at how
>>>>> __HDFGRTR_EL2_MASK and __HDFGRTR_EL2_nMASK are written.
>>>>
>>>> Still trying to understand what does these three masks represent
>>>> for a given FGT register XXXX
>>>>
>>>> 	- __XXXX_RES0
>>>
>>> RES0 bits.
>>>
>>>> 	- __XXXX_MASK
>>>
>>> Positive trap bits.
>>>
>>>> 	- __XXXX_nMASK
>>>
>>> Negative trap bits.
>>
>> Right, figured that eventually but these were not very clear at
>> first.
> 
> I keep hearing I'm not clear. But at this stage, I don't know what to
> do to make it (or myself) clearer.
> 
>>
>>>
>>>>
>>>> But from the mentioned example for HDFGRTR_EL2.
>>>>
>>>> #define __HDFGRTR_EL2_RES0      HDFGRTR_EL2_RES0
>>>> #define __HDFGRTR_EL2_MASK      (BIT(63) | GENMASK(58, 50) | GENMASK(48, 43) | \
>>>>                                  GENMASK(41, 40) | GENMASK(37, 22) | \
>>>>                                  GENMASK(19, 9) | GENMASK(7, 0))
>>>> #define __HDFGRTR_EL2_nMASK     ~(__HDFGRTR_EL2_RES0 | __HDFGRTR_EL2_MASK)
>>>>
>>>> Looking at HDFGRTR_EL2 definition inside arch/arm64/tools/sysreg
>>>>
>>>> HDFGRTR_EL2_RES0 = BIT(49) | GENMASK(39, 38) | GENMASK(21, 20) | BIT(8)
>>>>
>>>> is representing the entire mask in the register which are RES0. But then what
>>>> does __HDFGRTR_EL2_MASK signify ? Positive trap bits mask ?
>>>>
>>>> The following bits belong in __HDFGRTR_EL2_MASK
>>>>
>>>> HDFGRTR_EL2.PMBIDR_EL1    (63)
>>>> HDFGRTR_EL2.PMCEIDn_EL0   (58)
>>>>
>>>> Where as the following bits belong in __HDFGRTR_EL2_nMASK
>>>>
>>>> HDFGRTR_EL2.nPMSNEVFR_EL1 (61)
>>>> HDFGRTR_EL2.nBRBCTL	  (60) 
>>>>
>>>> Reworking proposed HDFGRTR2_EL2 and HDFGWTR2_EL2. 
>>>>
>>>> #define __HDFGRTR2_EL2_RES0     HDFGRTR2_EL2_RES0
>>>> #define __HDFGRTR2_EL2_MASK     0
>>>> #define __HDFGRTR2_EL2_nMASK    ~(__HDFGRTR2_EL2_RES0 | __HDFGRTR2_EL2_MASK)
>>>>
>>>> #define __HDFGWTR2_EL2_RES0     HDFGWTR2_EL2_RES0
>>>> #define __HDFGWTR2_EL2_MASK     0
>>>> #define __HDFGWTR2_EL2_nMASK    ~(__HDFGWTR2_EL2_RES0 | __HDFGWTR2_EL2_MASK)
>>>>
>>>> Please note that all trap bits in both these registers are negative ones
>>>> hence __HDFGRTR2_EL2_MASK/__HDFGWTR2_EL2_MASK should be 0.
>>>
>>> That's because you're looking at the XML, and not the ARM ARM this was
>>> written against.
>>
>> Did not follow that. Both in ddi0601/2024-03 XML and ARM ARM DDI 0487K.a
>> there are no positive trap bits, either in HDFGRTR2_EL2 or HDFGWTR2_EL2.
>> OR did I miss something here.
> 
>>From this very file:
> 
> <quote>
> /*
>  * FGT register definitions
>  *
>  * RES0 and polarity masks as of DDI0487J.a, to be updated as needed.
>  * We're not using the generated masks as they are usually ahead of
>  * the published ARM ARM, which we use as a reference.
>  *
>  * Once we get to a point where the two describe the same thing, we'll
>  * merge the definitions. One day.
>  */
> </quote>
> 
> In case it wasn't written *CLEARLY* enough.
> 
>> Sure, will add the following new registers in arch/arm64/tools/sysreg format
>> except for the ones that require a formula based enumeration. Those will be
>> added into arch/arm64/include/asm/sysreg.h directly e.g
>>
>> +#define SYS_SPMEVCNTR_EL0(m)           sys_reg(2, 3, 14, (0 | (m >> 3)), (m & 7))
>> +#define SYS_SPMEVTYPER_EL0(m)          sys_reg(2, 3, 14, (2 | (m >> 3)), (m & 7))
>> +#define SYS_SPMEVFILTR_EL0(m)          sys_reg(2, 3, 14, (4 | (m >> 3)), (m & 7))
>> +#define SYS_SPMEVFILT2R_EL0(m)         sys_reg(2, 3, 14, (6 | (m >> 3)), (m & 7))
>>
>> 9d93fc432f1a arm64/sysreg: Add remaining debug registers affected by HDFGxTR2_EL2
>> 56b8830f0a5e arm64/sysreg: Add register fields for SPMCGCR1_EL1
>> ad674ae52178 arm64/sysreg: Add register fields for SPMCGCR0_EL1
>> 8538a282d208 arm64/sysreg: Add register fields for PMZR_EL0
>> c88f0b8d898e arm64/sysreg: Add register fields for PMSSCR_EL1
>> 8788ad49b7b6 arm64/sysreg: Add register fields for SPMCFGR_EL1
>> 142de2bc3d7b arm64/sysreg: Add register fields for SPMDEVARCH_EL1
>> 3d903ba35e8c arm64/sysreg: Add register fields for SPMIIDR_EL1
>> 1a4db0b8b100 arm64/sysreg: Add register fields for PMICNTSVR_EL1
>> 6bee8f139ba5 arm64/sysreg: Add register fields for SPMSELR_EL0
>> b208ab4cd54d arm64/sysreg: Add register fields for SPMCNTENSET_EL0
>> 644abf522c8a arm64/sysreg: Add register fields for SPMCNTENCLR_EL0
>> fad9b7751359 arm64/sysreg: Add register fields for SPMINTENSET_EL1
>> c28299b8df76 arm64/sysreg: Add register fields for SPMINTENCLR_EL1
>> b9c283b27980 arm64/sysreg: Add register fields for SPMOVSSET_EL0
>> 03dd01a26c46 arm64/sysreg: Add register fields for SPMOVSCLR_EL0
>> c8a2f1b688de arm64/sysreg: Add register fields for SPMCR_EL0
>> 422ca4026aa7 arm64/sysreg: Add register fields for SPMACCESSR_EL1
>> d790b2570461 arm64/sysreg: Add register fields for SPMSCR_EL1
>> c2cdd0fecdcb arm64/sysreg: Add register fields for PMCCNTSVR_EL1
>> 3b793f3f07b8 arm64/sysreg: Add register fields for PMUACR_EL1
>> a1804742ee8c arm64/sysreg: Add register fields for PMICFILTR_EL0
>> c88476b9c52c arm64/sysreg: Add register fields for PMICNTR_EL0
>> 6d1520f3477b arm64/sysreg: Add register fields for PMECR_EL1
>> 257ea3ec7950 arm64/sysreg: Add register fields for PMIAR_EL1
>> a29f787102f0 arm64/sysreg: Add register fields for SPMDEVAFF_EL1
>> 3b7c4d4cf0eb arm64/sysreg: Add register fields for PMSDSFR_EL1
>> 2a14e5dc1903 arm64/sysreg: Add register fields for TRBMPAM_EL1
> 
> Have you done this by hand? Or have you used an automated generator
> that parses the XML?  If it's the former, please do the latter and
> compare the results.
> 
> [...]
> 
>>>
>>>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>>>> index f921af014d0c..8029f408855d 100644
>>>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>>>> @@ -4110,6 +4110,51 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>>>>>>  		kvm->arch.fgu[HAFGRTR_GROUP] |= ~(HAFGRTR_EL2_RES0 |
>>>>>>  						  HAFGRTR_EL2_RES1);
>>>>>>  
>>>>>> +	/* FEAT_TRBE_MPAM is not exposed to the guest */
>>>>>> +	kvm->arch.fgu[HDFGRTR2_GROUP] |= ~(HDFGRTR2_EL2_nTRBMPAM_EL1);
>>>>>
>>>>> Same thing about dynamic configuration.
>>>>>
>>>>> But more importantly, you are disabling anything *but* MPAM.  Does it
>>>>> seem right to you?
>>>>
>>>> Did not get that, should the inverse ~ be dropped here and also for all
>>>> other negative trap bits across the register ?
>>>
>>> Look at the way FGU works. A bit set to 1 means that if we have
>>> trapped because of this bit (as per the FGT table), we inject an
>>> UNDEF.
>>
>> Seems like positive and negative trap bits do not make any difference
>> here, while setting respective bits in kvm->arch.fgu[HDFGRTR2_GROUP]. 
>> In this case the inverse should be dropped for all bits.
> 
> Yup, that's what "A bit set to 1" means here. We don't need to follow
> the convolutions of the HW here.
> 
>>
>> Should the lone trap bit (nPMZR_EL0) which is present in HDFGWTR2_EL2
>> but not in HDFGRTR2_EL2, be set in kvm->arch.fgu[HDFGWTR2_GROUP] as
>> well ?
>>
>> if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9)) {
>> 	kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMUACR_EL1;
>> 	kvm->arch.fgu[HDFGWTR2_GROUP] |= HDFGWTR2_EL2_nPMZR_EL0;
>> }
> 
> Possibly. At the time this code was written, ARMv8.9 wasn't in the ARM
> ARM.
Hello Marc,

As you had suggested to avoid posting the entire series (which now consists
of around ~30 patches just for all required sysregs update) to get the core
part of FGT2 reviewed, please find the updated last patch here. I will post
the entire series once there is some agreement on this patch. Thank you.

Changes from RFC V1:

- Updated positive and negative masks for HDFGRTR2_EL2 and HDFGWTR2_EL2
	- Both register's positive masks are 0 (all bits are nFormat)
	- Both register's negative masks are all bits but the RES0 ones
	- Please note that sysreg field definitions for both registers
	  were added into tools are from 2024-06 XML not ARM DDI 0487K.a
	- Even if ARM DDI 0487K.a gets used instead of the above XML,
	  there are no positive mask bits, only RES0 mask will expand.

- Only nPMZR_EL0 gets added for HDFGWTR2_EL2 in encoding_to_fgt()
	- Follows the same pattern as in HDFGWTR_EL2/HDFGWTR_EL2
	- All other entries are for HDFGRTR2_EL2

- Used indirect features check for FEAT_TRBE_MPAM and FEAT_SPE_FDS
- Updated kvm_init_nv_sysregs() as required
- Updated kvm_calculate_traps() as required

- Anshuman

-------->8----------------------------------------------------------------
From c1e648dcdb603ad182bcd522ca489f7deee58e86 Mon Sep 17 00:00:00 2001
From: Anshuman Khandual <anshuman.khandual@arm.com>
Date: Mon, 8 Apr 2024 12:15:35 +0530
Subject: [PATCH] KVM: arm64: nv: Add new HDFGRTR2_GROUP & HDFGRTR2_GROUP based
 FGU handling

This adds new HDFGRTR2_GROUP and HDFGWTR2_GROUP groups in enum fgt_group_id
for FGU handling managed with HDFGRTR2_EL2 and HDFGWTR2_EL2 registers.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h        |   8 ++
 arch/arm64/include/asm/kvm_host.h       |   2 +
 arch/arm64/kvm/emulate-nested.c         | 158 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  10 ++
 arch/arm64/kvm/nested.c                 |  38 ++++++
 arch/arm64/kvm/sys_regs.c               |  49 ++++++++
 6 files changed, 265 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index d81cc746e0eb..66ebb2f8e0fa 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -353,6 +353,14 @@
 #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
 #define __HFGRTR_EL2_nMASK	~(__HFGRTR_EL2_RES0 | __HFGRTR_EL2_MASK)
 
+#define __HDFGRTR2_EL2_RES0	HDFGRTR2_EL2_RES0
+#define __HDFGRTR2_EL2_MASK	0
+#define __HDFGRTR2_EL2_nMASK	~(__HDFGRTR2_EL2_RES0 | __HDFGRTR2_EL2_MASK)
+
+#define __HDFGWTR2_EL2_RES0	HDFGWTR2_EL2_RES0
+#define __HDFGWTR2_EL2_MASK	0
+#define __HDFGWTR2_EL2_nMASK	~(__HDFGWTR2_EL2_RES0 | __HDFGWTR2_EL2_MASK)
+
 /*
  * The HFGWTR bits are a subset of HFGRTR bits. To ensure we don't miss any
  * future additions, define __HFGWTR* macros relative to __HFGRTR* ones.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 696bb07b4722..edf78ddb099f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -266,6 +266,8 @@ enum fgt_group_id {
 	HDFGWTR_GROUP = HDFGRTR_GROUP,
 	HFGITR_GROUP,
 	HAFGRTR_GROUP,
+	HDFGRTR2_GROUP,
+	HDFGWTR2_GROUP = HDFGRTR2_GROUP,
 
 	/* Must be last */
 	__NR_FGT_GROUP_IDS__
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05166eccea0a..bbeeb0ab758e 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1828,6 +1828,153 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_AMEVCNTR0_EL0(2),	HAFGRTR, AMEVCNTR02_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(1),	HAFGRTR, AMEVCNTR01_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
+
+	/*
+	 * HDFGWTR_EL2
+	 *
+	 * Although HDFGRTR2_EL2 and HDFGWTR2_EL2 registers largely
+	 * overlap in their bit assignment, there are a number of bits
+	 * that are RES0 on one side, and an actual trap bit on the
+	 * other.  The policy chosen here is to describe all the
+	 * read-side mappings, and only the write-side mappings that
+	 * differ from the read side, and the trap handler will pick
+	 * the correct shadow register based on the access type.
+	 */
+	SR_FGT(SYS_PMZR_EL0,		HDFGWTR2, nPMZR_EL0, 0),
+
+	/* HDFGRTR2_EL2 */
+	SR_FGT(SYS_MDSTEPOP_EL1,	HDFGRTR2, nMDSTEPOP_EL1, 0),
+	SR_FGT(SYS_TRBMPAM_EL1,		HDFGRTR2, nTRBMPAM_EL1, 0),
+	SR_FGT(SYS_TRCITECR_EL1,	HDFGRTR2, nTRCITECR_EL1, 0),
+	SR_FGT(SYS_PMSDSFR_EL1,		HDFGRTR2, nPMSDSFR_EL1, 0),
+	SR_FGT(SYS_SPMDEVAFF_EL1,	HDFGRTR2, nSPMDEVAFF_EL1, 0),
+
+	SR_FGT(SYS_SPMCGCR0_EL1,	HDFGRTR2, nSPMID, 0),
+	SR_FGT(SYS_SPMCGCR1_EL1,	HDFGRTR2, nSPMID, 0),
+	SR_FGT(SYS_SPMIIDR_EL1,		HDFGRTR2, nSPMID, 0),
+	SR_FGT(SYS_SPMDEVARCH_EL1,	HDFGRTR2, nSPMID, 0),
+	SR_FGT(SYS_SPMCFGR_EL1,		HDFGRTR2, nSPMID, 0),
+
+	SR_FGT(SYS_SPMSCR_EL1,		HDFGRTR2, nSPMSCR_EL1, 0),
+	SR_FGT(SYS_SPMACCESSR_EL1,	HDFGRTR2, nSPMACCESSR_EL1, 0),
+	SR_FGT(SYS_SPMCR_EL0,		HDFGRTR2, nSPMCR_EL0, 0),
+	SR_FGT(SYS_SPMOVSCLR_EL0,	HDFGRTR2, nSPMOVS, 0),
+	SR_FGT(SYS_SPMOVSSET_EL0,	HDFGRTR2, nSPMOVS, 0),
+	SR_FGT(SYS_SPMINTENCLR_EL1,	HDFGRTR2, nSPMINTEN, 0),
+	SR_FGT(SYS_SPMINTENSET_EL1,	HDFGRTR2, nSPMINTEN, 0),
+	SR_FGT(SYS_SPMCNTENCLR_EL0,	HDFGRTR2, nSPMCNTEN, 0),
+	SR_FGT(SYS_SPMCNTENSET_EL0,	HDFGRTR2, nSPMCNTEN, 0),
+	SR_FGT(SYS_SPMSELR_EL0,		HDFGRTR2, nSPMSELR_EL0, 0),
+
+	SR_FGT(SYS_SPMEVTYPER_EL0(0),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(1),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(2),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(3),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(4),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(5),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(6),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(7),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(8),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(9),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(10),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(11),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(12),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(13),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(14),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(15),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+
+	SR_FGT(SYS_SPMEVFILTR_EL0(0),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(1),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(2),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(3),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(4),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(5),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(6),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(7),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(8),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(9),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(10),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(11),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(12),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(13),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(14),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(15),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+
+	SR_FGT(SYS_SPMEVFILT2R_EL0(0),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(1),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(2),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(3),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(4),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(5),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(6),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(7),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(8),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(9),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(10),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(11),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(12),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(13),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(14),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(15),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+
+	SR_FGT(SYS_SPMEVCNTR_EL0(0),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(1),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(2),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(3),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(4),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(5),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(6),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(7),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(8),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(9),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(10),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(11),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(12),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(13),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(14),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(15),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+
+	SR_FGT(SYS_PMSSCR_EL1,		HDFGRTR2, nPMSSCR_EL1, 0),
+	SR_FGT(SYS_PMCCNTSVR_EL1,	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMICNTSVR_EL1,	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(0),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(1),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(2),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(3),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(4),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(5),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(6),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(7),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(8),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(9),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(10),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(11),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(12),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(13),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(14),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(15),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(16),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(17),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(18),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(19),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(20),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(21),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(22),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(23),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(24),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(25),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(26),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(27),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(28),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(29),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(30),	HDFGRTR2, nPMSSDATA, 0),
+
+	SR_FGT(SYS_MDSELR_EL1,		HDFGRTR2, nMDSELR_EL1, 0),
+	SR_FGT(SYS_PMUACR_EL1,		HDFGRTR2, nPMUACR_EL1, 0),
+	SR_FGT(SYS_PMICFILTR_EL0,	HDFGRTR2, nPMICFILTR_EL0, 0),
+	SR_FGT(SYS_PMICNTR_EL0,		HDFGRTR2, nPMICNTR_EL0, 0),
+	SR_FGT(SYS_PMIAR_EL1,		HDFGRTR2, nPMIAR_EL1, 0),
+	SR_FGT(SYS_PMECR_EL1,		HDFGRTR2, nPMECR_EL1, 0),
 };
 
 static union trap_config get_trap_config(u32 sysreg)
@@ -2083,6 +2230,10 @@ static bool check_fgt_bit(struct kvm *kvm, bool is_read,
 		sr = is_read ? HDFGRTR_EL2 : HDFGWTR_EL2;
 		break;
 
+	case HDFGRTR2_GROUP:
+		sr = is_read ? HDFGRTR2_EL2 : HDFGWTR2_EL2;
+		break;
+
 	case HAFGRTR_GROUP:
 		sr = HAFGRTR_EL2;
 		break;
@@ -2157,6 +2308,13 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 			val = __vcpu_sys_reg(vcpu, HDFGWTR_EL2);
 		break;
 
+	case HDFGRTR2_GROUP:
+		if (is_read)
+			val = __vcpu_sys_reg(vcpu, HDFGRTR2_EL2);
+		else
+			val = __vcpu_sys_reg(vcpu, HDFGWTR2_EL2);
+		break;
+
 	case HAFGRTR_GROUP:
 		val = __vcpu_sys_reg(vcpu, HAFGRTR_EL2);
 		break;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f59ccfe11ab9..af6c774d9202 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -89,6 +89,10 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 		case HDFGWTR_EL2:					\
 			id = HDFGRTR_GROUP;				\
 			break;						\
+		case HDFGRTR2_EL2:					\
+		case HDFGWTR2_EL2:					\
+			id = HDFGRTR2_GROUP;				\
+			break;						\
 		case HAFGRTR_EL2:					\
 			id = HAFGRTR_GROUP;				\
 			break;						\
@@ -160,6 +164,8 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	CHECK_FGT_MASKS(HDFGWTR_EL2);
 	CHECK_FGT_MASKS(HAFGRTR_EL2);
 	CHECK_FGT_MASKS(HCRX_EL2);
+	CHECK_FGT_MASKS(HDFGRTR2_EL2);
+	CHECK_FGT_MASKS(HDFGWTR2_EL2);
 
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
 		return;
@@ -171,6 +177,8 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	update_fgt_traps(hctxt, vcpu, kvm, HFGITR_EL2);
 	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR_EL2);
 	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR2_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR2_EL2);
 
 	if (cpu_has_amu())
 		update_fgt_traps(hctxt, vcpu, kvm, HAFGRTR_EL2);
@@ -200,6 +208,8 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	__deactivate_fgt(hctxt, vcpu, kvm, HFGITR_EL2);
 	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR_EL2);
 	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR2_EL2);
+	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR2_EL2);
 
 	if (cpu_has_amu())
 		__deactivate_fgt(hctxt, vcpu, kvm, HAFGRTR_EL2);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index de789e0f1ae9..32ac5342d340 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1146,6 +1146,44 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
 	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | HDFGRTR_EL2_RES0, res1);
 
+	/* HDFG[RW]TR2_EL2 */
+	res0 = res1 = 0;
+
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
+		res1 |= HDFGRTR2_EL2_nTRBMPAM_EL1;
+
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4))
+		res1 |= HDFGRTR2_EL2_nPMSDSFR_EL1;
+
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR2_EL1, STEP, IMP))
+		res1 |= HDFGRTR2_EL2_nMDSTEPOP_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, ITE, IMP))
+		res1 |= HDFGRTR2_EL2_nTRCITECR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, SPMU, IMP))
+		res1 |= (HDFGRTR2_EL2_nSPMDEVAFF_EL1 | HDFGRTR2_EL2_nSPMID |
+			 HDFGRTR2_EL2_nSPMSCR_EL1 | HDFGRTR2_EL2_nSPMACCESSR_EL1 |
+			 HDFGRTR2_EL2_nSPMCR_EL0 | HDFGRTR2_EL2_nSPMOVS |
+			 HDFGRTR2_EL2_nSPMINTEN | HDFGRTR2_EL2_nSPMCNTEN |
+			 HDFGRTR2_EL2_nSPMSELR_EL0 | HDFGRTR2_EL2_nSPMEVTYPERn_EL0 |
+			 HDFGRTR2_EL2_nSPMEVCNTRn_EL0);
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
+		res1 |=	(HDFGRTR2_EL2_nPMSSCR_EL1 | HDFGRTR2_EL2_nPMSSDATA);
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, V8P9))
+		res1 |= HDFGRTR2_EL2_nMDSELR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9))
+		res1 |= HDFGRTR2_EL2_nPMUACR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP))
+		res1 |= (HDFGRTR2_EL2_nPMICFILTR_EL0 | HDFGRTR2_EL2_nPMICNTR_EL0);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, SEBEP, IMP))
+		res1 |= HDFGRTR2_EL2_nPMIAR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, EBEP, IMP) &&
+	    !kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
+		res1 |= HDFGRTR2_EL2_nPMECR_EL1;
+	set_sysreg_masks(kvm, HDFGRTR2_EL2, res0 | HDFGRTR2_EL2_RES0, res1 | HDFGRTR2_EL2_RES1);
+	set_sysreg_masks(kvm, HDFGWTR2_EL2, res0 | HDFGWTR2_EL2_RES0, res1 | HDFGWTR2_EL2_RES1);
+
 	/* Reuse the bits from the read-side and add the write-specific stuff */
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
 		res0 |= (HDFGWTR_EL2_PMCR_EL0 | HDFGWTR_EL2_PMSWINC_EL0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4ea714dcb660..c971febcafab 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4610,6 +4610,55 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 		kvm->arch.fgu[HAFGRTR_GROUP] |= ~(HAFGRTR_EL2_RES0 |
 						  HAFGRTR_EL2_RES1);
 
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nTRBMPAM_EL1;
+
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMSDSFR_EL1;
+
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR2_EL1, STEP, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nMDSTEPOP_EL1;
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, ITE, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nTRCITECR_EL1;
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, SPMU, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nSPMDEVAFF_EL1	|
+						 HDFGRTR2_EL2_nSPMID		|
+						 HDFGRTR2_EL2_nSPMSCR_EL1	|
+						 HDFGRTR2_EL2_nSPMACCESSR_EL1	|
+						 HDFGRTR2_EL2_nSPMCR_EL0	|
+						 HDFGRTR2_EL2_nSPMOVS		|
+						 HDFGRTR2_EL2_nSPMINTEN		|
+						 HDFGRTR2_EL2_nSPMCNTEN		|
+						 HDFGRTR2_EL2_nSPMSELR_EL0	|
+						 HDFGRTR2_EL2_nSPMEVTYPERn_EL0	|
+						 HDFGRTR2_EL2_nSPMEVCNTRn_EL0;
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMSSCR_EL1	|
+						 HDFGRTR2_EL2_nPMSSDATA;
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, V8P9))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nMDSELR_EL1;
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9)) {
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMUACR_EL1;
+		kvm->arch.fgu[HDFGWTR2_GROUP] |= HDFGWTR2_EL2_nPMZR_EL0;
+	}
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP)) {
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMICFILTR_EL0;
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMICNTR_EL0;
+	}
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, SEBEP, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMIAR_EL1;
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, EBEP, IMP) &&
+	    !kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMECR_EL1;
+
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.25.1
