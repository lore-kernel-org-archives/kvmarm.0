Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793653074;
	b=z8mWQXqC7CJshNfapmIVJPmDUrxzh3e/z2OB3R4PhmKUgRqtg4k/cjMWu5KN8M/qkxqx
	 MZYUy0p3GbvCsMe+EjrlAgmSilbFMokZZdl/6iphcE01FlTeOhx0KygLlIfOLGrY5jLA8
	 vTA3EvYVu6+10ynvYhxUlvcKe38tohud6NslXnBOp3j/Te2vPfu9kB1RPS/GDhkVu8dt7
	 cbAt4kMOlyRTbz8HnZw2LILzJwQKMIKggXLMIEtetymTAkCoumdB5OkIioC2GlQGDK8EU
	 4BtYu5ooCJUtqLos65jPfjVObl7ZwLIKA2dbbLltJ4QHpBiAsNQJRP0YRtNhq3ESaQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793653074;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mgfd7drWnJTsLYHZtrgehegaVlJMIqsSPz3c/tif2Ow=;
	b=u30LPyiYyr2MYnLLyZLNNL9uEefmlOlGfeZ4H947//D25NlvTbpgHGTuwU86x4tU7jM5
	 fNqeDFqInU2aVKhDyonxvYmRCZphvBTKt+3iEv4FdpBhvZfIVCfWPLJ5LCiDHL71Dgm86
	 lCCggDMSHKtPzySdiM0WxnnEj5tae+xLAWrPfKuBDlsbB9Lp1MKzuuIUfTlX2OviBSBXz
	 l5nK2LSgvU1m1BX5BZE7sH/RUCl4N/HqrOsMU6OmNAYxlq2BsouAKc1PXaX8pGS/vmVFF
	 /+CGqooeGmXzIACzRr5N21c7JGdmD2XOEN/ukxh+to/9A8YsIDZ54IuBtbj9LUpZZqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mPGrT66U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76137606A324;
	Mon,  2 Nov 2026 20:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mPGrT66U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C326B1F00A16;
	Mon,  2 Nov 2026 20:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793653074;
	bh=mgfd7drWnJTsLYHZtrgehegaVlJMIqsSPz3c/tif2Ow=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mPGrT66U2E2V+m9WKDraprn8sG90I6Mty3WcwKjXZdWff2emcmDrBF/aPH8yV/ohc
	 a8z/9XfwidVvKHu0dxcOG8zHpXcwR5VDe6iA2PvvIoHx06B8zIDsDxGVj49QXJ4Pmx
	 bwm2TO8dgiyQp1ma/UdB9FD+ozpOfD/CbkbHebpbxdSM6YhCabNvXxKX2tB4w2t5qp
	 cmcWQXaXxd6ap3QJ4WgLB3Su9rzxBKz0Kw5nUMV6OfXOW2tSOo5pMhAt+h+U/g9BJ2
	 5IHzRWnRkFH9cc1u408Bu/GJyK5qaRHlH0j1EFCQ/iem0Ie/XMQzTottgkDuMq320p
	 dcpSOmut4GqQQ==
Message-ID: <sashiko-outbox-194164@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/16] irqchip/gic-v5: Enable direct injection in ITS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102194454.4086911-12-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-12-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 20:57:53 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] irqchip/gic-v5: sleep in atomic context via gicv5_irs_syncr() unde=
r desc->lock
- [High] irqchip/gic-v5: unlocked concurrent MMIO access in gicv5_its_itt_c=
ache_inv()
- [Medium] irqchip/gic-v5: ignored timeout in gicv5_irs_syncr() during ITTE=
 restoration
--

commit 0ced984dd99b707bdb6169e0051131c256a7148e
Author: Sascha Bischoff <sascha.bischoff@arm.com>

irqchip/gic-v5: Enable direct injection in ITS

This commit adds the irq_set_vcpu_affinity callback and helper functions to
install and remove virtual ITTE translations in the GICv5 ITS for KVM direct
interrupt injection, while disabling lazy masking for forwarded interrupts.

> diff --git a/drivers/irqchip/irq-gic-v5-its.c b/drivers/irqchip/irq-gic-v=
5-its.c
> index 28e39b065de0e..d91f4ea1ef440 100644
> --- a/drivers/irqchip/irq-gic-v5-its.c
> +++ b/drivers/irqchip/irq-gic-v5-its.c

[ ... ]

> @@ -723,6 +765,102 @@ static void gicv5_its_compose_msi_msg(struct irq_da=
ta *d, struct msi_msg *msg)
>  	msi_msg_set_addr(irq_data_get_msi_desc(d), msg, addr);
>  }
> =20
> +#ifdef CONFIG_KVM
> +static int gicv5_its_set_vcpu_affinity(struct irq_data *d, void *int_dat=
a)
> +{
> +	struct gicv5_its_dev *its_dev =3D irq_data_get_irq_chip_data(d);
> +	u16 event_id =3D FIELD_GET(GICV5_ITS_HWIRQ_EVENT_ID, d->hwirq);
> +	u32 dev_id =3D FIELD_GET(GICV5_ITS_HWIRQ_DEVICE_ID, d->hwirq);
> +	struct virt_intr_data *data =3D int_data;
> +	struct gicv5_its_chip_data *its;
> +	__le64 *itte;
> +	u64 itte_val, tmp;
> +	int ret =3D 0;

[ ... ]

> +invalidate:
> +	/* Make the change ITS-visible */
> +	dsb(st);
> +	ret =3D gicv5_its_itt_cache_inv(its, dev_id, event_id);

[Severity: High]
As reported by Sashiko on v1 [1], can concurrent calls to
gicv5_its_itt_cache_inv() on the same physical ITS race with each other?

Both gicv5_its_enable_direct_injection() and
gicv5_its_disable_direct_injection() invoke irq_set_vcpu_affinity(), which
only holds the per-IRQ desc->lock before calling
gicv5_its_set_vcpu_affinity().

Inside gicv5_its_itt_cache_inv():

drivers/irqchip/irq-gic-v5-its.c:gicv5_its_itt_cache_inv() {
	...
	its_writeq_relaxed(its, didr, GICV5_ITS_DIDR);
	its_writel_relaxed(its, eidr, GICV5_ITS_EIDR);
	its_writel_relaxed(its, eventr, GICV5_ITS_INV_EVENTR);

	return gicv5_its_cache_sync(its);
}

Because struct gicv5_its_chip_data has no spinlock serializing access to the
shared ITS MMIO registers, two CPUs concurrently configuring different IRQs
on the same ITS (or racing with gicv5_its_irq_domain_activate(),
gicv5_its_irq_domain_deactivate(), or gicv5_its_device_cache_inv()) can
overwrite each other's GICV5_ITS_DIDR and GICV5_ITS_EIDR values before
GICV5_ITS_INV_EVENTR is written, invalidating the wrong (DeviceID, EventID)
entry and leaving stale translations cached in the ITS.

> +	if (!ret && !data) {
> +		/*
> +		 * Invalidation sends events using the old translation to the
> +		 * IRS, but does not wait for them to be processed.
> +		 */
> +		gicv5_irs_syncr();
> +	}

[Severity: High]
Will calling gicv5_irs_syncr() here sleep in atomic context?

gicv5_its_disable_direct_injection() calls irq_set_vcpu_affinity(virq, NULL=
),
which acquires raw_spin_lock_irqsave(&desc->lock, flags) via
scoped_irqdesc_get_and_lock() before invoking gicv5_its_set_vcpu_affinity().

When gicv5_its_set_vcpu_affinity() calls gicv5_irs_syncr():

drivers/irqchip/irq-gic-v5-irs.c:gicv5_irs_syncr() {
	...
	syncr =3D FIELD_PREP(GICV5_IRS_SYNCR_SYNC, 1);
	irs_writel_relaxed(irs_data, syncr, GICV5_IRS_SYNCR);

	gicv5_wait_for_op(irs_data->irs_base, GICV5_IRS_SYNC_STATUSR,
			  GICV5_IRS_SYNC_STATUSR_IDLE);
}

Unlike gicv5_wait_for_op_atomic(), gicv5_wait_for_op() expands to
gicv5_wait_for_op_s(), which calls readl_poll_timeout() with a sleep_us of =
1,
executing might_sleep_if(1) and usleep_range() while holding desc->lock with
interrupts disabled.

> +	if (ret) {
> +		/* Keep a failed restoration distinguishable from a clean host ITTE. */
> +		if (!data)
> +			irqd_set_forwarded_to_vcpu(d);
> +		return ret;
> +	}

[Severity: Medium]
What happens if polling GICV5_IRS_SYNC_STATUSR times out inside
gicv5_irs_syncr() while restoring a host ITTE?

gicv5_irs_syncr() returns void and discards the -ETIMEDOUT return value from
gicv5_wait_for_op(). If the IRS synchronization times out after
gicv5_its_itt_cache_inv() succeeds, ret remains 0.

As a result, gicv5_its_set_vcpu_affinity() will proceed to clear
IRQD_FORWARDED_TO_VCPU instead of keeping the retryable forwarded state, and
gicv5_its_disable_direct_injection() will clear IRQ_DISABLE_UNLAZY and retu=
rn
0 to the caller while events using the old virtual translation may still be
in flight at the IRS. Should gicv5_irs_syncr() propagate its error so ret c=
an
be checked here?

[1] https://lore.kernel.org/r/sashiko-outbox-174629@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102194454.4086=
911-1-sascha.bischoff@arm.com?part=3D11
