Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE9145A284;
	Mon, 14 Sep 2026 12:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789389675; cv=none; b=IdYzRF2Qu2/6+YDdbc/I8LgQzh6yuRBTMMMGek9tujK4r+vKq/UlDNehLLSBSQr/zHqmCSdJoK6cpSPyscYowTxKKuJ8vBIM+Q/wG0cmgyoyRh//nb304gy308mYTRLOxQVsfY+nKjQXyHv+eKPd2xIpg9DfjnKqHA/Q/M9608o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789389675; c=relaxed/simple;
	bh=6OdUupEoTI9x3lCh6YxYzy6R78ghSCLSRa4eUzlLKME=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OkicHjWR9EfzYJrXh4qgkqhg9Z51ppSNeExCccS39HMvrFIbB9Tw2evQsZUndNMtfeeEAhJCDKbRuzcoZ4yEntr5fc+kfv8ZASkDilVcKyoniux0d3+QQcgs6WLXb4aGgIPPJY47SII+6ywgnqY89DXHiBAVrfVo1I6Uy5UgFG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jLd9B7SF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jLd9B7SF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07ED01F000FF;
	Mon, 14 Sep 2026 12:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789389673;
	bh=WmRIV58agLlwNXVxN9Er09L3N2g5lQM1tRaoJRS5WgM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jLd9B7SFVjYhC4WfV3zKNa1J78VJue/dM1+qQWDGdxg+ZbsPF4g/4xKKI3DTOGiw9
	 gpw/759L1KYTUyci+/rWFp3JTlUB7iVINttndLyVzov3FuXg41T7wzbdy/+D3+NOza
	 29NU6LppGThgAzQYYvfaHKEMSH5UWc4cEPyi2a94Qpytp48CNFR4wOVuRxWGrAtMbI
	 70CgzxwsgnGju8i2cWh/dysZRHCEwAp34LNwOYZgVkOnuEGRJu/k5PKqnMX/q9oifu
	 SqgFHmxxRJLsnl6DcWmZTkUeRPCadJ6zAcIygtl7xXqGI19ppRAajYJE4L+5PYQJlp
	 1WTHighhddksw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/13] arm64: Add ESR fault helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260914-kvm-arm-prefault-v2-1-26fb47f74b73@kernel.org>
References: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
 <20260914-kvm-arm-prefault-v2-1-26fb47f74b73@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 12:41:12 +0000
Message-Id: <20260914124113.07ED01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Generic ESR helpers `esr_trap_is_iabt()` and `esr_abt_is_exec_fault=
()` silently ignore instruction aborts from the current Exception level (`E=
SR_ELx_EC_IABT_CUR`).
--

commit 5b92bb137f8d48a92e83b6486d7d57faacb410df
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

arm64: Add ESR fault helpers

This commit adds helper functions that operate directly on ESR values, mirr=
oring
equivalent KVM vCPU wrappers to allow KVM's stage-2 fault handling to opera=
te
on plain ESR values.

> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index f816f5d77f1a5..9c0205983d9a8 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -437,6 +437,50 @@
>  #ifndef __ASSEMBLER__
>  #include <asm/types.h>
> =20
> +static __always_inline u8 esr_get_ec(unsigned long esr)
> +{
> +	return ESR_ELx_EC(esr);
> +}
> +
> +static __always_inline bool esr_trap_is_iabt(unsigned long esr)
> +{
> +	return esr_get_ec(esr) =3D=3D ESR_ELx_EC_IABT_LOW;
> +}

[Severity: Low]
Does this intentionally ignore instruction aborts originating from the curr=
ent
Exception level (ESR_ELx_EC_IABT_CUR)?

While this is safe for the current KVM stage-2 fault handling which only
processes LOW traps, moving this to a generic architectural header with a
generic name introduces a trap for future callers evaluating host kernel
page faults. It also contrasts with esr_is_data_abort() in the same file,
which correctly checks both LOW and CUR variants.

[ ... ]

> +static __always_inline bool esr_abt_is_exec_fault(unsigned long esr)
> +{
> +	return esr_trap_is_iabt(esr) && !esr_abt_is_s1ptw(esr);
> +}

[Severity: Low]
Because this relies on esr_trap_is_iabt(), does this mean it will also
misclassify current-EL execution faults?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-kvm-arm-pr=
efault-v2-0-26fb47f74b73@kernel.org?part=3D1
