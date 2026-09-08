Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8720E58FD1A;
	Tue,  8 Sep 2026 17:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788886828; cv=none; b=Q+yQkJFfNqW9IDC7FX3rWGzAXWMxwz9i6E9kNVR64dbXaAv7UdW3rg5gEzHPJN+wdri/D6I7XeZxET1Y5nOFKZgvuw/bOfbZCjR1yJrCk9hplwvOfi2SWkrD0hgEiVgWbbIJ1RFJbPoPzeX61I1jhyFMf7oQyzYP7PxAkdQhPiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788886828; c=relaxed/simple;
	bh=AfQ76jzVZcSQK+CgTCfGHcT2hJykkArR/lz2IXrizCA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BRCeO7vHEx36fHH7LuYVaAoOtup7oj+lgZqfX5eGV4/j3K9PZNhwZ320ocNWi46sxsQGfC+YzqyRP476dHAxUH2erArNfK1n6Uo3k2jN556fpCYL+uQFv8X08lhCz3nmEtEwlWM4oYrTKUbMcPQoyPtVc2B6jpxN9dZgK1V0+gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITX0Vjza; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITX0Vjza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47BF1F00A3A;
	Tue,  8 Sep 2026 17:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788886827;
	bh=R3aUTAgcOgCxXBqx4Z/ixILWAA5GisGK5hEdionsHJc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ITX0VjzauQyaZeOH0LGNeZa5CJX95GzSbcFvhNCCsdk9F/JayU4L8BwP8Y897+wJR
	 fhijY0qHxa4wyGyHFwhJlMFR4KzERmWxt+BRhw4DGGBePdODwl+SpgQ6nIRN1m1WMe
	 YKvR+EzoiWHWcYs0IQDUMDh7s6eUqB0dWYItxkxU0RD2jFl7zxJJ/SvqQDvK/GpiHn
	 qe1C0YzMh+UQi2S2IvEX5Mpx5vnNR+PdcuQQpfcg28RFPQz8LrYcsgCCXJ4pc0qdKG
	 Ywe1U+4/2Vg3gjANp708wXROLmR5zb3/qFBiU8h94tk0h2qa9NBlXSsUGC0xarOyc2
	 4woPSQykKNEmw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 17/20] KVM: arm64: CCA: Provide an accurate register
 list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260908162223.1683432-18-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-18-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 17:00:25 +0000
Message-Id: <20260908170026.B47BF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] KVM_GET_REG_LIST fails to restrict core registers to the 9 GP re=
gisters for Realm VMs, exposing all core registers instead.
- [Medium] Realm VM system register restrictions are only applied to KVM_GE=
T_REG_LIST, allowing userspace to bypass them via KVM_SET_ONE_REG and KVM_G=
ET_ONE_REG.
--

commit 1a82d37b0064cc3f1fa34c6757432fa355d160a3
Author: Jean-Philippe Brucker <jpb@kernel.org>

KVM: arm64: CCA: Provide an accurate register list
   =20
Userspace can set a few registers with KVM_SET_ONE_REG (9 GP registers
at runtime, and 3 system registers during initialization). Update the
register list returned by KVM_GET_REG_LIST.

> Userspace can set a few registers with KVM_SET_ONE_REG (9 GP registers
> at runtime, and 3 system registers during initialization). Update the
> register list returned by KVM_GET_REG_LIST.

[Severity: Medium]
Does KVM_GET_REG_LIST successfully restrict core registers to just the 9 GP
registers for Realm VMs?

Looking at copy_core_reg_indices(), it loops over the entire kvm_regs array
without checking vcpu_is_rec(vcpu):

arch/arm64/kvm/guest.c:copy_core_reg_indices() {
	for (i =3D 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
		u64 reg =3D KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
		int size =3D core_reg_size_from_offset(vcpu, i);

		if (size < 0)
			continue;
        ...
}

This appears to expose all core registers to the userspace array rather than
limiting it to the 9 GP registers mentioned in the commit message.

[ ... ]

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 44aae52c473d7..a58c1fc13ea17 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c

[ ... ]

> @@ -5693,11 +5693,26 @@ static bool copy_reg_to_user(const struct sys_reg=
_desc *reg, u64 __user **uind)
>  	return true;
>  }
> =20
> +static inline bool kvm_realm_sys_reg_hidden_user(const struct kvm_vcpu *=
vcpu,
> +						 u64 reg)
> +{
> +	switch (reg) {
> +	case SYS_ID_AA64DFR0_EL1:
> +	case SYS_PMCR_EL0:
> +		return false;
> +	}
> +	return true;
> +}
> +
>  static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
>  			    const struct sys_reg_desc *rd,
>  			    u64 __user **uind,
>  			    unsigned int *total)
>  {
> +	if (vcpu_is_rec(vcpu) &&
> +	    kvm_realm_sys_reg_hidden_user(vcpu, reg_to_encoding(rd)))
> +		return 0;
> +

[Severity: Medium]
Are the Realm system register restrictions bypassed by KVM_SET_ONE_REG and
KVM_GET_ONE_REG?

While this patch correctly hides the registers from KVM_GET_REG_LIST by
checking kvm_realm_sys_reg_hidden_user() in walk_one_sys_reg(), it doesn't
appear to add a similar check to the ioctl handlers for setting or getting
individual registers.

For example, in kvm_sys_reg_set_user(), the code only checks sysreg_hidden(=
):

arch/arm64/kvm/sys_regs.c:kvm_sys_reg_set_user() {
    ...
	r =3D id_to_sys_reg_desc(vcpu, id, table, num);
	if (!r || sysreg_hidden(vcpu, r))
		return -ENOENT;
    ...
}

The getter similarly fails to enforce the Realm system register restriction=
s.
Does this allow userspace to directly read or overwrite hidden system
registers on a Realm VM if they know the register ID, bypassing the CCA
register protection boundary?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908162223.1683=
432-1-suzuki.poulose@arm.com?part=3D17
