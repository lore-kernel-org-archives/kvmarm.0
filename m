Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D9B49EC4F
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 18:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788288190; cv=none; b=Q9G7J8iHLqk0PbwjVmdOsp6CmjASXQ35XS6Hj702HZcM5g93DCdMn1XKWL+6Sy+1gVjjqfZjJht/VYhvLGbAs7axWTkAk4jZACAGscvvs9bWb4tETVOcf8/LKFA4w1Z1FiAsitXII2d6IHQ05nMpfin+q9fhLy7T1DrZA6BLVtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788288190; c=relaxed/simple;
	bh=wLyA+30kW3tpfxnavozf+J8b/9AodFWdlEv30vNBwsg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CVeEqLTwnxC+obfJWELVOYN8feKQE7NFXReg7eRakpdsxmIO9YyfW8k8tQJNGgfBtHyY04+pwKEEfJY8OIfzLQCxN/z36DyDN23USuSoqV1q9w5QU9KLE3T5MKKAXJmFzPgWYnPm9kEWheiVaGrVH5vANYwzYBv1EkUYljpykiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tno+GlMa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tno+GlMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C9C1F00ACA;
	Tue,  1 Sep 2026 18:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788288189;
	bh=q2Z+dJWYelJ/Nxxk0DaI9+52KQA+DAo1JUWEtwl56h8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Tno+GlMaVNSX8v/TnBU+tF46rN2fv5Vd5eZEFn9ddaALRFOsK28w4e4SPA+UBh7MR
	 Futzn7wTzhbzXLCvz0dFda0my6XsB400ipSi5bcub7s3UfdnYh8KFbROZy+8GEv9bd
	 varuTHKx9gMj9FaAsIyq0dbsH02CypsDiiqqGxB+BhV3T1dy2xZACkkAjgP+XTnwBz
	 n0Kc439MRqCSjkbPMjBKs5fgB7Pm1T77f6AI7qCtR3J2UXKPFrBUdLkMgINpeBC0ti
	 i3BH5G1iblD1nbt0jTBcHnBKhKy3HsN7y8OwNcV6C7aAQHonXC4rjHH6+nQwKOYBUo
	 lyD1Xc8/siD+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/3] KVM: arm64: Finalize guest-wide sysregs prior to
 per-vCPU sysregs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260901-kvm-arm64-idreg-final-v3-1-a0ffa06fa872@kernel.org>
References: <20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org>
 <20260901-kvm-arm64-idreg-final-v3-1-a0ffa06fa872@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 18:43:08 +0000
Message-Id: <20260901184309.74C9C1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Iterating over `enum vcpu_sysreg` using a numeric range (`< NR_SYS=
_REGS`) treats the enum as a dense array, touching unintended unallocated g=
aps because VNCR-mapped entries have sparse numbering based on their byte o=
ffsets.
--

commit 54e02ec9a7efd1b5c5a028a29a9441e4c02c5f90
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Finalize guest-wide sysregs prior to per-vCPU sysregs

This commit splits the sysreg initialization into a guest-wide phase and a
per-vCPU phase. It runs the guest-wide setup earlier to prevent mismatches
between ID registers updated by vGIC finalization and the per-vCPU NV
register sanitization.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c

[ ... ]

> +/*
> + * Because this can be called once per CPU, changes must be idempotent.
> + */
> +int kvm_vcpu_finalize_sys_regs(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm =3D vcpu->kvm;
> +	int ret;
> +
> +	guard(mutex)(&kvm->arch.config_lock);
> +
> +	ret =3D kvm_vm_finalize_sys_regs(kvm);
> +	if (ret)
> +		return ret;
> +
> +	if (vcpu_has_nv(vcpu)) {
> +		ret =3D kvm_init_nv_sysregs(vcpu);

[Severity: High]
This isn't a bug introduced by this patch, but this is a pre-existing=20
issue in the kvm_init_nv_sysregs() function called here.

Does this loop in arch/arm64/kvm/nested.c:kvm_init_nv_sysregs() drop
guest state?

	for (enum vcpu_sysreg sr =3D __SANITISED_REG_START__; sr < NR_SYS_REGS; sr=
++)
		__vcpu_rmw_sys_reg(vcpu, sr, |=3D, 0);

The enum vcpu_sysreg maps VNCR entries using sparse byte offsets rather
than sequential integers. Iterating over it with a numeric range
comparison (< NR_SYS_REGS) covers unallocated gaps, which can silently
drop guest state and desynchronize the host's GET/SET_ONE_REG view when
a VM is configured with nested virtualization.

Could this loop be replaced with an explicit per-register allowlist?

> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-kvm-arm64-=
idreg-final-v3-0-a0ffa06fa872@kernel.org?part=3D1
