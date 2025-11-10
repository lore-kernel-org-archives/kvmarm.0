Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074FE153BD9;
	Mon, 10 Nov 2025 15:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789725; cv=none; b=bTBS+UfuaejFlKhV7g79QT05b4rT6QsK93LCYkSgADfSkdKsaVDDbFxBW59staLNVuixFjBpj43mywOrbepdTwvV0SCXnyDftnzTHhVhE4opezR1iR3Ta8lVyJK9GiHN2orsvVkxNvYeCPRBxYyatA5tT2VkxyxrKiyXoaGWLkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789725; c=relaxed/simple;
	bh=Bn2Zyt+aIDLf4tjfg1cxJuUuA6zwIk1XsFG7lBgkeHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KniyQYUvpAE53kH/LMEGdSgTy6u/Tl4ocaocxe5zDhezh8bRg3MalilQjgXDpsY2kuCzwFKPWh0WDXyyLqsvSqxuhIxKcUPQ9scS8WFhzwyG1F5q85+F8soKNaRuDray/eifc6MA17r6Mgfm0F226duMrQk3AK/h9hJT7fHyC8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wJ0M+0La; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wJ0M+0La"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C67O4LVeg8WMDJ8KU9F1/iW0QK6epKrLMnUjULyR+wE=; b=wJ0M+0LacOP1OLv0g4ScRMqglS
	LJK9h7xh6K4qf0modj5inMpydmTdGbcMa7u9oY50NBpmiUWjjm5opruYL1W72Y/GSXDF7DHO25qvl
	586Dr6AONOKccWRf436bm2xB571dWjwNdOivv0ZI/CfrO4M/nk0JrLuNmgUUCwJIjsx7OGodPSPQe
	phSKMDJo6WAUVBX4EMKgDFu58GhCxYg0ZomDpAcyLYAzI8slSTAwij3VIviu89UTMFO0YE+gtPFnF
	WqwJJegK0lW/mea8+L2aG91IiywF2Z/9h726ZmklZ5XudGqzHMoitlRUo7gWB+t5NQNkaMGgzzgTU
	eyvGuy2Q==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIU85-000000016gd-0EKo;
	Mon, 10 Nov 2025 15:48:29 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id DE6E330029E; Mon, 10 Nov 2025 16:48:27 +0100 (CET)
Date: Mon, 10 Nov 2025 16:48:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: James Clark <james.clark@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>, Leo Yan <leo.yan@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v9 2/5] perf: arm_spe: Add support for filtering on data
 source
Message-ID: <20251110154827.GA278048@noisy.programming.kicks-ass.net>
References: <20251029-james-perf-feat_spe_eft-v9-0-d22536b9cf94@linaro.org>
 <20251029-james-perf-feat_spe_eft-v9-2-d22536b9cf94@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029-james-perf-feat_spe_eft-v9-2-d22536b9cf94@linaro.org>

On Wed, Oct 29, 2025 at 03:46:02PM +0000, James Clark wrote:
> SPE_FEAT_FDS adds the ability to filter on the data source of packets.
> Like the other existing filters, enable filtering with PMSFCR_EL1.FDS
> when any of the filter bits are set.
> 
> Each bit maps to data sources 0-63 described by bits[0:5] in the data
> source packet (although the full range of data source is 16 bits so
> higher value data sources can't be filtered on). The filter is an OR of
> all the bits, so for example clearing bits 0 and 3 only includes packets
> from data sources 0 OR 3.
> 
> Invert the filter given by userspace so that the default value of 0 is
> equivalent to including all values (no filtering). This allows us to
> skip adding a new format bit to enable filtering and still support
> excluding all data sources which would have been a filter value of 0 if
> not for the inversion.

So from that I'm reading the config4 field will only have like 16 bits,
but here:

> +#define ATTR_CFG_FLD_inv_data_src_filter_CFG	config4	/* inverse of PMSDSFR_EL1 */
> +#define ATTR_CFG_FLD_inv_data_src_filter_LO	0
> +#define ATTR_CFG_FLD_inv_data_src_filter_HI	63

you claim all 64 bits.

Also, afaict:

  #define ATTR_CFG_FLD_min_latency_CFG            config2 /* PMSLATFR_EL1.MINLAT */
  #define ATTR_CFG_FLD_min_latency_LO             0
  #define ATTR_CFG_FLD_min_latency_HI             11

Still has more than 16 bits left.


So why exactly are we needing config4? Can we please get a more solid
argument?
