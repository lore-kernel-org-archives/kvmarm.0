Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B769527589;
	Fri, 16 Oct 2026 16:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167920; cv=none; b=m6OKXbwYEGLCpehdH3h4u9l0fGM4CEvYSFJMJx/srG5XjiJyt0LQcJIUpFW7n4UOfMv4C/+doZ840LUwG9BITor3zArm/JQHyRzrV+vkE8ihqqmMTOIyC9+OyAOPu5Mhn+F3m9xtqo4FyQFBTVW6Rv67qXVO0N8+Ui6ps+YXKMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167920; c=relaxed/simple;
	bh=2z1qfSmRmxhunYXaPTTjHCWA8JU3k4FO1Vbo6rNGLqg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=cp03Y461ayLWAabyKTjgOHzmwYWZpeyH4Q+WH2851ttAvH3DTL6faUed1iG8SxUvpUdDVxarqXsyZBV11Wap3PicFCwOjeH/FlcP46GLdx26ae5sbiXiTu1Q6UUiO7Fj23Vq7YAxBBH/wUtW/g0/b9WXgche7ZkDjY3K04YrD7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VJpNB5J+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VJpNB5J+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE0D1F000C4;
	Fri, 16 Oct 2026 16:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167917;
	bh=rmtHfJ1A3a0HjIqKluOkNBPy2VOvNJiiiOG5FECWDtE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VJpNB5J+a+rZTBTEeeI4GVAIvIqudvJisL/ug9QK/jJ8ZObNNVa9JlcKdQiyYBAVu
	 Qh03mmKQIEyG1UlW0TtAzkIKkdAKJ7gooPSpTkafh58c+sCTdltLAkJTIdeI6na4Rz
	 CkUzEPYXOKsRRjYe40xcUpSDvMMjSoVhuSqaKc4a6ZjxCyB52CkqOE6QqPyDQsijdo
	 MeyFh14VP6phhZT9Op8t0I+xfP3HCi8j26wXiCmTwZK4rGU6cjEg5zcETXxanEiq0l
	 6pnj56AlCk8sPq7MkJ9POLNQeZijv4k3GjaaN1ukvDDnrDuNlhjxJ+I0Poey0wyGUH
	 QdaofAl6aTtJA==
Message-ID: <sashiko-outbox-174635@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 13/16] KVM: arm64: gic-v5: Implement irq forwarding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261016155741.979985-14-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-14-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 16:25:17 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] kvm: passing full typed INTID to hardware VDPEND instruction
- [High] kvm: use of undefined macro kzalloc_obj
- [High] kvm: ABBA deadlock due to translation_cache_lock acquired without =
disabling IRQs
- [High] kvm/vgic: TOCTOU race in its_cache_drop_translation disables wrong=
 host IRQ
- [Medium] kvm: data race from lockless read of irq->hw bitfield
- [Low] cleanup: mixing goto-based cleanup with guard() declarations
--

commit 3a376f5ffceb9df2e3023c6def306e4b00a9eba1
Author: Sascha Bischoff <sascha.bischoff@arm.com>

    KVM: arm64: gic-v5: Implement irq forwarding

    GICv5, like GICv4, supports direct injection of interrupts via the
    ITS. Move the existing GICv4 interface behind a common shim that selects
    the appropriate implementation. For GICv5 forwarding, the ITS driver
    replaces a host ITTE with one targeting a guest. The host no longer
    receives that interrupt until forwarding is removed and the host ITTE is
    restored.

> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic=
-its-v5.c
> index 62c1ca8004007..e71cd67652bae 100644
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
[ ... ]
> @@ -31,7 +32,41 @@ static void its_cache_drop_translation(struct kvm *kvm,
>  				       struct its_cache_translation_entry *entry)
>  {
>  	struct vgic_irq *irq =3D entry->irq;
> +	unsigned long flags;
> +	int virq =3D 0;
> +	bool hw =3D false;
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
> +	 */
> +	raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +	if (irq->forwarding_owner =3D=3D entry) {
> +		/* The entry is about to be freed, even if unforwarding fails. */
> +		irq->forwarding_owner =3D NULL;
> +		virq =3D irq->host_irq;
> +		hw =3D irq->hw;
> +	}
> +	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +
> +	if (hw && !WARN_ON_ONCE(gicv5_its_disable_direct_injection(virq))) {

[Severity: High]
Is there a TOCTOU race here when the lock is dropped before calling=20
gicv5_its_disable_direct_injection?=20

While the lock is released, a concurrent host unbind operation could invoke=
=20
irq_bypass_del_producer, unset the forwarding, and free the host IRQ. The L=
inux
IRQ number could then be immediately reallocated to a different device. Whe=
n=20
this thread resumes, it would unconditionally disable hardware direct injec=
tion=20
for the newly assigned device/VM using the stale virq identifier, potential=
ly=20
causing lost interrupts.

> +		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +		if (irq->hw && irq->host_irq =3D=3D virq &&
> +		    !irq->forwarding_owner) {
> +			irq->hw =3D false;
> +			irq->host_irq =3D 0;
> +			drop_forwarding_ref =3D true;
> +		}
> +		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +	}
[ ... ]
> @@ -50,7 +85,8 @@ static void its_cache_drop_removed_translations(struct =
kvm *kvm,
> =20
>  static int its_cache_add_translation(struct kvm *kvm, struct vgic_v5_its=
 *its,
>  				     u32 device_id, u16 event_id,
> -				     struct vgic_irq *irq)
> +				     struct vgic_irq *irq,
> +				     void **owner)
>  {
>  	u64 key =3D ((u64)device_id << 16) | (u64)event_id;
>  	struct its_cache_translation_entry *entry;
> @@ -78,6 +114,8 @@ static int its_cache_add_translation(struct kvm *kvm, =
struct vgic_v5_its *its,
> +	struct its_cache_translation_entry *old;
> +	struct hlist_node *tmp;
> +	HLIST_HEAD(removed);
>=20
> -	entry =3D kzalloc(sizeof(*entry), GFP_KERNEL);
> +	entry =3D kzalloc_obj(*entry, GFP_KERNEL);

[Severity: High]
Is kzalloc_obj defined anywhere in the tree? It looks like this might be a=
=20
typo for kzalloc(sizeof(*entry), GFP_KERNEL) which will cause compilation=20
failures.

>  	if (!entry)
>  		return -ENOMEM;
> =20
>  	entry->key =3D key;
>  	entry->irq =3D irq;
> =20
> -	raw_spin_lock(&its->translation_cache_lock);
> +	scoped_guard(raw_spinlock, &its->translation_cache_lock) {

[Severity: High]
Should this use the irqsave variant of scoped_guard? Acquiring=20
translation_cache_lock in process context without disabling local hardware=
=20
interrupts could lead to an ABBA deadlock. If irqfd_wakeup runs in HardIRQ=
=20
context on a CPU that already holds this lock, the interrupt handler might=
=20
spin forever trying to acquire it.

>  		hash_for_each_possible_safe(its->translation_cache, old, tmp,
>  					    node, key) {
>  			if (old->key =3D=3D key) {
[ ... ]
> @@ -129,7 +167,8 @@ static void its_cache_clear_translations(struct vgic_=
v5_its *its)
> =20
>  static int its_cache_look_up_translation(struct vgic_v5_its *its,
>  					 u32 device_id, u16 event_id,
> -					 struct vgic_irq **irq)
> +					 struct vgic_irq **irq,
> +					 void **owner)
>  {
>  	u64 key =3D ((u64)device_id << 16) | (u64)event_id;
>  	struct its_cache_translation_entry *entry;
>=20
> -	raw_spin_lock(&its->translation_cache_lock);
> +	guard(raw_spinlock)(&its->translation_cache_lock);

[Severity: High]
Similarly here, acquiring translation_cache_lock without disabling interrup=
ts=20
leaves the system vulnerable to the same ABBA deadlock if the lock is=20
contended by HardIRQ context.

>  	hash_for_each_possible(its->translation_cache, entry, node, key) {
>  		if (entry->key =3D=3D key) {
[ ... ]
> @@ -657,8 +735,8 @@ int vgic_v5_its_inject_cached_translation(struct kvm =
*kvm, struct kvm_msi *msi)
>  static void vgic_v5_its_inject_lpi(struct kvm *kvm, struct vgic_irq *irq)
>  {
>  	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, true,
>  		     kvm->arch.vgic.gicv5_vm.vm_id);
>  }

[Severity: High]
Does this pass the full typed INTID directly to the hardware GIC VDPEND=20
instruction?=20

GICv5 INTIDs encode the type in bits [31:29]. The architecture limits hardw=
are=20
instructions to expecting a raw hardware ID. Should this be masked using=20
vgic_v5_get_hwirq_id(irq->intid) to avoid feeding the type bits into the=20
hardware operand?

[ ... ]
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index c90e00f56b298..970df3f41cf24 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> +int kvm_vgic_v5_set_forwarding(struct kvm *kvm, int virq,
> +			       struct kvm_kernel_irq_routing_entry *irq_entry)
> +{
> +	struct vgic_v5_its *its_data;
> +	struct vgic_irq *irq;
> +	void *owner;
> +	bool hw;
> +	int ret;
> +
> +	if (!vgic_has_its(kvm))
> +		return 0;
> +
> +	/* Look up the ITS; bail out if we can't look it up */
> +	its_data =3D vgic_v5_get_its(kvm, irq_entry);
> +	if (IS_ERR(its_data))
> +		return 0;
> +
> +	/*
> +	 * Look up and cache the translation. Bail out if we failed to look up
> +	 * the translation at this stage. If the translation becomes valid at a
> +	 * later stage, we should fall back to software-based injection.
> +	 */
> +	guard(mutex)(&its_data->its_lock);
> +
> +	ret =3D vgic_v5_its_resolve_lpi_locked(kvm, its_data,
> +					     irq_entry->msi.devid,
> +					     irq_entry->msi.data, &irq, &owner);
> +	if (ret)
> +		return 0;
> +
> +	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
> +		hw =3D irq->hw;
> +	}
> +
> +	if (hw)
> +		goto out_put_irq;

[Severity: Low]
Does this mix goto-based error handling with scope-based cleanup helpers li=
ke=20
guard() and scoped_guard()? The kernel cleanup guidelines strongly discoura=
ge=20
mixing these in the same function to avoid confusing ownership semantics.=20
Should this function be standardized to use only one of the approaches?

[ ... ]
> +static struct vgic_irq *vgic_v5_host_irq_get_lpi(struct kvm *kvm, int ho=
st_irq)
> +{
> +	struct vgic_irq *irq;
> +	unsigned long idx;
> +
> +	guard(rcu)();
> +	xa_for_each(&kvm->arch.vgic.lpi_xa, idx, irq) {
> +		if (!irq->hw || irq->host_irq !=3D host_irq)
> +			continue;

[Severity: Medium]
Is it safe to locklessly read the irq->hw bitfield here?=20

This bitfield is modified concurrently by kvm_vgic_v5_set_forwarding and=20
kvm_vgic_v5_unset_forwarding under irq_lock. Concurrent read and write acce=
ss=20
to a C bitfield is undefined behavior and can result in torn reads or=20
corrupted data.

> +
> +		if (!vgic_try_get_irq_ref(irq))
> +			return NULL;
> +
> +		return irq;
> +	}
> +
> +	return NULL;
> +}
> +
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
> +	if (WARN_ON_ONCE(gicv5_its_disable_direct_injection(virq)))
> +		goto out_put_irq;
> +
> +	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {

[Severity: Low]
This is another instance of mixing goto-based error handling alongside=20
scoped_guard(). Should we convert this completely to scope-based cleanup or=
=20
stick entirely to traditional goto labels?

> +		if (irq->hw && irq->host_irq =3D=3D virq) {
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
> +out_put_irq:
> +	vgic_put_irq(kvm, irq);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016155741.9799=
85-1-sascha.bischoff@arm.com?part=3D13
