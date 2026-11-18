Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795009535;
	b=17MIEyzomcxkmkXCx5qE670RjajSR2QMpsd2yfLEtDcfegIU+c7HQlm2IiHdHymttwNW
	 PUj5ZrGsTe7UKHb0Cksh5qKFFUkOhsRPUWRtpq4Yhkkr1p/7D6iwE289FQmq/X7Yth7Fd
	 RqbCASsHTudOZgjxK4BkJF9R/r0sH6JaOBK1lSY+KYjRYbOnK2B9TtQnX7kjVtYwoauJw
	 MewqDDFnLoBt5lfEPcFFEXfCxLiXS/kuIWpIEqNW5N2Ye+QrA3YAuteb4DT7rb5PRq7M9
	 v7mL0njBQIGbHvVae2ZjwxrKg/Dr5pNoHGyFfvCcFHnRxtyAWfK9jQ5+gKkepfHr7lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795009535;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=btdBq6aCoOiZ3CdzYw1g+4cWDNUm2li91oUlFkvJcFA=;
	b=FlUAa+OnAQStZD6j80Hy77HYPLdhSpOLdPmLEGJ6m45WYMRSF05IZnntFHZMEiOvlnwI
	 iwPCDKFwjtnulK+Cquw1S/d7qApRNF7Bhxe/waWDMiHSuKRubAyhs5O9NGqKJ0yG5LWnx
	 au9E6SfBJt6BagXuGk5Tacpz9zcZOAyNTANJsXD1FXSHfz4dFQ5XspQSvgk282WBW9LR6
	 gxkES5an4QKTMqrDUtvOH3pS7j6FxNXJASw/qlmq7bmqCkVYBGlnQvZxAT1YPOkEU/6x1
	 Piw4rOozYavrkR7hdPrv70AjYfXnuCY1PkWR/EWcm1WV1wx8oB82qkT5UWBJNtxEl2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QYSOwNop;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301C3606A333
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 13:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QYSOwNop
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867701F000C8;
	Wed, 18 Nov 2026 13:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795009534;
	bh=btdBq6aCoOiZ3CdzYw1g+4cWDNUm2li91oUlFkvJcFA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QYSOwNopktYpUKLaZzzHI4nCL9nshfkDV+vTiY2ZB8Nl50luE+Roz5Mqzh+r+06vN
	 mmGrVqR+DWfKI+zpjgn1eQcE9LpydAThP4+Gb4R40a1m2PGxnG8Cih9TlGimtrFSQd
	 +H+dml0UOz6rcjQTPHvwBzU2NDJLgwekDvIONWJBPvDj/2nxAQLU85ZC6wBuKfayIe
	 uJ5AoamyO0kTLbbPs3LwZ/lShwxLp/H/jnSN/4bPhAwFKyNDcr8LfA/arww8iaZ3Uj
	 hCIMbOkXCFRhG7CP4QY7QCtL/PpPUtYwiAI650GCfK31c+08pgFHPRSg4Af3K4HD/m
	 dnOfXOgtc8S0A==
Message-ID: <sashiko-outbox-221074@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: Load the vcpu in KVM_SET_VCPU_EVENTS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dan Carpenter" <dan@pereq.eu>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <033a2d49e0f48426281b46eb1131ae64012aba18.1795006659.git.dan@pereq.eu>
References: <cover.1795006659.git.dan@pereq.eu>
 <033a2d49e0f48426281b46eb1131ae64012aba18.1795006659.git.dan@pereq.eu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 13:45:34 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] KVM: arm64: stale mmio_needed after kvm_inject_nested() in
  KVM_SET_VCPU_EVENTS
--

commit 178d0de7451612b8ddf14a943cb82094efbd77d1
Author: Dan Carpenter <dan@pereq.eu>

KVM: arm64: Load the vcpu in KVM_SET_VCPU_EVENTS

This commit wraps __kvm_arm_vcpu_set_events() in vcpu_load() and vcpu_put()
so that kvm_inject_nested() operates on a loaded vCPU during
KVM_SET_VCPU_EVENTS.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 84a52e27ed859..a148e80d0aef7 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2002,7 +2002,7 @@ static int kvm_arm_vcpu_get_events(struct kvm_vcpu =
*vcpu,
>  static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>  				   struct kvm_vcpu_events *events)
>  {
> -	int i;
> +	int i, ret;
> =20
>  	/* check whether the reserved field is zero */
>  	for (i =3D 0; i < ARRAY_SIZE(events->reserved); i++)
> @@ -2014,7 +2014,11 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu=
 *vcpu,
>  		if (events->exception.pad[i])
>  			return -EINVAL;
> =20
> -	return __kvm_arm_vcpu_set_events(vcpu, events);
> +	vcpu_load(vcpu);
> +	ret =3D __kvm_arm_vcpu_set_events(vcpu, events);
> +	vcpu_put(vcpu);
> +
> +	return ret;
>  }

[Severity: Medium]
Does vcpu->mmio_needed remain set when KVM_SET_VCPU_EVENTS injects an
exception from L2 that routes to L1 EL2?

When an L2 guest exits with KVM_EXIT_MMIO and userspace aborts the access v=
ia
KVM_SET_VCPU_EVENTS (for example with ext_dabt_pending =3D 1 while HCR_EL2.=
TEA
is set), kvm_inject_sea_dabt() -> kvm_inject_nested() commits the EL2
exception entry directly via __kvm_adjust_pc(), which clears
PENDING_EXCEPTION.  When __kvm_arm_vcpu_set_events() then calls
commit_pending_events(), PENDING_EXCEPTION is already clear, so it returns
early without clearing vcpu->mmio_needed:

arch/arm64/kvm/guest.c:commit_pending_events() {
	if (!vcpu_get_flag(vcpu, PENDING_EXCEPTION))
		return;

	vcpu->mmio_needed =3D false;
	kvm_call_hyp(__kvm_adjust_pc, vcpu);
}

On the next KVM_RUN, kvm_handle_mmio_return() sees vcpu->mmio_needed still
set, writes the MMIO read value into L1 EL2's destination register and
advances L1 EL2's exception vector PC by 4 bytes via kvm_incr_pc().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1795006659.gi=
t.dan@pereq.eu?part=3D1
