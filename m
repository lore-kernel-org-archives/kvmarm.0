Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3508E383333
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 22:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214541; cv=none; b=YXQVT8p74vX7+8TUMfwyEO5uonCiBz7hwjbU93tOUnyqVTKFzSAG9g5esawva4zuXrHN49FwtCIITRnAuOvJQe804DvMmVynvHGYc0CzNF9AOR7SeWc+cTAFpaL45u7FGU7A1mXim15XATwngWF29Vg0DQoYG8wUdhmggUt/9KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214541; c=relaxed/simple;
	bh=QgcQl7nDut+nuNX30PMy4qBIqh1C1t9SC31fGMJFX/M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pIb5Fl5KG+zB2f7EkNI6RiXN9rgEDOAFB0AIy6swX8DULhUDl5/K1GezmP79PoZMj1VvTSgwnXUKS4xo79URfFR0GwecT8NFWcsnwda8WNq1S5u2675OF9dw81KUTdJBypSt+GL/a90QgiLzMAahfYn3Hk4V3yyDXfPABqrx1O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TdhMBXK5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TdhMBXK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB491F000E9;
	Mon, 31 Aug 2026 22:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788214539;
	bh=4lij8hx+HdXQlY1eMFJ7+PGqpGTdJS0fS4AHDi6n8lg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TdhMBXK5dTnhQYt7zkReh7m0jndh2M2Ge80pMs4zPYf8KOovuR5bsAMmx1j3GZV3P
	 yfuLsVe3eNFDC4+cQgniMan6ngvErpWRATU0uPiBsyE0wm4cXh+mlwZJwHeJq2360x
	 Jn7aw9lrWajt5FhYVYWn0PbTkyQlv16swoLgF4nJzPhVg9CpgHrL3ufy586lsnk21S
	 HA68J0We4SlT1stD+13oDgmSk3XqKedmIVSlzTi88jTPep5q7aqjKFw2DNvkIUUFb6
	 VHyD08t5MIlP+aYgSd7/yT9qV6CVLc3gAh0FrH5HCxXmPsPMc9NwAJenO8SE3w3ueW
	 P9XFONLv0H8dQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 13/17] KVM: arm64: Add per-EC entry/exit state
 marshalling for protected guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260831163421.272420-14-fuad.tabba@linux.dev>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
 <20260831163421.272420-14-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 22:15:39 +0000
Message-Id: <20260831221539.8DB491F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] The HVC64 entry handler ignores host-requested PC increments and e=
xception injections, causing an infinite trap loop.
- [High] Host-injected exceptions and PC advancements are silently ignored =
for unhandled Exception Classes, causing infinite trap loops.
- [High] handle_pvm_exit_wfx fails to marshal the WFx timeout register to x=
0, breaking WFET and WFIT emulation.
--

commit 0b0e245ce37c95597a108d7e1ed3684401ade81b
Author: Fuad Tabba <fuad.tabba@linux.dev>
Subject: KVM: arm64: Add per-EC entry/exit state marshalling for protected =
guests

This patch moves a protected guest's state between the hyp vCPU and the host
per exception class instead of copying the whole context. It adds per-EC
entry and exit handlers for various traps and routes protected guests
through them to marshal only the necessary state.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 5925d35abba8c..461e15cab1b92 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

> -static void __maybe_unused handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *=
hyp_vcpu)
> +static void handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	handle_pvm_entry_psci(hyp_vcpu);
> +}

[Severity: High]
Does this code omit handling for host-requested PC increments and exception
injections?=20

If the guest executes an HVC instruction, which traps to EL2, and the host
handles the call (e.g., standard PSCI fallback) by setting the INCREMENT_PC
or PENDING_EXCEPTION flags, it appears handle_pvm_entry_hvc64() doesn't
apply them on re-entry. As a result, the guest's PC wouldn't advance and
it could infinitely retry the same HVC.

[ ... ]

> +static void handle_pvm_exit_wfx(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	hyp_vcpu->host_vcpu->arch.ctxt.regs.pstate =3D
> +		hyp_vcpu->vcpu.arch.ctxt.regs.pstate & PSR_MODE_MASK;
> +}

[Severity: High]
Can this cause the host to read uninitialized or stale data for WFET and
WFIT timeout values?

When a protected guest traps to EL2 on a WFET/WFIT, pvm_host_esr()
deliberately masks out the RN field (the register index holding the timeout)
from the host's view of the ESR. Because of this, the host's
kvm_handle_wfx() expects the timeout register value to be marshalled into
regs[0]. It looks like handle_pvm_exit_wfx() doesn't copy the guest's RN
register to host_vcpu->arch.ctxt.regs.regs[0] before exiting to the host.

[ ... ]

> @@ -418,10 +638,16 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
>  	case ARM_EXCEPTION_IL:
>  		break;
>  	case ARM_EXCEPTION_TRAP:
> -		esr_ec =3D ESR_ELx_EC(kvm_vcpu_get_esr(&hyp_vcpu->vcpu));
> -		ec_handler =3D entry_hyp_vm_handlers[esr_ec];
> -		if (ec_handler)
> -			ec_handler(hyp_vcpu);
> +		/* Nothing was marshalled for this trap, see sync_hyp_vcpu(). */
> +		if (ARM_SERROR_PENDING(hyp_vcpu->exit_code))
> +			break;
> +
> +		if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> +			esr_ec =3D ESR_ELx_EC(kvm_vcpu_get_esr(&hyp_vcpu->vcpu));
> +			ec_handler =3D entry_hyp_pvm_handlers[esr_ec];
> +			if (ec_handler)
> +				ec_handler(hyp_vcpu);
> +		}
>  		break;

[Severity: High]
Does this logic silently ignore host-injected exceptions and PC advancements
for unhandled Exception Classes?

If a protected guest executes an unhandled instruction (like SMC64), it
traps to EL2. The host cannot emulate the unknown EC and pends an exception
via the PENDING_EXCEPTION flag. Because there is no specific entry handler
for this EC in entry_hyp_pvm_handlers, ec_handler is NULL and the re-entry
skips entry handling.=20

Since the generic fallback was removed, the PENDING_EXCEPTION flag is
ignored, the PC is not advanced, and the guest could hang trying to retry
the failing instruction infinitely.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831163421.2724=
20-1-fuad.tabba@linux.dev?part=3D13
