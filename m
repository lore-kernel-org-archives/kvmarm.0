Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795658754;
	b=v4IFuNy6hRnCjdigZ1ZIKy5/HgWShjkdq7Z+sotTlZOGTpScbRzQwOZpmhBFIHUrpgjo
	 7S42eXjaCDaydoOF63VOIfbLyNMeeB8/sKJnN+IX4JjVT0h2tS0IXOIS5WfWAM7z2daGA
	 sZY7eBkYrsyJ4owAT/dxXDVLNfzwmRoiYkL660IeWhtuJ5v2K/1SzRd+7Ier6xxkvlbbi
	 nJX4IUskyvBdvRgrUO1kGnhDV8eVkcrwZmbmyEGkFS/JW+a529PQBiAiqq/loWPZ/5I8m
	 SWIAwrwBuHNiIhIJ9oGwVJT747l3l3PIW79iizLqiDT1L/MHNvfXmWbE63/stUVBPQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795658754;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rQO6nctWokdL7kaPAlPNobD5zXIvnmJLXhHKWB6ucDc=;
	b=5p2vyWpkH0o+/UbI6k3ZPB/oRxCEfS5LJFIwX8ll1KbPMNNpSV06UTWjZ2g2OVZxoIcm
	 ViGtMalw6zuQpi4pdTLvBmRRHTFhEPetKazXEcUZ7FxSlR0gJcwYxC1S1xOlBAS0GWzOf
	 FLG99p5wrJAxMYMD/LLB2WCFJfdr4B9Y4FkvcGiJTSH76bGPlw8n7lKf/pOq7EeYRYmHl
	 QNZ9qPBXA45Wz16Si+CgQlCKIah/JKkP7t7Mz0I9nxxP3gopc8huLNPvfsgeg7chg3i+1
	 JuGKzeQ59i0T+buR4DHYD1cnShC2Z4LKP2Bb+qki7MrBzrSPLK0MFSbWmZqKkm6jsUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QBKPETqa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE60606A32A
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 02:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QBKPETqa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C86C1F000C4;
	Thu, 26 Nov 2026 02:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795658754;
	bh=rQO6nctWokdL7kaPAlPNobD5zXIvnmJLXhHKWB6ucDc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QBKPETqa8ccNzv9io4MSuAZiismQxf2sFkzR+4x7Y+DF9df5hr3OMD4Rz2hJcCrN8
	 ZBQBwrgsK5MSqDElBPnA2BFF9MmCsgR7C5poyZjtD/zjNb/u1Y/hYZA8kG+HNGN/kE
	 UUkD348llC+7JeCbHk0A0qopUGO4m6gdYdwwIyX3qLV2zYGCcAONI6ERAZNsIMHAzf
	 Na2f0DW1ECrybsYIuGf7lolZmXJSuDpRWGNngEHLL2YvjcqTwEREefPeYTD1nv1vgA
	 t0UxYsJjnpGDRTQf2YLzUO7o28Hvf0lq2Zj2p9gtrexTlcJctSNM5vg0WHhKAeADTt
	 Qxz0qGqIs9iyw==
Message-ID: <sashiko-outbox-234602@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: GICv3: Keep active LPIs in the LRs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Brad Fitzpatrick" <bradfitz@tailscale.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261126-bradfitz-kvm_lpi_active-v1-1-9ff28176bf66@tailscale.com>
References: <20261126-bradfitz-kvm_lpi_active-v1-1-9ff28176bf66@tailscale.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 02:05:53 +0000
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
- [Medium] KVM: arm64: vgic: stale ap_list_summary and sort order in
  vgic_flush_lr_state()
- [Medium] KVM: arm64: vgic: active LPIs left stuck active by
  vgic_flush_pending_lpis()
--

commit c554f5d3ddcbf7ba9d43ffa052060d79ec852b3b
Author: Brad Fitzpatrick <bradfitz@tailscale.com>

KVM: arm64: GICv3: Keep active LPIs in the LRs

This commit keeps the active state of virtual LPIs when folding list
registers on guest exit, and drops the active state in
vgic_flush_lr_state() only for LPIs that do not fit into the list
registers.

> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 65b77fb35be37..ba50809f66928 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -90,9 +90,7 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 =
val)
>  		return;
> =20
>  	scoped_guard(raw_spinlock, &irq->irq_lock) {
> -		/* Always preserve the active bit for !LPIs, note deactivation */
> -		if (irq->intid >=3D VGIC_MIN_LPI)
> -			val &=3D ~ICH_LR_ACTIVE_BIT;
> +		/* Always preserve the active bit, note deactivation */
>  		deactivated =3D irq->active && !(val & ICH_LR_ACTIVE_BIT);
>  		irq->active =3D !!(val & ICH_LR_ACTIVE_BIT);
> =20

[Severity: Medium]
Now that vgic_v3_fold_lr() preserves irq->active on LPIs across exits, can
vgic_flush_pending_lpis() unqueue an active LPI while leaving
irq->active =3D=3D true?

When the guest clears GICR_CTLR_ENABLE_LPIS while an LPI is active,
vgic_mmio_write_v3r_ctlr() pauses the vCPU (folding the active bit into
irq->active) and calls vgic_flush_pending_lpis():

arch/arm64/kvm/vgic/vgic.c:vgic_flush_pending_lpis() {
    ...
	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
			raw_spin_lock(&irq->irq_lock);
			irq->pending_latch =3D false;
			list_del(&irq->ap_list);
			irq->vcpu =3D NULL;
			raw_spin_unlock(&irq->irq_lock);
			deleted |=3D vgic_put_irq_norelease(vcpu->kvm, irq);
		}
	}
    ...
}

Because irq->active is still true with irq->vcpu =3D=3D NULL,
vgic_target_oracle() hits its first check (if (irq->active) return
irq->vcpu ? : irq->target_vcpu;) and bypasses the enabled, pending and
vgic_lpis_enabled() checks.  When the vCPU resumes, the LPI is not in any
LR for the guest's EOI, and any later vgic_queue_irq_unlock() (such as
its_sync_lpi_pending_table() when LPIs are re-enabled or update_lpi_config()
on an ITS invalidation) re-queues the LPI onto ap_list_head and loads it
into an LR as active, permanently wedging that LPI and its LR slot because
the guest has already EOI'd the earlier activation.

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index fe09ada322625..05459d662965c 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c

[ ... ]

> @@ -1059,6 +1061,20 @@ static void vgic_flush_lr_state(struct kvm_vcpu *v=
cpu)
>  			break;
>  	}
> =20
> +	/*
> +	 * Active LPIs left out of the LRs can't be deactivated by EOIcount, so
> +	 * drop their active state. See the LPI rules above.
> +	 */
> +	irq =3D *host_data_ptr(last_lr_irq);
> +	if (irq) {
> +		list_for_each_entry_continue(irq, &vgic_cpu->ap_list_head, ap_list) {
> +			if (irq->intid >=3D VGIC_MIN_LPI) {
> +				guard(raw_spinlock)(&irq->irq_lock);
> +				irq->active =3D false;
> +			}
> +		}
> +	}
> +
>  	/* Nuke remaining LRs */
>  	for (int i =3D count ; i < kvm_vgic_global_state.nr_lr; i++)
>  		vgic_clear_lr(vcpu, i);

[Severity: Medium]
Does clearing irq->active here leave struct ap_list_summary stale when
vgic_v3_configure_hcr() runs below?

summarize_ap_list() and vgic_sort_ap_list() run at the start of
vgic_flush_lr_state() while overflowing LPIs still have irq->active =3D=3D =
true,
counting them in als.nr_act instead of als.nr_pend and sorting
active+pending LPIs as active rather than pending.

When an overflowing LPI was active+pending, clearing irq->active turns it
into a pending interrupt outside the LRs without incrementing als.nr_pend,
so irqs_pending_outside_lrs(&als) can be false and vgic_v3_configure_hcr()
will not set ICH_HCR_EL2_NPIE to deliver it once in-LR pending interrupts
are acknowledged.  When an overflowing LPI was active-only, als.nr_act
remains inflated after irq->active is dropped, causing
vgic_v3_configure_hcr() to spuriously enable ICH_HCR_EL2_UIE,
ICH_HCR_EL2_LRENPIE and ICH_HCR_EL2_TDIR.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126-bradfitz-k=
vm_lpi_active-v1-1-9ff28176bf66@tailscale.com?part=3D1
