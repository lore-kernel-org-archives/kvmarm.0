Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0944B827E
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 09:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790845631; cv=none; b=Ie+Zg8rBsx/Qp7aAa7negkl8cjFH8WRA4ucYPEI20cnZQsWOtfW7byoPPs4WXaXri5Y9MFbU0dZ5wQw0Pwi09AQub/gEk6FOgizkGOZy/RQZz1TB1YbBq5lENqCHi1pRMnz1HpJyYQ8Ydyz4wvB61rAnvo0kDN4MW3I1IRbcTmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790845631; c=relaxed/simple;
	bh=S8QIHzGmdtEeJkEgShxanSkKhx63osI2Vox9ZwGUDNs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lhZg8/WvIoFtB7yHdH9FVfCFAuVY38kBdsShzk1rFOMMV/y1d83tRwxEMtLKtTOWE/b5sjASyz8k6vqEAlPQgrnwPC8qvvvmvfh3KNG0Diwztpm4dsU7O/vtXVTvzoJ/GKchQC346/wJxpr5o3OPAzIMtCPfwUJKpaJJ2yh9ioo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lUbneWvp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUbneWvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A971F000FF;
	Thu,  1 Oct 2026 09:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790845630;
	bh=T/ud2IvArazkUt9aDFQL/bnA4XkQJ+5Q3uaaQJOCRxs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lUbneWvpS7++HQgsCa1+RJJj6IR128XoihHLg4UbqAuQHW+Tl/TSxM1N3x/1+KxK3
	 ObrX7cYFmpgDLasF9/BN4Tn4Z9SrWcAAGlmYMkejWIrteP43zw/FAL1dFH/t02Peil
	 lW3nZgkFDQA6mCoXy2bh+TZV1vajljonC6/ZZxpP2vkTryLkxZAL/IZTJ1R+q9xDgS
	 MzScWXSB+kXxMIQMpYbn9W9wTRFf2A/HMnOBd9VFRpckV5w496SD4O4L6pzsYLO5e6
	 cnJnmyVtSUJtTazWw1ldc+LJqA3dwMP/CayEZCHvU/G2oBC3WxlGVQjpP41SQGKPkD
	 u4Z9T74nYoeyw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/4] KVM: arm64: Add hyp_printk event to nVHE/pKVM
 hyp
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20261001084909.2937943-5-vdonnefort@google.com>
References: <20261001084909.2937943-1-vdonnefort@google.com>
 <20261001084909.2937943-5-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 09:07:09 +0000
Message-Id: <20261001090709.C0A971F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] kvm: trace_hyp_printk lacks format string validation leading to ho=
st panic/leak
- [Medium] arm64: unaligned _hyp_string_fmts section start leads to pointer=
 corruption
- [Medium] kvm: out-of-bounds read in __hyp_trace_printk when trace sequenc=
e is empty
- [Medium] kvm: uninitialized padding in remote_event_format_hyp_printk lea=
ks hyp memory
--

commit bc7c47888c5fbd307a50212081f15f7498660a9b
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp

Create an event to allow developers to log pretty much anything into the
hypervisor tracing buffer with trace_hyp_printk(), just like the kernel
tracing has the function trace_printk().

> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.=
lds.S
> index af1d720209764..7f9b6c7dfe70f 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -324,6 +324,10 @@ SECTIONS
>  		__hyp_events_start =3D .;
>  		*(SORT(_hyp_events.*))
>  		__hyp_events_end =3D .;
> +
> +		__hyp_string_fmts_start =3D .;
> +		*(_hyp_string_fmts)
> +		__hyp_string_fmts_end =3D .;
>  	}
>  #endif

[Severity: Medium]
Could __hyp_string_fmts_start capture an unaligned address before section
padding is applied? The compiler might align struct hyp_string_fmt
elements, but without an ALIGN() directive, __hyp_string_fmts_start
captures the location counter before any alignment padding. When calculating
fmt_id in the hypervisor (fmt - __hyp_string_fmts_start), this unaligned
offset might yield incorrect values and cause memory access errors.

> diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp=
/include/nvhe/trace.h
> index 8813ff250f8e0..fa50720e2cffd 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
[ ... ]
> @@ -46,6 +46,70 @@ static inline pid_t __tracing_get_vcpu_pid(struct kvm_=
cpu_context *host_ctxt)
>  void *tracing_reserve_entry(unsigned long length);
>  void tracing_commit_entry(void);
> =20
> +/*
> + * The trace_hyp_printk boilerplate is too fiddly to be declared with
> + * HYP_EVENT():
> + *
> + * The string format is stored into a kernel-accessible ELF section. The
> + * hypervisor only writes the format ID.
> + *
> + * The function has a variadic prototype. We have no easy way to know ea=
ch
> + * argument width so they must all cast to u64.
> + */
> +#define REMOTE_EVENT_CUSTOM_PRINTK(...)
> +
> +#define __TO_U64_0()
> +#define __TO_U64_1(x)			, (u64)(x)
> +#define __TO_U64_2(x, ...)		, (u64)(x) __TO_U64_1(__VA_ARGS__)
> +#define __TO_U64_3(x, ...)		, (u64)(x) __TO_U64_2(__VA_ARGS__)
> +#define __TO_U64_4(x, ...)		, (u64)(x) __TO_U64_3(__VA_ARGS__)
> +#define __TO_U64_5(x, ...)		, (u64)(x) __TO_U64_4(__VA_ARGS__)
> +#define __TO_U64_6(x, ...)		, (u64)(x) __TO_U64_5(__VA_ARGS__)
> +#define __TO_U64_7(x, ...)		, (u64)(x) __TO_U64_6(__VA_ARGS__)
> +#define __TO_U64_8(x, ...)		, (u64)(x) __TO_U64_7(__VA_ARGS__)
> +
> +#define __TO_U64_X(N, ...)		CONCATENATE(__TO_U64_, N)(__VA_ARGS__)
> +#define __TO_U64(...)			__TO_U64_X(COUNT_ARGS(__VA_ARGS__), ##__VA_ARGS_=
_)
> +
> +REMOTE_EVENT_FORMAT(hyp_printk, HE_STRUCT(he_field(u16, fmt_id) he_field=
(u64, args[])));

[Severity: Medium]
Can this leak hypervisor memory to the host or userspace through uninitiali=
zed
struct padding? The REMOTE_EVENT_FORMAT definition creates a structure with
u16 fmt_id followed by a u64 args[] array, which introduces padding bytes
before the array to satisfy the 8-byte alignment requirement of u64. Because
tracing_reserve_entry() does not zero the allocated space, these padding by=
tes
are never initialized before tracing_commit_entry() exposes them.

> +extern struct hyp_event_id hyp_event_id_hyp_printk;
> +
> +static __always_inline void __trace_hyp_printk(struct hyp_string_fmt *fm=
t, int nr_args, ...)
> +{
> +	struct remote_event_format_hyp_printk *entry;
> +	va_list va;
> +	int i;
> +
> +	if (!atomic_read(&hyp_event_id_hyp_printk.enabled))
> +		return;
> +
> +	entry =3D tracing_reserve_entry(struct_size(entry, args, nr_args));
> +	if (!entry)
> +		return;
> +
> +	entry->hdr.id =3D hyp_event_id_hyp_printk.id;
> +	entry->fmt_id =3D fmt - __hyp_string_fmts_start;
> +
> +	va_start(va, nr_args);
> +	for (i =3D 0; i < nr_args; i++)
> +		entry->args[i] =3D va_arg(va, u64);
> +	va_end(va);
> +
> +	tracing_commit_entry();
> +}
> +
> +#define trace_hyp_printk(__fmt, __args...)						\
> +do {											\
> +	static struct hyp_string_fmt __used __section("_hyp_string_fmts")		\
> +	__hyp_str_fmt  =3D {								\
> +		.fmt		=3D __fmt,						\
> +		.nr_args	=3D COUNT_ARGS(__args),					\
> +	};										\
> +	BUILD_BUG_ON(sizeof(__fmt) > HYP_STRING_FMT_MAX_SIZE);				\
> +	/* __TO_U64 prepends a comma if there are arguments */				\
> +	__trace_hyp_printk(&__hyp_str_fmt, COUNT_ARGS(__args) __TO_U64(__args))=
;	\
> +} while (0)

[Severity: High]
Does this macro validate that the provided format string matches the given
arguments? Without checking the format string (e.g. using __printf attribut=
es
or if (0) printk(...) type-checking), a mismatch like
trace_hyp_printk("val=3D%d") will set nr_args to 0.

The host kernel's __hyp_trace_printk() will then unconditionally call
trace_seq_printf(seq, fmt); with no arguments, potentially causing
out-of-bounds reads or invalid dereferences when it parses the %d or %s
specifiers.

> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index 8faaec899f92c..ebb882d0152b6 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
[ ... ]
> @@ -421,6 +424,58 @@ static const char *__hyp_enter_exit_reason_str(u8 re=
ason)
>  	return strs[min(reason, HYP_REASON_UNKNOWN)];
>  }
> =20
> +static void __hyp_trace_printk(struct remote_event_format_hyp_printk *en=
try, struct trace_seq *seq)
> +{
[ ... ]
> +	switch (hyp_str_fmt->nr_args) {
> +	case 0:
> +		trace_seq_printf(seq, fmt);
> +		break;
> +	case 1:
> +		trace_seq_printf(seq, fmt, entry->args[0]);
> +		break;
[ ... ]
> +	}
> +
> +	if (seq->buffer[trace_seq_used(seq) - 1] !=3D '\n')
> +		trace_seq_putc(seq, '\n');

[Severity: Medium]
Is it possible for trace_seq_used(seq) to be 0 here? If the sequence buffer
was empty or in an overflowed state when passed to this function, subtracti=
ng
1 would result in an out-of-bounds array read (accessing seq->buffer[-1]).
Would adding a check for trace_seq_used(seq) > 0 prevent this?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001084909.2937=
943-1-vdonnefort@google.com?part=3D4
