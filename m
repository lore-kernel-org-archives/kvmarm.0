Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C8E38237D;
	Thu, 30 Jul 2026 07:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785398192; cv=none; b=qU5lOPNFuXsqlkkHf4f/y8we0ljDHO47fcRXmsNLFpooq3Jn+VNTWJoq3FnUwI5/pRorbLXD8Btq9oXSacAcIyhe1MT5nV+ymL5xOVZNaPdAhGobx+Z0EVdSOEYH97xbMFHbU5WnCpGnNegMfjCtXykeCIzGKx1n6Y/u8OPy2ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785398192; c=relaxed/simple;
	bh=9FoyOW7yHv91bKQO6x05Lj+9TPSIr1RiUQ2DkEy0GqU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EPO7wC7EL4HDlNEuwwE6nivF03FphBGJ+YAgwZV2N3hw/O8QWgzh6U8RiQtbK3PR81edu+/iQf/C2HHfXUIhRdXbifp/vcZSyh883JZ0eXrCYOdkpG4M+aPNj6QidyzofYlaw8dHhH3TZl/c3cy0/vFhDnqoN+pduldf2fm/Vx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FmxOpNiA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FmxOpNiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4776F1F000E9;
	Thu, 30 Jul 2026 07:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785398190;
	bh=LnuZvqzBzLjXQC/qKZ7AP5i2XM+zxtzfpC6+zbwYhAU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FmxOpNiAEmZLHqZ8xJ58qpT5KUhC0+TLYCGMBwkJqBE8lNCMw6AdyMKJv0Cbp+wPy
	 Budme5gA7f4JlBImtdDe3X2kcCfbpyHy+Nljau/EEWtTz4dPyOP0xBA3358MjJQ6WY
	 qkKiTlS0KthcSXo9xdXJiwNKkgRizJh2CDUKxAKtAEQKM7OAB39wyYMal+lIlRQ4JI
	 dfiWC9iqiCprDWXE07KuNxUHpctzzYg9BCUuYRCrhEUrGK3hA40d4TXsr77EQjz86t
	 jNOHVIu8KjfA6d3lyF/ydkLlUK57qvGiduGL9ABhNpVIxuJHRloWhr4IjIr2IU23o/
	 267HJ75arwBVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 09/29] KVM: arm64: Relax CPTR_EL2 handling when
 FEAT_NV2p1 is present
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260730071022.296811-10-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
 <20260730071022.296811-10-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 07:56:29 +0000
Message-Id: <20260730075630.4776F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Userspace modifications to CPTR_EL2 via KVM_SET_ONE_REG are silent=
ly lost on systems with FEAT_NV2p1.
--

--- Patch [9]: [PATCH v4 09/29] KVM: arm64: Relax CPTR_EL2 handling when FE=
AT_NV2p1 is present ---
commit 0ba038cc87ef366635c1e40d5069280819355ee7
Author: Marc Zyngier <maz@kernel.org>
KVM: arm64: Relax CPTR_EL2 handling when FEAT_NV2p1 is present

This patch updates the handling of CPTR_EL2 accesses when FEAT_NV2P1 is
present, preventing trapping via CPACR_EL1 and directly context switching
CPACR_EL1 in NV contexts instead.

> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/=
sysreg-sr.c
> index be685b63e8cf2..6f0f046e4ca4e 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -42,10 +42,12 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu =
*vcpu)
>  		u64 val;
> =20
>  		/*
> -		 * We don't save CPTR_EL2, as accesses to CPACR_EL1
> -		 * are always trapped, ensuring that the in-memory
> -		 * copy is always up-to-date. A small blessing...
> +		 * Without FEAT_NV2p1, we don't save CPTR_EL2, as accesses
> +		 * to CPACR_EL1 are always trapped, ensuring that the
> +		 * in-memory copy is always up-to-date. A small blessing...
>  		 */
> +		if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +			__vcpu_assign_sys_reg(vcpu, CPTR_EL2, read_sysreg_el1(SYS_CPACR));

[Severity: High]
Will this silently overwrite userspace modifications to CPTR_EL2 during
vcpu_put()?

When userspace calls KVM_SET_ONE_REG for CPTR_EL2, the ioctl is wrapped in
vcpu_load() and vcpu_put(). vcpu_load() loads the old memory state into the
physical CPU.=20

Then, because CPTR_EL2 lacks a custom .set_user handler,
kvm_sys_reg_set_user() falls back to updating the in-memory array:

    if (r->set_user) {
        ret =3D (r->set_user)(vcpu, r, val);
    } else {
        __vcpu_assign_sys_reg(vcpu, r->reg, val);
        ret =3D 0;
    }

This updates the in-memory array, but not the physical hardware register.

When vcpu_put() is called, this newly added code in
__sysreg_save_vel2_state() reads the stale old value from the physical
hardware register and overwrites the newly set in-memory value, silently
destroying the userspace modification.

Could a custom .set_user handler be needed for CPTR_EL2 to ensure the
physical CPU register is updated when modified by userspace?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730071022.2968=
11-1-maz@kernel.org?part=3D9
