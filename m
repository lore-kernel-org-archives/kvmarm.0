Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6FA3CE4B9
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782458205; cv=none; b=YrrAbpAANyCJoedxV/IE1l2TO+0nMWOrjlX31DRqe69VW6u6f80ouZ8F+63v4Q/Ca3YN4g29GMo4dNbmGd9lzSrcaPJDX1rEO+po6fsD8b74+5t1qU6Oa/XAgrFXQU074FOMaKsY8BnbERjaU4JAxHvjB/cJEncADqnhklfoeX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782458205; c=relaxed/simple;
	bh=wpAGcLFyPOPOKEOh2GQCMuQR5S9x60pspo4bZOxAAbg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uiHh6ZQX42iD+ZsqyWSxacAzzC5QLbCoJWIe7eUXrNxhVZoUXnvuZjAhoVk8HG4aUfoaDRGg6JVQ65P1xpgC9VnYdS9+0kwM69O2zQTihRhvPHMv9SZDE9T9SURBYSqBDswgaEd7sG9biuflX93zyDOf11SKB8irImZnO1mvmqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XnQzM6rE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XnQzM6rE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C821F000E9;
	Fri, 26 Jun 2026 07:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782458203;
	bh=lGLv3QRkanmaRlme3stptPppqI/tiRkabDaRfyv/1MQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XnQzM6rEBbghEpcIrPrGWT5HVoPauYDGJBFS7/BbDI9Du5bIHHvJIXfK+0FuUIXRK
	 8JWtm0STnNLQjKLnA9OdnAUhMRIo5YMdbb3+mJHkdIbfMNKByvz25DhxP+XgPP+luq
	 PZR9tF4/BcsCBNqV9gQlj8FSk6L+ct2xi6spcMprtXreYzEfGJOe8R5H3ONRmHFlnA
	 GTPGeQL3vJl4a3zsz28uBiEWsZl6uuxRRwEHssBrSNnj8pad0JnemX1/rNDNkHE8Hb
	 OfAG+gyJV+6iy2bpydKOqOx9XiZl6JNpfCCDNyrJZtCo9/KbcgD3nd41mWA7yVRZUt
	 Qzv71jNpyMzpA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/8] KVM: arm64: Move PSCI helper functions to a
 shared header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260626070408.3420953-5-fuad.tabba@linux.dev>
References: <20260626070408.3420953-1-fuad.tabba@linux.dev>
 <20260626070408.3420953-5-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 07:16:42 +0000
Message-Id: <20260626071642.C7C821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The newly shared header `include/kvm/arm_psci.h` references functio=
ns without including their defining headers (`<asm/kvm_emulate.h>` and `<li=
nux/wordpart.h>`), violating the practice of self-contained headers.
--

commit 6015f90f953617e9e81e02b97f5532daaa5dfdd7
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Move PSCI helper functions to a shared header

This commit moves kvm_psci_valid_affinity(), kvm_psci_narrow_to_32bit(),
and psci_affinity_mask() from psci.c to the shared include/kvm/arm_psci.h
header. This prepares the helpers for use in protected-guest PSCI calls
at EL2.

> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index cbaec804eb839..f86a006d67136 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
[ ... ]
> +/* Narrow the PSCI register arguments (r1 to r3) to 32 bits. */
> +static inline void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +
> +	/*
> +	 * Zero the input registers' upper 32 bits. They will be fully
> +	 * zeroed on exit, so we're fine changing them in place.
> +	 */
> +	for (i =3D 1; i < 4; i++)
> +		vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)));
> +}

[Severity: Low]
Does this new shared header need to include asm/kvm_emulate.h and=20
linux/wordpart.h to remain self-contained?

This inline function relies on lower_32_bits(), vcpu_get_reg(), and=20
vcpu_set_reg(), but the definitions are not directly included here.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626070408.3420=
953-1-fuad.tabba@linux.dev?part=3D4
