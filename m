Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8383374737;
	Mon, 15 Jun 2026 18:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781548395; cv=none; b=Eg/mg5lWRlW3syWiYahWlHLFbk8LwBLNND6TG0LJva4iZF8P8YcuSxVquW95Cf+1cypCUknv0AR0u3ISixOR7KohNGkMms8JGPaTgqEzCK5eTgigjIBecs698XXp+7xe3cQoNtAsmxiURXwHvnPTyhhOFGGWHhPIN3RNG2bBM9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781548395; c=relaxed/simple;
	bh=o/qnwHG0ab6ZgLkCBT0Ak01ZaiMzOenoI+hi6fCKoNo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YhdDBI+Zf/6zGqCh5d6yq0Z627AQQobhfWuHd8CK/6V61LwrTxWdFvTczHS4xpdbo0WhXj7p1/kw5RSvb+2jiY39vETQTZJ60mWpAMh4BciSgHDCnv1IHv5jFovDVd0WrMbXeVy/YmtXLuZQrLqZpvxU550alaN2/QO90lCJKXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVswiR9p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVswiR9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A571F00A3A;
	Mon, 15 Jun 2026 18:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781548394;
	bh=x0Dc9a/7ygQhLu1/+p31FFzVgUwYsVX+DJbz3LH1Tso=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YVswiR9pf1FKPLUUgtaxuVr/T5A7SVXzIjeSCWBlbBScBGOqWiXfUojINL9eN48jM
	 d/qDlDWOujNQgUNfDinSagT1EL/6EWv3/YqxVSZQQ5J1euddt45ENIEvyh8ldexC+P
	 V1w3tPdmXCh7/qC9Ylv8THNqevuF3CU04/dJcGEXyr0n8nORTWTnr2BLLxFtTSMkUn
	 XrI/HlxTkJcW0jrkEutETTZ5JPGmRL3Qxe8ExKhyo3uywy7ZeXgfFQD0YF4jnThf7H
	 uyhgfZRn8Oo/i3F9d/0VKAy6hvklgY+TyWnfN0F1tfbfX2MmS8SO/JNUC09sE9VN6J
	 1hYIX5D+vM91Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Handle race between interrupt affinity
 change and LPI disabling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260615181625.3029352-1-maz@kernel.org>
References: <20260615181625.3029352-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 15 Jun 2026 18:33:14 +0000
Message-Id: <20260615183314.65A571F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Concurrent interrupt injection during `vgic_prune_ap_list()`'s=
 dropped-lock window restores the pending state, leading to a poisoned doub=
le `list_del` and subsequent Use-After-Free.
--

commit 4bcf4a77aa55dfeba5b7f8ccf0345e4f29d70e1b
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Handle race between interrupt affinity change and LPI disabling

This patch addresses a use-after-free race condition when migrating an
interrupt while its LPIs are being disabled. It takes an explicit reference
on the interrupt before dropping locks in vgic_prune_ap_list(). It also
removes the migration of the pending bit state.

Link: https://lore.kernel.org/r/ailsCnyoS82r_QRz@v4bel

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 1e9fe8764584d..ab267d2c0bf8b 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -204,6 +204,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
>  	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
>  		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
>  			raw_spin_lock(&irq->irq_lock);
> +			irq->pending_latch =3D false;
>  			list_del(&irq->ap_list);
>  			irq->vcpu =3D NULL;
>  			raw_spin_unlock(&irq->irq_lock);

[ ... ]

> @@ -795,7 +796,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
>  			continue;
>  		}
> =20
> -		/* This interrupt looks like it has to be migrated. */
> +		/*
> +		 * This interrupt looks like it has to be migrated,
> +		 * make sure it is kept alive while locks are dropped.
> +		 */
> +		vgic_get_irq_ref(irq);

[Severity: Critical]
This isn't a bug introduced by this patch, but could the lock-dropping wind=
ow
here lead to a double list_del() and a use-after-free under certain race
conditions?

When vgic_prune_ap_list() drops the irq and ap_list locks shortly after this
reference is taken, another thread could concurrently execute
vgic_flush_pending_lpis() above and remove the irq from the list.

If a third thread then concurrently injects the same LPI before the locks a=
re
reacquired, the irq_lock is taken and pending_latch is set to true again.

When vgic_prune_ap_list() reacquires the locks further down in the function,
the target_vcpu oracle check will pass because the interrupt is pending aga=
in:

arch/arm64/kvm/vgic/vgic.c:vgic_prune_ap_list() {
    ...
    if (target_vcpu =3D=3D vgic_target_oracle(irq)) {
        struct vgic_cpu *new_cpu =3D &target_vcpu->arch.vgic_cpu;

        list_del(&irq->ap_list);
        irq->vcpu =3D target_vcpu;
    ...
}

Because there is no check verifying that irq->vcpu is still equal to the
source vcpu, does this unconditionally execute list_del() on a list entry
that has already been removed and poisoned?

Would this also bypass acquiring a new list reference, leaving the LPI on t=
he
new list with a deficient reference count if it avoids a crash?

> =20
>  		raw_spin_unlock(&irq->irq_lock);
>  		raw_spin_unlock(&vgic_cpu->ap_list_lock);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260615181625.3029=
352-1-maz@kernel.org?part=3D1
