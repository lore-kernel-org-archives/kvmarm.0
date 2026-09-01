Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A724562B7
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 22:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788300037; cv=none; b=o/QCRb7yFqaQpr/NeKWNDWFQR6qpj3AF+VtFToeKQGeScQT5ACGH9VmS4Dvn5SlShBoB+uBq57B5obmShxbzlBzMrSsg+3pBDETk37a/TZniRKy/AVWV+QRN2yQWmbNTc0hpvSOXgt6m2LecpEDTP1XADtddYY+iRAEA6T47FSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788300037; c=relaxed/simple;
	bh=5xxlMCS/otLui4B97F5toKdSMI2zhz4psfPW2oRIG/8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PYLElIJ1SXoS86p+C5XZifjU3t4mgegu56Ws34k3SJRKJXCY0Xy1mpeFIsLJXvZcfplzn7iALPN/NCyMeuNZkChR7vyz8C9N1t3E+F+y7e94gUSVY1oYLO9eLlLOi8Va3Ms7RgUps90c80W3CTwjUHJgJT3RTYVXtorbU9M+Gmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W3iTYUwF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W3iTYUwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A071F000E9;
	Tue,  1 Sep 2026 22:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788300036;
	bh=Ny5zEs2oMgAPy3wVM3TOWky4tokt4dp3QF59xcuu9yg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W3iTYUwFabCvwvHHL4DuDLmjqee9r/JuGb0pi/f0BFIOaKkmiAcBVio8hbV5x2X/u
	 +XIggrnAQmp+MP01RLk4rh3Xb6onXM6aEYzKYQ12yx2PaRYEy1lt0Vxh1daEfTiQ1i
	 eZCV1EjHL9X1nhWOJYGgtZNVq7Q0Xg2CgAOIUKwisV7KIA/vhExDujEvcibV9r8aqj
	 tfZmk4x4dMdr199ODzoBLyhmkr4U3tWVNtY2pv0aYBuTUYLN4NGokaKQWQABUx9I46
	 Y/ZmJx8j/qBynqQAFaOkvXdXLa25KOdHxFH6X95nlHypCm/SZCeUdoQLGZHZLMU7FO
	 xboIG3dDt1KzQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v20 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260901-arm64-gcs-v20-3-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-3-f31750bdfadb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 22:00:36 +0000
Message-Id: <20260901220036.67A071F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] GCS register context switch logic is erroneously nested inside=
 unrelated S1PIE and TCR2 capability checks, leading to host state leakage,=
 asymmetrical save/restore, and guest state corruption if GCS is enabled in=
dependently.
--

commit ad11e1da6432a36cf2c3a84df41b688bfab6461b
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Manage GCS access and registers for guests

This commit introduces context switching for Guarded Control Stack (GCS)
registers and exposes them to VMMs to allow guests to use GCS features.
It also configures HCRX_EL2.GCSEn to enable GCS instruction execution in
the guest.

> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/=
hyp/include/hyp/sysreg-sr.h
> index c382848d31947..d26802aa455e3 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
[ ... ]
> @@ -144,6 +158,10 @@ static inline void __sysreg_save_el1_state(struct kv=
m_cpu_context *ctxt)
>  		if (ctxt_has_s1pie(ctxt)) {
>  			ctxt_sys_reg(ctxt, PIR_EL1)	=3D read_sysreg_el1(SYS_PIR);
>  			ctxt_sys_reg(ctxt, PIRE0_EL1)	=3D read_sysreg_el1(SYS_PIRE0);
> +			if (ctxt_has_gcs(ctxt)) {
> +				ctxt_sys_reg(ctxt, GCSPR_EL1)	=3D read_sysreg_el1(SYS_GCSPR);
> +				ctxt_sys_reg(ctxt, GCSCR_EL1)	=3D read_sysreg_el1(SYS_GCSCR);
> +			}
>  		}

[Severity: Critical]
Does this mistakenly couple the EL1 GCS state save to the unrelated S1PIE
and TCR2 features?

Because the ctxt_has_gcs() check is nested inside ctxt_has_s1pie() (which is
itself nested under ctxt_has_tcrx() in __sysreg_save_el1_state()), if a
guest is configured with GCS enabled but S1PIE or TCR2 disabled, the
hypervisor skips saving GCSPR_EL1 and GCSCR_EL1. Since HCRX_EL2.GCSEn is
still enabled for the guest, couldn't this allow the guest to access and
potentially corrupt the host's GCS state?

[ ... ]
> @@ -243,6 +266,11 @@ static inline void __sysreg_restore_el1_state(struct=
 kvm_cpu_context *ctxt,
>  		if (ctxt_has_s1pie(ctxt)) {
>  			write_sysreg_el1(ctxt_sys_reg(ctxt, PIR_EL1),	SYS_PIR);
>  			write_sysreg_el1(ctxt_sys_reg(ctxt, PIRE0_EL1),	SYS_PIRE0);
> +
> +			if (ctxt_has_gcs(ctxt)) {
> +				write_sysreg_el1(ctxt_sys_reg(ctxt, GCSPR_EL1),	SYS_GCSPR);
> +				write_sysreg_el1(ctxt_sys_reg(ctxt, GCSCR_EL1),	SYS_GCSCR);
> +			}
>  		}

[Severity: Critical]
Similarly for the restore path in __sysreg_restore_el1_state(), does this
miss restoring the EL1 GCS registers when S1PIE or TCR2 is disabled?

> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/=
sysreg-sr.c
> index 0c4ef1ce32ae7..08b5d939a6c5a 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
[ ... ]
> @@ -59,10 +59,14 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu =
*vcpu)
>  			if (ctxt_has_s1pie(&vcpu->arch.ctxt)) {
>  				__vcpu_assign_sys_reg(vcpu, PIRE0_EL2, read_sysreg_el1(SYS_PIRE0));
>  				__vcpu_assign_sys_reg(vcpu, PIR_EL2, read_sysreg_el1(SYS_PIR));
> +
> +				if (ctxt_has_gcs(&vcpu->arch.ctxt))
> +					__vcpu_assign_sys_reg(vcpu, GCSCR_EL2, read_sysreg_el1(SYS_GCSCR));
>  			}

[Severity: Critical]
Is it intentional that the GCSCR_EL2 save in __sysreg_save_vel2_state()
is nested inside the S1PIE check here?

[ ... ]
> @@ -86,6 +90,8 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *v=
cpu)
>  	__vcpu_assign_sys_reg(vcpu, SP_EL2,	 read_sysreg(sp_el1));
>  	__vcpu_assign_sys_reg(vcpu, ELR_EL2,	 read_sysreg_el1(SYS_ELR));
>  	__vcpu_assign_sys_reg(vcpu, SPSR_EL2,	 read_sysreg_el1(SYS_SPSR));
> +	if (ctxt_has_gcs(&vcpu->arch.ctxt))
> +		__vcpu_assign_sys_reg(vcpu, GCSPR_EL2, read_sysreg_el1(SYS_GCSPR));

[Severity: Critical]
This creates an asymmetry in __sysreg_save_vel2_state(): GCSPR_EL2 is saved
unconditionally based only on ctxt_has_gcs(), but GCSCR_EL2 is saved
conditionally based on both ctxt_has_s1pie() and ctxt_has_gcs(). Can this
cause the hypervisor to track mixed states if S1PIE is disabled?

[ ... ]
> @@ -138,6 +144,11 @@ static void __sysreg_restore_vel2_state(struct kvm_v=
cpu *vcpu)
>  		if (ctxt_has_s1pie(&vcpu->arch.ctxt)) {
>  			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIR_EL2), SYS_PIR);
>  			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIRE0_EL2), SYS_PIRE0);
> +
> +			if (ctxt_has_gcs(&vcpu->arch.ctxt)) {
> +				write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSCR_EL2), SYS_GCSCR);
> +				write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSPR_EL2), SYS_GCSPR);
> +			}
>  		}

[Severity: Critical]
Does this break the restore logic for GCSPR_EL2?=20

In the save path above, GCSPR_EL2 is saved outside the S1PIE block, but here
in __sysreg_restore_vel2_state() it is restored inside the S1PIE block. If=
=20
S1PIE is absent but GCS is enabled, the saved GCSPR_EL2 value is never=20
restored, which could leave the hardware with an unexpected state upon exit.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-arm64-gcs-=
v20-0-f31750bdfadb@kernel.org?part=3D3
