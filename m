Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC0F2F8C5E;
	Thu, 17 Jul 2025 14:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752762607; cv=none; b=t8Gz+rQfdE4h5BCi9N8/z700al43rMRhNVNvISnsfcV95r9Bu8OxaL4I7j23Vs/KaUdOC5b5M6/EFqh1lJaXRkInsEVfDcuixqqGdN7Dvv5kFL3glrnz31ZMWNRABV5xyLaW04DpRRHdJXlPQN0afzzMNqKtUcvCXu02alrdeVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752762607; c=relaxed/simple;
	bh=0WzZkjhX8wGliBownxT0mAsfFW9ZWAVlF7kWj0BjBVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MswUs/0CvCF95Ed32c/z4JRKaFzHqX8llRKlbgce4aw9mYtlo/3M5NPSfkFPlKt+LXniYlNPL+nDP7QHbdPR49IYQJNiLkQTiJBaweYZ4FbtTMxryAJYqM6HHS6LaEmvftbYvlpRB7MwnqPvRq0VMSTnV42IjV4jkGE3LwwEQkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWQb4Zew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWQb4Zew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D731BC4CEE3;
	Thu, 17 Jul 2025 14:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752762606;
	bh=0WzZkjhX8wGliBownxT0mAsfFW9ZWAVlF7kWj0BjBVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MWQb4Zewxy9SCl7yC+evEFFUBAjupypasKkfzhneL8szoKWz2KRwNYzyViM9Gwi7G
	 gsK/ejuYavl/DjQlM5v/1g6ixBSaS14caJ3bsr0qFvRfgsCb5cEKEiLmkr6O0rG9wj
	 7QsS9I7ixvB0R+wy6EesUn6EQ/imsCIN4d6lmMUeYz4A2aKWmwZHX3k/0gs7b/LdSi
	 DbH25ErAqiaqbcBEBoV5qGVDcoMsEucJgaVcYCD4utMxqd8zz7JoHzTUtTBU53V9b7
	 gx8OWNCAf5tTG/Hz09S5WFxIc//1QUdjdaa2TGK/iuyA7uV8v4BZWf6OnoBCodtZto
	 YayyHUOrxqkMA==
Date: Thu, 17 Jul 2025 15:29:59 +0100
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
Message-ID: <aHkI5_IOV35L4YJa@willie-the-truck>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
 <20250605-james-perf-feat_spe_eft-v3-7-71b0c9f98093@linaro.org>
 <aHUOig-kaRo15ZH5@willie-the-truck>
 <7f51d4f9-7e08-49b5-ab43-8bc765bb2ca8@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f51d4f9-7e08-49b5-ab43-8bc765bb2ca8@linaro.org>

On Tue, Jul 15, 2025 at 02:04:18PM +0100, James Clark wrote:
> On 14/07/2025 3:04 pm, Will Deacon wrote:
> > On Thu, Jun 05, 2025 at 11:49:05AM +0100, James Clark wrote:
> > > @@ -406,6 +416,9 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
> > >   	if (ATTR_CFG_GET_FLD(attr, inv_event_filter))
> > >   		reg |= PMSFCR_EL1_FnE;
> > > +	if (ATTR_CFG_GET_FLD(attr, data_src_filter))
> > > +		reg |= PMSFCR_EL1_FDS;
> > 
> > Is the polarity correct here? The description of PMSDSFR_EL1.S<m> suggests
> > that setting bits to 1 _excludes_ the FDS filtering.
> > 
> 
> Setting filter bits to 1 means that samples matching are included. Setting
> bits to 0 means that they are excluded. And PMSFCR_EL1.FDS enables filtering
> as a whole, so if the user sets any filter bit to 1 we want to enable
> filtering:
> 
>   PMSDSFR_EL1.S<m>
> 
>   0b0  If PMSFCR_EL1.FDS is 1, do not record load operations that have
>        bits [5:0] of the Data Source packet set to <m>.
> 
>   0b1  Load operations with Data Source <m> are unaffected by
>        PMSFCR_EL1.FDS.
> 
> I think it's all the right way around and it ends up being the same as the
> other filters in SPE. Because we're using any bit being set to enable the
> filtering, the only thing you can't do is enable filtering with a 0 filter,
> but I didn't think that was useful. See the previous discussion on this
> here:
> https://lore.kernel.org/all/5752f039-51c1-4452-b5df-03ff06da7be3@linaro.org/
> 
> Reading the "Data source filtering" section in the docs change at the end
> might help too.

Sorry, but I still don't get it :/

afaict, if any of the bits in 'data_src_filter' are _zero_ then we
should set PMSFCR_EL1.FDS. That also means that a mask of zero means all
loads are filtered, which is what the architecture says and is what we
should provide to userspace.

Will
