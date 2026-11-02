Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630302;
	b=SyEUDhZ2UtUSzgfar+GxmGfkTXfPk8MIdylyOa6XE6VM+9R5NwE3tAsHqhgVjfSyXHGC
	 Vz0+vWWkifvaNYEhW/A9+DQ3FO3lNKn1X2nHzNfGDy1mquCPtLWM0wDskzqx83I97RYCt
	 RN4vs8aNOWULtD0VPRr93nsgRrjAp4eQN/ZGrGHZQoxFdBHr+Ug5Wfbu354MeDthrR5H+
	 HdLH9O9sDypwiW7p1t8epcMZ/FmfpQyDDG+mlve2LLH/3IR0RCKjwQzSLazl61ghlxohm
	 LFwDvoNvx5YeIraTMt8LMBNFhGhHh9M9L3at9w27zrBe3oTY65svgcoYp+7TY0LVL5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630302;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ny9oIIVnbfsFrLspkH3cGjZ/uaZlRr0vfRl2YcrQ1WU=;
	b=QgA3fbn1PoBsU7FipUPGPEMo3KHbJyNQ0VC75t2XOKRViLbZkc0pmd5WgV96wAulT4Zl
	 Ni/tMK95WEfoVxVIwyigyGna1TV4/eZ0AnOhEy6O4JW7auKICyvcXkd7CDUyF3DspH57U
	 1lJ7+R2XcJF8uL5KLrAbE3RB5w62QST761S/TJZnxBA25dO0P8vPrFUec5CgSIp36QkyZ
	 AuEw5m87HYjb1nqHLqvX7r4o/28Bq1oNtWq3V00P6NaQFeqiALk2pqLxaKkIp/zmnYFYr
	 3p9jP70SzwwnHfafktAk0rtZj93GALkPxgKj9Dgw0N4tSQowICkGpy2Ape6+hWVIZGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SJ2jMuQJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094E6607A890;
	Mon,  2 Nov 2026 14:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SJ2jMuQJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA8E1F00A16;
	Mon,  2 Nov 2026 14:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630300;
	bh=Ny9oIIVnbfsFrLspkH3cGjZ/uaZlRr0vfRl2YcrQ1WU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SJ2jMuQJXONMMg5MDW1xvXHTdBCnKJbFXmcR9JjeUBpCC5/C3g0ukxB8MxL9agRoT
	 mb7GlxFl4/OTfd9/6DqW8gCu6SfuX8h20feGKnK82Lo9gZ9lh48zZTpb+oeOH1uGwd
	 CTlWEkHDdY3sJQrDBKwqiUyfePqqhEtwNeMkAh96qS1mAzWeAy5iXKu8Hd8yOUeodf
	 6vVDhLr4whdAeiXA6cArg/tR7Y03fGJoIn1rmJJv8h3fUW0r0GwjTFd5ssn43Cu8Ps
	 kCMb+YQfDDIyCFUqsRoeNeKoRe2NmPJ3fwecsd3jJxCA5KGdHY+T388vaevbgiZpGY
	 fzmBepkpz1qCQ==
Message-ID: <sashiko-outbox-193589@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/11] KVM: arm64: CCA: Check for LPA2 support and
 SHA-256
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102141304.126883-5-steven.price@arm.com>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-5-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 14:38:20 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] KVM: arm64: rmi_has_feature() passes non-constant mask to u64_get_b=
its()
--

commit a9400749495394b73c9cccd919996b48771556fe
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Check for LPA2 support and SHA-256

This commit adds feature checks during KVM RMI initialization to verify that
the RMM supports LPA2 when KVM has LPA2 enabled and that the RMM supports
SHA-256 measurements.

> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 9d118768550d6..5b07beff8bc91 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -6,8 +6,30 @@
>  #include <linux/arm-rmi-cmds.h>
>  #include <linux/kvm_host.h>
> =20
> +#include <asm/kvm_pgtable.h>
>  #include <asm/virt.h>
> =20
> +static bool rmi_has_feature(int reg, unsigned long feature)
> +{
> +	return !!u64_get_bits(rmi_feat_reg(reg), feature);
> +}

[Severity: Low]
Can this fail to build if the compiler decides not to inline
rmi_has_feature()?

In include/linux/bitfield-fix-width.h, u64_get_bits() calls
field_multiplier(field):

static __always_inline
u64 field_multiplier(u64 field)
{
	if ((field | (field - 1)) & ((field | (field - 1)) + 1))
		__bad_mask();
	return field & -field;
}

Because rmi_has_feature() is not marked __always_inline, if the compiler do=
es
not inline it (for example under CONFIG_CC_OPTIMIZE_FOR_SIZE or compiler
instrumentation), the feature parameter is not a compile-time constant insi=
de
field_multiplier(), preventing constant folding from eliminating the call to
__bad_mask().

Should rmi_has_feature() be marked __always_inline, or use field_get() or a
direct bitwise test instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102141304.1268=
83-1-steven.price@arm.com?part=3D4
