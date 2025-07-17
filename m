Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E462F8C5C;
	Thu, 17 Jul 2025 15:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752766038; cv=none; b=BrLGdDohM+hE2wbB7AeR7LV/uTyUUL3nNPD5N23ohQrU4FHsNrcORmwUCv3+pXnS373b3jVrbCaVgBb8AVU/TtSMkRHYJNW4NaRre/M13ZAUodFCLZtA9VNdumoX21MoaYIG3FDzaAx2SxDxEaL70OxshyzgEzCV/xhODCaYBv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752766038; c=relaxed/simple;
	bh=4yydri2iXJ+vkt3rGzpbKbnKbfLngsgnmN/hlvqV+sM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eL4zG9cd/B9R35Feuy3eJAndRU4s2ZV2kGr+TKXXTE/+zGV68ysIvr9JsjVotaDNO1TJMOmx9puk1tv+Jno8W/oYxIHORBOfb2wMr+uSdEKGWBceXNlnxWwVumueWnL0VWRDyfEU+HY5ED7buIptL9hHSzoxbI1EfKFtmUn+FzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jkc2HIzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jkc2HIzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64C4C4CEE3;
	Thu, 17 Jul 2025 15:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752766037;
	bh=4yydri2iXJ+vkt3rGzpbKbnKbfLngsgnmN/hlvqV+sM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jkc2HIzlh/f85sSERCDk6FnHc0o7b/fmOkjr6/ic6/EdFaEA6woHqSEIO4UapszO3
	 e44POPFs96UF2owJnF1avPhvQuRZb5ouwef1zHHAjIy52Oz0BirO81qvr+Eh2YT8b6
	 8B8xIrTOYVNMboxBpbEH4wB1OHUbsvjAVNYlwhxBEM/r8CJNP34/vxr9JgvjPrkoca
	 9gDVTA8RV8ohYM5nBBQ4rKUGFvm1jVOwuhO4KfdUicfQSuM29KK4mSro9vBNXeCaXu
	 5/ZyE4QwYAq1ZyS+4u2iCDD0/ofDKmH9rlEu+Yb7H+ZnnDzW+otjrPKMmLW+4mE4YC
	 FCYvQo3eJAbIA==
Date: Thu, 17 Jul 2025 16:27:10 +0100
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
Subject: Re: [PATCH v3 07/10] perf: arm_spe: Add support for filtering on
 data source
Message-ID: <aHkWTlaRKdXbnA0r@willie-the-truck>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
 <20250605-james-perf-feat_spe_eft-v3-7-71b0c9f98093@linaro.org>
 <aHUOig-kaRo15ZH5@willie-the-truck>
 <7f51d4f9-7e08-49b5-ab43-8bc765bb2ca8@linaro.org>
 <aHkI5_IOV35L4YJa@willie-the-truck>
 <ca99af3b-e358-4c2b-8d62-0b6c29984391@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca99af3b-e358-4c2b-8d62-0b6c29984391@linaro.org>

On Thu, Jul 17, 2025 at 04:16:32PM +0100, James Clark wrote:
> 
> 
> On 17/07/2025 3:29 pm, Will Deacon wrote:
> > On Tue, Jul 15, 2025 at 02:04:18PM +0100, James Clark wrote:
> > > On 14/07/2025 3:04 pm, Will Deacon wrote:
> > > > On Thu, Jun 05, 2025 at 11:49:05AM +0100, James Clark wrote:
> > > > > @@ -406,6 +416,9 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
> > > > >    	if (ATTR_CFG_GET_FLD(attr, inv_event_filter))
> > > > >    		reg |= PMSFCR_EL1_FnE;
> > > > > +	if (ATTR_CFG_GET_FLD(attr, data_src_filter))
> > > > > +		reg |= PMSFCR_EL1_FDS;
> > > > 
> > > > Is the polarity correct here? The description of PMSDSFR_EL1.S<m> suggests
> > > > that setting bits to 1 _excludes_ the FDS filtering.
> > > > 
> > > 
> > > Setting filter bits to 1 means that samples matching are included. Setting
> > > bits to 0 means that they are excluded. And PMSFCR_EL1.FDS enables filtering
> > > as a whole, so if the user sets any filter bit to 1 we want to enable
> > > filtering:
> > > 
> > >    PMSDSFR_EL1.S<m>
> > > 
> > >    0b0  If PMSFCR_EL1.FDS is 1, do not record load operations that have
> > >         bits [5:0] of the Data Source packet set to <m>.
> > > 
> > >    0b1  Load operations with Data Source <m> are unaffected by
> > >         PMSFCR_EL1.FDS.
> > > 
> > > I think it's all the right way around and it ends up being the same as the
> > > other filters in SPE. Because we're using any bit being set to enable the
> > > filtering, the only thing you can't do is enable filtering with a 0 filter,
> > > but I didn't think that was useful. See the previous discussion on this
> > > here:
> > > https://lore.kernel.org/all/5752f039-51c1-4452-b5df-03ff06da7be3@linaro.org/
> > > 
> > > Reading the "Data source filtering" section in the docs change at the end
> > > might help too.
> > 
> > Sorry, but I still don't get it :/
> > 
> > afaict, if any of the bits in 'data_src_filter' are _zero_ then we
> > should set PMSFCR_EL1.FDS. That also means that a mask of zero means all
> > loads are filtered, which is what the architecture says and is what we
> > should provide to userspace.
> > 
> > Will
> 
> We'd have to add another format flag to enable data source filtering then,
> because otherwise the default would be zero and people's samples would
> disappear.
> 
> But the only use cases I could think of were more like "I want to see
> samples from data source 1":
> 
>   -e arm_spe/data_src_filter=0x1/
> 
> Or "I want to see all data sources except 1":
> 
>   -e arm_spe/data_src_filter=0xfffffffe/
> 
> Filtering out all samples with any data source didn't seem to make sense to
> me, and I think you can already do that with the other filters (remove loads
> etc).
> 
> It would be a shame to be inconsistent and to add an enable flag just for
> that one case because the other filters in SPE are auto enabled for non-zero
> values. Although to be fair for PMSFCR.FT and others, zero filters are
> explicitly not allowed:
> 
>   If this field is set to 1 and the PMSFCR_EL1.{ST, LD, B} bits are all
>   set to zero, it is CONSTRAINED UNPREDICTABLE whether no samples are
>   recorded or the PE behaves as if PMSFCR_EL1.FT is set to 0
> 
> Seems like FDS doesn't end up as neat as the others, but IMO I can't see
> anyone needing a zero filter. I did discuss it with Leo and we decided that
> we could always add the enable flag at a later date if a use case turned up
> and it wouldn't be a breaking change.
> 
> But if you think it's there so it should be exposed I can add it.

What about if we expose the inverse of PMSDSFR_EL1 to userspace instead?

Will
