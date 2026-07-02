Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1053C347FE1;
	Thu,  2 Jul 2026 16:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009570; cv=none; b=brYde9sI3uYHgtAT0yOW4Zs6FAS8n+ApphxomVxXKbjJdfTluB0XOtDsjeQdaOsRjjMYukxaRnSOQg/tLC7FnBGfKkmx8Y0Uk3maOGZ7YPf/Pyypq6+dVN61cfNErykrhEN1H4F5JQR7frwwYIQZthR7y6/zDyfIwjL8MRnpbfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009570; c=relaxed/simple;
	bh=0W9DKRSWkM9tR2BVEViGLmyPtBA/yiepWYGfUN6fGVA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IXiUi0nkiOa5iM7xKSefHj8X0jWWwIEh42QiGHHc5Y6ZF4pa+IRoYz05yT1wk0XEmcW740j79KirriQClZwP3gvkmKGxLYuhpiCuRUJpupbHXZCnSvKoDB1CtsWV8pWpi8iLmzjIgyY5p2Br7YSJVMQG4gAmvCt1vsuxlymU8AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oaYrmYxW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oaYrmYxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0FD1F00A3D;
	Thu,  2 Jul 2026 16:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783009568;
	bh=fv/mkmKB2xleCWuS0asvQSJ+Al6kKj/whpZF3Y23zgM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oaYrmYxWzQeC8WwHx3QNUixvLT4Dbl8PUZYTVg+QRqwOVOlqARD3qP5bpvWvS0tD6
	 mde0I22oontiiW1wWRT52FxSeEMvWXqg7aUxzTDA+LC1jNRTI2kYYqN+Stvf5oPcSz
	 h/wp1UsFvH8Km1hHkM4vqPZPE5PBgBMfRdkjAln2MTKjVPkc945TVK8t1J1GUZlmoS
	 VV/OOZASpPPnyDAVAjz4yMvtesQWLnB/0sQfN5d+EoU9xNUw816VdzHBhsFZT+yYBe
	 8z8P9Utr4+t6KM1rSROv8vsvCUDWq5Qh+HswRqdDdUuTLt346yENS0Jd5l64VwIHnk
	 LD5FRY7J/8R7w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 22/28] KVM: arm64: Add routing for NVHCR_EL2 trap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260702160248.1377250-23-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-23-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 16:26:07 +0000
Message-Id: <20260702162608.6D0FD1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The trap routing condition for `NVHCR_EL2` incorrectly uses a logi=
cal OR (`MCB`) instead of a logical AND, causing improper trap injection to=
 guest EL2.
--

commit 6d634fa5ff4e9b082f4e46e999fa4990ecf38957
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add routing for NVHCR_EL2 trap
   =20
NVHCR_EL2 accesses from EL1 are taken to EL2 when HCRX_EL2.NVTGE=3D=3D0
and HCR_EL2.NV=3D=3D1. Describe this in the exception routing tables.

> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index b7f3d86a94031..f5dc578d8c985 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
[ ... ]
> @@ -468,6 +477,7 @@ static const enum cgt_group_id *coarse_control_combo[=
] =3D {
>  					CGT_HCR_TVM, CGT_HCR_TRVM, CGT_HCRX_SCTLR2En),
>  	MCB(CGT_HCR_TPU_TICAB,		CGT_HCR_TPU, CGT_HCR_TICAB),
>  	MCB(CGT_HCR_TPU_TOCU,		CGT_HCR_TPU, CGT_HCR_TOCU),
> +	MCB(CGT_HCR_NV_HCRX_nNVTGE,	CGT_HCR_NV, CGT_HCRX_nNVTGE),

[Severity: High]
Does this correctly evaluate the trap condition as an AND?

The commit message indicates the trap is taken when "HCRX_EL2.NVTGE=3D=3D0 =
and
HCR_EL2.NV=3D=3D1". However, coarse_control_combo[] uses the MCB() macro, w=
hich
evaluates multiple conditions using a bitwise OR:

arch/arm64/kvm/emulate-nested.c:__compute_trap_behaviour() {
	...
		for (int i =3D 0; cgids[i] !=3D __RESERVED__; i++)
			b |=3D __compute_trap_behaviour(vcpu, cgids[i], b);
	...
}

Because this ORs the behaviors, the trap will be forwarded if HCR_EL2.NV =
=3D=3D 1
OR HCRX_EL2.NVTGE =3D=3D 0 evaluates to forward. This would erroneously sen=
d the
trap to EL2 even if normal execution without nested virt is active (NV =3D=
=3D 0
and NVTGE =3D=3D 0).

Should this use a __COMPLEX_CONDITIONS__ callback instead to enforce the
logical AND?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702160248.1377=
250-1-maz@kernel.org?part=3D22
