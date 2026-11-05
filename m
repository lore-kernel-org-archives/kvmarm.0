Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793877816;
	b=qdW5LrkP1qntiErj8GesZmpll21zAydGa/Zi2FNa8fY061rCcEDbFxu9CX9VKtinD+LC
	 xh/FF+6A9WJVJETUycs5OaEOCDNMxe3U4TgKsaHP7g4x1WKcQM5/i0QKq45C7BBOvaTgz
	 rYupg62uIcLROmkvYUkxfdubB+YHKjQVJPtRpjmtvcl9dFejykuSXICALOKjGHZTl8paz
	 8KTcV+BcrCLDdVNUmQWOwiA5wOifIC/7cQ+pyboLe1JjMwPqTeLVIuC7t/p/mpI/RPmFs
	 ogpi9IgjvHdII5qv0Kkjdm/hbFhP8Sm9MXJAxApUhB/3XObShRhlEZGXJV6FZex7mdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793877816;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=A2uLr0KxwrCWA+vd7eJ7yZMV0SnA/9BVh8hcQeYwp1I=;
	b=Mai+BwWPNrWB7wu7XWNtHP3RsSTKlFDfmZt36FUYGre8LQqj/wC+96mhjv9EYr6XQiNZ
	 QdgLuROCQVbwl0eL9G/FC3o3D8976SMTn1pgr2bdU8DvbYJZYMDWeina14mk/OS0IzsUd
	 7NyUsM0ASCdHVmusjRJ0J6KmUGYqs09Wa326ioYW7NsOiuPfiHkPEvXz3WzJ1EWRuUKpX
	 blc6759YZB6s6HHLIuM5d300pG6benaV7Qv8l6VXGydTwZyZfSxs66JAqNyQdNVNr+sIX
	 5agsVm4r4Hmlkj3vekBdcoyhmjMv1FtSvgBDoPQCl/7U3SSSQm3cbNqiSZCg5Z1+vYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QSfY3Kcl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6873606A31B;
	Thu,  5 Nov 2026 11:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QSfY3Kcl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2171F000C1;
	Thu,  5 Nov 2026 11:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793877815;
	bh=A2uLr0KxwrCWA+vd7eJ7yZMV0SnA/9BVh8hcQeYwp1I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QSfY3Kcl9Zginb5DZ2hDW6hV8+T8tqmmYCbSLlo0y9eqdiUzywiAlhTtlKbg4jcN8
	 C5q4KBoK3myegtvdbkgYw2EqEBlVK8MbTfNstscdZ5t/s/k641VBV86ZDAtLsToi49
	 RUwBDOHMQomAeOXvCFNtT5CNqj1ILaRgxllRtWT/58DTWx1K/jiFoQ5KMwwwhhwT90
	 IHnIHOG481OjGIgcZBQ5YpwdKT9QGPFrMHC7jZrKkCqg48Eu2ISCTa9YELB71veyXa
	 jFGVGG9H+6cBT/ixnuHvDV+IVfsBIRcPOYDcxJkZOTKO/7wRRL3Tuf5Ex5E1Wo7Blr
	 3JLRpxDo0Kehw==
Message-ID: <sashiko-outbox-198943@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] KVM: arm64: vgic-its: Don't read the pending table
 when mapping an LPI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261105110050.1244525-4-fuad.tabba@linux.dev>
References: <20261105110050.1244525-1-fuad.tabba@linux.dev>
 <20261105110050.1244525-4-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 11:23:34 +0000
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
- [Medium] KVM: arm64: vgic-its: its_sync_lpi_pending_table() reads unrelat=
ed LPIs
- [Medium] KVM: arm64: vgic-its: uncleaned queued LPIs in vgic_its_restore_=
tables_v0()
--

commit 5977878e13acf988213f1898fd84a41cd479ed52
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: vgic-its: Don't read the pending table when mapping an LPI

This commit stops reading the redistributor LPI pending table when mapping =
an
LPI in vgic_add_lpi() and removes vgic_v3_lpi_sync_pending_status(). Instea=
d,
it synchronizes the pending tables for all vCPUs with LPIs enabled at the e=
nd
of vgic_its_restore_tables_v0() via its_sync_lpi_pending_table().

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index 5ce485485a117..ede205e05dc04 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c

[ ... ]

> @@ -2710,6 +2704,9 @@ static int vgic_its_save_tables_v0(struct vgic_its =
*its)
>   */
>  static int vgic_its_restore_tables_v0(struct vgic_its *its)
>  {
> +	struct kvm *kvm =3D its->dev->kvm;
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
>  	int ret;
> =20
>  	ret =3D vgic_its_restore_collection_table(its);
> @@ -2717,9 +2714,25 @@ static int vgic_its_restore_tables_v0(struct vgic_=
its *its)
>  		return ret;
> =20
>  	ret =3D vgic_its_restore_device_tables(its);
> -	if (ret)
> -		vgic_its_free_collection_list(its->dev->kvm, its);
> -	return ret;
> +	if (ret) {
> +		vgic_its_free_collection_list(kvm, its);
> +		return ret;
> +	}
> +
> +	/* Enabling LPIs read the pending tables before these LPIs existed. */
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!vgic_lpis_enabled(vcpu))
> +			continue;
> +
> +		ret =3D its_sync_lpi_pending_table(vcpu);

[Severity: Medium]
Can calling its_sync_lpi_pending_table() here cause KVM_DEV_ARM_ITS_RESTORE=
_TABLES
to fail with -EFAULT when a vCPU with LPIs enabled has a pending table that
does not cover LPI INTIDs targeting other vCPUs or unmapped collections?

Previously, vgic_add_lpi() called vgic_v3_lpi_sync_pending_status(), which
checked irq->target_vcpu (returning 0 if NULL) and only read the pending ta=
ble
of the redistributor that the LPI actually targeted.

In contrast, its_sync_lpi_pending_table() iterates over every LPI in
dist->lpi_xa and reads from the current vCPU's pendbase before checking
whether the LPI targets that vCPU:

arch/arm64/kvm/vgic/vgic-its.c:its_sync_lpi_pending_table() {
	xa_for_each(&dist->lpi_xa, intid, irq) {
		...
		if (byte_offset !=3D last_byte_offset) {
			ret =3D kvm_read_guest_lock(vcpu->kvm,
						  pendbase + byte_offset,
						  &pendmask, 1);
			if (ret)
				return ret;

			last_byte_offset =3D byte_offset;
		}

		irq =3D vgic_get_irq(vcpu->kvm, intid);
		if (!irq)
			continue;

		raw_spin_lock_irqsave(&irq->irq_lock, flags);
		if (irq->target_vcpu =3D=3D vcpu)
			irq->pending_latch =3D pendmask & (1U << bit_nr);
		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
		vgic_put_irq(vcpu->kvm, irq);
	}
}

If a guest enables LPIs on a vCPU that has no LPIs targeting it (or only
lower-INTID LPIs) with an unmapped or smaller pending table in GICR_PENDBAS=
ER,
while LPIs in dist->lpi_xa target other vCPUs or unmapped collections,
its_sync_lpi_pending_table() will read that vCPU's pending table at the byte
offsets of those unrelated LPIs and return -EFAULT. That also performs
O(nr_vcpus * nr_lpis) guest memory reads and vgic_queue_irq_unlock() calls
across all vCPUs during restore.

> +		if (ret) {
> +			vgic_its_free_device_list(kvm, its);
> +			vgic_its_free_collection_list(kvm, its);
> +			return ret;
> +		}

[Severity: Medium]
If its_sync_lpi_pending_table() fails partway through syncing the vCPUs'
pending tables, does this error path leave already-queued LPIs referenced in
dist->lpi_xa and on vcpu->arch.vgic_cpu.ap_list_head?

During the documented restore sequence, the distributor and redistributors =
are
restored before KVM_DEV_ARM_ITS_RESTORE_TABLES is invoked. When
its_sync_lpi_pending_table() sees a pending bit set for an enabled LPI, it
sets irq->pending_latch and calls vgic_queue_irq_unlock(), which takes an
additional reference via vgic_get_irq_ref() and adds irq->ap_list to
vcpu->arch.vgic_cpu.ap_list_head.

If a later kvm_read_guest_lock() call fails (on a subsequent byte offset or=
 a
subsequent vCPU), vgic_its_free_device_list() frees the ITEs via
its_free_ite():

arch/arm64/kvm/vgic/vgic-its.c:its_free_ite() {
	if (irq) {
		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
			if (irq->hw)
				its_unmap_vlpi(ite->irq->host_irq);

			irq->hw =3D false;
			irq->mapped =3D false;
		}

		vgic_put_irq(kvm, ite->irq);
	}
}

Because its_free_ite() only drops the single ITE reference without clearing
irq->pending_latch or flushing ap_list_head, any LPI that was already queued
retains its ap_list reference and stays in dist->lpi_xa and on ap_list_head
with irq->mapped =3D false. If the vCPU runs, vgic_target_oracle() does not
check irq->mapped and can inject the unmapped LPI, or if
KVM_DEV_ARM_ITS_RESTORE_TABLES is retried, vgic_add_lpi() will find the
existing vgic_irq in dist->lpi_xa and return it early without calling
update_lpi_config().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105110050.1244=
525-1-fuad.tabba@linux.dev?part=3D3
