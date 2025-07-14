Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABC424FC09;
	Mon, 14 Jul 2025 13:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752501411; cv=none; b=QQuarfO7c9qok2IqFAyukUhs4uFPhsn1Yv+iUkHqPE7nXfZIKWKKy07bUEuDNNMk5UVh8mdoxk708L3z5nlVV5yUVedCy08DjmVOkHOJeSh53bm2KW/pQEOeOuywk+W5szWINKISVR15OiuJGSU3quljfS8jx+lERAcaSTZPtqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752501411; c=relaxed/simple;
	bh=RvhIzF1178EACH5sRBxk0JJFnaECIpOn0lv+2agGFrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RwZsXw+WbTJ0AVyWRDyCfwNuT6qdyG5RwLyt0k8dNRd4+1Yq8NuAuqYWt3O3DnW2oxLXewjPgCYL8V5yp+H03OWiMxx6gzwrrugpPR7LKCE/pB60LXDm4ANa9FZ6RUJj7EaS1atDkvQUqywOw+XTIAKXW2rb/dzXA5VAMSCWL+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SHVMsFiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SHVMsFiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97C5C4CEED;
	Mon, 14 Jul 2025 13:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752501410;
	bh=RvhIzF1178EACH5sRBxk0JJFnaECIpOn0lv+2agGFrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SHVMsFiV2nhGLVS79/uw7C6EfvU6dSKDBpwo22vUR3TF4ARaRaSmJPfS1WWtNMXFB
	 HNq4WazkdXXB/PbdkiYBgHZ+OLynQQksyImyyDrWJN0DvUp1mK7jSO4+zI5LDc28ZQ
	 DqwnGnkrwBPjmzMjskBHhB2mdMZ5oxXfqZCA4UPtX1auC9eDUCBfWZPeeeGqaDhkA0
	 wW+KD9z8wVi9op8wlL5riVWjYhLoIslAEgvHbxQKPK+qAsZkyNOp9bLkEtq/8f78mV
	 ildM5/001t+rqW+Wtl/DB6Jbd7NS75u/cahn8ZlGvwYMFNwAORQn/raUQn6ZtjQa0H
	 7xCtq57AlezTA==
Date: Mon, 14 Jul 2025 14:56:42 +0100
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
Subject: Re: [PATCH v3 06/10] perf: Add perf_event_attr::config4
Message-ID: <aHUMmgt2fCSfxy6f@willie-the-truck>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
 <20250605-james-perf-feat_spe_eft-v3-6-71b0c9f98093@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-6-71b0c9f98093@linaro.org>

On Thu, Jun 05, 2025 at 11:49:04AM +0100, James Clark wrote:
> Arm FEAT_SPE_FDS adds the ability to filter on the data source of a
> packet using another 64-bits of event filtering control. As the existing
> perf_event_attr::configN fields are all used up for SPE PMU, an
> additional field is needed. Add a new 'config4' field.
> 
> Reviewed-by: Leo Yan <leo.yan@arm.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
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
>  };

Looks straightforward to me, but this will need an Ack from one of the perf
core maintainers.

Will
