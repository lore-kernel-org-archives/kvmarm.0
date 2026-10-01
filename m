Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EE636B912
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790862731; cv=none; b=QPvqf6syyPs9F92GyWb18E4H8M/WmUuEavyk4IvWORZXEN+MApTuVcYq6ve62eA2lUa/u1jDfhj49uFrToJiabtuoMUI2PsWXCrojvc4QoNU7/93qjMRfxZb1jgAhWfcN5mvfLlS4HKGNfpZS63Aheabc3K2hVTRjOHSWuBfEXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790862731; c=relaxed/simple;
	bh=xph1c43Xe1W7p8VbWvnpVws2Aq5YHWyRuoWpTrL40fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z3XCwdyb7fdn2atNoTrlSzmVSylodgbG9BORHHKHsvGGgPxBKNYSSy6/s4Gw7V1qHEq/5sS1YnSTCNDpcdYTDKy4BumfoFUGjrY1vFHV99vL1xslSNP96IPLWjpfWvoPbT6mq9ixShbyVECh8wr0nGwjoGAnLbz+d4YUcByEUv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hFyi/QQR; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hFyi/QQR"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d3931so49764055e9.3
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 06:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790862727; x=1791467527; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=puUp6QetFCd0xmG62nmZajmHZqrboAPDRquIYk2wybY=;
        b=hFyi/QQRtKuuNiVHMPydLiIezTnE9kotB1ksgDV0ZwHYKAwvybVHM4+HyMzZB2T4h7
         AniWBaaS2OcTtpThU8mVWwRTntqbVNk2PbDIcEwAMw4woI8QTqXaYGs6uGRhFEqw3vqK
         zmT7ghou7cJFoW5ATzuVWhjLWL71+WMIrSE3KBw4AfCJlSw6olAiioHFLEQTKcjhnXut
         3Wfp7TooWw1SakKYwFTdep6ir0HWH0gucMNjh9Of+eiSp3G4feUkGjiNpiIPKo4Awol7
         px7nfILYakdDYrC/Hqo3PgVc+N3if7lGrkJ2YKLDy0Gpra6yHY7oQjZ6U4Rz8YYmSZXa
         ndAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790862727; x=1791467527;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=puUp6QetFCd0xmG62nmZajmHZqrboAPDRquIYk2wybY=;
        b=JSLlmrCJ5H+8Moh5sziJfkkKFBbxMuu6oIG0v166GjrssXisInlafFBAtDsrcnfF1A
         wZK6WZTHsA+K5VXAOunHHJ+6KTtOU6OPbhGPVg+gUR+PSrbWFGPtqSQloN8LBc4bsnM6
         fUYru4CVl/QNtp2y56JBzedd8qzClXwKgtARZeZ0myTAD5JUwZozuMUUJJkN4oiuUyE/
         vUhH0A6dmH6F3v2CV/K+i1UiLRCtYeZDXiyOdgaYI3aCnG9mwJi13nAs6airf+3HPYf5
         K5QmQiy5yPCNNVuZ8R2H1mlfxKgv/HnMS8ta4Ys2O97uK8wgpL5feODjqDY16aiJKfmX
         KzMA==
X-Forwarded-Encrypted: i=1; AKwUvBxqfPcgJ7UhMpFYueRmEZu2DxpOv0NOrfFVr60d1/Ygh1vPE/T8Wwfm9XwhWG+E7VPOqfsKHbg=@lists.linux.dev
X-Gm-Message-State: AFuF++mi/ROxmFQ3yl3S38r8EJEjr0SV6PuK3Rk1UiDH/niKZQ2CXeAd
	TXKGblftJsl57oZ1H9f8yHFoa55hXxvnyZ+i363rXioEGl4ld3LMzyr7MTM/ccshww==
X-Gm-Gg: AYBFou0CBLMB2xKdn174cJxD7gAZXWQE+JYqCGFbhvKMbyBSHNHu4utQ687DBdOE3k6
	GunCHhnh/nR5kly9kZ7bv1o8dEPuHjpVV4PrwIsnvi2h+oiBTos8CyPGNuTHDxqOagPNGf5d9BS
	KDQtDJUBDhTWAMNc6NXytB7yfJ6Kqqm5icTe+wxydsq93WBmhfeRY8hCTB9LebrKuuHBkvBJIRW
	5fYJIZbAb1QQQmfBoHOH3V8ImQgkMcu1lrl/vZZFfiZaQmfb9phfjb/Br3laQ324Tmb1zM0Skj0
	q65Xrzg3EoaWxoZDDj+0bzqeA/yzbCysTVCZHShv2j0eaix8GmCZsLBkllfXmBuhgFeTUwlvnJ9
	71tPRn8V/BcHq0mXz1Fp54GmMQCXEKg08/qeUs/ImOf8G+XkubTpZ1EtyPTDe72HS8Xe9oVGJl/
	gd9D4AWct3DUL9PqaXvnuHdDy2qbK+E0tPVgMlaX0VAhl+y6X7XlxJIvCXXpTQOAJYILSidGolI
	IpW0zdOVd76dcZS9VGOdP3ghTThMKpDh2VOqv+U9pc=
X-Received: by 2002:a05:600c:83c3:b0:49c:edd8:ba35 with SMTP id 5b1f17b1804b1-4a01aff3c4emr82048195e9.6.1790862726856;
        Thu, 01 Oct 2026 06:52:06 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f947898sm75262965e9.10.2026.10.01.06.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 06:52:05 -0700 (PDT)
Date: Thu, 1 Oct 2026 14:52:01 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v4 4/4] KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
Message-ID: <ar5lgYD93976IO6s@google.com>
References: <20261001084909.2937943-1-vdonnefort@google.com>
 <20261001084909.2937943-5-vdonnefort@google.com>
 <20261001090709.C0A971F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261001090709.C0A971F000FF@smtp.kernel.org>

On Thu, Oct 01, 2026 at 09:07:09AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] kvm: trace_hyp_printk lacks format string validation leading to host panic/leak
> - [Medium] arm64: unaligned _hyp_string_fmts section start leads to pointer corruption
> - [Medium] kvm: out-of-bounds read in __hyp_trace_printk when trace sequence is empty
> - [Medium] kvm: uninitialized padding in remote_event_format_hyp_printk leaks hyp memory
> --
> 
> commit bc7c47888c5fbd307a50212081f15f7498660a9b
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
> 
> Create an event to allow developers to log pretty much anything into the
> hypervisor tracing buffer with trace_hyp_printk(), just like the kernel
> tracing has the function trace_printk().
> 
> > diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> > index af1d720209764..7f9b6c7dfe70f 100644
> > --- a/arch/arm64/kernel/vmlinux.lds.S
> > +++ b/arch/arm64/kernel/vmlinux.lds.S
> > @@ -324,6 +324,10 @@ SECTIONS
> >  		__hyp_events_start = .;
> >  		*(SORT(_hyp_events.*))
> >  		__hyp_events_end = .;
> > +
> > +		__hyp_string_fmts_start = .;
> > +		*(_hyp_string_fmts)
> > +		__hyp_string_fmts_end = .;
> >  	}
> >  #endif
> 
> [Severity: Medium]
> Could __hyp_string_fmts_start capture an unaligned address before section
> padding is applied? The compiler might align struct hyp_string_fmt
> elements, but without an ALIGN() directive, __hyp_string_fmts_start
> captures the location counter before any alignment padding. When calculating
> fmt_id in the hypervisor (fmt - __hyp_string_fmts_start), this unaligned
> offset might yield incorrect values and cause memory access errors.

arg, that is correct, it depends on the number of events...

I'll move into its own .rodata.hyp_string_fmts output section.

And make the hyp_string_fmts struct const at the same time...

> 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
> > index 8813ff250f8e0..fa50720e2cffd 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
> [ ... ]
> > @@ -46,6 +46,70 @@ static inline pid_t __tracing_get_vcpu_pid(struct kvm_cpu_context *host_ctxt)
> >  void *tracing_reserve_entry(unsigned long length);
> >  void tracing_commit_entry(void);
> >  
> > +/*
> > + * The trace_hyp_printk boilerplate is too fiddly to be declared with
> > + * HYP_EVENT():
> > + *
> > + * The string format is stored into a kernel-accessible ELF section. The
> > + * hypervisor only writes the format ID.
> > + *
> > + * The function has a variadic prototype. We have no easy way to know each
> > + * argument width so they must all cast to u64.
> > + */
> > +#define REMOTE_EVENT_CUSTOM_PRINTK(...)
> > +
> > +#define __TO_U64_0()
> > +#define __TO_U64_1(x)			, (u64)(x)
> > +#define __TO_U64_2(x, ...)		, (u64)(x) __TO_U64_1(__VA_ARGS__)
> > +#define __TO_U64_3(x, ...)		, (u64)(x) __TO_U64_2(__VA_ARGS__)
> > +#define __TO_U64_4(x, ...)		, (u64)(x) __TO_U64_3(__VA_ARGS__)
> > +#define __TO_U64_5(x, ...)		, (u64)(x) __TO_U64_4(__VA_ARGS__)
> > +#define __TO_U64_6(x, ...)		, (u64)(x) __TO_U64_5(__VA_ARGS__)
> > +#define __TO_U64_7(x, ...)		, (u64)(x) __TO_U64_6(__VA_ARGS__)
> > +#define __TO_U64_8(x, ...)		, (u64)(x) __TO_U64_7(__VA_ARGS__)
> > +
> > +#define __TO_U64_X(N, ...)		CONCATENATE(__TO_U64_, N)(__VA_ARGS__)
> > +#define __TO_U64(...)			__TO_U64_X(COUNT_ARGS(__VA_ARGS__), ##__VA_ARGS__)
> > +
> > +REMOTE_EVENT_FORMAT(hyp_printk, HE_STRUCT(he_field(u16, fmt_id) he_field(u64, args[])));
> 
> [Severity: Medium]
> Can this leak hypervisor memory to the host or userspace through uninitialized
> struct padding? The REMOTE_EVENT_FORMAT definition creates a structure with
> u16 fmt_id followed by a u64 args[] array, which introduces padding bytes
> before the array to satisfy the 8-byte alignment requirement of u64. Because
> tracing_reserve_entry() does not zero the allocated space, these padding bytes
> are never initialized before tracing_commit_entry() exposes them.

That memory is kernel-shared memory anyway. I do not believe this is an issue.

> 
> > +extern struct hyp_event_id hyp_event_id_hyp_printk;
> > +
> > +static __always_inline void __trace_hyp_printk(struct hyp_string_fmt *fmt, int nr_args, ...)
> > +{
> > +	struct remote_event_format_hyp_printk *entry;
> > +	va_list va;
> > +	int i;
> > +
> > +	if (!atomic_read(&hyp_event_id_hyp_printk.enabled))
> > +		return;
> > +
> > +	entry = tracing_reserve_entry(struct_size(entry, args, nr_args));
> > +	if (!entry)
> > +		return;
> > +
> > +	entry->hdr.id = hyp_event_id_hyp_printk.id;
> > +	entry->fmt_id = fmt - __hyp_string_fmts_start;
> > +
> > +	va_start(va, nr_args);
> > +	for (i = 0; i < nr_args; i++)
> > +		entry->args[i] = va_arg(va, u64);
> > +	va_end(va);
> > +
> > +	tracing_commit_entry();
> > +}
> > +
> > +#define trace_hyp_printk(__fmt, __args...)						\
> > +do {											\
> > +	static struct hyp_string_fmt __used __section("_hyp_string_fmts")		\
> > +	__hyp_str_fmt  = {								\
> > +		.fmt		= __fmt,						\
> > +		.nr_args	= COUNT_ARGS(__args),					\
> > +	};										\
> > +	BUILD_BUG_ON(sizeof(__fmt) > HYP_STRING_FMT_MAX_SIZE);				\
> > +	/* __TO_U64 prepends a comma if there are arguments */				\
> > +	__trace_hyp_printk(&__hyp_str_fmt, COUNT_ARGS(__args) __TO_U64(__args));	\
> > +} while (0)
> 
> [Severity: High]
> Does this macro validate that the provided format string matches the given
> arguments? Without checking the format string (e.g. using __printf attributes
> or if (0) printk(...) type-checking), a mismatch like
> trace_hyp_printk("val=%d") will set nr_args to 0.

It is impossible to use __printf here due to the u64 cast.

> 
> The host kernel's __hyp_trace_printk() will then unconditionally call
> trace_seq_printf(seq, fmt); with no arguments, potentially causing
> out-of-bounds reads or invalid dereferences when it parses the %d or %s
> specifiers.
> 
> > diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> > index 8faaec899f92c..ebb882d0152b6 100644
> > --- a/arch/arm64/kvm/hyp_trace.c
> > +++ b/arch/arm64/kvm/hyp_trace.c
> [ ... ]
> > @@ -421,6 +424,58 @@ static const char *__hyp_enter_exit_reason_str(u8 reason)
> >  	return strs[min(reason, HYP_REASON_UNKNOWN)];
> >  }
> >  
> > +static void __hyp_trace_printk(struct remote_event_format_hyp_printk *entry, struct trace_seq *seq)
> > +{
> [ ... ]
> > +	switch (hyp_str_fmt->nr_args) {
> > +	case 0:
> > +		trace_seq_printf(seq, fmt);
> > +		break;
> > +	case 1:
> > +		trace_seq_printf(seq, fmt, entry->args[0]);
> > +		break;
> [ ... ]
> > +	}
> > +
> > +	if (seq->buffer[trace_seq_used(seq) - 1] != '\n')
> > +		trace_seq_putc(seq, '\n');
> 
> [Severity: Medium]
> Is it possible for trace_seq_used(seq) to be 0 here? If the sequence buffer
> was empty or in an overflowed state when passed to this function, subtracting
> 1 would result in an out-of-bounds array read (accessing seq->buffer[-1]).
> Would adding a check for trace_seq_used(seq) > 0 prevent this?

I will fix that too.

> 
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261001084909.2937943-1-vdonnefort@google.com?part=4

I will also change the "\"Unknown\"" even though we do not support yet external
tooling.

-- 
Vincent
