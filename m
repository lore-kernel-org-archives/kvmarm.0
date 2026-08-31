Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCC7377AB0
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 19:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788206342; cv=none; b=ASdcLRuxjvv/yvMxEoL3XIZGsOnj1n/IU5drUkLkwRxe0HegQQiFJLPK9kXRDl/dwrVbpHqll+iSd0h2HAC5cpcl6dVbQqM9ovukOhEtmk7X3OqGhizTnbIM5/M2RRIk0c/snnxpVfAUdV4CciIxNTF5m0gEiDT5AYn5WSJuf2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788206342; c=relaxed/simple;
	bh=YhbTdrsQMgoUIO8LUJXPdmggOOpk7jkref3qwDM4iFY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P2vYszJ4XpN2J4vz/48/p/ec8vp0foxMK9ZRqpXLRiuBFEgKior+Ez6tg5c75iLQDuCEbW43a3lhDowtDfQxdxfDUWkdX6nWEd74uc2t1VxwoT5YTzaWg8qnKabLw2Itq5A3TRS0r63yah4wbFZDS6dcPUX2YfwqzfIoQkDI9q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKoPo0T+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKoPo0T+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512F71F000E9;
	Mon, 31 Aug 2026 19:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788206340;
	bh=ImOxtYnuJFAaScvzqQpR9EA1Kwq2aHVnExKsS5J3mhc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JKoPo0T+QNZL6+xgEsRGj5ySafNURnFAMCBM6JO5U4sGkLqhTG1EWjgRReSvmEpc8
	 QA1AWPvaIvQlobagtgxL82J5XDBrNd/zlLEPxDIXHZyU8l8xNpc/ZK9FrsAZPiFsHd
	 0RJKcM0A9xisgOmsYw5tOYEuFjK6TKlq8+cuQz8HK13AQvvwdXy4aOfdGgIr+U+w9q
	 bmzW9HPyLJgtmaEN5HHVPFc+9oIuMp2O29TZP7OPJpwhKyIRLj3eiro450k71I9wE0
	 5mDnFZuF5bkPlLLRA/wRmRqNt1iF3nPs+l8nY25K6m6yLKFhhP1Ud/0ZRl+GFr5rAa
	 l8Lo8QamzS5Ag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/17] KVM: arm64: Skip fixed-feature state flush for
 protected vCPUs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260831163421.272420-6-fuad.tabba@linux.dev>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
 <20260831163421.272420-6-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 19:58:59 +0000
Message-Id: <20260831195900.512F71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Under-inclusion in the per-entry `HCR_EL2` allowlist for protect=
ed guests, dropping dynamic WFx trapping policy updates.
--

commit 2c210642954dbb2df4858e3ad74ba54ba96b05d7
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Skip fixed-feature state flush for protected vCPUs

This commit optimizes the per-entry synchronization for protected vCPUs by
moving the copy of fixed-feature state (like mdcr_el2, TWI/TWE, and debug
state) to the non-protected branch and the per-vCPU load path.

> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -241,7 +240,14 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp=
_vcpu)
>  	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
>  		if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
>  			flush_hyp_vcpu_state(hyp_vcpu);
> +
> +		hyp_vcpu->vcpu.arch.hcr_el2 &=3D ~(HCR_TWI | HCR_TWE);
> +		hyp_vcpu->vcpu.arch.hcr_el2 |=3D READ_ONCE(host_vcpu->arch.hcr_el2) &
> +							 (HCR_TWI | HCR_TWE);

[Severity: Medium]
Does restricting the per-entry synchronization of HCR_TWI and HCR_TWE to on=
ly
non-protected guests break dynamic scheduling behavior?

These bits act as host-owned runtime signals. If the host dynamically updat=
es
vcpu->arch.hcr_el2 (for example, via kvm_vcpu_on_spin() to yield on
spinlocks) and re-enters the guest, the updated WFI/WFE trapping policy
won't be synced on entry for protected guests because it is now skipped her=
e.

[ ... ]
> @@ -249,17 +255,13 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
>  	/* __hyp_running_vcpu must be NULL in a guest context. */
>  	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu =3D NULL;
> =20
> -	hyp_vcpu->vcpu.arch.mdcr_el2	=3D host_vcpu->arch.mdcr_el2;
>  	/*
> -	 * HCR_EL2.VSE is host-owned (a pending virtual SError to inject), not a
> -	 * trap-control bit, so it must flow to the hyp vCPU alongside TWI/TWE
> -	 * for the vSError to be delivered. sync_hyp_vcpu() reflects it back.
> +	 * A host-injected vSError is masked by the guest's own PSTATE.A, so it
> +	 * applies to protected guests too.
>  	 */
> -	hyp_vcpu->vcpu.arch.hcr_el2 &=3D ~(HCR_TWI | HCR_TWE | HCR_VSE);
> -	hyp_vcpu->vcpu.arch.hcr_el2 |=3D READ_ONCE(host_vcpu->arch.hcr_el2) &
> -						 (HCR_TWI | HCR_TWE | HCR_VSE);
> -
> -	hyp_vcpu->vcpu.arch.vsesr_el2	=3D host_vcpu->arch.vsesr_el2;
> +	hyp_vcpu->vcpu.arch.hcr_el2 &=3D ~HCR_VSE;
> +	hyp_vcpu->vcpu.arch.hcr_el2 |=3D READ_ONCE(host_vcpu->arch.hcr_el2) & H=
CR_VSE;

[Severity: Medium]
Because HCR_TWI and HCR_TWE were removed from this unconditional allowlist =
in
flush_hyp_vcpu(), are we under-including these required bits for protected
guests on re-entry?

[ ... ]
> @@ -329,6 +332,12 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_c=
ontext *host_ctxt)
>  		/* Propagate WFx trapping flags */
>  		hyp_vcpu->vcpu.arch.hcr_el2 &=3D ~(HCR_TWE | HCR_TWI);
>  		hyp_vcpu->vcpu.arch.hcr_el2 |=3D hcr_el2 & (HCR_TWE | HCR_TWI);

[Severity: Medium]
While this code satisfies the WFx trapping configuration in
handle___pkvm_vcpu_load(), doesn't moving it exclusively to the per-load
path mean that any subsequent per-entry policy updates made by the host
will be silently dropped for protected VMs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831163421.2724=
20-1-fuad.tabba@linux.dev?part=3D5
