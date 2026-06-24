Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA7F371CE3
	for <kvmarm@lists.linux.dev>; Wed, 24 Jun 2026 20:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782333632; cv=none; b=h0Rhuv8l8uZrzFjzXWRCEIeBTax5NhD+i1BAqxWFmqohKkhgv0wo9RwB4v5/bQPWhgNnjwH8BVziuqA69w4zF1PM99M4jxvimChk5iwsUTH+VXVatcW5WX05kN6KwLaP+9EigUSMYNaW73P3Bzw/tycpBepYp7wZjVjPB7cKZ9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782333632; c=relaxed/simple;
	bh=4yGwMA1wLPSbucFGz3qdrU0sj86EDb608Rq8a//waDM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nv+PbYY6YRLXVyxM34icZKcx3gldXiS+3PL914CJqbpo5d13QETJD28HqwamF758r0SjP2LQWeSim6T3ccIIo99rqqJ5QAFYi01LZtK9Zil+kglLY7qmggfU8tAnPpLzo0hRPpLgl69WrieQNzSXHHh18lur/iftAuT5Lp12+gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jB5rfyEH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jB5rfyEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519861F000E9;
	Wed, 24 Jun 2026 20:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782333625;
	bh=dH0ptlw2so0ob7ytwTzy8cqMNN4NrE8c3whGTbyftjo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jB5rfyEHf4OdLhICa8bvgx8+lTBu21TUz+Q/sMSml10wkZ6HYZNckb5kaJpwHYAbr
	 QzD+qAdZq1K7gd/cciC8CTxoOANqupZYdpUlg57odkVpkTI5ziNwDafSWUJhUSuUGN
	 qamGSrJgPbQkUCZYiP4GTf6T6YBvo1hn9bvVuyN4MeH3K9AJlIBFUfUQizJlWv8hXF
	 oRLzkBbPbKD9XPUBmnmKStZDV+CbJo/AfMhgQbSKAFB+rcua9CQDTBzjBccTG0YHaL
	 kXk49ZwZ/kUyd2kd4x1QZNQ8DzEiD/OW3Y1jkmu3MzjxxBv1or+WirsmOv/Fjra63v
	 sVKM0NAkiUJ0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: Only consider S1PTW a write fault if
 HA is set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260624202446.1698535-2-oupton@kernel.org>
References: <20260624202446.1698535-1-oupton@kernel.org>
 <20260624202446.1698535-2-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 20:40:24 +0000
Message-Id: <20260624204025.519861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Unconditionally treating all S1PTW faults as write faults when HA=
=3D1 breaks pre-populated guest page tables in read-only memslots.
- [High] `effective_tcr_ha()` incorrectly evaluates the Hardware Access (HA=
) bit for unprivileged memory accesses (e.g., `LDTR`) at EL2, leading to po=
tential infinite fault loops.
--

commit 05ab0c07bd3e6099e1182b29afb0219565246eb7
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: Only consider S1PTW a write fault if HA is set

This commit works around the hardware not always setting the WnR bit for=20
stage-1 page table walk (S1PTW) faults. It introduces effective_tcr_ha()=20
to assume an S1PTW fault is a write if the Hardware Access (HA) flag is=20
enabled at stage-1.

Link: https://lore.kernel.org/kvmarm/20260623213225.A89CF1F000E9@smtp.kerne=
l.org/

> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/as=
m/kvm_emulate.h
> index 5bf3d7e1d92c7..8e208ce2597e5 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h

[ ... ]

> @@ -479,21 +479,13 @@ static __always_inline int kvm_vcpu_sys_get_rt(stru=
ct kvm_vcpu *vcpu)
> =20
>  static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_vcpu_abt_iss1tw(vcpu)) {
> -		/*
> -		 * Only a permission fault on a S1PTW should be
> -		 * considered as a write. Otherwise, page tables baked
> -		 * in a read-only memslot will result in an exception
> -		 * being delivered in the guest.
> -		 *
> -		 * The drawback is that we end-up faulting twice if the
> -		 * guest is using any of HW AF/DB: a translation fault
> -		 * to map the page containing the PT (read only at
> -		 * first), then a permission fault to allow the flags
> -		 * to be set.
> -		 */
> -		return kvm_vcpu_trap_is_permission_fault(vcpu);
> -	}
> +	/*
> +	 * The architecture sucks; assume that the S1PTW fetched for write if
> +	 * HA is enabled at stage-1. Note that hardware updates to dirty state
> +	 * and table AF are predicated on HA=3D1 (DDI0487 M.a D24.2.194; R_SNVT=
X).
> +	 */
> +	if (kvm_vcpu_abt_iss1tw(vcpu))
> +		return effective_tcr_ha(vcpu);

[Severity: High]
Does unconditionally treating S1PTW faults as writes when HA is enabled bre=
ak
guests that use pre-populated page tables in read-only memslots?

If a guest populates its page tables with the Access Flag already set, plac=
es
them in an RO memslot, and enables HA in its TCR, the hardware only needs r=
ead
access during a walk. However, if a translation fault occurs,
kvm_is_write_fault() will unconditionally evaluate to true because of
effective_tcr_ha().

This will cause kvm_handle_guest_abort() to see a write fault on an RO mems=
lot
and inject a spurious Synchronous External Abort (SEA) into the guest, even
though the hardware only needed to read the page table. Could we retain the
conditional check for permission faults to avoid this?

> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 8263c648207b0..91154654210ec 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c

[ ... ]

> +static bool __effective_tcr_ha(struct kvm_vcpu *vcpu, enum trans_regime =
regime)
> +{
> +	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, AF))
> +		return false;
> +
> +	switch (regime) {
> +	case TR_EL10:
> +		return vcpu_read_sys_reg(vcpu, TCR_EL1) & TCR_HA;
> +	case TR_EL20:
> +		return vcpu_read_sys_reg(vcpu, TCR_EL2) & TCR_HA;
> +	case TR_EL2:
> +		return vcpu_read_sys_reg(vcpu, TCR_EL2) & TCR_EL2_HA;
> +	default:
> +		BUG();
> +	}
> +}
> +
> +static enum trans_regime vcpu_trans_regime(struct kvm_vcpu *vcpu)
> +{
> +	if (!is_hyp_ctxt(vcpu))
> +		return TR_EL10;
> +
> +	return vcpu_el2_e2h_is_set(vcpu) ? TR_EL20 : TR_EL2;
> +}

[Severity: High]
Does vcpu_trans_regime() correctly handle unprivileged memory accesses=20
like LDTR/STTR executed from EL2?

By returning TR_EL2 based strictly on the vCPU's execution context, KVM
disregards that unprivileged instructions at EL2 use the EL1 and 0 translat=
ion
regime (TCR_EL1) when HCR_EL2.E2H is 0 or TGE is 0.

Since KVM cannot distinguish an LDTR fault from an LDR fault via the ESR
syndrome, it will read TCR_EL2.HA in __effective_tcr_ha() instead of
TCR_EL1.HA. If TCR_EL1.HA is 1 but TCR_EL2.HA is 0, KVM incorrectly evaluat=
es
HA as disabled.

This causes KVM to treat a legitimate S1PTW permission fault (generated to
update the Access Flag) as a read fault, refusing to grant write permission=
s.
The hardware will then fault again on retry, creating an infinite stage-2 f=
ault
loop that hangs the guest vCPU.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624202446.1698=
535-1-oupton@kernel.org?part=3D1
