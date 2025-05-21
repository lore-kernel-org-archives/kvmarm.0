Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com [209.85.221.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D11822256B
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 16:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747843415; cv=none; b=GJIJn0W6w+MZk4ItOhs4LZenKRGrJa9jvgV7qgoCQJHzuOIXGYS9jSWL77NUHjE4PnuPRJpYPBU3VhGisE4dWqv70ZXm+zfv54eGr8yjvOSdw6whcWYCF/SBFSRe90Q9lX/dkaiqS9Gc1hKL2YEJKEC+CEt1JKVpXsp76fLo+Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747843415; c=relaxed/simple;
	bh=+G1fLnhlhXxr3ZvzaeMtgU9tO7CyP2QhZJSqVPjlpQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bi4y+JAiJIehHKfThQNWDDq9e5XU2qGRGd00+EXpVvBf+I/ztjT1IJgKm2im9mB86+kXP6BOiEdBZd8bLLfJC75CB+xlvw2zMUH2SlWoxl4zXcsEUsBWyV2aAUjNfk3PamwNnVnZ92xSVJXoUFLmF6yYeJ+AWj2TE6e01H+qhkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pxXKf470; arc=none smtp.client-ip=209.85.221.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pxXKf470"
Received: by mail-wr1-f66.google.com with SMTP id ffacd0b85a97d-3a367ec7840so2939747f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 09:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747843410; x=1748448210; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DU4DhTBi3w0I71OaugEdufXKgnJcnr7ZOAufcx7ncBk=;
        b=pxXKf470G4oiu7lKMv0nwrAG2t/GbXA7Dri9rDCbTnQvADnDXwHzw9nR3RJ6ywpMhs
         FmQ/oo5YJGtUcM55DdpQiMJYdpqDgYCXHi9H91jTnQR3fbIE9vqJEYtlywgTdS9hsz8M
         Yf2CdpG0037FHWLWcA+UuQ0Orvo45urqLoY/qWp6RqB4sPSEy/ahtGKTqCWfdRJtLlNz
         s76lIj9nn1LOlDTJfDjCPen7WOG3Zv7v3uf7WMQNzwTVKYprqISv5vDGJc2GoPadv5CX
         7kunrP5TOWwI2VLi15ZyRIYLrEGNdsUaPvE+FzVM1xT40ZRniPH1kcPO3njdef2PdgAQ
         scNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747843410; x=1748448210;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DU4DhTBi3w0I71OaugEdufXKgnJcnr7ZOAufcx7ncBk=;
        b=df6ce572lnR8ZdkP5j8eILHWikbr0CpRLeOM5sshfCj+ndClQy6z/CMoQxg+2V4/IY
         390RAD5YyHtzg0KEwUEXgNkth7/qaKr8eTEa0MD7Md0E6mascL5D2byi/Jg0znE1iNTX
         zOo3fa7l2+wx/KtwMnBU7F/3ICtlj3YPS6l3Vo0l8B82UViDSygccJ+Nzc7vq0VqFQYr
         SzgIvcOY4hDkHKfJ2InsG+0u4qhORVOhrQChqSsEQsrTYKiaMx0TAyRfeTyXJ44LjJhO
         Pn1yB1OQTYLOUz6sqDT81FD/LvkFGIm1zeccBaW9E9OHlZsEHJPHzhnz34SXtYk8Eu/G
         ip+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVdVEpuSYd2LIxPSujs8jOmY91+tx/Q0hVbHecRqvQFLP8XszfF3LrQSp7ztXI+iUIwiIeGxNE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSpB7T1dvfi7vNLQzrQQzTQjdzC0EMHApjLzQI+n8oZPSbNxLN
	+AIuwJp50PDv0w5yT8faLaIuJOzNeu0AiMLbeO1vEIyD9Ry+aqpO2VSSvUH0dm/TEzw=
X-Gm-Gg: ASbGncuvtw0UjpQYbHXq/BSuAW4JkPAivZVsNlsa0sqrZ3Z/Yqd6dGTR4w42JOP1yZm
	vcL/4GAm9TVhbaEK3ewNG6BMt3NvYHkUwRYDx3ZyWUktAoofkoU06d8rCV3UxK0TOJpaxdbbJqP
	9hkIzE1uJvBzwAjYJqxT1JqRzWlrQr7sJ9hNvWjUvG7w+mqFoLezcGKF6YKT1aqn9gryLUJ8wvO
	nqdwX+lm867RN3XHGUna7yZQOwLtFSGnVfHH1szDM+wtd8sfh70Tx/4Oabmp+R7pSHKJPvJN994
	i/Pt9VFEn5lFyorU1yvbVB0fbf5N16ON83yFbkW9kxOM8QSr2LCP1ozG
X-Google-Smtp-Source: AGHT+IEyoKY3tJdYtp+J+rpSWxW2aCfooQOr4u9kTfdzhat/VkGak9kEFjV0g/x//GNnE1pWPg2izg==
X-Received: by 2002:a05:6000:2901:b0:3a3:5c89:7a66 with SMTP id ffacd0b85a97d-3a35fe66207mr17376036f8f.4.1747843410137;
        Wed, 21 May 2025 09:03:30 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca4d263sm19819082f8f.3.2025.05.21.09.03.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 09:03:29 -0700 (PDT)
Message-ID: <925bf014-cea8-4cf0-9517-46291db729f2@linaro.org>
Date: Wed, 21 May 2025 17:03:28 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 5/5] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>
References: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
 <20250520-arm-brbe-v19-v22-5-c1ddde38e7f8@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20250520-arm-brbe-v19-v22-5-c1ddde38e7f8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 20/05/2025 11:27 pm, Rob Herring (Arm) wrote:
> The ARMv9.2 architecture introduces the optional Branch Record Buffer
> Extension (BRBE), which records information about branches as they are
> executed into set of branch record registers. BRBE is similar to x86's
> Last Branch Record (LBR) and PowerPC's Branch History Rolling Buffer
> (BHRB).
> 
> BRBE supports filtering by exception level and can filter just the
> source or target address if excluded to avoid leaking privileged
> addresses. The h/w filter would be sufficient except when there are
> multiple events with disjoint filtering requirements. In this case, BRBE
> is configured with a union of all the events' desired branches, and then
> the recorded branches are filtered based on each event's filter. For
> example, with one event capturing kernel events and another event
> capturing user events, BRBE will be configured to capture both kernel
> and user branches. When handling event overflow, the branch records have
> to be filtered by software to only include kernel or user branch
> addresses for that event. In contrast, x86 simply configures LBR using
> the last installed event which seems broken.
> 
> It is possible on x86 to configure branch filter such that no branches
> are ever recorded (e.g. -j save_type). For BRBE, events with a
> configuration that will result in no samples are rejected.
> 
> Recording branches in KVM guests is not supported like x86. However,
> perf on x86 allows requesting branch recording in guests. The guest
> events are recorded, but the resulting branches are all from the host.
> For BRBE, events with branch recording and "exclude_host" set are
> rejected. Requiring "exclude_guest" to be set did not work. The default
> for the perf tool does set "exclude_guest" if no exception level
> options are specified. However, specifying kernel or user events
> defaults to including both host and guest. In this case, only host
> branches are recorded.
> 
> BRBE can support some additional exception branch types compared to
> x86. On x86, all exceptions other than syscalls are recorded as IRQ.
> With BRBE, it is possible to better categorize these exceptions. One
> limitation relative to x86 is we cannot distinguish a syscall return
> from other exception returns. So all exception returns are recorded as
> ERET type. The FIQ branch type is omitted as the only FIQ user is Apple
> platforms which don't support BRBE. The debug branch types are omitted
> as there is no clear need for them.
> 
> BRBE records are invalidated whenever events are reconfigured, a new
> task is scheduled in, or after recording is paused (and the records
> have been recorded for the event). The architecture allows branch
> records to be invalidated by the PE under implementation defined
> conditions. It is expected that these conditions are rare.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Co-developed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Co-developed-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: James Clark <james.clark@linaro.org>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> v22:
>   - Move branch stack disabling after armpmu_stop() in armpmu_del()
>   - Fix branch_records_alloc() to work on heterogeneous systems
>   - Make setting .sched_task function ptr conditional on BRBE support
> 
> v21:
>   - update .sched_task() parameters. task_struct added in v6.15
> 
> v20:
>   - Fix sparse percpu warning in branch_records_alloc()
>   - Use pr_debug instead of pr_debug_once. Add debug print on all error
>     cases when event.attr is rejected.
>   - Add back some arm64 specific exception types
>   - Convert 'call' from user to kernel to syscall as appropriate
>   - Drop requiring event and branch privileges to match
>   - Only enable exceptions and exception returns if recording kernel
>     branches
>   - Add "branches" caps sysfs attribute like x86
>   - Drop some unused defines
>   - Use u64 instead of unsigned long for branch record fields
>   - use min() in brbinf_get_cycles()
>   - Reword comment about FZP and MDCR_EL2.HPMN interaction
>   - Add comments on assumptions about calling brbe_enable()
>   - Merge capture_brbe_flags() into perf_entry_from_brbe_regset()
>   - Rework BRBE invalidation to avoid invalidating in interrupt handler
>     when no handled events capture the branch stack.
>   - Also clear BRBCR_ELx in brbe_disable(). This is for KVM nVHE checks
>     if BRBE is enabled.
> 
> v19:
> - Drop saving of branch records when task scheduled out. (Mark)
> - Got rid of added armpmu ops. All BRBE support contained within pmuv3
>    code.
> - Dropped armpmu.num_branch_records as reg_brbidr has same info.
> - Make sched_task() callback actually get called. Enabling requires a
>    call to perf_sched_cb_inc().
> - Fix freeze on overflow for VHE
> - The cycle counter doesn't freeze BRBE on overflow, so avoid assigning
>    it when BRBE is enabled.
> - Drop all the Arm specific exception branches. Not a clear need for
>    them.
> - Simplify enable/disable to avoid RMW and document ISBs needed
> - Fix handling of branch 'cycles' reading. CC field is
>    mantissa/exponent, not an integer.
> - Save BRBFCR and BRBCR settings in event->hw.branch_reg.config and
>    event->hw.extra_reg.config to avoid recalculating the register value
>    each time the event is installed.
> - Rework s/w filtering to better match h/w filtering
> - Reject events with disjoint event filter and branch filter
> - Reject events if exclude_host is set
> 
> v18: https://lore.kernel.org/all/20240613061731.3109448-6-anshuman.khandual@arm.com/
> ---
>   drivers/perf/Kconfig         |  11 +
>   drivers/perf/Makefile        |   1 +
>   drivers/perf/arm_brbe.c      | 802 +++++++++++++++++++++++++++++++++++++++++++
>   drivers/perf/arm_brbe.h      |  47 +++
>   drivers/perf/arm_pmu.c       |  16 +-
>   drivers/perf/arm_pmuv3.c     | 125 ++++++-
>   include/linux/perf/arm_pmu.h |   8 +
>   7 files changed, 1003 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/perf/Kconfig b/drivers/perf/Kconfig
> index 4e268de351c4..3be60ff4236d 100644
> --- a/drivers/perf/Kconfig
> +++ b/drivers/perf/Kconfig
> @@ -223,6 +223,17 @@ config ARM_SPE_PMU
>   	  Extension, which provides periodic sampling of operations in
>   	  the CPU pipeline and reports this via the perf AUX interface.
>   
> +config ARM64_BRBE
> +	bool "Enable support for branch stack sampling using FEAT_BRBE"
> +	depends on ARM_PMUV3 && ARM64
> +	default y
> +	help
> +	  Enable perf support for Branch Record Buffer Extension (BRBE) which
> +	  records all branches taken in an execution path. This supports some
> +	  branch types and privilege based filtering. It captures additional
> +	  relevant information such as cycle count, misprediction and branch
> +	  type, branch privilege level etc.
> +
>   config ARM_DMC620_PMU
>   	tristate "Enable PMU support for the ARM DMC-620 memory controller"
>   	depends on (ARM64 && ACPI) || COMPILE_TEST
> diff --git a/drivers/perf/Makefile b/drivers/perf/Makefile
> index de71d2574857..192fc8b16204 100644
> --- a/drivers/perf/Makefile
> +++ b/drivers/perf/Makefile
> @@ -23,6 +23,7 @@ obj-$(CONFIG_STARFIVE_STARLINK_PMU) += starfive_starlink_pmu.o
>   obj-$(CONFIG_THUNDERX2_PMU) += thunderx2_pmu.o
>   obj-$(CONFIG_XGENE_PMU) += xgene_pmu.o
>   obj-$(CONFIG_ARM_SPE_PMU) += arm_spe_pmu.o
> +obj-$(CONFIG_ARM64_BRBE) += arm_brbe.o
>   obj-$(CONFIG_ARM_DMC620_PMU) += arm_dmc620_pmu.o
>   obj-$(CONFIG_MARVELL_CN10K_TAD_PMU) += marvell_cn10k_tad_pmu.o
>   obj-$(CONFIG_MARVELL_CN10K_DDR_PMU) += marvell_cn10k_ddr_pmu.o
> diff --git a/drivers/perf/arm_brbe.c b/drivers/perf/arm_brbe.c
> new file mode 100644
> index 000000000000..2f254bd40af3
> --- /dev/null
> +++ b/drivers/perf/arm_brbe.c
> @@ -0,0 +1,802 @@
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
> +				   BRBFCR_EL1_INDIRECT | \
> +				   BRBFCR_EL1_RTN      | \
> +				   BRBFCR_EL1_INDCALL  | \
> +				   BRBFCR_EL1_DIRCALL  | \
> +				   BRBFCR_EL1_CONDDIR)
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
> + *	---------------------------------	------
> + *	| 00 | BRBSRC | BRBTGT | BRBINF |	| 00 |
> + *	---------------------------------	------
> + *	| 01 | BRBSRC | BRBTGT | BRBINF |	| 01 |
> + *	---------------------------------	------
> + *	| .. | BRBSRC | BRBTGT | BRBINF |	| .. |
> + *	---------------------------------	------
> + *	| 31 | BRBSRC | BRBTGT | BRBINF |	| 31 |
> + *	---------------------------------	------
> + *
> + * Bank 1
> + *
> + *	---------------------------------	------
> + *	| 32 | BRBSRC | BRBTGT | BRBINF |	| 00 |
> + *	---------------------------------	------
> + *	| 33 | BRBSRC | BRBTGT | BRBINF |	| 01 |
> + *	---------------------------------	------
> + *	| .. | BRBSRC | BRBTGT | BRBINF |	| .. |
> + *	---------------------------------	------
> + *	| 63 | BRBSRC | BRBTGT | BRBINF |	| 31 |
> + *	---------------------------------	------
> + */
> +#define BRBE_BANK_MAX_ENTRIES	32
> +
> +struct brbe_regset {
> +	u64 brbsrc;
> +	u64 brbtgt;
> +	u64 brbinf;
> +};
> +
> +#define PERF_BR_ARM64_MAX (PERF_BR_MAX + PERF_BR_NEW_MAX)
> +
> +struct brbe_hw_attr {
> +	int	brbe_version;
> +	int	brbe_cc;
> +	int	brbe_nr;
> +	int	brbe_format;
> +};
> +
> +#define BRBE_REGN_CASE(n, case_macro) \
> +	case n: case_macro(n); break
> +
> +#define BRBE_REGN_SWITCH(x, case_macro)				\
> +	do {							\
> +		switch (x) {					\
> +		BRBE_REGN_CASE(0, case_macro);			\
> +		BRBE_REGN_CASE(1, case_macro);			\
> +		BRBE_REGN_CASE(2, case_macro);			\
> +		BRBE_REGN_CASE(3, case_macro);			\
> +		BRBE_REGN_CASE(4, case_macro);			\
> +		BRBE_REGN_CASE(5, case_macro);			\
> +		BRBE_REGN_CASE(6, case_macro);			\
> +		BRBE_REGN_CASE(7, case_macro);			\
> +		BRBE_REGN_CASE(8, case_macro);			\
> +		BRBE_REGN_CASE(9, case_macro);			\
> +		BRBE_REGN_CASE(10, case_macro);			\
> +		BRBE_REGN_CASE(11, case_macro);			\
> +		BRBE_REGN_CASE(12, case_macro);			\
> +		BRBE_REGN_CASE(13, case_macro);			\
> +		BRBE_REGN_CASE(14, case_macro);			\
> +		BRBE_REGN_CASE(15, case_macro);			\
> +		BRBE_REGN_CASE(16, case_macro);			\
> +		BRBE_REGN_CASE(17, case_macro);			\
> +		BRBE_REGN_CASE(18, case_macro);			\
> +		BRBE_REGN_CASE(19, case_macro);			\
> +		BRBE_REGN_CASE(20, case_macro);			\
> +		BRBE_REGN_CASE(21, case_macro);			\
> +		BRBE_REGN_CASE(22, case_macro);			\
> +		BRBE_REGN_CASE(23, case_macro);			\
> +		BRBE_REGN_CASE(24, case_macro);			\
> +		BRBE_REGN_CASE(25, case_macro);			\
> +		BRBE_REGN_CASE(26, case_macro);			\
> +		BRBE_REGN_CASE(27, case_macro);			\
> +		BRBE_REGN_CASE(28, case_macro);			\
> +		BRBE_REGN_CASE(29, case_macro);			\
> +		BRBE_REGN_CASE(30, case_macro);			\
> +		BRBE_REGN_CASE(31, case_macro);			\
> +		default: WARN(1, "Invalid BRB* index %d\n", x);	\
> +		}						\
> +	} while (0)
> +
> +#define RETURN_READ_BRBSRCN(n) \
> +	return read_sysreg_s(SYS_BRBSRC_EL1(n))
> +static inline u64 get_brbsrc_reg(int idx)
> +{
> +	BRBE_REGN_SWITCH(idx, RETURN_READ_BRBSRCN);
> +	return 0;
> +}
> +
> +#define RETURN_READ_BRBTGTN(n) \
> +	return read_sysreg_s(SYS_BRBTGT_EL1(n))
> +static u64 get_brbtgt_reg(int idx)
> +{
> +	BRBE_REGN_SWITCH(idx, RETURN_READ_BRBTGTN);
> +	return 0;
> +}
> +
> +#define RETURN_READ_BRBINFN(n) \
> +	return read_sysreg_s(SYS_BRBINF_EL1(n))
> +static u64 get_brbinf_reg(int idx)
> +{
> +	BRBE_REGN_SWITCH(idx, RETURN_READ_BRBINFN);
> +	return 0;
> +}
> +
> +static u64 brbe_record_valid(u64 brbinf)
> +{
> +	return FIELD_GET(BRBINFx_EL1_VALID_MASK, brbinf);
> +}
> +
> +static bool brbe_invalid(u64 brbinf)
> +{
> +	return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_NONE;
> +}
> +
> +static bool brbe_record_is_complete(u64 brbinf)
> +{
> +	return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_FULL;
> +}
> +
> +static bool brbe_record_is_source_only(u64 brbinf)
> +{
> +	return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_SOURCE;
> +}
> +
> +static bool brbe_record_is_target_only(u64 brbinf)
> +{
> +	return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_TARGET;
> +}
> +
> +static int brbinf_get_in_tx(u64 brbinf)
> +{
> +	return FIELD_GET(BRBINFx_EL1_T_MASK, brbinf);
> +}
> +
> +static int brbinf_get_mispredict(u64 brbinf)
> +{
> +	return FIELD_GET(BRBINFx_EL1_MPRED_MASK, brbinf);
> +}
> +
> +static int brbinf_get_lastfailed(u64 brbinf)
> +{
> +	return FIELD_GET(BRBINFx_EL1_LASTFAILED_MASK, brbinf);
> +}
> +
> +static u16 brbinf_get_cycles(u64 brbinf)
> +{
> +	u32 exp, mant, cycles;
> +	/*
> +	 * Captured cycle count is unknown and hence
> +	 * should not be passed on to userspace.
> +	 */
> +	if (brbinf & BRBINFx_EL1_CCU)
> +		return 0;
> +
> +	exp = FIELD_GET(BRBINFx_EL1_CC_EXP_MASK, brbinf);
> +	mant = FIELD_GET(BRBINFx_EL1_CC_MANT_MASK, brbinf);
> +
> +	if (!exp)
> +		return mant;
> +
> +	cycles = (mant | 0x100) << (exp - 1);
> +
> +	return min(cycles, U16_MAX);
> +}
> +
> +static int brbinf_get_type(u64 brbinf)
> +{
> +	return FIELD_GET(BRBINFx_EL1_TYPE_MASK, brbinf);
> +}
> +
> +static int brbinf_get_el(u64 brbinf)
> +{
> +	return FIELD_GET(BRBINFx_EL1_EL_MASK, brbinf);
> +}
> +
> +void brbe_invalidate(void)
> +{
> +	// Ensure all branches before this point are recorded
> +	isb();
> +	asm volatile(BRB_IALL_INSN);
> +	// Ensure all branch records are invalidated after this point
> +	isb();
> +}
> +
> +static bool valid_brbe_nr(int brbe_nr)
> +{
> +	return brbe_nr == BRBIDR0_EL1_NUMREC_8 ||
> +	       brbe_nr == BRBIDR0_EL1_NUMREC_16 ||
> +	       brbe_nr == BRBIDR0_EL1_NUMREC_32 ||
> +	       brbe_nr == BRBIDR0_EL1_NUMREC_64;
> +}
> +
> +static bool valid_brbe_cc(int brbe_cc)
> +{
> +	return brbe_cc == BRBIDR0_EL1_CC_20_BIT;
> +}
> +
> +static bool valid_brbe_format(int brbe_format)
> +{
> +	return brbe_format == BRBIDR0_EL1_FORMAT_FORMAT_0;
> +}
> +
> +static bool valid_brbidr(u64 brbidr)
> +{
> +	int brbe_format, brbe_cc, brbe_nr;
> +
> +	brbe_format = FIELD_GET(BRBIDR0_EL1_FORMAT_MASK, brbidr);
> +	brbe_cc = FIELD_GET(BRBIDR0_EL1_CC_MASK, brbidr);
> +	brbe_nr = FIELD_GET(BRBIDR0_EL1_NUMREC_MASK, brbidr);
> +
> +	return valid_brbe_format(brbe_format) && valid_brbe_cc(brbe_cc) && valid_brbe_nr(brbe_nr);
> +}
> +
> +static bool valid_brbe_version(int brbe_version)
> +{
> +	return brbe_version == ID_AA64DFR0_EL1_BRBE_IMP ||
> +	       brbe_version == ID_AA64DFR0_EL1_BRBE_BRBE_V1P1;
> +}
> +
> +static void select_brbe_bank(int bank)
> +{
> +	u64 brbfcr;
> +
> +	brbfcr = read_sysreg_s(SYS_BRBFCR_EL1);
> +	brbfcr &= ~BRBFCR_EL1_BANK_MASK;
> +	brbfcr |= SYS_FIELD_PREP(BRBFCR_EL1, BANK, bank);
> +	write_sysreg_s(brbfcr, SYS_BRBFCR_EL1);
> +	/*
> +	 * Arm ARM (DDI 0487K.a) D.18.4 rule PPBZP requires explicit sync
> +	 * between setting BANK and accessing branch records.
> +	 */
> +	isb();
> +}
> +
> +static bool __read_brbe_regset(struct brbe_regset *entry, int idx)
> +{
> +	entry->brbinf = get_brbinf_reg(idx);
> +
> +	if (brbe_invalid(entry->brbinf))
> +		return false;
> +
> +	entry->brbsrc = get_brbsrc_reg(idx);
> +	entry->brbtgt = get_brbtgt_reg(idx);
> +	return true;
> +}
> +
> +/*
> + * Generic perf branch filters supported on BRBE
> + *
> + * New branch filters need to be evaluated whether they could be supported on
> + * BRBE. This ensures that such branch filters would not just be accepted, to
> + * fail silently. PERF_SAMPLE_BRANCH_HV is a special case that is selectively
> + * supported only on platforms where kernel is in hyp mode.
> + */
> +#define BRBE_EXCLUDE_BRANCH_FILTERS (PERF_SAMPLE_BRANCH_ABORT_TX	| \
> +				     PERF_SAMPLE_BRANCH_IN_TX		| \
> +				     PERF_SAMPLE_BRANCH_NO_TX		| \
> +				     PERF_SAMPLE_BRANCH_CALL_STACK	| \
> +				     PERF_SAMPLE_BRANCH_COUNTERS)
> +
> +#define BRBE_ALLOWED_BRANCH_TYPES   (PERF_SAMPLE_BRANCH_ANY		| \
> +				     PERF_SAMPLE_BRANCH_ANY_CALL	| \
> +				     PERF_SAMPLE_BRANCH_ANY_RETURN	| \
> +				     PERF_SAMPLE_BRANCH_IND_CALL	| \
> +				     PERF_SAMPLE_BRANCH_COND		| \
> +				     PERF_SAMPLE_BRANCH_IND_JUMP	| \
> +				     PERF_SAMPLE_BRANCH_CALL)
> +
> +
> +#define BRBE_ALLOWED_BRANCH_FILTERS (PERF_SAMPLE_BRANCH_USER		| \
> +				     PERF_SAMPLE_BRANCH_KERNEL		| \
> +				     PERF_SAMPLE_BRANCH_HV		| \
> +				     BRBE_ALLOWED_BRANCH_TYPES		| \
> +				     PERF_SAMPLE_BRANCH_NO_FLAGS	| \
> +				     PERF_SAMPLE_BRANCH_NO_CYCLES	| \
> +				     PERF_SAMPLE_BRANCH_TYPE_SAVE	| \
> +				     PERF_SAMPLE_BRANCH_HW_INDEX	| \
> +				     PERF_SAMPLE_BRANCH_PRIV_SAVE)
> +
> +#define BRBE_PERF_BRANCH_FILTERS    (BRBE_ALLOWED_BRANCH_FILTERS	| \
> +				     BRBE_EXCLUDE_BRANCH_FILTERS)
> +
> +/*
> + * BRBE supports the following functional branch type filters while
> + * generating branch records. These branch filters can be enabled,
> + * either individually or as a group i.e ORing multiple filters
> + * with each other.
> + *
> + * BRBFCR_EL1_CONDDIR  - Conditional direct branch
> + * BRBFCR_EL1_DIRCALL  - Direct call
> + * BRBFCR_EL1_INDCALL  - Indirect call
> + * BRBFCR_EL1_INDIRECT - Indirect branch
> + * BRBFCR_EL1_DIRECT   - Direct branch
> + * BRBFCR_EL1_RTN      - Subroutine return
> + */
> +static u64 branch_type_to_brbfcr(int branch_type)
> +{
> +	u64 brbfcr = 0;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_ANY) {
> +		brbfcr |= BRBFCR_EL1_BRANCH_FILTERS;
> +		return brbfcr;
> +	}
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
> +		brbfcr |= BRBFCR_EL1_INDCALL;
> +		brbfcr |= BRBFCR_EL1_DIRCALL;
> +	}
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_ANY_RETURN)
> +		brbfcr |= BRBFCR_EL1_RTN;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_IND_CALL)
> +		brbfcr |= BRBFCR_EL1_INDCALL;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_COND)
> +		brbfcr |= BRBFCR_EL1_CONDDIR;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_IND_JUMP)
> +		brbfcr |= BRBFCR_EL1_INDIRECT;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_CALL)
> +		brbfcr |= BRBFCR_EL1_DIRCALL;
> +
> +	return brbfcr;
> +}
> +
> +/*
> + * BRBE supports the following privilege mode filters while generating
> + * branch records.
> + *
> + * BRBCR_ELx_E0BRE - EL0 branch records
> + * BRBCR_ELx_ExBRE - EL1/EL2 branch records
> + *
> + * BRBE also supports the following additional functional branch type
> + * filters while generating branch records.
> + *
> + * BRBCR_ELx_EXCEPTION - Exception
> + * BRBCR_ELx_ERTN     -  Exception return
> + */
> +static u64 branch_type_to_brbcr(int branch_type)
> +{
> +	u64 brbcr = BRBCR_ELx_FZP | BRBCR_ELx_DEFAULT_TS;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_USER)
> +		brbcr |= BRBCR_ELx_E0BRE;
> +
> +	/*
> +	 * When running in the hyp mode, writing into BRBCR_EL1
> +	 * actually writes into BRBCR_EL2 instead. Field E2BRE
> +	 * is also at the same position as E1BRE.
> +	 */
> +	if (branch_type & PERF_SAMPLE_BRANCH_KERNEL)
> +		brbcr |= BRBCR_ELx_ExBRE;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_HV) {
> +		if (is_kernel_in_hyp_mode())
> +			brbcr |= BRBCR_ELx_ExBRE;
> +	}
> +
> +	if (!(branch_type & PERF_SAMPLE_BRANCH_NO_CYCLES))
> +		brbcr |= BRBCR_ELx_CC;
> +
> +	if (!(branch_type & PERF_SAMPLE_BRANCH_NO_FLAGS))
> +		brbcr |= BRBCR_ELx_MPRED;
> +
> +	/*
> +	 * The exception and exception return branches could be
> +	 * captured, irrespective of the perf event's privilege.
> +	 * If the perf event does not have enough privilege for
> +	 * a given exception level, then addresses which falls
> +	 * under that exception level will be reported as zero
> +	 * for the captured branch record, creating source only
> +	 * or target only records.
> +	 */
> +	if (branch_type & PERF_SAMPLE_BRANCH_KERNEL) {
> +		if (branch_type & PERF_SAMPLE_BRANCH_ANY) {
> +			brbcr |= BRBCR_ELx_EXCEPTION;
> +			brbcr |= BRBCR_ELx_ERTN;
> +		}
> +
> +		if (branch_type & PERF_SAMPLE_BRANCH_ANY_CALL)
> +			brbcr |= BRBCR_ELx_EXCEPTION;
> +
> +		if (branch_type & PERF_SAMPLE_BRANCH_ANY_RETURN)
> +			brbcr |= BRBCR_ELx_ERTN;
> +	}
> +	return brbcr;
> +}
> +
> +bool brbe_branch_attr_valid(struct perf_event *event)
> +{
> +	u64 branch_type = event->attr.branch_sample_type;
> +
> +	/*
> +	 * Ensure both perf branch filter allowed and exclude
> +	 * masks are always in sync with the generic perf ABI.
> +	 */
> +	BUILD_BUG_ON(BRBE_PERF_BRANCH_FILTERS != (PERF_SAMPLE_BRANCH_MAX - 1));
> +
> +	if (branch_type & BRBE_EXCLUDE_BRANCH_FILTERS) {
> +		pr_debug("requested branch filter not supported 0x%llx\n", branch_type);
> +		return false;
> +	}
> +
> +	/* Ensure at least 1 branch type is enabled */
> +	if (!(branch_type & BRBE_ALLOWED_BRANCH_TYPES)) {
> +		pr_debug("no branch type enabled 0x%llx\n", branch_type);
> +		return false;
> +	}
> +
> +	/*
> +	 * No branches are recorded in guests nor nVHE hypervisors, so
> +	 * excluding the host or both kernel and user is invalid.
> +	 *
> +	 * Ideally we'd just require exclude_guest and exclude_hv, but setting
> +	 * event filters with perf for kernel or user don't set exclude_guest.
> +	 * So effectively, exclude_guest and exclude_hv are ignored.
> +	 */
> +	if (event->attr.exclude_host || (event->attr.exclude_user && event->attr.exclude_kernel)) {
> +		pr_debug("branch filter in hypervisor or guest only not supported 0x%llx\n", branch_type);
> +		return false;
> +	}
> +
> +	event->hw.branch_reg.config = branch_type_to_brbfcr(event->attr.branch_sample_type);
> +	event->hw.extra_reg.config = branch_type_to_brbcr(event->attr.branch_sample_type);
> +
> +	return true;
> +}
> +
> +unsigned int brbe_num_branch_records(const struct arm_pmu *armpmu)
> +{
> +	return FIELD_GET(BRBIDR0_EL1_NUMREC_MASK, armpmu->reg_brbidr);
> +}
> +
> +void brbe_probe(struct arm_pmu *armpmu)
> +{
> +	u64 aa64dfr0 = read_sysreg_s(SYS_ID_AA64DFR0_EL1);
> +	u32 brbe;
> +
> +	brbe = cpuid_feature_extract_unsigned_field(aa64dfr0, ID_AA64DFR0_EL1_BRBE_SHIFT);
> +	if (!valid_brbe_version(brbe))
> +		return;
> +
> +	u64 brbidr = read_sysreg_s(SYS_BRBIDR0_EL1);
> +	if (!valid_brbidr(brbidr))
> +		return;
> +
> +	armpmu->reg_brbidr = brbidr;
> +}
> +
> +/*
> + * BRBE is assumed to be disabled/paused on entry
> + */
> +void brbe_enable(const struct arm_pmu *arm_pmu)
> +{
> +	struct pmu_hw_events *cpuc = this_cpu_ptr(arm_pmu->hw_events);
> +	u64 brbfcr = 0, brbcr = 0;
> +
> +	/*
> +	 * Merge the permitted branch filters of all events.
> +	 */
> +	for (int i = 0; i < ARMPMU_MAX_HWEVENTS; i++) {
> +		struct perf_event *event = cpuc->events[i];
> +
> +		if (event && has_branch_stack(event)) {
> +			brbfcr |= event->hw.branch_reg.config;
> +			brbcr |= event->hw.extra_reg.config;
> +		}
> +	}
> +
> +	/*
> +	 * In VHE mode with MDCR_EL2.HPMN equal to PMCR_EL0.N, BRBCR_EL1.FZP
> +	 * controls freezing the branch records on counter overflow rather than
> +	 * BRBCR_EL2.FZP (which writes to BRBCR_EL1 are redirected to).
> +	 * The exception levels are enabled/disabled in BRBCR_EL2, so keep EL1
> +	 * and EL0 recording disabled for guests.
> +	 *
> +	 * As BRBCR_EL1 CC and MPRED bits also need to match, use the same
> +	 * value for both registers just masking the exception levels.
> +	 */
> +	if (is_kernel_in_hyp_mode())
> +		write_sysreg_s(brbcr & ~(BRBCR_ELx_ExBRE | BRBCR_ELx_E0BRE), SYS_BRBCR_EL12);
> +	write_sysreg_s(brbcr, SYS_BRBCR_EL1);
> +	isb(); // Ensure BRBCR_ELx settings take effect before unpausing
> +
> +	// Finally write SYS_BRBFCR_EL to unpause BRBE
> +	write_sysreg_s(brbfcr, SYS_BRBFCR_EL1);
> +	// Synchronization in PMCR write ensures ordering WRT PMU enabling
> +}
> +
> +void brbe_disable(void)
> +{
> +	/*
> +	 * No need for synchronization here as synchronization in PMCR write
> +	 * ensures ordering and in the interrupt handler this is a NOP as
> +	 * we're already paused.
> +	 */
> +	write_sysreg_s(BRBFCR_EL1_PAUSED, SYS_BRBFCR_EL1);
> +	write_sysreg_s(0, SYS_BRBCR_EL1);
> +}
> +
> +static const int brbe_type_to_perf_type_map[BRBINFx_EL1_TYPE_DEBUG_EXIT + 1][2] = {
> +	[BRBINFx_EL1_TYPE_DIRECT_UNCOND] = { PERF_BR_UNCOND, 0 },
> +	[BRBINFx_EL1_TYPE_INDIRECT] = { PERF_BR_IND, 0 },
> +	[BRBINFx_EL1_TYPE_DIRECT_LINK] = { PERF_BR_CALL, 0 },
> +	[BRBINFx_EL1_TYPE_INDIRECT_LINK] = { PERF_BR_IND_CALL, 0 },
> +	[BRBINFx_EL1_TYPE_RET] = { PERF_BR_RET, 0 },
> +	[BRBINFx_EL1_TYPE_DIRECT_COND] = { PERF_BR_COND, 0 },
> +	[BRBINFx_EL1_TYPE_CALL] = { PERF_BR_CALL, 0 },
> +	[BRBINFx_EL1_TYPE_ERET] = { PERF_BR_ERET, 0 },
> +	[BRBINFx_EL1_TYPE_IRQ] = { PERF_BR_IRQ, 0 },
> +	[BRBINFx_EL1_TYPE_TRAP] = { PERF_BR_IRQ, 0 },
> +	[BRBINFx_EL1_TYPE_SERROR] = { PERF_BR_SERROR, 0 },
> +	[BRBINFx_EL1_TYPE_ALIGN_FAULT] = { PERF_BR_EXTEND_ABI, PERF_BR_NEW_FAULT_ALGN },
> +	[BRBINFx_EL1_TYPE_INSN_FAULT] = { PERF_BR_EXTEND_ABI, PERF_BR_NEW_FAULT_INST },
> +	[BRBINFx_EL1_TYPE_DATA_FAULT] = { PERF_BR_EXTEND_ABI, PERF_BR_NEW_FAULT_DATA },
> +};
> +
> +static void brbe_set_perf_entry_type(struct perf_branch_entry *entry, u64 brbinf)
> +{
> +	int brbe_type = brbinf_get_type(brbinf);
> +
> +	if (brbe_type <= BRBINFx_EL1_TYPE_DEBUG_EXIT) {
> +		const int *br_type = brbe_type_to_perf_type_map[brbe_type];
> +
> +		entry->type = br_type[0];
> +		entry->new_type = br_type[1];
> +	}
> +}
> +
> +static int brbinf_get_perf_priv(u64 brbinf)
> +{
> +	int brbe_el = brbinf_get_el(brbinf);
> +
> +	switch (brbe_el) {
> +	case BRBINFx_EL1_EL_EL0:
> +		return PERF_BR_PRIV_USER;
> +	case BRBINFx_EL1_EL_EL1:
> +		return PERF_BR_PRIV_KERNEL;
> +	case BRBINFx_EL1_EL_EL2:
> +		if (is_kernel_in_hyp_mode())
> +			return PERF_BR_PRIV_KERNEL;
> +		return PERF_BR_PRIV_HV;
> +	default:
> +		pr_warn_once("%d - unknown branch privilege captured\n", brbe_el);
> +		return PERF_BR_PRIV_UNKNOWN;
> +	}
> +}
> +
> +static bool perf_entry_from_brbe_regset(int index, struct perf_branch_entry *entry,
> +					const struct perf_event *event)
> +{
> +	struct brbe_regset bregs;
> +	u64 brbinf;
> +
> +	if (!__read_brbe_regset(&bregs, index))
> +		return false;
> +
> +	brbinf = bregs.brbinf;
> +	perf_clear_branch_entry_bitfields(entry);
> +	if (brbe_record_is_complete(brbinf)) {
> +		entry->from = bregs.brbsrc;
> +		entry->to = bregs.brbtgt;
> +	} else if (brbe_record_is_source_only(brbinf)) {
> +		entry->from = bregs.brbsrc;
> +		entry->to = 0;
> +	} else if (brbe_record_is_target_only(brbinf)) {
> +		entry->from = 0;
> +		entry->to = bregs.brbtgt;
> +	}
> +
> +	brbe_set_perf_entry_type(entry, brbinf);
> +
> +	if (!branch_sample_no_cycles(event))
> +		entry->cycles = brbinf_get_cycles(brbinf);
> +
> +	if (!branch_sample_no_flags(event)) {
> +		/* Mispredict info is available for source only and complete branch records. */
> +		if (!brbe_record_is_target_only(brbinf)) {
> +			entry->mispred = brbinf_get_mispredict(brbinf);
> +			entry->predicted = !entry->mispred;
> +		}
> +
> +		/*
> +		 * Currently TME feature is neither implemented in any hardware
> +		 * nor it is being supported in the kernel. Just warn here once
> +		 * if TME related information shows up rather unexpectedly.
> +		 */
> +		if (brbinf_get_lastfailed(brbinf) || brbinf_get_in_tx(brbinf))
> +			pr_warn_once("Unknown transaction states\n");
> +	}
> +
> +	/*
> +	 * Branch privilege level is available for target only and complete
> +	 * branch records.
> +	 */
> +	if (!brbe_record_is_source_only(brbinf))
> +		entry->priv = brbinf_get_perf_priv(brbinf);
> +
> +	return true;
> +}
> +
> +#define PERF_BR_ARM64_ALL (				\
> +	BIT(PERF_BR_COND) |				\
> +	BIT(PERF_BR_UNCOND) |				\
> +	BIT(PERF_BR_IND) |				\
> +	BIT(PERF_BR_CALL) |				\
> +	BIT(PERF_BR_IND_CALL) |				\
> +	BIT(PERF_BR_RET))
> +
> +#define PERF_BR_ARM64_ALL_KERNEL (			\
> +	BIT(PERF_BR_SYSCALL) |				\
> +	BIT(PERF_BR_IRQ) |				\
> +	BIT(PERF_BR_SERROR) |				\
> +	BIT(PERF_BR_MAX + PERF_BR_NEW_FAULT_ALGN) |	\
> +	BIT(PERF_BR_MAX + PERF_BR_NEW_FAULT_DATA) |	\
> +	BIT(PERF_BR_MAX + PERF_BR_NEW_FAULT_INST))
> +
> +static void prepare_event_branch_type_mask(u64 branch_sample,
> +					   unsigned long *event_type_mask)
> +{
> +	if (branch_sample & PERF_SAMPLE_BRANCH_ANY) {
> +		if (branch_sample & PERF_SAMPLE_BRANCH_KERNEL)
> +			bitmap_from_u64(event_type_mask,
> +				BIT(PERF_BR_ERET) | PERF_BR_ARM64_ALL |
> +				PERF_BR_ARM64_ALL_KERNEL);
> +		else
> +			bitmap_from_u64(event_type_mask, PERF_BR_ARM64_ALL);
> +		return;
> +	}
> +
> +	bitmap_zero(event_type_mask, PERF_BR_ARM64_MAX);
> +
> +	if (branch_sample & PERF_SAMPLE_BRANCH_ANY_CALL) {
> +		if (branch_sample & PERF_SAMPLE_BRANCH_KERNEL)
> +			bitmap_from_u64(event_type_mask, PERF_BR_ARM64_ALL_KERNEL);
> +
> +		set_bit(PERF_BR_CALL, event_type_mask);
> +		set_bit(PERF_BR_IND_CALL, event_type_mask);
> +	}
> +
> +	if (branch_sample & PERF_SAMPLE_BRANCH_IND_JUMP)
> +		set_bit(PERF_BR_IND, event_type_mask);
> +
> +	if (branch_sample & PERF_SAMPLE_BRANCH_COND)
> +		set_bit(PERF_BR_COND, event_type_mask);
> +
> +	if (branch_sample & PERF_SAMPLE_BRANCH_CALL)
> +		set_bit(PERF_BR_CALL, event_type_mask);
> +
> +	if (branch_sample & PERF_SAMPLE_BRANCH_IND_CALL)
> +		set_bit(PERF_BR_IND_CALL, event_type_mask);
> +
> +	if (branch_sample & PERF_SAMPLE_BRANCH_ANY_RETURN) {
> +		set_bit(PERF_BR_RET, event_type_mask);
> +
> +		if (branch_sample & PERF_SAMPLE_BRANCH_KERNEL)
> +			set_bit(PERF_BR_ERET, event_type_mask);
> +	}
> +}
> +
> +/*
> + * BRBE is configured with an OR of permissions from all events, so there may
> + * be events which have to be dropped or events where just the source or target
> + * address has to be zeroed.
> + */
> +static bool filter_branch_privilege(struct perf_branch_entry *entry, u64 branch_sample_type)
> +{
> +	/* We can only have a half record if permissions have not been expanded */
> +	if (!entry->from || !entry->to)
> +		return true;
> +
> +	bool from_user = access_ok((void __user *)(unsigned long)entry->from, 4);
> +	bool to_user = access_ok((void __user *)(unsigned long)entry->to, 4);
> +	bool exclude_kernel = !((branch_sample_type & PERF_SAMPLE_BRANCH_KERNEL) ||
> +		(is_kernel_in_hyp_mode() && (branch_sample_type & PERF_SAMPLE_BRANCH_HV)));
> +
> +	/*
> +	 * If record is within a single exception level, just need to either
> +	 * drop or keep the entire record.
> +	 */
> +	if (from_user == to_user)
> +		return ((entry->priv == PERF_BR_PRIV_KERNEL) && !exclude_kernel) ||
> +			((entry->priv == PERF_BR_PRIV_USER) &&
> +			 (branch_sample_type & PERF_SAMPLE_BRANCH_USER));
> +
> +	// Fixup calls which are syscalls
> +	if (entry->type == PERF_BR_CALL && from_user && !to_user)
> +		entry->type = PERF_BR_SYSCALL;
> +
> +	/*
> +	 * Record is across exception levels, mask addresses for the exception
> +	 * level we're not capturing.
> +	 */
> +	if (!(branch_sample_type & PERF_SAMPLE_BRANCH_USER)) {
> +		if (from_user)
> +			entry->from = 0;
> +		if (to_user)
> +			entry->to = 0;
> +	}
> +
> +	if (exclude_kernel) {
> +		if (!from_user)
> +			entry->from = 0;
> +		if (!to_user)
> +			entry->to = 0;
> +	}
> +	return true;
> +}
> +
> +static bool filter_branch_type(struct perf_branch_entry *entry,
> +			       const unsigned long *event_type_mask)
> +{
> +	if (entry->type == PERF_BR_EXTEND_ABI)
> +		return test_bit(PERF_BR_MAX + entry->new_type, event_type_mask);
> +	else
> +		return test_bit(entry->type, event_type_mask);
> +}
> +
> +static bool filter_branch_record(struct perf_branch_entry *entry,
> +				 u64 branch_sample,
> +				 const unsigned long *event_type_mask)
> +{
> +	return filter_branch_type(entry, event_type_mask) &&
> +		filter_branch_privilege(entry, branch_sample);

filter_branch_privilege() sometimes changes the branch type for 
PERF_BR_SYSCALL so I think it should come before filter_branch_type(). I 
didn't see any actual issue caused by this, but it's a bit hard to 
review to see if it's working correctly.

Ideally any mutation would be done with a more explicitly named function 
than 'filter'.

James

