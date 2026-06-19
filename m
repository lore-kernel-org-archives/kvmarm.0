Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259341FD4
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781827625; cv=none; b=irMUrXJ9QsjYHZThUfW31vJQcQFFdAMM+j+R1fgYHp7HpMY8ClI+xBpoUDZX1juw72rXInPQdOG81NdrBF0b2RG9JprYe4/DP274GUV7FCWC7P6+6QAJIEu7mqueFJAc3ZMwE8ztuIwLJ5xI+aSgk6t1OVb12HFKB/5FvY1fPF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781827625; c=relaxed/simple;
	bh=d9yG7gEhRyQCJBoLIncFxVByfpFnSu1tEONI0JeZgaQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RgI8AL/dqEBaKWQNrbczF+asxNOKBNRz1kS7G/XLVY3zhYDOMscQz1ESnTXLV2XbAr7LllRw/i91FSBJWadZDorjxLnEn3oBI1vM2yJkVfbODwxWD3sel+FAe/7U7i57K+wQWA9h5has658WfDIdexD2+jDsDMXnsfRjfw5IQVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFTY4Ywo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFTY4Ywo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F731F000E9;
	Fri, 19 Jun 2026 00:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781827623;
	bh=ImMJTtc9KUQT/FWN7Xi+8pIc7fiOiZCNJvmhl6m4Svs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mFTY4YworO5HwH14Un8gyiBNzydlDboMYrTyUciHIsKSCbkBLN6hiWfe9YoOVxQmV
	 Z+lvltJPld9lWrMCoCDh3gEXwnxSWogZpj3O+IwKYc4I/fZy6/td2qAJKOGu5ls2R0
	 u+f4KiMObxSjpvQ7WeHaCmaafE9GYksOx+GXAV++eNOCJfhPHornyy5xviuIkXNTpz
	 byn7E7NNJE6PN7QgcNSBlOoTJnGuDCKsaWvQmp2q0XG6BWNgShGzdGInETRCLrNHb1
	 +U4xMxncX6qd+thPahYsHyhKwcxKn4YVOeP70K2hgg1PysPiRrMtZBV51DaTY947gf
	 BJibYybX0GWKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/5] KVM: arm64: nv: Respect read-only PFN when
 mapping L1 VNCR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260618234207.1063941-2-oupton@kernel.org>
References: <20260618234207.1063941-1-oupton@kernel.org>
 <20260618234207.1063941-2-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 19 Jun 2026 00:07:03 +0000
Message-Id: <20260619000703.89F731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] KVM injects an External Abort instead of a Permission Fault when a=
 guest accesses a read-only memslot via VNCR with guest stage-1 write prote=
ctions.
--

commit be3537f8a87d3f507b2b54b34084b37b1630155a
Author: Oliver Upton <oupton@kernel.org>
KVM: arm64: nv: Respect read-only PFN when mapping L1 VNCR

This commit updates KVM to cache the writability of the PFN in the VNCR
TLB to constrain the resulting fixmap permissions. It also promotes VNCR
permission faults to a Synchronous External Abort (SEA) when the guest
attempts to write to a read-only endpoint.

Link: https://lore.kernel.org/kvm/20260608082603.16AEC1F00893@smtp.kernel.o=
rg/

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 3a5571c3c1142..903ccabca78c5 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -1401,7 +1402,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu=
, bool *is_gmem)
>  	if (!*is_gmem) {
>  		pfn =3D __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
>  					&writable, &page);
> -		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
> +		if (is_error_noslot_pfn(pfn))
>  			return -EFAULT;

[Severity: High]
This is a pre-existing issue, but does this leak host memory configuration
to the guest by incorrectly prioritizing an External Abort over a Permission
Fault?

When a guest takes a VNCR write fault, this code unconditionally requests
FOLL_WRITE from __kvm_faultin_pfn() without checking if the guest's
stage-1 page tables actually permit writes (vt->wr.pw).

If the backing host memslot is read-only, __kvm_faultin_pfn() fails and KVM
returns -EFAULT, which ultimately causes KVM to inject a guest External Abo=
rt
(ESR_ELx_FSC_EXTABT). Architecturally, if the guest's stage-1 translation
lacks write permission, the guest should receive a Stage-1 Permission Fault
regardless of the host's physical memory permissions.

Could this cause unexpected guest panics if the guest OS relies on handling
Permission Faults gracefully before the host RO mapping is enforced?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618234207.1063=
941-1-oupton@kernel.org?part=3D1
