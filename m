Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB051DC745
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 08:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425319; cv=none; b=oD1j4Dae8pnXRZgmO7FxI/MeOBE5XRD4xzfRr76zw1I1rMwrTI6j6Db7gipgZfPFhTmo4bfvTuqNPzj14+QRJoHBv/UOztPZPpAqddTB0eoChmiMCgj+4qTHbXLjQW1kqWdoIW75YpV66VfzQTyRpjnzONBZr+hEzLLzMeTWZi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425319; c=relaxed/simple;
	bh=+26mOEZQWL2sesFz1H/XDGXnEAa1Bzahc8q7pZ00C8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VfRxhTUMVFkJSXl17pntgSznKpWbLCf0DpjnIZ3CgTxVyNZd6QaYzV1MLnZJ8tKbfChwSp8Mmc5s/W4XjaD+s0O7i4tTnhWOxhhkQCir5Y/yxoms9nhAiE3/zd7H5pyZMuDxXAmG95n+N8e7LAtFoDWArpvnh1kmsAGeuEc5/uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 305611007;
	Tue, 17 Dec 2024 00:49:02 -0800 (PST)
Received: from [10.162.16.49] (a077893.blr.arm.com [10.162.16.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D82F3F720;
	Tue, 17 Dec 2024 00:48:29 -0800 (PST)
Message-ID: <c64709f7-e1c6-482e-8665-912be50b15bd@arm.com>
Date: Tue, 17 Dec 2024 14:18:27 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 6/7] arm64/boot: Enable EL2 requirements for
 FEAT_Debugv8p9
To: Rob Herring <robh@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 kvmarm@lists.linux.dev, linux-doc@vger.kernel.org
References: <20241216040831.2448257-1-anshuman.khandual@arm.com>
 <20241216040831.2448257-7-anshuman.khandual@arm.com>
 <20241216234251.GA629562-robh@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20241216234251.GA629562-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/17/24 05:12, Rob Herring wrote:
> On Mon, Dec 16, 2024 at 09:38:30AM +0530, Anshuman Khandual wrote:
>> Fine grained trap control for MDSELR_EL1 register needs to be configured in
>> HDFGRTR2_EL2, and HDFGWTR2_EL2 registers when kernel enters at EL1, but EL2
>> is also present.
> 
> Shouldn't this be "when kernel enters at EL2, and EL3 is also present"?

AFAICT - HDFGRTR2_EL2 and HDFGWTR2_EL2 registers configure traps into EL2 when
accessed from EL1/EL0, provided all required EL3 trap controls are in place as
well. These EL2 based trap configs need to be set before the kernel finally
enters EL1. Although there is an assumption about EL3 based trap configs being
in place, do we need to mention that in commit message as well. Is not updating 
booting.rst takes care of all EL3 requirements.

> Though it is really "If EL3 set FGTEn2 and the kernel is entered in 
> EL2, then FGT2 must be initialized for MDSELR_EL1."
> 
> If it was me, I'd just plagarize what was written for prior FGT 
> commits for this code. :)

There are many commits that changed __init_el2_fgt() with different description
formats. Do you have particular one in mind which can be followed here ? :)

> 
>> This adds a new helper __init_el2_fgt2() initializing this
>> new FEAT_FGT2 based fine grained registers.
> 
> "This adds" is the same as saying "This patch/commit adds" which is well 
> documented to avoid. Use imperative "Add a new helper...". Though it is 
> clear from the diff that is what you are doing...

Sure, will fix it.

> 
> 
>> MDCR_EL2.EBWE needs to be enabled for additional (beyond 16) breakpoint and
>> watchpoint exceptions when kernel enters at EL1, but EL2 is also present.
>> This updates __init_el2_debug() as required for FEAT_Debugv8p9.
>>
>> While here, also update booting.rst with MDCR_EL3 and SCR_EL3 requirements.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Oliver Upton <oliver.upton@linux.dev>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: kvmarm@lists.linux.dev
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> Changes in V3:
>>
>> - Dropped MDCR_EL3.TDA boot requirement from documentation (separate series)
>> - Dropped MDCR_EL2_EBWE definition as MDCR_EL2 is now defined in tools sysreg
>>
>> https://lore.kernel.org/all/20241211065425.1106683-1-anshuman.khandual@arm.com/
>>
>>  Documentation/arch/arm64/booting.rst | 18 ++++++++++++++++++
>>  arch/arm64/include/asm/el2_setup.h   | 26 ++++++++++++++++++++++++++
>>  2 files changed, 44 insertions(+)
>>
>> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
>> index 3278fb4bf219..054cfe1cad18 100644
>> --- a/Documentation/arch/arm64/booting.rst
>> +++ b/Documentation/arch/arm64/booting.rst
>> @@ -288,6 +288,12 @@ Before jumping into the kernel, the following conditions must be met:
>>  
>>      - SCR_EL3.FGTEn (bit 27) must be initialised to 0b1.
>>  
>> +  For CPUs with the Fine Grained Traps (FEAT_FGT2) extension present:
>> +
>> +  - If EL3 is present and the kernel is entered at EL2:
>> +
>> +    - SCR_EL3.FGTEn2 (bit 59) must be initialised to 0b1.
>> +
>>    For CPUs with support for HCRX_EL2 (FEAT_HCX) present:
>>  
>>    - If EL3 is present and the kernel is entered at EL2:
>> @@ -322,6 +328,18 @@ Before jumping into the kernel, the following conditions must be met:
>>      - ZCR_EL2.LEN must be initialised to the same value for all CPUs the
>>        kernel will execute on.
>>  
>> +  For CPUs with FEAT_Debugv8p9 extension present:
>> +
>> +  - If the kernel is entered at EL1 and EL2 is present:
>> +
>> +    - HDFGRTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
>> +    - HDFGWTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
>> +    - MDCR_EL2.EBWE (bit 43) must be initialized to 0b1
>> +
>> +  - If EL3 is present:
>> +
>> +    - MDCR_EL3.EBWE (bit 43) must be initialized to 0b1
>> +
>>    For CPUs with the Scalable Matrix Extension (FEAT_SME):
>>  
>>    - If EL3 is present:
>> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
>> index 4ef52d7245bb..2fbfe27d38b5 100644
>> --- a/arch/arm64/include/asm/el2_setup.h
>> +++ b/arch/arm64/include/asm/el2_setup.h
>> @@ -105,6 +105,13 @@
>>  						// to own it.
>>  
>>  .Lskip_trace_\@:
>> +	mrs	x1, id_aa64dfr0_el1
>> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
>> +	cmp	x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
>> +	b.lt	.Lskip_dbg_v8p9_\@
>> +
>> +	orr	x2, x2, #MDCR_EL2_EBWE
>> +.Lskip_dbg_v8p9_\@:
>>  	msr	mdcr_el2, x2			// Configure debug traps
>>  .endm
>>  
>> @@ -244,6 +251,24 @@
>>  .Lskip_gcs_\@:
>>  .endm
>>  
>> +.macro __init_el2_fgt2
>> +	mrs	x1, id_aa64mmfr0_el1
>> +	ubfx	x1, x1, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
>> +	cmp	x1, #ID_AA64MMFR0_EL1_FGT_FGT2
> 
> We already read this field in __init_el2_fgt, shouldn't we leverage that 
> and move all this there rather than read the feature reg twice.

Should not __init_el2_fgt2() remain separate to contain all future FEAT_FGT2
related trap enabled/disable checks ? OTOH reading id_aa64mmfr0_el1 register
should improve some performance as well.

> 
>> +	b.lt	.Lskip_fgt2_\@
>> +
>> +	mrs	x1, id_aa64dfr0_el1
>> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
>> +	cmp	x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
>> +	b.lt	.Lskip_dbg_v8p9_\@
>> +
>> +	mov_q   x0, HDFGWTR2_EL2_nMDSELR_EL1
>> +	msr_s	SYS_HDFGWTR2_EL2, x0
>> +	msr_s	SYS_HDFGRTR2_EL2, x0
> 
> If Debug v8.9 is not present, but FGT2 is, shouldn't we write 0 to these 
> registers? That is what we do for FGT.

Just to summerize what's being done in __init_el2_fgt()

.macro __init_el2_fgt
	...............
	mov     x0, xzr
	...............
.Lskip_spe_fgt_\@:
        msr_s   SYS_HDFGRTR_EL2, x0
        msr_s   SYS_HDFGWTR_EL2, x0
	...............
.Lset_fgt_\@:
        msr_s   SYS_HFGRTR_EL2, x0
        msr_s   SYS_HFGWTR_EL2, x0
        msr_s   SYS_HFGITR_EL2, xzr
	...............

If the relevant features are not present and their traps need not be handled,
all FEAT_FGT based trap control registers (SYS_HDFGRTR_EL2, SYS_HDFGWTR_EL2,
SYS_HFGRTR_EL2, SYS_HFGWTR_EL2 and SYS_HFGITR_EL2) get cleared. Hence same
needs to be done for all FEAT_FGT2 register as well. Fair enough, something
like the following makes sense ?

.macro __init_el2_fgt2
        mrs     x1, id_aa64mmfr0_el1
        ubfx    x1, x1, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
        cmp     x1, #ID_AA64MMFR0_EL1_FGT_FGT2
        b.lt    .Lskip_fgt2_\@

        mov     x0, xzr
        mrs     x1, id_aa64dfr0_el1
        ubfx    x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
        cmp     x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
        b.lt    .Lskip_dbg_v8p9_\@

        orr     x0, x0, #HDFGWTR2_EL2_nMDSELR_EL1
.Lskip_dbg_v8p9_\@:
        msr_s   SYS_HDFGWTR2_EL2, x0
        msr_s   SYS_HDFGRTR2_EL2, x0
        msr_s   SYS_HFGRTR2_EL2, xzr
        msr_s   SYS_HFGWTR2_EL2, xzr
        msr_s   SYS_HFGITR2_EL2, xzr
.Lskip_fgt2_\@:
.endm

Just wondering - following the same principle if clearing these FEAT_FGT2 trap
registers would make sense in itself, even without FEAT_Debugv8p9 enablement ?

Something like the commit

commit 31c00d2aeaa2da89361f5b64a64ca831433be5fc
Author: Mark Brown <broonie@kernel.org>
Date:   Thu Apr 1 19:09:40 2021 +0100

    arm64: Disable fine grained traps on boot
    
    The arm64 FEAT_FGT extension introduces a set of traps to EL2 for accesses
    to small sets of registers and instructions from EL1 and EL0.  Currently
    Linux makes no use of this feature, ensure that it is not active at boot by
    disabling the traps during EL2 setup.


> 
> 
> I just realized I forgot to add FGT2 setup for the PMUv3.9 features I 
> already added in 6.12 and 6.13. So this really needs to land sooner 
> rather than later to add that. 
Not sure if I got this correctly. Are you suggesting to carve out __init_el2_fgt2()
from the series and post separately with PMUv3.9 requirements and fallback clearing
for all FEAT_FGT2 trap config registers as mentioned above ?
