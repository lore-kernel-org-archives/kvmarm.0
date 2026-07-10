Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0D2329C60
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 13:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689557; cv=none; b=LLqkuWUTmiDKZZ1RfE/mk49XpzWiyL+RHfV5toFUVpyAQfZIJSRvHyv0C4swDXKgcdMCOAUBhIMO5U4KBFlK/FZ39GqsthL783VX3fG34L2TJyGIoVsZFuf/1Pxducxdn+iQgfP6hefK6xOgpnhIO0uBSrkxlXf2pJ+W6xAgtNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689557; c=relaxed/simple;
	bh=120FrtS+j1GG51mgZIRxdm+GXHIWFGFWdYCBfXas0IU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qYZB481wIm24aejWprjgNk/gQFKbvHy+PgLfxSg13QS2u293lSyVqTZG4kG3iFDFpM2ar923nFoqVKFLr4tjdULEfdxxqLUxpPDkK6mDrUTl8ftU0kCFe3U4GvTTRwUskLgxSy1Mypq0RklAusy8a2d5fNVaCoHbtQP9NNhdSa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i8IvE3xt; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i8IvE3xt"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493e8d4f4dcso7699405e9.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 06:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783689553; x=1784294353; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IzTMLuV8GHg1XIdYVJfY3lkeFPJPr2GQ2IIgWuqZdyE=;
        b=i8IvE3xtL9tjtK5xSbURCeVtueIph1nHU6aEiXSUPYv0fuksbKEZ+QB3eIT1mCwupf
         4GJjqqhclhlkRbtnwRRGhxL2qi7sRm/RP72rBzk/UR+O06VE+7jbfKcgVyeqprSMuhEx
         PsiYvsdAQyEkPcjI5PLPZhR3CGQQjja7FAW83c4bxZsN65dWCZ8so+QwjjXpzf16P/LN
         F94kGmviHTNRw6/E2FkejgrR7pqq2tKCkh/3YTHd7HHlMyrFvTfRD+ezHD4GuEG7t46j
         H/BlpbsDesV7lBWCepZGDfF7UgOSCa2+0x1xGVqnKM+OyTh7iFvnXduJNffxcH2nTZbO
         o7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689553; x=1784294353;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IzTMLuV8GHg1XIdYVJfY3lkeFPJPr2GQ2IIgWuqZdyE=;
        b=iEM4Cur1yW5Z9x4YaXLyllIv8l9AM8YLCLyVHIGPNP1BGESCHFNaTTrXlbgh/vY0DQ
         IpW2ojSQcA1U6/8nOPRoH/ZRczCpMm58yMUVW5WcCqvEda10vJYrTamrC3hHD6NdUTnB
         WGJ8OVpxnh1D2UJU/JEvZHpIc5D4XjJ1QXzZdcWq5yJT6cRwg7bEsSVt9QdmJ4o7lrZs
         ja0ZoKsZB1v24uF6n6KLH/t2Qn6m5SDbmqSnFq3d9/yKWTS6UeSoyJeWO4Hsl+/8qw2n
         TSX/Z6UqHxPkszUF3SgCx5HjaW0NoZwKHJFkJpVD2f1QPvqRdJi3eAxX7Gfk6p4AmwU4
         OQeg==
X-Gm-Message-State: AOJu0YxJTTvtiTgSyP61Ov6xQ0IERh2lHldLzfb/RUnLGS6VasO5gnF2
	zN6VBytvKhyxPpPVLHMnncAd3fNrTQRoyREboJ79TYeBNnXnrpn5Fg8HrzyTa3hJUw==
X-Gm-Gg: AfdE7ck7ntr147wHrzGShJxWooBOwdgWXEvucc0hJRIv4mv0t9vgA59oU55OuEUKZbV
	WkUdLqve3Z5s6xFo6gziiH9boe+k2bYJdZ16+x20QRF10lyqhisA/kM/Tf3Dq4QKcT5Cu1a1Zad
	HBt9Id2CPbK+PezgOMd+vjLE/vZKLYUyXwWhhfewtWEBTChzBC3Bx2SDe2ia0Pa1Y2yPDgTyL7E
	EDTI3eJy8Zes2vPMMTIl4ZqINjs7mGSXdKwYPBLaXG01CpUBpgC2fXRsN1GNznD2j0F0qVgUJBH
	nKUicDJnbuyqZD+l4QvXQzXObs1WrVeoIEcYuqjUDo0KqOK7az6AA+eZgjnDPj07IBWqywSxD0I
	35Qbnn5k7HnK9sftpKfdKCIEV53qxPFHp9tJQ4KxFTicOGnTJ8z8PW/FlrioBk8KxOGng52I7hh
	lxxJIZ/TpTi/IurWTZ/Mv8MxRFyBVN3p5q0nHfiW4PkS3KZCBslPs=
X-Received: by 2002:a05:600c:4688:b0:493:f6f7:299e with SMTP id 5b1f17b1804b1-493f6f729e9mr9978435e9.20.1783689552776;
        Fri, 10 Jul 2026 06:19:12 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6d4f9fsm138700495e9.4.2026.07.10.06.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:19:12 -0700 (PDT)
Date: Fri, 10 Jul 2026 14:19:08 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Fix hyp_trace_desc allocation size in
 hyp_trace_load()
Message-ID: <alDxTK1uPuecd2dY@google.com>
References: <20260710114819.2689386-1-vdonnefort@google.com>
 <20260710114819.2689386-3-vdonnefort@google.com>
 <20260710120255.883B01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260710120255.883B01F000E9@smtp.kernel.org>

On Fri, Jul 10, 2026 at 12:02:54PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [Critical] Incorrect bounds calculation due to pointer arithmetic on struct pointers leads to bounds check bypass and critical TOCTOU vulnerability.
> --
> 
> --- Patch [2]: [PATCH v2 2/2] KVM: arm64: Fix hyp_trace_desc allocation size in hyp_trace_load() ---
> commit 6dde5b05614b22025af630cb338d61676ac3c7d8
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Fix hyp_trace_desc allocation size in hyp_trace_load()
> 
> The footprint calculated for struct hyp_trace_desc sizes only
> trace_buffer_desc and do not take into account the other fields. It
> worked so far thanks to the follow-up PAGE_ALIGN().
> 
> > diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> > index a7237aca68989..22437c5e1e7bc 100644
> > --- a/arch/arm64/kvm/hyp_trace.c
> > +++ b/arch/arm64/kvm/hyp_trace.c
> [ ... ]
> > @@ -262,7 +266,7 @@ static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
> >  	if (ret)
> >  		goto err_free_desc;
> >  
> > -	ret = trace_remote_alloc_buffer(&desc->trace_buffer_desc, desc_size, size,
> > +	ret = trace_remote_alloc_buffer(&desc->trace_buffer_desc, tb_desc_size, size,
> >  					cpu_possible_mask);
> 
> [Severity: Critical]
> This is a pre-existing issue, but does the bounds check in
> trace_remote_alloc_buffer() calculate desc_end correctly?
> 
> In kernel/trace/trace_remote.c:trace_remote_alloc_buffer(), desc_end is
> calculated as:
> 
> 	void *desc_end = desc + desc_size;
> 
> Since desc is a typed pointer (struct trace_buffer_desc *), this pointer
> arithmetic scales desc_size by sizeof(struct trace_buffer_desc), inflating
> the bounds check and bypassing the intended protection.

This is already part of this fix: https://lore.kernel.org/all/20260709160017.1729517-3-vdonnefort@google.com/

> 
> A similar issue appears to exist in arch/arm64/kvm/hyp/nvhe/trace.c inside
> hyp_trace_desc_is_valid(), where pointer arithmetic scales desc_size by
> sizeof(struct hyp_trace_desc). This could potentially allow EL2 to read
> un-donated host memory, opening a TOCTOU vulnerability if the host modifies
> bounds after the validation check.

I don't see any issue in hyp_trace_desc_is_valid() though. 

> 
> Should these pointers be cast to a byte-sized type like (void *) or (u8 *)
> before adding the size?
> 
> >  	if (ret)
> >  		goto err_free_backing;
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260710114819.2689386-1-vdonnefort@google.com?part=2
