Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDD53B47D0
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 07:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790838316; cv=none; b=YuAQeYmQv12gDds0Fne0GLKBEwXKN3SIxwubxC7KJSEvSzR09ZmF4iH4praAyBS6eEII4YVYTfdyiv91MqyiWUsa+XzZl0KnJsIYmgFiJnpweeQ58KumrtjHFeEfg4Tj/SVZ+3M8XaHhGCCnp9608g/+KAq5kzOieXT7P5NMaRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790838316; c=relaxed/simple;
	bh=2bWlEomTT6RXTQU0/yUWRf8NsUBDGdxk15/fvQlF8Og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQRdpCDWSfrrogPucTNSgInskiBIi1LzVuMdPqsPKnRY4gf6E/ExtrDLgK7dql/bim57d69DUFjBkL0vMFseHLGr4Z42Hp9xe78E4lTVK7S5IpVL+aNQkqVwokM4DmrmBza8jwJ4VzP9GDKfkwzzJJsPmOeEAYaoc27Gw1C3hlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BxiC3X5G; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BxiC3X5G"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48b01c41135so981432f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 00:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790838312; x=1791443112; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ip0JK1laKbzgFDQ4J4NPke6DEzSIhz7SWsZYR9ctV80=;
        b=BxiC3X5G3+tCISKdp0rSrvIznS0/Q0jsZz2w2hbMOSe0IQxyaz90YH2xdd7zsyrIjJ
         2vF8LI6PJ/uhkoN7laLlycv35hZRR6TBLqRqjlZysV/+6NH6dPgKjau14KA2oVOCeymW
         1x4qvLljD4sz1e0srdQOSZdzfvsrnAWj/Bvm6x/XZZE77Mn/w2shNrxSwil1kyIkVI3m
         ur8op8j/wIdscIheQ0VUosHPLC+xPnM43bGdw9z5C5zLxbRay8MFUQVfhtf9jtS3Nzu3
         YJJRvX2JZ+Cb/MX7imGyOX+6LPITnsboJDZyTyEmo2NYJpJw7B7RHfLqC8gYQnTb/8rV
         rOeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790838312; x=1791443112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ip0JK1laKbzgFDQ4J4NPke6DEzSIhz7SWsZYR9ctV80=;
        b=HE01F63M23tkYgiFNtdH8RAfhk9InFTmhk46OpMzjVtdb9vWGje6Lg+Q7F4xWbhhj9
         HV+eIw3vIYPOk3z/71AETzxOS2B9ONPGh/fPfAA9mcavr2b7mkmpEqFvn4XKre6X5G7T
         NrQx6qvruYLRZCkUFnii6EX6+OYdvN7vBZhRxu31EG/lyZ2TmIYqPCn6ipu2YvFf74WF
         d3IWaC/+qTts3UkOL8KHeTOdF3kkWu40gHvcrCnrHig0R8wN+YDposaVtbobt1KfQ7VJ
         baSH2d9NVLAWUzRVp3C1gJDgGyfJdgZuE4mhVqpqOXHwLxRiS6bfrvReJzRx4Vose+Xc
         /a1g==
X-Gm-Message-State: AFq9FYIho61HQQohrDyc+f1ZHbMUqyFTO//ryeNg9n9Kmph3FFaBwHX1
	hedMdwE8QJD4GaqRxf4Kc3dEnzfX3101QJxRXue8EukT7RdS9MCU78G7bLrysmJMvw==
X-Gm-Gg: AYBFou1jiTgatak5HFZU7Dqw8mqhB7Anl9vrol4Z1D8XVD6ZZlAwocdCkK34INi2Msp
	Vaws6rwzsV8+daBChRNEhrrpQvQ52em/DjM+GhN7HlBh1BNYOrmizQ8NW7z+B52pVyxG/RSW4bE
	nG7ai20KZhkdVPGg6piqT9InkG5Yc133Ow14N00O7EKpsrYcZs3GdB+2gcfFNU4mHfnAUxsfEB5
	hpRpz+YkLQwelDIZEwAgcvERJYpym7DwOe1kMP0yjSx8NTuYdEmoWZqhs4vbx/TQnB9UXqQPReG
	npNE4wUUQw/z3PGV9bGIfNW4hzw/w18rpipqvdpGATZ063pM/1iaNvBdSvP9oL7/AbgcgFJ6mgo
	Q8Io2ARCATvBYFLMiszrqL/8omfggc1pC/hjQQloUBOkgVGhp6J8mWPnTzgnJW8iLYDvgN7BDWb
	G8rmKq2esyKzMsz5lhkjotKfIfEa8q1zaozi7AchXz6csu4jyGynClNpD7jFABGJfKtW12jdVuH
	L9zHLt1BZeMwo+0eKUJ8FnRxJABVQty0m0SbrRcBg0=
X-Received: by 2002:a05:6000:230f:b0:487:6f6:29a6 with SMTP id ffacd0b85a97d-48b0252a86amr7003700f8f.35.1790838311680;
        Thu, 01 Oct 2026 00:05:11 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b0690c47dsm4532152f8f.15.2026.10.01.00.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 00:05:11 -0700 (PDT)
Date: Thu, 1 Oct 2026 08:05:07 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v3 4/4] KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
Message-ID: <ar4GI_kJNVxno7eV@google.com>
References: <20260930153505.2144559-1-vdonnefort@google.com>
 <20260930153505.2144559-5-vdonnefort@google.com>
 <20260930155655.8E63E1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260930155655.8E63E1F0089C@smtp.kernel.org>

On Wed, Sep 30, 2026 at 03:56:55PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] trace: trace_hyp_printk calculates invalid ring_buffer_event pointer causing memory corruption
> - [Medium] trace: trace_hyp_printk lacks compile-time format string validation
> - [Medium] trace: trace_hyp_printk macro shadows caller variables named fmt
> --
> 
> commit 26cdec70ff2d60c665c546592ecab1e31f40820e
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
> 
> Create an event to allow developers to log pretty much anything into the
> hypervisor tracing buffer with trace_hyp_printk(), just like the kernel
> tracing has the function trace_printk().
> 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
> > index 8813ff250f8e0..3d0b5c634bb3f 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
> [ ... ]
> > +
> > +#define trace_hyp_printk(__fmt, __args...)						\
> > +do {											\
> > +	static struct hyp_string_fmt __used __section("_hyp_string_fmts") fmt = {	\
> 
> [Severity: Medium]
> Will this shadow caller variables named fmt? If a caller passes a local
> variable named fmt as one of the format arguments, it seems it would resolve
> to this static struct instead of the intended variable, logging the struct
> address or causing a compilation error.
> 
> [Severity: Medium]
> Does this macro validate the format string at compile time?
> 
> Since __trace_hyp_printk() does not use a __printf compiler attribute, passing
> unsupported specifiers like %s or %p, or providing mismatched arguments, won't
> trigger a compiler warning. This could cause a host panic when
> trace_seq_printf() attempts to dereference an EL2 pointer at runtime.
> 
> > +		.fmt = __fmt								\
> > +	};										\
> > +	BUILD_BUG_ON(sizeof(__fmt) > HYP_STRING_FMT_MAX_SIZE);				\
> > +	/* __TO_U64 prepends a comma if there are arguments */				\
> > +	__trace_hyp_printk(&fmt, COUNT_ARGS(__args) __TO_U64(__args));			\
> > +} while (0)
> >  
> >  int __tracing_load(unsigned long desc_va, size_t desc_size);
> [ ... ]
> > diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> > index 8faaec899f92c..9d4378bcad74b 100644
> > --- a/arch/arm64/kvm/hyp_trace.c
> > +++ b/arch/arm64/kvm/hyp_trace.c
> [ ... ]
> > @@ -421,6 +424,61 @@ static const char *__hyp_enter_exit_reason_str(u8 reason)
> >  	return strs[min(reason, HYP_REASON_UNKNOWN)];
> >  }
> >  
> > +static void __hyp_trace_printk(struct remote_event_format_hyp_printk *entry, struct trace_seq *seq)
> > +{
> > +	const char *fmt = (const char *)(&__hyp_string_fmts_start[entry->fmt_id]);
> > +	struct ring_buffer_event *evt = (void *)entry - RB_EVNT_HDR_SIZE;
> 
> [Severity: High]
> Does this pointer arithmetic correctly locate the event header?
> 
> Since this event is allocated by simple_ring_buffer_reserve(), the payload
> starts at array[1] (offset 8) rather than immediately after a standard ring
> buffer header. Subtracting RB_EVNT_HDR_SIZE (4 bytes) appears to result in a
> misaligned pointer pointing to array[0] instead of the event header.

Lol, fun I missed that in the testing because printf behaves quite well with the
format string.

Anyway, it's even worse than Sahiko thinks because I am adding support for
compressed length here [1]. As a consequence it is a bit dodgy to know the event
size. I'll store the number of arguments directly into struct hyp_string_fmt
instead.

[1] https://lore.kernel.org/all/20260924145754.1285146-8-vdonnefort@google.com/

> 
> > +	int nr_args;
> > +
> > +	trace_seq_putc(seq, ' ');
> > +
> > +	if ((void *)fmt >= (void *)__hyp_string_fmts_end) {
> > +		trace_seq_printf(seq, "Unknown hyp_string_fmt ID %d\n", entry->fmt_id);
> > +		return;
> > +	}
> > +
> > +	nr_args = (ring_buffer_event_length(evt) -
> > +		   offsetof(struct remote_event_format_hyp_printk, args)) / sizeof(entry->args[0]);
> 
> [Severity: High]
> Does ring_buffer_event_length() read garbage data here?
> 
> If the evt pointer is misaligned, interpreting the payload data as the event
> header could yield a garbage nr_args value. This could lead to out-of-bounds
> memory reads or information leaks of uninitialized host stack/registers when
> trace_seq_printf() is called below.
> 
> > +	switch (nr_args) {
> > +	case 0:
> > +		trace_seq_printf(seq, fmt);
> > +		break;
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260930153505.2144559-1-vdonnefort@google.com?part=4

-- 
Vincent
