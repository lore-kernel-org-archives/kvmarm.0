Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 127A1219E8
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 12:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754656757; cv=none; b=R0uvaOdC7I7ENsykAnZcZZA+yNVGauUQkFeYJknM/Z9JIVj5ivl3yI+yTw0B9sQRMSHwMQq7KO/Q5FcUwDVS6huEVriSYWfHlMsyC/AQ7z6JuuCsZs0LSFz40sngeqV9G8fjDMOl6tUg5X3UinLtfLn0sh6lyiu4oqXqz7utGSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754656757; c=relaxed/simple;
	bh=ln1HNCzo9RIwrwVk2B7h9hUQxMxOLo8AM0M6ecxItZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ak9APO6HQm9i/o4q9p8wpuHtOY0A0Pgis4UDecMMC305Fzvu60xB6FGEHwkJySHSwfqwV5NWlJBQM1tpk0D3eI+sAZ2a41NEOzUoQqCk9ghVbzvtFt3UzRrXWSSP9webm8dUwCaniBkMWLuhLhDAKhElx2v762kAF5MJDItHG+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 568FF16F8;
	Fri,  8 Aug 2025 05:39:07 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C25D3F738;
	Fri,  8 Aug 2025 05:39:15 -0700 (PDT)
Date: Fri, 8 Aug 2025 13:39:13 +0100
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
Subject: Re: [PATCH v6 00/12] perf: arm_spe: Armv8.8 SPE features
Message-ID: <20250808123913.GD3420125@e132581.arm.com>
References: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>

On Fri, Aug 08, 2025 at 12:22:57PM +0100, James Clark wrote:
> Support 3 new SPE features: FEAT_SPEv1p4 filters, FEAT_SPE_EFT extended
> filtering, and SPE_FEAT_FDS data source filtering. The features are
> independent can be applied separately:
> 
>   * Prerequisite sysreg changes - patch 1
>   * FEAT_SPEv1p4 - patches 2 - 3
>   * FEAT_SPE_EFT - patch 4
>   * FEAT_SPE_FDS - patches 5 - 9
>   * FEAT_SPE_FDS Perf tool changes - patches 10 - 12
> 
> The first two features will work with old Perfs but a Perf change to
> parse the new config4 is required for the last feature.

I tested FEAT_SPE_EFT (xxx_filter_mask), inv_data_src_filter
and inv_event_filter, all of them work as expected.

Tested-by: Leo Yan <leo.yan@arm.com>
