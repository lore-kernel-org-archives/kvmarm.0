Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C30F206F3A
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 08:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738570606; cv=none; b=C86aVf2jEFK7eiOavUH8ystVR33bC2vGPd3HK/cQrJrY28OB2qlRc/pqGo3N2vNfEp95WenH7dPmtUL2Bf39/o+ETJPIrxOJuMvHb5XXcx0qxcvpC6etIJKhN4fDGgCtabbbhKk6TNpUdb7trlD/cfOtLrvs37waO3dOBjxJ6Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738570606; c=relaxed/simple;
	bh=OlQeYrzPVv58IrxmOumYS1K+AmbuoJdgbRxMPUPr8Gs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AuLzOgRNrkJDmK/jqyFCN0pCp7oFRZiFK3GJXxzzO39qUDi9AT7Ka+cS+Ftgq2mpQuYzzp2t1vdVMXw0KK0iyaeVcQNv1Cg2Qtfe2vVkGIIGMpNwz+hIa6euFRnW6fGwd8gvyYc+UYparYR2DGayU86+Hd9zwwcjHH2XiTj+Je4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7B261476;
	Mon,  3 Feb 2025 00:17:08 -0800 (PST)
Received: from [10.162.16.79] (unknown [10.162.16.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EB923F63F;
	Mon,  3 Feb 2025 00:16:39 -0800 (PST)
Message-ID: <522bb984-3dd7-4099-b956-f2e42af71b1c@arm.com>
Date: Mon, 3 Feb 2025 13:46:37 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 07/11] perf: arm_pmu: Move PMUv3-specific data
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
 <20250202-arm-brbe-v19-v19-7-1c1300802385@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250202-arm-brbe-v19-v19-7-1c1300802385@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 2/3/25 06:13, Rob Herring (Arm) wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> A few fields in struct arm_pmu are only used with PMUv3, and soon we
> will need to add more for BRBE. Group the fields together so that we
> have a logical place to add more data in future.
> 
> At the same time, remove the comment for reg_pmmir as it doesn't convey
> anything useful.
> 
> There should be no functional change as a result of this patch.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  include/linux/perf/arm_pmu.h | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
> index 4b5b83677e3f..c70d528594f2 100644
> --- a/include/linux/perf/arm_pmu.h
> +++ b/include/linux/perf/arm_pmu.h
> @@ -84,7 +84,6 @@ struct arm_pmu {
>  	struct pmu	pmu;
>  	cpumask_t	supported_cpus;
>  	char		*name;
> -	int		pmuver;
>  	irqreturn_t	(*handle_irq)(struct arm_pmu *pmu);
>  	void		(*enable)(struct perf_event *event);
>  	void		(*disable)(struct perf_event *event);
> @@ -102,18 +101,20 @@ struct arm_pmu {
>  	int		(*map_event)(struct perf_event *event);
>  	DECLARE_BITMAP(cntr_mask, ARMPMU_MAX_HWEVENTS);
>  	bool		secure_access; /* 32-bit ARM only */
> -#define ARMV8_PMUV3_MAX_COMMON_EVENTS		0x40
> -	DECLARE_BITMAP(pmceid_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
> -#define ARMV8_PMUV3_EXT_COMMON_EVENT_BASE	0x4000
> -	DECLARE_BITMAP(pmceid_ext_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
>  	struct platform_device	*plat_device;
>  	struct pmu_hw_events	__percpu *hw_events;
>  	struct hlist_node	node;
>  	struct notifier_block	cpu_pm_nb;
>  	/* the attr_groups array must be NULL-terminated */
>  	const struct attribute_group *attr_groups[ARMPMU_NR_ATTR_GROUPS + 1];
> -	/* store the PMMIR_EL1 to expose slots */
> +
> +	/* PMUv3 only */
> +	int		pmuver;
>  	u64		reg_pmmir;
> +#define ARMV8_PMUV3_MAX_COMMON_EVENTS		0x40
> +	DECLARE_BITMAP(pmceid_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
> +#define ARMV8_PMUV3_EXT_COMMON_EVENT_BASE	0x4000
> +	DECLARE_BITMAP(pmceid_ext_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
>  
>  	/* Only to be used by ACPI probing code */
>  	unsigned long acpi_cpuid;
> 

Makes sense.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
