Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654231;
	b=qb5QxD5CwXX2kUS+rxI5BXd7wYy+qYpcYxx0Jf1CMuXViF39RA+/7EolqnWHDIUuaoBs
	 L0itkyD0Ph6ByWtv5/BnITwygnEFZacofE+IezODE60TXOi/Dcn/ebkqbNMRLbtx8Z1+i
	 h4BWWx0RKRHceEPuYytuD5btoryB5y50pLZdVKIXuvGU3/M8wQkDrgWInRB0q5r5MiBt1
	 uicH0oKxvfygshEFE/XpS7xYn3qBlf4UUVgY5R28zynZeKt6myhyvLSRz2F9I6qZf2nib
	 rzMsyw+WSBYnMdCCoix5A8dye/06bpb35qHCSgFHx0MUoXpIuc84Etik/J1nozwjSFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654231;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xg0Hmc9WjDODyegDoJutnIFb7L7GGDsGX7TLmjShcJE=;
	b=1OzBfgTAEZqSY8XT98dQN6xhSBaGcCIw5wxpOvbVlVv3qVkGifzgOXr/98EkoeiC7320
	 TlzQzPCTLmuLZwVi2JGQJ+JNFJNqaW5H8NpgcgTjzariplmh/b3tA+QHh+R72QswFwkd6
	 sJqBg98gmnBQzPCA1pf3qwG2o4yNNM5YQqz7zr50/Evlxa0N3rRezvpS3AloQQNRDe0CO
	 r/aRMs/3jJm5gr8e/BqDnClcdkDRoI7SImKW0dmCDp5OsnOhIhJbH2FCgd6tRoirqxUI+
	 CiS9onz1MNmsrIbw4v89tzCQ1E86MJYSCtNJ/Cll31oa7fREm7u2h2L4TBMBOWbUGzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mrGqEAZL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D35606A327;
	Mon,  2 Nov 2026 21:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mrGqEAZL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA231F00A16;
	Mon,  2 Nov 2026 21:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654230;
	bh=xg0Hmc9WjDODyegDoJutnIFb7L7GGDsGX7TLmjShcJE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mrGqEAZLbcw4qI03o7BkeAD4d9KCHi/u6IO5tEOVrX1sMVQAFJVgBqzR27xZS8+Xc
	 KWjtFTqrsOBa/OCHRZ0sXT+8Vm3krID/5YTXFZhst5lTlOWxROLISXIk4K7RFJ1YoQ
	 PuibKD89ZIHL7Q7sXQiNcDsZDy5EB2PuikQ+MOTl0TDdd0WKuSABzgl2wLy5MZzyw6
	 j7USlJ8186yfmkgAYHmBdtDcxWQi1mMdXnahFDLaN+yvgsnxAOkhlv0hQg6JQt73An
	 lAwtx2kL/bhBZNC091RXSmTgHDCLGYRAFYqECjxOJapsuzgRkC4YWj/2afEwxNYO+K
	 PhVUtCSB9k9iA==
Message-ID: <sashiko-outbox-194187@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 13/16] KVM: arm64: gic-v5: Implement irq forwarding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102194454.4086911-14-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-14-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 21:17:09 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] KVM: arm64: gic-v5: sleep in atomic context when disabling direct =
injection
- [High] KVM: arm64: gic-v5: stale host_irq and leaked LPI on unforward fai=
lure
- [High] KVM: arm64: gic-v5: unserialized physical ITS MMIO in gicv5_its_it=
t_cache_inv()
- [Low] KVM: arm64: gic-v5: unused VGIC_V5 check in vgic_supports_direct_ms=
is()
--

commit deaf3d7036edf849d625db99977af89a6c3e3411
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: gic-v5: Implement irq forwarding

This commit implements direct interrupt injection (IRQ forwarding) for GICv5
via the ITS, placing the GICv4 and GICv5 forwarding hooks behind common
kvm_vgic_set_forwarding() and kvm_vgic_unset_forwarding() shims. It also
tracks the translation cache entry that owns forwarding on each LPI and uses
access_remote_vm() when resolving guest DT/ITT entries from another
process's address space.

> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic=
-its-v5.c
> index 638ee47f6e27d..3648d3f7c1b29 100644
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
> @@ -38,7 +39,35 @@ static void its_cache_drop_translation(struct kvm *kvm,
>  				       struct its_cache_translation_entry *entry)
>  {
>  	struct vgic_irq *irq =3D entry->irq;
> +	unsigned long flags;
> +	bool drop_forwarding_ref =3D false;
> =20
> +	/*
> +	 * Multiple translations can share an LPI as we have no way of stopping
> +	 * the guest from doing so. Only the entry associated with direct injec=
tion
> +	 * may tear down the IRQ's forwarding state, as otherwise we can end up
> +	 * accidentally tearing something down. Realistically, this only would
> +	 * result in a performance degradation, but we might as well avoid that
> +	 * in the first place if we can.
> +	 *
> +	 * Keep the lock until the host IRQ is restored, so the producer cannot
> +	 * free it while we are using its IRQ number.
> +	 */
> +	raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +	if (irq->forwarding_owner =3D=3D entry) {
> +		/* The entry is about to be freed, even if unforwarding fails. */
> +		irq->forwarding_owner =3D NULL;
> +		if (irq->hw &&
> +		    !WARN_ON_ONCE(gicv5_its_disable_direct_injection(irq->host_irq))) {
> +			irq->hw =3D false;
> +			irq->host_irq =3D 0;
> +			drop_forwarding_ref =3D true;
> +		}
> +	}
> +	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);

[Severity: High]
Can calling gicv5_its_disable_direct_injection() here and in
kvm_vgic_v5_unset_forwarding() sleep in atomic context?

Both its_cache_drop_translation() and kvm_vgic_v5_unset_forwarding() hold
raw_spin_lock_irqsave(&irq->irq_lock, flags) (and
kvm_arch_update_irqfd_routing() -> kvm_vgic_unset_forwarding() is also
invoked under spin_lock_irq(&kvm->irqfds.lock)). The call chain is:

  gicv5_its_disable_direct_injection()
    -> irq_set_vcpu_affinity(virq, NULL) [acquires desc->lock raw_spinlock]
      -> gicv5_its_set_vcpu_affinity(d, NULL)
        -> gicv5_irs_syncr()
          -> gicv5_wait_for_op(..., GICV5_IRS_SYNC_STATUSR,
                               GICV5_IRS_SYNC_STATUSR_IDLE)

In drivers/irqchip/irq-gic-v5-irs.c, gicv5_irs_syncr() uses the sleeping
gicv5_wait_for_op() macro (which expands to readl_poll_timeout() with a 1 us
sleep and calls might_sleep() and usleep_range()) rather than
gicv5_wait_for_op_atomic().

Should gicv5_irs_syncr() use gicv5_wait_for_op_atomic() since it is called
under desc->lock and irq->irq_lock?

[ ... ]

> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-m=
mio.c
> index 3c0c858608752..3268e3d3d5170 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
> @@ -1144,6 +1144,8 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t=
 dist_base_address,
> =20
>  bool vgic_supports_direct_msis(struct kvm *kvm)
>  {
> +	const struct vgic_dist *dist =3D &kvm->arch.vgic;
> +
>  	/*
>  	 * Deliberately conflate vLPI and vSGI support on GICv4.1 hardware,
>  	 * indirectly allowing userspace to control whether or not vPEs are
> @@ -1152,7 +1154,13 @@ bool vgic_supports_direct_msis(struct kvm *kvm)
>  	if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(kvm))
>  		return false;
> =20
> -	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
> +	if (kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm))
> +		return true;
> +	if (kvm_vgic_global_state.type =3D=3D VGIC_V5 && vgic_has_its(kvm) &&
> +	    dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
> +		return true;
> +
> +	return false;
>  }

[Severity: Low]
This isn't a bug, but is the new VGIC_V5 check in vgic_supports_direct_msis=
()
ever reached?

In arch/arm64/kvm/vgic/vgic.h, vgic_supports_direct_irqs() already returns
true early when vgic_is_v5(kvm) is true before calling
vgic_supports_direct_msis(kvm). The only other callers of
vgic_supports_direct_msis() are kvm_vgic_v4_set_forwarding() and
kvm_vgic_v4_unset_forwarding(), whereas kvm_vgic_v5_set_forwarding() and
kvm_vgic_v5_unset_forwarding() check !vgic_has_its(kvm) directly.

Should kvm_vgic_v5_set_forwarding() and kvm_vgic_v5_unset_forwarding() (or
the common kvm_vgic_set_forwarding() and kvm_vgic_unset_forwarding() shims)
call vgic_supports_direct_msis(kvm) instead of vgic_has_its(kvm)?

[ ... ]

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 18184020e188b..c2ae7b0fb3a7f 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -1635,3 +1635,151 @@ unsigned long vgic_v5_handle_guest_coresight_idre=
g_read(u32 offset)
> +int kvm_vgic_v5_set_forwarding(struct kvm *kvm, int virq,
> +			       struct kvm_kernel_irq_routing_entry *irq_entry)
> +{

[ ... ]

> +	ret =3D gicv5_its_enable_direct_injection(virq, vgic_v5_vm_id(kvm),
> +						vgic_v5_get_hwirq_id(irq->intid));

[Severity: High]
What serializes concurrent physical ITS MMIO register accesses in
gicv5_its_itt_cache_inv() when forwarding or unforwarding interrupts?

Enabling and disabling direct injection calls:

  gicv5_its_enable_direct_injection() / gicv5_its_disable_direct_injection()
    -> irq_set_vcpu_affinity() [locks per-IRQ desc->lock]
      -> gicv5_its_set_vcpu_affinity()
        -> gicv5_its_itt_cache_inv()

In drivers/irqchip/irq-gic-v5-its.c, gicv5_its_itt_cache_inv() writes the
shared physical ITS registers and waits for completion without a per-ITS lo=
ck
in struct gicv5_its_chip_data:

	its_writeq_relaxed(its, didr, GICV5_ITS_DIDR);
	its_writel_relaxed(its, eidr, GICV5_ITS_EIDR);
	its_writel_relaxed(its, eventr, GICV5_ITS_INV_EVENTR);

	return gicv5_its_cache_sync(its);

Because irq_set_vcpu_affinity() only holds the per-IRQ desc->lock and
kvm_vgic_v5_unset_forwarding() only holds the per-LPI irq->irq_lock (without
its->its_lock), two CPUs forwarding, unforwarding, or invalidating different
IRQs on the same physical ITS (within the same VM, across VMs, or racing wi=
th
host gicv5_its_map_event() / gicv5_its_unmap_event()) can interleave writes
to GICV5_ITS_DIDR and GICV5_ITS_EIDR before GICV5_ITS_INV_EVENTR is written.

Could one CPU overwrite GICV5_ITS_DIDR or GICV5_ITS_EIDR so that the physic=
al
ITS invalidates the wrong DeviceID/EventID entry while gicv5_its_cache_sync=
()
still sees GICV5_ITS_STATUSR_IDLE and returns success, leaving a stale
virtual or host ITTE cached in the physical ITS?

> +	if (ret) {
> +		if (ret !=3D -ETIMEDOUT) {
> +			vgic_put_irq(kvm, irq);
> +			return 0;
> +		}

[ ... ]

> +void kvm_vgic_v5_unset_forwarding(struct kvm *kvm, int virq)
> +{
> +	struct vgic_irq *irq;
> +	bool drop_forwarding_ref =3D false;
> +
> +	if (!vgic_has_its(kvm))
> +		return;
> +
> +	/*
> +	 * Note: We don't remove the entry from our translation cache here. It
> +	 * is up to the guest to invalidate the old translations, and hence the
> +	 * removal path is tied into ITS_INV_DEVICER and ITS_INV_EVENTR, rather
> +	 * than being explicitly called here.
> +	 */
> +	irq =3D vgic_v5_host_irq_get_lpi(kvm, virq);
> +	if (!irq)
> +		return;
> +
> +	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
> +		if (irq->hw && irq->host_irq =3D=3D virq &&
> +		    !WARN_ON_ONCE(gicv5_its_disable_direct_injection(virq))) {
> +			irq->hw =3D false;
> +			irq->host_irq =3D 0;
> +			irq->forwarding_owner =3D NULL;
> +			drop_forwarding_ref =3D true;
> +		}
> +	}
> +
> +	if (drop_forwarding_ref)
> +		vgic_put_irq(kvm, irq);
> +
> +	vgic_put_irq(kvm, irq);
> +}

[Severity: High]
If gicv5_its_disable_direct_injection(virq) fails in
kvm_vgic_v5_unset_forwarding(), can a subsequent cache eviction operate on a
freed or reallocated host Linux IRQ number, or leak the LPI and reuse the VM
ID at teardown?

1. kvm_arch_irq_bypass_del_producer() returns void to __disconnect() in
   virt/lib/irqbypass.c, so producer unregistration cannot be aborted when
   gicv5_its_disable_direct_injection(virq) fails. Once
   irq_bypass_unregister_producer() returns, the producer (e.g. VFIO) tears
   down and frees virq, which can then be reallocated to another device.
   Because irq->forwarding_owner, irq->hw, and irq->host_irq remain set her=
e,
   a later guest invalidation or vgic_v5_its_destroy() ->
   its_cache_clear_translations() -> its_cache_drop_translation() will call
   gicv5_its_disable_direct_injection(irq->host_irq) on that freed or
   reallocated virq.

2. Similarly, if kvm_arch_update_irqfd_routing() calls
   kvm_vgic_unset_forwarding() when an irqfd routing entry changes from
   KVM_IRQ_ROUTING_MSI to a non-MSI type and
   gicv5_its_disable_direct_injection() fails, a subsequent
   kvm_arch_irq_bypass_del_producer() sees irq_entry->type !=3D
   KVM_IRQ_ROUTING_MSI and returns early without retrying
   kvm_vgic_unset_forwarding().

3. If gicv5_its_disable_direct_injection() fails in both
   its_cache_drop_translation() and kvm_vgic_v5_unset_forwarding(),
   drop_forwarding_ref is never set. When the VM is destroyed,
   kvm_vgic_dist_destroy() runs xa_destroy(&dist->lpi_xa) and leaks the
   struct vgic_irq, while vgic_v5_teardown() unconditionally calls
   vgic_v5_release_vm_id(kvm) even though a physical ITS virtual ITTE may
   still reference that VM ID.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102194454.4086=
911-1-sascha.bischoff@arm.com?part=3D13
