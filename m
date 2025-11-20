Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE1F335074
	for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 12:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763641674; cv=none; b=RIxmwz1QX/I5dPxvPxIr1/6+WrCPn2fXRVeyLSQVHQpj99XaSHeW+SoV5/JDRC/XD7gAJeKhsrazNoSRSSRDFgcZq+FoGDaFgBDPVxg6WgzbrpiWosL9H5UX8cM1j6cC9u+6Y6PQv88iLkU3aR9SLiWe0DR369iMVkidC3XvUTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763641674; c=relaxed/simple;
	bh=L10GaSAQJIrnyis8mGo7hQR+sdFEFFQeWaeqDypnHgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZaeyDtmA1UkKRFwcVmtD5v2KMlnhMxsRieEPFX5fZsCmWt+mmiPw4ptjMAyhdnEiNI9pmNzR3dCKGYIxZKdG1MNGpEyO2APman0YCLD/9/R6wbWI1UamOrF5zSzL7o1AslgGIm8w/+fg5xJRPjtiAgTl2hn/lbW4Xd3C+VcxHws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RwHyCQg3; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RwHyCQg3"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so8480975e9.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 04:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763641667; x=1764246467; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4HhtSTqCGLLrH7sfkvwPKz4oo0QSbD9ECCA73kZYpvQ=;
        b=RwHyCQg3sKFNZHkNdHhG1zrzMrpRi6alyFeCiPlxku0nuj6WiZuMQqm5v1JXznmaeY
         27d6KP8I2/DoHFIopHrhgFfAD8u0HPvYyCpEcbuVI5F3x9GC8NJU3QNNode1tkGJrugm
         tMDy9NalD4RcKrq1T8mm68q8tlKdlky2PJA/yWYXwp/p548e3IcA5OKq7s7w6U9FRcAz
         36nWH/8Lkd6OxmrMrW+JN9xcDVM+hH1ZLzyVYCt1gzg2oIL2O5tPBXJrGwF5rP+vQxMp
         GNEoG0m+SV5dAOSN7ez867eNKgdOVmGHPryDP0FOT1hMpIka2KpvBssuMTakrPHbMrSY
         K3oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763641667; x=1764246467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4HhtSTqCGLLrH7sfkvwPKz4oo0QSbD9ECCA73kZYpvQ=;
        b=mQooEPqLak6nJd5ClZLdB4oSXUkvuQkGzCuNlA0zpRtwcgUJkkX/itlVADXbyS0uIt
         ojCFScmH4PoRU5SkI467ma/H1WXQTHnynKcmnWz4yerYy+PpuJMIORW/1Y7ZIVryNtU4
         BVxF523sry+l2Hd3eD8OnCxTB7dXX6h9ocLAYmzNUmfpLfDjIszVbOgz8Ghv762I8bUV
         QPNYjgVUtCuSub2BDRSve//vp8kkGwx00PAWGA0h2cQ01Wu7/FuTAZC8EVusyV5ujEon
         WtSFvTa1t6COwAju6hV4U2cqh5Toi99XavElz134vKbvT8qp1jfVQdKn8yVTggs2vpzl
         OJTA==
X-Forwarded-Encrypted: i=1; AJvYcCUBxhnTUAtgUhjnwjcLyI7tVEx+1JjG9T464PUsXZdvUB/202XoRyIqya87a8a94vvOtwNQVCw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwpJ1L4Qq3Nvb9LjlzgI69hq02pRqb0k3HtypNGxCnSSePUY6Fk
	H7VdyDHbuqbJ3hduX/C7MSbdzCjD8ZUtHrdyURYbRJa3ewdI4/MtQnfW5pgWMiMGaQ==
X-Gm-Gg: ASbGncs9M1jivv0uG8ZlmTm8SkYIxrHWVU3GQ9V1IyfbQDDaLRTQ+j/omlu2taZQguW
	joOdN0PpGon39LTJYCRHl0Twt1N+7xY81E0JV9uYvIczLtBp9rALIGTOYq5+0dvzFM/Bp0ykver
	ZPDC+E+LnvUvoIGU9h+i7+iwskWlkb5Dr9kG8duAkjR/22y29+VMybQgE/9A2vEaukxlb1pxsJV
	lu/POs4T9qd07GgXwxV1n9yzpfk6chZ+6nXxflpwJy96qjVP9aycLuVK6EDB8PeDKUCb6An9K7U
	gZMKkcYim5ddi0drktrFefmgzM5juaws+kd7YH5fyksHOMmqXAN26tA3tN3p9XawCZFUKs9LlYq
	nMni5OP56NnUbk6aeYkeEajcqU2ne8zyJGK1WuFXU2PhusNJIeNXxS8bF5A8MkUqkun8U/ru5oY
	41QBMCinrqOFsGYde79cCRN0pN8CDe0OXszGyp0OuekcXU7gIWnA==
X-Google-Smtp-Source: AGHT+IHpeFeIGGZiJTmXFsR+6beF5U9qh+UXPfFDdc/PMj/YV98aLC84HYj/PIpbhK9tkAcu44ljjQ==
X-Received: by 2002:a05:600c:4e8f:b0:477:9eb8:97d2 with SMTP id 5b1f17b1804b1-477b8a511d8mr26758955e9.8.1763641667024;
        Thu, 20 Nov 2025 04:27:47 -0800 (PST)
Received: from google.com (120.54.38.34.bc.googleusercontent.com. [34.38.54.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477a9dbec2bsm64229035e9.5.2025.11.20.04.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 04:27:46 -0800 (PST)
Date: Thu, 20 Nov 2025 12:27:43 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 22/28] KVM: arm64: Add trace remote for the pKVM hyp
Message-ID: <aR8JPxRHg7vEOME4@google.com>
References: <20251107093840.3779150-1-vdonnefort@google.com>
 <20251107093840.3779150-23-vdonnefort@google.com>
 <86a50irkst.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a50irkst.wl-maz@kernel.org>

On Wed, Nov 19, 2025 at 05:31:30PM +0000, Marc Zyngier wrote:
> On Fri, 07 Nov 2025 09:38:34 +0000,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > When running with KVM protected mode, the hypervisor is able to generate
> > events into tracefs compatible ring-buffers. Create a trace remote so
> > the kernel can read those buffers.
> > 
> > This currently doesn't provide any event support which will come later.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 580426cdbe77..64db254f0448 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -87,6 +87,7 @@ config PKVM_TRACING
> >  	bool
> >  	depends on KVM
> >  	depends on TRACING
> > +	select TRACE_REMOTE
> >  	select SIMPLE_RING_BUFFER
> >  	default y
> >

[...]

> > +static void hyp_trace_buffer_free_bpages_backing(struct hyp_trace_buffer *trace_buffer)
> > +{
> > +	free_pages_exact((void *)trace_buffer->desc->bpages_backing_start,
> > +			 trace_buffer->desc->bpages_backing_size);
> > +}
> > +
> > +static int __load_page(unsigned long va)
> > +{
> > +	return kvm_call_hyp_nvhe(__pkvm_host_share_hyp, virt_to_pfn((void *)va), 1);
> > +}
> 
> I struggle a bit with the nomenclature here. Why is that called
> "load"? Surely this is a "map" operation, right? Is that because this
> is called at "vcpu load" time? Something else?

I called "load" the operation of getting the tracing buffer ready. But for this
implementation specific part, I can use map/unmap here. (same for
hyp_trace_buffer_map_pages/hyp_trace_buffer_map_pages)

> 
> Also, how is this working without pKVM, in a normal nVHE environment?
> Being able to trace in nVHE is a basic requirement, and I don't see
> how this works here.

I can probably make it work with nVHE as well.

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
