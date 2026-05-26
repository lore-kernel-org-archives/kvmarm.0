Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FFEE3DD515
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 10:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779792687; cv=none; b=Paco1EIiZswocx+PH5vHsz4BN8gZwcsuaQYa1ZiZ9Yx76uUNz7ZscAZCS5cat2FDFft9hiFqZD8H/7HpdFZx/azghSvx9gT1F3FujXixmTy/QDHnTfFVWu+c/qHBnxshPZ3GWpFA4hPDlIgrwgaUVWV5VzZI0dU9GYoKsIOCH+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779792687; c=relaxed/simple;
	bh=ZxOUuceS2mxmDx2oNv6hCdsGaOdZS8PVj3M7iP62dbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hdpuJPBV1Lu9APJgLygruS+SgmzkjHYn7pnxT2TxcBnUPmISEVveZ3y9gqKSlYLIOu9vKgGYGcXFSUFs3VuJgnyqCD6mR/iHSuP7I68LTXxcFnsyL1+FkyJCLT9kqklj8ZE+F5zUzCTWKvRfsLDVCytq9c+UMMmyt0fbTWRRp+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k6YMIO2N; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k6YMIO2N"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92FEF169C;
	Tue, 26 May 2026 03:51:19 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 82C123F7B4;
	Tue, 26 May 2026 03:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779792684; bh=ZxOUuceS2mxmDx2oNv6hCdsGaOdZS8PVj3M7iP62dbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k6YMIO2N360Dwl1uu4plqdmpqgjBNP0wS6JklC5B/aLtkqSKVBxg+93v6VC+gfM9F
	 83lPoSShTY2rg6E4cxYx0Jjm3O0crKYxqOAVmcFUpEdpkhILGxQWRTQmfjCmzhkyER
	 WVd8dkNQ/SFUheW/uFNM62wiyfAfoakRFQhOrdhs=
Date: Tue, 26 May 2026 11:51:21 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH] firmware: arm_ffa: Treat missing FF-A feature on a
 platform as a probe miss
Message-ID: <ahV7KVX2jPhGELwF@e129823.arm.com>
References: <20260526103649.5684-1-sudeep.holla@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526103649.5684-1-sudeep.holla@kernel.org>

LGTM.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>

On Tue, May 26, 2026 at 11:36:49AM +0100, Sudeep Holla wrote:
> When FF-A initialisation is driven from a platform device probe, systems
> that do not implement FF-A can return -EOPNOTSUPP from the early transport
> or version discovery paths. Driver core treats that as a matched probe
> failure and prints:
> 
>   |  arm-ffa arm-ffa: probe with driver arm-ffa failed with error -95
> 
> That is noisy for a firmware interface that can be absent on otherwise
> valid systems. Driver core already treats -ENODEV and -ENXIO as quiet
> rejected matches, so translate only the early unsupported discovery cases
> to -ENODEV. Keep later setup failures unchanged so real FF-A
> initialisation problems are still reported as probe failures.
> 
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Closes: https://lore.kernel.org/all/20260523001148.GA1319283@ax162
> Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
> ---
>  drivers/firmware/arm_ffa/driver.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
> index 54984e1b9741..0f468362c288 100644
> --- a/drivers/firmware/arm_ffa/driver.c
> +++ b/drivers/firmware/arm_ffa/driver.c
> @@ -2109,7 +2109,7 @@ static int ffa_probe(struct platform_device *pdev)
>  
>  	ret = ffa_transport_init(&invoke_ffa_fn);
>  	if (ret)
> -		return ret;
> +		return ret == -EOPNOTSUPP ? -ENODEV : ret;
>  
>  	drv_info = kzalloc_obj(*drv_info);
>  	if (!drv_info)
> @@ -2117,8 +2117,11 @@ static int ffa_probe(struct platform_device *pdev)
>  	platform_set_drvdata(pdev, drv_info);
>  
>  	ret = ffa_version_check(&drv_info->version);
> -	if (ret)
> +	if (ret) {
> +		if (ret == -EOPNOTSUPP)
> +			ret = -ENODEV;
>  		goto free_drv_info;
> +	}
>  
>  	if (ffa_id_get(&drv_info->vm_id)) {
>  		pr_err("failed to obtain VM id for self\n");
> -- 
> 2.43.0
> 

-- 
Sincerely,
Yeoreum Yun
