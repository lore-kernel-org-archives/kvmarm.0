Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379C94E324D
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 15:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783820; cv=none; b=YlZTfcIK0dem6Qoeb+LhyqoFuN2vGxSL3j+rf84BR68xaNHEsJmYcjpibJva6FWSduwr1+bjbMob60GoFGOa1RlBReGLpZupcmD/99SnzF1Iife1w9B9/RuOAtCJzzOSo/S+CLU3YekKDU5M3ZYMIjXMYB/LMkszERHzq+3JLeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783820; c=relaxed/simple;
	bh=r23wN9j1Kl5sBQwf3MqrazuAz45jz1qM4uXDgnaa/gY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fmD4MaJKCzdvyze3axF3nD9xgkQRf1OOjUeg6FtNFaDzKmRg5OYeQv+q7e88Gd/5QV/7sxmWP1J8dDsogocHFbONu2RdUeodylWkHMN70g0b4mz71CLW41F4j8uunhkTsZ6uYQgpvn61nxFRwuUshNljTvFuBVNH/WI9ODYN7kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqaCZUGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqaCZUGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E63E1F0089C;
	Wed, 30 Sep 2026 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790783815;
	bh=3cSZcqMuqPUE31rN9amGh9+/5u4x0Z686KaZJIFmXe4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iqaCZUGH9yMuo2InbTZKSo8Ridba9+Hggvv95RV1DwoIMERNRQAmGlrilvD5ThUbi
	 XfABB0hZ3ZHfvZGafCNl4UzdWNQMCR+aYlOWpLh+KsdhMgTxbHM5zq3TV6nL/ZAhrg
	 bVIkiFvkESKiimjOIEL9b5AfywQJOAtHe7G/2A4qVejpktZXYV2SUaf6VaXRIc8DBB
	 GHJ2n25LAgZ7zUi/cGatGv+5qmHCd1dciwvhX5N04ibrS7Rg1SUqVz6/e9DFVbZEyj
	 lCWc1Db7Hk0C2V7IecRGMEHKz9Yo1E4DOXMx7sjpsvQA74AZTej/LqiNWOzp+YedhG
	 FtpQ3hutAfPPw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/4] KVM: arm64: Add hyp_printk event to nVHE/pKVM
 hyp
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260930153505.2144559-5-vdonnefort@google.com>
References: <20260930153505.2144559-1-vdonnefort@google.com>
 <20260930153505.2144559-5-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 15:56:55 +0000
Message-Id: <20260930155655.8E63E1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] trace: trace_hyp_printk calculates invalid ring_buffer_event point=
er causing memory corruption
- [Medium] trace: trace_hyp_printk lacks compile-time format string validat=
ion
- [Medium] trace: trace_hyp_printk macro shadows caller variables named fmt
--

commit 26cdec70ff2d60c665c546592ecab1e31f40820e
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp

Create an event to allow developers to log pretty much anything into the
hypervisor tracing buffer with trace_hyp_printk(), just like the kernel
tracing has the function trace_printk().

> diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp=
/include/nvhe/trace.h
> index 8813ff250f8e0..3d0b5c634bb3f 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
[ ... ]
> +
> +#define trace_hyp_printk(__fmt, __args...)						\
> +do {											\
> +	static struct hyp_string_fmt __used __section("_hyp_string_fmts") fmt =
=3D {	\

[Severity: Medium]
Will this shadow caller variables named fmt? If a caller passes a local
variable named fmt as one of the format arguments, it seems it would resolve
to this static struct instead of the intended variable, logging the struct
address or causing a compilation error.

[Severity: Medium]
Does this macro validate the format string at compile time?

Since __trace_hyp_printk() does not use a __printf compiler attribute, pass=
ing
unsupported specifiers like %s or %p, or providing mismatched arguments, wo=
n't
trigger a compiler warning. This could cause a host panic when
trace_seq_printf() attempts to dereference an EL2 pointer at runtime.

> +		.fmt =3D __fmt								\
> +	};										\
> +	BUILD_BUG_ON(sizeof(__fmt) > HYP_STRING_FMT_MAX_SIZE);				\
> +	/* __TO_U64 prepends a comma if there are arguments */				\
> +	__trace_hyp_printk(&fmt, COUNT_ARGS(__args) __TO_U64(__args));			\
> +} while (0)
> =20
>  int __tracing_load(unsigned long desc_va, size_t desc_size);
[ ... ]
> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index 8faaec899f92c..9d4378bcad74b 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
[ ... ]
> @@ -421,6 +424,61 @@ static const char *__hyp_enter_exit_reason_str(u8 re=
ason)
>  	return strs[min(reason, HYP_REASON_UNKNOWN)];
>  }
> =20
> +static void __hyp_trace_printk(struct remote_event_format_hyp_printk *en=
try, struct trace_seq *seq)
> +{
> +	const char *fmt =3D (const char *)(&__hyp_string_fmts_start[entry->fmt_=
id]);
> +	struct ring_buffer_event *evt =3D (void *)entry - RB_EVNT_HDR_SIZE;

[Severity: High]
Does this pointer arithmetic correctly locate the event header?

Since this event is allocated by simple_ring_buffer_reserve(), the payload
starts at array[1] (offset 8) rather than immediately after a standard ring
buffer header. Subtracting RB_EVNT_HDR_SIZE (4 bytes) appears to result in a
misaligned pointer pointing to array[0] instead of the event header.

> +	int nr_args;
> +
> +	trace_seq_putc(seq, ' ');
> +
> +	if ((void *)fmt >=3D (void *)__hyp_string_fmts_end) {
> +		trace_seq_printf(seq, "Unknown hyp_string_fmt ID %d\n", entry->fmt_id);
> +		return;
> +	}
> +
> +	nr_args =3D (ring_buffer_event_length(evt) -
> +		   offsetof(struct remote_event_format_hyp_printk, args)) / sizeof(ent=
ry->args[0]);

[Severity: High]
Does ring_buffer_event_length() read garbage data here?

If the evt pointer is misaligned, interpreting the payload data as the event
header could yield a garbage nr_args value. This could lead to out-of-bounds
memory reads or information leaks of uninitialized host stack/registers when
trace_seq_printf() is called below.

> +	switch (nr_args) {
> +	case 0:
> +		trace_seq_printf(seq, fmt);
> +		break;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930153505.2144=
559-1-vdonnefort@google.com?part=3D4
