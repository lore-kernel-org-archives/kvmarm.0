Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D33D23D281;
	Tue, 15 Jul 2025 12:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752584231; cv=none; b=tVm/BqySc6tTItOgT8VGUVyITBNOCrYsrE+wOJDGHpAez9PIZoZVsiopHQMSmbNbn/11XL7OqPFDkYaxlf/o07LDSED/2fMkAXwB4f0g9ZyccHhBkeJGb2rFCUafE5twyxNYxiJzi5KvlWAbnaEwHqqpSnM7i777tYqhv3egZGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752584231; c=relaxed/simple;
	bh=z5wyTPXmVEd1ZYkkyrXr7DhOnKLOMu2j6kn1bYNNu2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLB5RtKM42kSb6cRXAkKWG/H/VL9Vs7jC6eDyEuQ9lmHyEzGLY6zO98EQK+NbnSdnAcV+V5HaPc7uMg+zIuMSWxk2zXuOYd+PjjTijuUQ2+1SLTcsWp34e/d8yZrcg8zxUvbCCFreeHNH/LqXIxf4EtVZ63G6+QkF2j4IreTUbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=arXTtqQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="arXTtqQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33325C4CEE3;
	Tue, 15 Jul 2025 12:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752584231;
	bh=z5wyTPXmVEd1ZYkkyrXr7DhOnKLOMu2j6kn1bYNNu2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=arXTtqQU+QSnwZtSgZFQUCRyEQe28EGJJWhN7GEFpPYP4LLlxjVqDlko/aH5ciQih
	 BJUm0djMUY9NLb2aHxpjqmV5efA2Zwtf7wPQJwJcVI+k5CinIK41kze1nNNu19fWd7
	 RLzpIUBjYsoNK3/UnFmcQahWeijRO5uuPY6L8gtAxUEFjwyVWpQBxFIJ/CZAAU45tl
	 ImaCL9/wM+2rG8Yk0As9LpjxmLXXQrhrUdlJQrLnw/0i2wHky4ym3U1jHHnXsRphLR
	 X6dVR1HCdjYkTidS0Aqj+2qK/8nuDV9hjBVkty62m0m6tvZ/PZ7OUV5rWNwqKlEnuj
	 ECohc5Eqn9d4g==
Date: Tue, 15 Jul 2025 13:57:03 +0100
From: Will Deacon <will@kernel.org>
To: James Clark <james.clark@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
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
	Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 04/10] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
Message-ID: <aHZQH7QGhi5pbXU8@willie-the-truck>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
 <20250605-james-perf-feat_spe_eft-v3-4-71b0c9f98093@linaro.org>
 <aHUMMk9JUdK6luLN@willie-the-truck>
 <04d52182-6043-4eaf-a898-9f8ccc893e5f@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04d52182-6043-4eaf-a898-9f8ccc893e5f@linaro.org>

On Tue, Jul 15, 2025 at 01:48:03PM +0100, James Clark wrote:
> 
> 
> On 14/07/2025 2:54 pm, Will Deacon wrote:
> > On Thu, Jun 05, 2025 at 11:49:02AM +0100, James Clark wrote:
> > > SPE data source filtering (optional from Armv8.8) requires that traps to
> > > the filter register PMSDSFR be disabled. Document the requirements and
> > > disable the traps if the feature is present.
> > > 
> > > Tested-by: Leo Yan <leo.yan@arm.com>
> > > Signed-off-by: James Clark <james.clark@linaro.org>
> > > ---
> > >   Documentation/arch/arm64/booting.rst | 11 +++++++++++
> > >   arch/arm64/include/asm/el2_setup.h   | 14 ++++++++++++++
> > >   2 files changed, 25 insertions(+)
> > > 
> > > diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
> > > index dee7b6de864f..abd75085a239 100644
> > > --- a/Documentation/arch/arm64/booting.rst
> > > +++ b/Documentation/arch/arm64/booting.rst
> > > @@ -404,6 +404,17 @@ Before jumping into the kernel, the following conditions must be met:
> > >       - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
> > >       - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
> > > +  For CPUs with SPE data source filtering (FEAT_SPE_FDS):
> > > +
> > > +  - If EL3 is present:
> > > +
> > > +    - MDCR_EL3.EnPMS3 (bit 42) must be initialised to 0b1.
> > > +
> > > +  - If the kernel is entered at EL1 and EL2 is present:
> > > +
> > > +    - HDFGRTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
> > > +    - HDFGWTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
> > > +
> > >     For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
> > >     - If the kernel is entered at EL1 and EL2 is present:
> > > diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> > > index 1e7c7475e43f..02b4a7fc016e 100644
> > > --- a/arch/arm64/include/asm/el2_setup.h
> > > +++ b/arch/arm64/include/asm/el2_setup.h
> > > @@ -279,6 +279,20 @@
> > >   	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
> > >   	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
> > >   .Lskip_pmuv3p9_\@:
> > > +	mrs	x1, id_aa64dfr0_el1
> > > +	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
> > > +	/* If SPE is implemented, */
> > > +	cmp	x1, #ID_AA64DFR0_EL1_PMSVer_IMP
> > > +	b.lt	.Lskip_spefds_\@
> > > +	/* we can read PMSIDR and */
> > > +	mrs_s	x1, SYS_PMSIDR_EL1
> > > +	and	x1, x1,  #PMSIDR_EL1_FDS
> > > +	/* if FEAT_SPE_FDS is implemented, */
> > > +	cbz	x1, .Lskip_spefds_\@
> > > +	/* disable traps to PMSDSFR. */
> > > +	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
> > 
> > Why is this being done here rather than alongside the existing SPE
> > configuration of HDFGRTR_EL2 and HDFGWTR_EL2 near the start of
> > __init_el2_fgt?
> > 
> I thought everything was separated by which trap configs it writes to,
> rather than the feature. This SPE feature is in HDFGRTR2 so I put it in
> __init_el2_fgt2 rather than __init_el2_fgt.

That's fair; __init_el2_fgt isn't the right place. But the redundancy of
re-reading PMSVer from DFR0 is a little jarring.

> I suppose we could have a single __init_el2_spe that writes to both HDFGRTR
> and HDFGRTR2 but we'd have to be careful to not overwrite what was already
> done in the other sections.

Right, perhaps it would be clearer to have trap-preserving macros for
features in a specific ID register rather than per-trap configuration
register macros.

In other words, we have something like __init_fgt_aa64dfr0 which would
configure the FGT and FGT2 registers based on features in aa64dfr0. I
think you'd need to have a play to see how it ends up looking but the
main thing to avoid is having duplicate ID register parsing code for
setting up FGT and FGT2 traps.

Will
