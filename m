Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A7A2F99BD;
	Wed, 17 Sep 2025 17:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758129873; cv=none; b=E1FbuWwZw1QvCoPtFjipaH4Go9N0yaSouX7mRIKIKEU5Sq/bDkZEg/C8qeZGp5i8odjPjNMMcPPjV6ea2TcjpD96u5wvHWA2iJvtL9YMNQodELlJ607HLCeOUh5+ra4UjwWcQaqmgof/uuLpjLdslLschvyyvIAyAMJFTF/0RV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758129873; c=relaxed/simple;
	bh=4UoXPczKg9TI8gT2C8XoVlv2Ynl1q/uZ3VhRzWWWyL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TRfhYuzkSjF5ap36pkCTKP9loCR6wgfhe9tHLcSEBI5JYxreRiANBbnVNjz2KfMk+yf+zw7ij+7ExBwmQKfMxGmkVI5czn5r7A4fkUy9q1u5AzAQCXsdn0++MJOiv4QTAZMvypIaFu1b54oV3fL/SCg2xNsX4fYQhTL+I3D/wb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mhENdb70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mhENdb70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F226AC4CEE7;
	Wed, 17 Sep 2025 17:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758129872;
	bh=4UoXPczKg9TI8gT2C8XoVlv2Ynl1q/uZ3VhRzWWWyL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mhENdb70ih5gEPAaGFnU9gvOL5vnLYRihU/D1e97SBANv3lOG9ooDfnxdId2zkmRL
	 /P6thmnX0eCCuNi/lvxGQkj9nr3VSv4mUr9aliqnlnnD7sNDR+GOZy3fQQDfEc/yce
	 cBNxIkPUd/2YHXWpJD1ZJp9cx4yWAixjHilt9qTLg5E/XQiJogwZyiTuP3l7VyXz1z
	 3ulFWme/QBIAOptneJigS3xJIGophNq4birSAF3ZI+OS0cAOleG+s7zxMxoMFGu5G6
	 hvncvb8HMzSZg1XqmChn0bAgVbr60lrNuvupZSS6lLxHqoRUcruFa8rXLNqv9htg+G
	 2ByyKb4ozUbdQ==
Date: Wed, 17 Sep 2025 14:24:29 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Leo Yan <leo.yan@arm.com>
Cc: James Clark <james.clark@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v6 00/12] perf: arm_spe: Armv8.8 SPE features
Message-ID: <aMruzdTu74rZ0RZ9@x1>
References: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>
 <20250808123913.GD3420125@e132581.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808123913.GD3420125@e132581.arm.com>

On Fri, Aug 08, 2025 at 01:39:13PM +0100, Leo Yan wrote:
> On Fri, Aug 08, 2025 at 12:22:57PM +0100, James Clark wrote:
> > Support 3 new SPE features: FEAT_SPEv1p4 filters, FEAT_SPE_EFT extended
> > filtering, and SPE_FEAT_FDS data source filtering. The features are
> > independent can be applied separately:
> > 
> >   * Prerequisite sysreg changes - patch 1
> >   * FEAT_SPEv1p4 - patches 2 - 3
> >   * FEAT_SPE_EFT - patch 4
> >   * FEAT_SPE_FDS - patches 5 - 9
> >   * FEAT_SPE_FDS Perf tool changes - patches 10 - 12
> > 
> > The first two features will work with old Perfs but a Perf change to
> > parse the new config4 is required for the last feature.
> 
> I tested FEAT_SPE_EFT (xxx_filter_mask), inv_data_src_filter
> and inv_event_filter, all of them work as expected.
> 
> Tested-by: Leo Yan <leo.yan@arm.com>

Please let me know when I can merge the tools/perf bits.

- Arnaldo
