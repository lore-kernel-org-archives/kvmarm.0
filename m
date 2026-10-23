Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792790740;
	b=V9cf4/uXTz8ytmKDXXYhR7jQAWUynqQUZQXsbrbZewOPn93qvE868bi2fo7/1V/7jGlB
	 eK6c0rzUyWzOpaHDsAWrLEfl8VcfMSJ6PaC9lHEHpCwKl1wLBYyiY53ivCFZNHA5AC7ib
	 khp7LohoR6ADOipq6kvSmzryNT+wzK09/LHbZqfjRONvwbTcpRnSUSHpABHDJjxm+U/Sn
	 K91gJfEe9E0odVJZx3iJzA3y1XgqWd8+sB6O+w257534083r3c9Q3fKecqnjEKbmAUjB3
	 wxFDOqDtJ81GW0TqTciNOW/XtsAn6T2D8JaxkhtMLJtSq0SbGEbBKUAjPiVEOPsus5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792790740;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yVjrVPypZUVPeIvD2h8j1MvS9E1GRGh6nM+Q9+RArOk=;
	b=hSV4PnBJJNw5wDU5FNGm7N9PyYjaCCn3N4oTX2exclBjv5S31qOuh+JVliwCYO8H9jM+
	 t46iEH2hfY0G4XWlxh0jbpAgcmrg9o5YHfgoNnxy6gA5i+xAKLgzVYQQh5yuHPQOnb9dB
	 HWUYCKHnilxNW7UuAMHRrLU3JAg8AZy92SEf2n3t+2stQ0IFl9SG7xMl8VIiGKr3BL12C
	 ebpCoU+KuJfycMde8louUinvzr9mr8dWN+F+G1EXFTVdEICRV424sSlACRMD24GWNUTox
	 UD3E0GwoC7nUQhy1mFFaLgPcwdEIteoqdWuEGceL+4wF7kl77XT5T2UQcIl7gVqnphg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R7syQOkJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31441606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 21:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R7syQOkJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA911F01825;
	Fri, 23 Oct 2026 21:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792790739;
	bh=yVjrVPypZUVPeIvD2h8j1MvS9E1GRGh6nM+Q9+RArOk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R7syQOkJHLEoEKpYS2ocEZibCncx+Pqrsm74UUbLuxH2Pggs26DutiDxS4QHBiR20
	 /7boaRMTDIRflxQG4DHbv1vR695EtvWXk9qTOsEa4uYgTJ6JQmQy0Fu6CSJKBEwVdY
	 6JwGHwrc6dOGZTLLJv7u5asdusqHwpmK8vklppyO1ptU2FKYh8lsuKzN7WNydTY4Xv
	 tB5cWGaJGLuHX3G2+rj4EzGM1cf4uKW2/5ReK2WJFnHQ0wgvwAJqHW90g9DY0DjKnZ
	 olMnajCxSj5d9SyFykUWmQmCkhXqkmpQrfSid+tmO2BMeHd0BCQgM5Rc6J0LFFNzlB
	 vN6Dmew56KCeQ==
Message-ID: <sashiko-outbox-183253@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/28] KVM: arm64: nv: Only shadow writable-dirty
 guest descs as writable
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
Cc: "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261023205610.1044532-5-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
 <20261023205610.1044532-5-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 21:25:39 +0000
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
- [Medium] KVM: arm64: nv: missing wr.dirty check in handle_vncr_perm()
--

commit cfa39628f154da2407f90720dcc9a53017a25a78
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: nv: Only shadow writable-dirty guest descs as writable

This commit restricts shadow stage-2 and shadow VNCR translations to
read-only for writable-clean guest descriptors in preparation for emulating
hardware dirty state management for nested guests.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 15c22a2186095..9b2ea83aeccd2 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c

[ ... ]

> @@ -1587,6 +1589,11 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
>  	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
>  }
> =20
> +static bool vncr_can_map_writable(struct vncr_tlb *vt)
> +{
> +	return vt->wr.pw && vt->wr.dirty && vt->hpa_writable;
> +}
> +
>  static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>  {
>  	struct kvm_memory_slot *memslot;

[ ... ]

> @@ -1781,7 +1788,7 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
>  		kvm_inject_nested_sync(vcpu, esr);
>  		break;
>  	case 0:
> -		perm =3D kvm_is_write_fault(vcpu) ? vt->wr.pw && vt->hpa_writable : vt=
->wr.pr;
> +		perm =3D kvm_is_write_fault(vcpu) ? vncr_can_map_writable(vt) : vt->wr=
.pr;
>  		if (!perm)
>  			handle_vncr_perm(vcpu);
>  		break;

[Severity: Medium]
Does handle_vncr_perm() in arch/arm64/kvm/nested.c also need to check
vt->wr.dirty when deciding whether to promote a write fault to an external
abort?

With FEAT_S1PIE enabled at guest EL2, compute_s1_indirect_permissions()
computes vt->wr.pw =3D true from PIR_EL2 and the descriptor's permission in=
dex
independently of BIT(7), while compute_s1_permissions() sets vt->wr.dirty =
=3D
false when BIT(7) is set on a writable-clean stage-1 descriptor.

When a nested guest takes a VNCR write fault on such a writable-clean
descriptor backed by a read-only memslot or HPA (!vt->hpa_writable),
kvm_handle_vncr_abort() sees !vncr_can_map_writable(vt) and calls
handle_vncr_perm():

arch/arm64/kvm/nested.c:handle_vncr_perm() {
	...
	if (kvm_is_write_fault(vcpu) && vt->wr.pw && !vt->hpa_writable)
		fsc =3D ESR_ELx_FSC_EXTABT;
	/*
	 * Otherwise, inject a permission fault using the guest's translation
	 * level rather than the host's.
	 */
	else
		fsc =3D ESR_ELx_FSC_PERM_L(vt->wr.level);
	...
}

Because handle_vncr_perm() only checks vt->wr.pw && !vt->hpa_writable
without checking vt->wr.dirty, won't it inject ESR_ELx_FSC_EXTABT instead of
the architectural stage-1 permission fault ESR_ELx_FSC_PERM_L(vt->wr.level)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023205610.1044=
532-1-oupton@kernel.org?part=3D4
