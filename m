Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430893AC0C1
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 09:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781170105; cv=none; b=N54zjiIHTJGw1dWQpjFNICXYz+CynUsuyK9YQyVugCiIK+mv7ZGoA7oEXAzC5URIyYJkuY3mwTCuXy9eGB1mOU4JHu8jeUJreuHd+5AjK0q8TxSTy1E6j1jR0vfm1QsFuvPGXyayIvDMeEdQ2hHkTbnlBPVlEkpvq/b8HPh2Yvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781170105; c=relaxed/simple;
	bh=7etrmlI5A7BMgYIM7URQtNEDTRrH2aw/eXcelOreBNA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oE3tqarjJ2QspzmNLlWNBcuzQ3w1XDCGi0K8EcoqJmyYGAyXTXf3mg7Nr701kZ18DLNuIOJhaKmLoR0FtSJP8X1J8GCGgoSsgWFEaL2SRuqklBg+qo/MzZOh7KLqc7XPHr4YUvMVYRnioOjfyPbE45xOU05dYe2LiaM2YDW6l4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTTVD+PR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTTVD+PR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5201F00893;
	Thu, 11 Jun 2026 09:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781170104;
	bh=4YzfFJnL9TqHOd3FNUFhbqevQH/MKtBLKC7uCHedqaM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UTTVD+PRjsV6Kh0gtNM0ja1WO5MhnWR309YrqM8yHAF7yQ618VxLTiJNUS8oPuopS
	 sPDU4Dh7uKqXC+FgxB8q0eGgmyw9+43BsH1kXTS6cXViGG2SAGEYxDanpEwxJIiL8V
	 3tC1Zx93ndl9T5uBfdHTqekVgDNuMb92pBg4GtafISR7iV1jZzEiFLv+W9C1ZG6s1W
	 iz13H4ZCo+/nwM1czgEOkBICsNhkGRg9kwmK3hP8u6Q1qXXwSREwdkwWSUehM3ioR1
	 TEVNV3kbgulWC8mxEp8d1Sex+BbLtFFSWPsYxYRfTNpbh+oHZhFd9ssMZ88GZQwZEH
	 BASWmifvBvE3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Skip unreset vCPUs in MPIDR lookup
 table
Reply-To: sashiko-reviews@lists.linux.dev
To: "fuqiang wang" <fuqiang.wng@gmail.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260611090934.84469-3-fuqiang.wng@gmail.com>
References: <20260611090934.84469-3-fuqiang.wng@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 09:28:23 +0000
Message-Id: <20260611092823.6E5201F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The `kvm_vcpu_mpidr_is_reset()` check unconditionally evaluates to=
 false due to bitmasking and sign-extension bugs, causing the MPIDR lookup =
table to remain unpopulated and forcing a slow linear-search fallback for a=
lmost all vCPUs.
--

commit 492eed93a0927af5d722a777b1e148b77bf39d93
Author: fuqiang wang <fuqiang.wng@gmail.com>

KVM: arm64: Skip unreset vCPUs in MPIDR lookup table

This commit attempts to fix an issue where unreset vCPUs overwrite the MPIDR
lookup table index for vCPU0 by skipping vCPUs that do not have the RES1 bit
set in their MPIDR_EL1 value.

> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/as=
m/kvm_emulate.h
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
[ ... ]
> @@ -506,6 +506,15 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(s=
truct kvm_vcpu *vcpu)
>  	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
>  }
> =20
> +/*
> + * Check if MPIDR matches hardware reset value. RES1 bits are set after =
reset,
> + * while a zero default indicates a vCPU that has not been reset.
> + */
> +static inline bool kvm_vcpu_mpidr_is_reset(u64 val)
> +{
> +	return (val & MIDR_RES1_MASK) =3D=3D MIDR_RES1_MASK;
> +}

[Severity: High]
Does this check always evaluate to false due to sign-extension? MIDR_RES1_M=
ASK
is defined as (1 << 31), which evaluates to a signed 32-bit int. When compa=
red
against the unsigned 64-bit integer val, the mask is sign-extended to
0xffffffff80000000ULL.

Since val only contains the lower 32 bits, the bitwise AND will never match
the sign-extended mask.

[ ... ]
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
[ ... ]
> @@ -884,6 +884,16 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
>  		u64 aff =3D kvm_vcpu_get_mpidr_aff(vcpu);
>  		u16 index =3D kvm_mpidr_index(data, aff);
> =20
> +		/*
> +		 * In the CPU hot-plug scenario, the kvm_for_each_vcpu() macro
> +		 * iterates over all possible vcpus. For vcpus that are not
> +		 * reset, kvm_vcpu_get_mpidr_aff() returns 0, then the index
> +		 * computed by kvm_mpidr_index() will also be 0, thereby
> +		 * overwriting the original value of vcpu0.
> +		 */
> +		if (!kvm_vcpu_mpidr_is_reset(aff))
> +			continue;

[Severity: High]
Will this unconditionally skip all vCPUs?

The aff argument passed here is obtained from kvm_vcpu_get_mpidr_aff(), whi=
ch
masks the raw MPIDR value with MPIDR_HWID_BITMASK (0xff00ffffff). This
explicitly clears bits 24-31, stripping the RES1 bit (bit 31) from the
returned value before the check even occurs.

Because the check will always fail, the continue statement executes for
every vCPU, leaving the cmpidr_to_idx table completely zero-initialized.
This causes all MPIDR lookups to fail the cache verification check and
permanently fall back to the slow linear search.

>  		data->cmpidr_to_idx[index] =3D c;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611090934.8446=
9-1-fuqiang.wng@gmail.com?part=3D2
