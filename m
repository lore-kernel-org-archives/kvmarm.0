Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0A03C553F
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 08:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104454; cv=none; b=oA+AyZ2RxVzmXZAf69v2cAjoOxOXfJh4vUhP1cXy8h7pXmSckA9rAxMkKjqe+H5U3iHCjXUhva/MT3g4b+8dY7Rtec7YKwnhcSMK1iTzN3kaYKQsg+4mHUoOi2VcKSkcqjelseT29oYIwJXotKSDkBbIlQV32gnuX/7FpYRPu0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104454; c=relaxed/simple;
	bh=30VSpW4CC1qqUYWZ/slJQ1+1Qy8ySauieGfYk7Xj3gc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GDajKr123l/7xndeeF4Asgqvd3MWk7nAODzaovBycVY5it7CThy03Ak0YDiFcadbRIutOr4yvqn8Zm0Fj3f0hIXWuNjDhb3U4EOo59sXagWO6eA6XnbbCZawtsB1upUy/J5+9o2HwGluU5mettbPKnVuFd+KIMgXGzn0anUIIyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WvJJgdaV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WvJJgdaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433141F000E9;
	Wed, 15 Jul 2026 08:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784104452;
	bh=/yBCJ1cM6NPHWafJS0m8BbYVOdvHKKRYOgMjRo2ViLA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WvJJgdaVaJEBxjcPMr36m4j1afFPwdEcq+a9qju4tW34wI8V1lz8fBWREOseY41Z7
	 JNEo3bp/JfsL4/gvFQ+6gPbqkaKOEC/Yyr+jPbK+Gf4u7rvjm2y8WYhoZNQTM1gpgp
	 gMBH5XvECeLBVRmE5Rie2ykphV4lRT1PL0ul8LfuiqyXb6neGTm6YYdo2+UgGfNM7H
	 KWv7z6Z3QBmvf6f1L9p6QewNh+XH8yxMJFmPkZRYVKbav8HJWIEx06AYkSMiJrxhrN
	 EPk/5MkKbvbvEGFyQUEs073o7b/BR/w/RzIIv2HAzot12rYjL6klc2f7JvV+oz9zrl
	 nx/NqDiyOoY+Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260715081238.1891918-9-fuad.tabba@linux.dev>
References: <20260715081238.1891918-1-fuad.tabba@linux.dev>
 <20260715081238.1891918-9-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 08:34:11 +0000
Message-Id: <20260715083412.433141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Removal of hcr_el2 synchronization breaks virtual SError injection=
, causing an infinite loop of virtual SErrors.
- [High] Asynchronous host-side modifications to vCPU system registers (e.g=
., PMU overflow updating PMOVSSET_EL0) are permanently lost due to lazy sta=
te sync.

Pre-existing issues:
- [Critical] The hypervisor unconditionally overwrites a protected guest's =
register context with the untrusted host context on every entry, and leaks =
it back to the host on exit.
--

--- Patch [8]: [PATCH v6 8/8] KVM: arm64: Implement lazy vCPU state sync fo=
r non-protected guests ---
commit 89d46644a5cb6e03eee6a1ef5d530db27a9d6cdb
Author: Fuad Tabba <fuad.tabba@linux.dev>
Subject: KVM: arm64: Implement lazy vCPU state sync for non-protected guests

This commit defers the register context copy for non-protected guests betwe=
en
the host and hypervisor. The state is only flushed to the hypervisor if it =
is
marked dirty by the host on entry, and copied back to the host on exit only
when needed. Protected guests continue to have their state copied
unconditionally.

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 54aedf93c78b6..29108e5c0206e 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
[ ... ]
> @@ -486,9 +486,32 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception=
_index)
>  	}
>  }
> =20
> +static void handle_exit_pkvm_state(struct kvm_vcpu *vcpu, int exception_=
index)
> +{
> +	int exception_code =3D ARM_EXCEPTION_CODE(exception_index);
[ ... ]
> +	if (exception_code =3D=3D ARM_EXCEPTION_TRAP ||
> +	    exception_code =3D=3D ARM_EXCEPTION_EL1_SERROR ||
> +	    ARM_SERROR_PENDING(exception_index)) {
> +		kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> +		vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +	} else {
> +		vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);

[Severity: High]
Does clearing the dirty flag on IRQ exits result in dropping asynchronous
host modifications to vCPU system registers?

When an external IRQ triggers during guest execution, handle_exit_pkvm_stat=
e()
clears the dirty flag. If the host's IRQ handler asynchronously updates the
host's vcpu->arch.ctxt (for example, kvm_pmu_perf_overflow() setting
PMOVSSET_EL0), flush_hyp_vcpu() will skip syncing this updated state on the
next guest entry.

When the guest later traps, handle_exit_pkvm_state() calls
__pkvm_vcpu_sync_state(), which overwrites the host's updated context with =
the
hypervisor's stale context, permanently erasing the asynchronous update.

> +	}
> +}

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 2db56146ec493..4a8445b636e60 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -172,7 +214,17 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp=
_vcpu)
>  	fpsimd_sve_flush();
>  	flush_debug_state(hyp_vcpu);
> =20
> -	hyp_vcpu->vcpu.arch.ctxt	=3D host_vcpu->arch.ctxt;
> +	/*
> +	 * If we deal with a non-protected guest and the state is potentially
> +	 * dirty (from a host perspective), copy the state back into the hyp
> +	 * vcpu.
> +	 */
> +	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> +		if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
> +			flush_hyp_vcpu_state(hyp_vcpu);
> +	} else {
> +		hyp_vcpu->vcpu.arch.ctxt =3D host_vcpu->arch.ctxt;

[Severity: Critical]
This is a pre-existing issue, but does this unconditionally overwrite the
protected guest's register context with the untrusted host context?

In flush_hyp_vcpu(), this line allows the host EL1 to arbitrarily modify the
protected guest's general purpose and system registers, bypassing pKVM's gu=
est
confidentiality and integrity guarantees.

> +	}
> =20
>  	/* __hyp_running_vcpu must be NULL in a guest context. */
>  	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu =3D NULL;
[ ... ]
> @@ -203,9 +255,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_=
vcpu)
>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
>  	sync_debug_state(hyp_vcpu);
> =20
> -	host_vcpu->arch.ctxt		=3D hyp_vcpu->vcpu.arch.ctxt;
> -
> -	host_vcpu->arch.hcr_el2		=3D hyp_vcpu->vcpu.arch.hcr_el2;

[Severity: High]
Does removing the synchronization of hcr_el2 break virtual SError injection=
 and
cause an infinite loop of virtual SErrors?

When the host injects a virtual SError by setting HCR_VSE in its local
hcr_el2 copy, the guest takes the SError, and the hardware clears HCR_VSE in
the hypervisor's active hcr_el2.

Without this line, the hypervisor's cleared state is never synchronized back
to the host. The host's copy permanently retains HCR_VSE=3D1, and on every
subsequent guest entry, flush_hyp_vcpu() will copy HCR_VSE=3D1 back to the
hypervisor, endlessly re-injecting the SError.

> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> +		host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;

[Severity: Critical]
This is a pre-existing issue, but does this leak the protected guest's
registers back to the untrusted host?

Similar to the issue in flush_hyp_vcpu(), this line in sync_hyp_vcpu() copi=
es
the protected guest's register context to the untrusted host on exit, which
violates pKVM's threat model guarantees.

> +	} else {
> +		/* Keep PC (tracepoint) and PSTATE (vcpu_mode_is_bad_32bit) current. */
> +		host_vcpu->arch.ctxt.regs.pc =3D hyp_vcpu->vcpu.arch.ctxt.regs.pc;
> +		host_vcpu->arch.ctxt.regs.pstate =3D hyp_vcpu->vcpu.arch.ctxt.regs.pst=
ate;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715081238.1891=
918-1-fuad.tabba@linux.dev?part=3D8
