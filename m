Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238433DC852
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782458948; cv=none; b=u6OH8GMFm+M1cHSqOh2hTLk3NNak49fXuFtidBFtuC4un/ugrn0GuPvItALyg8hlCEDOkYrdhZf6P42Ru2D8Asi86yfRx1N+YmesOIOckPZUHq1k3aPmLYGMwMdWKX5Oew8AJW1gFiJjmqagL7v4pIL1ha7vvgg/kLQc3inTNCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782458948; c=relaxed/simple;
	bh=KLCKarmmyNo346nYmAOr6hLbqkfYiNYL9g5qOwzGo60=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BtRyBxKsx8H6ggbCGZ/nxJLk8FtuMR0z+p3QZfAbCmnEGzy6mepqdmWgyj5uGlfgf86R9gh0pJ/go4Aje32niXsS9NRNJupSE90vZAsjUsKAmUO3FvuMT3udoXJfmjJUYyK3Sqadmhl2ME1gEleMj0qSRAjbHTk85gbM/0fG9wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=clHgT4Hi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="clHgT4Hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7777C1F000E9;
	Fri, 26 Jun 2026 07:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782458946;
	bh=lqO0OWwYKIfwL050meLaz6NL4B2RN0XGrj9v8dDnjYM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=clHgT4HirAfUWT7GGY/XtDnJKe1s3BwWcqODmUjMZuzx755ebePIS2yfQMzmPC0vP
	 Qvoi4RG/gwLRixLB033T4myJwbjUNDE/bpxDz9CNxevM0tOQy/B4JUgkcIXoi6ePPZ
	 asH0wI/PVyoO1gz4DzoP0dhoPSF97TqJX6VjT58QoOnfLaoZpqG1krgHw/JSncnLNU
	 fOINTmZsiUOFqRqkGedvUg+LMSmAj/SSxyTkLsceVKHtvh/DHY8ZVt5rxnm+X1Go4D
	 hbRRKu1/+qphmcGHAKpC1dSKCfWP4G2UwkdKbwhEwxEHnoL2OalCLr8HW+jdDjepY7
	 0bQd3leigD1CA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260626070408.3420953-9-fuad.tabba@linux.dev>
References: <20260626070408.3420953-1-fuad.tabba@linux.dev>
 <20260626070408.3420953-9-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 07:29:06 +0000
Message-Id: <20260626072906.7777C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Asynchronous host modifications to non-protected guest sysregs (e.=
g., PMU overflows updating PMOVSSET_EL0) are lost because lazy vCPU state s=
ync clears the dirty flag on IRQ exits and later overwrites the host's upda=
tes with stale hypervisor state.
- [High] The patch removes the synchronization of `hcr_el2` from the hyperv=
isor back to the host on guest exit, breaking the delivery tracking of virt=
ual SErrors and causing infinite virtual SError loops.

Pre-existing issues:
- [Critical] pKVM completely breaks register confidentiality and integrity =
for protected VMs by copying the entire execution context (`arch.ctxt`) to =
and from untrusted host memory on every world switch.
--

commit 44f38b89413b112e6bbd7b360cf03c7937ed43a4
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Implement lazy vCPU state sync for non-protected guests

pKVM copies a non-protected guest's register context between the host
and the hypervisor on every world switch. This commit defers the copy
by flushing context on entry only if marked dirty, and syncing back
on exit only when requested.

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
> +
> +	if (!is_protected_kvm_enabled() || kvm_vm_is_protected(vcpu->kvm))
> +		return;
> +
> +	/*
> +	 * Sync the context back when the host will read (trap) or write
> +	 * (SError) it. Preempt-off here, so the loaded hyp vCPU is stable.
> +	 */
> +	if (exception_code =3D=3D ARM_EXCEPTION_TRAP ||
> +	    exception_code =3D=3D ARM_EXCEPTION_EL1_SERROR ||
> +	    ARM_SERROR_PENDING(exception_index)) {
> +		kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> +		vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +	} else {
> +		vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);

[Severity: High]
Is it possible for asynchronous host updates to be lost here? If a physical
IRQ (like a PMU overflow) causes a guest exit, this else branch clears
PKVM_HOST_STATE_DIRTY.

If the host IRQ handler then updates PMOVSSET_EL0 in the host's
vcpu->arch.ctxt, the next guest entry in flush_hyp_vcpu() will skip
copying sys_regs to the hyp vCPU. The guest will see stale state.

If the guest later triggers a TRAP exit, __pkvm_vcpu_sync_state() is
called, which copies the stale hypervisor sys_regs back to the host,
permanently erasing the host's asynchronous update.

> +	}
> +}
[ ... ]
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
This is a pre-existing issue, but does trusting arch.ctxt violate the pKVM
threat model? Copying the entire execution context directly from untrusted
host memory into the protected guest context on entry breaks integrity,
allowing the host to arbitrarily modify a protected guest's registers.

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
Could removing the hcr_el2 sync result in infinite virtual SError loops?

When the host injects a virtual SError by setting HCR_VSE, flush_hyp_vcpu()
flows this bit to the hyp vCPU. The hardware clears the physical
HCR_EL2.VSE bit when the guest takes the virtual SError, and KVM clears it
in the hyp vCPU's hcr_el2.

Without syncing this back to the host here, the host's hcr_el2 retains
the stale HCR_VSE=3D1. On the next entry, flush_hyp_vcpu() will re-apply the
stale HCR_VSE bit and re-inject the SError continuously.

> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> +		host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;

[Severity: Critical]
This is a pre-existing issue, but can writing arch.ctxt out to the host
leak sensitive register state? For protected VMs, writing the private guest
context directly out to the untrusted host on exit breaks confidentiality.

> +	} else {
> +		/* Keep PC (tracepoint) and PSTATE (vcpu_mode_is_bad_32bit) current. */
> +		host_vcpu->arch.ctxt.regs.pc =3D hyp_vcpu->vcpu.arch.ctxt.regs.pc;
> +		host_vcpu->arch.ctxt.regs.pstate =3D hyp_vcpu->vcpu.arch.ctxt.regs.pst=
ate;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626070408.3420=
953-1-fuad.tabba@linux.dev?part=3D8
