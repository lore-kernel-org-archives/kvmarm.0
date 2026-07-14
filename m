Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA6E44BC93
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 12:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784032446; cv=none; b=Kh4ToWeX5pzGhSDAsae575ljroYv4kvrzynzmeWWLSE3X+7BqnSa+UuLLNeZrUJBQDKrleZ7oTQ1w5tvj8KE7mRGwMf6O1LYqe+NIRU5BsrjDbEzN4zm98D2fIu/Ex2rlWVAT0FKPzbYwFB1Xk15/+3LYNHTICGXfMllXDcVWgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784032446; c=relaxed/simple;
	bh=hzcPzvNESfxGy1SXAQLnDqi2wmxDzHe0CfNsN9cL/xI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SIU9FptfXfBnxlm7uDIR8mJ5O/LJjFHuWYP6iw2PmYd/GMhlj9Ks8AO1J/cSGItW9NCwGVe5aoyuKNOr5deS4A5hThWV5PUmmdNB63vWXlbN78rnj4YXXkdtRH7uHBATG0ONei7xeBCa5/E22EWJh+bZP2AA2WeFWFNniFu+k2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iXQqqCGg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iXQqqCGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631A51F00A3A;
	Tue, 14 Jul 2026 12:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784032435;
	bh=BCw3Ba4jiEhVo8Yhr5XF9tpF8LRNvQB3kl+9sTXFju4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iXQqqCGgxp18hBNXWwP+bSBBMrj46eIP44/Wo6iCJECbZwFVfDcFqKnxJJzOHs9AZ
	 l1Dk4xOB5PnLY84lJTzT5yMZ6Hcly3pe44FYYoTyMhxg/feyeXE+pBKxG9STWPhHX8
	 DerxgIVPsEyDO71AxgfTDGwCwH9yPZUHose5bykvMr08rgD0p6PTEoSu/JAkW87Vac
	 hTZaMgKfWOd/3l+CZSZi9fgp2uZTlSNHv7qVQedCIk6fWkF6v5Bnr0K8ecaYm8f+qg
	 pht72z5BRfHrM2a1N4TW96xuc4QqQwQqMoa5CGLEaAGVUNHIa8agMlCl/QUbW3zXdP
	 lTNDU1LeAbv8A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260714101601.4142645-9-fuad.tabba@linux.dev>
References: <20260714101601.4142645-1-fuad.tabba@linux.dev>
 <20260714101601.4142645-9-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 12:33:54 +0000
Message-Id: <20260714123355.631A51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Removal of `hcr_el2` synchronization back to the host prevents cle=
arance of `HCR_VSE`, causing infinite virtual SError storms in the guest.
- [High] Lazy state sync skips synchronization and clears `PKVM_HOST_STATE_=
DIRTY` on IRQ and IL exits, silently discarding host-side context modificat=
ions.

Pre-existing issues:
- [Critical] Protected guest register state is unconditionally leaked to an=
d overwritten by untrusted host memory (`host_vcpu->arch.ctxt`) on every wo=
rld switch.
--

--- Patch [8]: [PATCH v5 8/8] KVM: arm64: Implement lazy vCPU state sync fo=
r non-protected guests ---
commit e68e83fa70438b2538d1ea836d971c6d52ffb760
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Implement lazy vCPU state sync for non-protected guests

pKVM copies a non-protected guest's register context between the host
and the hypervisor on every world switch, even when the host never
inspects it. Defer the copy: on entry, flush the host context into the
hyp vCPU only when the host marked it dirty; on exit, leave it in the
hyp vCPU and copy it back only when the host needs it.

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -486,9 +486,32 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception=
_index)

[ ... ]

> +static void handle_exit_pkvm_state(struct kvm_vcpu *vcpu, int exception_=
index)
> +{

[ ... ]

> +	if (exception_code =3D=3D ARM_EXCEPTION_TRAP ||
> +	    exception_code =3D=3D ARM_EXCEPTION_EL1_SERROR ||
> +	    ARM_SERROR_PENDING(exception_index)) {
> +		kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> +		vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +	} else {
> +		vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +	}
> +}

[Severity: High]
If a non-protected guest exits due to an IRQ (such as a PMU overflow), this
clears PKVM_HOST_STATE_DIRTY. If the host kernel then handles the IRQ and
modifies the guest context (for example, setting PMOVSSET_EL0 for the
overflow or applying a reset like KVM_REQ_SUSPEND), these updates appear to
be lost.

On the next entry, flush_hyp_vcpu() will skip copying the host state because
the dirty flag is clear. Then, on a subsequent exit or vcpu_put,
handle___pkvm_vcpu_put() will reverse-sync the stale hyp state back over the
host state. Does this clear flag path silently discard host-side context
modifications?

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
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
> +	}

[Severity: Critical]
This is a pre-existing issue, but doesn't this unconditionally overwrite the
protected guest's private EL2 registers with the values from the untrusted
host memory? By copying host_vcpu->arch.ctxt into the hyp_vcpu on entry,
could the host arbitrarily modify a protected VM's state before execution?

> @@ -203,9 +255,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_=
vcpu)
>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
>  	sync_debug_state(hyp_vcpu);
> =20
> -	host_vcpu->arch.ctxt		=3D hyp_vcpu->vcpu.arch.ctxt;
> -
> -	host_vcpu->arch.hcr_el2		=3D hyp_vcpu->vcpu.arch.hcr_el2;
> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> +		host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;

[Severity: Critical]
This is also a pre-existing issue, but leaking the protected guest's
register state into the untrusted host memory seems to violate pKVM's
confidentiality guarantees. The untrusted host EL1 can read all private EL2
registers via its mapped kvm_vcpu structure. Should this copy be avoided for
protected VMs?

[Severity: High]
By removing the assignment that copies hcr_el2 back to the host, do we break
virtual SError injection?

When the guest takes a virtual SError, the hardware clears the VSE bit in
the hyp vCPU's hcr_el2. Because we no longer sync this back in
sync_hyp_vcpu(), the host's copy remains set. On the next entry,
flush_hyp_vcpu() will read the stale host HCR_VSE bit and set it again,
which seems like it would trap the guest in an infinite virtual SError
storm.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714101601.4142=
645-1-fuad.tabba@linux.dev?part=3D8
