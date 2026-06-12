Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3226B31F99F
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 13:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781272117; cv=none; b=fHHjWRVxuEDlu6RPrUglPktzD9lPORbubgy8YXS2ULNtsI7pW1qHsYvfaQ/2PIoY4z5CkATMyPCBBG0imVNFYVPsOeLMz6SxoyXqFZ8/2602O2NmZyh2KS4jVjCy9lEXJJaT9dSXhis7dXzdC3b8407wIPfhAomx5Ot8CYy2DIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781272117; c=relaxed/simple;
	bh=Bhp0IFm7+Cp5BAsXzJWBHTHsg7efmZh/L6u74kV8G6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuQ5GGzSSJIf9v9wQpao/HwEO1X6IFF/wk1wTOiJdZ87UOMqCnFQMVI/nslChhnfLkdTUkSUMfh7Q3w3Y3iUTxV79EzTz66ZmRkMa61VWW3W9UR+z6rfM70NegqsPkl0LWldqsybIPi6T4D/nvkht2qDmqidS+zg2WWF8oY/pGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QuMdT2Ji; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QuMdT2Ji"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490bb5ad3bdso60185e9.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781272112; x=1781876912; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LPd03DCEhnxVnAon/lJc1dl4riij9fpdXdHb1nTxRzM=;
        b=QuMdT2Jievl/PvUg0s63SX9T/syEZmRNQq2/+OXQE6fK+KyU74J+RIdSqavlJm945m
         LWjMIHf/JJync47GKs9lZz+y0Xq2hvhOGX6aV12Wcn1mKMmo4n9M1SIGwAhpFn1T31er
         4j5ld8uir0i7ZYdYoDnUPN/4Ij1xvN2TJgY6p+yd3WratLQ+TFyOTGsypWOEzpTAWBx4
         ORk1pmxHXmGWAg9AK+35dgdkRr/lHDs2V96663F8qouNegLp+19o3TW8kScFSR1xztLT
         GTBRUgOE6BRLLTSMbHa803YXFe6rO4FkhKbMod8d/2ADQvnhPI/0Ay8Ecjwt8iF6uvPL
         0dww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781272112; x=1781876912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LPd03DCEhnxVnAon/lJc1dl4riij9fpdXdHb1nTxRzM=;
        b=aFOtWeC/lhG+RivOmTbhXX8VNyCG2WiPFpG/miZA63d6r1MrR10b9+a/XVyF190eoz
         O68XvvMqRGFFyXpXWOK6Dav+ybkwMZlvP9tqGcm1Ajv/nfuurhtyt5RvESEJxg7BSip2
         Si1fW3bdRJa3HCck7I5uryJjYjx4f7BcGE7WZFNEliA3IO1AIrmkkeXL8u2ddw/torMk
         it33zAhRp2JoKTrhmAByTrN9uvuVqf2BQ2RL7cS2gzL9laA6nVvM2bSspeOyDFiXKT9W
         JfLMBqwSMwSvKTyrf0TWQV9qhwDkaFfmRiuEuYzXlsh2DnWg0xn3vOIl2eCSnNLuZAQu
         DdUw==
X-Forwarded-Encrypted: i=1; AFNElJ/6gslqOpb8HjQFM2pvEczr2NQC2ogKtcIIrqB/Pa/je01EsFdvD3/gqF1nZaCuIPFpz0+YWAg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQPPUC7yA7xEgIOx5onO+RYAFPNWEwHBt6qRilB/ZE0QQoYVbT
	8E62vqSVIWNa5aMcdajmXAMLwLBsOC6weF+8B5iCENSTU+AO+lkkWuy0q2xanaYmvQ==
X-Gm-Gg: Acq92OEZUo0A7Dbvai3Oeifu/uo6DcG3ayCJgr2bq61Q/HyYGUuawDyX8l0v7evGjGV
	X22jjZwwek1sZNpyWDyaw++mqnI1BcUN1ZXdVFF3Rz4nAyp3+HVzUo13n7o94zABfkpiUjVVko3
	UJVyXFOc0qxjUPgBKi6RQH4n0G/BkoePL0v/ZEG8YM+ZaKeUIWx5+Xd7IAXhlYaWPtA5KF0YMbl
	JERnHtRGJOcDkO9EqyjlO+Uz3cyWSNSjy2j9udyymiPGDk36RcsyA5UZsAaoB26RYxaF3WzCRoy
	FetgyvzBiUsxLWN8Bjwf8K/vRqnVcn56g8ZsA/+Evc1Qo+YVPjdMjSB+kVs1W+5bYDPoXzY5b5L
	70+rf5cgJ/Y36IZ+sLgEsG64pRjxJ8NBRFQg+3Ya7gxOvcIMauMGqyJIqu8gA9xjtSnpKBir18F
	zxcorLG8iLCBiH4RZq+gEekUO8oYEw7CvGp4Nhtrqv67OU9EpVwpVQ0OZlpTELCrAbdJaMpg==
X-Received: by 2002:a05:600c:a149:b0:490:be1f:66bc with SMTP id 5b1f17b1804b1-490ea57d327mr1097535e9.4.1781272111887;
        Fri, 12 Jun 2026 06:48:31 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2d09a85sm146043915e9.14.2026.06.12.06.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 06:48:31 -0700 (PDT)
Date: Fri, 12 Jun 2026 13:48:27 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, catalin.marinas@arm.com,
	jens.wiklander@linaro.org, sumit.garg@kernel.org,
	vdonnefort@google.com, sudeep.holla@kernel.org
Subject: Re: [PATCH v6 3/6] firmware: arm_ffa: Fix Endpoint Memory Access
 Descriptor offset calculation
Message-ID: <aiwOKyXN_68A54_0@google.com>
References: <20260527150236.1978655-1-smostafa@google.com>
 <20260527150236.1978655-4-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527150236.1978655-4-smostafa@google.com>

On Wed, May 27, 2026 at 03:02:33PM +0000, Mostafa Saleh wrote:

Hi Mostafa,

> From: Sebastian Ene <sebastianene@google.com>
> 
> Use the descriptor's `ep_mem_offset` to calculate the start of the endpoint
> memory access array and to comply with the FF-A spec instead of defaulting
> to `sizeof(struct ffa_mem_region)`.
> This requires moving `ffa_mem_region_additional_setup()` earlier in the setup
> flow.
> Also, add sanity checks to ensure the calculated descriptor offsets do not
> exceed `max_fragsize`.
> [@Mostafa Harden error checking]
> 
> Fixes: 113580530ee7 ("firmware: arm_ffa: Update memory descriptor to support v1.1 format")
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/firmware/arm_ffa/driver.c | 16 +++++++++++-----
>  include/linux/arm_ffa.h           |  2 +-
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
> index 059e2aae7ca0..bed4bd48963f 100644
> --- a/drivers/firmware/arm_ffa/driver.c
> +++ b/drivers/firmware/arm_ffa/driver.c
> @@ -703,19 +703,26 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
>  	struct ffa_composite_mem_region *composite;
>  	struct ffa_mem_region_addr_range *constituents;
>  	struct ffa_mem_region_attributes *ep_mem_access;
> -	u32 idx, frag_len, length, buf_sz = 0, num_entries = sg_nents(args->sg);
> +	u32 idx, frag_len, length, buf_sz = 0, num_entries = sg_nents(args->sg), ep_offset;
> +	u32 emad_size = ffa_emad_size_get(drv_info->version);
>  
>  	mem_region->tag = args->tag;
>  	mem_region->flags = args->flags;
>  	mem_region->sender_id = drv_info->vm_id;
>  	mem_region->attributes = ffa_memory_attributes_get(func_id);
> +
> +	ffa_mem_region_additional_setup(drv_info->version, mem_region);
>  	composite_offset = ffa_mem_desc_offset(buffer, args->nattrs,
>  					       drv_info->version);
> +	if (composite_offset + sizeof(*composite) > max_fragsize)
> +		return -ENXIO;
>  
>  	for (idx = 0; idx < args->nattrs; idx++) {
> -		ep_mem_access = buffer +
> -			ffa_mem_desc_offset(buffer, idx, drv_info->version);
> -		memset(ep_mem_access, 0, ffa_emad_size_get(drv_info->version));
> +		ep_offset = ffa_mem_desc_offset(buffer, idx, drv_info->version);
> +		if (ep_offset + emad_size > max_fragsize)
> +			return -ENXIO;

Looking between v3 (the version that I sent) and this version, you
account correctly for the emad_size which depends on the FF-A version
(thus the introduced call to ffa_emad_size_get()).

I think the only remaining bit here is making sure that we don't
overflow in `ep_offset + emad_size`.

> +		ep_mem_access = buffer + ep_offset;
> +		memset(ep_mem_access, 0, emad_size);
>  		ep_mem_access->receiver = args->attrs[idx].receiver;
>  		ep_mem_access->attrs = args->attrs[idx].attrs;
>  		ep_mem_access->composite_off = composite_offset;
> @@ -725,7 +732,6 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
>  	}
>  	mem_region->handle = 0;
>  	mem_region->ep_count = args->nattrs;
> -	ffa_mem_region_additional_setup(drv_info->version, mem_region);
>  
>  	composite = buffer + composite_offset;
>  	composite->total_pg_cnt = ffa_get_num_pages_sg(args->sg);
> diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
> index 81e603839c4a..62d67dae8b70 100644
> --- a/include/linux/arm_ffa.h
> +++ b/include/linux/arm_ffa.h
> @@ -445,7 +445,7 @@ ffa_mem_desc_offset(struct ffa_mem_region *buf, int count, u32 ffa_version)
>  	if (!FFA_MEM_REGION_HAS_EP_MEM_OFFSET(ffa_version))
>  		offset += offsetof(struct ffa_mem_region, ep_mem_offset);
>  	else
> -		offset += sizeof(struct ffa_mem_region);
> +		offset += buf->ep_mem_offset;
>  
>  	return offset;
>  }
> -- 
> 2.54.0.746.g67dd491aae-goog
>

Thanks,
Sebastian
