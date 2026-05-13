Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286B5253359
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 13:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778680417; cv=none; b=LCvolfpilsJZdOXErjwURu4QOOcStIhNaI7Z+wM2lVmHPANoHol6SKEzoFepfM/W01qpJkAZ3CUqnodvEQY+UZq6jH2uNcbwqg1+fbxH5nze7zHadXRvKlTflMQfxpNDLA8KtSpGoqdnfEM3MStQ2eNld064p7eUkXSqq7fkEXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778680417; c=relaxed/simple;
	bh=ofdHaHFEMpVkg7dUSVUdr40lziYvJsc5aRLaxKiysAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ptyUADk4C6TVfxs8hAnuAGPmYMjg3QM78YPBp4Wv1HhVgqtCJ8hlp24W8R+k5jdX6zTowqSb0FxirrI8KAD0bc9bDsRckdcdqKB+UZqTkBDiRLnPiz5wDjk9YiqIot9ZaRKVveE6FkHdvN62qU5NLvcs/O8DblkpFmoVzJMytzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oXIlV6Pq; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oXIlV6Pq"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50d864c23bdso12731cf.1
        for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 06:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778680415; x=1779285215; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8J6GRvshR84cVDL8+yqDVLhfMFpXsrxiE9ecLJtpmYg=;
        b=oXIlV6PqM1vMbRjhMbY2zSjoeYVA3Y45VNE+g4HSojZa9MV4XGOSYOYNvpGPMlz+Ds
         IJBqBgBvabByND7yq4QiX6FogL7eZf4QCrooSdNDJm6wFix1lyLJC2MfTpUyu7FjSa7D
         jf8lDq/BT59lJwdzL2GGO04nITfLaScpYoZ31f0B+iV1/+OlOyldug5jaBIGPqW8qbVZ
         seCUf19NbOi8pUlprcYw58k6F/nbNM5gUNk//+qXn0aY2ggMeE5IHEftXA1Wmb+MKIOI
         U4RgXJy9tjNj2FeoAp/RiwQLlvRBWCHynZTgVtyDlECEZEk5RLyAmM2ChQe64qnmEg1D
         hXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778680415; x=1779285215;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8J6GRvshR84cVDL8+yqDVLhfMFpXsrxiE9ecLJtpmYg=;
        b=Z/B1xjFlhT3WAJ8YKiCcJcMcRZbKRVyTkw6vy41jJenLxwbj2Lp67LjzPyx8dzCXe8
         raVIqCP7SHaBPdOGl96YElMXCaj80BUcJ7hMBUznNM5g/6iwr8n7eYYv8Yp1egFvHlFI
         aYSYyhygyWueh237uyriHWTX0P6+zSstRMTo2pFPx+nyvaFAGQFlb3/kTtl0JEfrcf0w
         W1QCqNIDSaXRARByrKznmgRFrRTAB3n9LK3fzmVW+4s4IjMiF72DMM3mbZLsPOd8lAFZ
         BS/3+JP3jq+S3B5REokVNbB+lbUTG5IyEecEpbOt77pbtfbTXkso2k9VewO1jRfIQ/YY
         0gyg==
X-Forwarded-Encrypted: i=1; AFNElJ9mXNCtfNgIIW91BrBK+O2Z91/gSsfYSquoAFbxqBdcySyyp9Cpj4QcTAipM0PSQYdDAE+N4fY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRCc8cBcPMBIQa4nj7GP0yAwU5JgG7vaeaJGxI2OKhafPtfTLw
	lOr4LVDLRb1Xg53hP1NpRrUeg9B6PlmWTNIzK/WU2dHniyUfHx7MK93cKciDR2Drng==
X-Gm-Gg: Acq92OHitpcYWj+xHJJijZN9vaUdfQp4U4nDkPcpjlThF2gBIUIRQlIRLM6MiRnow1J
	dvj7W4wdcOecLFvruIDHNL8AbkvjV/J91DFy4TYhbgm9oZ+oBGdUm1dk/1boIHvxReARnm44mxb
	c6B+jkEImJD1KeYaZq0Z8WANlzja0WJxp9RAd9INzR2BXqS47okQaIzp/UfNRQ9A8Zm5icgiiQh
	gCJl3wLJYUqbEL7WF0qOGr9v05LKeKDjPWZAVT+R3lb0UppMOzIs6kog6zMGeK2Gkiro/QDdh+w
	FLZJed+IJFyJLuE4xUeLd0Dr7MrhUzQrBhH/teGUhFBgFAG0eZWTrF0XIQqaBg78H8vSRHTdMr4
	o7PGXKN7CcDEY02IKtNvvkPnN0cXaU99k/Rpsir//CO4rejDfFisgT5nBpkm3inko8PGKlh/cMc
	3ybI6dltynyN5H8oaFm9IKQzHtZvWmySPYDRNjvQCCVYKmkLRRDYY/zc5fSAM1IzKZfycPoSF1P
	EWgmj0=
X-Received: by 2002:ac8:5c86:0:b0:510:fa1:73c5 with SMTP id d75a77b69052e-5162b16988amr18374031cf.16.1778680414453;
        Wed, 13 May 2026 06:53:34 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65db6dd6ca8sm6202887d50.4.2026.05.13.06.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 06:53:33 -0700 (PDT)
Date: Wed, 13 May 2026 13:53:24 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	sudeep.holla@kernel.org, will@kernel.org, joey.gouly@arm.com,
	korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v3 2/2] KVM: arm64: Validate the offset to the mem access
 descriptor
Message-ID: <agSCVMykWHY4pzlm@google.com>
References: <20260512124442.1899107-1-sebastianene@google.com>
 <20260512124442.1899107-3-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512124442.1899107-3-sebastianene@google.com>

On Tue, May 12, 2026 at 12:44:42PM +0000, Sebastian Ene wrote:
> Prevent the pKVM hypervisor from making assumptions that the
> endpoint memory access descriptor (EMAD) comes right after the
> FF-A memory region header.
> Prior to FF-A version 1.1 the header of the memory region
> didn't contain an offset to the endpoint memory access descriptor.
> The layout of a memory transaction looks like this from 1.1 onward:
> Type | Field name | Offset
> [ Header | ffa_mem_region  | 0
>   EMAD 1 | ffa_mem_region_attributes) | ffa_mem_region.ep_mem_offset
> ]
> Verify that the offset to the first endpoint memory access descriptor
> is within the mailbox buffer bounds.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178..34927bc1239b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -479,7 +479,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  	struct ffa_mem_region_attributes *ep_mem_access;
>  	struct ffa_composite_mem_region *reg;
>  	struct ffa_mem_region *buf;
> -	u32 offset, nr_ranges, checked_offset;
> +	u32 offset, nr_ranges, checked_offset, em_mem_access_off;
>  	int ret = 0;
>  
>  	if (addr_mbz || npages_mbz || fraglen > len ||
> @@ -508,8 +508,14 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  	buf = hyp_buffers.tx;
>  	memcpy(buf, host_buffers.tx, fraglen);
>  
> -	ep_mem_access = (void *)buf +
> -			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> +	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> +	if (em_mem_access_off >
> +	    KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE - sizeof(struct ffa_mem_region_attributes)) {
> +		ret = FFA_RET_INVALID_PARAMETERS;
> +		goto out_unlock;
> +	}
> +
> +	ep_mem_access = (void *)buf + em_mem_access_off;
>  	offset = ep_mem_access->composite_off;
>  	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
>  		ret = FFA_RET_INVALID_PARAMETERS;
> @@ -576,7 +582,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
>  	DECLARE_REG(u32, flags, ctxt, 3);
>  	struct ffa_mem_region_attributes *ep_mem_access;
>  	struct ffa_composite_mem_region *reg;
> -	u32 offset, len, fraglen, fragoff;
> +	u32 offset, len, fraglen, fragoff, em_mem_access_off;
>  	struct ffa_mem_region *buf;
>  	int ret = 0;
>  	u64 handle;
> @@ -599,8 +605,14 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
>  	len = res->a1;
>  	fraglen = res->a2;
>  
> -	ep_mem_access = (void *)buf +
> -			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> +	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> +	if (em_mem_access_off >
> +	    KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE - sizeof(struct ffa_mem_region_attributes)) {
> +		ret = FFA_RET_INVALID_PARAMETERS;
> +		goto out_unlock;
> +	}
> +
> +	ep_mem_access = (void *)buf + em_mem_access_off;
>  	offset = ep_mem_access->composite_off;
>  	/*
>  	 * We can trust the SPMD to get this right, but let's at least
> -- 
> 2.54.0.563.g4f69b47b94-goog
> 
