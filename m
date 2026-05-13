Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58A03F4108
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 13:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778679294; cv=none; b=FFs/XWUX9AbHp46/PljYFaxkob0vt6FlwJp3pdcst4wltZfIC6SegmTbi/Ay8e6dJdlAOTFWgGUTRgq3JB7x4Fu/kLbL1ZwnlNY0rkz3VuDWxebzDx9ldfFkVBC6bgMcNoNcyMl/o80b19AVWuaLd78ykhZ2le6n5TnMj9hs41U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778679294; c=relaxed/simple;
	bh=xSGiGUyd7WdFFROHx3hnAyd4nrUNDZMnp1UdOVJOs5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APNnMNTtEZvQP00IaADY35vCTO+LI6dNz7qE7Qcwo1q1Qmg52+NN4VMNKy/BpQzx23Rk26b8+RefCNb7NPkd3hzIb95kEQJ0x24Hso1OcZ1XU1HzHgRQHDkWZhkVHon0x7FzrwHxhyZ9Pnjz5YM9KvuJMssnZwUSQfG4E4tbH0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mikHqKsA; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mikHqKsA"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4891ca4ce02so1535e9.1
        for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 06:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778679291; x=1779284091; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jGeQr4vZaey6OdXuMe/F8YfUkluAsGc9AieNXA6tGdE=;
        b=mikHqKsAdY5r/tskYRp9F85MSd4Lnog8nGYipLcQa+QvRbBnYhdwQoHUkHG1gcxTmm
         j6rzNtY/B/OdeJLBHbO3HRBlQDfcivORqkDSzr3Wm+o/w0ViDK2KSaTD4HpmRuT+x0K/
         z/Pv0u7n0DTqwd8dH8MUtWBRg5/lgNNJyI+b6DjeJ+LjQrkUwq0YFRzPfeoSZqwBd8iv
         I2jBJARjtF3nfgZXBjr0NblbaXYP8Id9E34611kcJ+BVv8L8BH/zrKPxVwMzqzvCaiUb
         OA91M6q96w1htjNe5aJ93Fg69iPF7pvI24rrM+maTu0aFSCKvjbJaimb0zs07W9lefD4
         VX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778679291; x=1779284091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jGeQr4vZaey6OdXuMe/F8YfUkluAsGc9AieNXA6tGdE=;
        b=DZLQtanxZHt78V8GHLuDpgZ1wmVO6n/OwzKFehVnMXfz2e6PvGTw05pFH5Qxi9ZJqs
         2UCG8ZfngmOc7vGgRUzCA8fnkhlIc8V8l/NSnmH6Vhy3pEWKoXsqH0l/vAZLNAePox8M
         ch83p7TL8E3LOHAgBx4kHC+1UR7YvANt2GzfmGCAplm9uD29tX+vTeyhFg7Ou74Op2BS
         mfOeaH6ZcoW6Pzv2P0brCDnNXzrUq8iimVC/g7dEcmuGzIf10KRyTKPEKycJr64+3jy+
         LiH5MBHg+ABDzpiNyvFWj7h2EQoPunvi0quyidbpA+MPQtaqxgwFe5opB/EgIVUIv2Y8
         EpLQ==
X-Forwarded-Encrypted: i=1; AFNElJ/ywrQjHC6DSA49seYB7wfWmkrV8ECgHOOYqK8EMuqB7SbY5WtWYnsXqW4Re5fVS5u9PHFpaGA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5HMDPvaFP9Qm67QNDvloW2Jb+yfQILACJUmcROInn1QQpV9/A
	1RGvgPfmYVjierF3DvcDHGHDXZ+H6G1SEQZeUVHcvKYrbX6kUlqc1tQAHKMU2nT5Gw==
X-Gm-Gg: Acq92OGT6IcTEbPp3f8zz57CvNpJUzsnEPzMKFdtVIowihwyRQ3sXeyOHBm+PsAYnFs
	HFZ4oob5vF7Vx2PMnq5WEvo7YI4hWZiX1ytQQbyNlgvoN/wqRd68ezYT7xHo4AiJi4sLYeOSWC6
	gGgXbkglpON6jbQ/wa9bEp7irTI8c+bjSXs5wAh4YvkXdZF0qMdhd0hzhowrNSTssi7dUmpx19m
	ogV/b3buiAabKeTZBEi0yRLfw+9zQ2zBjwl3+zrMzzj63EL3x/g99TAf8ufyw/ztAYUoovst0Ey
	smXSJo3Tt95CZbTHxfVvYsvIiM7bqv5qm2/2k+bny6ADIe0ZhF5Mh+ocKD/65FnqdCsx8deEfH3
	8XT2RiHoYaMELG/p6qm5LXa8OC2x391PP1fq+b9rt/9NzXxVk9JzufFn4JNWrjsbXV6DOkBJacP
	FYlsAI1Ylj6ausVvXoselmWsm2OUBcwJodTeSg8C733YKG4BJqpbJgV2ZZy6e1kEPOvgE=
X-Received: by 2002:a7b:c455:0:b0:48a:5d95:d33e with SMTP id 5b1f17b1804b1-48fc9148926mr763185e9.6.1778679290836;
        Wed, 13 May 2026 06:34:50 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce065732sm43837465e9.6.2026.05.13.06.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 06:34:48 -0700 (PDT)
Date: Wed, 13 May 2026 13:34:42 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	sudeep.holla@kernel.org, will@kernel.org, joey.gouly@arm.com,
	korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v3 1/2] firmware: arm_ffa: Fix Endpoint Memory Access
 Descriptor offset calculation
Message-ID: <agR98uWCHQBHuGNg@google.com>
References: <20260512124442.1899107-1-sebastianene@google.com>
 <20260512124442.1899107-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512124442.1899107-2-sebastianene@google.com>

On Tue, May 12, 2026 at 12:44:41PM +0000, Sebastian Ene wrote:
> Use the descriptor's `ep_mem_offset` to calculate the start of the endpoint
> memory access array and to comply with the FF-A spec instead of defaulting
> to `sizeof(struct ffa_mem_region)`.
> This requires moving `ffa_mem_region_additional_setup()` earlier in the setup
> flow.
> Also, add sanity checks to ensure the calculated descriptor offsets do not
> exceed `max_fragsize`.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  drivers/firmware/arm_ffa/driver.c | 14 ++++++++++----
>  include/linux/arm_ffa.h           |  2 +-
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
> index eb2782848283..56b166290b24 100644
> --- a/drivers/firmware/arm_ffa/driver.c
> +++ b/drivers/firmware/arm_ffa/driver.c
> @@ -685,18 +685,25 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
>  	struct ffa_composite_mem_region *composite;
>  	struct ffa_mem_region_addr_range *constituents;
>  	struct ffa_mem_region_attributes *ep_mem_access;
> -	u32 idx, frag_len, length, buf_sz = 0, num_entries = sg_nents(args->sg);
> +	u32 idx, frag_len, length, buf_sz = 0, num_entries = sg_nents(args->sg), ep_offset;
>  
>  	mem_region->tag = args->tag;
>  	mem_region->flags = args->flags;
>  	mem_region->sender_id = drv_info->vm_id;
>  	mem_region->attributes = ffa_memory_attributes_get(func_id);
> +
> +	ffa_mem_region_additional_setup(drv_info->version, mem_region);
>  	composite_offset = ffa_mem_desc_offset(buffer, args->nattrs,
>  					       drv_info->version);
> +	if (composite_offset > max_fragsize - sizeof(struct ffa_composite_mem_region))
> +		return -ENXIO;

nit: This driver seems to use sizeof() with variable name rather than
type (except for one place) so it may be good to keep that.

>  
>  	for (idx = 0; idx < args->nattrs; idx++) {
> -		ep_mem_access = buffer +
> -			ffa_mem_desc_offset(buffer, idx, drv_info->version);
> +		ep_offset = ffa_mem_desc_offset(buffer, idx, drv_info->version);
> +		if (ep_offset > max_fragsize - sizeof(struct ffa_mem_region_attributes))
> +			return -ENXIO;
> +
> +		ep_mem_access = buffer + ep_offset;
>  		ep_mem_access->receiver = args->attrs[idx].receiver;
>  		ep_mem_access->attrs = args->attrs[idx].attrs;
>  		ep_mem_access->composite_off = composite_offset;
> @@ -708,7 +715,6 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
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

Does it make sense to also set buf->ep_mem_offset for the other
case in ffa_mem_region_additional_setup() and then add this
unconditionally here?

Thanks,
Mostafa


>  
>  	return offset;
>  }
> -- 
> 2.54.0.563.g4f69b47b94-goog
> 
