Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430531;
	b=VRSPLRUkJQ59gC8Ny591vHyw7oaNobJVCNdjQgvpPBperwgU1BYvLPad7UPNW8+XAcRN
	 ZZVdjf2X9WMUyYpsPGuzmAg15pjs+VgyBxF9rG7+5kbhYiTJVfq7KS39ddHHNGthd3FKK
	 EN3b3S1d0YO2IWv7dYPDln2P69fFeYx94cdFxbFOjHgiTgTkOk77e7knuII1+5Tq3Ph37
	 JX9S5dnEOHqZihmhMj+Gp0HVfh6ImlzppVEu1eTF/evPpJ8Mj6x7geGMk8cJrCHRjRkPH
	 B8BASp9YlRHvx3Zw7UK3qot1kVqBcVbKdd7kv61UBBdc0mpmZp3hwE43EGSRTyR9SAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430531;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hnKOtRCqIvyy1sSy8VyZw9gGdPtPJkPBXPX0Mg8ue+4=;
	b=YJWqLtae6aSHRHl5xFq5EeTyr2QdKdCb7cYJiOZn/jreIWVbEFt0MN1Xk0+FUxMzTu/G
	 KSyF93f0Telyzukvg9JbnVS/A1QAzuwM2Ahykpf7vM1/se8QIp9p5aPh9u2ZNRbdO6+Jc
	 Ym93MERIJ2D9MKdZQ3Dklx+3OHTWyznw+W24If+sXB9NQKCHnHhwL/AQ/zUZpsMZFUrcc
	 Nbfba6fhow8XpD4dg5gm6KNjCf+dseLO0KcDxgSOMRs82N5X4Q/mlUfVnZKKnWovA1Zq1
	 2E0ztwst07Vx8G0C2KXdbXYBF93P8QYdC+ZVtivGDgGrlPmfHh90AMcpyZYVywc8h/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dnD6Z5pj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AC0606A31A
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 10:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dnD6Z5pj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FC21F000D1;
	Mon, 23 Nov 2026 10:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795430531;
	bh=hnKOtRCqIvyy1sSy8VyZw9gGdPtPJkPBXPX0Mg8ue+4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dnD6Z5pjdV3QzFjdylzKo/67IxiRbnnkAx2dtz7K49u/C5NaM0h3SDJca9Ad+r/qB
	 I7aYWtbK2gIIHtr9obI7kVt7we38h3YcQ63tUrKy7me074CguvrABZnuc4J8PUJWAt
	 6wUNXrzOOZ8j9nUNBNKvnjTKxnfI0RHTtaCIj7UgRG0WcWblcobuXw5O0qKqdv0aWl
	 zOTnhtCBuNAbehlryM93MnIQpDaBin6UnaWRaRK12YuMH+60gHQPaKH9TMlZs1GV/2
	 P0RboLoCDjXGCO8Pmi0HRGWfllNjf4PDK0htVwimbnQwVt6MQQVME9520A/GhTdVp1
	 tPPTL1bo1OlqA==
Message-ID: <sashiko-outbox-229065@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Re-inject a stored SError after the
 exit is handled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dan Carpenter" <dan@pereq.eu>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261123-double_exception-v1-1-cd82b59a232d@pereq.eu>
References: <20261123-double_exception-v1-1-cd82b59a232d@pereq.eu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 10:42:10 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] KVM: arm64: nv: duplicate SError injection when
  NESTED_SERROR_PENDING is set
- [Medium] KVM: arm64: nv: premature SError re-injection in
  kvm_nested_flush_hwstate()
--

commit a6e9a58a0688b0de9bbbb40738acfc3f5921f92e
Author: Dan Carpenter <dan@pereq.eu>

KVM: arm64: nv: Re-inject a stored SError after the exit is handled

This commit defers SError re-injection for nested guests from
kvm_nested_sync_hwstate() to kvm_nested_flush_hwstate() so that exit
handlers can record their exception or PC increment before the SError is
re-injected, and updates kvm_arch_vcpu_runnable() to treat a deliverable
stored SError as a wakeup condition.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 78d5b18dbd2d6..f063c01c565a0 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -2213,8 +2213,11 @@ void kvm_nested_flush_hwstate(struct kvm_vcpu *vcp=
u)
>  	if (!vcpu_has_nv(vcpu))
>  		return;
> =20
> -	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING)))
> +	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING))) {
> +		/* Commit the exit handler's exception first */
> +		__kvm_adjust_pc(vcpu);
>  		kvm_inject_serror_esr(vcpu, vcpu_get_vsesr(vcpu));
> +	}
> =20
>  	vgic_v3_nested_update_mi(vcpu);
> =20

[Severity: Medium]
Can re-injecting NESTED_SERROR_PENDING here run prematurely when guest
entry is subsequently aborted?

In kvm_arch_vcpu_ioctl_run(), kvm_nested_flush_hwstate() runs before
checking ret <=3D 0 or kvm_vcpu_exit_request(), and inside
kvm_nested_flush_hwstate() the SError is re-injected before
vgic_v3_nested_update_mi() and the KVM_REQ_GUEST_HYP_IRQ_PENDING check:

arch/arm64/kvm/nested.c:kvm_nested_flush_hwstate() {
	...
	vgic_v3_nested_update_mi(vcpu);

	if (vgic_state_is_nested(vcpu) && kvm_vgic_vcpu_pending_irq(vcpu))
		kvm_make_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu);
}

If L2 has PSTATE.A =3D=3D 1 (with HCR_EL2.AMO =3D=3D 0 and HCRX_EL2.TMEA =
=3D=3D 0) and
NESTED_SERROR_PENDING set while an L1 IRQ or maintenance interrupt is
pending, kvm_nested_flush_hwstate() clears NESTED_SERROR_PENDING, sets
HCR_EL2_VSE in *vcpu_hcr(vcpu), and posts KVM_REQ_GUEST_HYP_IRQ_PENDING.
kvm_vcpu_exit_request() then aborts guest entry without calling
kvm_nested_sync_hwstate(), and on the next loop iteration
check_nested_vcpu_requests() -> kvm_inject_nested_irq() switches the vCPU
to L1 vEL2 with HCR_EL2_VSE still set in vcpu->arch.hcr_el2 even when TGE
and AMO are clear.  Similarly, if PSTATE.A =3D=3D 0 in L2 or if ret <=3D 0 =
exits
to userspace, pend_serror_exception() pends the SError into L2 state that
gets committed by __kvm_adjust_pc() even though L2 was never entered.

> @@ -2231,18 +2234,11 @@ void kvm_nested_sync_hwstate(struct kvm_vcpu *vcp=
u)
> =20
>  	/*
>  	 * We previously decided that an SError was deliverable to the guest.
> -	 * Reap the pending state from HCR_EL2 and...
> +	 * Reap the pending state from HCR_EL2, and re-inject it from
> +	 * kvm_nested_flush_hwstate() once the exit has been handled.
>  	 */
>  	if (unlikely(__test_and_clear_bit(__ffs(HCR_EL2_VSE), hcr)))
>  		vcpu_set_flag(vcpu, NESTED_SERROR_PENDING);
> -
> -	/*
> -	 * Re-attempt SError injection in case the deliverability has changed,
> -	 * which is necessary to faithfully emulate WFI the case of a pending
> -	 * SError being a wakeup condition.
> -	 */
> -	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING)))
> -		kvm_inject_serror_esr(vcpu, vcpu_get_vsesr(vcpu));
>  }

[Severity: Medium]
Does leaving NESTED_SERROR_PENDING set across handle_exit() and exits to
userspace cause a duplicate SError injection when kvm_inject_serror_esr()
is called before the next kvm_nested_flush_hwstate()?

Because kvm_inject_serror_esr() does not clear NESTED_SERROR_PENDING when
it delivers an SError via kvm_inject_nested_serror(),
pend_serror_exception(), or HCR_EL2_VSE, a KVM_GET_VCPU_EVENTS followed by
KVM_SET_VCPU_EVENTS in __kvm_arm_vcpu_set_events() injects and immediately
commits the SError via commit_pending_events() while NESTED_SERROR_PENDING
remains set:

arch/arm64/kvm/guest.c:__kvm_arm_vcpu_set_events() {
	...
	if (has_esr)
		ret =3D kvm_inject_serror_esr(vcpu, esr);
	else
		ret =3D kvm_inject_serror(vcpu);

	commit_pending_events(vcpu);
}

On the subsequent KVM_RUN, kvm_nested_flush_hwstate() sees
NESTED_SERROR_PENDING still set and injects a second SError into the
guest.  The same double injection happens in-kernel if handle_exit() calls
kvm_handle_guest_sea() -> kvm_inject_serror() while NESTED_SERROR_PENDING
is set.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123-double_exc=
eption-v1-1-cd82b59a232d@pereq.eu?part=3D1
