Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853315326BB;
	Fri, 16 Oct 2026 16:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167837; cv=none; b=jV5fruIb3e8Oexxw3uMlQzUdR9cU7aQheYBTqtSRXIwxz6L85UL3EHMA7Lgr2/OeDeBmiipIQDCrR5mgTXyK946HRybNnSwpV3UZuAjuxOBdGyCLHdx071VAyUsbUxOeP0/RR7ecgrPYAUd3F49/7sa6uu2ePC9jbNA0sHiIdnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167837; c=relaxed/simple;
	bh=HbyTB9YG3IEFvULFpxbg7zJ3FR2lmghbhWYQBeuso18=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=aJKlYqJyJ0g0PuSf27WjAvSIdDdPCK6p+vHfUHws90Kv9IVmcnTUCHe/+ZoaXVWiJdG45rr4vXT/SRPUd8B4GGEJglIPN2SDDJWO0FReYvGHEE6LJOTjGbby1pt2SN289YowwniGvUTOQJaEYseu3cqF778QL8MVQ0uYlN2Z4Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=am7s3oiB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="am7s3oiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4A41F000C4;
	Fri, 16 Oct 2026 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167835;
	bh=MTGG3sE8c3g2AGiRuxoGfoVJjt2RErDfmEmcb286QKI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=am7s3oiBpL3DW65qGetBS/FQFYEFBJl0JVvSqybQgaOYMEVyJI02GmGpUaZMlJx77
	 SEIXt2GUQxjM8VXRmBUpm+ynpDeM7j0SvnxtDg3D3i+nC9AE947unMp8qwe6uYxmZQ
	 K9m/gpAeVXEOBmn7GnkqKgAI50tP29dNW8ZZZrg9sFdj5PBkoZTjmU/+0LFcT8QQxH
	 qL1Pyx3mTeRa8CLvaJ5tzDS7H1zvHUPvrdnDdmB6ViKTEUVsYMXtcRDNHwN4HJ2rmQ
	 sc/YckdTIcoQYmw49E/kt8e9L0iP/9FhcLuAv3vjT6T4l6eJpotadHaDy9zUY7xcaT
	 d6vHyrJYAPatA==
Message-ID: <sashiko-outbox-174632@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/16] KVM: arm64: gic-v5: Add ITS MSI injection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261016155741.979985-10-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-10-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 16:23:54 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] kvm/vgic: raw_spinlock deadlock due to missing IRQ disable in its_=
cache_add_translation
- [High] kvm/vgic: userspace-triggerable WARN_ON_ONCE causes host DoS in vg=
ic_v5_its_inject_msi
- [High] arm64: vgic-v5: User-triggerable WARN_ON_ONCE in MSI injection
- [High] kvm: arm64: ABI violation on guest-driven MSI mapping errors
- [Medium] kvm: arm64: gic-v5: MSI injection aborted on translation cache a=
llocation failure
- [Medium] arm64: vgic-v5: MSI injection fails if ITS cache insertion fails
--

commit 65afd53542f7c52bea1da09f7e70c85b22c50b33
Author: Sascha Bischoff <sascha.bischoff@arm.com>

    KVM: arm64: gic-v5: Add ITS MSI injection
   =20
    Now that KVM can resolve GICv5 ITS translations from guest memory,
    allow userspace and irqfd MSI injection to target a virtual GICv5 ITS.

> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic=
-its-v5.c
> index e4c0415137605..5920fa1bcb2cf 100644
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c

[ ... ]

>  static int its_cache_add_translation(struct kvm *kvm, struct vgic_v5_its=
 *its,
>  				     u32 device_id, u16 event_id,
>  				     struct vgic_irq *irq)
>  {
>  	u64 key =3D ((u64)device_id << 16) | (u64)event_id;
>  	struct its_cache_translation_entry *entry;
>  	struct its_cache_translation_entry *old;
>  	struct hlist_node *tmp;
>  	HLIST_HEAD(removed);
> =20
>  	entry =3D kzalloc_obj(*entry, GFP_KERNEL);
>  	if (!entry)
>  		return -ENOMEM;
> =20
>  	entry->key =3D key;
>  	entry->irq =3D irq;
> =20
>  	scoped_guard(raw_spinlock, &its->translation_cache_lock) {

[Severity: High]
Could this lock acquisition deadlock?

The translation_cache_lock is a raw_spinlock_t that is also acquired in
hardirq context by its_cache_look_up_translation(). Since
scoped_guard(raw_spinlock) does not disable local interrupts, a hardirq cou=
ld
preempt this process-context section and attempt to acquire the same lock,
spinning forever.

Should this use the raw_spinlock_irqsave variant?

[ ... ]

>  static int its_cache_look_up_translation(struct vgic_v5_its *its,
>  					 u32 device_id, u16 event_id,
>  					 struct vgic_irq **irq)
>  {
>  	u64 key =3D ((u64)device_id << 16) | (u64)event_id;
>  	struct its_cache_translation_entry *entry;
> =20
>  	guard(raw_spinlock)(&its->translation_cache_lock);

[Severity: High]
Does this also need to disable interrupts?

Since this is called from the fast path (kvm_arch_set_irq_inatomic) which c=
an
run in hardirq context, and the same lock is taken in process context, shou=
ld
both sides use the irqsave/irqrestore variants to prevent deadlocks?

[ ... ]

> @@ -531,7 +572,8 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kvm,=
 struct vgic_v5_its *its,
>  		return PTR_ERR(*irq);
> =20
>  	vgic_get_irq_ref(*irq);
> -	ret =3D its_cache_add_translation(kvm, its, device_id, event_id, *irq);
> +	ret =3D its_cache_add_translation(kvm, its, device_id, (u16)event_id,
> +					 *irq);
>  	if (ret) {
>  		vgic_put_irq(kvm, *irq);
>  		vgic_put_irq(kvm, *irq);
>  		*irq =3D NULL;
>  	}
> =20
>  	return ret;
>  }

[Severity: Medium]
Is it correct to abort the injection if the translation cache insertion fai=
ls?

The translation cache is intended to be a best-effort optimization. If
its_cache_add_translation() fails (e.g., due to -ENOMEM), propagating the
error and dropping the successfully resolved LPI will silently lose the
interrupt, which could hang guest drivers under host memory pressure.

Should the error be swallowed here instead so that injection proceeds?

[ ... ]

> +int vgic_v5_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
> +{
> +	struct vgic_v5_its *its;
> +	struct vgic_irq *irq;
> +	bool borrowed_mm =3D false;
> +	int ret;
> +
> +	ret =3D vgic_v5_check_msi(kvm, msi);
> +	if (ret)
> +		return ret;
> +
> +	its =3D vgic_v5_msi_to_its(kvm, msi);
> +	if (IS_ERR(its))
> +		return PTR_ERR(its);
> +
> +	/* An irqfd cache miss is resolved by a worker outside the VM's mm. */
> +	if (current->mm !=3D kvm->mm) {
> +		if (WARN_ON_ONCE(current->mm || !(current->flags & PF_KTHREAD)))
> +			return -EWOULDBLOCK;

[Severity: High]
Could this WARN_ON_ONCE be triggered by unprivileged userspace?=20

If a normal user process (other than the VM creator) calls the KVM_SIGNAL_M=
SI
ioctl, current->mm will not equal kvm->mm, and since it is a user thread,
current->mm is non-NULL and it lacks PF_KTHREAD. Triggering a kernel warning
can crash the host if panic_on_warn is enabled, leading to a Denial of Serv=
ice.

> +
> +		if (!mmget_not_zero(kvm->mm))
> +			return -EFAULT;
> +
> +		kthread_use_mm(kvm->mm);
> +		borrowed_mm =3D true;
> +	}
> +
> +	ret =3D vgic_v5_its_resolve_lpi(kvm, its, msi->devid, msi->data, &irq);
> +	if (borrowed_mm) {
> +		kthread_unuse_mm(kvm->mm);
> +		mmput(kvm->mm);
> +	}
> +
> +	if (ret)
> +		return ret;

[Severity: High]
Does this violate the KVM_SIGNAL_MSI ABI by returning negative error codes?

When the guest provides an invalid mapping (like an out-of-bounds Event ID),
vgic_v5_its_resolve_lpi() returns errors like -E2BIG or -EINVAL. Propagating
these directly to the ioctl caller instead of returning 0 (to indicate the
guest blocked or unmapped the MSI) can cause the VMM to abort, creating a
guest-to-host Denial of Service.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016155741.9799=
85-1-sascha.bischoff@arm.com?part=3D9
