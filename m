Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5ABF19B5A3
	for <kvmarm@lists.linux.dev>; Sat, 19 Sep 2026 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789821546; cv=none; b=J2mIK73Cv3pSMSBgF5+lFuawtREtgoQrLlcd9nbXpmPq/OFUlnf7YrzZ9P3pUUIMK23nfqdD/B4482ewty45ehBp3VrscpYAyF9G5Nf/lzZciC8QBP96zAoCc4IcbplNMYVFLvwo8VaRB+e29urbXthiNLL3Qcr5zB6f+BNUomQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789821546; c=relaxed/simple;
	bh=VYCW5t4fSMg4T0rGmNZYA7B+uLZ5RpNz4FNoX39qvsU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iuAzbQURllFQeFBM/Cu38L20LU1zotaLLICSAGGhXURycYZjLzrzAOYoamXVr6Eoqq3QDAp95DeUIwTPGfSCMjj4TVmXHSZKHUq+H3QM7NTErCm1Q76LRYh+p6zhpIJNRYMf+JuEKoHpO0EoYRL8mUW3HEF7hM47WJl2RWtK+Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dmXxz9xY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dmXxz9xY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515941F000FF;
	Sat, 19 Sep 2026 12:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789821545;
	bh=iagt8R/JhufdS636a46I55mODYQkthz/9zEq+XMuWBM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dmXxz9xYiAbjumIde/NCWbGMWponRK7SRPJLzyK+kdVEOdeEeX41bZcs3DsGkCzHh
	 F9oDMqb1T6UUCPLEjL3a+Qe+Luw+diLaZ20S6kMwePTGnwisH0aNnHXoSGGSlCxLPh
	 3Y0QTjZLEAjmghG1vT9nBxPYiavEj6PdxqfXckrPYblx8T0XRnv9aG3T9+BUhTtwGU
	 KcscXsYdPc6+Dl6NJkxhRy2954rF1opvpaZXV7efVHFa2Wp9lKFHy28554AAWkmg4T
	 abjjjF63jUKeAUD/1piiGCWDvowxavSmgB9TJ5BW7gCNYbF0TfQ4NObxzyg/fqe1UO
	 L/oih04sfXGhQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] KVM: arm64: vgic-v5: Correctly handle host ISTE
 __le32 conversion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260919123150.3283606-5-maz@kernel.org>
References: <20260919123150.3283606-1-maz@kernel.org>
 <20260919123150.3283606-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 19 Sep 2026 12:39:04 +0000
Message-Id: <20260919123905.515941F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] kvm: arm64: code and commit message mismatch regarding h_iste ty=
pe
--

commit a916f514228ceaaf50a5546f6df29cea59ab15f1
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: vgic-v5: Correctly handle host ISTE __le32 conversion

This commit addresses a sparse warning by modifying the endianness
conversion of the host ISTE. The intent is to define h_iste as a u32
instead of __le32, doing the conversion at the point of access.

Closes: https://lore.kernel.org/oe-kbuild-all/202609191215.to1MBYak-lkp@int=
el.com/

> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> index 2c8d0f360506c..aae5cf05f3907 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c

[ ... ]

> @@ -1520,7 +1520,7 @@ static int vgic_v5_save_two_level_ist(const struct =
vgic_v5_ist_desc *ist,
>  			h_iste =3D *(__le32 *)(h_l2_ist_base +
>  					     h_l2_index * ist->iste_size);
> =20
> -			ret =3D put_user(h_iste, uaddr);
> +			ret =3D put_user(le32_to_cpu(h_iste), uaddr);
>  			if (ret)
>  				return ret;

[Severity: Medium]
Is the refactoring in vgic_v5_save_two_level_ist() incomplete?

The commit message explicitly states "define h_iste as a u32", and this
pattern was applied to the other three functions modified in the file.
However, in vgic_v5_save_two_level_ist(), the h_iste variable retains
its __le32 type at the top of the function, and the conversion is instead
done inline within the put_user() call.

Does this variable also need to be redefined as a u32 to remain consistent
with the commit description and the rest of the patch?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919123150.3283=
606-1-maz@kernel.org?part=3D4
