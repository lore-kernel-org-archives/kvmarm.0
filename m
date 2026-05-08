Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180143DB626
	for <kvmarm@lists.linux.dev>; Fri,  8 May 2026 18:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778265736; cv=none; b=UjnOkq+trqLzl5Gvb7rRVEc0u23+sC1er97+/Qr3801vPMTuWhW31DyaB5rm26lPk0HGYucBQWjUYCPpQDY4hPRQHpIg+figtYTsUi6ep1PoHP5MXHW5Saa+WAW9szlKaa/TRC+27oqjrouGbuy+MgznJbsfio/WA065CEWfo2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778265736; c=relaxed/simple;
	bh=2R0fPqfrjruSXC8XwdopLbeaSYMX4IVp2H58vn6VBkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k4Rrj84xQv/BW2IXFCKM/3NoKr2l0dRXFR2bQqhU1hB1zOljWiV7NCWHDujUB2YdPQE+vI8L+7w5XddggroHTWj9b0kCdrLQ2qPKoBzi9w49Pg08LwG3KU6zYSE5sSfyUdF7bqpSuAoeX82RyBaux9yk9Nf0wHKJ9X3oIfyHWeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ljqHJYSw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ljqHJYSw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 253951682;
	Fri,  8 May 2026 11:42:08 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 423B93F763;
	Fri,  8 May 2026 11:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778265733; bh=2R0fPqfrjruSXC8XwdopLbeaSYMX4IVp2H58vn6VBkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ljqHJYSwdfOAM9rsQ3vQWOk0Wfhf5MM+bUcBFdFcJy6Q1x3r87sztE2yx/X9kQUC9
	 HX0JUX7MXxXpnL6rx2HVsMpRrbFBHtZj7EOMvygfG+UtEr0VozxhWkA7iGbCPg+j3r
	 cBTr5HIPEBgl/ANtHs2AGesYPhri1sRhgzoWcWHA=
Date: Fri, 8 May 2026 19:42:09 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/4] firmware: arm_ffa: Set the core device as FF-A
 device parent
Message-ID: <af4ugdkfaO3m2Ile@e129823.arm.com>
References: <20260508-b4-ffa_plat_dev-v1-0-c5a30f8cf7b8@kernel.org>
 <20260508-b4-ffa_plat_dev-v1-3-c5a30f8cf7b8@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508-b4-ffa_plat_dev-v1-3-c5a30f8cf7b8@kernel.org>

LGTM.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>

> Pass a parent device into ffa_device_register() and use the synthetic
> arm-ffa platform device as the parent for each registered FF-A device.
> 
> This keeps the enumerated FF-A partition devices anchored below the FF-A
> core device in the driver model, matching the platform-driver conversion
> of the core transport.
> 
> Suggested-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
> ---
>  drivers/firmware/arm_ffa/bus.c    | 3 ++-
>  drivers/firmware/arm_ffa/driver.c | 5 +++--
>  include/linux/arm_ffa.h           | 4 ++--
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/firmware/arm_ffa/bus.c b/drivers/firmware/arm_ffa/bus.c
> index 9576862d89c4..e05fe0b6049c 100644
> --- a/drivers/firmware/arm_ffa/bus.c
> +++ b/drivers/firmware/arm_ffa/bus.c
> @@ -190,7 +190,7 @@ bool ffa_device_is_valid(struct ffa_device *ffa_dev)
>  
>  struct ffa_device *
>  ffa_device_register(const struct ffa_partition_info *part_info,
> -		    const struct ffa_ops *ops)
> +		    const struct ffa_ops *ops, struct device *parent)
>  {
>  	int id, ret;
>  	struct device *dev;
> @@ -210,6 +210,7 @@ ffa_device_register(const struct ffa_partition_info *part_info,
>  	}
>  
>  	dev = &ffa_dev->dev;
> +	dev->parent = parent;
>  	dev->bus = &ffa_bus_type;
>  	dev->release = ffa_release_device;
>  	dev->dma_mask = &dev->coherent_dma_mask;
> diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
> index 97ecdb5dac09..e9d7dc71c06d 100644
> --- a/drivers/firmware/arm_ffa/driver.c
> +++ b/drivers/firmware/arm_ffa/driver.c
> @@ -1688,7 +1688,7 @@ static int ffa_setup_host_partition(int vm_id)
>  	int ret;
>  
>  	buf.id = vm_id;
> -	ffa_dev = ffa_device_register(&buf, &ffa_drv_ops);
> +	ffa_dev = ffa_device_register(&buf, &ffa_drv_ops, &ffa_pdev->dev);
>  	if (!ffa_dev) {
>  		pr_err("%s: failed to register host partition ID 0x%x\n",
>  		       __func__, vm_id);
> @@ -1758,7 +1758,8 @@ static int ffa_setup_partitions(void)
>  		 * provides UUID here for each partition as part of the
>  		 * discovery API and the same is passed.
>  		 */
> -		ffa_dev = ffa_device_register(tpbuf, &ffa_drv_ops);
> +		ffa_dev = ffa_device_register(tpbuf, &ffa_drv_ops,
> +					      &ffa_pdev->dev);
>  		if (!ffa_dev) {
>  			pr_err("%s: failed to register partition ID 0x%x\n",
>  			       __func__, tpbuf->id);
> diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
> index 81e603839c4a..17eca3dfc59e 100644
> --- a/include/linux/arm_ffa.h
> +++ b/include/linux/arm_ffa.h
> @@ -173,7 +173,7 @@ struct ffa_partition_info;
>  #if IS_REACHABLE(CONFIG_ARM_FFA_TRANSPORT)
>  struct ffa_device *
>  ffa_device_register(const struct ffa_partition_info *part_info,
> -		    const struct ffa_ops *ops);
> +		    const struct ffa_ops *ops, struct device *parent);
>  void ffa_device_unregister(struct ffa_device *ffa_dev);
>  int ffa_driver_register(struct ffa_driver *driver, struct module *owner,
>  			const char *mod_name);
> @@ -184,7 +184,7 @@ bool ffa_device_is_valid(struct ffa_device *ffa_dev);
>  #else
>  static inline struct ffa_device *
>  ffa_device_register(const struct ffa_partition_info *part_info,
> -		    const struct ffa_ops *ops)
> +		    const struct ffa_ops *ops, struct device *parent)
>  {
>  	return NULL;
>  }
> 
> -- 
> 2.43.0
> 

-- 
Sincerely,
Yeoreum Yun
