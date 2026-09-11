Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6084F3793A5
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 11:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789124514; cv=none; b=QjCj6jz2fcDCmyJmh8ieYA0hRdyFlu5Glm9WgI8aGn4+pUO3Oe5hOqzd0p48MPe/mRQ6CunWzsHKk6oS/HQzdZBVI7SL7XyZbmcr8P3HOEM5yncHIJTPqdg6vC9AbssnHvW7OX6UIMgCu0rlevXAqgkEiGtJvLeWfXaWF5nMAEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789124514; c=relaxed/simple;
	bh=YuS0qmX9vYecbgEF78up39VM7x+3pZf5BvXtWuPZhOA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MW1UkMaUKmQ0XpTGbW6FjiZMfeEAZ83WzMdv1QzY17lYx2mLhzVjlo6mtdYfD1a3AdQWkac9bAYctj2UhwwRgv3yrD2Jpv9pbv0kzruSJm96Nqxbw0JLHzvcRxN1tRi5/XOjkst4SLQ257mVKetcUG8qAeGW54WYIxndLsYl8/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CxpOE/Lz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CxpOE/Lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D086C1F000FF;
	Fri, 11 Sep 2026 11:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789124513;
	bh=p8wdyj/n/LK7ITRNLkMJmbUpfkQAobDrPys1dkNN5SE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CxpOE/LznLVwU+lFe000mRQtB087Q51s06Sq6duIFJDLMEgh1n1Qi5XO/XceSuB7l
	 hNfjGSSU+nmP4RsKSpN94al18bf+2anBX6RyOX200OM3J9Nu2wipddPzVmWfL3Svht
	 es7Xm2kbP5Nwv5pFK3KPbwzpJbZ56JX0Mr0ST1WgrViY6D8NDx0tRWciTvQ7orN7yS
	 LyMXaTR8tifgMabQEnBdbbjC6Q4QzW3OwG9pJK2y6g5FTqLdyFhELMs6/LvY1kPk7Z
	 RxbdbOrYtbxYUA2IxIwfSCBFFLId3HPr2YL7sBWDqM7x5xivCG03CwpOavD5VD5eco
	 91Qhy6h0ON7/Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Trap guest MPAM accesses whenever MPAM
 is implemented
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260911104715.307500-1-fuad.tabba@linux.dev>
References: <20260911104715.307500-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 11:01:52 +0000
Message-Id: <20260911110152.D086C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] KVM fails to trap guest MPAM accesses if the host boots with the `=
arm64.nompam` kernel parameter on MPAM-capable hardware, potentially allowi=
ng the guest to bypass virtualization isolation.
--

commit b4685c49d4f8e9f9eb2e612a24ecf71fcf533869
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented

This commit changes how KVM determines whether to trap guest MPAM accesses.
It relies on a per-CPU flag set based on the ID registers rather than using
the system-wide system_supports_mpam() check.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90b..fde75a63cf045 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2281,9 +2281,16 @@ static void cpu_set_hyp_vector(void)
> =20
>  static void cpu_hyp_init_context(void)
>  {
> +	u64 pfr0 =3D __read_sysreg_by_encoding(SYS_ID_AA64PFR0_EL1);
> +	u64 pfr1 =3D __read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1);
> +

[Severity: High]
This is a pre-existing issue, but does reading the software-overridden ID
register value here in cpu_hyp_init_context() allow the arm64.nompam kernel
parameter to falsely report no MPAM hardware to the KVM trap initialization
logic?

By using __read_sysreg_by_encoding(), the software override for arm64.nompam
forces the MPAM fields to 0. This causes the HAS_MPAM flag to evaluate to
false even when physical MPAM hardware is present.

>  	kvm_init_host_cpu_context(host_data_ptr(host_ctxt));
>  	kvm_init_host_debug_data();
> =20
> +	/* The traps take effect without MPAMEN, which ARM64_MPAM requires. */
> +	if (id_aa64pfr0_mpam(pfr0) || id_aa64pfr1_mpamfrac(pfr1))
> +		host_data_set_flag(HAS_MPAM);
> =20
>  	if (!is_kernel_in_hyp_mode())
>  		cpu_init_hyp_mode();

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index 1ce7130e25490..2cb611e2bd69b 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -298,14 +298,17 @@ static inline void  __activate_traps_mpam(struct kv=
m_vcpu *vcpu)
>  	u64 clr =3D MPAM2_EL2_EnMPAMSM;
>  	u64 set =3D MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
> =20
> -	if (!system_supports_mpam())
> +	if (!host_data_test_flag(HAS_MPAM))
>  		return;

[Severity: High]
This isn't a bug introduced by this patch, but does skipping the guest MPAM
trap activation in __activate_traps_mpam() based on the overridden HAS_MPAM
flag leave the hardware trap state at its UNKNOWN reset value?

When the host boots with the arm64.nompam parameter, HAS_MPAM is false. This
causes KVM to skip setting the MPAM2_EL2 trap bits (TRAPMPAM0EL1 and
TRAPMPAM1EL1) during guest entry. Additionally, the EL2 initialization in
finalise_el2_state() also skips initializing MPAM2_EL2 when the ID registers
are overridden.

Because MPAM2_EL2 is never initialized by the host, it retains its
architecturally UNKNOWN reset value. If its trap bits happen to reset to 0,
a guest can execute MPAM instructions without trapping to KVM. This would
allow the guest to bypass virtualization isolation and directly manipulate
memory bandwidth and cache partitioning across the system, potentially
causing resource starvation or side-channel information leaks.

Does this patch codify and reinforce gating the trap initialization on the
overridden software ID registers rather than the physical hardware
capabilities?

> =20
>  	/* trap guest access to MPAMIDR_EL1 */
> -	if (system_supports_mpam_hcr()) {
> +	if (read_sysreg_s(SYS_MPAMIDR_EL1) & MPAMIDR_EL1_HAS_HCR) {
>  		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911104715.3075=
00-1-fuad.tabba@linux.dev?part=3D1
