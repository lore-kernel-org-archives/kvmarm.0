Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793010824;
	b=BYzhwIeUoUe/oK2M99fZP9tNyy8AEaSPjoy7/cAXcO6eNu08DXAXphKmTdjZlcUcjPrt
	 obg6HjFxK/APwMFio7GTu9viugvx0wiH4acC0g9aPTZRGb4WsHeem+LRdwN1OfoWEDDLc
	 1/ZpgKLyYSPCJvG88DY/ThP2w6s42O4d5fB6dJU319rD2lUCHnsAjeM3q3yO2ONnQEyig
	 4n4p4CT/tQ0GIxI6sRXQPqSu6Sy3C2r1RXw/AxECsyqsL8vxWTiNiBXnRS4LxyX3ZIX1V
	 9sFgIkttTNk0NcYHF6ZqZvndjP9Q1W7brfl5feM9PIfz16EtNjAJsmHaskER2aaX7fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793010824;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=codivIgbZl7UJS8uokRy9UYat5bUEoobYqhUzGVImnc=;
	b=MBQnZeM9DJyB3FT90eE5ZEtR+DtarH+7kL6V6x44yEYlCcGPluYK14eDv6wM4hpS/wI+
	 A7NJpm62rKTsfKgeelHsfIs/lZNm9duL5XAAnVp0XZFJC4ZV/q53yUKtyb4pdGi0hyTUr
	 y39cdp7bXww0aKAngRj3YVttFXU8ZyYSDG6+AIuEzFLb3HumbmnPp4VCGsQc/Yb7FMJN6
	 tY3ZtLB+FShuNtRdVotkjt3hUAhUkf3veXKmucqR7cLLWA/FBJRMaMulMd9C1niT49YsI
	 OQKteAAYCBeKzqa4hL8Hb+sV1KhpWHd6BQ5rXrn8eGXUtk5LTlTAYWeuanchcmKKaoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="G/AFVdQy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D18A606A31B
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 10:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G/AFVdQy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23ED51F01828;
	Mon, 26 Oct 2026 10:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793010823;
	bh=codivIgbZl7UJS8uokRy9UYat5bUEoobYqhUzGVImnc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G/AFVdQy2OhcpOoyqpICY6pi1f0WqScpHa8X1Au+L69KBJBMFGN0/nAD6u2DZI1UG
	 vbYKs4/mSaipH7Dboc+OKeSMEbxbkO/hCnFsNrH20l+3WfQYsji7kRi7JrGgSsOCGk
	 uXSXj3VokY+qqmxArql6t/GJIRGooOqkKMQHrdQIssfxqGiI2ahdGLc64KEqpYmMuN
	 xtR92wKFE0rnmCOAuCVyhxktcEW1yj7n9z+b9vujliqcYgwY4MogIW1nxBSJh1aYWc
	 MAM5WqTOV6oDhBsYUSipN3tANmVJZyhXSyx+GGmfM1MhgijgU87PYBTWRg6FriSMiZ
	 TEJ9Q1yjuCqFA==
Message-ID: <sashiko-outbox-184962@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: vgic-v3: Don't drop a pending LPI
 mapped with LPIs disabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261026092802.2636798-3-fuad.tabba@linux.dev>
References: <20261026092802.2636798-1-fuad.tabba@linux.dev>
 <20261026092802.2636798-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 10:33:42 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] KVM: arm64: vgic-v3: unconsumed pending table bit when LPIs are en=
abled
- [High] KVM: arm64: vgic-v3: TOCTOU race on vgic_lpis_enabled() drops pend=
ing LPI
--

commit 1318a5e945ab06141897d5ffe8f4348f6a0ecf31
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: vgic-v3: Don't drop a pending LPI mapped with LPIs disabled

This commit updates vgic_v3_lpi_sync_pending_status() so that it only clears
the pending bit in the guest redistributor's pending table when LPIs are
enabled on the target vCPU. This ensures that when LPIs are subsequently
enabled and its_sync_lpi_pending_table() reloads pending state from guest
memory, a pending LPI mapped while LPIs were disabled does not lose its
pending status.

> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 346bacb3198f2..65b77fb35be37 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -552,7 +552,8 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, =
struct vgic_irq *irq)
>  	irq->pending_latch =3D status;
>  	vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> =20
> -	if (status) {
> +	/* Enabling LPIs resets the latch from the table: leave the bit for it =
*/
> +	if (status && vgic_lpis_enabled(vcpu)) {

[Severity: High]
When vgic_lpis_enabled(vcpu) is false, vgic_v3_lpi_sync_pending_status() le=
aves
the pending bit set in the guest's pending table for its_sync_lpi_pending_t=
able()
to consume later.

However, when the guest enables LPIs on the redistributor via
vgic_mmio_write_v3r_ctlr() -> vgic_enable_lpis() -> its_sync_lpi_pending_ta=
ble(),
its_sync_lpi_pending_table() reads the pending bit into irq->pending_latch
without clearing the bit in guest memory:

arch/arm64/kvm/vgic/vgic-its.c:its_sync_lpi_pending_table() {
	...
	raw_spin_lock_irqsave(&irq->irq_lock, flags);
	if (irq->target_vcpu =3D=3D vcpu)
		irq->pending_latch =3D pendmask & (1U << bit_nr);
	vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
	vgic_put_irq(vcpu->kvm, irq);
	...
}

Could leaving that bit set in guest RAM cause spurious LPI delivery in the
following cases?

1. After the guest acknowledges and deactivates the LPI, only irq->pending_=
latch
   is cleared in software while the bit in guest RAM remains 1. If the guest
   later discards and remaps the LPI while LPIs are enabled, vgic_add_lpi()=
 ->
   vgic_v3_lpi_sync_pending_status() will read the stale bit from guest RAM=
 and
   inject a spurious interrupt (or if the guest disables and re-enables LPI=
s,
   its_sync_lpi_pending_table() will re-inject the already-consumed interru=
pt).

2. If the guest issues an ITS CLEAR command (vgic_its_cmd_handle_clear())
   before enabling LPIs, CLEAR only clears irq->pending_latch, and enabling
   LPIs via its_sync_lpi_pending_table() will resurrect the cleared interru=
pt
   from the bit left in guest RAM.

[Severity: High]
Can a race between vgic_v3_lpi_sync_pending_status() on one vCPU and
vgic_mmio_write_v3r_ctlr() enabling LPIs on another vCPU cause the pending =
LPI
to still be dropped?

In vgic_v3_lpi_sync_pending_status(), vgic_queue_irq_unlock() calls
vgic_target_oracle(irq) while holding irq->irq_lock:

arch/arm64/kvm/vgic/vgic.c:vgic_target_oracle() {
	...
	if (unlikely(vcpu && irq_is_lpi(vcpu->kvm, irq->intid) && !vgic_lpis_enabl=
ed(vcpu)))
		return NULL;
	...
}

If vgic_lpis_enabled(vcpu) is false at that point, vgic_target_oracle() ret=
urns
NULL and vgic_queue_irq_unlock() unlocks irq->irq_lock without queueing the=
 LPI
onto the target vCPU's ap_list.

If another vCPU concurrently writes GICR_CTLR_ENABLE_LPIS in
vgic_mmio_write_v3r_ctlr() right after vgic_queue_irq_unlock() checks
vgic_lpis_enabled(vcpu):

CPU 0 (vgic_v3_lpi_sync_pending_status)     CPU 1 (vgic_mmio_write_v3r_ctlr)
---------------------------------------     --------------------------------
vgic_queue_irq_unlock()
  vgic_target_oracle()
    !vgic_lpis_enabled(vcpu) -> returns NULL
  unlocks irq->irq_lock (not queued)
                                            atomic_cmpxchg_acquire(&vgic_cp=
u->ctlr,
                                                0, GICR_CTLR_ENABLE_LPIS);
if (status && vgic_lpis_enabled(vcpu))
  /* now true! */
  val &=3D ~(1 << bit_nr);
  vgic_write_guest_lock(kvm, ptr, &val, 1);
                                            vgic_enable_lpis(vcpu)
                                              its_sync_lpi_pending_table(vc=
pu)
                                                /* reads 0 from guest table=
 */
                                                irq->pending_latch =3D 0;

Wouldn't CPU 0 observe vgic_lpis_enabled(vcpu) as true on the second check =
and
clear the bit in the guest pending table before its_sync_lpi_pending_table()
reads it, causing its_sync_lpi_pending_table() to overwrite irq->pending_la=
tch
with 0 and lose the pending interrupt?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026092802.2636=
798-1-fuad.tabba@linux.dev?part=3D2
