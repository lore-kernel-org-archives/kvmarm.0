Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85432308F26
	for <kvmarm@lists.linux.dev>; Wed, 24 Jun 2026 20:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782333318; cv=none; b=pMYL8M/2+foN1aNwGq06YAAjB42ydGTnJeps68+GhuSTBqXqByns9q/OoMECbm0lLaHNH9xvuo+cMp8XI7DOp/fMCZkf/69TRCUqcNCxad/Z4PJnp0iQYVa/zmzTM0nNrKrnD9I/BVv9HMaqXqFjVp2X0AGvLv0LMlndfn9y27s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782333318; c=relaxed/simple;
	bh=p06OfYEtPd3YWxPgj9Jnpcuy5zYT3rz7Q1mboYyQiDA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jcTerZkUWhl6/Am/UgG67DEUPfN487WTpbIkvZ9sgk0A/27euf+n5ALvPKisXAUuPQo2VcdI9r4XQHN7EXgmGBGkJ7dMZDsQIgv1ZbQsLmlISTUgWXPl8JbWysUtxBKkt+ivkbGxkbl2nFkw0SwBwPv6XRiFogoi/StACPshXW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i2v9zdch; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2v9zdch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76241F000E9;
	Wed, 24 Jun 2026 20:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782333317;
	bh=GWVi3Yqq/k1aNe8W5Ic/tPE9YK8bhz3dMm8nc5yEewY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i2v9zdchar1j6usElIz/IwwzN5syqn7dg2va8o140mnHNTNYyNx1B432QbtsJXDYx
	 BkKY5wlJCxLyxEpH/R6GTPdZhbIzkC2rNHeoeoDTJtFXp/CGvDOSi1DbW7Rj/72JXO
	 hE6y0coaATdlgalUNkYL7Hx+PcH+Ybl3uOED7yxAvGvuukWa9OFeKMAY2f2orW0zKS
	 ckgjqHExJ/3NkR0iolz59PwXY8yvqUa6m2cviPgm6F15jFxNaIq2lFnCqTV0OwhX+M
	 LDDY8rlOU9G/jV6vDK0WCBBfgtj23yyfg5Dnv1LQMQYLlNi2c6M5ySmGVgDBGoIHzb
	 Fxp8Uo0387ASg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: nv: Treat S1PTW permission faults
 specially
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260624202446.1698535-3-oupton@kernel.org>
References: <20260624202446.1698535-1-oupton@kernel.org>
 <20260624202446.1698535-3-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 20:35:16 +0000
Message-Id: <20260624203516.E76241F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] An L1 hypervisor can cause an infinite page fault loop in the L0 h=
ypervisor by creating an L1 S2 PTE with XN=3D0 (execution allowed) but AP=
=3D00 (read/write denied). L0 fails to forward the resulting instruction ab=
ort to L1, repeatedly mapping the shadow PTE without read permissions, whic=
h the hardware continually rejects as non-executable.
--

commit f64f1ef4967d6c0954790535ee60d6e909805163
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: nv: Treat S1PTW permission faults specially

Permission faults reported as instruction aborts with S1PTW set are due
to missing read/write permissions for the table walk, not execute
permissions on the output of translation. This patch adds logic to evaluate
both and forward the fault to the L1 hypervisor if either fails.

Closes: https://lore.kernel.org/kvmarm/20260623190607.7106B1F000E9@smtp.ker=
nel.org/

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 94df26de6990c..4c9123cb2e1c5 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -918,14 +919,27 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,=
 struct kvm_s2_trans *trans)
>  	if (!kvm_vcpu_trap_is_permission_fault(vcpu))
>  		return 0;
> =20
> -	if (kvm_vcpu_trap_is_iabt(vcpu)) {
> +	/*
> +	 * S1PTW permission faults do not provide sufficient syndrome informati=
on
> +	 * to determine if the fault was for read or write permissions. Perform=
 a
> +	 * read permission check and an optional write permission check, relying
> +	 * on the fact that:
> +	 *
> +	 *  - The table walker at minimum requires read permission
> +	 *
> +	 *  - The L1 hypervisor also needs to deal with the architecture and
> +	 *    cannot directly infer the failing permission from the fault conte=
xt
> +	 */
> +	if (kvm_vcpu_abt_iss1tw(vcpu)) {
> +		forward_fault =3D !trans->readable;
> +		if (write_fault)
> +			forward_fault |=3D !trans->writable;
> +	} else if (kvm_vcpu_trap_is_iabt(vcpu)) {
>  		if (vcpu_mode_priv(vcpu))
>  			forward_fault =3D !kvm_s2_trans_exec_el1(vcpu->kvm, trans);
>  		else
>  			forward_fault =3D !kvm_s2_trans_exec_el0(vcpu->kvm, trans);

[Severity: High]
This is a pre-existing issue, but does this logic miss a read-permission
dependency check for normal instruction aborts?

If an L1 hypervisor maps a page for L2 with Stage-2 PTE AP=3D00 (no read/wr=
ite)
and XN=3D0 (executable), and L2 attempts to fetch an instruction, the hardw=
are
generates a Stage-2 Instruction Abort (Permission Fault) because execution
requires read permission.

Here, kvm_s2_handle_perm_fault() intercepts the IABT and checks only the XN
bits via kvm_s2_trans_exec_el1() and kvm_s2_trans_exec_el0(). Since they
only check the XN bits and ignore trans->readable, forward_fault is set to
false.

L0 then handles the fault by mapping the shadow S2 PTE. The shadow fault
handler will clear the read protection bit, leaving the execute protection
bit intact. The hardware will reject this shadow mapping as non-executable
due to missing read permissions, triggering another IABT upon guest
resumption and causing an infinite page fault loop in the L0 hypervisor.

>  	} else {
> -		bool write_fault =3D kvm_is_write_fault(vcpu);
> -
>  		forward_fault =3D ((write_fault && !trans->writable) ||
>  				 (!write_fault && !trans->readable));
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624202446.1698=
535-1-oupton@kernel.org?part=3D2
