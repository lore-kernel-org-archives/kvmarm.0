Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21C93B52E1
	for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785251273; cv=none; b=qiJM+qw/oz9SNN1N7BuoBcrhUdg/rhjNl77jsC1Ggx7iaESJ6CGWU1ylGEQZgboO6pcLYyoSXSXspO4mUP5o8YX/qhy9EOxGHvZPvqHGix8i49Y/e9FJFE7bADYMD6eEsFvOCp3AeWWHramQBaTKcwSrQwRcsmPKk2s93utTGo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785251273; c=relaxed/simple;
	bh=BD1LV6gEweEYUjcl9ARIkRkGvDhvtnv+9e/uvIhdghI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lW2LUiwkPpJ/G9ZGUfg6RnBN4d4ZkOqks9kmpRUfCkoVU7ciudvhldtMFYdZWDEH0d9Lq3IHy4EY4HDE+qT7EEAFfyt2bz9pfTZEH+DY+m37CtSAOl4dns51mk48U9xI6l4WPES24gKIFm8PD+N4eHkXnSkMTu2d6lJPUnxnDKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p/2GpzZ5; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p/2GpzZ5"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2BF3B169E;
	Tue, 28 Jul 2026 08:07:46 -0700 (PDT)
Received: from [10.2.212.23] (e121345-lin.cambridge.arm.com [10.2.212.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0824B3F66F;
	Tue, 28 Jul 2026 08:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785251270; bh=BD1LV6gEweEYUjcl9ARIkRkGvDhvtnv+9e/uvIhdghI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p/2GpzZ5F0kbQ5EoZfBqT6yq53KWffSqkwhsIwKSHFzBhk0XWz3iHGtbOpnwKHDaR
	 +mZWUXOg8abFit3hXggkmWfs+gpD13GREcrsMwRHMljNbkHBS+FeDf/VC9w1pW9RMp
	 idzWRxlG6MXIBei4T3i++d8CNJbO219W9tqEu8Ng=
Message-ID: <b8b1fbe4-fb73-418a-b43d-086894d31ce8@arm.com>
Date: Tue, 28 Jul 2026 16:07:44 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/21] perf: arm_pmuv3: Check cntr_mask before using
 pmccntr
To: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Shuah Khan <shuah@kernel.org>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260612192909.1153907-1-coltonlewis@google.com>
 <20260612192909.1153907-6-coltonlewis@google.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20260612192909.1153907-6-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/06/2026 8:28 pm, Colton Lewis wrote:
> Check cntr_mask before using pmccntr to ensure it's available. With a
> partitioned PMU, there may be instances where pmccntr is being used by
> the guest and will be absent from cntr_mask.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>   drivers/perf/arm_pmuv3.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 1cceb1f614515..17bb1cfdc271c 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -1028,7 +1028,8 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
>   
>   	/* Always prefer to place a cycle counter into the cycle counter. */
>   	if (armv8pmu_can_use_pmccntr(cpuc, event)) {

Something smells wrong here - we can use PMCCNTR but we can't?

> -		if (!test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
> +		if (test_bit(ARMV8_PMU_CYCLE_IDX, cpu_pmu->cntr_mask) &&

...i.e. this test would seem to belong in the helper function.

> +		    !test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
>   			return ARMV8_PMU_CYCLE_IDX;
>   		else if (armv8pmu_event_is_64bit(event) &&
>   			   armv8pmu_event_want_user_access(event) &&

Plus it also doesn't make much sense to fall through to the "we _could_ 
accommodate this event if only PMCCNTR was free" case here if we know 
PMCCNTR can never be free because it's not even available.

Thanks,
Robin.
