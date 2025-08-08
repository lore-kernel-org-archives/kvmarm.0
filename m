Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE79B1FBEB6
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 12:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754656629; cv=none; b=Y3pNDKFnQPUCXzWLzEjwwwh98FXEf8/hOnhtGn3aZwsMIYU5TpbFBLRAJmEIA2ef6RzkHuGqN9bKFh5HDcPVDWrvObR5dQ5sCfy+yrUXp2WyXIduBSMPnTt9J4OlszC+JyBT3GevH7tS+ByjxOpt88ENAUPSp7nyjqokTaE5Snk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754656629; c=relaxed/simple;
	bh=hSZfRs7QxjiBbqw4t9VGZPhMQaXckK6qsNAKECTWHxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YFP1YmOSAeSskojqU7bVwZfVj4cP6mCD84Ztq/gYtxDvtXp8J+4zjX5g/GKtFpsDsMxXATez8jurc5pxXWxJqWeISh9BT6gBH1l8N9itomEUA9W1xfdl9nTt9qzdngcFGBuWBZliPqRPh7VfD04ZzmubR+0xOR3G6J+tdYnumy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 040D816F8;
	Fri,  8 Aug 2025 05:36:59 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC0AD3F738;
	Fri,  8 Aug 2025 05:37:06 -0700 (PDT)
Date: Fri, 8 Aug 2025 13:37:04 +0100
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
Subject: Re: [PATCH v6 12/12] perf docs: arm-spe: Document new SPE filtering
 features
Message-ID: <20250808123704.GC3420125@e132581.arm.com>
References: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>
 <20250808-james-perf-feat_spe_eft-v6-12-6daf498578c8@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808-james-perf-feat_spe_eft-v6-12-6daf498578c8@linaro.org>

On Fri, Aug 08, 2025 at 12:23:09PM +0100, James Clark wrote:

[...]

> +  data_src_filter=<mask> - mask to filter from 0-63 possible data sources (PMSDSFR, FEAT_SPE_FDS) - See 'Data source filtering'

A typo: s/data_src_filter/inv_data_src_filter
