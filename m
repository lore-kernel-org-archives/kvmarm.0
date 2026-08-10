Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA6E3BED30;
	Mon, 10 Aug 2026 11:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786360576; cv=none; b=Tyz279dD6/J4d0yeWMoY86AS4rNTX6u6mM6SUQL7Cbj6uRI7yGOpEDXSTlnHSUTIsFPdN2LnBWCebrg7zj0LRjHuPQCXK9aXhVhq+/YET5ZkSeug1pRenyqpFUpHdLEJiMNxRz1P7RN6Ss369iwBnsXy6MFqZeENlNMdEnLK8eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786360576; c=relaxed/simple;
	bh=uEUhT3YIVexjE7DIMB/gsT6flEZfJYWdAkkA82o3gWY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=necrgtcW/Bmw9pxkRJELrBoPdjn/WrbuIJwYLT1smKi+h0uaoM+P7JRQyFqaKndSyD9YJ899ug1Ze+pbTFfI3AqM6fqcDfFVIEU1l3jffdyzQgTUW+et1RKD6PSZmsokBsMNJaN7a3Lkl8qNBB6EFyl1B3uuV0VQWlv/3MjNHsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HANZfPUy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HANZfPUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC731F000E9;
	Mon, 10 Aug 2026 11:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786360575;
	bh=5GkJ60QfR59Z1ddarWazchyTjT6S4Ti5bYVuNBSD5Ug=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HANZfPUyLhM4BbCc2ZLgA/oIUtPpqUpvFh6zfP2nDuGFhQjH1ht1s5WkGn7eLiYmf
	 OPOu3HAW6fHZaNQtH+ZcflPCYV36FL/+3LBTb1oy7tiG9SKCLdBK+9YaJuIgoL1die
	 CYXQpJN9nD7TLxYEFal/LxBK0fegzqqbphY0ApA0N6TVkI5vFEgWhKloJ7gMLYoQPB
	 ozIbydFL6xoarbLiQYdxDpz7Ho/C8GbUrejlQXA3+394sDvYLrc9UYMN6bY7qkhUea
	 KQnnm1zdEtJZiVmiBbitiiNL52HpR4Asmzl6q5fmhwyp5ylhHUiVwpfcFNXiA7og4M
	 o6W69oH/PjA7g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] KVM: arm64: vgic: Reject out-of-range GICv5 PPI IDs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260810102652.758719-6-sascha.bischoff@arm.com>
References: <20260810102652.758719-1-sascha.bischoff@arm.com>
 <20260810102652.758719-6-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 10 Aug 2026 11:16:14 +0000
Message-Id: <20260810111614.DDC731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Returning NULL for out-of-range GICv5 PPIs causes a determinis=
tic host kernel panic via NULL pointer dereference or BUG_ON() during timer=
 initialization with user-controlled inputs.
--

--- Patch [5]: [PATCH 5/5] KVM: arm64: vgic: Reject out-of-range GICv5 PPI =
IDs ---
commit b745364de86ed8f379d9297c2d334e7a734654d6
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: vgic: Reject out-of-range GICv5 PPI IDs

The commit prevents KVM from clamping out-of-range GICv5 PPIs to index 0.
It introduces a check in vgic_get_vcpu_irq() that returns NULL when the
extracted hardware IRQ ID exceeds the supported range.

Link: https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischo=
ff@arm.com?part=3D27

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 3077cfdaa146d..d0c91f0c52698 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -118,6 +118,8 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *v=
cpu, u32 intid)
>  		switch (type) {
>  		case KVM_DEV_TYPE_ARM_VGIC_V5:
>  			intid =3D vgic_v5_get_hwirq_id(intid);
> +			if (intid >=3D VGIC_V5_NR_PRIVATE_IRQS)
> +				return NULL;

[Severity: Critical]
Does returning NULL here allow a malicious userspace process to trigger a h=
ost
kernel panic?

If a user configures a VM and sets the timer IRQ to an out-of-bounds GICv5 =
PPI
ID (>=3D 64) via the KVM_SET_DEVICE_ATTR ioctl, the input is validated using
irq_is_ppi(). Because irq_is_ppi() only checks the upper type bits for GICv=
5,
it accepts the invalid ID and stores it.

When the vCPU is subsequently run, kvm_timer_enable() initializes the timers
and calls functions like kvm_vgic_set_owner() and kvm_vgic_map_phys_irq() w=
ith
the out-of-bounds IRQ. These callers lack NULL checks and assume the return=
ed
pointer is valid.

For example, kvm_vgic_set_owner() unconditionally dereferences it:

arch/arm64/kvm/vgic/vgic.c:kvm_vgic_set_owner() {
	irq =3D vgic_get_vcpu_irq(vcpu, intid);
	raw_spin_lock_irqsave(&irq->irq_lock, flags);
	...
}

And kvm_vgic_map_phys_irq() explicitly asserts it with BUG_ON():

arch/arm64/kvm/vgic/vgic.c:kvm_vgic_map_phys_irq() {
	struct vgic_irq *irq =3D vgic_get_vcpu_irq(vcpu, vintid);
	...
	BUG_ON(!irq);
	...
}

Should the boundary check be enforced earlier, such as during the ioctl
validation itself, to prevent storing the invalid ID and crashing during
timer initialization?

>  			intid =3D array_index_nospec(intid, VGIC_V5_NR_PRIVATE_IRQS);
>  			break;
>  		default:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260810102652.7587=
19-1-sascha.bischoff@arm.com?part=3D5
