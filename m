Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52BBC30F940
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 10:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756722431; cv=none; b=JRjSsXRSUAIxGrBgrwXdY6uFa1blV/Rq92zRSaWRBKOdBRbI47t5MDVKg+AcXAwhjn+Ess6YBpV8Ma2YsAh/9zcxVyRkQ7MHIZ33CJ3L/+ITDzUASJ2tTktMYfY/n6f5XHq761TIMW1T2TQN1OYumh+qUSJzT43dhcSyzBu9ns0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756722431; c=relaxed/simple;
	bh=47NmbuVrIcaJ5Z8LgSoWLR4Uk/hhgd/dRLf5GESG/Q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wq8trhpa4w9Ehs/6BRafhtEE919sGLGxG4rHSXUxwHecaC+/R2VS43jpmzmPcPTiNjIgpgPb6hUd38UhthDUIeoSohTZiwN7BAjO8Zkr0LWOrsOFDUtX8stSbtVMDOpoFQm43Um1APz1gXK2dxfD6UQT749VD2mbPXfOIh1/1W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6961F16A3;
	Mon,  1 Sep 2025 03:27:01 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B6EC3F6A8;
	Mon,  1 Sep 2025 03:27:09 -0700 (PDT)
Date: Mon, 1 Sep 2025 11:27:07 +0100
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
Subject: Re: [PATCH v7 09/12] perf: arm_spe: Add support for filtering on
 data source
Message-ID: <20250901102707.GL745921@e132581.arm.com>
References: <20250814-james-perf-feat_spe_eft-v7-0-6a743f7fa259@linaro.org>
 <20250814-james-perf-feat_spe_eft-v7-9-6a743f7fa259@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814-james-perf-feat_spe_eft-v7-9-6a743f7fa259@linaro.org>

On Thu, Aug 14, 2025 at 10:25:31AM +0100, James Clark wrote:
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
> 
> Tested-by: Leo Yan <leo.yan@arm.com>
> Signed-off-by: James Clark <james.clark@linaro.org>

Reviewed-by: Leo Yan <leo.yan@arm.com>
