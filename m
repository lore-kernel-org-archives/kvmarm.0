Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B1030DEB9
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 10:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756721162; cv=none; b=USFhG5kqzrC1s6XLFGE0k2kPkNDJLpJNP//U4RAMR53xDPh+gi7HeuFEudTo4hI7HdQxPwia+aIVcXcETtn12jxfvvOj25Y9XIOtgwsMJIj8tliSi+D4LfK7BPWTjizJ7tsm1RhGdegbRznGTseTxQ9F2p6dxSY+jMUzx85rJ8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756721162; c=relaxed/simple;
	bh=qqxlfHhKAhMZStIBcjXn0E21C1VTEww9NkrL79A/zCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXfEochgms5vXf1jjor3l3l0BoQczYMuL87t/LEtUa7DT2sozCC1ahoaGeq/PlVCEVBRJ59YVBgVKaTWYc7L3R/xRpWYrdYYzvGvtcJqXeB47mDQBOYSxdz742YAVXTEK377d0sSXiy1Rt30V2ENusqDFRQRnzP/covA2M7JVmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41EA62680;
	Mon,  1 Sep 2025 03:05:52 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 30E3F3F6A8;
	Mon,  1 Sep 2025 03:06:00 -0700 (PDT)
Date: Mon, 1 Sep 2025 11:05:58 +0100
From: Leo Yan <leo.yan@arm.com>
To: James Clark <james.clark@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v7 05/12] arm64/boot: Factor out a macro to check SPE
 version
Message-ID: <20250901100558.GJ745921@e132581.arm.com>
References: <20250814-james-perf-feat_spe_eft-v7-0-6a743f7fa259@linaro.org>
 <20250814-james-perf-feat_spe_eft-v7-5-6a743f7fa259@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814-james-perf-feat_spe_eft-v7-5-6a743f7fa259@linaro.org>

On Thu, Aug 14, 2025 at 10:25:27AM +0100, James Clark wrote:
> We check the version of SPE twice, and we'll add one more check in the
> next commit so factor out a macro to do this. Change the #3 magic number
> to the actual SPE version define (V1p2) to make it more readable.
> 
> No functional changes intended.
> 
> Tested-by: Leo Yan <leo.yan@arm.com>
> Signed-off-by: James Clark <james.clark@linaro.org>
> ---
>  arch/arm64/include/asm/el2_setup.h | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index 46033027510c..3a4ca7f9acfb 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -103,8 +103,7 @@
>  	csel	x2, xzr, x0, eq			// all PMU counters from EL1
>  
>  	/* Statistical profiling */
> -	ubfx	x0, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
> -	cbz	x0, .Lskip_spe_\@		// Skip if SPE not present
> +	__spe_vers_imp .Lskip_spe_\@, ID_AA64DFR0_EL1_PMSVer_IMP, x0 // Skip if SPE not present
>  
>  	mrs_s	x0, SYS_PMBIDR_EL1              // If SPE available at EL2,
>  	and	x0, x0, #(1 << PMBIDR_EL1_P_SHIFT)
> @@ -255,6 +254,14 @@
>  .Lskip_brbe_\@:
>  .endm
>  
> +/* Branch to skip_label if SPE version is less than given version */
> +.macro __spe_vers_imp skip_label, version, tmp
> +    mrs    \tmp, id_aa64dfr0_el1
> +    ubfx   \tmp, \tmp, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
> +    cmp    \tmp, \version
> +    b.lt   \skip_label
> +.endm
> +

Just wondering if we need to move the macro to the beginning of the
file, so that we can define it first and call it afterwards.

Otherwise, LGTM:

Reviewed-by: Leo Yan <leo.yan@arm.com>

>  /* Disable any fine grained traps */
>  .macro __init_el2_fgt
>  	mrs	x1, id_aa64mmfr0_el1
> @@ -263,10 +270,8 @@
>  
>  	mov	x0, xzr
>  	mov	x2, xzr
> -	mrs	x1, id_aa64dfr0_el1
> -	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
> -	cmp	x1, #3
> -	b.lt	.Lskip_spe_fgt_\@
> +	/* If SPEv1p2 is implemented, */
> +	__spe_vers_imp .Lskip_spe_fgt_\@, #ID_AA64DFR0_EL1_PMSVer_V1P2, x1
>  	/* Disable PMSNEVFR_EL1 read and write traps */
>  	orr	x0, x0, #HDFGRTR_EL2_nPMSNEVFR_EL1_MASK
>  	orr	x2, x2, #HDFGWTR_EL2_nPMSNEVFR_EL1_MASK
> 
> -- 
> 2.34.1
> 
