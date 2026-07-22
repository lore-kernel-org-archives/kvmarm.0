Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C656239E6C;
	Wed, 22 Jul 2026 08:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708585; cv=none; b=RKUuNv1E+Fux2cQWOew7J27SI3BYiJpgDfNv+iEqXyiwUf5HZd3EUdf/RgAFqqJCj2xxdwiKFKB3KMEioRTYcogibsvBC3d31MA4OLs5x/jNp/Ck5XdKoBMNE3z80aW9MB7WvuzB0Z4vA8SvJbzR6IfQ+KcxM1mGxJQceHlfK44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708585; c=relaxed/simple;
	bh=UTf1jaLeluF6pinui5/cgZZrhNwSlvq4dAGC4mF3iqU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=b6eLYtQ77XiDVjbPiJ32yY2U2Xi5CZMcaL7MwE+nQJFFvhyS07OPfqQlkDaQJcLnt+YBihXvEUK9/4dQauABb2SbcV07BueNwX8lVF/RDtA+ACJ1k/PvKpvlENDZOp28TCiUJV9ccSxefSNC0N1u9wxUv05k2C5nS/L583TjoSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GmIbWDy5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GmIbWDy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E821F000E9;
	Wed, 22 Jul 2026 08:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784708584;
	bh=dQgR02L/YrfyDAlf6oGjYuW7KdllCEa5f68EtZG7nOk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GmIbWDy5VYsKn91zLFlDku8Iph5J4NQhmwYKHtnpEQqZ68QoTbZzU6u3kPiI6fZIN
	 9ZfoZrQTJLVeS0CaFFGlcD76eSmbGilZu/2747P6WabQ6WF9Z4p24ooninjbHNAL0l
	 W3cjEbRGn0VDSkhvOvZOvMsAeZwcUSKvTAw7V/6Ou1OKBUlwOm13oiuFAXambfYMP3
	 D+6i2q61HHGHKx08Z6M5XmQBvX0vYFALEnWixp1NZKYfmRPyMoRqHZCQEcDyFHnSMc
	 kDQJ6R+27EsSsx1o1qlbJURA+Mv1DgWiRjQIXmtQ67oPzhZTUQoab31VEetTIND++G
	 yLFWMIqcpeLkQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 16/28] KVM: arm64: Split NV-specific exit fixups from
 the non-NV handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260722074234.3330999-17-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-17-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 08:23:03 +0000
Message-Id: <20260722082303.B4E821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Removing `inline` from `fixup_guest_exit()` and breaking out `fixu=
p_nv_guest_exit()` exposes them to kprobes, which will cause a fatal host p=
anic if probed.
--

--- Patch [16]: [PATCH v3 16/28] KVM: arm64: Split NV-specific exit fixups =
from the non-NV handling ---
commit 54c98942c16b88b656ffdb68540aac18e6fe4d3f
Author: Marc Zyngier <maz@kernel.org>
KVM: arm64: Split NV-specific exit fixups from the non-NV handling

This commit moves the nested virtualization (NV) handling of early fixups=20
into its own helper function. This simplifies parsing and prepares the code
for further changes.

> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/swi=
tch.c
> index a8da40568a048..53af19212895d 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -539,18 +539,15 @@ static const exit_handler_fn hyp_exit_handlers[] =
=3D {
>  	[0x3F]				=3D kvm_hyp_handle_impdef,
>  };
> =20
> -static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_cod=
e)
> +static void fixup_nv_guest_exit(struct kvm_vcpu *vcpu)

[Severity: High]
Does extracting this function without a NOKPROBE_SYMBOL() annotation expose
it to kprobes?

Since this executes on the VM exit path while the KVM hypervisor vectors are
still loaded, placing a kprobe here would trigger a BRK instruction that tr=
aps
to __kvm_hyp_vector. This cannot handle kprobes and would unconditionally
call hyp_panic(), crashing the host.

Should we add NOKPROBE_SYMBOL(fixup_nv_guest_exit) to prevent this?

>  {
> -	synchronize_vcpu_pstate(vcpu);
> -
>  	/*
>  	 * If we were in HYP context on entry, adjust the PSTATE view
>  	 * so that the usual helpers work correctly. This enforces our
>  	 * invariant that the guest's HYP context status is preserved
>  	 * across a run.
>  	 */
> -	if (vcpu_has_nv(vcpu) &&
> -	    unlikely(host_data_test_flag(VCPU_IN_HYP_CONTEXT))) {
> +	if (unlikely(host_data_test_flag(VCPU_IN_HYP_CONTEXT))) {

[ ... ]

> @@ -567,8 +564,15 @@ static inline bool fixup_guest_exit(struct kvm_vcpu =
*vcpu, u64 *exit_code)
>  	}
> =20
>  	/* Apply extreme paranoia! */
> -	BUG_ON(vcpu_has_nv(vcpu) &&
> -	       !!host_data_test_flag(VCPU_IN_HYP_CONTEXT) !=3D is_hyp_ctxt(vcpu=
));
> +	BUG_ON(!!host_data_test_flag(VCPU_IN_HYP_CONTEXT) !=3D is_hyp_ctxt(vcpu=
));
> +}
> +
> +static bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)

[Severity: High]
By removing the inline keyword here, doesn't this also expose
fixup_guest_exit() to kprobes if the compiler chooses not to inline it?

Should this function also receive a NOKPROBE_SYMBOL() annotation to avoid t=
he
same host panic hazard?

> +{
> +	synchronize_vcpu_pstate(vcpu);
> +
> +	if (vcpu_has_nv(vcpu))
> +		fixup_nv_guest_exit(vcpu);
> =20
>  	return __fixup_guest_exit(vcpu, exit_code, hyp_exit_handlers);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722074234.3330=
999-1-maz@kernel.org?part=3D16
