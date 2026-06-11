Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C96345731
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 09:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781169522; cv=none; b=nuwvidLIWNw2eQl5Oj58eS8PlRQ0YgrHqWv7kNi3dkwNI7GJX5A27N8lDgTmCOiM9pzx98d/kYxdIVa8YlnJLQ4abGs6f9NAMQb2Z6Gk5+zbbmIjtN9PJV/7GwmVudt0CTeO70lBegcPyD/UQS+bJWQRTg/5XqizRhaKGSvlo18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781169522; c=relaxed/simple;
	bh=d0tJ3JrF1JWdrjsqkDWffVEh6HYc7YPcUY0WiBY/UFo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tXLcgI4v/T2ImafWc0Otkkp6UuB35vOgFJCqeChCizXqCJ4zhLljmx8bkySu9YfOa3cViJyYmaL3TvJX4+YWnO4oZpvIGyPn0JFPBkzqVXWe5W3ZErDnlD7DGkOFD8OHz04LM0JVVIHKbUL1CqmdEH2MyqHJPbkGBoZ/gjVKGcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eiCtuE1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eiCtuE1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA79B1F00893;
	Thu, 11 Jun 2026 09:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781169521;
	bh=hR6OaPhm/gmkweqEAbox3QTz08C+MgW+Uett7gfY3Ac=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eiCtuE1te/IBeOMpXvP3O1NU3mGgYdwAj6HN9AkecdjZQjbyMg2SzYuWes5VVN8w0
	 iONoccfW9k/2sTtfm1ib6KWr/OZDfDGF+44X1zgDpfRdHuuF+f67CFS5q5oLd6XeNM
	 TriHSJAIFx00DczgGoO/pnfFIAUzUmhyzKw0wNDSO9GAPLlCTniSRHOl1FW5CjLEqP
	 +DGh35E6KJ9F7G/3o4BUWiQQS5LehD8ug+CgzhO6GYokhzLE6gSwq81lYSDVH9Fo14
	 RiXkSVY2EWRKxNZZXPKgak2rc9XlyYXJF4OdRC/28nb/kKYcAP+Z87EaZaQkTzYmqv
	 QQZhMib3Y7lOw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] arm64: Add MIDR_EL1 RES1 definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "fuqiang wang" <fuqiang.wng@gmail.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260611090934.84469-2-fuqiang.wng@gmail.com>
References: <20260611090934.84469-2-fuqiang.wng@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 09:18:39 +0000
Message-Id: <20260611091840.BA79B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] The macro `MIDR_RES1_MASK` is defined as `(1 << 31)`, which ca=
uses undefined behavior via signed integer overflow and dangerous sign-exte=
nsion when applied to 64-bit values.
- [High] The commit incorrectly asserts that bit 31 of `MIDR_EL1` is `RES1`=
. Bit 31 is actually part of the `Implementor` field.
--

commit 8b397f704d83868070b0e6c30f4a5f7c1b4f12e3
Author: fuqiang wang <fuqiang.wng@gmail.com>

arm64: Add MIDR_EL1 RES1 definitions

This patch adds definitions for bit 31 of MIDR_EL1, identifying it as a
RES1 bit.

> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cp=
utype.h
> --- a/arch/arm64/include/asm/cputype.h
> +++ b/arch/arm64/include/asm/cputype.h
> @@ -39,6 +39,8 @@
>  #define MIDR_IMPLEMENTOR_MASK	(0xffU << MIDR_IMPLEMENTOR_SHIFT)
>  #define MIDR_IMPLEMENTOR(midr)	\
>  	(((midr) & MIDR_IMPLEMENTOR_MASK) >> MIDR_IMPLEMENTOR_SHIFT)
> +#define MIDR_RES1_SHIFT		31
[Severity: High]
Does this correctly identify the register?

According to the ARM Architecture Reference Manual, bits [31:24] of MIDR_EL1
represent the 8-bit Implementor code.

Could this be confusing MIDR_EL1 with MPIDR_EL1, where bit 31 is indeed
RES1?

> +#define MIDR_RES1_MASK		(1 << MIDR_RES1_SHIFT)
[Severity: Critical]
Can this cause undefined behavior via signed integer overflow?

The literal 1 is a 32-bit signed integer, so shifting it by 31 overflows.

When this mask is used in kvm_vcpu_mpidr_is_reset(u64 val), it is
sign-extended to a 64-bit value (0xffffffff80000000). The condition
(val & MIDR_RES1_MASK) =3D=3D MIDR_RES1_MASK would then expect all upper 33=
 bits
of val to be 1.

Since val is obtained from kvm_vcpu_get_mpidr_aff() which explicitly masks
the register value with MPIDR_HWID_BITMASK and clears bit 31,
kvm_vcpu_mpidr_is_reset() will always evaluate to false.

Will this cause kvm_init_mpidr_data() to unconditionally skip all vCPUs,
leaving the KVM MPIDR-to-vCPU lookup table empty and guests unbootable?

> =20
>  #define MIDR_CPU_MODEL(imp, partnum) \
>  	((_AT(u32, imp)		<< MIDR_IMPLEMENTOR_SHIFT) | \

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611090934.8446=
9-1-fuqiang.wng@gmail.com?part=3D1
