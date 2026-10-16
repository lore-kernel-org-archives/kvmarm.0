Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA5C416853;
	Fri, 16 Oct 2026 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167058; cv=none; b=WQ5INuVPrHr7tfMQ3o6fBWaZVaVTLyGjsnTHuHc3E7LK74hRA4Ns9iD54m8CdlZlH27H/Q+MzwANx5Cae0w0Je01QT3UKPomHuXQ/Owih1SKnM6zLTCuIpmVYDAk9x01XEhTR9HSR0pjKRERVBe4DlLcbsFRiH7Vg6xOLcnqw6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167058; c=relaxed/simple;
	bh=Dg54TqDa1D6dbMfqPiJ1CRuUUNhZFU76g/INU1Vp6hI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=bteRDH3iMqh/GXZbbekrvX1fZ/VeFmedu/LvSA45U3bXVio15nxPacJRKbcjUCqReobJYRA//MdKG9i1Zp8wNAUPZxMSyZIdM+FecsIZgCCt796tcOxtmuJAiEYHWnSlKWgf+5/aPA6VkdUuGbnbH414r9p0IAr06wQIv/1FjcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mtkkAFNE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mtkkAFNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7A41F000C4;
	Fri, 16 Oct 2026 16:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167051;
	bh=ScagHFAJFeV7TR+SBT98jmSsdyp8uIoHHFcwed3MH2k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mtkkAFNEnky/pcRdpLYXEq5Ag1mc7Nb+Av1/C5xMvNlNvLBaP64w8tm5WVMjmIa3/
	 K45HoYSpKFlO37+QylMTWai6Qdgwhxkp8GAH6JrL82vmrN8piPwQQ1VZePCVjH8asG
	 8sppwD/g2jCUcjD37awjWbUjuO5SHU0pq64wjaOuKNsxWRkJw7TF0wbX3wZXWMK2Sf
	 xYBbX3ByEbrZFwWyVWZqbBaM7nhVpdfOv/Pw2fVWk0ueCTakoCy9vSSUcKITgFEKU1
	 NDj7B73YekJlAKfK81G7Q2PpNr9ljO+E5oP/478rY0A2Ypljf21h505nIUEc68A4Ky
	 VuJAnXzdLUEDw==
Message-ID: <sashiko-outbox-174606@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/16] KVM: arm64: gic-v5: Add ITS translation cache
 maintenance
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261016155741.979985-9-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-9-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 16:10:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] kvm: missing memcg accounting for ITS translation cache allocations
- [High] kvm: undersized ITS translation hash table causes raw spinlock DoS
- [Medium] kvm: arm64: gic-v5: cache insertion failure drops valid LPI
--

commit b6b2c7ac3d0d6dc377bf1fd1bb7de1527b73194f
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: gic-v5: Add ITS translation cache maintenance

This commit introduces a disposable acceleration structure to cache
resolved ITS translations, avoiding iterating over guest memory on every
MSI or ITS event.

> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic=
-its-v5.c
> index f6d2acca4ae4c..e4c0415137605 100644
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c

[ ... ]

> @@ -19,6 +19,272 @@
>  #define VITS_V5_DEVICE_ID_BITS		16
>  #define VITS_V5_EVENT_ID_BITS		16

[ ... ]

> +static int its_cache_add_translation(struct kvm *kvm, struct vgic_v5_its=
 *its,
> +				     u32 device_id, u16 event_id,
> +				     struct vgic_irq *irq)
> +{
> +	u64 key =3D ((u64)device_id << 16) | (u64)event_id;
> +	struct its_cache_translation_entry *entry;
> +	struct its_cache_translation_entry *old;
> +	struct hlist_node *tmp;
> +	HLIST_HEAD(removed);
> +
> +	entry =3D kzalloc_obj(*entry, GFP_KERNEL);
> +	if (!entry)
> +		return -ENOMEM;

[Severity: High]
Does this allocation need memcg accounting?

The GFP_KERNEL flag is missing __GFP_ACCOUNT, which means these guest-driven
allocations are not charged to the VM memory cgroup. Since the cache has no
upper size bound, could a guest inject arbitrary device_id and event_id
combinations via GICV5_ITS_GEN_EVENTR to exhaust host kernel memory and
cause an out-of-memory denial of service?

[ ... ]

> +static int its_cache_look_up_translation(struct vgic_v5_its *its,
> +					 u32 device_id, u16 event_id,
> +					 struct vgic_irq **irq)
> +{
> +	u64 key =3D ((u64)device_id << 16) | (u64)event_id;
> +	struct its_cache_translation_entry *entry;
> +
> +	guard(raw_spinlock)(&its->translation_cache_lock);
> +
> +	hash_for_each_possible(its->translation_cache, entry, node, key) {

[Severity: High]
Can this traversal cause a host lockup under a raw spinlock?

Since the translation cache is unbounded, a guest could trigger the inserti=
on
of millions of LPI translations. These entries are distributed across a sma=
ll
fixed-size hash table, which will result in massive hash collisions and
extremely long bucket chains.

Traversing tens or hundreds of thousands of entries under a raw spinlock
disables preemption and interrupts for an extended period, which could
lead to soft or hard CPU lockups.

[ ... ]

> @@ -260,7 +530,15 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kvm=
, struct vgic_v5_its *its,
>  	if (IS_ERR(*irq))
>  		return PTR_ERR(*irq);
> =20
> -	return 0;
> +	vgic_get_irq_ref(*irq);
> +	ret =3D its_cache_add_translation(kvm, its, device_id, event_id, *irq);
> +	if (ret) {
> +		vgic_put_irq(kvm, *irq);
> +		vgic_put_irq(kvm, *irq);
> +		*irq =3D NULL;
> +	}
> +
> +	return ret;

[Severity: Medium]
Should a cache insertion failure cause the valid LPI to be dropped?

If its_cache_add_translation() fails due to memory pressure, this error
handling path drops both the cache reference and the caller's successfully
resolved reference, propagating the error and discarding the interrupt.

Since the translation cache is a best-effort acceleration structure, is it
better to swallow the caching error and allow the caller to proceed with the
validly resolved LPI rather than completely failing the resolution?

> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index c9eaa7897b57e..bf970275868c9 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h

[ ... ]

> @@ -590,6 +591,12 @@ struct vgic_v5_its {
>  		u32 device_id;
>  	} gen_event_didr;
> =20
> +	/* A hash table with 2^3 buckets */
> +	DECLARE_HASHTABLE(translation_cache, 3);
> +
> +	/* Protects the translation_cache */
> +	raw_spinlock_t translation_cache_lock;

[Severity: High]
Is a 3-bit hash table (8 buckets) sufficient for an unbounded number of
guest-driven translations?

As noted earlier, storing a potentially unbounded number of LPI translations
in 8 buckets causes significant hash collisions. When paired with the
translation_cache_lock raw spinlock, this creates the denial of service
risk mentioned above.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016155741.9799=
85-1-sascha.bischoff@arm.com?part=3D8
