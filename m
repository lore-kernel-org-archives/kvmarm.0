Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD7F256C7D
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 06:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740464250; cv=none; b=IrEHwfR7zorsJD76ukbBDkEsZn0EL5IMtlR+kXX8d4i9xViW94D9TNMrUOn/H57yYDJJ7NXW5LT+egJe60qepD9UjG0Ej9YGUGmD9iQTfg9IohIe8CK8G1fKmW96luZofj+hXKg/ISgiDvXLlTFRuNGa9PJG6+s/jKMy28vYOfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740464250; c=relaxed/simple;
	bh=2shgGogTgLVnF/xDRmIJLUbUkEMcbxDsqRJUV2lIt5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lPycRBfWzlnnr3to+5r/Xw43/Qm4P/T2TZnW6gk7UqJ17z484bXWtAtWpaAZ0+8UhkcZBVU1mJr0tAUGZk2E9unMm355MjRU952jNIQ93jhQ2Yh5f1SNTxjwS08yaUb+o7QgDKiTtkw7XE6Svrm+Q3T8vhfKkXYYE60CVDP9ydc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 731C0152B;
	Mon, 24 Feb 2025 22:17:36 -0800 (PST)
Received: from [10.162.40.21] (a077893.blr.arm.com [10.162.40.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C42A73F673;
	Mon, 24 Feb 2025 22:17:15 -0800 (PST)
Message-ID: <2ca1dc13-cd5a-4597-9733-2343e05f53b3@arm.com>
Date: Tue, 25 Feb 2025 11:47:12 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 7/7] arm64/boot: Enable EL2 requirements for
 FEAT_PMUv3p9
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Mark Brown <robh@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, Eric Auger <eric.auger@redhat.com>,
 kvmarm@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250203050828.1049370-1-anshuman.khandual@arm.com>
 <20250203050828.1049370-8-anshuman.khandual@arm.com>
 <Z7x-EDH9QP7g4lC6@J2N7QTR9R3.cambridge.arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <Z7x-EDH9QP7g4lC6@J2N7QTR9R3.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/24/25 19:41, Mark Rutland wrote:
> On Mon, Feb 03, 2025 at 10:38:28AM +0530, Anshuman Khandual wrote:
>> FEAT_PMUv3p9 registers such as PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1
>> access from EL1 requires appropriate EL2 fine grained trap configuration
>> via FEAT_FGT2 based trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2.
>> Otherwise such register accesses will result in traps into EL2.
>>
>> Add a new helper __init_el2_fgt2() which initializes FEAT_FGT2 based fine
>> grained trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2 (setting the
>> bits nPMICNTR_EL0, nPMICFILTR_EL0 and nPMUACR_EL1) to enable access into
>> PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 registers.
>>
>> Also update booting.rst with SCR_EL3.FGTEn2 requirement for all FEAT_FGT2
>> based registers to be accessible in EL2.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Oliver Upton <oliver.upton@linux.dev>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: kvmarm@lists.linux.dev
>> Tested-by: Rob Herring (Arm) <robh@kernel.org>
>> Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  Documentation/arch/arm64/booting.rst | 18 ++++++++++++++++++
>>  arch/arm64/include/asm/el2_setup.h   | 25 +++++++++++++++++++++++++
>>  2 files changed, 43 insertions(+)
> 
> Three things to note here:
> 
> (1) I think this is missing some other necessary register configuration.
> 
>     From a quick scan, we also require MDCR_EL3.EnPM2 (bit [7]) to be
>     configured, which is not described in mainline nor here. If that

Will update the Documentation/arch/arm64/booting.rst.

>     resets to 0, then EL{2,1,0} accesses to a number of registers such
>     as PMUACR_EL1 may trap to EL3> 
>     AFAICT the boot-wrapper resets that bit to 0, so have we actually
>     tested all of this with the boot-wrapper? Does TF-A set this bit?

Right, boot wrapper resets the bit to 0. We will need the following changes
to set that up when PMUv3p9 is available. MDCR_EL3.EnPM2 also needs to be
set when FEAT_SPMU, FEAT_EBEP, FEAT_PMUv3_SS or FEAT_SPMU2 are implemented.
Should those features be checked here as well ?

--- a/arch/aarch64/include/asm/cpu.h
+++ b/arch/aarch64/include/asm/cpu.h
@@ -56,6 +56,7 @@
 #define MDCR_EL3_SBRBE_NOTRAP_NOPROHIBIT       (UL(3) << 32)
 #define MDCR_EL3_ENPMSN                                BIT(36)
 #define MDCR_EL3_EBWE                          BIT(43)
+#define MDCR_EL3_EnPM2                         BIT(7)
 
 #define SCR_EL3_RES1                   BITS(5, 4)
 #define SCR_EL3_NS                     BIT(0)
@@ -87,6 +88,7 @@
 #define ID_AA64DFR0_EL1_PMSVER         BITS(35, 32)
 #define ID_AA64DFR0_EL1_TRACEBUFFER    BITS(47, 44)
 #define ID_AA64DFR0_EL1_BRBE           BITS(55, 52)
+#define ID_AA64DFR0_EL1_PMUVER         BITS(11, 8)
 #define ID_AA64DFR0_EL1_DEBUGVER       BITS(3, 0)
 
 #define ID_AA64ISAR0_EL1_TME           BITS(27, 24)
diff --git a/arch/aarch64/init.c b/arch/aarch64/init.c
index 54e4cc4..fe7ed5f 100644
--- a/arch/aarch64/init.c
+++ b/arch/aarch64/init.c
@@ -152,6 +152,9 @@ static void cpu_init_el3(void)
        if (mrs_field(ID_AA64DFR0_EL1, DEBUGVER) >= 11)
                mdcr |= MDCR_EL3_EBWE;
 
+       if (mrs_field(ID_AA64DFR0_EL1, PMUVER) >= 0b1001)
+               mdcr |= MDCR_EL3_EnPM2;
+
        msr(MDCR_EL3, mdcr);
 
        if (mrs_field(ID_AA64PFR0_EL1, SVE)) {

MDCR_EL2.EnPM2 does not seem to be set on TFA either, will double check and
get it enabled.

> 
>     Are we sure we've cpatured *all* requirements for FEAT_PMUv3p9? i.e.
>     is there anything else that we've missed?


> 
> (2) This is a fix for !VHE support for PMUACR and ICNTR, where the host
>     may run at EL1 and consequently will be affected by fine grained
>     traps.
> 
>     So this probably needs a CC stable and/or fixes tag, and backport.

Fixes: 0bbff9ed8165 ("perf/arm_pmuv3: Add PMUv3.9 per counter EL0 access control")
Fixes: d8226d8cfbaf ("perf: arm_pmuv3: Add support for Armv9.4 PMU instruction counter")
Cc: stable@vger.kernel.org

But is there a particular stable tree this patch should be addressed ?

> 
> (3) As there's no KVM changes, this is only safe provided that the
>     registers affected by these fine grained traps are already
>     unconditionally trapped by other traps when running a vCPU.
> 
>     It looks like PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 are all
>     trapped by MDCR_EL2.TPM, so that should work as long as we emulate
>     the PMU. For direct access, FGT2 support will be a prerequisite.
> 
> Ideally, we'd have added support for FGT2 before the PMU functionality
> that implicitly depends upon it. We should pay more attention to trap
> controls in future.
> 
> Given (1) and (2) I think someone needs to look into this a bit more and
> figure out if this needs a fixup or a respin.

To summarize

- Update arm64/booting.rst regarding MDCR_EL3.EnPM2
- Add above mentioned "Fixes:" tag and "CC: stable"
- But should respin this patch or send a fix up instead ?

- Boot wrapper patch setting MDCR_EL3.EnPM2
- TFA patch setting MDCR_EL3.EnPM2

Is there anything else missing ?

> 
> Mark.
> 
>> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
>> index cad6fdc96b98..04d97a1d5ffa 100644
>> --- a/Documentation/arch/arm64/booting.rst
>> +++ b/Documentation/arch/arm64/booting.rst
>> @@ -288,6 +288,12 @@ Before jumping into the kernel, the following conditions must be met:
>>  
>>      - SCR_EL3.FGTEn (bit 27) must be initialised to 0b1.
>>  
>> +  For CPUs with the Fine Grained Traps 2 (FEAT_FGT2) extension present:
>> +
>> +  - If EL3 is present and the kernel is entered at EL2:
>> +
>> +    - SCR_EL3.FGTEn2 (bit 59) must be initialised to 0b1.
>> +
>>    For CPUs with support for HCRX_EL2 (FEAT_HCX) present:
>>  
>>    - If EL3 is present and the kernel is entered at EL2:
>> @@ -382,6 +388,18 @@ Before jumping into the kernel, the following conditions must be met:
>>  
>>      - SMCR_EL2.EZT0 (bit 30) must be initialised to 0b1.
>>  
>> +  For CPUs with the Performance Monitors Extension (FEAT_PMUv3p9):
>> +
>> + - If the kernel is entered at EL1 and EL2 is present:
>> +
>> +    - HDFGRTR2_EL2.nPMICNTR_EL0 (bit 2) must be initialised to 0b1.
>> +    - HDFGRTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
>> +    - HDFGRTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
>> +
>> +    - HDFGWTR2_EL2.nPMICNTR_EL0 (bit 2) must be initialised to 0b1.
>> +    - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
>> +    - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
>> +
>>    For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
>>  
>>    - If the kernel is entered at EL1 and EL2 is present:
>> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
>> index 25e162651750..1a0071faf57e 100644
>> --- a/arch/arm64/include/asm/el2_setup.h
>> +++ b/arch/arm64/include/asm/el2_setup.h
>> @@ -233,6 +233,30 @@
>>  .Lskip_fgt_\@:
>>  .endm
>>  
>> +.macro __init_el2_fgt2
>> +	mrs	x1, id_aa64mmfr0_el1
>> +	ubfx	x1, x1, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
>> +	cmp	x1, #ID_AA64MMFR0_EL1_FGT_FGT2
>> +	b.lt	.Lskip_fgt2_\@
>> +
>> +	mov	x0, xzr
>> +	mrs	x1, id_aa64dfr0_el1
>> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
>> +	cmp	x1, #ID_AA64DFR0_EL1_PMUVer_V3P9
>> +	b.lt	.Lskip_pmuv3p9_\@
>> +
>> +	orr	x0, x0, #HDFGRTR2_EL2_nPMICNTR_EL0
>> +	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
>> +	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
>> +.Lskip_pmuv3p9_\@:
>> +	msr_s   SYS_HDFGRTR2_EL2, x0
>> +	msr_s   SYS_HDFGWTR2_EL2, x0
>> +	msr_s   SYS_HFGRTR2_EL2, xzr
>> +	msr_s   SYS_HFGWTR2_EL2, xzr
>> +	msr_s   SYS_HFGITR2_EL2, xzr
>> +.Lskip_fgt2_\@:
>> +.endm
>> +
>>  .macro __init_el2_gcs
>>  	mrs_s	x1, SYS_ID_AA64PFR1_EL1
>>  	ubfx	x1, x1, #ID_AA64PFR1_EL1_GCS_SHIFT, #4
>> @@ -283,6 +307,7 @@
>>  	__init_el2_nvhe_idregs
>>  	__init_el2_cptr
>>  	__init_el2_fgt
>> +	__init_el2_fgt2
>>          __init_el2_gcs
>>  .endm
>>  
>> -- 
>> 2.25.1
>>
