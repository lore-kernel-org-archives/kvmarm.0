Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 680A04502F
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 06:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738564726; cv=none; b=Clg6IsH0y9MGdc62w0nrRHgHUy6Q0NgRGJYt8zgyeVhPXvHjoEdQasDQd/hSi9vYPDxvGAhSPShu/QcNEKRI32j5UGwA7+ldIwKwqZ66ZlI2ES0ck9OFz1zmMXi1ghCsmufhwXWfM+MnDPfo9SRQBeey4qK4eOD5EnuF4X5B7FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738564726; c=relaxed/simple;
	bh=KBq44VxD0mtvsZUAYhFY7MMb8UXLSNUlwTI4ITmj+/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ggdrQXg7G/My3LdoQfOoILvSd6TEviFZA0HdoROBJhNeoiX+z8HJX+PVF6PgiEgMcV39xy3Kuc1qJZGvOL5YyaOVLi3pKpKQKezZVszPAO3uHWwv+iYpTWeykU5AqTxNx/03eaMbcJXRKN+uMEKdXLLL+MWRTExhSlMha92b0W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8FC21476;
	Sun,  2 Feb 2025 22:39:06 -0800 (PST)
Received: from [10.162.16.79] (unknown [10.162.16.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 187F73F63F;
	Sun,  2 Feb 2025 22:38:37 -0800 (PST)
Message-ID: <8584f5cc-70b0-46a0-9582-8d7b4d491ba6@arm.com>
Date: Mon, 3 Feb 2025 12:08:35 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 03/11] perf: arm_pmuv3: Don't disable counter in
 armv8pmu_enable_event()
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
 <20250202-arm-brbe-v19-v19-3-1c1300802385@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250202-arm-brbe-v19-v19-3-1c1300802385@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/3/25 06:12, Rob Herring (Arm) wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> Currently armv8pmu_enable_event() starts by disabling the event counter
> it has been asked to enable. This should not be necessary as the counter
> (and the PMU as a whole) should not be active when
> armv8pmu_enable_event() is called.
Makes sense.

> 
> Remove the redundant call to armv8pmu_disable_event_counter(). At the
> same time, remove the comment immeditately above as everything it says

s/immeditately/immediately

> is obvious from the function names below.

But should this comment drop change be folded into the next patch which
exclusively drops all obviously redundant disable/enable comments.

> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  drivers/perf/arm_pmuv3.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 9ebc950559c0..5406b9ca591a 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -795,11 +795,6 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
>  
>  static void armv8pmu_enable_event(struct perf_event *event)
>  {
> -	/*
> -	 * Enable counter and interrupt, and set the counter to count
> -	 * the event that we're interested in.
> -	 */
> -	armv8pmu_disable_event_counter(event);
>  	armv8pmu_write_event_type(event);
>  	armv8pmu_enable_event_irq(event);
>  	armv8pmu_enable_event_counter(event);
> 

Otherwise LGTM.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
