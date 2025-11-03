Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74167274B39;
	Mon,  3 Nov 2025 14:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762180410; cv=none; b=vD7b827Allh9jAot84mFtTXzktpRasnV4R+jZKPy1DQwCDq/xW1Y29cIQHh5DjVYOGPrRcR/ATloNeKNGCm6QDqQa+Th6D8tYfeUcIyccKiTJGn0nl19AKHkCutXIYboj5ydFhJcYVQdRigKpaG7LfbTKNUeeN9C993H1CgeyrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762180410; c=relaxed/simple;
	bh=ADIEP2R4Ye3a32o5urTgbZq2x2MIrVSu4eY4ppawa+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kT5m0tuGkWv62YFytd8yrK4j5IWm4FBCjJdFJS9LbpErjsh0pOM9Jck71iezkvsCg3Z4Z1TuB6ah/+vkf0vDCyB1BtS1FlRV4ek617xvJEpkSQSfsYej9B8Ic+GpZrcdxYoTQd8kqDOo4q/R1kRz9lIxsAytsiKE1UOAo6fXBno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pu0EgPfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pu0EgPfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AD8C4CEE7;
	Mon,  3 Nov 2025 14:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762180410;
	bh=ADIEP2R4Ye3a32o5urTgbZq2x2MIrVSu4eY4ppawa+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pu0EgPfzvjxNzAIsMUXSORw/6lYc9GfU4GaBq2sILlsDpGtjsrmRc+YdwDv3m6ake
	 JHxJ2Yay279m0qKorZ3WYC67v1gF4ln6k4IMb6+HwrSwsVQeFUbzJzigRn5MHI9OeY
	 qjVx5buHc9KVTKW/R1cvEsti/x+qNEUhwlk0a9XjuQEbOoV9QnImX50GUpNci/qCxz
	 vql1rTt+ETn/+hUSJH3lr6oIYzPVgxk82JOo7j5i+UALRm5az5Ofga8DTAx6ACk3f9
	 rlAw2wYpEkHIcl89YFRv2J0vO2tS295cEnBqrcyv1DbPNunAfRoPNJeAmmKBbkbkzT
	 q/NtfE39BpBVA==
Date: Mon, 3 Nov 2025 14:33:22 +0000
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
	Adrian Hunter <adrian.hunter@intel.com>, Leo Yan <leo.yan@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v9 1/5] perf: Add perf_event_attr::config4
Message-ID: <aQi9MstZTsloKmeo@willie-the-truck>
References: <20251029-james-perf-feat_spe_eft-v9-0-d22536b9cf94@linaro.org>
 <20251029-james-perf-feat_spe_eft-v9-1-d22536b9cf94@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029-james-perf-feat_spe_eft-v9-1-d22536b9cf94@linaro.org>

On Wed, Oct 29, 2025 at 03:46:01PM +0000, James Clark wrote:
> Arm FEAT_SPE_FDS adds the ability to filter on the data source of a
> packet using another 64-bits of event filtering control. As the existing
> perf_event_attr::configN fields are all used up for SPE PMU, an
> additional field is needed. Add a new 'config4' field.
> 
> Reviewed-by: Leo Yan <leo.yan@arm.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Reviewed-by: Ian Rogers <irogers@google.com>
> Signed-off-by: James Clark <james.clark@linaro.org>
> ---
>  include/uapi/linux/perf_event.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 78a362b80027..0d0ed85ad8cb 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -382,6 +382,7 @@ enum perf_event_read_format {
>  #define PERF_ATTR_SIZE_VER6			120	/* Add: aux_sample_size */
>  #define PERF_ATTR_SIZE_VER7			128	/* Add: sig_data */
>  #define PERF_ATTR_SIZE_VER8			136	/* Add: config3 */
> +#define PERF_ATTR_SIZE_VER9			144	/* add: config4 */
>  
>  /*
>   * 'struct perf_event_attr' contains various attributes that define
> @@ -543,6 +544,7 @@ struct perf_event_attr {
>  	__u64	sig_data;
>  
>  	__u64	config3; /* extension of config2 */
> +	__u64	config4; /* extension of config3 */

Please can one of the core perf maintainers ack/nak this extension?

Cheers,

Will
