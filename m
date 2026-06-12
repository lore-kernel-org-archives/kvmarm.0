Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBD4349B0A
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 14:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781274808; cv=none; b=qea/l5pm0SdxiSEgzIwFded0uwpRurjmLEkQZcXJRoKhLW2yb814ImY3XbA5g8XeVyJtWH66aUQC+63/R1PaazRIwH3YCZOtyMbLb9i22nvqtkmsRqsMMHdSfVAk0ooxG1buHuPbSE3a0ZLT0ZVXtguh+5Yrd+jalGnnROhNOYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781274808; c=relaxed/simple;
	bh=1kIUhhtg8j8MH7+8dyR6PJL2hDticDgw0P7VS2nD/a0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g3QCMu9QZli1U6JyUI1lRrBzl6jDumPbiyS11MiOqHmkfdifOF1E6K19OSqBFbYNveEkVlOoRax8Y1Z4xqeodlA9pW4R1PRG1mlmj9ya+LKVIBy8vzn1vLnpnlBSwAIz4w4QNsViE5M6RYU2V2E68cc2o8EQsURbnmv3iM5uJmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fSJCHHo2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fSJCHHo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B2B1F00A3D;
	Fri, 12 Jun 2026 14:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781274806;
	bh=cndT0VGwrqJ4buh3IXFu4vXBqMDwsGuHKDGwaUMl56I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fSJCHHo2Vh9tVOKVVXWLKyOiQ7yfm+aJLDtk6JxnhapBOZ44JEDQgwDThjWKIKNaV
	 CTav+VLhSpZy6Rx80GxCRmWn16lS3hwEIcyT2Lzbt4ujh6vFRTYkBZ3PNQIGrm3lwK
	 h+KOmZxLdTvos3xSbKYY4lrT1L2A1o7+mNvRZucRwqk+ZIXBY/T6nejbB4vWjbAyIK
	 G5lpqNpJyabBcHBSeKRIDY698+ZoSXo6+ISScNuIl+y3RmddV8S8bI8sdyXaLJvMXM
	 al9JaXAFpK6HJ1c6vS2gAGNIidTSmPFbhUpcLUirYYs5c/a83hp3SUYrptxuesgnja
	 SVhvD1hFg/2NA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 4/4] KVM: arm64: Add hyp_printk event to nVHE/pKVM
 hyp
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260612142245.1015744-5-vdonnefort@google.com>
References: <20260612142245.1015744-5-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 14:33:26 +0000
Message-Id: <20260612143326.93B2B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Linker script alignment mismatch causes the host to read padding b=
ytes instead of trace format strings.
- [High] Missing format string validation in `trace_hyp_printk` allows host=
 kernel panics via `%s` and information leaks via argument mismatch.
--

commit d7bc5a6433c1c6dd4e023e0c02d6df0881142324
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp

This commit adds a trace_hyp_printk() mechanism to allow logging from
the nVHE/pKVM hypervisor into the host's tracing buffer. The format
strings are stored in a kernel-accessible ELF section, while the
hypervisor writes the string ID and arguments.

> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.=
lds.S
> index e1ac876200a3d..b6d62642b6bdb 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
[ ... ]
> @@ -324,6 +324,10 @@ SECTIONS
>  		__hyp_events_start =3D .;
>  		*(SORT(_hyp_events.*))
>  		__hyp_events_end =3D .;
> +
> +		__hyp_string_fmts_start =3D .;

[Severity: High]
Does this lack of alignment before __hyp_string_fmts_start cause pointer
arithmetic issues?

The start symbol is defined without an explicit alignment directive like
. =3D ALIGN(8);. Because struct hyp_string_fmt is a 128-byte array, the
compiler may align it to a larger boundary. The __hyp_string_fmts_start
symbol captures the location counter before the section's alignment
requirements are processed by the linker.

Later in __trace_hyp_printk() within arch/arm64/kvm/hyp/include/nvhe/trace.=
h,
the pointer arithmetic:
  entry->fmt_id =3D fmt - __hyp_string_fmts_start;

can yield a corrupted index if the start symbol includes padding bytes. The
host reconstructs the pointer using this corrupted index in
__hyp_trace_printk(), causing it to read padding bytes instead of the actual
trace format strings.

> +		*(_hyp_string_fmts)
> +		__hyp_string_fmts_end =3D .;
>  	}
>  #endif

[ ... ]
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp=
/include/nvhe/trace.h
> index 8813ff250f8e0..3d0b5c634bb3f 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
[ ... ]
> +#define trace_hyp_printk(__fmt, __args...)						\
> +do {											\
> +	static struct hyp_string_fmt __used __section("_hyp_string_fmts") fmt =
=3D {	\
> +		.fmt =3D __fmt								\
> +	};										\
> +	BUILD_BUG_ON(sizeof(__fmt) > HYP_STRING_FMT_MAX_SIZE);				\
> +	/* __TO_U64 prepends a comma if there are arguments */				\
> +	__trace_hyp_printk(&fmt, COUNT_ARGS(__args) __TO_U64(__args));			\
> +} while (0)

[Severity: High]
Could this missing format validation lead to host kernel panics or
information leaks?

The trace_hyp_printk macro blindly casts arguments to u64 without verifying
that they match the format string at compile time.

This can cause severe cross-privilege issues:

1. If an EL2 developer uses the %s format specifier, the macro casts the EL2
string pointer to u64 and passes it to the host. The host's trace_seq_printf
would attempt to dereference the EL2 virtual address, resulting in an
immediate EL1 translation fault and host kernel panic.

2. If a developer passes fewer arguments than format specifiers (for exampl=
e,
trace_hyp_printk("x=3D%d y=3D%d", x)), the COUNT_ARGS macro returns 1, and =
the
host executes the case 1: block in __hyp_trace_printk. The underlying
vsnprintf on the host will parse the second %d and fetch the missing argume=
nt
from the host kernel's stack or registers, leaking host kernel memory into
the trace buffer.

Could we add a dummy __attribute__((format(printf))) check to ensure
these mismatches are caught during the build?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612142245.1015=
744-1-vdonnefort@google.com?part=3D4
