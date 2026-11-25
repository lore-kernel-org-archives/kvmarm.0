Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590947;
	b=YfoNDfQt3SjR7/S0qz9S7xkSlC5h2p4ZkNdhkKHiAzPpTXsaeBT/srIDD4skeZsWArw+
	 soerEpGb9y/DIs3gjtOAQgf61Hm6W1tH7rccoT+YWSRmwTYb3RjGZ9ucCxOm5koCLBVw0
	 23mobCxBZ49pqvq11NTC3aleDW/9tknhHbubJMP+dn8lvDRTsWwLxWiCWUs01WJANuJTV
	 BlLKCxE+pUdwT/STtTJWoJiEnaPCAhQ4x7+s8UCmwWJbo5YO4fDDY4zVG8G7ao96nCrqP
	 QLvXnktbiRDeh2/AQPnBV1/4s8GMxcAvoECatjZkxGSNWRMWw8TONuX11CBd0MFO3gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590947;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Qr1WkdD7lUjHmLYrbbgORpljbdFmct9M7d97UJO6688=;
	b=SXMuj1MlhM1x0Xu20fujfFhYI2pKsUdz84grVNr5cI1pEg2zVmeAzzbT9rj+NxrV6f6P
	 uEkCZiVM40QNtA568X/JOoIkqQ6t2d+Y92Po7BCRAbMO3JSB/jqexF2KqvxLtv88PDV56
	 M0A/UqcSX21W/j+M6ly1lcpej+RfesBrhPNk/GhFTvrkzBJs/BJ4h/KoK88ktReA7C6/5
	 vnqcKGtd2WpHUjEhDp6NZ9qvOPGMQ1LEwb47CgVqAA05nQAKnzcCwE/JB249fmYZVZorN
	 +GsFm0jcd8XPMlMEJpfWPkh5M5lQc69tW5+px2eAVIyJ/Yf6GgqAY7PWSsf+7PY36Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bCAyis22;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484A2606A69C;
	Wed, 25 Nov 2026 07:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bCAyis22
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955DE1F000C0;
	Wed, 25 Nov 2026 07:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590946;
	bh=Qr1WkdD7lUjHmLYrbbgORpljbdFmct9M7d97UJO6688=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bCAyis22aCFZbDn2UL9udyWVE+FoHVvkvGRLkvreaQECV5zd46cvS+2V6+B7HE40C
	 ulTO3+PjmJNxDClYZ00Z6gM4fXnxJOJLXImKCKF+B0oJ7Q1mjwyiACzfov+th5MyZo
	 3N8x3VcDajLReFkmw9oIy0Bpa/vsniGjRnAWI86UeM/AQfbmmmdd+G0YusURcdNGwo
	 iLvVOvTC/ZlcMZF+PMk9dtU0FUgKxO1Lls8U2mE4miIg1/z7VMuIrB8D00KSLOBssK
	 VM7h+pVSUOLRA37CFsHhxhOmBgvUTUJZgqjhZ/9ogaqhZTeJvdB4uXuowbZLYtL+xQ
	 0qCUzWP71bYyw==
Message-ID: <sashiko-outbox-232760@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/8] KVM: arm64: Reset SP_EL1, ELR_EL1 and SPSR_EL1
 when resetting a vcpu
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dan Carpenter" <dan@pereq.eu>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261125-double_exception-v2-2-224689d8a764@pereq.eu>
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
 <20261125-double_exception-v2-2-224689d8a764@pereq.eu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 07:15:46 +0000
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
- [Medium] KVM: arm64: SP_EL1, ELR_EL1, and SPSR_EL1 unreset in
  pkvm_reset_vcpu() and core
--

commit d315f26d12c1dd260ed62612065ad5e34b6f9f03
Author: Dan Carpenter <dan@pereq.eu>

KVM: arm64: Reset SP_EL1, ELR_EL1 and SPSR_EL1 when resetting a vcpu

This commit zeroes SP_EL1, ELR_EL1, and SPSR_EL1 in kvm_reset_vcpu() when
resetting a vCPU.

> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 26081d2734087..9c1b42890c966 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -199,6 +199,9 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> =20
>  	/* Reset core registers */
>  	kvm_reset_vcpu_core(vcpu);
> +	__vcpu_assign_sys_reg(vcpu, SP_EL1, 0);
> +	__vcpu_assign_sys_reg(vcpu, ELR_EL1, 0);
> +	__vcpu_assign_sys_reg(vcpu, SPSR_EL1, 0);
>  	vcpu->mmio_needed =3D false;
> =20
>  	/* Reset system registers */

[Severity: Medium]
Should SP_EL1, ELR_EL1, and SPSR_EL1 be reset in the shared helpers instead
of only in host kvm_reset_vcpu()?

For pKVM protected VMs, flush_hyp_vcpu() does not copy host_vcpu->arch.ctxt
into hyp_vcpu->vcpu.arch.ctxt.  Instead, on PSCI CPU_ON,
handle___kvm_vcpu_run() calls pkvm_reset_vcpu() at EL2:

arch/arm64/kvm/hyp/nvhe/pkvm.c:pkvm_reset_vcpu() {
	...
	kvm_reset_vcpu_core(&hyp_vcpu->vcpu);
	kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);

	/* Must be done after resetting sys registers. */
	kvm_reset_vcpu_psci(&hyp_vcpu->vcpu, reset_state);
	...
}

Because neither kvm_reset_vcpu_core() nor pvm_sys_reg_reset_vals[] resets
SP_EL1, ELR_EL1, or SPSR_EL1, a protected vCPU that cycles through PSCI
CPU_OFF and CPU_ON re-enters in PSR_MODE_EL1h with stale SP_EL1, ELR_EL1,
and SPSR_EL1 values.  Resetting *vcpu_sp_el1(vcpu) =3D 0 in
kvm_reset_vcpu_core() (which also covers arch/s390/kvm/arm64/reset.c) and
ensuring ELR_EL1 and SPSR_EL1 are reset for pvm_sys_reg_reset_vals[] as
well would keep all vCPU reset paths consistent.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125-double_exc=
eption-v2-0-224689d8a764@pereq.eu?part=3D2
