Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A493CD8B0
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 08:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932925; cv=none; b=YIx9SxBbKIMvEKgSqkOxiLUGhs5gH9Z3bGl5R+tOHZpf0mkYcn+1yg+u41NgN6m1uWy1cin6sWuDf1tq7MSrRB0SH4iwYbTP/mTweMcgFQyRqmLRwX9pTxvmtIn3vFIAj18/pZD39fvyfzOeHK2X6fHacFEBb5gJsCEk8jwbeUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932925; c=relaxed/simple;
	bh=wQjoMGo4RQSfpyYZ+IGZ2yaanIQu1MXkMPtV0NCk25Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZY7ckgzIunhL2fNND2jdfXOc3iPfax50rcz1bZc0RlnUr987xQ8RH148t6eHO5Awx2VC4Hh7kAOGa9x3BRBjh9kTEB8nfe4bsRJ6GrKw3O5PNb5F01iMXxFQu7eN9iSEygH8TOiitJyvL45qCD2G09wdwRqV0in/Jc49UR8rWAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VeCcAlTm; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VeCcAlTm"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47f3e6cc44aso748815f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 01:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783932922; x=1784537722; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BtqEp6WILuHu3z7cOSw6EYTxyyE81/3b++ePQIGwGRA=;
        b=VeCcAlTmfYjPfz9BbFSQIHQmMtBeABKIWrvkC+aMp6RTC4voId8QhyHlSUOG/j5NFQ
         k1FK7evX48r0tewa7tuwQ1NP52VdnWbxOjLQ+00YTdG42R0SaZN75B2aoMbynsU9/XqQ
         jjG+wOdyiEM1nS3XgD7GoCk42txp+rdHFzZvetLpPxlYPEbRvty7pL4u4Zg9OEXlAxz7
         tMl/v7RpW1j75wBvSsPWpI88m13TA6+l/9OLjO7avsuKGe3JYoAHee0+G43GwF72kSVe
         9B9SPxzWwIGI4Oe32z2r+IREf9XrYVm1IyP/+In4XTlRWES4fEAMz3/egF9KEeaLkYis
         W8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783932922; x=1784537722;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BtqEp6WILuHu3z7cOSw6EYTxyyE81/3b++ePQIGwGRA=;
        b=sUd1TyukgMuQ0Nb8q73CGwh0R61BX43CZNq3KQUVcprnOYwKnT1I7BTyDzB85r5GAz
         wlH0F8JvUKZN7MqaimtOm9nRQi2p3xUM/7pB5+hsN7HhrFC+nH7y5iN4ofWdLQ+oopSG
         2ewEs1PWXqnj4tzvPkuwDNebTqQontKEI+vuW3NfwKzHv7FhQR6uJ2O9MTddGjPoKlpn
         F9y6Sp1smc3y3Mn+5GBgXsDXX/JtbYRxVI8XIujMyc2L8KO3kfyUmfjWkDWmNTmeUsyT
         +ntJ/+RPyAN/NZlSQeozq9xNAOYjO0PRLX+2Q4U9aNt61ZWQw4HEUdD1ltFmG7arFr5k
         XySQ==
X-Forwarded-Encrypted: i=1; AHgh+RodBY+s+jJ5EG394DspZ1jSGEa9fydlKo10wTyJI8r40gBrqOCGhhThYfPEheEwf9a8K2XWpmw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZbhzzy99Vh1OBQUePPrCpKryBOBCgAUZBOnPhkvkxwsgl4hyV
	7y/o4JoRxkiClRxF5Qw94W5gFPYvwNy7V5cAdeLzoGvpvdWBxeXpaXVGiAhPNqe9aw==
X-Gm-Gg: AfdE7cmiJ1QJ52Xx8Hl4iLoNUjeIn4XbRlnqrTyO2FOIEJP2FFePT7Ko/Bz5poNnvBD
	zOy8J3ZOVdZkSsra022IrY6RAyJYkeE451czBwXhaXZmkYUSQBkL175/oyFa8BQ5rJI5HjnL3Xt
	aK1WQ1UJLQG1eHufFQy/LVJqHdA6Ym4tgA9Aw/M93pFKKp8oUXESze5sMokFnKo/XkJD1rO1kNj
	UeMHI17YDvVnzfKT6hmz1m9DzyEj3VpLQ2pQcRb8eISB00ZmaoeR35PQls7+OvTZGK1qCDik11d
	g1040VNvzJeWEDFIP652XTiA4YeQCgTQQQVjuvIuXg1v3Z6WqJ1LUk+Wh7uzgXTY3IXFWiLaPFO
	/UyZhYiruyASLfvb+8OCKMn+KJ/YEzeM3kR3gurDMWfaWSzkRiRaNN8DY1JYn3z/Q7FUB/kVIq9
	oa2/F1EWKpcuUcCEUgPCo3XEkjdYugy3899BM1bpI7rxxbYAesY+8=
X-Received: by 2002:a05:6000:2688:b0:47d:f440:fb62 with SMTP id ffacd0b85a97d-47f2dcef535mr8659990f8f.57.1783932921619;
        Mon, 13 Jul 2026 01:55:21 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47df6a31dd5sm40641410f8f.16.2026.07.13.01.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 01:55:21 -0700 (PDT)
Date: Mon, 13 Jul 2026 09:55:17 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH] KVM: arm64: Avoid naming collision in tracing
Message-ID: <alSn9VSa7YQZ6NFH@google.com>
References: <20260712153835.2264905-1-smostafa@google.com>
 <CA+EHjTxN1fcBVRi+yK18UgReGsX8Evu1GsijSQC61dY3XrjCtw@mail.gmail.com>
 <alPox2BDk4Il0s9t@google.com>
 <CA+EHjTzvzcV8Cxw+VHK9Fxv7Y-7m84XbzUFU+4sXZXNrM8y7dw@mail.gmail.com>
 <alSdr9wNyyPiHmbt@google.com>
 <alShO27MLsNqgBws@google.com>
 <alSjGAqmB7HX1jYB@google.com>
 <alSkmhpjNCYFnUmO@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alSkmhpjNCYFnUmO@google.com>

On Mon, Jul 13, 2026 at 08:40:58AM +0000, Mostafa Saleh wrote:
> On Mon, Jul 13, 2026 at 09:34:32AM +0100, Vincent Donnefort wrote:
> > On Mon, Jul 13, 2026 at 08:26:35AM +0000, Mostafa Saleh wrote:
> > > On Mon, Jul 13, 2026 at 09:11:27AM +0100, Vincent Donnefort wrote:
> > > > [...]
> > > > 
> > > > > >
> > > > > > > > I did not add Fixes tag as this is currently dormant and not breaking
> > > > > > > > anything.
> > > > > > > > ---
> > > > > > > >  arch/arm64/kvm/hyp/include/nvhe/clock.h | 8 ++++----
> > > > > > > >  arch/arm64/kvm/hyp/nvhe/clock.c         | 4 ++--
> > > > > > > >  arch/arm64/kvm/hyp/nvhe/trace.c         | 4 ++--
> > > > > > > >  3 files changed, 8 insertions(+), 8 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > > > > > index 9f429f5c0664..c2ccd0e8bf22 100644
> > > > > > > > --- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > > > > > +++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > > > > > @@ -6,11 +6,11 @@
> > > > > > > >  #include <asm/kvm_hyp.h>
> > > > > > > >
> > > > > > > >  #ifdef CONFIG_NVHE_EL2_TRACING
> > > > > > > > -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > > > > > > > -u64 trace_clock(void);
> > > > > > > > +void hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > > > > > > > +u64 hyp_trace_clock(void);
> > > > > > >
> > > > > > > hyp_trace_clock overlaps the host side: arch/arm64/kvm/hyp_trace.c
> > > > > > > already has a struct hyp_trace_clock and static helpers
> > > > > > > hyp_trace_clock_enable() / hyp_trace_clock_show() for the debugfs view
> > > > > > > of the same clock. No actual collision, so this is only a readability
> > > > > > > point, but a reader grepping hyp_trace_clock now gets two unrelated
> > > > > > > things. Maybe you'd want to consider a different name, but naming is
> > > > > > > hard :)
> > > > 
> > > > If we were to rename: the clock is a "hyp_clock" so probably trace_hyp_clock()
> > > > is the right thing here.
> > > > 
> > > > while the "hyp_trace_" is the prefix for hyp_trace.c file content.
> > > > 
> > > > Although I would like to see why we pull trace_clock() from the kernel into EL2.
> > > > That bit sounds wrong and if we have a way around perhaps that's better?
> > > 
> > > Most include path look like this:
> > > In file included from ./include/linux/ftrace.h:11,
> > >                  from ./include/linux/kprobes.h:28,
> > >                  from ./include/linux/kgdb.h:17,
> > >                  from ./arch/arm64/include/asm/cacheflush.h:11,
> > >                  from ./include/linux/cacheflush.h:5,
> > >                  from ./include/linux/highmem.h:8,
> > >                  from ./include/linux/bvec.h:10,
> > >                  from ./include/linux/blk_types.h:10,
> > >                  from ./include/linux/writeback.h:13,
> > >                  from ./include/linux/memcontrol.h:23,
> > >                  from ./include/linux/resume_user_mode.h:8,
> > >                  from ./include/linux/entry-virt.h:6,
> > >                  from ./include/linux/kvm_host.h:5,
> > > 
> > > Although, some files have ./arch/arm64/include/asm/cacheflush.h
> > > directly.
> > 
> > Ha sad, no way around that... 
> > 
> > So about trace_hyp_clock() / trace_hyp_clock_update() ?
> > 
> 
> Makes sense, I will respin with that.

Thanks. And small nit for the patch title: use "hyp tracing" to distinguish from
the kernel tracing.

> 
> Thanks,
> Mostafa
> 
