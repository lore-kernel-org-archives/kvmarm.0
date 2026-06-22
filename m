Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86573363C6C
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 09:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782120215; cv=none; b=HZ2jxEaOJhFnZrhqBbL76KOjgqJ1tuXlR7RZUTcvowA31YINY3dOICVke3YFcFlZCFX72JsXxu4vX7MH+PBBmN5ixJSulKDkTkmjBZa+Wi7A2Ipp/afT/+RHI4PrYTtYR3HSqQ+gAeoXtNUP+b7gNELjv/vkErwidGr/M0ep4nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782120215; c=relaxed/simple;
	bh=xRGw/5WdO17oARE2tbE39dqLOEvwz63PJBHom1jLzGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWFqXUxocBs/RyB3BEORTCUrheiOLxcLbwoVnwi1YIFSUUrHHopg77ZJbHRyFPPnN70O987bpOlx+j7YaT1KwB1lFhjgkHz5i2soRSP8AxLV+OyQghTZ/w2OsL5zE+UxK9UHnaO50Q17naVUksEt5uuRZ21TgEqAzzWwKACtc2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tyclO+KE; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tyclO+KE"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-695a3842230so23984a12.0
        for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 02:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782120212; x=1782725012; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lG9c7IfmrMj5SYE5QngWHzgS5zVNj1KkYNbZ00E7vJE=;
        b=tyclO+KEQUJK2f5KC1RMO1ZFLiHaedDJ9AGgAXc4q9Y2xCowlBDIewaAEpRl58ilPt
         W0VIT3f5FDpPWpeEQ9UjFQdnIWbgH2puukTF6Ls6gmHXkIyZQMlAQ4yr6JXj1XSjFVit
         P8TZq1LeFq/0KmVH0eEXpBuFQHIZpThGq4u309R1nGZuDEOQzfPWg6HvY58bbf42gepA
         SWiGobpmtWyRmZRwEZhW/LvljDRsQ7mtKKCJBp+tyUFkBnH7SrwqfLT764bYQrvacutE
         K2Yhf90k4Kelueb89YfROTPJ3CJOtWLAd6VbbJKiTMm8ekpJG1AJCLDxZTwn/Sl4OEmQ
         +LvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782120212; x=1782725012;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lG9c7IfmrMj5SYE5QngWHzgS5zVNj1KkYNbZ00E7vJE=;
        b=MLNwXmSSURPA9nDILkveqf8lBH7nejbsUQCz0ElFoK7YRWL8tzPkcIo4KKZyGNPVU5
         feb5qCXI2OHb0HaDzw6zIIZgm8+5xVTIRWygFyxfvGdaEn+oUSUgC5EECP2BkJ5Wa9Br
         TAtKLm8EGs66PEwcxiMcWQ+WOLBxakcSJ4G7JN3pPHSh94YBBzndD9nRY2tqia3YGtdu
         jXmQIJZ+zOtbD4YtpsDiP1QRHhOUDbQX1fR8MUzbEIaDoepCrPqNlhHbQEofCVcyQa72
         YTE2Wm+HaC6Evp4kaL0dzVfXasogPk6WvRoDC/Ung/JWb1iYryHP4FTWV96KC8Isqr0E
         TR1A==
X-Forwarded-Encrypted: i=1; AFNElJ9w5tIpmn87SltdpC3NLxBxndomxL9s31c3xx5qP0Rd2yxuOq1VxOMFbALVeaApRElJJYcEgeM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8jzO3oajb4rwI18uCwDs2C0dhP6Y0EhJpDZxQO4CVozM9TkMu
	GXYnHxY344edjK7l/PsYsWY1jZH7z/HyMK11jelIfKOIw/vRUi9VZ2/M7Vhlzrlmkg==
X-Gm-Gg: AfdE7cnvgg9iCTmviOWL49rKVsio3mcjZdgeDsDk2XXNb8gPKGvaF5MZDephKqkfyUj
	h0+3UYqEDatIyUQ221Iwvted8PL7AEOy1XB1eJDZdYsqnC4LPYb/ZCrELKVZURfOEWS3hTgwAtb
	boIZy/eFUqfnI9TmaVlkxTF4K4/f9LwaBGt+B0fLl2AVy2nV82QsBQOZGxT6Kt18A8pxr5XnyiW
	CyhMTmLNqxyM5AP8XOSOAI3zL2mLSefq6Ze+IYvLkle9zvjjsU9Swlycissnq0rTvd9mf2c0yp7
	w43yGj5QxoiYJu6uPWNc1zZwD6vrDahCPl/bnGuuBYKK8rApw94uV9m2CaJzkBhGdTMJnyn8G+C
	1OEmNIc/n7QvOT4xnf1VdQJna6GTQi6farepvmPyDGLLZJ6Sb03dCCPnyQPuF8g/rcKBthCk0XG
	Zteh10skW42yn6jY+Om5iFXzC2QHvHYJGM1y/lnV6BnfnWRa4mDNG6dwHTaSk=
X-Received: by 2002:a05:6402:a58a:20b0:671:dad9:8caf with SMTP id 4fb4d7f45d1cf-697498db0b9mr73558a12.5.1782120211444;
        Mon, 22 Jun 2026 02:23:31 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6977b86f480sm2949634a12.13.2026.06.22.02.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 02:23:30 -0700 (PDT)
Date: Mon, 22 Jun 2026 09:23:26 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org,
	will@kernel.org, jens.wiklander@linaro.org, joey.gouly@arm.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	maz@kernel.org, mrigendra.chaubey@gmail.com,
	op-tee@lists.trustedfirmware.org, perlarsen@google.com,
	seiden@linux.ibm.com, smostafa@google.com, sumit.garg@kernel.org,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v7 5/7] KVM: arm64: Validate the offset to the mem access
 descriptor
Message-ID: <ajj_DkqiDwiF8imZ@google.com>
References: <20260617145130.3729015-1-sebastianene@google.com>
 <20260617145130.3729015-6-sebastianene@google.com>
 <ajQjOH9Cjk1UqdT-@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajQjOH9Cjk1UqdT-@google.com>

On Thu, Jun 18, 2026 at 05:56:24PM +0100, Vincent Donnefort wrote:
> On Wed, Jun 17, 2026 at 02:51:28PM +0000, Sebastian Ene wrote:
> > Prevent the pKVM hypervisor from making assumptions that the
> > endpoint memory access descriptor (EMAD) comes right after the
> > FF-A memory region header.
> > Prior to FF-A version 1.1 the header of the memory region
> > didn't contain an offset to the endpoint memory access descriptor.
> > The layout of a memory transaction looks like this from 1.1 onward:
> > Type | Field name | Offset
> > [ Header | ffa_mem_region  | 0
> >   EMAD 1 | ffa_mem_region_attributes) | ffa_mem_region.ep_mem_offset
> > ]
> > Verify that the offset to the first endpoint memory access descriptor
> > is within the mailbox buffer bounds.
> > 
> > Also, fix one hardcoded sizeof(struct ffa_mem_region_attributes) that
> > should be replaced ffa_emad_size_get() for compatibility with FFA v1.0.
> > 
> > Fixes: 42fb33dde42b ("KVM: arm64: Use FF-A 1.1 with pKVM")
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 29 +++++++++++++++++++++--------
> >  1 file changed, 21 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 2d211661952e..1a2abd0154c6 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -476,11 +476,14 @@ static void __do_ffa_mem_xfer(const u64 func_id,
> >  	DECLARE_REG(u32, fraglen, ctxt, 2);
> >  	DECLARE_REG(u64, addr_mbz, ctxt, 3);
> >  	DECLARE_REG(u32, npages_mbz, ctxt, 4);
> > +	u32 offset, nr_ranges, checked_offset, em_mem_access_off;
> >  	struct ffa_mem_region_attributes *ep_mem_access;
> >  	struct ffa_composite_mem_region *reg;
> >  	struct ffa_mem_region *buf;
> > -	u32 offset, nr_ranges, checked_offset;
> >  	int ret = 0;
> > +	size_t mem_region_len = !FFA_MEM_REGION_HAS_EP_MEM_OFFSET(hyp_ffa_version) ?
> > +		offsetof(struct ffa_mem_region, ep_mem_offset) :
> > +		sizeof(struct ffa_mem_region);
> >  
> >  	if (addr_mbz || npages_mbz || fraglen > len ||
> >  	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
> > @@ -488,8 +491,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
> >  		goto out;
> >  	}
> >  
> > -	if (fraglen < sizeof(struct ffa_mem_region) +
> > -		      sizeof(struct ffa_mem_region_attributes)) {
> > +	if (fraglen < mem_region_len + ffa_emad_size_get(hyp_ffa_version)) {
> 
> Can't we replace mem_region_len with ffa_mem_desc_offset()? that pretty much
> looks like the same thing.
> 

We can't because `ffa_mem_desc_offset` dereferences struct
ffa_mem_region to extract ep_mem_offset as per the latest updates. 

> 
> >  		ret = FFA_RET_INVALID_PARAMETERS;
> >  		goto out;
> >  	}
> > @@ -508,8 +510,13 @@ static void __do_ffa_mem_xfer(const u64 func_id,
> >  	buf = hyp_buffers.tx;
> >  	memcpy(buf, host_buffers.tx, fraglen);
> >  
> > -	ep_mem_access = (void *)buf +
> > -			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> > +	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> > +	if ((u64)em_mem_access_off + ffa_emad_size_get(hyp_ffa_version) > fraglen) {
> 
> This check looks like ffa_mem_desc_offset() with count to 1.
> 
>
> > +		ret = FFA_RET_INVALID_PARAMETERS;
> > +		goto out_unlock;
> > +	}
> > +
> > +	ep_mem_access = (void *)buf + em_mem_access_off;
> >  	offset = ep_mem_access->composite_off;
> >  	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
> >  		ret = FFA_RET_INVALID_PARAMETERS;
> > @@ -574,9 +581,9 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
> >  	DECLARE_REG(u32, handle_lo, ctxt, 1);
> >  	DECLARE_REG(u32, handle_hi, ctxt, 2);
> >  	DECLARE_REG(u32, flags, ctxt, 3);
> > +	u32 offset, len, fraglen, fragoff, em_mem_access_off;
> >  	struct ffa_mem_region_attributes *ep_mem_access;
> >  	struct ffa_composite_mem_region *reg;
> > -	u32 offset, len, fraglen, fragoff;
> >  	struct ffa_mem_region *buf;
> >  	int ret = 0;
> >  	u64 handle;
> > @@ -599,8 +606,14 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
> >  	len = res->a1;
> >  	fraglen = res->a2;
> >  
> > -	ep_mem_access = (void *)buf +
> > -			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> > +	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> > +	if ((u64)em_mem_access_off + ffa_emad_size_get(hyp_ffa_version) > fraglen) {
> 
> ditto. ffa_mem_desc_offset()
> 
> > +		ret = FFA_RET_INVALID_PARAMETERS;
> > +		ffa_rx_release(res);
> > +		goto out_unlock;
> > +	}
> > +
> > +	ep_mem_access = (void *)buf + em_mem_access_off;
> >  	offset = ep_mem_access->composite_off;
> >  	/*
> >  	 * We can trust the SPMD to get this right, but let's at least
> > -- 
> > 2.54.0.1136.gdb2ca164c4-goog
> > 

Thanks,
Sebastian
