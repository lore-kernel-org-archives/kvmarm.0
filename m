Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7989C1DB45F
	for <kvmarm@lists.linux.dev>; Fri,  2 Aug 2024 09:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722590759; cv=none; b=fgvdrAO1AkwWlnAmEuNSkD3ojaQNZsWuaDiTyv+aDbxyUFvmszc52rIR/HS0nW0ZXKXcX2scIcU2odocAJ5Tz1lQ5VxsMFs9dI3nFajAk3/9AQ9VAQ91DqwjFguYlLi8MeLr/3trb46K5KCpmYgn4mRJHcIv3MxQX7NiYXjIcf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722590759; c=relaxed/simple;
	bh=+SlUGcMl0KL1n0hkkAFM10F6Ui4QVvHqZzdXc5MuFCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NI6LqmMWi0XLh+GaKAyQ1Sj5H8Yd6vA/G/0pyq1ht1JhJZeP49P9h9W16JraeGSEPuoqK7EPzqSW+1+6KyvHhv433blkzgsfcIN77o31J+AB3M97aKTElvAULEjtyCEkgSmN8E70zwP4T94yqfa5HsolbjFr+76cWPuG4gIteRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E4DA1007;
	Fri,  2 Aug 2024 02:26:16 -0700 (PDT)
Received: from [10.163.56.112] (unknown [10.163.56.112])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 625943F766;
	Fri,  2 Aug 2024 02:25:47 -0700 (PDT)
Message-ID: <d56735e2-3fee-4d91-84e1-a5b480ec0ce1@arm.com>
Date: Fri, 2 Aug 2024 14:55:44 +0530
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
 <86tthhi0nz.wl-maz@kernel.org> <c84d0081-5afa-4bc2-82f4-a6dd07b8ab87@arm.com>
 <86o76c1b8p.wl-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <86o76c1b8p.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/1/24 21:33, Marc Zyngier wrote:
> On Thu, 01 Aug 2024 11:46:22 +0100,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>> Hello Marc,
>>
>> As you had suggested to avoid posting the entire series (which now consists
>> of around ~30 patches just for all required sysregs update) to get the core
>> part of FGT2 reviewed, please find the updated last patch here. I will post
>> the entire series once there is some agreement on this patch. Thank
>> you.
> 
> Thanks for respining it in this form. Comments below.
> 
>>
>> Changes from RFC V1:
>>
>> - Updated positive and negative masks for HDFGRTR2_EL2 and HDFGWTR2_EL2
>> 	- Both register's positive masks are 0 (all bits are nFormat)
>> 	- Both register's negative masks are all bits but the RES0 ones
>> 	- Please note that sysreg field definitions for both registers
>> 	  were added into tools are from 2024-06 XML not ARM DDI 0487K.a
>> 	- Even if ARM DDI 0487K.a gets used instead of the above XML,
>> 	  there are no positive mask bits, only RES0 mask will expand.
>>
>> - Only nPMZR_EL0 gets added for HDFGWTR2_EL2 in encoding_to_fgt()
>> 	- Follows the same pattern as in HDFGWTR_EL2/HDFGWTR_EL2
>> 	- All other entries are for HDFGRTR2_EL2
>>
>> - Used indirect features check for FEAT_TRBE_MPAM and FEAT_SPE_FDS
>> - Updated kvm_init_nv_sysregs() as required
>> - Updated kvm_calculate_traps() as required
>>
>> - Anshuman
>>
>> -------->8----------------------------------------------------------------
>> From c1e648dcdb603ad182bcd522ca489f7deee58e86 Mon Sep 17 00:00:00 2001
>> From: Anshuman Khandual <anshuman.khandual@arm.com>
>> Date: Mon, 8 Apr 2024 12:15:35 +0530
>> Subject: [PATCH] KVM: arm64: nv: Add new HDFGRTR2_GROUP & HDFGRTR2_GROUP based
>>  FGU handling
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
>>  arch/arm64/include/asm/kvm_arm.h        |   8 ++
>>  arch/arm64/include/asm/kvm_host.h       |   2 +
>>  arch/arm64/kvm/emulate-nested.c         | 158 ++++++++++++++++++++++++
>>  arch/arm64/kvm/hyp/include/hyp/switch.h |  10 ++
>>  arch/arm64/kvm/nested.c                 |  38 ++++++
>>  arch/arm64/kvm/sys_regs.c               |  49 ++++++++
>>  6 files changed, 265 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index d81cc746e0eb..66ebb2f8e0fa 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -353,6 +353,14 @@
>>  #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
>>  #define __HFGRTR_EL2_nMASK	~(__HFGRTR_EL2_RES0 | __HFGRTR_EL2_MASK)
>>  
>> +#define __HDFGRTR2_EL2_RES0	HDFGRTR2_EL2_RES0
>> +#define __HDFGRTR2_EL2_MASK	0
>> +#define __HDFGRTR2_EL2_nMASK	~(__HDFGRTR2_EL2_RES0 | __HDFGRTR2_EL2_MASK)
>> +
>> +#define __HDFGWTR2_EL2_RES0	HDFGWTR2_EL2_RES0
>> +#define __HDFGWTR2_EL2_MASK	0
>> +#define __HDFGWTR2_EL2_nMASK	~(__HDFGWTR2_EL2_RES0 | __HDFGWTR2_EL2_MASK)
>> +
>>  /*
>>   * The HFGWTR bits are a subset of HFGRTR bits. To ensure we don't miss any
>>   * future additions, define __HFGWTR* macros relative to __HFGRTR* ones.
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 696bb07b4722..edf78ddb099f 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -266,6 +266,8 @@ enum fgt_group_id {
>>  	HDFGWTR_GROUP = HDFGRTR_GROUP,
>>  	HFGITR_GROUP,
>>  	HAFGRTR_GROUP,
>> +	HDFGRTR2_GROUP,
>> +	HDFGWTR2_GROUP = HDFGRTR2_GROUP,
>>  
>>  	/* Must be last */
>>  	__NR_FGT_GROUP_IDS__
>> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
>> index 05166eccea0a..bbeeb0ab758e 100644
>> --- a/arch/arm64/kvm/emulate-nested.c
>> +++ b/arch/arm64/kvm/emulate-nested.c
>> @@ -1828,6 +1828,153 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
>>  	SR_FGT(SYS_AMEVCNTR0_EL0(2),	HAFGRTR, AMEVCNTR02_EL0, 1),
>>  	SR_FGT(SYS_AMEVCNTR0_EL0(1),	HAFGRTR, AMEVCNTR01_EL0, 1),
>>  	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
>> +
>> +	/*
>> +	 * HDFGWTR_EL2
>> +	 *
>> +	 * Although HDFGRTR2_EL2 and HDFGWTR2_EL2 registers largely
>> +	 * overlap in their bit assignment, there are a number of bits
>> +	 * that are RES0 on one side, and an actual trap bit on the
>> +	 * other.  The policy chosen here is to describe all the
>> +	 * read-side mappings, and only the write-side mappings that
>> +	 * differ from the read side, and the trap handler will pick
>> +	 * the correct shadow register based on the access type.
>> +	 */
>> +	SR_FGT(SYS_PMZR_EL0,		HDFGWTR2, nPMZR_EL0, 0),
> 
> Be consistent with the existing order of registers. Writes are ordered
> after reads, and I'd like to preserve this.

Sure, will move this just after HDFGRTR2_EL2.

> 
>> +
>> +	/* HDFGRTR2_EL2 */
>> +	SR_FGT(SYS_MDSTEPOP_EL1,	HDFGRTR2, nMDSTEPOP_EL1, 0),
>> +	SR_FGT(SYS_TRBMPAM_EL1,		HDFGRTR2, nTRBMPAM_EL1, 0),
>> +	SR_FGT(SYS_TRCITECR_EL1,	HDFGRTR2, nTRCITECR_EL1, 0),
>> +	SR_FGT(SYS_PMSDSFR_EL1,		HDFGRTR2, nPMSDSFR_EL1, 0),
>> +	SR_FGT(SYS_SPMDEVAFF_EL1,	HDFGRTR2, nSPMDEVAFF_EL1, 0),
>> +
>> +	SR_FGT(SYS_SPMCGCR0_EL1,	HDFGRTR2, nSPMID, 0),
>> +	SR_FGT(SYS_SPMCGCR1_EL1,	HDFGRTR2, nSPMID, 0),
>> +	SR_FGT(SYS_SPMIIDR_EL1,		HDFGRTR2, nSPMID, 0),
>> +	SR_FGT(SYS_SPMDEVARCH_EL1,	HDFGRTR2, nSPMID, 0),
>> +	SR_FGT(SYS_SPMCFGR_EL1,		HDFGRTR2, nSPMID, 0),
>> +
>> +	SR_FGT(SYS_SPMSCR_EL1,		HDFGRTR2, nSPMSCR_EL1, 0),
> 
> That's a pretty odd one, as it only exists on the secure side. We will
> never see the access, as it will UNDEF at EL1, but hey, who cares.
> Let's take this as documentation.

Sure, will keep this unchanged.

> 
>> +	SR_FGT(SYS_SPMACCESSR_EL1,	HDFGRTR2, nSPMACCESSR_EL1, 0),
> 
> This (and I take it most of the stuff here) is also gated by
> MDCR_EL2.SPM, which is a coarse grained trap. That needs to be
> described as well. For every new register that you add here.

I did not find a SPM field in MDCR_EL2 either in latest ARM ARM or in
the latest XML. But as per current HDFGRTR2_EL2 description the field
nSPMACCESSR_EL1 is gated by FEAT_SPMU feature, which is being checked
via ID_AA64DFR1_EL1.PMU when required. So could you please give some
more details.

> 
>> +	SR_FGT(SYS_SPMCR_EL0,		HDFGRTR2, nSPMCR_EL0, 0),
>> +	SR_FGT(SYS_SPMOVSCLR_EL0,	HDFGRTR2, nSPMOVS, 0),
>> +	SR_FGT(SYS_SPMOVSSET_EL0,	HDFGRTR2, nSPMOVS, 0),
>> +	SR_FGT(SYS_SPMINTENCLR_EL1,	HDFGRTR2, nSPMINTEN, 0),
>> +	SR_FGT(SYS_SPMINTENSET_EL1,	HDFGRTR2, nSPMINTEN, 0),
>> +	SR_FGT(SYS_SPMCNTENCLR_EL0,	HDFGRTR2, nSPMCNTEN, 0),
>> +	SR_FGT(SYS_SPMCNTENSET_EL0,	HDFGRTR2, nSPMCNTEN, 0),
>> +	SR_FGT(SYS_SPMSELR_EL0,		HDFGRTR2, nSPMSELR_EL0, 0),
>> +
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(0),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(1),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(2),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(3),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(4),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(5),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(6),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(7),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(8),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(9),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(10),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(11),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(12),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(13),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(14),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVTYPER_EL0(15),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(0),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(1),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(2),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(3),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(4),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(5),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(6),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(7),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(8),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(9),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(10),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(11),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(12),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(13),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(14),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILTR_EL0(15),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(0),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(1),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(2),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(3),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(4),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(5),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(6),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(7),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(8),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(9),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(10),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(11),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(12),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(13),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(14),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVFILT2R_EL0(15),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
>> +
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(0),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(1),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(2),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(3),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(4),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(5),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(6),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(7),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(8),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(9),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(10),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(11),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(12),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(13),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(14),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +	SR_FGT(SYS_SPMEVCNTR_EL0(15),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
>> +
>> +	SR_FGT(SYS_PMSSCR_EL1,		HDFGRTR2, nPMSSCR_EL1, 0),
>> +	SR_FGT(SYS_PMCCNTSVR_EL1,	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMICNTSVR_EL1,	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(0),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(1),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(2),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(3),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(4),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(5),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(6),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(7),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(8),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(9),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(10),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(11),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(12),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(13),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(14),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(15),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(16),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(17),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(18),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(19),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(20),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(21),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(22),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(23),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(24),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(25),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(26),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(27),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(28),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(29),	HDFGRTR2, nPMSSDATA, 0),
>> +	SR_FGT(SYS_PMEVCNTSVR_EL1(30),	HDFGRTR2, nPMSSDATA, 0),
>> +
>> +	SR_FGT(SYS_MDSELR_EL1,		HDFGRTR2, nMDSELR_EL1, 0),
>> +	SR_FGT(SYS_PMUACR_EL1,		HDFGRTR2, nPMUACR_EL1, 0),
>> +	SR_FGT(SYS_PMICFILTR_EL0,	HDFGRTR2, nPMICFILTR_EL0, 0),
>> +	SR_FGT(SYS_PMICNTR_EL0,		HDFGRTR2, nPMICNTR_EL0, 0),
>> +	SR_FGT(SYS_PMIAR_EL1,		HDFGRTR2, nPMIAR_EL1, 0),
>> +	SR_FGT(SYS_PMECR_EL1,		HDFGRTR2, nPMECR_EL1, 0),
>>  };
>>  
>>  static union trap_config get_trap_config(u32 sysreg)
>> @@ -2083,6 +2230,10 @@ static bool check_fgt_bit(struct kvm *kvm, bool is_read,
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
>> @@ -2157,6 +2308,13 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
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
>> index f59ccfe11ab9..af6c774d9202 100644
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
>> index de789e0f1ae9..32ac5342d340 100644
>> --- a/arch/arm64/kvm/nested.c
>> +++ b/arch/arm64/kvm/nested.c
>> @@ -1146,6 +1146,44 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
>>  		res0 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
>>  	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | HDFGRTR_EL2_RES0, res1);
>>  
>> +	/* HDFG[RW]TR2_EL2 */
>> +	res0 = res1 = 0;
>> +
>> +	if (!kvm_has_feat_enum(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
>> +		res1 |= HDFGRTR2_EL2_nTRBMPAM_EL1;
> 
> I know I told you do use 'res1' here at some point, but I also told
> you that I was wrong in [1], and that this should be definitely be
> 'res0'. I'm really sorry to have led you down the wrong path, but
> that's a pretty minor change (see commit cb52b5c8b81).
> 
> [1] https://lore.kernel.org/kvmarm/86bk3c3uss.wl-maz@kernel.org/

Alright, will changes all that is res1 as res0.

> 
>> +
>> +	if (!kvm_has_feat_enum(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4))
>> +		res1 |= HDFGRTR2_EL2_nPMSDSFR_EL1;
>> +
>> +	if (!kvm_has_feat_enum(kvm, ID_AA64DFR2_EL1, STEP, IMP))
>> +		res1 |= HDFGRTR2_EL2_nMDSTEPOP_EL1;
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, ITE, IMP))
>> +		res1 |= HDFGRTR2_EL2_nTRCITECR_EL1;
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, SPMU, IMP))
>> +		res1 |= (HDFGRTR2_EL2_nSPMDEVAFF_EL1 | HDFGRTR2_EL2_nSPMID |
>> +			 HDFGRTR2_EL2_nSPMSCR_EL1 | HDFGRTR2_EL2_nSPMACCESSR_EL1 |
>> +			 HDFGRTR2_EL2_nSPMCR_EL0 | HDFGRTR2_EL2_nSPMOVS |
>> +			 HDFGRTR2_EL2_nSPMINTEN | HDFGRTR2_EL2_nSPMCNTEN |
>> +			 HDFGRTR2_EL2_nSPMSELR_EL0 | HDFGRTR2_EL2_nSPMEVTYPERn_EL0 |
>> +			 HDFGRTR2_EL2_nSPMEVCNTRn_EL0);
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
>> +		res1 |=	(HDFGRTR2_EL2_nPMSSCR_EL1 | HDFGRTR2_EL2_nPMSSDATA);
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, V8P9))
>> +		res1 |= HDFGRTR2_EL2_nMDSELR_EL1;
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9))
>> +		res1 |= HDFGRTR2_EL2_nPMUACR_EL1;
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP))
>> +		res1 |= (HDFGRTR2_EL2_nPMICFILTR_EL0 | HDFGRTR2_EL2_nPMICNTR_EL0);
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, SEBEP, IMP))
>> +		res1 |= HDFGRTR2_EL2_nPMIAR_EL1;
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, EBEP, IMP) &&
>> +	    !kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
>> +		res1 |= HDFGRTR2_EL2_nPMECR_EL1;
>> +	set_sysreg_masks(kvm, HDFGRTR2_EL2, res0 | HDFGRTR2_EL2_RES0, res1 | HDFGRTR2_EL2_RES1);
>> +	set_sysreg_masks(kvm, HDFGWTR2_EL2, res0 | HDFGWTR2_EL2_RES0, res1 | HDFGWTR2_EL2_RES1);
>> +
> 
> This is missing nPMZR_EL0, which should only apply to the write register.

I did realize that subsequently. Hence will changes it as the following
which adds HDFGWTR2_EL2_nPMZR_EL0 to res0 just before HDFGWTR2_EL2 gets
updated.

set_sysreg_masks(kvm, HDFGRTR2_EL2, res0 | HDFGRTR2_EL2_RES0, res1 | HDFGRTR2_EL2_RES1);
if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9))
	res0 |= HDFGWTR2_EL2_nPMZR_EL0;
set_sysreg_masks(kvm, HDFGWTR2_EL2, res0 | HDFGWTR2_EL2_RES0, res1 | HDFGWTR2_EL2_RES1);

> 
>>  	/* Reuse the bits from the read-side and add the write-specific stuff */
>>  	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
>>  		res0 |= (HDFGWTR_EL2_PMCR_EL0 | HDFGWTR_EL2_PMSWINC_EL0);
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 4ea714dcb660..c971febcafab 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -4610,6 +4610,55 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
>>  		kvm->arch.fgu[HAFGRTR_GROUP] |= ~(HAFGRTR_EL2_RES0 |
>>  						  HAFGRTR_EL2_RES1);
>>  
>> +	if (!kvm_has_feat_enum(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nTRBMPAM_EL1;
>> +
>> +	if (!kvm_has_feat_enum(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMSDSFR_EL1;
>> +
>> +	if (!kvm_has_feat_enum(kvm, ID_AA64DFR2_EL1, STEP, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nMDSTEPOP_EL1;
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, ITE, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nTRCITECR_EL1;
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, SPMU, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nSPMDEVAFF_EL1	|
>> +						 HDFGRTR2_EL2_nSPMID		|
>> +						 HDFGRTR2_EL2_nSPMSCR_EL1	|
>> +						 HDFGRTR2_EL2_nSPMACCESSR_EL1	|
>> +						 HDFGRTR2_EL2_nSPMCR_EL0	|
>> +						 HDFGRTR2_EL2_nSPMOVS		|
>> +						 HDFGRTR2_EL2_nSPMINTEN		|
>> +						 HDFGRTR2_EL2_nSPMCNTEN		|
>> +						 HDFGRTR2_EL2_nSPMSELR_EL0	|
>> +						 HDFGRTR2_EL2_nSPMEVTYPERn_EL0	|
>> +						 HDFGRTR2_EL2_nSPMEVCNTRn_EL0;
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMSSCR_EL1	|
>> +						 HDFGRTR2_EL2_nPMSSDATA;
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, V8P9))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nMDSELR_EL1;
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9)) {
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMUACR_EL1;
>> +		kvm->arch.fgu[HDFGWTR2_GROUP] |= HDFGWTR2_EL2_nPMZR_EL0;
> 
> The registers are different, but the *groups* are the same: if
> something UNDEFs for read, it also UNDEFs for write. So you can be
> consistent and use the 'read' name everywhere.

Sure, will change that as follows.

        if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9)) {
                kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMUACR_EL1;
                kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGWTR2_EL2_nPMZR_EL0;
        }

> 
> This is also consistent with what you add in kvm_host.h.

Agreed.

> 
>> +	}
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP)) {
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMICFILTR_EL0;
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMICNTR_EL0;
>> +	}
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, SEBEP, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMIAR_EL1;
>> +
>> +	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, EBEP, IMP) &&
>> +	    !kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
>> +		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMECR_EL1;
>> +
>>  	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
>>  out:
>>  	mutex_unlock(&kvm->arch.config_lock);
> 
> I haven't looked into the fine details, but overall, this looks much
> better.

Alright.

> 
> Now, the main issues are that:
> 
> - you're missing the coarse grained trapping for all the stuff you
>   have just added. It's not a huge amount of work, but you need, for
>   each register, to describe what traps apply to it. The fine grained
>   stuff is most, but not all of it. There should be enough of it
>   already to guide you through it.

Coarse grained trapping for FEAT_FGT2 based fine grained registers ?
Afraid, did not understand this. Could you please give some pointers
on similar existing code.

> 
> - this is all part of FEAT_FGT2, and that has some side effects:
>   HFGITR2_EL2, HFGRTR2_EL2, and HFGWTR2_EL2 must also be defined.
>   Thankfully, there is not much in them, so this should be much easier
>   than the above. But the architecture do not give us the option to
>   have two but not the others.

Sure, will incorporate and fold in changes required for remaining FEAT_FGT2
register i.e HFGITR2_EL2, HFGRTR2_EL2 and HFGWTR2_EL2. In fact could write
down some initial changes and it was manageable.

> 
> Once you have all that, we should be in a reasonable place.

Sure, thanks for the review.
