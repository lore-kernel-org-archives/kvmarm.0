Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792493603;
	b=faUviuWTKh30er0agGfW6/Th+KNgKYcvNvZQs3KNmk3Bz22BF0yn/LZqIasR6args+c9
	 V6pSjbstCm/trFsJv/cFyt3tk5NFoGBrVM2+Rolh11sobk1bgKSFl61W+k6pc6vmXIE9m
	 wt2I2+rJdhK/lHEUKBLs9DMixlLFlMmj9F29Hv9hZ+PtAyJ8nR64OiejrKCxy33AJGURg
	 gV56e6sAfOF1GrQA3sBpBw3WBjg2p6wXijAG8EC1G191zz1wNCgYI7fDmAfNVFtnrpVcW
	 v40AuuBs7VPwkmjheweRsXatg5egaU8mFheRlnxPagIun5ISizZnP0uiMom4uV2zRXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792493603;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DDT5/jkrFEkfdQSDuGQCxfkobQuwzoFK2usbBy74Kbo=;
	b=r7t2wLGb+v6FdebbIE6t8uqnTR4f6qUZEk1gQAEC4UXB15zSRoo0WO91pfSgZLqPLF2p
	 CuIuHlxMgn5GAG2HcwXZGFBVQsW7urz8nWv2v7lqjey2f34YQ/dQcGYoGLLpfj0r0CWPK
	 78vMZBqudOusObOkyuPuxEHk2rObuDmwGqzZ1LBmQEBpx/x4FD0WXshy8M8t6uWQ+n2TP
	 Lf9oKcBl0Ryta3AWZoxwGTTN63PODYSUUN/BNkpl57Mx9Tzn1D6uz8gX6cKOg1r5ie79x
	 bhbSe8TzLzZHNDkalfytDXlCZHmtQ/FU4xQkMCchDbrAGjoi7KqwyaVbLvPHi+3wcKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gys8uQLV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD69606A320
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 10:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gys8uQLV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F101F000C4;
	Tue, 20 Oct 2026 10:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792493602;
	bh=DDT5/jkrFEkfdQSDuGQCxfkobQuwzoFK2usbBy74Kbo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gys8uQLVo1CjNd/NrcqkGumbmn4tIZF852VqE+ZV9+b5LQo/uRJBMwCh1m+5Enbxw
	 lNjyzyo5gKYMen9/xQBjmFTyI2WN7C98ESeOOy0MWqdDjy3xTwP2RfJnS9MmcEcyEm
	 y65HwV77xptmUhn71sRpo2D5R7iMVlDQxF9Smu8+spBt3C1ecQ4c+tJof6rzNE35mk
	 qbC/+N4/YJn/H9uc1MmdfYVp88mUKVGwqCLISQY5jm+zsfURUiXXS4706C3PBpi6Dr
	 VgKhwHrZKaWwYqTkLj9tCpi5tdMk1MNGpuh1FlMsL1R3+d6UtU3SSxW6Mzgp4Hn/4V
	 GJqHJvnlMBAww==
Message-ID: <sashiko-outbox-178860@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Decouple computation of the GICv5 trap
 registers from FEAT_FGT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gustavo Romero" <gromero@redhat.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261020104138.2641586-1-gromero@redhat.com>
References: <20261020104138.2641586-1-gromero@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 10:53:22 +0000
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
- [High] KVM: arm64: populate_nv_trap_config() skips GICv5 FGTs when FEAT_F=
GT is absent
--

commit 78d2daa299df3d77e7dfa794f19cd0a1eee7919c
Author: Gustavo Romero <gromero@redhat.com>

KVM: arm64: Decouple computation of the GICv5 trap registers from FEAT_FGT

This commit moves the computation of ICH_HFGRTR_EL2, ICH_HFGWTR_EL2, and
ICH_HFGITR_EL2 in kvm_vcpu_load_fgt() ahead of the ARM64_HAS_FGT check so
that GICv5 trap register values are computed whenever ARM64_HAS_GICV5_CPUIF
is present, even if the CPU lacks FEAT_FGT.

> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index e93919cadf860..0833453efe4bb 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1744,6 +1744,12 @@ static void __compute_ich_hfgwtr(struct kvm_vcpu *=
vcpu)
> =20
>  void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
>  {
> +	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
> +		__compute_ich_hfgrtr(vcpu);
> +		__compute_ich_hfgwtr(vcpu);
> +		__compute_fgt(vcpu, ICH_HFGITR_EL2);
> +	}
> +
>  	if (!cpus_have_final_cap(ARM64_HAS_FGT))
>  		return;

[Severity: High]
Does populate_nv_trap_config() in arch/arm64/kvm/emulate-nested.c also need
to be updated to store the ICH_HFGRTR_GROUP and ICH_HFGITR_GROUP entries in=
to
sr_forward_xa when ARM64_HAS_GICV5_CPUIF is present but ARM64_HAS_FGT is
absent?

Currently, populate_nv_trap_config() skips storing any entry into
sr_forward_xa when ARM64_HAS_FGT is not supported:

arch/arm64/kvm/emulate-nested.c:populate_nv_trap_config() {
	...
		for_each_encoding_in(enc, fgt->encoding, fgt->end) {
			...
			if (!cpus_have_final_cap(ARM64_HAS_FGT))
				continue;

			prev =3D xa_store(&sr_forward_xa, enc,
					xa_mk_value(tc.val), GFP_KERNEL);
			...
		}
}

Because of that, on a system with ARM64_HAS_GICV5_CPUIF and !ARM64_HAS_FGT,
the GICv5 entries in sr_forward_xa are left with tc.fgt =3D=3D __NO_FGT_GRO=
UP__
(populated only with tc.sri by populate_sysreg_config() for registers in
sys_reg_descs[], or left at 0 for all other GICv5 registers and instruction=
s).

When a guest running without FEAT_GCIE (for example, a GICv3 guest in
compatibility mode, or a VM where ID_AA64PFR2_EL1.GCIE was cleared) executes
a GICv5 system register or instruction access, kvm_vcpu_load_fgt() has
cleared the trap bits in ICH_HFGRTR_EL2, ICH_HFGWTR_EL2, and ICH_HFGITR_EL2
from kvm->arch.fgu[], so the access traps to kvm_handle_sys_reg() ->
triage_sysreg_trap():

arch/arm64/kvm/emulate-nested.c:triage_sysreg_trap() {
	...
	if (tc.fgt !=3D __NO_FGT_GROUP__ &&
	    (vcpu->kvm->arch.fgu[tc.fgt] & BIT(tc.bit))) {
		kvm_inject_undefined(vcpu);
		return true;
	}
	...
}

With tc.fgt =3D=3D __NO_FGT_GROUP__, this FGU check is bypassed instead of
injecting an UNDEF:

- A guest read of SYS_ICC_PPI_ENABLER0_EL1 or SYS_ICC_PPI_ENABLER1_EL1
  dispatches to access_gicv5_ppi_enabler() in arch/arm64/kvm/sys_regs.c with
  !p->is_write, triggering WARN_ON_ONCE(!p->is_write).

- A guest write to SYS_ICC_PPI_ENABLER0_EL1 dispatches to
  access_gicv5_ppi_enabler() and writes to
  vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_enabler, which shares a union with
  vgic_v3 in struct vgic_cpu.

- Guest reads of SYS_ICC_IDR0_EL1 or SYS_ICC_IAFFIDR_EL1 execute
  access_gicv5_idr0() or access_gicv5_iaffid() instead of injecting UNDEF.

- Guest accesses to other GICv5 registers or instructions fall through to t=
he
  local label with !tc.sri and log "Unsupported guest access at:" on the ho=
st
  before injecting UNDEF.

> =20
> @@ -1761,10 +1767,4 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
>  		__compute_fgt(vcpu, HDFGRTR2_EL2);
>  		__compute_fgt(vcpu, HDFGWTR2_EL2);
>  	}
> -
> -	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
> -		__compute_ich_hfgrtr(vcpu);
> -		__compute_ich_hfgwtr(vcpu);
> -		__compute_fgt(vcpu, ICH_HFGITR_EL2);
> -	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261020104138.2641=
586-1-gromero@redhat.com?part=3D1
