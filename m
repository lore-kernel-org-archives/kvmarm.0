Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792793793;
	b=D7Cnyu/ayXf1+B/gdjz7le/RPU01gUDm0G651TE19etJMSaSTQAt1JICU+Jz0L1ewC2d
	 E0WRFg/PicmKcuN9yE3ELLrjjQ3GJQi9fCNAUdFfn4Zi2vft98jTCmb1Y+m0z8Sypz/e0
	 yax4pdpcDbMazivK66bvO5cSrJjM+DEM4rleyKoKe0G3jmSSPKzU0sAp14dMiz43n1rmx
	 4SwNaCEBxw4H+sT7GKf49xTCHZq2QdatwItwwJH636678QksV2ndVaR8dzBVH0FKuU3Rd
	 lFFFe8og+q5aghMWP2ROgCkUDF8wNPTT0NPZaAYZZR+knuVtObWOpUxEdVSHCFcdxwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792793793;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rLFIoWXSyzLkSt+yREs60vNWFw3E1YH3TLGs1lB02jk=;
	b=tR3ofWERFkd1Cvgz7HaqOjYXmAtaaJ5zavp1D7k5WILwLStHdKtQG9aXvq1UVB5u0dKS
	 DUje7mNENDRDZ4C6CaIL9XQto9pMdP2YJqcqsVdxhm6w17WrMK2PGWQMDqTEdsfNRLID2
	 WZKbQKJEmuRtztCROxvHZXuON7letY5yUBpXc5NzzvgnLR8dp3oZgFY1tjktK5jv0RREA
	 MBuJCErDJq8SAVqLm70YHl2DCHuEOrGvgFMZc86+z+7fiMBwRTPydJVcRQsBsDpmGdbAn
	 xNe7jd2LdTsiPXDHymh+7syK9sHRzPkHqRNu4LqH9bbakjWL7UdkvPApeCLoMWzVcIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dKwGdeCb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D043606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 22:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dKwGdeCb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8541F01825;
	Fri, 23 Oct 2026 22:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792793792;
	bh=rLFIoWXSyzLkSt+yREs60vNWFw3E1YH3TLGs1lB02jk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dKwGdeCb+/zepwXIrG0Rqjg+gfY1Qj8pRznzD5tlpzERm8e7eUovVST7jDOBOmU8g
	 kutJtKjb/NFyCEiFecarpi+TGuf9GYfSCS5k1VJMssKckKRKDiwN4fbLO/WHhQ10OD
	 Fx+mKYf4ntfn+YjEEp7r+xozjFjjknf8erFOGGBcIpenmjM5D9fac2pQqQmwyso7+K
	 jHWvSjRlcSzcJmQ3AeQleDJBhgJyOcxShwjQGo2/JjgqBqbBJAMtDIHUSXIL5T80sY
	 RV6moxrzWnYzwHGG5Kb7bD9IDwsW9Vx6rENXgrBFrJWYBbmw7FCKuAbF0jWvn34FDa
	 6DBnr0ChboTaw==
Message-ID: <sashiko-outbox-183282@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] irqchip/gic-v4: Use a separate lockdep class for vPE
 doorbell IRQs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261023215207.1465369-1-coltonlewis@google.com>
References: <20261023215207.1465369-1-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 22:16:32 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] irqchip/gic-v4: missing IRQ_NOTHREAD in its_alloc_vcpu_irqs() caus=
es deadlock
--

commit 3b1ba3145da23221937683b56baa88615a91fb69
Author: Colton Lewis <coltonlewis@google.com>

irqchip/gic-v4: Use a separate lockdep class for vPE doorbell IRQs

This commit assigns a dedicated lockdep class to GICv4 vPE doorbell IRQs in
its_alloc_vcpu_irqs() to avoid a circular locking dependency between
rq->__lock and the shared irq_desc_lock_class when scheduling out a KVM
vCPU.

> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index 8455b4a5fbb0d..68ee288f6a076 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -157,6 +157,8 @@ static int its_alloc_vcpu_sgis(struct its_vpe *vpe, i=
nt idx)
> =20
>  int its_alloc_vcpu_irqs(struct its_vm *vm)
>  {
> +	static struct lock_class_key vpe_irq_lock_class;
> +	static struct lock_class_key vpe_irq_request_class;
>  	int vpe_base_irq, i;
> =20
>  	vm->fwnode =3D irq_domain_alloc_named_id_fwnode("GICv4-vpe",
> @@ -183,6 +185,8 @@ int its_alloc_vcpu_irqs(struct its_vm *vm)
>  	for (i =3D 0; i < vm->nr_vpes; i++) {
>  		int ret;
>  		vm->vpes[i]->irq =3D vpe_base_irq + i;
> +		irq_set_lockdep_class(vm->vpes[i]->irq, &vpe_irq_lock_class,
> +				      &vpe_irq_request_class);

[Severity: High]
Can vpe->irq still establish a vpe_irq_lock_class -> p->pi_lock ->
rq->__lock dependency and deadlock when forced IRQ threading is active (via
the threadirqs boot parameter or CONFIG_PREEMPT_RT=3Dy)?

Neither its_alloc_vcpu_irqs() / its_vpe_irq_domain_alloc() nor DB_IRQ_FLAGS
sets IRQ_NOTHREAD, and vgic_v4_request_vpe_irq() in
arch/arm64/kvm/vgic/vgic-v4.c requests the interrupt without IRQF_NO_THREAD:

int vgic_v4_request_vpe_irq(struct kvm_vcpu *vcpu, int irq)
{
	return request_irq(irq, vgic_v4_doorbell_handler, 0, "vcpu", vcpu);
}

Because arm64 unconditionally selects IRQ_FORCED_THREADING, when
force_irqthreads() is enabled, __setup_irq() -> irq_setup_forced_threading()
converts vgic_v4_doorbell_handler into a threaded handler and creates
action->thread for vpe->irq.

While IRQ_NO_BALANCING blocks userspace affinity changes, vgic_v4_load() in
arch/arm64/kvm/vgic/vgic-v4.c directly updates the affinity on vcpu_load():

	err =3D irq_set_affinity(vpe->irq, cpumask_of(smp_processor_id()));

This acquires vpe->irq's desc->lock (vpe_irq_lock_class) and calls
irq_set_affinity_locked() -> irq_try_set_affinity() -> irq_do_set_affinity(=
).
After its_vpe_set_affinity() returns IRQ_SET_MASK_OK_DONE,
irq_do_set_affinity() invokes irq_set_thread_affinity() in
kernel/irq/manage.c while still holding desc->lock:

	for_each_action_of_desc(desc, action) {
		if (action->thread) {
			set_bit(IRQTF_AFFINITY, &action->thread_flags);
			wake_up_process(action->thread);
		}

Calling wake_up_process() under desc->lock acquires p->pi_lock and
rq->__lock under vpe_irq_lock_class (as does __irq_wake_thread() when the
doorbell interrupt fires). When a resident vCPU is later scheduled out,
__schedule() holds rq->__lock and calls kvm_sched_out() ->
kvm_arch_vcpu_put() -> vgic_v3_put() -> vgic_v4_put() ->
its_make_vpe_non_resident() -> irq_set_vcpu_affinity(), acquiring
vpe_irq_lock_class under rq->__lock.

Should vPE doorbell IRQs also be marked with IRQ_NOTHREAD (or requested with
IRQF_NO_THREAD) so they are never force-threaded?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023215207.1465=
369-1-coltonlewis@google.com?part=3D1
