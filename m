Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C15BB25B689
	for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 18:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386355; cv=none; b=Ce5UVO+qooNZbEEkEbZh/gQqJAeecKfPoxJA9lDS2n/RCrptZCpR3DpjrqoQHFNDWL8W/mxnJDfgX1X5GtBSWwni8YAzng+obmLOiJhfbJ9MsIim5ZXO1XPUP9p0/jzUYMl9Fwc/nhUnbIs2sZi7hGf8CS4NdSwBkE/0xETTl9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386355; c=relaxed/simple;
	bh=ZQz2wDiHbpxEQ/ba2T+aRTX+dXIYHn4rkX+/YB/MagY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kqs7TVjiUzYqzE8H8xdRsQ1o7Mqt8H/NCb/0cPSgrpnmtFykZi2ANhuFTgFADi0yMAO907MSL47bbw3uJVRumG89VdWJkUUu6Q6BD0OAsK28IpY7mOQx3OgA/xgz48BoJzAHwlnbJUVcXDtTvPYsfWjQXbriQNk5Ls2OYt9GBtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA44E12FC;
	Wed, 12 Feb 2025 10:52:53 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8007A3F58B;
	Wed, 12 Feb 2025 10:52:32 -0800 (PST)
Date: Wed, 12 Feb 2025 18:52:27 +0000
From: Leo Yan <leo.yan@arm.com>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v19 11/11] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
Message-ID: <20250212185227.GC235556@e132581.arm.com>
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-11-1c1300802385@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250202-arm-brbe-v19-v19-11-1c1300802385@kernel.org>

On Sun, Feb 02, 2025 at 06:43:05PM -0600, Rob Herring (Arm) wrote:
> 
> From: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> The ARMv9.2 architecture introduces the optional Branch Record Buffer
> Extension (BRBE), which records information about branches as they are
> executed into set of branch record registers. BRBE is similar to x86's
> Last Branch Record (LBR) and PowerPC's Branch History Rolling Buffer
> (BHRB).

[...]

> diff --git a/drivers/perf/arm_brbe.c b/drivers/perf/arm_brbe.c
> new file mode 100644
> index 000000000000..18eb9bfa1f9c
> --- /dev/null
> +++ b/drivers/perf/arm_brbe.c
> @@ -0,0 +1,794 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Branch Record Buffer Extension Driver.
> + *
> + * Copyright (C) 2022-2025 ARM Limited
> + *
> + * Author: Anshuman Khandual <anshuman.khandual@arm.com>
> + */
> +#include <linux/types.h>
> +#include <linux/bitmap.h>
> +#include <linux/perf/arm_pmu.h>
> +#include "arm_brbe.h"
> +
> +#define BRBFCR_EL1_BRANCH_FILTERS (BRBFCR_EL1_DIRECT   | \
> +                                  BRBFCR_EL1_INDIRECT | \
> +                                  BRBFCR_EL1_RTN      | \
> +                                  BRBFCR_EL1_INDCALL  | \
> +                                  BRBFCR_EL1_DIRCALL  | \
> +                                  BRBFCR_EL1_CONDDIR)
> +
> +/*
> + * BRBTS_EL1 is currently not used for branch stack implementation
> + * purpose but BRBCR_ELx.TS needs to have a valid value from all
> + * available options. BRBCR_ELx_TS_VIRTUAL is selected for this.
> + */
> +#define BRBCR_ELx_DEFAULT_TS      FIELD_PREP(BRBCR_ELx_TS_MASK, BRBCR_ELx_TS_VIRTUAL)
> +
> +/*
> + * BRBE Buffer Organization
> + *
> + * BRBE buffer is arranged as multiple banks of 32 branch record
> + * entries each. An individual branch record in a given bank could
> + * be accessed, after selecting the bank in BRBFCR_EL1.BANK and
> + * accessing the registers i.e [BRBSRC, BRBTGT, BRBINF] set with
> + * indices [0..31].
> + *
> + * Bank 0
> + *
> + *     ---------------------------------       ------
> + *     | 00 | BRBSRC | BRBTGT | BRBINF |       | 00 |
> + *     ---------------------------------       ------
> + *     | 01 | BRBSRC | BRBTGT | BRBINF |       | 01 |
> + *     ---------------------------------       ------
> + *     | .. | BRBSRC | BRBTGT | BRBINF |       | .. |
> + *     ---------------------------------       ------
> + *     | 31 | BRBSRC | BRBTGT | BRBINF |       | 31 |
> + *     ---------------------------------       ------
> + *
> + * Bank 1
> + *
> + *     ---------------------------------       ------
> + *     | 32 | BRBSRC | BRBTGT | BRBINF |       | 00 |
> + *     ---------------------------------       ------
> + *     | 33 | BRBSRC | BRBTGT | BRBINF |       | 01 |
> + *     ---------------------------------       ------
> + *     | .. | BRBSRC | BRBTGT | BRBINF |       | .. |
> + *     ---------------------------------       ------
> + *     | 63 | BRBSRC | BRBTGT | BRBINF |       | 31 |
> + *     ---------------------------------       ------
> + */
> +#define BRBE_BANK_MAX_ENTRIES  32
> +#define BRBE_MAX_BANK          2
> +#define BRBE_MAX_ENTRIES       (BRBE_BANK_MAX_ENTRIES * BRBE_MAX_BANK)

BRBE_MAX_BANK and BRBE_MAX_ENTRIES are not used.  Should remove them?

> +
> +struct brbe_regset {
> +       unsigned long brbsrc;
> +       unsigned long brbtgt;
> +       unsigned long brbinf;

Explicitly define as 'u64' type for 64-bit registers.

> +};
> +
> +#define PERF_BR_ARM64_MAX (PERF_BR_MAX + PERF_BR_NEW_MAX)
> +
> +struct brbe_hw_attr {
> +       int     brbe_version;
> +       int     brbe_cc;
> +       int     brbe_nr;
> +       int     brbe_format;
> +};
> +
> +#define BRBE_REGN_CASE(n, case_macro) \
> +       case n: case_macro(n); break
> +
> +#define BRBE_REGN_SWITCH(x, case_macro)                                \
> +       do {                                                    \
> +               switch (x) {                                    \
> +               BRBE_REGN_CASE(0, case_macro);                  \
> +               BRBE_REGN_CASE(1, case_macro);                  \
> +               BRBE_REGN_CASE(2, case_macro);                  \
> +               BRBE_REGN_CASE(3, case_macro);                  \
> +               BRBE_REGN_CASE(4, case_macro);                  \
> +               BRBE_REGN_CASE(5, case_macro);                  \
> +               BRBE_REGN_CASE(6, case_macro);                  \
> +               BRBE_REGN_CASE(7, case_macro);                  \
> +               BRBE_REGN_CASE(8, case_macro);                  \
> +               BRBE_REGN_CASE(9, case_macro);                  \
> +               BRBE_REGN_CASE(10, case_macro);                 \
> +               BRBE_REGN_CASE(11, case_macro);                 \
> +               BRBE_REGN_CASE(12, case_macro);                 \
> +               BRBE_REGN_CASE(13, case_macro);                 \
> +               BRBE_REGN_CASE(14, case_macro);                 \
> +               BRBE_REGN_CASE(15, case_macro);                 \
> +               BRBE_REGN_CASE(16, case_macro);                 \
> +               BRBE_REGN_CASE(17, case_macro);                 \
> +               BRBE_REGN_CASE(18, case_macro);                 \
> +               BRBE_REGN_CASE(19, case_macro);                 \
> +               BRBE_REGN_CASE(20, case_macro);                 \
> +               BRBE_REGN_CASE(21, case_macro);                 \
> +               BRBE_REGN_CASE(22, case_macro);                 \
> +               BRBE_REGN_CASE(23, case_macro);                 \
> +               BRBE_REGN_CASE(24, case_macro);                 \
> +               BRBE_REGN_CASE(25, case_macro);                 \
> +               BRBE_REGN_CASE(26, case_macro);                 \
> +               BRBE_REGN_CASE(27, case_macro);                 \
> +               BRBE_REGN_CASE(28, case_macro);                 \
> +               BRBE_REGN_CASE(29, case_macro);                 \
> +               BRBE_REGN_CASE(30, case_macro);                 \
> +               BRBE_REGN_CASE(31, case_macro);                 \
> +               default: WARN(1, "Invalid BRB* index %d\n", x); \
> +               }                                               \
> +       } while (0)
> +
> +#define RETURN_READ_BRBSRCN(n) \
> +       return read_sysreg_s(SYS_BRBSRC_EL1(n))
> +static inline u64 get_brbsrc_reg(int idx)
> +{
> +       BRBE_REGN_SWITCH(idx, RETURN_READ_BRBSRCN);
> +       return 0;
> +}
> +
> +#define RETURN_READ_BRBTGTN(n) \
> +       return read_sysreg_s(SYS_BRBTGT_EL1(n))
> +static u64 get_brbtgt_reg(int idx)
> +{
> +       BRBE_REGN_SWITCH(idx, RETURN_READ_BRBTGTN);
> +       return 0;
> +}
> +
> +#define RETURN_READ_BRBINFN(n) \
> +       return read_sysreg_s(SYS_BRBINF_EL1(n))
> +static u64 get_brbinf_reg(int idx)
> +{
> +       BRBE_REGN_SWITCH(idx, RETURN_READ_BRBINFN);
> +       return 0;
> +}
> +
> +static u64 brbe_record_valid(u64 brbinf)
> +{
> +       return FIELD_GET(BRBINFx_EL1_VALID_MASK, brbinf);
> +}
> +
> +static bool brbe_invalid(u64 brbinf)
> +{
> +       return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_NONE;
> +}
> +
> +static bool brbe_record_is_complete(u64 brbinf)
> +{
> +       return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_FULL;
> +}
> +
> +static bool brbe_record_is_source_only(u64 brbinf)
> +{
> +       return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_SOURCE;
> +}
> +
> +static bool brbe_record_is_target_only(u64 brbinf)
> +{
> +       return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_TARGET;
> +}
> +
> +static int brbinf_get_in_tx(u64 brbinf)
> +{
> +       return FIELD_GET(BRBINFx_EL1_T_MASK, brbinf);
> +}
> +
> +static int brbinf_get_mispredict(u64 brbinf)
> +{
> +       return FIELD_GET(BRBINFx_EL1_MPRED_MASK, brbinf);
> +}

I would expect the naming of brbinf_get_mispredict() will cause
confusion.  When the function returns 1, it means "Branch was
incorrectly predicted".

Maybe consider to use '!FIELD_GET(...)' for a reversed value?

> +
> +static int brbinf_get_lastfailed(u64 brbinf)
> +{
> +       return FIELD_GET(BRBINFx_EL1_LASTFAILED_MASK, brbinf);
> +}
> +
> +static u16 brbinf_get_cycles(u64 brbinf)
> +{
> +       u32 exp, mant, cycles;
> +       /*
> +        * Captured cycle count is unknown and hence
> +        * should not be passed on to userspace.
> +        */
> +       if (brbinf & BRBINFx_EL1_CCU)
> +               return 0;
> +
> +       exp = FIELD_GET(BRBINFx_EL1_CC_EXP_MASK, brbinf);
> +       mant = FIELD_GET(BRBINFx_EL1_CC_MANT_MASK, brbinf);
> +
> +       if (!exp)
> +               return mant;
> +
> +       cycles = (mant | 0x100) << (exp - 1);
> +
> +       return (cycles > U16_MAX) ? U16_MAX : cycles;

min(cycles, (u32)U16_MAX);

Please expect more comments in my tomorrow.

Thanks,
Leo
