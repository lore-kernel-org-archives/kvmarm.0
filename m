Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2CE670820
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 06:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738562674; cv=none; b=CjT/+u3zf7JAjLOdGvoEVjCu13QPPtTfs3ziEsbDoGUJ2+kYD1U0377SuCXGa1niyPzJnpxQevu2/OtGc6k5RgZtslUm+Txrg3Lf48250bBYZmV+NmBH98Ji/tBr/P2ZpHTfhuvnecT0dOe3XBhF1mbL7p8iyc/8N4s0Ocnylxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738562674; c=relaxed/simple;
	bh=w1IKu0BfJ+ZZ+MghaLy9rJoVvE/lYu9W/92oo9jaNXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mQOnzVojbLXUmfsUNp3CIkN/2mnAx2h3acpo4TEG2I4lh1vBKIybB8I9kmOzTddnoXh0+1fmcoQ0I4/+pRxnKixeE5jDLZZgOPWxYvEDh5ern3CPYrygo7F5OM2pqxbt9PNuZgG56rPbErH610Y++s7QrHiWRqvz68eWluODWcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E39C1476;
	Sun,  2 Feb 2025 22:04:56 -0800 (PST)
Received: from [10.162.16.79] (unknown [10.162.16.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7EF0F3F63F;
	Sun,  2 Feb 2025 22:04:27 -0800 (PST)
Message-ID: <5bcc9ffb-62a0-4b98-9b41-9cf1786751a6@arm.com>
Date: Mon, 3 Feb 2025 11:34:24 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 02/11] perf: arm_pmu: Don't disable counter in
 armpmu_add()
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
 <20250202-arm-brbe-v19-v19-2-1c1300802385@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250202-arm-brbe-v19-v19-2-1c1300802385@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/3/25 06:12, Rob Herring (Arm) wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> Currently armpmu_add() tries to handle a newly-allocated counter having
> a stale associated event, but this should not be possible, and if this

A stale associated event ? Does that mean hw_events->events[idx] still
points to a valid event even though counter idx has already been freed
up and allocated to a new event.

> were to happen the current mitigation is insufficient and potentially
> expensive. It would be better to warn if we encounter the impossible
> case.

Makes sense.

> 
> Calls to pmu::add() and pmu::del() are serialized by the core perf code,
> and armpmu_del() clears the relevant slot in pmu_hw_events::events[]
> before clearing the bit in pmu_hw_events::used_mask such that the
> counter can be reallocated. Thus when armpmu_add() allocates a counter
> index from pmu_hw_events::used_mask, it should not be possible to observe
> a stale even in pmu_hw_events::events[] unless either
> pmu_hw_events::used_mask or pmu_hw_events::events[] have been corrupted.
> 
> If this were to happen, we'd end up with two events with the same
> event->hw.idx, which would clash with each other during reprogramming,
> deletion, etc, and produce bogus results. Add a WARN_ON_ONCE() for this
> case so that we can detect if this ever occurs in practice.

Agreed.

> 
> That possiblity aside, there's no need to call arm_pmu::disable(event)

s/possiblity/possibility

> for the new event. The PMU reset code initialises the counter in a
> disabled state, and armpmu_del() will disable the counter before it can
> be reused. Remove the redundant disable.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  drivers/perf/arm_pmu.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
> index 398cce3d76fc..2f33e69a8caf 100644
> --- a/drivers/perf/arm_pmu.c
> +++ b/drivers/perf/arm_pmu.c
> @@ -342,12 +342,10 @@ armpmu_add(struct perf_event *event, int flags)
>  	if (idx < 0)
>  		return idx;
>  
> -	/*
> -	 * If there is an event in the counter we are going to use then make
> -	 * sure it is disabled.
> -	 */
> +	/* The newly-allocated counter should be empty */

Should this comment also include what happens when two events some how end
up using the same 'event->hw.idx' as mentioned in the commit message, just
to make things clearer.

> +	WARN_ON_ONCE(hw_events->events[idx]);
> +
>  	event->hw.idx = idx;
> -	armpmu->disable(event);
>  	hw_events->events[idx] = event;
>  
>  	hwc->state = PERF_HES_STOPPED | PERF_HES_UPTODATE;
> 

Otherwise LGTM.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
