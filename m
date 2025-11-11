Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767AC34EEE8;
	Tue, 11 Nov 2025 10:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762858543; cv=none; b=srf1J2eiJs95LuKRvHO5VNxngfG+Dj0Oo97sgeI/fv7aXQDQO+lUfzY2qGBUyPUuQEIajdd3CaEoV/AN6YDDQApry6r/oS9+/wC5BMiKrphrTHA9ZE4HvEl0iuYKp/+REqaDJFVV3umvLwBGKkdMkYWbL/MNTrNAUUnUty0228k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762858543; c=relaxed/simple;
	bh=JIiXBQ+HfWnHPFXLFi4PNYjKN8uoAMBbRfj6haUpS3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mtLNH6EbuwJqERnNMzxdgExVRjSqNbgbnDI49NYcNVqCBth7cTMyrYhumFJ2B8hbxNoYamwh4aewjXK6+EzhB7s4cKmsERGaR65eMUJSfh6lMZxRa1NYA+aVeotOqFniT2K8Edx1UtwOKF5uQEqChBwEa4h2dCUSxSS2FvnHeng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C5eRZQTa; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C5eRZQTa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xnRd3UIwh+9qZhSCRQpcmxah3gyiZrVdc2k35mDPlXQ=; b=C5eRZQTaySI5US1pSO5wDw2NYR
	32s1bpXC8pyo8HHTfDBR/mteI4rLGoP6FrtIJK+Dw8jnhwFgyVC9oyVrEFE1yMIVClqRGeN+3nizJ
	WLKEsvrvkrg6C+M63UXfcMO8zQXCcwap4v2IJN3v5WGTrNZE1Qpwbqv5Yv+lJEjszB2z3VdctDVP0
	hxRTPDmSyWwfXATdKCZf8dz1qVOGdWa0Sck3qJAU2QvcUMMU9Zl/KjKCNK3Ew3aZos7B9IgHSdibz
	5wULk7flcbk98o+9ZkgyvojJOLvB3K1q7tv4NxVPXm1NHcxvv+zQux2aRr0Nk/PMVQbidIRHiduKy
	7qOTS3nA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIlAN-0000000CyGv-3VTa;
	Tue, 11 Nov 2025 10:00:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6527A300328; Tue, 11 Nov 2025 11:55:26 +0100 (CET)
Date: Tue, 11 Nov 2025 11:55:26 +0100
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
Message-ID: <20251111105526.GI278048@noisy.programming.kicks-ass.net>
References: <20251029-james-perf-feat_spe_eft-v9-0-d22536b9cf94@linaro.org>
 <20251029-james-perf-feat_spe_eft-v9-2-d22536b9cf94@linaro.org>
 <20251110154827.GA278048@noisy.programming.kicks-ass.net>
 <8078e440-e97c-425c-b046-987b642640f7@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8078e440-e97c-425c-b046-987b642640f7@linaro.org>

On Tue, Nov 11, 2025 at 10:51:56AM +0000, James Clark wrote:
> 
> 
> On 10/11/2025 3:48 pm, Peter Zijlstra wrote:
> > On Wed, Oct 29, 2025 at 03:46:02PM +0000, James Clark wrote:
> > > SPE_FEAT_FDS adds the ability to filter on the data source of packets.
> > > Like the other existing filters, enable filtering with PMSFCR_EL1.FDS
> > > when any of the filter bits are set.
> > > 
> > > Each bit maps to data sources 0-63 described by bits[0:5] in the data
> > > source packet (although the full range of data source is 16 bits so
> > > higher value data sources can't be filtered on). The filter is an OR of
> > > all the bits, so for example clearing bits 0 and 3 only includes packets
> > > from data sources 0 OR 3.
> > > 
> > > Invert the filter given by userspace so that the default value of 0 is
> > > equivalent to including all values (no filtering). This allows us to
> > > skip adding a new format bit to enable filtering and still support
> > > excluding all data sources which would have been a filter value of 0 if
> > > not for the inversion.
> > 
> > So from that I'm reading the config4 field will only have like 16 bits,
> 
> The _data source_ is 16 bits, but the _data source filter_ is 64 bits.

Ah!

> It might be clearer if I add a few more words to differentiate "data source"
> and "filter":
> 
>   Each bit of the 64 bit filter maps to data sources 0-63 described by
>   bits[0:5] in the data source packet (although the full range of data
>   source is 16 bits so higher value data sources can't be filtered on).
>   The filter is an OR of all the filter bits, so for example clearing
>   filter bits 0 and 3 only includes packets from data sources 0 OR 3.

Yeah, that might've helped :-)
