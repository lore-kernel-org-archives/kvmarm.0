Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76CDD36164B
	for <kvmarm@lists.linux.dev>; Fri,  8 May 2026 18:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778265924; cv=none; b=p/Sx0gEt367AKiYLELHTD/6vjpLKqoT0ZFwlhW9ltyi61s86ziGHYmI5ioL7GBWkMCGy4Ra8vAyDSXAAkT2VHyJW347KtShjKk7qHthOdW5qaTUCAXzgzt5tdSHch9/BU/FyYFNQ87pScQB1Qy3K9r1UJIuwqfbRMaS3wAGyuJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778265924; c=relaxed/simple;
	bh=Um9WPFqN7H2ySkHiR2sGQgTz8RH4w81WnNll++kO0KE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kKJJfLK5ylSpjFUxVqx6tqH0JldK4hJ5P63rmZZk8HKjw0w4wnXaXEZqCE2ZrVSub39G99qMI254qCCV+hu2QgAGcZFrNS4lqYCSpGEoJpmXV0De/L3yP8KeleJq9u72Jwq9piDGBDWXgzN1PsboyQybKFKDv/WVmmhHIw5cVSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uTmdZouw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uTmdZouw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E21E35C8;
	Fri,  8 May 2026 11:45:17 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDF5D3F763;
	Fri,  8 May 2026 11:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778265922; bh=Um9WPFqN7H2ySkHiR2sGQgTz8RH4w81WnNll++kO0KE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uTmdZouwo9E6t00HxpLFDySDpfjnNQYivZlR7bZalwSAXnoqbqYhjPvhASnVaTCdp
	 c/ZkWgRYxg9hxDM47Ti/paOahAhtcGINq//R1N/fEcFhDwNnLr/2NNnQ2ZM37aqDxo
	 o07keQreCRyqmvemlEU1mqlyhUq0Bs/VVc178Upg=
Date: Fri, 8 May 2026 19:45:19 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 4/4] firmware: arm_ffa: Defer probe until pKVM is
 initialized
Message-ID: <af4vPxsKXpJlX8Ds@e129823.arm.com>
References: <20260508-b4-ffa_plat_dev-v1-0-c5a30f8cf7b8@kernel.org>
 <20260508-b4-ffa_plat_dev-v1-4-c5a30f8cf7b8@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508-b4-ffa_plat_dev-v1-4-c5a30f8cf7b8@kernel.org>

Look good to me.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>

> When protected KVM is enabled, the kernel includes a pKVM FF-A proxy
> that sits in front of the normal FF-A driver. The proxy has to perform
> its own FF-A version negotiation and setup first, so that it can mediate
> subsequent FF-A traffic correctly.
> 
> Defer FF-A core probing until pKVM has completed initialization. This
> keeps the normal driver from negotiating the FF-A version or performing
> other transport setup before the pKVM proxy is ready, and lets the
> driver model retry probing once the protected KVM state required by the
> FF-A transport is available.
> 
> Suggested-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
> ---
>  drivers/firmware/arm_ffa/driver.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
> index e9d7dc71c06d..1fba064c2aba 100644
> --- a/drivers/firmware/arm_ffa/driver.c
> +++ b/drivers/firmware/arm_ffa/driver.c
> @@ -43,6 +43,8 @@
>  #include <linux/uuid.h>
>  #include <linux/xarray.h>
>  
> +#include <asm/virt.h>
> +
>  #include "common.h"
>  
>  #define FFA_DRIVER_VERSION	FFA_VERSION_1_2
> @@ -2039,6 +2041,10 @@ static int ffa_probe(struct platform_device *pdev)
>  	u32 buf_sz;
>  	size_t rxtx_bufsz = SZ_4K;
>  
> +	if (IS_BUILTIN(CONFIG_ARM_FFA_TRANSPORT) &&
> +	    is_protected_kvm_enabled() && !is_pkvm_initialized())
> +		return -EPROBE_DEFER;
> +
>  	ret = ffa_transport_init(&invoke_ffa_fn);
>  	if (ret)
>  		return ret;
> 
> -- 
> 2.43.0
> 

-- 
Sincerely,
Yeoreum Yun
