Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C359B7E575
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 11:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718020517; cv=none; b=rG+4pPZNAkvzFGZd2jL3taYv88yrA2KKmgJw/gN85cMa0rvL3qwl/8KAYzwNLzlHzeevu/aI+2vIPhAfwPlL7LJWRQu3KGfCgV74CEkd8NYhNjNN0yZdpFquMNSO+Ru1H1mBNvOhvSRyNN7MBjklNYIjKzKDB/bi8j3k4ssMzrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718020517; c=relaxed/simple;
	bh=lHU2JJLgCKo26fwvGAKkI/5vfcLyhRaN2Ta0zIemFAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nHb2agJHufxDGG1+2axMJww3RaLxBKKbaQuWkbc+Cdao8gWAMxdipoji+sS3Aex/OTUzD3v/tiSY7imDCXVKBjBNV/heYhrEZBRVChXHQh+94Tv4gopD3yKuJSp/JXRQ47Ttf3khhPg/Va2AFXCFl0iFZoDX6/IYjBUW8C1ZmuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3BD112FC;
	Mon, 10 Jun 2024 04:55:38 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D8F903F58B;
	Mon, 10 Jun 2024 04:55:10 -0700 (PDT)
Date: Mon, 10 Jun 2024 12:55:08 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 9/9] perf: arm_pmuv3: Add support for Armv9.4 PMU
 instruction counter
Message-ID: <ZmbpnHU3YM0q6YeA@J2N7QTR9R3>
References: <20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org>
 <20240607-arm-pmu-3-9-icntr-v1-9-c7bd2dceff3b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607-arm-pmu-3-9-icntr-v1-9-c7bd2dceff3b@kernel.org>

On Fri, Jun 07, 2024 at 02:31:34PM -0600, Rob Herring (Arm) wrote:
> Armv9.4/8.9 PMU adds optional support for a fixed instruction counter
> similar to the fixed cycle counter. Support for the feature is indicated
> in the ID_AA64DFR1_EL1 register PMICNTR field. The counter is not
> accessible in AArch32.
> 
> Existing userspace using direct counter access won't know how to handle
> the fixed instruction counter, so we have to avoid using the counter
> when user access is requested.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  arch/arm/include/asm/arm_pmuv3.h   | 21 +++++++++++++++++++++
>  arch/arm64/include/asm/arm_pmuv3.h | 29 +++++++++++++++++++++++++++++
>  arch/arm64/kvm/pmu.c               |  8 ++++++--
>  arch/arm64/tools/sysreg            | 25 +++++++++++++++++++++++++
>  drivers/perf/arm_pmuv3.c           | 28 ++++++++++++++++++++++++++--
>  include/linux/perf/arm_pmu.h       |  8 ++++++--
>  include/linux/perf/arm_pmuv3.h     |  4 +++-
>  7 files changed, 116 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
> index ac2cf37b57e3..b836537ddfbf 100644
> --- a/arch/arm/include/asm/arm_pmuv3.h
> +++ b/arch/arm/include/asm/arm_pmuv3.h
> @@ -10,6 +10,7 @@
>  #include <asm/cputype.h>
>  
>  #define ARMV8_PMU_CYCLE_IDX		31
> +#define ARMV8_PMU_INSTR_IDX		32 /* Not accessible from AArch32 */

As with ARMV8_PMU_CYCLE_IDX, I reckon this should live in
<linux/perf/arm_pmuv3.h> (with the comment above) so that we don't need
separate definitions for arm & arm64.

[...]

> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 231817a379b5..8ab6e09871de 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2029,6 +2029,31 @@ Sysreg	FAR_EL1	3	0	6	0	0
>  Field	63:0	ADDR
>  EndSysreg
>  
> +Sysreg	PMICNTR_EL0	3	3	9	4	0
> +Field	63:0	ICNT
> +EndSysreg

LGTM per ARM DDI 0487K.a, section D23.5.15, pages 8989 to 8992.

> +
> +Sysreg	PMICFILTR_EL0	3	3	9	6	0
> +Res0	63:59
> +Field	58	SYNC
> +Field	57:56	VS

The 'VS' field doesn't seem to be in the ARM ARM (ARM DDI 0487K.a); is
that defined in a supplement?

> +Res0	55:32
> +Field	31	P
> +Field	30	U
> +Field	29	NSK
> +Field	28	NSU
> +Field	27	NSH
> +Field	26	M
> +Res0	25
> +Field	24	SH
> +Field	23	T
> +Field	22	RLK
> +Field	21	RLU
> +Field	20	RLH
> +Res0	19:16
> +Field	15:0	evtCount
> +EndSysreg

Aside from 'VS', this LGTM per ARM DDI 0487K.a, section D23.5.14, pages
8981 to 8988.

One important thing to note is that this doesn't have the threshold
controls (TC, TE, TH); so if threshold events make sense for instruction
events, we cannot place those in the dedicated isntruction counter.

[...]

> @@ -931,6 +939,18 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
>  				return -EAGAIN;
>  	}
>  
> +	/*
> +	 * Always prefer to place a instruction counter into the instruction counter,
> +	 * but don't expose the instruction counter to userspace access as userspace
> +	 * may not know how to handle it.
> +	 */
> +	if (test_bit(ARMV8_PMU_INSTR_IDX, cpu_pmu->cntr_mask) &&
> +	    (evtype == ARMV8_PMUV3_PERFCTR_INST_RETIRED) &&
> +	    !armv8pmu_event_want_user_access(event)) {
> +		if (!test_and_set_bit(ARMV8_PMU_INSTR_IDX, cpuc->used_mask))
> +			return ARMV8_PMU_INSTR_IDX;
> +	}


I reckon this'd be a bit clearer if we check the evtype first, as with
cycles, e.g.

	/*
	 * Always prefer to place a instruction counter into the instruction counter,
	 * but don't expose the instruction counter to userspace access as userspace
	 * may not know how to handle it.
	 */
	if (evtype == ARMV8_PMUV3_PERFCTR_INST_RETIRED) {
		if (test_bit(ARMV8_PMU_INSTR_IDX, cpu_pmu->cntr_mask) &&
		    !armv8pmu_event_want_user_access(event) &&
		    !test_and_set_bit(ARMV8_PMU_INSTR_IDX, cpuc->used_mask))
			return ARMV8_PMU_INSTR_IDX;
	}

As above, we might need to check for threshold controls, but I'll need
to go page that in.

Mark.
