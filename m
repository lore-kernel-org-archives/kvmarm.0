Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651882;
	b=efwXmS47JkX71D5nqgtTacBRbs2Ve0mBPvmp7LkZYoZnLuaou7CvZJQTDv/yiB6vMezl
	 OO3gv9YQsXoqnkQ5MLVtTQ+3GBxBPGGhXgz8X+V2+4Hj1kO/Ax4ITHWF2zuasRqw9Hjv1
	 iZKcx/q9R1bTMsj9nYzPEzj1yDhsFPUxNIECfKHhaZsN3NJsbMyKQhFV2HB/L1gtDVOQi
	 7+I3xa+1vaXrZhtgXrMkKfyYn7Of6VXTKDeHTWBOHcJQ4kOprM2UjgE3ymT44wjFrHs4D
	 0mhX1ayTZQHfouxOi/7uBZBYEgmSKFcUKlvisyYIbQxA3L8qmm+YK40QUIOsomUTR0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651882;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=thytxbJXxeGikUjHXwlRX1Hc7pfpqIWn3LGnZlH7d0A=;
	b=jLmtql+1nZr3BdLxDA/7cQP1gUR824/hnV1Zprb1hiWCC0g7ghluW+rW5QPsJCxybSrq
	 sSNHTNxqLA1oLlyftC3aykB/oTLP3u5UKiOWVN3Nz3fVWHA1FYLP/5Kwz+AR77Ji1sUFD
	 qqSv5+QGuuBHigYnvA1FewgGSHXWlKvwCWSiUoMLvRd8Iu37uoNw5cp8ts5q+M80Dig1U
	 JFoDw4y5GH8aGIfKuWTj9DemNnMYdpbYpdfUIXY7rBFdOeGvUL5YxfYpDnQMD2FRcQNdf
	 1DnexSumuyvKuRwEaPGkKUP3sl6egaS9jkLy/w4qGZOz+HJW9iLCyFP/ZnOJoVdcp9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YAglJoQq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C581606A324;
	Mon,  2 Nov 2026 20:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YAglJoQq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FD31F00A16;
	Mon,  2 Nov 2026 20:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793651882;
	bh=thytxbJXxeGikUjHXwlRX1Hc7pfpqIWn3LGnZlH7d0A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YAglJoQqXQSAZYcjPDpyN5onTlSFpGfdM7MrStdZS+GFaO931q570MlIzp30ZT1d3
	 Z//JPMiS7X1P7tsHC8ctt9qNIX8SGeV1pf34bLp8O0v1LVtAEqBF7qbLlVZXX/fWFP
	 50bvXO3OkeZdmBuI0/9BsOeBFgHPw0KYONQiBce1+mp1thJccILo5xPdo7bGPFVnoi
	 D4ca1BN1CKDRabnaAIcq+ycG5/Z/6fEO39N8yCjTrgqXrGn5+5txrxczxwpVbIzaIs
	 NgaMZXE8ZI3wc5R92EvR70zWKAoK2rwPl4e9xX4QQjt5HBPn+zXFscp0p9Yzsmmq7k
	 86luyHXp+XBMw==
Message-ID: <sashiko-outbox-194134@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/16] KVM: arm64: gic-v5: Add ITS MSI injection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102194454.4086911-10-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-10-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 20:38:01 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] KVM: arm64: gic-v5: missing vgic_initialized() check in MSI inject=
ion
--

commit b2f7c0263871635da8ddb0614e8b96f1cb1f641c
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: gic-v5: Add ITS MSI injection

This commit adds MSI injection support for the virtual GICv5 ITS via both
the slow guest-memory translation path and the inatomic cached translation
path. It wires kvm_set_msi() and kvm_arch_set_irq_inatomic() to invoke the
new GICv5 ITS injection helpers for GICv5 VMs.

> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic=
-its-v5.c
> index 9f4783b243221..b69a1d107c0ae 100644
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c

[ ... ]

> @@ -424,12 +468,86 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kv=
m, struct vgic_v5_its *its,
>  	return ret;
>  }
> =20
> +int vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
> +			    u32 device_id, u32 event_id,
> +			    struct vgic_irq **irq)
> +{
> +	guard(mutex)(&its->its_lock);
> +
> +	return __vgic_v5_its_resolve_lpi(kvm, its, device_id, event_id, irq);
> +}
> +
>  static void vgic_v5_its_inject_lpi(struct kvm *kvm, struct vgic_irq *irq)
>  {
>  	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, true,
>  		     kvm->arch.vgic.gicv5_vm.vm_id);
>  }
> =20
> +int vgic_v5_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
> +{
> +	struct vgic_v5_its *its;
> +	struct vgic_irq *irq;
> +	bool borrowed_mm =3D false;
> +	int ret;
> +
> +	its =3D vgic_v5_msi_to_its(kvm, msi);
> +	if (IS_ERR(its))
> +		return PTR_ERR(its);
> +
> +	/* An irqfd cache miss is resolved by a worker outside the VM's mm. */
> +	if (current->mm !=3D kvm->mm) {
> +		if (WARN_ON_ONCE(current->mm || !(current->flags & PF_KTHREAD)))
> +			return -EWOULDBLOCK;
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
> +	if (ret < 0)
> +		return ret;
> +	/* KVM_SIGNAL_MSI reports guest translation failures as blocked MSIs. */
> +	if (ret)
> +		return 0;
> +
> +	vgic_v5_its_inject_lpi(kvm, irq);
> +	vgic_put_irq(kvm, irq);
> +
> +	return 1;
> +}
> +
> +int vgic_v5_its_inject_cached_translation(struct kvm *kvm, struct kvm_ms=
i *msi)
> +{
> +	struct vgic_v5_its *its;
> +	struct vgic_irq *irq;
> +	int ret;
> +
> +	its =3D vgic_v5_msi_to_its(kvm, msi);
> +	if (IS_ERR(its))
> +		return PTR_ERR(its);
> +
> +	if (!READ_ONCE(its->enabled))
> +		return -EWOULDBLOCK;
> +
> +	ret =3D its_cache_look_up_translation(its, msi->devid, (u16)msi->data,
> +					    &irq);
> +	if (ret)
> +		return -EWOULDBLOCK;
> +
> +	vgic_v5_its_inject_lpi(kvm, irq);
> +	vgic_put_irq(kvm, irq);
> +
> +	return 0;
> +}

[Severity: High]
Can userspace trigger vgic_v5_its_inject_lpi() before the GICv5 VM has been
initialized?

When a VM creates KVM_DEV_TYPE_ARM_VGIC_V5 and KVM_DEV_TYPE_ARM_VGIC_V5_ITS,
kvm_vgic_create() initializes kvm->arch.vgic.gicv5_vm.vm_id to
VGIC_V5_VM_ID_INVAL (-1), and a valid VM ID is only allocated later during
KVM_DEV_ARM_VGIC_CTRL_INIT via:

  vgic_init()
    vgic_v5_init()
      vgic_v5_allocate_vm_id()

However, vgic_v5_register_its_iodev() registers the ITS on KVM_MMIO_BUS as
soon as KVM_VGIC_V5_ADDR_TYPE_ITS is set, and userspace register access
allows writing GICV5_ITS_CR0 (setting its->enabled =3D true),
GICV5_ITS_DT_CFGR, and GICV5_ITS_DT_BASER before vgic_init() is called.

If userspace invokes KVM_SIGNAL_MSI or triggers an irqfd before
KVM_DEV_ARM_VGIC_CTRL_INIT, neither __vgic_v5_its_resolve_lpi(),
vgic_v5_its_inject_msi(), nor vgic_v5_its_inject_cached_translation() checks
vgic_initialized(kvm). As a result, vgic_v5_its_inject_lpi() will pass
VGIC_V5_VM_ID_INVAL truncated to u16 (0xffff) to __vgic_v5_vdpend(), which
executes the hardware VDPEND instruction with an unallocated VM ID (or
targets another active VM using VM ID 0xffff).

Should the MSI resolution and injection paths check vgic_initialized(kvm)
before resolving translations or calling vgic_v5_its_inject_lpi()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102194454.4086=
911-1-sascha.bischoff@arm.com?part=3D9
