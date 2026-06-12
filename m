Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35F9340A6B
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781277638; cv=none; b=Ev3E1Pgk5pD7eIRdTus628QT3ru42EFFKRmBOr1udBgrx6Vz+kfcWzBCu6kmNluGk5FJK6rM0ei8aDB598Nba9Br7PeUvP3xqIbuM6XB1jqptP/xp4NWDsu5tGTB61oD97mF9U4nY8yUp97/lJFwo4WMb6mkA8tXQXI306rJSRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781277638; c=relaxed/simple;
	bh=y4gUR7PK7kB9TGfGnWD6YdieymSk4ciySNgT4AjfdVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOfA2lsOA3DhqiuiMhlklOlmtkqHYCg3ky4R9gvK53tha0ZVGyG4SmbKenMaEqEKQjATZax853BOx7y16ppftwrxrWZsIk2b2jSXoQ5k///FP46bwAr5oy1q+nAK9PBW5uSslPNQkAAFqNY/XH7STmGZFzjb0VHGNUqeVmNJ5p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j0guJ3IW; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j0guJ3IW"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490b23c828aso60215e9.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 08:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781277635; x=1781882435; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M73/czaUWyBGnw72mY49ubaGrHPAbyEOgxiU49yDTv4=;
        b=j0guJ3IWsvhgw9VjQUIQ6NzVxjVk0WQuDJlgAw1Vo8TwZgJYFj34Rmtmc16/ZGpM2G
         3zwVC9gtghP6ugTOPz6f6YhIcksz2j8CD6kdhOLLCWTvtHipN5h+hJ/XmeEBH7MIUyNZ
         vIUXVzVTcJ/ctR4M4bAQxzZ8FEuiVS0uhz869UmfrB4aij4m3nuLESGMArj/1nXmAKug
         V+hgH2xv2OsOq1/3dv+MJJoJ0VQiMUlsuIqOOTrzRpv+Sqd51X2XnbCIIVLGGQdRH6kW
         tbfsT3H0mio8KwopmlpDna6NLQfaQni2nUl1pdKu7Eo0pRP7UvRKDdxNdB5F9pZuOVvF
         zTIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781277635; x=1781882435;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M73/czaUWyBGnw72mY49ubaGrHPAbyEOgxiU49yDTv4=;
        b=Q5c5UegSgjoLKPXIvorqRFh5HPXpnA46wiLqQdXHLZr3nejEhm0RthAJwbzPEDrhip
         Jy5W9pzkVrHW+QNcA2GkYywJfJLX2HglMN4XeoycwSamzP6SFYCn1aL0m3/rdd/jUbDR
         jp5NHI8Ue0p5B/PrCdnqTGk7QKZLhlNisXQgcXsfSz6siCme3HKagPzawoLtjOAthC9T
         7FtPecaov7OCjfR26sYJ2wrTvIwhX028o3x/M3jLt1MCXJO1uEllpOR7nlDqezkANlw2
         VDPyZQtRbPtjMak2DD2DPN0nc5jw11DxRa1/4iXjrPJNJwqQa6LoaZ4fZm9LUQCKXdco
         Qarg==
X-Forwarded-Encrypted: i=1; AFNElJ+UpY92HXJctuNRaub/iRITemSm+lePsgz++pO42YQYCthb8RUXD9faPq7CNahEGuoqCtwtv9M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3+Xc4Cciplj61NlHv5Id6xiGfdi1n+GRvAXD8VcdijtVMTvoP
	DLZcMHzNmdtbhadvbBjAhxsifazm7iRm5B56211FRmjlBY4dPSnobZYy2kM2OvptSQ==
X-Gm-Gg: Acq92OHguQKpKjpW13ualNxwjT+Ewek/qn7kz5bCkQCirqOljSh9WAx4ECafRkIP6IB
	KNVu8+Tx1WJMZgpOlA4MnFNxx9dFsWYFg16jbEJv8V21wccFNkZqqLRjuRnlbiC9LGZVzFNSDPK
	4L1kXQYCiW/XyLQi+shK+HSOLWRE3I8NlW9tKtI5PZ9yuvfHqqKkURVkB82Au8wctQEweERCDg2
	fy1FgJx1Xwah6IP+Rb00YQzs+jdpA+g5ycPxoJp9j7uaLXAjLhzsn1iK1tA1FkIGkT/mXT1KBre
	ijDz7PTH545KAQjZb9vWs13dhLV1rPOIxDqDZUZe/oxDHIyIdE0OEQQap1JQXP+dvW+V/6p6x0W
	pPB2Y0DKYstF80vXs94dpMtK61YbPt6Fy7mZD9PZlGRldJzVRLOZdFBuNyJBNm8qRnjvDWcxdVC
	cd1Pm3uxzysJsMqA2RPoqjPeWTpKdPQo1MJ7hak7+LnJy/cQ9fKebYl28r2DnjIlJniGfAPg==
X-Received: by 2002:a05:600c:2309:b0:489:1f6a:4ac0 with SMTP id 5b1f17b1804b1-490ea51dfb4mr951915e9.0.1781277634812;
        Fri, 12 Jun 2026 08:20:34 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c4240sm6626262f8f.27.2026.06.12.08.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 08:20:34 -0700 (PDT)
Date: Fri, 12 Jun 2026 15:20:30 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, catalin.marinas@arm.com,
	jens.wiklander@linaro.org, sumit.garg@kernel.org,
	vdonnefort@google.com, sudeep.holla@kernel.org
Subject: Re: [PATCH v6 5/6] KVM: arm64: Validate the offset to the mem access
 descriptor
Message-ID: <aiwjvihrwbInBqGn@google.com>
References: <20260527150236.1978655-1-smostafa@google.com>
 <20260527150236.1978655-6-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527150236.1978655-6-smostafa@google.com>

On Wed, May 27, 2026 at 03:02:35PM +0000, Mostafa Saleh wrote:
> From: Sebastian Ene <sebastianene@google.com>
> 
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
> Also, fix one hardcoded sizeof(struct ffa_mem_region_attributes) that
> should be replaced ffa_emad_size_get() for compatibility with FFA v1.0.
> 
> [@Mostafa, Add missing call to ffa_rx_release() and use fraglen
>  as the max buffer size as it is the only intialised part]
> 
> Fixes: 42fb33dde42b ("KVM: arm64: Use FF-A 1.1 with pKVM")
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index b6cf9ad82e12..a12e01883314 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -476,10 +476,10 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  	DECLARE_REG(u32, fraglen, ctxt, 2);
>  	DECLARE_REG(u64, addr_mbz, ctxt, 3);
>  	DECLARE_REG(u32, npages_mbz, ctxt, 4);
> +	u32 offset, nr_ranges, checked_offset, em_mem_access_off;
>  	struct ffa_mem_region_attributes *ep_mem_access;
>  	struct ffa_composite_mem_region *reg;
>  	struct ffa_mem_region *buf;
> -	u32 offset, nr_ranges, checked_offset;
>  	int ret = 0;
>  
>  	if (addr_mbz || npages_mbz || fraglen > len ||
> @@ -489,7 +489,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  	}
>  

Hi Mostafa,

>  	if (fraglen < sizeof(struct ffa_mem_region) +
> -		      sizeof(struct ffa_mem_region_attributes)) {
> +		      ffa_emad_size_get(hyp_ffa_version)) {
>  		ret = FFA_RET_INVALID_PARAMETERS;
>  		goto out;
>  	}

Here sashiko complains about a compatibility break with v1.0 even though
it is not from this change. This is because the size of sizeof(struct
ffa_mem_region) was 36 bytes in v1.0 and now it is 48.

This check can cause "perfectly valid v1.0 memory transfers to be rejected"
(from sashiko).

Other than that this looks good. I will spin a new version of this
series.

> @@ -508,8 +508,13 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  	buf = hyp_buffers.tx;
>  	memcpy(buf, host_buffers.tx, fraglen);
>  
> -	ep_mem_access = (void *)buf +
> -			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> +	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> +	if ((u64)em_mem_access_off + ffa_emad_size_get(hyp_ffa_version) > fraglen) {
> +		ret = FFA_RET_INVALID_PARAMETERS;
> +		goto out_unlock;
> +	}
> +
> +	ep_mem_access = (void *)buf + em_mem_access_off;
>  	offset = ep_mem_access->composite_off;
>  	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
>  		ret = FFA_RET_INVALID_PARAMETERS;
> @@ -574,9 +579,9 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
>  	DECLARE_REG(u32, handle_lo, ctxt, 1);
>  	DECLARE_REG(u32, handle_hi, ctxt, 2);
>  	DECLARE_REG(u32, flags, ctxt, 3);
> +	u32 offset, len, fraglen, fragoff, em_mem_access_off;
>  	struct ffa_mem_region_attributes *ep_mem_access;
>  	struct ffa_composite_mem_region *reg;
> -	u32 offset, len, fraglen, fragoff;
>  	struct ffa_mem_region *buf;
>  	int ret = 0;
>  	u64 handle;
> @@ -599,8 +604,14 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
>  	len = res->a1;
>  	fraglen = res->a2;
>  
> -	ep_mem_access = (void *)buf +
> -			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> +	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> +	if ((u64)em_mem_access_off + ffa_emad_size_get(hyp_ffa_version) > fraglen) {
> +		ret = FFA_RET_INVALID_PARAMETERS;
> +		ffa_rx_release(res);
> +		goto out_unlock;
> +	}
> +
> +	ep_mem_access = (void *)buf + em_mem_access_off;
>  	offset = ep_mem_access->composite_off;
>  	/*
>  	 * We can trust the SPMD to get this right, but let's at least
> -- 
> 2.54.0.746.g67dd491aae-goog
>

Thanks,
Sebastian
