Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D33FC70821
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 04:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738555668; cv=none; b=A5Jsr2rr3eCvbt/9XHyBpe/4tu+Ml7Lv+zwGf7oHryLMJa+bLy4Hlo68/ke1KaEucUdMKM7F8q1EkBHIl/RSea7XSD1mQGKIPaxsJq97dXUZJCicaat4ZvhWCOmETEv4126ovafxq8zJBeby0lO+PXY2MODMQEdzVs7K+rJyZjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738555668; c=relaxed/simple;
	bh=WiErfKDTIO2GUE6Pb3PkwOPEVJSvmC7PZ0BfyEI2FZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lRZcwlrpJewjbWm8EwFw5hx80tDt7QcurBCFmyjkfVbFkMqPBWOLPFTZIg0+jIcBRjEqIvoHvUAUS+t5vbtrfrUQZxmp29ZqXfxZ9P4o6BNjnZw1NLGQRIclqzICcNXPK+gAtp4nDFAXykmGFPdTZUPiaE988YAWuZ2Vv+CSvSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A751A1476;
	Sun,  2 Feb 2025 20:08:03 -0800 (PST)
Received: from [10.162.16.79] (unknown [10.162.16.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C29863F63F;
	Sun,  2 Feb 2025 20:07:34 -0800 (PST)
Message-ID: <1910b0da-68fe-4161-b7bb-f0d5ac8d5fe7@arm.com>
Date: Mon, 3 Feb 2025 09:37:31 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 01/11] perf: arm_pmuv3: Call kvm_vcpu_pmu_resync_el0()
 before enabling counters
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
 <20250202-arm-brbe-v19-v19-1-1c1300802385@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250202-arm-brbe-v19-v19-1-1c1300802385@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/3/25 06:12, Rob Herring (Arm) wrote:
> Counting events related to setup of the PMU is not desired, but
> kvm_vcpu_pmu_resync_el0() is called just after the PMU counters have
> been enabled. Move the call to before enabling the counters.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  drivers/perf/arm_pmuv3.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 0e360feb3432..9ebc950559c0 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -825,10 +825,10 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
>  	else
>  		armv8pmu_disable_user_access();
>  
> +	kvm_vcpu_pmu_resync_el0();
> +
>  	/* Enable all counters */
>  	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
> -
> -	kvm_vcpu_pmu_resync_el0();
>  }
>  
>  static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
> 

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
