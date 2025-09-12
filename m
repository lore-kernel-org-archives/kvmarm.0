Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E758D3002DE;
	Fri, 12 Sep 2025 13:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757685258; cv=none; b=fjTghRFAVTnSBCZkugb5fVmUhJQT5lMxGEdnW2KUQ18Yhpj9FdP4eKyoZnVaQZG0r39V6Tgz9htp6re1k+AS8Esks+fCAlxD94TqFGGYQVCet0HLScO8GCmMlJ5hxUruYbW+V+L6PjDFpz/+5+PCLvlZggKg51u9Aq6GYdBlznI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757685258; c=relaxed/simple;
	bh=HIAwmhCNeSypW5N4gjF2EVFOTx2Y1RaxzUCFu5jMQBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DVhNxjaWd4ddlQ/1W5YDFlDVgsMqJtMf1535F9tAevbYkN25vv8m4mbO11x1eKR5tLC4d32Oei3WkC+MFR0VlopmO+WqkS/hR6nF798+lHgThjOhu2xUkxA/LwRnKVtWhQpEZ2KRC0dKTPx+9PSxjuxNcGLicpq79PfbNLXXjac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5HLOVTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5HLOVTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B506C4CEF1;
	Fri, 12 Sep 2025 13:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757685257;
	bh=HIAwmhCNeSypW5N4gjF2EVFOTx2Y1RaxzUCFu5jMQBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d5HLOVTRn8pvc+pKJoK4+1B+mArFCpTnmR6tbLA7cUSDW726oWDdKaGQbYsR/cLNU
	 cI/PSFWIBpPpf+eU5vognCEBeEdsyiAp13aPfzJpyE3nFKYAdZVlvSUTwxgNwMWiS8
	 l7aehyrP7Sezh4COKYXi2MGFUE1NIRRWf3JNrEmtPH7jDogV8Uk47L/YhAxVcM3c+u
	 CtSEGBLgfVPKJJdbA5LEN/kIoAoVd7Is5NqKARbYhrBM6qxZfggSXrCcElxTjbSpMR
	 C0vQ7X0/32IWXF7+qgyQcIsX6uLDWzdmETRmiZl8DtpwuX+5mpD1FTe6F5JFkZxcOS
	 5sXX9B9Id3YOg==
Date: Fri, 12 Sep 2025 14:54:11 +0100
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 15/28] iommu/arm-smmu-v3: Load the driver later in KVM
 mode
Message-ID: <aMQmA9cLaeYWG5_C@willie-the-truck>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-16-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819215156.2494305-16-smostafa@google.com>

On Tue, Aug 19, 2025 at 09:51:43PM +0000, Mostafa Saleh wrote:
> While in KVM mode, the driver must be loaded after the hypervisor
> initializes.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 25 ++++++++++++++++-----
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 10ca07c6dbe9..a04730b5fe41 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -4576,12 +4576,6 @@ static const struct of_device_id arm_smmu_of_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, arm_smmu_of_match);
>  
> -static void arm_smmu_driver_unregister(struct platform_driver *drv)
> -{
> -	arm_smmu_sva_notifier_synchronize();
> -	platform_driver_unregister(drv);
> -}
> -
>  static struct platform_driver arm_smmu_driver = {
>  	.driver	= {
>  		.name			= "arm-smmu-v3",
> @@ -4592,8 +4586,27 @@ static struct platform_driver arm_smmu_driver = {
>  	.remove = arm_smmu_device_remove,
>  	.shutdown = arm_smmu_device_shutdown,
>  };
> +
> +#ifndef CONFIG_ARM_SMMU_V3_PKVM
> +static void arm_smmu_driver_unregister(struct platform_driver *drv)
> +{
> +	arm_smmu_sva_notifier_synchronize();
> +	platform_driver_unregister(drv);
> +}
> +
>  module_driver(arm_smmu_driver, platform_driver_register,
>  	      arm_smmu_driver_unregister);
> +#else
> +/*
> + * Must be done after the hypervisor initializes at module_init()
> + * No need for unregister as this is a built in driver.
> + */
> +static int arm_smmu_driver_register(void)
> +{
> +	return platform_driver_register(&arm_smmu_driver);
> +}
> +device_initcall_sync(arm_smmu_driver_register);
> +#endif /* !CONFIG_ARM_SMMU_V3_PKVM */

I think this is a bit grotty as we now have to reason about different
initialisation ordering based on CONFIG_ARM_SMMU_V3_PKVM. Could we
instead return -EPROBE_DEFER if the driver tries to probe before the
hypervisor is up?

Will
