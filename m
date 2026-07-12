Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BDE35C197
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 19:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783883985; cv=none; b=Cf+8jMrXUmLZ6d1t8ZG9MOSd3xSLjctZ1fJe4A+UjSqJIh/MLHd759FsoEZwOD92bfIQoFqKGHMQmia8jAJZDNZzbveGWcOgaw/dnh81V7dHkphES2pOXzAgc7L0TcOBXk4b/QoV/CwDdXEFoYw+YIH94gsBuLeBP9DJn0okE2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783883985; c=relaxed/simple;
	bh=gfZgT+iv2oj2lcKtRdSuGg71IzxCGTjr9ADXjGGkxVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nNn2lkMpjtUXoLI01rudMKm6domgVcAlG19pvGnT5y2EWfcvL5cEwnFfAsWeLqkG+GhRLmGB2na+kgwvQ9lTMWxaBqEtjx3G379bB/v4okNV7QHkXFTHO/MAGqVwRv6To8YCnzoKUQTpH9lZlJYfAx/gekyoADTs1vXeq1K4Wjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MlKv6VCs; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MlKv6VCs"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493b8d92a4eso53895e9.1
        for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 12:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783883981; x=1784488781; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vEU3y3lXMNFSsQ9hphclmAmUhcp5miEUyosWJijgi/Q=;
        b=MlKv6VCsCuviO0+Pv6qt0pGmhtJSnon5Y3p09PKHOfRxpWIR+JJNT1pCrv2fSYEJwK
         ufXdVev6SrBuWML6i5EEyBOR1EejMGcgj2U4grlqN6JlhMRpuOsXMH4ezoR5ltbROHTn
         yfFXto7TEMo+IedIP+bGEl8UVePTypi/fLMJ14CRkmxbRsQlEC1ZxlRXfnScFuYeBHMB
         BbYpoUwjlcE2tHoNWMhzwAHhU6o6q7rVV9R6NlpTp3Q7XqmtyVvtzNejv0L6NvQI2rvW
         z9EMngNRs6rBVY+IJLMSrN8lM5UOvzeE2Ejmdatpj0t2gqYhUV+M6jErbuvFEEvViSd0
         PGMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783883981; x=1784488781;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vEU3y3lXMNFSsQ9hphclmAmUhcp5miEUyosWJijgi/Q=;
        b=XlMYXiX+OZaHxwS9g/96rcoRB0NtGqsnt+tIwpFPQHQJoHVXw3l5E2/ksb5IrNjoK/
         SLpMDTyzJzzuZCz6baR2ebxAaO5IQ6aN7Hfbs13u1ArPCNxq/XzJPlRXgVN//qCe/lhI
         SlRaFwZyBYWzt9nfuYX8UcyQ+1s3lHOMuqmaHGk1XPsYX3Wcx4kCjVy35rVlO8jkL9zl
         o1ZMMVMkVtHqE2pZ5qkeoM4DFfPqA/k+z4lJYkrkTaRkuayV2wIB4cPuZguVhF2vEeB/
         BeN97jlH3V1AOH2KqthLPjG4YT3dl+eqIvpMvvbnauchOJGAvC+EGkbpyNMS5+PhvZ0Q
         TcqA==
X-Forwarded-Encrypted: i=1; AHgh+RqosPwPCbIGRqWBwTSq6FuR8PjLk96wIDitVVNg4attII0QsrRMcjEazmrC30ox/lI7LQzs/T4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQZGYO4NNxXywcgiWI865ZXj7tBZ+1a4sAg276Mj7zuRdhLuZi
	hWBflstll2Po2LZ2UQRlRspcnRO/xzOMcJOuhsP3atf5CCbw9bA8JOYjY6k9YfpVEg==
X-Gm-Gg: AfdE7clZLXY68AScswwUBAVKXic9gJuVReZj3+QcJy7zfvj7QeVJYQltBptWTwtZxJp
	wdYTIcS2zvZvQx/Bh8fK4CQygu2wac1f4vsd2FGhhUt2jFZmU0qcrMUso2VRXkmM+v13AA+Bjzu
	2rJuHXNjNiY/QYHDuJLUZREuXc0LZwRO+GfmDUuqMYbBZ38wEufHVhJ0d7BzSRbQcGNey+JPHfv
	i5ICONDKJdvGopX1h8Lx9iUYfXMIPwJ2YbqqnX1aS6q4Vie//d8eneN3U+DNc6OekYHVy1GVdZG
	w1+lWsJ92GlqypHr8B9sXWueMm7rjCgnnZ8W0tb1Tyvt2Nr70p4WX4Bu9cz1/+anKAZTPfVhc4s
	p8aOyTZQ8Eqtf7hMCWYJtdS6j7GXSoJm4sX+SbZxPkBd7DFcnKKjkbmd5gwkShqgAXFKMOXS37G
	hcVGlSwE32noQbzBPf/GkqdL+3/Tdpa5NqhT7zxGiSWucOUcXx
X-Received: by 2002:a05:600c:6085:b0:493:ae5f:d29f with SMTP id 5b1f17b1804b1-493f8bc151fmr2729225e9.3.1783883980658;
        Sun, 12 Jul 2026 12:19:40 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493fbae1cdbsm124580445e9.10.2026.07.12.12.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 12:19:39 -0700 (PDT)
Date: Sun, 12 Jul 2026 19:19:35 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oupton@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com
Subject: Re: [PATCH] KVM: arm64: Avoid naming collision in tracing
Message-ID: <alPox2BDk4Il0s9t@google.com>
References: <20260712153835.2264905-1-smostafa@google.com>
 <CA+EHjTxN1fcBVRi+yK18UgReGsX8Evu1GsijSQC61dY3XrjCtw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EHjTxN1fcBVRi+yK18UgReGsX8Evu1GsijSQC61dY3XrjCtw@mail.gmail.com>

Hi Fuad,

On Sun, Jul 12, 2026 at 05:19:22PM +0100, Fuad Tabba wrote:
> Hi Mostafa,
> 
> On Sun, 12 Jul 2026 at 16:38, Mostafa Saleh <smostafa@google.com> wrote:
> >
> > When the hypervisor tracing (CONFIG_NVHE_EL2_TRACING) is disabled, it
> > defines a static inline stub for trace_clock().
> >
> > However, trace_clock() is already declared as an extern function in
> > linux/trace_clock.h which is pulled in EL2 compilation.
> 
> The rename itself looks correct and complete: all three sites (the
> declarations and stubs in nvhe/clock.h, the definitions in clock.c,
> and the two callers in trace.c) are updated, and no other reference to
> the old names remains under arch/arm64/kvm.
> 
> Two small things...
> 
> >
> > If the file <nvhe/clock.h> is included when CONFIG_NVHE_EL2_TRACING
> > is disabled (by including it manually in setup.c) it will cause:
> > In file included from arch/arm64/kvm/hyp/nvhe/setup.c:22:
> >
> > ./arch/arm64/kvm/hyp/include/nvhe/clock.h:14:19: error: static declaration of ‘trace_clock’ follows non-static declaration
> >
> >    14 | static inline u64 trace_clock(void) { return 0; }
> >
> >       |                   ^~~~~~~~~~~
> >
> > on GCC and a linker error on LLVM (it seems to change the linkage to
> > global)
> >
> > Although that is not a problem at the moment, as no other files
> > include <nvhe/clock.h>. That does not seem to be the intent of
> > this code and that will cause issues with more users as the SMMUv3
> > driver.
> >
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> >
> > --
> 
> git am only treats a three-dash "---" line as the scissors; the "--"
> here is two dashes, so mailinfo keeps everything above the diffstat.
> Worth a "---" on the repost so the note stays out of the log.
> 

ops, I will fix that.


> > I did not add Fixes tag as this is currently dormant and not breaking
> > anything.
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/clock.h | 8 ++++----
> >  arch/arm64/kvm/hyp/nvhe/clock.c         | 4 ++--
> >  arch/arm64/kvm/hyp/nvhe/trace.c         | 4 ++--
> >  3 files changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > index 9f429f5c0664..c2ccd0e8bf22 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > @@ -6,11 +6,11 @@
> >  #include <asm/kvm_hyp.h>
> >
> >  #ifdef CONFIG_NVHE_EL2_TRACING
> > -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > -u64 trace_clock(void);
> > +void hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > +u64 hyp_trace_clock(void);
> 
> hyp_trace_clock overlaps the host side: arch/arm64/kvm/hyp_trace.c
> already has a struct hyp_trace_clock and static helpers
> hyp_trace_clock_enable() / hyp_trace_clock_show() for the debugfs view
> of the same clock. No actual collision, so this is only a readability
> point, but a reader grepping hyp_trace_clock now gets two unrelated
> things. Maybe you'd want to consider a different name, but naming is
> hard :)

Yes, that shouldn't be a problem,  I just added hyp_ prefix, but I
am ok with any suggestions!

Thanks,
Mostafa

> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba < fuad.tabba@linux.dev>
> 
> Test: builds fine with the different config enables.
> 
> Cheers,
> /fuad
