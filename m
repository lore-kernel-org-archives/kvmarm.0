Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E992D05E
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 06:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738565692; cv=none; b=VYQR2atWd3HPSkUpxQxzD12bkRD0e9/0DDi+NdkhZb/N07d1ZN4w+QoVCIbxsZIxHeqIIQrDEwwowN/fSAS2Hmj2kHQxy6fhNEp+3lFJu7GEouw+wjkUZX9VpHCrsB/li+IAb+2V7cVFuqpE6QnMqjOggP8XpjBIdtMWtnp9Frg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738565692; c=relaxed/simple;
	bh=44c9gPZIolabUiz7EogGAmPzd7JLkEOmPwGSaD765Z4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ny3iDHORRr3Lghl3ugpb7IZJSRm+pG6SGQytiLFra9HOIrkmXLKZnoZpuJJYga5ktSjLst7ILlmjqDGPpD/5Cji9v34oGBMTFcN/oLtwhj+caskCLiVBQfhfQj+o/ZmQs9bSjgfmA5kBOnKhVdMGHcuspE2pVBgu8Wm6CJL0fZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 280231476;
	Sun,  2 Feb 2025 22:55:14 -0800 (PST)
Received: from [10.162.16.79] (unknown [10.162.16.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 54C8F3F5A1;
	Sun,  2 Feb 2025 22:54:45 -0800 (PST)
Message-ID: <9a4e16af-b5b9-406f-8f9f-4d395a14a61c@arm.com>
Date: Mon, 3 Feb 2025 12:24:42 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 05/11] perf: arm_v7_pmu: Don't disable counter in
 (armv7|krait_|scorpion_)pmu_enable_event()
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
 <20250202-arm-brbe-v19-v19-5-1c1300802385@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250202-arm-brbe-v19-v19-5-1c1300802385@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/3/25 06:12, Rob Herring (Arm) wrote:
> Currently (armv7|krait_|scorpion_)pmu_enable_event() start by disabling
> the event counter it has been asked to enable. This should not be
> necessary as the counter (and the PMU as a whole) should not be active
> when *_enable_event() is called.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  drivers/perf/arm_v7_pmu.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/perf/arm_v7_pmu.c b/drivers/perf/arm_v7_pmu.c
> index 7fa88e3b64e0..17831e1920bd 100644
> --- a/drivers/perf/arm_v7_pmu.c
> +++ b/drivers/perf/arm_v7_pmu.c
> @@ -857,8 +857,6 @@ static void armv7pmu_enable_event(struct perf_event *event)
>  		return;
>  	}
>  
> -	armv7_pmnc_disable_counter(idx);
> -
>  	/*
>  	 * Set event (if destined for PMNx counters)
>  	 * We only need to set the event for the cycle counter if we
> @@ -1450,8 +1448,6 @@ static void krait_pmu_enable_event(struct perf_event *event)
>  	struct hw_perf_event *hwc = &event->hw;
>  	int idx = hwc->idx;
>  
> -	armv7_pmnc_disable_counter(idx);
> -
>  	/*
>  	 * Set event (if destined for PMNx counters)
>  	 * We set the event for the cycle counter because we
> @@ -1762,8 +1758,6 @@ static void scorpion_pmu_enable_event(struct perf_event *event)
>  	struct hw_perf_event *hwc = &event->hw;
>  	int idx = hwc->idx;
>  
> -	armv7_pmnc_disable_counter(idx);
> -
>  	/*
>  	 * Set event (if destined for PMNx counters)
>  	 * We don't set the event for the cycle counter because we
> 

LGTM

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
