Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA192494A04
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 13:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785331905; cv=none; b=FeKcDg1+VFl8wg9y6KP7lA3puShULke0orecrWOAc+CFZgVF3dHqM8Jit6kVRloo9tdtypXXEqThBBsHGy7Tkll8AjTRQ3XfvzGLFr1zkfVdMbKU50gZjGi6j9CfGBq53K3Z2v35rN8ie8zakGJkGvLpuE/WBP/BhCKXOgT+SXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785331905; c=relaxed/simple;
	bh=DxPc0iWUFE3pgy/bhAX9UYxs3F0jsfCBd7CA/10CIwU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kvy3/2+AuJQWsfvgIS1eZ0Jz2xiKSn8IT8w/7mJBKD4eU0AMl+pyPwvju4Gy+JDXUbx9YKnEz/ScJUVqBaIdsF+t5qusVC5KzxmDcfCxCpnjwHDwsyky0YAYqRBZUBS1pPkd2VD2bqwz44xDkzoe9Wmetju0XYas/3QTCovy1+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DgA74cqo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DgA74cqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EFA1F00A3D;
	Wed, 29 Jul 2026 13:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785331896;
	bh=UB8JTNDWwxKl66ShW1S6cEMRaDUqYLEZRH1D33GgNKE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DgA74cqoEmsmKw18MfhAT/XhOhcyw4dRS9SikQJ6Up4dUZzTbFtQG3044iqVPf53x
	 p4CGCdgez8RhXR0DWdZlUr9jtgUSLKl8Ff1UxPxflgZjvshj9f2aXLgsnZAwnt8flP
	 nXLeAq1nmf+TXOVZgjWPBQVav8XX3KlECvmHvGYIOMSOTpmIhNx8iDUsneLiOJHO8r
	 kxhS2jhAO5KkJCiL+oKVol9PfYV8HMdR+zznNh0YEaueStFayhm/ukeGZTSOQRxQFk
	 Hh8oYNnhLm3xpb2bVMHLUgLV5V8ct+AHwKrgKbq8rmqnXDmKbaqnSL87PaBv+0uuNz
	 LamSb6ME1c/lg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 4/8] KVM: arm64: Move PSCI helper functions to a
 shared header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260729131823.2021516-5-fuad.tabba@linux.dev>
References: <20260729131823.2021516-1-fuad.tabba@linux.dev>
 <20260729131823.2021516-5-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 13:31:35 +0000
Message-Id: <20260729133136.50EFA1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Missing header dependencies in include/kvm/arm_psci.h
--

--- Patch [4]: [PATCH v7 4/8] KVM: arm64: Move PSCI helper functions to a s=
hared header ---
commit 4d648c3ac7ab8549b7dcf7d52de4756db87e329c
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Move PSCI helper functions to a shared header

This commit moves several PSCI helper functions from psci.c to the shared
include/kvm/arm_psci.h header. This makes them available for upcoming
protected-guest PSCI calls at EL2.

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
Does this header need to include additional dependencies to remain=20
self-contained?

This inline function uses vcpu_set_reg() and vcpu_get_reg(), which are defi=
ned
in <asm/kvm_emulate.h>, as well as lower_32_bits() from <linux/wordpart.h>.
If a new C file includes <kvm/arm_psci.h> without first including those
dependencies, it looks like it could trigger a build failure.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729131823.2021=
516-1-fuad.tabba@linux.dev?part=3D4
