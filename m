Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E85841CAA4
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 04:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738555752; cv=none; b=nA2DTUOdD5mvXTguw7IE8pkwNVz6OJubNTVucPuY13mrFBWwHYHjRcQxACg0Mb9JV8g0nRBVA0v1udxf9e3cGeiLOE0Zc49/f6ALjRREPsbQRtMw5qpC5GN7T5ygPKf1OdG/CdnI/6cPSU3sbEHuwjhu2RIEEG12zfWdu2SdkXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738555752; c=relaxed/simple;
	bh=bcoMa0eQAZoK/33F8YMVPfn9OeW6T5JHkl52a2h2hz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i1AZCK2OZA7CEmHMmdTQymw7QzCSuuZ8S6ORXhgYpkHKHdJjjoPxbPo9TL0i4liE5xF+JO5Dsmeh14bnOzYE5LcPMDHWlxcT8jNdqX8D57KS/MBAUsZ4tm9EzZODj8xzqv+wbR0ELagpo5MtN5BnzSIX8723GFXMgsBLogCVDSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C81F61476;
	Sun,  2 Feb 2025 20:09:34 -0800 (PST)
Received: from [10.162.16.79] (unknown [10.162.16.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E58D23F63F;
	Sun,  2 Feb 2025 20:09:05 -0800 (PST)
Message-ID: <b5257952-1968-4eb3-8969-e6e3fcb5efdd@arm.com>
Date: Mon, 3 Feb 2025 09:39:02 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 04/11] perf: arm_v7_pmu: Drop obvious comments for
 enabling/disabling counters and interrupts
To: "Rob Herring (Arm)" <robh@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-4-1c1300802385@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250202-arm-brbe-v19-v19-4-1c1300802385@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/3/25 06:12, Rob Herring (Arm) wrote:
> The function calls for enabling/disabling counters and interrupts are
> pretty obvious as to what they are doing, and the comments don't add
> any additional value.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  drivers/perf/arm_v7_pmu.c | 44 --------------------------------------------
>  1 file changed, 44 deletions(-)
> 
> diff --git a/drivers/perf/arm_v7_pmu.c b/drivers/perf/arm_v7_pmu.c
> index 420cadd108e7..7fa88e3b64e0 100644
> --- a/drivers/perf/arm_v7_pmu.c
> +++ b/drivers/perf/arm_v7_pmu.c
> @@ -857,14 +857,6 @@ static void armv7pmu_enable_event(struct perf_event *event)
>  		return;
>  	}
>  
> -	/*
> -	 * Enable counter and interrupt, and set the counter to count
> -	 * the event that we're interested in.
> -	 */
> -
> -	/*
> -	 * Disable counter
> -	 */
>  	armv7_pmnc_disable_counter(idx);
>  
>  	/*
> @@ -875,14 +867,7 @@ static void armv7pmu_enable_event(struct perf_event *event)
>  	if (cpu_pmu->set_event_filter || idx != ARMV7_IDX_CYCLE_COUNTER)
>  		armv7_pmnc_write_evtsel(idx, hwc->config_base);
>  
> -	/*
> -	 * Enable interrupt for this counter
> -	 */
>  	armv7_pmnc_enable_intens(idx);
> -
> -	/*
> -	 * Enable counter
> -	 */
>  	armv7_pmnc_enable_counter(idx);
>  }
>  
> @@ -898,18 +883,7 @@ static void armv7pmu_disable_event(struct perf_event *event)
>  		return;
>  	}
>  
> -	/*
> -	 * Disable counter and interrupt
> -	 */
> -
> -	/*
> -	 * Disable counter
> -	 */
>  	armv7_pmnc_disable_counter(idx);
> -
> -	/*
> -	 * Disable interrupt for this counter
> -	 */
>  	armv7_pmnc_disable_intens(idx);
>  }
>  
> @@ -1476,12 +1450,6 @@ static void krait_pmu_enable_event(struct perf_event *event)
>  	struct hw_perf_event *hwc = &event->hw;
>  	int idx = hwc->idx;
>  
> -	/*
> -	 * Enable counter and interrupt, and set the counter to count
> -	 * the event that we're interested in.
> -	 */
> -
> -	/* Disable counter */
>  	armv7_pmnc_disable_counter(idx);
>  
>  	/*
> @@ -1494,10 +1462,7 @@ static void krait_pmu_enable_event(struct perf_event *event)
>  	else
>  		armv7_pmnc_write_evtsel(idx, hwc->config_base);
>  
> -	/* Enable interrupt for this counter */
>  	armv7_pmnc_enable_intens(idx);
> -
> -	/* Enable counter */
>  	armv7_pmnc_enable_counter(idx);
>  }
>  
> @@ -1797,12 +1762,6 @@ static void scorpion_pmu_enable_event(struct perf_event *event)
>  	struct hw_perf_event *hwc = &event->hw;
>  	int idx = hwc->idx;
>  
> -	/*
> -	 * Enable counter and interrupt, and set the counter to count
> -	 * the event that we're interested in.
> -	 */
> -
> -	/* Disable counter */
>  	armv7_pmnc_disable_counter(idx);
>  
>  	/*
> @@ -1815,10 +1774,7 @@ static void scorpion_pmu_enable_event(struct perf_event *event)
>  	else if (idx != ARMV7_IDX_CYCLE_COUNTER)
>  		armv7_pmnc_write_evtsel(idx, hwc->config_base);
>  
> -	/* Enable interrupt for this counter */
>  	armv7_pmnc_enable_intens(idx);
> -
> -	/* Enable counter */
>  	armv7_pmnc_enable_counter(idx);
>  }
>  
> 

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
