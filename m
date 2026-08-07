Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695492F1FDF;
	Fri,  7 Aug 2026 14:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786112233; cv=none; b=Y9DpMI0yPqk+Kh1hrohCmi4zjpp5tU+Nt4h46xyGmHdPgVgoU9fz93kMRE9QxXIbkytcY5n4r7zK88oC65XwQIJqGinIa6R/A16CjF/ZPnuSzx/oj4S5SmP0qL0Sv8cupkeF6LmF1aUAUVEX6DXemAFxWmkjSsh2EzY/nDdd9js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786112233; c=relaxed/simple;
	bh=XDeRwMr/Z+mnZAZl+VL6JCojG8uOz3rB5iaNkL+R28M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H+iDfY7nL7kFGLlkMCrchDCmu1jVj2gw50H4xQUlBNkyLvvm+zZZLOwwVCwFtoJf5P3g5mA6Kj4gqn3dL0FynuDpWzJR7VjwJd18D4xIVEhmNh5PKSHw3KDxoAroHQkz68DEyJvTO6CJ8eEenaZlFCacV1Arbs1q8PfRFAp5ClA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fz+n4Nol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fz+n4Nol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4925A1F000E9;
	Fri,  7 Aug 2026 14:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786112229;
	bh=NkCVI9sbm0zg72yQOQ9pIeFu6F31jlko3bKb8CUSgII=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fz+n4NollQ0lYROaEx3dWLKokG7aJddz7Fx74tMAv4RioluAYgxMkZdiCC0MdUmtC
	 tDF5eY/WvZFUpeczYdcbDNPA01izeaNW9pHmpn8gkNzU4nlVhCDfDdVZaQPlCmZkQ6
	 9a3OuN+PO8xeBDBayCU54IMyhvjxrcneU/0sNOlIE1JP57RT0Q6AB2iq1iY57WpfgK
	 wxSk58zLm5Uf2CMS9j58qgY1WcB73UxIZ44WDzH1kjbtQKqxgxMSUFYBXIYrC5YfLu
	 5ywZY/DK9DdJhDUmDiP75tjmvFuXmfOm11aXZX3yow1c0hJjCxKkbqSGuwM2rIdb6t
	 K9TVa25IV8i7A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 16/49] KVM: arm64: gic-v5: Request doorbells when
 VPEs enter WFI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260807111159.429128-17-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-17-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 14:17:08 +0000
Message-Id: <20260807141709.4925A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] ABBA deadlock between `rq_lock` and `desc->lock` in `vgic_v5_put` =
via `irq_set_affinity`.
- [High] Stale `db_fired` state causes infinite VMEXIT loops upon subsequen=
t WFIs.
- [High] Guest-reachable WARN_ON due to host-side `irq_set_affinity` failur=
es.
--

--- Patch [16]: [PATCH v5 16/49] KVM: arm64: gic-v5: Request doorbells when=
 VPEs enter WFI ---
commit c40948b426a64dc48dae28e60304e7f29600ab3c
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI

When a GICv5 VPE is made non-resident as part of the vcpu entering
WFI, request a VPE doorbell so that KVM can be notified when a
suitable SPI or LPI becomes pending for that VPE.

> diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5=
-sr.c
> --- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
> @@ -22,6 +22,15 @@ void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cp=
u_if)
> =20
>  void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if)
>  {
> +	/*
> +	 * Clear the db_fired state to ensure that we're ready for the next
> +	 * doorbell when it is requested. If a doorbell firing caused us to
> +	 * enter the guest, then we've already consumed that state at this
> +	 * point, so this is safe to clear. Use WRITE_ONCE() to ensure we're not
> +	 * racing with the doorbell firing and setting the state true again.
> +	 */
> +	WRITE_ONCE(cpu_if->gicv5_vpe.db_fired, false);

[Severity: High]
Will this state management regression leave the db_fired state stale for
back-to-back WFIs?

Since __vgic_v5_make_non_resident() is called from vgic_v5_put(), which is
invoked upon host preemption or user exit (but not standard guest re-entry
after kvm_vcpu_block), db_fired appears to remain true when the guest resum=
es.

If the guest executes WFI again, kvm_vcpu_check_block() checks
kvm_vgic_vcpu_pending_irq() in arch/arm64/kvm/vgic/vgic.c and observes
db_fired is still true, which causes it to instantly abort blocking. This
could result in the guest continuously spinning in VMEXITs.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> @@ -1099,6 +1099,46 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
[ ... ]
> +			/*
> +			 * Make the doorbell affine to this CPU, if it isn't
> +			 * already. Actively check the cpumask first as it is
> +			 * cheaper than changing the affinity every time.
> +			 */
> +			if (!cpumask_test_cpu(cpu, aff))
> +				WARN_ON(irq_set_affinity(db_irq, cpumask_of(cpu)));

[Severity: High]
Does this introduce an ABBA deadlock regression between rq_lock and desc->l=
ock?

When a guest vCPU thread is preempted or enters WFI, the host scheduler's
__schedule() holds the runqueue lock (rq_lock) while calling
prepare_task_switch(). This triggers the sched_out preempt notifier, taking
us through kvm_sched_out() -> kvm_arch_vcpu_put() -> kvm_vgic_put() and
finally to vgic_v5_put().

Inside vgic_v5_put(), irq_set_affinity() acquires the hardware interrupt
descriptor lock (desc->lock). Taking desc->lock while already holding
rq_lock violates the locking hierarchy where desc->lock must be acquired
before rq_lock.

[Severity: High]
Can a guest trigger this WARN_ON regression to cause a host denial of servi=
ce?

Calls to irq_set_affinity() can legitimately fail and return negative error
codes due to hardware constraints (such as ITS socket-crossing limitations)
or resource exhaustion.

Since the guest controls when it executes WFI, it can reliably trigger this
WARN_ON if the host scheduler places it on a restricted CPU. If panic_on_wa=
rn
is enabled, this allows the guest to crash the host.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D16
