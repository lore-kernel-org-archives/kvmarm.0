Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31789205AC1
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 08:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738570232; cv=none; b=FjSaaAqOC1wqIWFMgdGtX6Aa16YwrwkwSwkrq3hhk7DB+sbLBiRWvapGtkz2TKzXVQ73esxXgSg62jwEOTiGNH+7j6wXGUBSAwPPJi+RdWR7ZO2doCILfwkuXiDtQ0dwoOmUpDZLSxYE+LLb58glD3njnCWkgM+6zm3vkGgzlIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738570232; c=relaxed/simple;
	bh=H1CB2E56WKQIFvUzXhKB0YMNUM1bkWdcIUeiE9iPlKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=thaOXFeS8Z/bdoZmeMiB4UFShGn13f3glvhqEQ6RLIqlT3xxO1p0tjuIScPyIPvoVUzTW7dWqaQC85MWx05DwQDIMqeaE7tv9L+tMjlGLoIxQ346jHwqFu0/LNzPBdMf9YBXUlH5WJ7Au7R44O41gcBL/G+6Tc6G1cgbR2hiWkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF97A1476;
	Mon,  3 Feb 2025 00:10:52 -0800 (PST)
Received: from [10.162.16.79] (unknown [10.162.16.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2E1A3F63F;
	Mon,  3 Feb 2025 00:10:23 -0800 (PST)
Message-ID: <e63478e7-de74-4228-9b75-a26a9a3dd294@arm.com>
Date: Mon, 3 Feb 2025 13:40:20 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 06/11] perf: apple_m1: Don't disable counter in
 m1_pmu_enable_event()
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
 <20250202-arm-brbe-v19-v19-6-1c1300802385@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250202-arm-brbe-v19-v19-6-1c1300802385@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/3/25 06:13, Rob Herring (Arm) wrote:
> Currently m1_pmu_enable_event() starts by disabling the event counter
> it has been asked to enable. This should not be necessary as the
> counter (and the PMU as a whole) should not be active when
> m1_pmu_enable_event() is called.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  drivers/perf/apple_m1_cpu_pmu.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/perf/apple_m1_cpu_pmu.c b/drivers/perf/apple_m1_cpu_pmu.c
> index 06fd317529fc..39349ecec3c1 100644
> --- a/drivers/perf/apple_m1_cpu_pmu.c
> +++ b/drivers/perf/apple_m1_cpu_pmu.c
> @@ -396,10 +396,6 @@ static void m1_pmu_enable_event(struct perf_event *event)
>  	user = event->hw.config_base & M1_PMU_CFG_COUNT_USER;
>  	kernel = event->hw.config_base & M1_PMU_CFG_COUNT_KERNEL;
>  
> -	m1_pmu_disable_counter_interrupt(event->hw.idx);
> -	m1_pmu_disable_counter(event->hw.idx);
> -	isb();
> -
>  	m1_pmu_configure_counter(event->hw.idx, evt, user, kernel);
>  	m1_pmu_enable_counter(event->hw.idx);
>  	m1_pmu_enable_counter_interrupt(event->hw.idx);
> 

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
