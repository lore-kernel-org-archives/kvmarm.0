Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793009595;
	b=YE2XWxc5jcIN8Mx054L0sPQDnfxLqq7ywbvT3UyWkhKezs400FHXI1d+kuYZlcq45D29
	 GrbluqrjScNi+gSi+r0fv30tAIHhWhekfZ3wt84iBMona3/zOk3JtGDvkktNx0hRoZJgS
	 hZPMt0/wHdye+AobPOSmDUTHezDHwqBTQzArnbpcrXM86BC5OsTJSkzadXad7KpzBWeFg
	 AeNKtW0iZHQBN+kiT/IPcSf+0qAToyzaRJ5uJFo1mvE7DwzMztAXm1XNgJILccXz7uGSG
	 28aowr3QVDfR5ws89M9GRfOESt2LBmimSkP/9nIvTFickApS2XQ435IV6CGrm4ViSjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793009595;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bumdlitgU1cDlFQT8cc/0QYk9nu5URWygwq3qfmXbxM=;
	b=oUoda+pwhz0hzL97DLxkmzYi8JXydjEQy4vR31yKieUtjNECFaGbgGkg/rAk5nmH173P
	 6OgQgbPD7zbDiv4IAxMF+qusLalxDGTLW76NOE3KJ+Q4Cq+3yzRslrHyopsO5XTA5DRNo
	 WH80fCs6RrGZQpsptiUyAB0FuNXApiQNGIb4BD0e+L8sCVbpoTpKLuMMNsgHDef6hW3I2
	 pz/16jnh2YZ1Po/VzdkZcRoA+IfMoVgyMAjiJoHCvJp49CpLbCv8cpAuZ4tFtgE1GCrW+
	 /VuHNGve8g0VLtGJ3+llvPy62GSkwB7kJZ8fnHNSIk267wk7oPCJVtItCFo4RltmkcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LmYckAk0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC5C606A31D
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 10:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LmYckAk0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC071F031E2;
	Mon, 26 Oct 2026 10:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793009595;
	bh=bumdlitgU1cDlFQT8cc/0QYk9nu5URWygwq3qfmXbxM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LmYckAk0yexVmiLdURqtA93fNTNd30WT9TMmXg4IahgW8tf2a5bvVBi7MEkT5p+LS
	 DhpCDVv5yK+fMSmVykk/x1e2M4/0vXE+yqD3hDdB0nufZTt7DJibvMMG2dkk1UImAK
	 WPZJd6iDhA6DfAApEquydbu/MUB2jG+DFjOxJlyJ/JvQOS1+9FFr1YPPEbqdLYjjn3
	 3tV8Mz0pOgUgpSfSuPmpp9TRpPQkURV/bOgN5yS1grt6eK5MZya3fo5mFMl53B/N15
	 L15eS1b8AIbWNVV+P5bpEivmBv7yc6jeVaWP8Dhk2EVnzpg++U0vvcMGlaFe20USfE
	 APAXxeKpU9J9A==
Message-ID: <sashiko-outbox-184898@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: Don't forward LPIs to a
 redistributor with LPIs disabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261026092802.2636798-2-fuad.tabba@linux.dev>
References: <20261026092802.2636798-1-fuad.tabba@linux.dev>
 <20261026092802.2636798-2-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 10:13:14 +0000
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
- [Medium] KVM: arm64: vgic: stale pending_latch when vgic_target_oracle() =
drops LPI
- [Medium] KVM: arm64: vgic: unretired LPI pending_latch in vgic_prune_ap_l=
ist() race
--

commit bd1852e15ba5100e9d4ac1c40f3a92dab6693935
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: vgic: Don't forward LPIs to a redistributor with LPIs disabled

This commit updates vgic_target_oracle() to return NULL for LPIs targeting a
redistributor with GICR_CTLR.EnableLPIs cleared. It also reorders
vgic_mmio_write_v3r_ctlr() to pause the target vCPU before clearing
GICR_CTLR.EnableLPIs so that vgic_flush_pending_lpis() can retire pending
LPIs before vgic_prune_ap_list() removes them from the ap_list.

Link: https://lore.kernel.org/r/asf87i2RDh-WksL-@kernel.org

> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgi=
c-mmio-v3.c
> index f5bd29fbe3a90..9117cd85aa593 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -293,28 +293,31 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcp=
u *vcpu,
>  		return;
> =20
>  	if (!(val & GICR_CTLR_ENABLE_LPIS)) {
> -		/*
> -		 * Don't disable if RWP is set, as there already an
> -		 * ongoing disable. Funky guest...
> -		 */
> -		ctlr =3D atomic_cmpxchg_acquire(&vgic_cpu->ctlr,
> -					      GICR_CTLR_ENABLE_LPIS,
> -					      GICR_CTLR_RWP);
> -		if (ctlr !=3D GICR_CTLR_ENABLE_LPIS)
> -			return;
> -
>  		/*
>  		 * Yes, disabling LPIs is painful, since it can be done from
>  		 * a *remote* vcpu! So let's not take any chance, and make
>  		 * sure that the target vCPU has written their LRs back to the
>  		 * irq structures, and release any reference they would have.
> +		 * Pause it before its LPIs read as disabled, so that the exit's
> +		 * prune leaves them for vgic_flush_pending_lpis() to retire.
>  		 *
>  		 * If it hurts, don't do it.
>  		 */
>  		kvm_pause_vcpu(vcpu);
> -		vgic_flush_pending_lpis(vcpu);
> -		vgic_its_invalidate_all_caches(vcpu->kvm);
> -		atomic_set_release(&vgic_cpu->ctlr, 0);
> +
> +		/*
> +		 * Don't disable if RWP is set, as there already an
> +		 * ongoing disable. Funky guest...
> +		 */
> +		ctlr =3D atomic_cmpxchg_acquire(&vgic_cpu->ctlr,
> +					      GICR_CTLR_ENABLE_LPIS,
> +					      GICR_CTLR_RWP);
> +		if (ctlr =3D=3D GICR_CTLR_ENABLE_LPIS) {
> +			vgic_flush_pending_lpis(vcpu);

[Severity: Medium]
Is kvm_pause_vcpu() sufficient to prevent vgic_prune_ap_list() from seeing
!vgic_lpis_enabled(vcpu) and dropping pending LPIs off an ap_list without
clearing irq->pending_latch before vgic_flush_pending_lpis() retires them?

First, kvm_pause_vcpu() sets KVM_REQ_SLEEP and calls
kvm_make_vcpus_request_mask(), which only waits for vcpu->mode to become
OUTSIDE_GUEST_MODE. In arch/arm64/kvm/arm.c:check_vcpu_requests(), the vCPU
already runs in OUTSIDE_GUEST_MODE:

    if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
        kvm_vcpu_sleep(vcpu);
    ...
    if (kvm_check_request(KVM_REQ_VGIC_PROCESS_UPDATE, vcpu))
        kvm_vgic_process_async_update(vcpu);

If KVM_REQ_SLEEP is set right after the vCPU passes the KVM_REQ_SLEEP check
(or if kvm_vcpu_sleep() wakes early due to a pending signal),
kvm_pause_vcpu() returns while the vCPU continues into
kvm_vgic_process_async_update() -> vgic_prune_ap_list() concurrently with
atomic_cmpxchg_acquire() and vgic_flush_pending_lpis().

Second, if a pending LPI queued on vcpuA (irq->vcpu =3D=3D vcpuA) was retar=
geted
to vcpuB (irq->target_vcpu =3D vcpuB, for example via MOVI or MAPC in
update_affinity()) before vcpuA exited to prune its ap_list, and vcpuB then
disables LPIs, vgic_mmio_write_v3r_ctlr() only pauses and flushes vcpuB. Wh=
en
vcpuA exits and runs vgic_prune_ap_list(), vgic_target_oracle(irq) observes
!vgic_lpis_enabled(vcpuB) and returns NULL:

    target_vcpu =3D vgic_target_oracle(irq);

    if (!target_vcpu) {
        list_del(&irq->ap_list);
        irq->vcpu =3D NULL;
        raw_spin_unlock(&irq->irq_lock);

This removes irq from vcpuA's ap_list while leaving irq->pending_latch set =
to
true, which can later cause a stale pending bit to be saved by
vgic_v3_save_pending_tables() or delivered spuriously if LPIs are re-enabled
with GICR_PENDBASER_PTZ set followed by INV/INVALL.

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 7061b4ab206c9..e1a6a5aa61a8e 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -273,14 +273,18 @@ struct kvm_vcpu *vgic_target_oracle(struct vgic_irq=
 *irq)
>  	 * If the IRQ is not active but enabled and pending, we should direct
>  	 * it to its configured target VCPU.
>  	 * If the distributor is disabled, pending interrupts shouldn't be
> -	 * forwarded.
> +	 * forwarded, nor should LPIs whose redistributor has them disabled.
>  	 */
>  	if (irq->enabled && irq_is_pending(irq)) {
> -		if (unlikely(irq->target_vcpu &&
> -			     !irq->target_vcpu->kvm->arch.vgic.enabled))
> +		struct kvm_vcpu *vcpu =3D irq->target_vcpu;
> +
> +		if (unlikely(vcpu && !vcpu->kvm->arch.vgic.enabled))
> +			return NULL;
> +
> +		if (unlikely(vcpu && irq_is_lpi(vcpu->kvm, irq->intid) && !vgic_lpis_e=
nabled(vcpu)))
>  			return NULL;

[Severity: Medium]
When an MSI injection races with clearing GICR_CTLR.EnableLPIs in
vgic_mmio_write_v3r_ctlr(), can returning NULL here leave irq->pending_latch
stuck at true and leave a live entry in its->translation_cache?

In vgic_mmio_write_v3r_ctlr(), atomic_cmpxchg_acquire() sets vgic_cpu->ctlr
to GICR_CTLR_RWP before calling vgic_flush_pending_lpis() and
vgic_its_invalidate_all_caches(). If vgic_its_inject_msi() hits the cache v=
ia
vgic_its_inject_cached_translation() in that window:

    raw_spin_lock_irqsave(&irq->irq_lock, flags);
    irq->pending_latch =3D true;
    vgic_queue_irq_unlock(kvm, irq, flags);

vgic_target_oracle() sees !vgic_lpis_enabled(vcpu) and returns NULL, so
vgic_queue_irq_unlock() does not add irq to ap_list_head and does not clear
irq->pending_latch. Because vgic_flush_pending_lpis() only walks
ap_list_head, irq->pending_latch remains true while irq->vcpu is NULL.

Similarly, in arch/arm64/kvm/vgic/vgic-its.c:vgic_its_resolve_lpi():

    if (!vgic_lpis_enabled(vcpu))
        return -EBUSY;

    vgic_its_cache_translation(kvm, its, devid, eventid, ite->irq);

Because vgic_its_resolve_lpi() is not serialized against
vgic_mmio_write_v3r_ctlr(), it can pass the vgic_lpis_enabled(vcpu) check
just before ctlr transitions to GICR_CTLR_RWP, insert the translation into
its->translation_cache after vgic_its_invalidate_all_caches() has already
finished, and set irq->pending_latch =3D true in vgic_its_trigger_msi().

Wouldn't this leave a stale irq->pending_latch that gets written to guest
memory on migration by vgic_v3_save_pending_tables(), forwarded by
kvm_vgic_v4_set_forwarding(), or delivered after re-enabling LPIs with
GICR_PENDBASER_PTZ set and issuing INV/INVALL?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026092802.2636=
798-1-fuad.tabba@linux.dev?part=3D1
