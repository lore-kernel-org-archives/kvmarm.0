Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092E12AEED
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 17:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747418015; cv=none; b=H7zMU2ujCiAHYQTGtbphqTwcGD0Aer4/1DL461H6ZmU9qHbjRAzOEREjLuJugecv4a0LbQSH749woVEtA1j1OdXRuYB0O0OE+4+Kq+xUbHMqXQSZDtNObiZix3Dpu1MAiUeCAQiUFSelIBecCCGalC/u9Kz/O6wL3dHJwPsqNbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747418015; c=relaxed/simple;
	bh=8upEJ/Pro8IkXndSvkiwT/kFxgoDTzCkAC7XhGjYZVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HwbQpaN01wsZ3ayZmMBwX1OwgABnsku7VC44kfLmI34Mcj7G5RM6ZhHDHLlRHfutRrlQ06WVCveyZGfy+f+tORk/zcDgs84/vbg7hob/ylDgAKwd3iAQlpTOwsJh/jfOiMTrDTuoXnvinedtKnCsChDiy6QVJgonaozfQZuj10A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SwzQxZ0a; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SwzQxZ0a"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-441c99459e9so15232295e9.3
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 10:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747418012; x=1748022812; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2PUV/bkg4QUBVAIj3GMyPK/efOdWpKA1GWmXkehoUR4=;
        b=SwzQxZ0a9z0ZP/s79V22NF6QoZHIHf4cuqr/gRMfYBzRfadnQ+DaEZlcCSOy5R9r3R
         ylzgM6emXN1nhUIysbWGlpQvY2CUNdsGVZGnL/f+uEshXEvnADwHnEgBUPHepZzJWrIl
         LgjTKpVJNqOqRM3x4/6l2Ro426mQR+Feyv6M75rKNE8WYgET04rQiiLxPQEByj4CWilo
         ztk7sGv3lYqh7pk5YNG9G2rCvZcYpGXFfyHc5DDtRaS755tXJHS+GH3mc+jliaiOlRrX
         ky0RHN31GvSXwauxV6EG7wq8aM5Uku5h7sREDgaSf1MSA8grXLkZCN4NjDld3jJtDDRL
         hsxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747418012; x=1748022812;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2PUV/bkg4QUBVAIj3GMyPK/efOdWpKA1GWmXkehoUR4=;
        b=fCkfbQCnp3zKxPnC6h6u+JDj218iHljT30wRS6i9KM8oO7mBt2mNehwbKs1TKTFWYE
         yLyo2wjD8HcTikyVSxGap38BfVLPwVea4WPLfy7WW4ysHwv1C+TJBIF4YmNPwhCCwwO1
         OIXtVb5H7G99qh6FabXXGVXtss/EXhL245nk2Ul6+Knq7cdiVniMOd0cTlwMyFBqPNLu
         av3KQJC7djKG5DArfJsgjfZy0x+5e54b1HZsc8K67CS8fYBjSKdLZZ6E+/2AY3yiUYOy
         ok2Cv1Czyez9lS1h+EkOAckBvFho72Ir0Ne3T0buznrjXqOm7XQAUHrQ8shn0yKRzllG
         2iBw==
X-Forwarded-Encrypted: i=1; AJvYcCW4DGAPxTgVTVJhxDDWKYlgaXUUXwyLtJc2cN0SCI1gimxd6ejaBLfk6tB0duNsf6Vvyfi1eR0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAfVp+PXqTpeVjEJZOn+3vzqc9UsOXcxALU47e4fd2FaWTAbvN
	UCiHVyYiAeJYSBZgVK6czpNjEVTc3CXbnsvLQTeFcTlLj6SyP87J0wuALYDY97kB7w==
X-Gm-Gg: ASbGncuiko3Nkeunr57ecBdzm7Pr6SznjMDvRoc6gb3O84lZ05/XTE0i0w/Laa4Dw++
	8N6X1mk5Yn+DRRmuVn0eTv91/5d/uyNlbGJL7A/oZbfaYmBxmXj+Pex7xlmC877hRk8QY3pNF7j
	KL0P5i+LHHhUSTgOCZSv0QBD86om25IXyBCLCy9sYWDcSTgPhXjxf1YaBc9Cew0MRLHOYwXHiLV
	CCnRNIxLGyv3xRVLsWQpFw07wofjizmF8BF5dljTyZmOALjM6REIJ/NKhs/wnWi4EALsml0o/vZ
	vk+/3gY8e08Ov21tUW7x3pqKyv9QApyHNijSKfY4usGpo8GK/s3CzoSOeP+gcFMIzRsz2Zp34Hp
	PtWEZR4Tzl2D8UmDnyVGvMYlSB7E=
X-Google-Smtp-Source: AGHT+IEv0Zz+YAfIIihBgvDHDhxHsSF6QrQSMcho8CQZS8XKX5FCrwPQKgycTnORAz6U0zTZnRbJsw==
X-Received: by 2002:a05:600c:1e09:b0:43c:f616:f08 with SMTP id 5b1f17b1804b1-442fd624854mr45671515e9.8.1747418012214;
        Fri, 16 May 2025 10:53:32 -0700 (PDT)
Received: from google.com (218.131.22.34.bc.googleusercontent.com. [34.22.131.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442fd50b9b2sm42329115e9.12.2025.05.16.10.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 10:53:31 -0700 (PDT)
Date: Fri, 16 May 2025 18:53:27 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v4 01/10] KVM: arm64: Handle huge mappings for np-guest
 CMOs
Message-ID: <aCd7l455qd4NmOeb@google.com>
References: <20250509131706.2336138-1-vdonnefort@google.com>
 <20250509131706.2336138-2-vdonnefort@google.com>
 <86bjrsg3az.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bjrsg3az.wl-maz@kernel.org>

Hi,

Thanks for having a look at the series.

On Fri, May 16, 2025 at 01:15:00PM +0100, Marc Zyngier wrote:
> On Fri, 09 May 2025 14:16:57 +0100,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > clean_dcache_guest_page() and invalidate_icache_guest_page() accept a
> > size as an argument. But they also rely on fixmap, which can only map a
> > single PAGE_SIZE page.
> > 
> > With the upcoming stage-2 huge mappings for pKVM np-guests, those
> > callbacks will get size > PAGE_SIZE. Loop the CMOs on a PAGE_SIZE basis
> > until the whole range is done.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 31173c694695..23544928a637 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -219,14 +219,28 @@ static void guest_s2_put_page(void *addr)
> >  
> >  static void clean_dcache_guest_page(void *va, size_t size)
> >  {
> > -	__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
> > -	hyp_fixmap_unmap();
> > +	WARN_ON(!PAGE_ALIGNED(size));
> 
> What if "va" isn't aligned?

So the only callers are either for PAGE_SIZE or PMD_SIZE with the right
alignment addr alignment.

But happy to make this more future-proof, after all an ALIGN() is quite cheap.

> 
> > +
> > +	while (size) {
> > +		__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)),
> > +					  PAGE_SIZE);
> > +		hyp_fixmap_unmap();
> > +		va += PAGE_SIZE;
> > +		size -= PAGE_SIZE;
> > +	}
> 
> I know pKVM dies on WARN, but this code "looks" unsafe. Can you align
> va and size to be on page boundaries, so that we are 100% sure the
> loop terminates?
> 
> >  }
> >  
> >  static void invalidate_icache_guest_page(void *va, size_t size)
> >  {
> > -	__invalidate_icache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
> > -	hyp_fixmap_unmap();
> > +	WARN_ON(!PAGE_ALIGNED(size));
> > +
> > +	while (size) {
> > +		__invalidate_icache_guest_page(hyp_fixmap_map(__hyp_pa(va)),
> > +					       PAGE_SIZE);
> > +		hyp_fixmap_unmap();
> > +		va += PAGE_SIZE;
> > +		size -= PAGE_SIZE;
> > +	}
> 
> Same here.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
