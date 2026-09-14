Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D410472093
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 13:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393380; cv=none; b=FtEaELbtZ77T9D7s9K4rppDBN69x/L/0DL8KtAjwQPofnemoDUxlMd6WjygofgPDcquMqCYS9q69hZIg4z7fOO/ATc6q6ZDhMGaGjgvVxIHYyLIfRqzigPmYEWA+AfCN09jRp4fF2+U1Wxr6v2BdWClrZUpI3nHThl7q6mU9dqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393380; c=relaxed/simple;
	bh=mS4qWVd8sviF4ovA4wB4+v5UqsrIMGsbpO9jOrN9r2A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jGduDfSj9GinpYSznUc7ZcxObqxr72uuuW3tjxmuQKRpD6CaavaPM9d8nPMWrXafP4GxWU58uR1K4HiUg++eKxl9MLKX6ERsKqRkae2ob66BAxbk//TXuJ5+rXVby6BINbUXaPlNjhnSMrNF4YmW9UBi5UBIr+2w1NnbeRiGFdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PhyZhnPZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PhyZhnPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5B21F000FF;
	Mon, 14 Sep 2026 13:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789393378;
	bh=NgGyOq6Kv0kRSueMHmrPbIbVGS8r/kcWjymJBZ773pI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PhyZhnPZ0fQ/EO8oyz4/ZBDkVH57Sz4kP2qLiUVtDXKoZrg2/1bJy2+aIO5YBGFwP
	 NwC22JBRA5n9gej+O/OjTg5IGwbKXHl7tMnpCxngsicbqX+6/7gkdaxH3FFZ+vL/bA
	 /UAd/ezj3yEElA2BroVuEGEbFE3NFD+WAxe+64tHQ4DSkfwrWqHD9EHoJpXPNfm2OD
	 Qo0ftwf7+dRUy3ZWy41bJraxa2aeQ0CV6O7gXqxUopUgGXhGDYTWe7nqtMB1OzDZqF
	 2aS9VTKuQHdT2JflJoppDdRhDWlJgXP7f6LAK4aFNmsLjb5aoiDbtUwjEQeLYrrY8p
	 b6eqdqr8wZgkQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/18] KVM: arm64: Skip fixed-feature state flush for
 protected vCPUs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260914113338.159227-7-fuad.tabba@linux.dev>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
 <20260914113338.159227-7-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 13:42:58 +0000
Message-Id: <20260914134258.9A5B21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Early return in `flush_debug_state` leaves the protected guest=
's `debug_owner` as `VCPU_DEBUG_FREE`, completely bypassing hardware debug =
register context switching and exposing host physical debug registers to th=
e guest.
--

commit 3ff31a206fa3951489ae8f183dab7b2241b1018e
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Skip fixed-feature state flush for protected vCPUs

This commit skips the fixed-feature state flush for protected vCPUs by
returning early in flush_debug_state() and sync_debug_state(), and moving t=
he
mdcr_el2 copy into the non-protected branch in flush_hyp_vcpu().

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index ef65c3cd6f810..229a4877d14f5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -200,6 +200,9 @@ static void flush_debug_state(struct pkvm_hyp_vcpu *h=
yp_vcpu)
>  {
>  	struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> =20
> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		return;
> +

[Severity: Critical]
Does this early return leave the protected guest's debug_owner as
VCPU_DEBUG_FREE (its zero-initialized value) instead of synchronizing it?
This could bypass hardware debug register context switching, potentially
exposing host physical debug registers to the guest.

>  	hyp_vcpu->vcpu.arch.debug_owner =3D host_vcpu->arch.debug_owner;
> =20
>  	if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu)) {

[ ... ]

> @@ -218,6 +221,9 @@ static void sync_debug_state(struct pkvm_hyp_vcpu *hy=
p_vcpu)
>  {
>  	struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> =20
> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		return;
> +

[Severity: Critical]
Could this early return ignore debug state updates on exit, further
contributing to the debug isolation bypass?

If KVM's world switch sees !kvm_debug_regs_in_use(), it might skip restoring
the host's debug registers.

>  	if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu))
>  		host_vcpu->arch.vcpu_debug_state =3D hyp_vcpu->vcpu.arch.vcpu_debug_st=
ate;
>  	else if (kvm_host_owns_debug_regs(&hyp_vcpu->vcpu))

[ ... ]

> @@ -241,6 +247,12 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp=
_vcpu)
>  	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
>  		if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
>  			flush_hyp_vcpu_state(hyp_vcpu);
> +
> +		hyp_vcpu->vcpu.arch.hcr_el2 &=3D ~(HCR_TWI | HCR_TWE);
> +		hyp_vcpu->vcpu.arch.hcr_el2 |=3D READ_ONCE(host_vcpu->arch.hcr_el2) &
> +							 (HCR_TWI | HCR_TWE);
> +
> +		hyp_vcpu->vcpu.arch.mdcr_el2 =3D host_vcpu->arch.mdcr_el2;

[Severity: Critical]
By moving the mdcr_el2 copy into the non-protected branch, does the protect=
ed
guest retain the EL2-computed mdcr_el2 where TDA is deliberately cleared?

This seems to prevent debug accesses from trapping. If a protected guest
directly executes MSR DBGBVR0_EL1, <addr> without trapping to EL2, and KVM
skips restoring the host's debug registers on exit due to the early returns
above, the guest's malicious values could remain active when the host resum=
es.

If the host has breakpoints enabled (MDSCR_EL1.MDE =3D 1), these guest-inje=
cted
breakpoints could fire in the host kernel.

>  		hyp_vcpu->vcpu.arch.iflags =3D host_vcpu->arch.iflags;
>  	} else {
>  		hyp_vcpu->vcpu.arch.ctxt =3D host_vcpu->arch.ctxt;
> @@ -249,17 +261,13 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
>  	/* __hyp_running_vcpu must be NULL in a guest context. */
>  	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu =3D NULL;
> =20
> -	hyp_vcpu->vcpu.arch.mdcr_el2	=3D host_vcpu->arch.mdcr_el2;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914113338.1592=
27-1-fuad.tabba@linux.dev?part=3D6
