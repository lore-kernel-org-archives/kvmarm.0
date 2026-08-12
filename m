Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D7037F727
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 19:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786563889; cv=none; b=fZUz5VSl0xUaLTKsrlkjce/ET8jWyPOCeAQ1qtgkTJOy2Sih8uY0YFxMSyHrPvig8c0NkMXLojS1pk17JEHdzw1MDgV4RIY/i8C4oFnYfREKZ2dz59elHlersMk0Rxb3UW12+GRQqThnHm31PSha+qxtdynmivtxY35/mHD7pKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786563889; c=relaxed/simple;
	bh=XJOtR/vDAYXYMU/wTRPK7sSMj633Z2VM51pvqrzHzy4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uuldOdwMSRndusU7Mw56DkORoK6YCjC7hXGcFjGvzQ+69SbrMw3MogvcF2DbdEyIuKuAU9fXR9WxidEiOW7+fzKOggydhg9iSwx0L0Qyle7JltSh/8yftXaXL8aK0yOLsMkrSbw0S4W2jPTy5xup3/9aKD5m3aWM76YGS7+HWP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fOB0Ak1d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fOB0Ak1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8131F000E9;
	Wed, 12 Aug 2026 19:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786563888;
	bh=Dc2PdOq7q4aZ7q+HNr4Wt9yNRjJvrrjj71unBUfxup4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fOB0Ak1dI8zBp1ws2UcU7jFnSlOeIOzGYl8ls4ptjNOYHrvpKfS5lPo64nUUazjIv
	 2JICqoiI7ktTgKVu+B1cEkwkNK9Zrylvb0z3GcvmMtuMjRlsmUVNybq0RmeOILefuS
	 GqPxZtLifl4n3W0QgSKXbKe6mbsEUxQ7og0XMo7ERgPQvOCVPMET4jLzOBKlSpTN71
	 VIykt691SbanojrZkDIUwjyEz2gXY61AAC5s0Dzyv9sWQ4gI6A2gc1V0dLuQkZ+YLj
	 khYDY+ZqxD8yP2T5m2OBNRzeSXK2uMYhB4WCWk+NQ5FPbldgm0jotVPLd7s4IAcBhl
	 7Bov7iadjPjxw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260812-arm64-gcs-v19-3-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-3-9105afd828ac@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 19:44:47 +0000
Message-Id: <20260812194447.AB8131F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] GCS system register save/restore logic is incorrectly nested i=
nside unrelated S1PIE and TCRX feature checks, causing guest state corrupti=
on and potential host control-flow hijack.
- [Critical] Calling ctxt_has_gcs() on the host context calculates a bogus =
vCPU pointer and dereferences arbitrary memory, crashing the host kernel on=
 VCPU load/put.
--

--- Patch [3]: [PATCH v19 03/14] KVM: arm64: Manage GCS access and register=
s for guests ---
commit 7b54a8ce806322bdd9585098668578c6af7e75b8
Author: Mark Brown <broonie@kernel.org>
Date:   Wed Aug 12 19:12:02 2026 +0000

    KVM: arm64: Manage GCS access and registers for guests
   =20
    GCS introduces a number of system registers, on systems with GCS we need
    to context switch them and expose them to VMMs to allow guests to use
    GCS.
   =20
    In order to allow guests to use GCS we also need to configure
    HCRX_EL2.GCSEn, if this is not set GCS instructions will be noops and
    CHKFEAT will report GCS as disabled.

> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/=
hyp/include/hyp/sysreg-sr.h
> index a17cbe7582de9..053d7b3c5104d 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -67,6 +68,11 @@ static inline void __sysreg_save_user_state(struct kvm=
_cpu_context *ctxt)
>  {
>  	ctxt_sys_reg(ctxt, TPIDR_EL0)	=3D read_sysreg(tpidr_el0);
>  	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	=3D read_sysreg(tpidrro_el0);
> +
> +	if (ctxt_has_gcs(ctxt)) {
> +		ctxt_sys_reg(ctxt, GCSPR_EL0) =3D read_sysreg_s(SYS_GCSPR_EL0);
> +		ctxt_sys_reg(ctxt, GCSCRE0_EL1)	=3D read_sysreg_s(SYS_GCSCRE0_EL1);
> +	}
>  }

[Severity: Critical]
Does this cause a host kernel panic when called on the host context?

__sysreg_save_user_state() is called on the host context during vcpu_load()
and vcpu_put(). The host_ctxt is embedded inside the per-CPU struct
kvm_host_data, not a kvm_vcpu.

When ctxt_has_gcs(ctxt) evaluates ctxt_to_vcpu(ctxt), the container_of() ma=
th
will yield a bogus kvm_vcpu pointer, leading to an out-of-bounds memory read
when it dereferences vcpu->kvm to check the features.

[ ... ]
> @@ -144,6 +161,10 @@ static inline void __sysreg_save_el1_state(struct kv=
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
Should the GCS register saving be conditionally nested inside the S1PIE
feature check?

If a KVM guest is configured with GCS enabled but without S1PIE, it appears
the GCS registers will not be saved or restored. This could leave stale GCS
register values in hardware across context switches, potentially allowing
guest-to-host privilege escalation if the host resumes with a guest-control=
led
GCSPR_EL1.

[ ... ]
> @@ -239,6 +265,11 @@ static inline void __sysreg_restore_el1_state(struct=
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
Similarly, the GCS register restoration appears to be incorrectly tied to t=
he
S1PIE feature check here.

> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/=
sysreg-sr.c
> index be685b63e8cf2..4f775545c71ba 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -61,6 +61,9 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *v=
cpu)
> =20
>  			if (ctxt_has_s1poe(&vcpu->arch.ctxt))
>  				__vcpu_assign_sys_reg(vcpu, POR_EL2, read_sysreg_el1(SYS_POR));
> +
> +			if (ctxt_has_gcs(&vcpu->arch.ctxt))
> +				__vcpu_assign_sys_reg(vcpu, GCSCR_EL2, read_sysreg_el1(SYS_GCSCR));
>  		}

[Severity: Critical]
Is there a structural asymmetry being introduced here?=20

GCSCR_EL2 save is nested inside the TCRX feature check, while GCSPR_EL2 is
saved entirely independently later in this function. This ties GCSCR_EL2
saving to an unrelated feature.

[ ... ]
> @@ -129,6 +134,11 @@ static void __sysreg_restore_vel2_state(struct kvm_v=
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
Does this also tie the GCS restoration to the unrelated S1PIE and TCRX
features?

Both GCSCR_EL2 and GCSPR_EL2 restorations are deeply nested inside the S1PIE
feature check here, breaking symmetry with the save path above and requiring
S1PIE to be enabled for GCS registers to be restored.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812-arm64-gcs-=
v19-0-9105afd828ac@kernel.org?part=3D3
