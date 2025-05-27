Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1029F25484B;
	Tue, 27 May 2025 10:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748343044; cv=none; b=jd5QcvUVJnLqlCxq+elgIWKU09k+DKtNPGTj0hX4JQ3oMfta+zBgvEOo2NK5nS0+5EUBJ8cVKdNSicHnWWIOX8UGjnEGav+ULhTseHAFXXGJh8omsUHiU7Bu6elYioKA6tgofjPF96CZKS6P4BlznkMqbMRMVeKHdB88UYchwYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748343044; c=relaxed/simple;
	bh=iChCSwBj+S41jBky5HpvDJ5GYFdj24X5Q19WyfZ61l4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BBdJaCaEWkWmStINwMVWQwPIT5ZwKbmY8PLbVeW1fYo8kG9bBFkEz0PafZpwot/QVzdaw8RRI1QgFwlIYyj7jxbHC8YWCODw4jmy0qw8s6EAx5WuRNM4Sb+T8LVl6C1u7bwQ6RN4N9jIax/om4ofmg8xqjyatpaAuCmCrTFVUGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fC12pMhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fC12pMhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86ACCC4CEEE;
	Tue, 27 May 2025 10:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748343042;
	bh=iChCSwBj+S41jBky5HpvDJ5GYFdj24X5Q19WyfZ61l4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fC12pMhU7iPEXVlplCcUi3+eIAKiz7WknO0aoyXQ8C0BkMeB30LWHvcTEIpPyFsEz
	 G7KSe57I++spsiqp5Ea6QU3XS0IPHXFx0sYWcJWuc03itsBENB6xBPrIZajOTZZJUA
	 gbULJC2mebyoZw5ENZcznu44gGDJD5yjIaOm3qZRf77igm07mkaSE85g0ZIlWKAwC4
	 yh+OI4FuUFGulIYMjXtmm56lhN5BF3Ryspb2Zf3chf3GR0QhOH9zilBOljOwrll5Ay
	 vtF169JO8nkeocyvt2yVCkKJLsiJtZ9wgk4A5HfAON8/7hOih1fbPL1mbUEn5fkPnU
	 Cx+FPT40shpRQ==
Date: Tue, 27 May 2025 11:50:36 +0100
From: Will Deacon <will@kernel.org>
To: James Clark <james.clark@linaro.org>
Cc: Rob Herring <robh@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Leo Yan <leo.yan@arm.com>, linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v21 4/4] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
Message-ID: <20250527105035.GA26328@willie-the-truck>
References: <20250407-arm-brbe-v19-v21-0-ff187ff6c928@kernel.org>
 <20250407-arm-brbe-v19-v21-4-ff187ff6c928@kernel.org>
 <20250519150621.GA17177@willie-the-truck>
 <20250519215651.GB2650608-robh@kernel.org>
 <119c9a70-6ea8-46f0-b877-8a433d97ce84@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <119c9a70-6ea8-46f0-b877-8a433d97ce84@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 21, 2025 at 04:58:42PM +0100, James Clark wrote:
> 
> 
> On 19/05/2025 10:56 pm, Rob Herring wrote:
> > On Mon, May 19, 2025 at 04:06:22PM +0100, Will Deacon wrote:
> > > Hey Rob,
> > > 
> > > On Mon, Apr 07, 2025 at 12:41:33PM -0500, Rob Herring (Arm) wrote:
> > > > From: Anshuman Khandual <anshuman.khandual@arm.com>
> > > > 
> > > > The ARMv9.2 architecture introduces the optional Branch Record Buffer
> > > > Extension (BRBE), which records information about branches as they are
> > > > executed into set of branch record registers. BRBE is similar to x86's
> > > > Last Branch Record (LBR) and PowerPC's Branch History Rolling Buffer
> > > > (BHRB).
> > > 
> > > Since you picked this up from v19, the driver has changed considerably
> > > and I presume you will be continuing to extend it in future as the
> > > architecture progresses. Perhaps having you listed as Author (and
> > > crucially, in git blame :p) with Anshuman as a Co-developed-by: would be
> > > more appropriate?
> > 
> > Shrug.
> > 
> > > > ---
> > > >   drivers/perf/Kconfig         |  11 +
> > > >   drivers/perf/Makefile        |   1 +
> > > >   drivers/perf/arm_brbe.c      | 802 +++++++++++++++++++++++++++++++++++++++++++
> > > >   drivers/perf/arm_brbe.h      |  47 +++
> > > >   drivers/perf/arm_pmu.c       |  15 +-
> > > >   drivers/perf/arm_pmuv3.c     | 129 ++++++-
> > > >   include/linux/perf/arm_pmu.h |   8 +
> > > >   7 files changed, 1006 insertions(+), 7 deletions(-)
> > > 
> > > Do you know if James Clark's tests [1] are going to be respun for the
> > > perf tool? It would be handy to have some way to test this new
> > > functionality.
> > 
> > Yes. I dropped them here because I've been told by Arnaldo in the past
> > to send userspace stuff separately.
> > 
> 
> That version of the test was out of date so I've pushed the new version
> here: https://git.linaro.org/plugins/gitiles/people/james.clark/linux.git/+/16e4a18c2d5fc53736f05c9052b1d11d74909707
> 
> But I'll wait for the driver changes to be finalised before posting it. Or
> Rob can take it back into the patchset.

Thanks, James. I just wanted to make sure that there was still a plan
for upstreaming these separately from the driver. Have you had a chance
to run them against this v21?

Will
