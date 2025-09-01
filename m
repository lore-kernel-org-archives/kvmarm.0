Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CD730AD02
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 10:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756721949; cv=none; b=bETGgNul5hUwlVWp8kpcSactaRjHOqzXd783Loj9QvN5Eq4E+2k/mrmyH8S3DKqWRHb3pGJRFLqRgpAteBmyNMdtKuVqoqNM+Mb/xUlQEjSBFqsuu5DZsqXToBXW6Xhn3lC9wf/v/fFTWn0q/p/8TnOxdaTQ0i6BtFtTulxl+IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756721949; c=relaxed/simple;
	bh=KpoPdnF2+ctpKyW+VaW2pLm9WEkCvj2Er+FLCx058mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NvvRtZZmY0dwsi6hWYdl1ICTbUR43Z2m32eFZ/eMxY6sI1ba0Hu0oCIaQlNhmJJXxEI+27mDKVIWVRrW5PYOfiY91qrRcXR1RP1+kgnFxlBUJ3DcGubogisu1YD599u+XQN7CPf8SOWrTjHIEp/2uxqK/Jrn3jyfDYUGnz0hHeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C72B31A25;
	Mon,  1 Sep 2025 03:18:58 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B57893F6A8;
	Mon,  1 Sep 2025 03:19:06 -0700 (PDT)
Date: Mon, 1 Sep 2025 11:19:04 +0100
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
Subject: Re: [PATCH v7 06/12] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
Message-ID: <20250901101904.GK745921@e132581.arm.com>
References: <20250814-james-perf-feat_spe_eft-v7-0-6a743f7fa259@linaro.org>
 <20250814-james-perf-feat_spe_eft-v7-6-6a743f7fa259@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814-james-perf-feat_spe_eft-v7-6-6a743f7fa259@linaro.org>

On Thu, Aug 14, 2025 at 10:25:28AM +0100, James Clark wrote:

[...]

> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index 3a4ca7f9acfb..a0361ddcdca4 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -392,6 +392,17 @@
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
>  .Lskip_pmuv3p9_\@:
> +	/* If SPE is implemented, */
> +	__spe_vers_imp .Lskip_spefds_\@, ID_AA64DFR0_EL1_PMSVer_IMP, x1
> +	/* we can read PMSIDR and */
> +	mrs_s	x1, SYS_PMSIDR_EL1
> +	and	x1, x1,  #PMSIDR_EL1_FDS
> +	/* if FEAT_SPE_FDS is implemented, */
> +	cbz	x1, .Lskip_spefds_\@
> +	/* disable traps to PMSDSFR. */

Nitpick: the comment is a bit ambiguous for me. Would it be better to
say "disable traps to EL2" or "set the PMSDSFR bit to disable trapping" ?

Otherwise, LGTM:

Reviewed-by: Leo Yan <leo.yan@arm.com>

> +	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
> +
> +.Lskip_spefds_\@:
>  	msr_s   SYS_HDFGRTR2_EL2, x0
>  	msr_s   SYS_HDFGWTR2_EL2, x0
>  	msr_s   SYS_HFGRTR2_EL2, xzr
> 
> -- 
> 2.34.1
> 
