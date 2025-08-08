Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 342832AE74
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 09:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754644717; cv=none; b=IIK/qqHkk7awPYLwjI0tLqMCURDDLCEUd+7DNUOPTLZXIXZcehlCC6RwflzJasDKxKVOtDQNEk2XSyppx0Vf6vzu6SMAle11mP/tWsaMpkERwVun3sJZhyYhBwRpQunE1rQZB8jLgtwdgu/3EKuZrcpGzXeqb5XeDT9gOKUJ810=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754644717; c=relaxed/simple;
	bh=t5KuL+94ednlQJ7Ve5CREJRT/5Xc6aurxRM+6BLf38c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RL39qvDBq2ySrU+IgAHMTez64NkXWKwDV34aJC27znNEZ56oJjV7CCJVgY86favye0sUhcPQVEIo1VpabjpPKi0i+/18yMGHqh9TcNwvtoTjQeDi2pBEkpExHHIgQ/v5TNcLRDo0WOKSr3cRZ5266kxiSyP79/kMsVk1jxCCbCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 329B416F2;
	Fri,  8 Aug 2025 02:18:26 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9A8E3F673;
	Fri,  8 Aug 2025 02:18:33 -0700 (PDT)
Date: Fri, 8 Aug 2025 10:18:32 +0100
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
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 05/12] arm64/boot: Factor out a macro to check SPE
 version
Message-ID: <20250808091832.GA3420125@e132581.arm.com>
References: <20250721-james-perf-feat_spe_eft-v5-0-a7bc533485a1@linaro.org>
 <20250721-james-perf-feat_spe_eft-v5-5-a7bc533485a1@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250721-james-perf-feat_spe_eft-v5-5-a7bc533485a1@linaro.org>

On Mon, Jul 21, 2025 at 02:04:59PM +0100, James Clark wrote:
> We check the version of SPE twice, and we'll add one more check in the
> next commit so factor out a macro to do this. Change the #3 magic number
> to the actual SPE version define (V1p2) to make it more readable.
> 
> No functional changes intended.

I failed to apply this patch on the mailine kernel, seems like this is
because your local tree does not include the commit:

  ae344bcb0d49 ("arm64: Handle BRBE booting requirements")

Please note the commit above has updated __init_el2_fgt so you might
need to update this patch.

Thanks,
Leo

> Signed-off-by: James Clark <james.clark@linaro.org>
> ---
>  arch/arm64/include/asm/el2_setup.h | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index 9f38340d24c2..2bb0d28952e4 100644
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
> @@ -189,6 +188,14 @@
>  .Lskip_set_cptr_\@:
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
>  /* Disable any fine grained traps */
>  .macro __init_el2_fgt
>  	mrs	x1, id_aa64mmfr0_el1
> @@ -196,10 +203,8 @@
>  	cbz	x1, .Lskip_fgt_\@
>  
>  	mov	x0, xzr
> -	mrs	x1, id_aa64dfr0_el1
> -	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
> -	cmp	x1, #3
> -	b.lt	.Lskip_spe_fgt_\@
> +	/* If SPEv1p2 is implemented, */
> +	__spe_vers_imp .Lskip_spe_fgt_\@, #ID_AA64DFR0_EL1_PMSVer_V1P2, x1
>  	/* Disable PMSNEVFR_EL1 read and write traps */
>  	orr	x0, x0, #(1 << 62)
>  
> 
> -- 
> 2.34.1
> 
> 
