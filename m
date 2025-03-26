Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A841F7069
	for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 16:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743007506; cv=none; b=X5YqKof3+TspmEmojn8MtQA+QBkOQ56i1XLCVrRFyEkUU+2BJFz0F8mJSdXP3Kk99veiFsXta/QjYA8/8rjA6dnWzWZPRM1HCosH8w4JQRSVZbxmU5fFNdEDzlozksIeLTpWSscO0/zZuz5xUEnDj5UOxZWqtB3sglLTT/cwdAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743007506; c=relaxed/simple;
	bh=+Vg7qfjngvUxeC9pBRayk4qvu/QCUzrPfdR/PUAsoHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FRwPItnrew/j8GK6txOqx8CpbUOZX4AM2/2ROlV73Hf3RrYbsGDT4PcDUVlhIsCzbvIa6OHTy7I80C6+G1uVzbCtVhSARJfSycgYi8rcjdyLXvDq8NKWVfW04ijubz3LaHlr49XBOfHy1couBEybL7M/fHyAbP2UAFoJxzIJwh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bg/XC385; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bg/XC385"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-abbb12bea54so6085766b.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 09:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743007503; x=1743612303; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TJcS26LBUOhpjAbenzEObokE4HdnvqfrqILTFguP4A8=;
        b=Bg/XC385dmtGST8P5qXfpxzJMSyULPPcKZhDhPaY63Ff9+ND1n0Ffdbg+AswV/LkNM
         Vhj/rERDX6QzwUB65eZUs1cYYIXhCeOaWwPfZROE0RO8EITlXv3LzNylXLB5VGKgPAUp
         vByT/dfhV0neSak5SxhjBnfsDuTN3dZPpscAkf06+Azpr/lsj61tVXmmYCFGhtx2+KLp
         sZKlno1NlV/wvtafVBJ2DGc+QPJyUnJxMrKez6AhxNOvGfPQoJfsBg3FdCzbyrBspc/4
         X4+/tZRZFpOVbghrX8RKmbY3TqWvzEeWcPiLOQ6k9JWBbr1n0BqO9YIL0opgwAKRnjHQ
         IXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743007503; x=1743612303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TJcS26LBUOhpjAbenzEObokE4HdnvqfrqILTFguP4A8=;
        b=XxaQhXhVH4AAhwa6qdXlaRzl++9Y3q5GHjCbmSOPe62ceO0HYAwxhBgkCjeoJ2Ql/C
         5M42P805WLRCEQxdQpczdfHOZZJQwtoYVegpOnl+FFJbyklHFQxNsAPWM6ZnPekKf956
         GPmQtyiFFv0RSF07Jf3+Qsytxy+qshFPjZcHaoXZdyqzzHQkHKfJV+E3IaS1Dg9UlWqS
         giaDBG65NfIHy/8h88m5tV4FPYI0NVIWfy68pfUk+7QIkKvDIzzq+zOrOEUDIEq95+av
         h0fFKTC6yetaebZD9n9Xv6ZKbsrDNJBmCQu1uTK3KJbySBKQsnW3uhwNXqg2NCeVuuvB
         rsYg==
X-Forwarded-Encrypted: i=1; AJvYcCVyzpM8D8VD/w0Ik1N/mbVmUTiNh15Sirh/c4tpq/UvHhi4D4cr8K8zxvUUnI0rnY5kf14DgDo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwawtaWsW1lZ7nVMfRwL1IR13yAfAsIMsMCZnPHmfkCzot9ndBI
	Pv3p6gPxPMs7eYglPywjXg/cv1VuhOpclSv27z3zQ4GuKF2/sYgzRZerHFW8w9ubBthwmKJe2bi
	CLA==
X-Gm-Gg: ASbGncuYqjRQb5Xh3VkK9BfTz2LADDfGwqgKmDE8aU/bMU0VwPeiR0U6WdsskgOBOJc
	eG+zG5//uMM1ATRjdUftWDmP/SkeemvwaYzaHruPbPIgxrhLLmV/NSREwwzJPIj+W4GduW+rXYU
	jtNkMjb053fFCIECrNNgrznYD1kaoBpyZIWC3EUJI0viX/2dB2qcvFUwf+k00Bgg4MK0GhAv5cC
	WgSNB+7hSFw6fVjb+6Yq8LqfBTh2Kz0HUKAvRzixvnwUp4HOiV+DduYXs0pd1a438bxJ+gr6LCQ
	Ceg6IzH9Nm5Jf12CAksR00X2ddiCWDDZPa7pY3t+w4w5q0GXE3oE5N3/OCgybHk7knBVwsTgGA6
	iMZ8=
X-Google-Smtp-Source: AGHT+IGOVJHC73PxBi8VOaVjs2DbOvsUBkfBcTBTYm45C4g3UAljCGATrWdzKXaReM4hH2C/WCgTfg==
X-Received: by 2002:a17:907:1b10:b0:ac4:3d0:8bc8 with SMTP id a640c23a62f3a-ac6fb0fcd76mr8333166b.35.1743007502398;
        Wed, 26 Mar 2025 09:45:02 -0700 (PDT)
Received: from google.com (140.20.91.34.bc.googleusercontent.com. [34.91.20.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efb52279sm1052173966b.116.2025.03.26.09.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 09:45:01 -0700 (PDT)
Date: Wed, 26 Mar 2025 16:44:58 +0000
From: Quentin Perret <qperret@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	will@kernel.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v4 2/3] firmware: arm_ffa: Move the ffa_to_linux
 definition to the ffa header
Message-ID: <Z-QvCvGBCtkxNG-e@google.com>
References: <20250326113901.3308804-1-sebastianene@google.com>
 <20250326113901.3308804-3-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326113901.3308804-3-sebastianene@google.com>

On Wednesday 26 Mar 2025 at 11:39:00 (+0000), Sebastian Ene wrote:
> Keep the ffa_to_linux error map in the header and move it away
> from the arm ffa driver to make it accessible for other components.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>

Reviewed-by: Quentin Perret <qperret@google.com>

> ---
>  drivers/firmware/arm_ffa/driver.c | 26 --------------------------
>  include/linux/arm_ffa.h           | 27 +++++++++++++++++++++++++++
>  2 files changed, 27 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
> index 2c2ec3c35f15..3f88509a15b7 100644
> --- a/drivers/firmware/arm_ffa/driver.c
> +++ b/drivers/firmware/arm_ffa/driver.c
> @@ -61,30 +61,6 @@
>  
>  static ffa_fn *invoke_ffa_fn;
>  
> -static const int ffa_linux_errmap[] = {
> -	/* better than switch case as long as return value is continuous */
> -	0,		/* FFA_RET_SUCCESS */
> -	-EOPNOTSUPP,	/* FFA_RET_NOT_SUPPORTED */
> -	-EINVAL,	/* FFA_RET_INVALID_PARAMETERS */
> -	-ENOMEM,	/* FFA_RET_NO_MEMORY */
> -	-EBUSY,		/* FFA_RET_BUSY */
> -	-EINTR,		/* FFA_RET_INTERRUPTED */
> -	-EACCES,	/* FFA_RET_DENIED */
> -	-EAGAIN,	/* FFA_RET_RETRY */
> -	-ECANCELED,	/* FFA_RET_ABORTED */
> -	-ENODATA,	/* FFA_RET_NO_DATA */
> -	-EAGAIN,	/* FFA_RET_NOT_READY */
> -};
> -
> -static inline int ffa_to_linux_errno(int errno)
> -{
> -	int err_idx = -errno;
> -
> -	if (err_idx >= 0 && err_idx < ARRAY_SIZE(ffa_linux_errmap))
> -		return ffa_linux_errmap[err_idx];
> -	return -EINVAL;
> -}
> -
>  struct ffa_pcpu_irq {
>  	struct ffa_drv_info *info;
>  };
> @@ -238,8 +214,6 @@ static int ffa_features(u32 func_feat_id, u32 input_props,
>  	return 0;
>  }
>  
> -#define PARTITION_INFO_GET_RETURN_COUNT_ONLY	BIT(0)
> -
>  /* buffer must be sizeof(struct ffa_partition_info) * num_partitions */
>  static int
>  __ffa_partition_info_get(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
> diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
> index 74169dd0f659..cdaa162060f4 100644
> --- a/include/linux/arm_ffa.h
> +++ b/include/linux/arm_ffa.h
> @@ -223,6 +223,9 @@ extern const struct bus_type ffa_bus_type;
>  /* The FF-A 1.0 partition structure lacks the uuid[4] */
>  #define FFA_1_0_PARTITON_INFO_SZ	(8)
>  
> +/* Return the count of partitions deployed in the system */
> +#define PARTITION_INFO_GET_RETURN_COUNT_ONLY	BIT(0)
> +
>  /* FFA transport related */
>  struct ffa_partition_info {
>  	u16 id;
> @@ -475,4 +478,28 @@ struct ffa_ops {
>  	const struct ffa_notifier_ops *notifier_ops;
>  };
>  
> +static const int ffa_linux_errmap[] = {
> +	/* better than switch case as long as return value is continuous */
> +	0,		/* FFA_RET_SUCCESS */
> +	-EOPNOTSUPP,	/* FFA_RET_NOT_SUPPORTED */
> +	-EINVAL,	/* FFA_RET_INVALID_PARAMETERS */
> +	-ENOMEM,	/* FFA_RET_NO_MEMORY */
> +	-EBUSY,		/* FFA_RET_BUSY */
> +	-EINTR,		/* FFA_RET_INTERRUPTED */
> +	-EACCES,	/* FFA_RET_DENIED */
> +	-EAGAIN,	/* FFA_RET_RETRY */
> +	-ECANCELED,	/* FFA_RET_ABORTED */
> +	-ENODATA,	/* FFA_RET_NO_DATA */
> +	-EAGAIN,	/* FFA_RET_NOT_READY */
> +};
> +
> +static inline int ffa_to_linux_errno(int errno)
> +{
> +	int err_idx = -errno;
> +
> +	if (err_idx >= 0 && err_idx < ARRAY_SIZE(ffa_linux_errmap))
> +		return ffa_linux_errmap[err_idx];
> +	return -EINVAL;
> +}
> +
>  #endif /* _LINUX_ARM_FFA_H */
> -- 
> 2.49.0.395.g12beb8f557-goog
> 
