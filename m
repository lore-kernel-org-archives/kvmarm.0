Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727C848D889
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 13:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332166; cv=none; b=VMiycK3mXuiA/wPbVbwZeB9uJstR9ErMHP/8E4lQfzG4tqHFnARqqo0+EfQNqgcrvKZLQGxS9zWt63dJxHK9V8h/8Us2SxNPtxZlxSi8UavtCTiNlSN+vutYCq0/njeT9Bzbqt4qr95mDWM2+No1gwqBERDSRhTzq7ui3DlAgys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332166; c=relaxed/simple;
	bh=GiZG2esfvlNhFns5MrJGN6yUnJUvKnxLR89MSrmvoaA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Vv9VWlpmm6nUEnkx7sgDlSswsTEg7HbomqFfJAZ+cfAWlq++gCEd9tAxDOSPHROaZgOzKnuMHHhZwpBW6oyQkJHMsLhfuO4L89XexFgHLQZHJEdjz6BaBptda3hlzkRyb9wVx1iqNxERrwwRYUmvubELFuF7tTXMKs3ZtYor9Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VpShLxfM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VpShLxfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD741F000E9;
	Wed, 29 Jul 2026 13:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785332161;
	bh=jGA8A0nJ7e1VZ64i3nWVOM7u+u6pjWJXo5ER+jnu9nU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VpShLxfMHeDSZvcN+P0JzyjwyjM/QDQeHQ7HSMrPfTrfruYmHCuk2wisU2oWoLzBl
	 vbNGIvBui0rSdWocpfb6ZdVn5Fet+3LCQaSNolFL89LK68c2UpIeckGamVTXtq5Ekd
	 Pe/5WY+042LzA40UuwUXRq2XAVJYWB1+/OFE3TlT75xiEEH+TtTHKs1QXVTeu6OpCt
	 aicMBibbOd1Hs7k98O5onJv/EfOk85qNf853RAOhr2Gk2bPal+h8Ugh10St7Nk3PEp
	 25MlICgqTXWlKDVOj5BrE5b15GhvSNjhc3Xttxds612wffdYI9Im9M2zS64T+3V20+
	 xfH6rFHHZZeuw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260729131823.2021516-9-fuad.tabba@linux.dev>
References: <20260729131823.2021516-1-fuad.tabba@linux.dev>
 <20260729131823.2021516-9-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 13:36:00 +0000
Message-Id: <20260729133600.ABD741F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing HCR_EL2 state synchronization breaks virtual SError inject=
ion, causing an infinite exception loop.
- [High] Lazy state sync fails to flush context after KVM_REQ_VCPU_RESET, c=
ausing vCPU resets (e.g., PSCI CPU_ON) to be ignored.
--

--- Patch [8]: [PATCH v7 8/8] KVM: arm64: Implement lazy vCPU state sync fo=
r non-protected guests ---
commit 80df5c4ca2cca0a1726813fa129b353353482892
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Implement lazy vCPU state sync for non-protected guests

This commit optimizes world switches for non-protected guests by deferring
the copy of the vCPU register context between the host and hypervisor.
State is now only synced on entry if marked dirty, and on exit only when
explicitly needed by the host.

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
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
Is it possible for KVM_REQ_VCPU_RESET updates to be ignored due to this
cleared flag?

If a secondary vCPU is powered on (for example, via PSCI CPU_ON), it
receives KVM_REQ_VCPU_RESET and gets kicked, leading to an exit with an
IRQ. Since that exit takes this else branch and clears the dirty flag,
and the reset request is processed afterward in kvm_vcpu_check_requests()
which modifies the host-side vCPU context, wouldn't flush_hyp_vcpu() skip
syncing this updated reset state because the flag remains cleared?

This could result in the target vCPU resuming with its pre-IRQ stale
context, eventually overwriting the new reset state on the next exit.

> +	}
> +}
> +

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -203,9 +255,16 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_=
vcpu)
>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
>  	sync_debug_state(hyp_vcpu);
> =20
> -	host_vcpu->arch.ctxt		=3D hyp_vcpu->vcpu.arch.ctxt;
> -
> -	host_vcpu->arch.hcr_el2		=3D hyp_vcpu->vcpu.arch.hcr_el2;

[Severity: High]
Does removing this HCR_EL2 assignment break virtual SError injection and
cause an infinite exception loop?

When the host injects a virtual SError into a non-protected guest under
pKVM by setting HCR_VSE in the host-side vcpu->arch.hcr_el2, the hardware
automatically clears the VSE bit in the physical HCR_EL2 register once the
guest takes the exception.

Without syncing this hardware-cleared state back to the host here, the
host's HCR_VSE bit remains set. On the next entry, flush_hyp_vcpu() will
repeatedly re-inject the stale HCR_VSE bit from the host into the hyp vCPU,
locking up the guest.

> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> +		host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;
> +	} else {
> +		/*
> +		 * PC feeds trace_kvm_exit(), PSTATE.SS the host software-step
> +		 * machine, and both run before the next on-demand ctxt sync.
> +		 */
> +		host_vcpu->arch.ctxt.regs.pc =3D hyp_vcpu->vcpu.arch.ctxt.regs.pc;
> +		host_vcpu->arch.ctxt.regs.pstate =3D hyp_vcpu->vcpu.arch.ctxt.regs.pst=
ate;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729131823.2021=
516-1-fuad.tabba@linux.dev?part=3D8
