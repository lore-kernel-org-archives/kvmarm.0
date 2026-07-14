Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3530377019
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 10:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784025835; cv=none; b=W2x/em/qkKZ15OFgwO56Sb6rMfJjLceTHzfkYGv5yg0VlYQ2Ed84hen+zjtVYnBu2P5VKnUeIIlM+rgBeSwFZ1LU375gh34cKvjTiZubk4EGIlC9/9AK5M5jhum28Zc03VugbBCoi74OjEQ8hcsDOzh8pXm/5ICuLadyhb7r7Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784025835; c=relaxed/simple;
	bh=xWLngaxltA5NnVjIRwWKcEqNV6xV20PNkz8Yr/EAHoc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Dbgz57u3HVGso29BOW4uGILPSPBEZ3/VCsTkm/1ROtVvvqxgK/ozBbJaAA9CFGTSTmQDz0U8kqsqmN9VZzXJuycs2kVVFW/LEO7iP0a0/izJ8/oHFvB7b/ixlF3aYwD0PWPT/jhqZPQjnbhU8xtqqiy20ndM8nfvj10ZczVjBck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Udh4FiMy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Udh4FiMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615DA1F00A3E;
	Tue, 14 Jul 2026 10:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784025824;
	bh=Gpq/K4Q8AvWCWE/+NAdfxzP0EEx9bFz/LIS9Jp79RJM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Udh4FiMyoK/aNyJ/7NMsQr5MKh77cpXxhcfJ7RkEZcPeBRHH6VAyUHCC+/MA3Mpbs
	 J4J/Bl7Ttu5ZVZriDT/Pjhvqy/ulVhmDfUiNtENcmoWYaGBjG28pF5vUa5TQEB4AYK
	 SgNgYJYI3v/IY+s6pLUDFOccLl9FuBpKmPJSRJEz7JQkKXiEt2hEtm9znrdgE0//HT
	 630nAhYLbjhJjIUl2iiVEYyFgnaAOnz5/iW15zVtWhkNChgF34D/IMvVu147pYJ7YN
	 QGEzSLAkcSkCbz0TBAQn2bK4TSuW7y0jqB6NY/V3masXndCUoW841+YEF6TKxAID36
	 M/GRrXJgHtdnQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260714101601.4142645-3-fuad.tabba@linux.dev>
References: <20260714101601.4142645-1-fuad.tabba@linux.dev>
 <20260714101601.4142645-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 10:43:44 +0000
Message-Id: <20260714104344.615DA1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The WARN_ON_ONCE checks in __vcpu_read_sysreg_vhe and __vcpu_write_=
sysreg_vhe contain impossible conditions.
--

--- Patch [2]: [PATCH v5 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg av=
ailable to HYP code ---
commit fbd97ecacd267a88fbcb547ae114d7b3bbe56fb4
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code

This patch renames the host-only implementations to
__vcpu_{read,write}_sysreg_vhe() and turns vcpu_{read,write}_sys_reg() into
context-dispatching wrappers. This allows helpers built on them to be shared
with hyp code.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 08ba882799d48..c6a416974a61f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -291,7 +291,7 @@ static void write_sr_to_cpu(enum vcpu_sysreg reg, u64=
 val)
>  	}
>  }
> =20
> -u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
> +u64 __vcpu_read_sysreg_vhe(const struct kvm_vcpu *vcpu, enum vcpu_sysreg=
 reg)
>  {
>  	struct sr_loc loc =3D {};
> =20

[Severity: Low]
Since the new vcpu_read_sys_reg() wrapper in kvm_emulate.h explicitly checks
has_vhe(), does this make the WARN_ON_ONCE(!has_vhe() ...) check inside this
function dead code?

Specifically, just below this declaration:

	locate_register(vcpu, reg, &loc);
	WARN_ON_ONCE(!has_vhe() && loc.loc !=3D SR_LOC_MEMORY);

Is it worth removing the check now that the caller guarantees has_vhe()
is true?

[ ... ]

> @@ -338,7 +338,7 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, en=
um vcpu_sysreg reg)
>  	return __vcpu_sys_reg(vcpu, reg);
>  }
> =20
> -void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg=
 reg)
> +void __vcpu_write_sysreg_vhe(struct kvm_vcpu *vcpu, u64 val, enum vcpu_s=
ysreg reg)
>  {
>  	struct sr_loc loc =3D {};
> =20

[Severity: Low]
Similarly, does the WARN_ON_ONCE(!has_vhe() ...) check inside this function
become unreachable now that the wrapper only calls this when has_vhe()
is true?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714101601.4142=
645-1-fuad.tabba@linux.dev?part=3D2
