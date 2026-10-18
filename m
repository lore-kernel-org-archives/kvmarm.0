Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1987633E345
	for <kvmarm@lists.linux.dev>; Sun, 18 Oct 2026 08:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792312164; cv=none; b=ERJElsdxrCRWlYFLcWKiplmqLcP734oDq0jeyNRqETLp1ZVlzRx1YvWhQpDf6Gxrr4tf3z4pV4+8ofJp9p+r6P/BGk131ZYRTmAAkZgvWXIuXxw8+ox2EuZP5DoW3+yIxZA68EJrbjEccEN/0MYfUW5diW2HldHE5HaRdkDd4GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792312164; c=relaxed/simple;
	bh=6UvPHw9tynirR1x0a57YAlFhbsjhXTROvoGJiSxDXTI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=cYipWydghobz6fKTu3Pmw3ZaK1sUXkRG3wmDEudFNiJdw4jP/zAEWzb44Zj97njSBmhTTVO8DzG3l+wMwWWfIxo+Qro84uGI+NpWYuMI2jBDD4f8YZMYPVdKj46rI/RyAL4RapqfstXVfS5Fc1pDPD8mYHV3czgGbnjfVmwxQ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDRieEvJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDRieEvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09BB1F000C4;
	Sun, 18 Oct 2026 08:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792312162;
	bh=xt4ZUfOHNAt7AHDXqlWb+Bg3PDSf+xhzRzMS04jzzcA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EDRieEvJhiXkt9mcAZNgFjkK7qP5o/NPwp04jFq1aKDUf3D3aEdSbzPafj6+jQfo/
	 k6zYXb9f6EWJKE0NdfjoG5fASfMs9nO+bwXbuTueSS62CUBCqPLx3y0vWDpQLeAmMS
	 TYbkhPJ/Zg61qQyFhV28l4GQ7sX+Tm3fWr56aWDEIO9wmEBNW1WOen2aX+6HHeLfui
	 fG1CURTCIfxwkRu4on7+kfh+r2pzCRAunKGB/ru4oesyK8YlYsFsr3t6/GM0Ed+SGs
	 ja6+e7Rt9WYm6n0KT0QVndjJnvzX6qEP8QjUjSSzpPBKyDORX7A1n/+Fuw+5PHkilQ
	 /mQCl9tgILS/w==
Message-ID: <sashiko-outbox-176009@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Only enable S1PIE and S1POE with the
 features they imply
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261018080921.3942517-1-fuad.tabba@linux.dev>
References: <20261018080921.3942517-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 18 Oct 2026 08:29:22 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] KVM: arm64: incomplete S1PIE/S1POE implied-feature checks in kvm_h=
as_s1p*()
--

commit 1d4d0fe97a6aa6ec7a4e6a93ff7c048e9f3bf806
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Only enable S1PIE and S1POE with the features they imply

This commit restricts the fine-grained trap enablement of S1PIE and S1POE
registers in hfgrtr_feat_map and hfgwtr_feat_map to guests that also have
the architecturally implied features (TCR2 and ATS1A, plus HPDS for S1POE).

Link: https://lore.kernel.org/r/20260930-arm64-gcs-v21-2-3556644cd927@kerne=
l.org
Link: https://lore.kernel.org/r/86fqyn2che.wl-maz@kernel.org

> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index e93919cadf860..5cb2b759b68d6 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -205,6 +205,7 @@ struct reg_feat_map_desc {
>  #define FEAT_MEC		ID_AA64MMFR3_EL1, MEC, IMP
>  #define FEAT_HAFT		ID_AA64MMFR1_EL1, HAFDBS, HAFT
>  #define FEAT_HDBSS		ID_AA64MMFR1_EL1, HAFDBS, HDBSS
> +#define FEAT_HPDS		ID_AA64MMFR1_EL1, HPDS, IMP
>  #define FEAT_HPDS2		ID_AA64MMFR1_EL1, HPDS, HPDS2
>  #define FEAT_BTI		ID_AA64PFR1_EL1, BT, IMP
>  #define FEAT_ExS		ID_AA64MMFR0_EL1, EXS, IMP
> @@ -280,6 +281,25 @@ static bool feat_anerr(struct kvm *kvm)
>  		kvm_has_feat(kvm, ID_AA64MMFR3_EL1, SNERR, FEAT_ANERR));
>  }
> =20
> +/*
> + * S1PIE and S1POE imply TCR2 and ATS1A, and S1POE also implies HPDS, but
> + * userspace can set them independently.
> + */
> +static bool feat_s1pie(struct kvm *kvm)
> +{
> +	return (kvm_has_feat(kvm, FEAT_S1PIE) &&
> +		kvm_has_feat(kvm, FEAT_TCR2) &&
> +		kvm_has_feat(kvm, FEAT_ATS1A));
> +}
> +
> +static bool feat_s1poe(struct kvm *kvm)
> +{
> +	return (kvm_has_feat(kvm, FEAT_S1POE) &&
> +		kvm_has_feat(kvm, FEAT_TCR2) &&
> +		kvm_has_feat(kvm, FEAT_ATS1A) &&
> +		kvm_has_feat(kvm, FEAT_HPDS));
> +}
> +

[Severity: High]
Should these implied-feature checks also be folded into kvm_has_s1pie() and
kvm_has_s1poe() in arch/arm64/include/asm/kvm_host.h, as well as the other
S1PIE and S1POE checks in KVM?

Right now, feat_s1pie() and feat_s1poe() are only wired into
hfgrtr_feat_map[] and hfgwtr_feat_map[], which populate
kvm->arch.fgu[HFGRTR_GROUP] for the EL1/EL0 registers, while
kvm_has_s1pie() and kvm_has_s1poe() still only check ID_AA64MMFR3_EL1:

arch/arm64/include/asm/kvm_host.h:
    #define kvm_has_s1pie(k)				\
    	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))

    #define kvm_has_s1poe(k)				\
    	(system_supports_poe() &&			\
    	 kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))

In a nested virtualization guest running at vEL2 when TCR2 is hidden,
accesses to PIR_EL2, PIRE0_EL2, and POR_EL2 trap via HCR_EL2.NV rather than
fine-grained traps. Because encoding_to_fgt[] in triage_sysreg_trap() only
maps the EL1/EL0 encodings, kvm_handle_sys_reg() -> perform_access() falls
back to sysreg_hidden() -> s1pie_el2_visibility() / s1poe_el2_visibility():

arch/arm64/kvm/sys_regs.c:
    static unsigned int s1poe_visibility(const struct kvm_vcpu *vcpu,
    				     const struct sys_reg_desc *rd)
    {
    	if (kvm_has_s1poe(vcpu->kvm))
    		return 0;

    	return REG_HIDDEN;
    }

Because kvm_has_s1pie() and kvm_has_s1poe() return true even when TCR2 is
hidden, perform_access() does not inject an UNDEF. Instead, on VHE,
access_rw() -> vcpu_read_sys_reg() / vcpu_write_sys_reg() ->
locate_register() maps PIR_EL2, PIRE0_EL2, and POR_EL2 to the hardware
SYS_PIR_EL12, SYS_PIRE0_EL12, and SYS_POR_EL12 registers. However,
__sysreg_save_vel2_state() and __sysreg_restore_vel2_state() in
arch/arm64/kvm/hyp/vhe/sysreg-sr.c skip saving and restoring them when
!ctxt_has_tcrx():

    if (ctxt_has_tcrx(&vcpu->arch.ctxt)) {
    	__vcpu_assign_sys_reg(vcpu, TCR2_EL2, read_sysreg_el1(SYS_TCR2));

    	if (ctxt_has_s1pie(&vcpu->arch.ctxt)) {
    		__vcpu_assign_sys_reg(vcpu, PIRE0_EL2, read_sysreg_el1(SYS_PIRE0));
    		__vcpu_assign_sys_reg(vcpu, PIR_EL2, read_sysreg_el1(SYS_PIR));
    	}

    	if (ctxt_has_s1poe(&vcpu->arch.ctxt))
    		__vcpu_assign_sys_reg(vcpu, POR_EL2, read_sysreg_el1(SYS_POR));
    }

Won't a nested guest with S1PIE or S1POE and without TCR2 still leak and
corrupt the physical PIR_EL1, PIRE0_EL1, and POR_EL1 registers across
guests on VHE via PIR_EL2, PIRE0_EL2, and POR_EL2?

Similarly, if userspace enables TCR2 alongside S1PIE or S1POE while hiding
ATS1A or HPDS, leaving kvm_has_s1pie() and kvm_has_s1poe() unchanged means:

- s1pie_visibility() and s1poe_visibility() keep the registers visible to
  userspace and vEL2, and ctxt_has_s1pie() / ctxt_has_s1poe() still context
  switch them.
- s1pie_enabled() and compute_s1poe() in arch/arm64/kvm/at.c still treat
  S1PIE and S1POE as enabled during software AT walks.
- tcr2_el2_feat_map[] in arch/arm64/kvm/config.c still uses FEAT_S1POE and
  FEAT_S1PIE for TCR2_EL2_POE | TCR2_EL2_E0POE and TCR2_EL2_PIE instead of
  feat_s1poe and feat_s1pie.
- __activate_cptr_traps_vhe() in arch/arm64/kvm/hyp/include/hyp/switch.h
  still checks raw kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1POE, IMP)
  when propagating CPACR_EL1_E0POE.

>  static bool feat_sme_smps(struct kvm *kvm)
>  {
>  	/*
> @@ -393,10 +413,10 @@ static const struct reg_bits_to_feat_map hfgrtr_fea=
t_map[] =3D {
>  	NEEDS_FEAT(HFGRTR_EL2_nS2POR_EL1, FEAT_S2POE),
>  	NEEDS_FEAT(HFGRTR_EL2_nPOR_EL1		|
>  		   HFGRTR_EL2_nPOR_EL0,
> -		   FEAT_S1POE),
> +		   feat_s1poe),
>  	NEEDS_FEAT(HFGRTR_EL2_nPIR_EL1		|
>  		   HFGRTR_EL2_nPIRE0_EL1,
> -		   FEAT_S1PIE),
> +		   feat_s1pie),
>  	NEEDS_FEAT(HFGRTR_EL2_nRCWMASK_EL1, FEAT_THE),
>  	NEEDS_FEAT(HFGRTR_EL2_nTPIDR2_EL0	|
>  		   HFGRTR_EL2_nSMPRI_EL1,
> @@ -474,10 +494,10 @@ static const struct reg_bits_to_feat_map hfgwtr_fea=
t_map[] =3D {
>  	NEEDS_FEAT(HFGWTR_EL2_nS2POR_EL1, FEAT_S2POE),
>  	NEEDS_FEAT(HFGWTR_EL2_nPOR_EL1		|
>  		   HFGWTR_EL2_nPOR_EL0,
> -		   FEAT_S1POE),
> +		   feat_s1poe),
>  	NEEDS_FEAT(HFGWTR_EL2_nPIR_EL1		|
>  		   HFGWTR_EL2_nPIRE0_EL1,
> -		   FEAT_S1PIE),
> +		   feat_s1pie),
>  	NEEDS_FEAT(HFGWTR_EL2_nRCWMASK_EL1, FEAT_THE),
>  	NEEDS_FEAT(HFGWTR_EL2_nTPIDR2_EL0	|
>  		   HFGWTR_EL2_nSMPRI_EL1,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261018080921.3942=
517-1-fuad.tabba@linux.dev?part=3D1
