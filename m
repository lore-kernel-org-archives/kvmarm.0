Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C4E4314A6
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 10:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786100160; cv=none; b=fuMH/EREXUjj0Ok+20/Xo89T3NsiiLjVsglU0bZri64uvhVFNKKeFoeiZig/I0xsm7NH805Vt65eHuJ3DhnlJtAoe/2HH9FqggpEoEroWK6BucRG7b4/Jm6+CZRDfBmu+zwJ8nkoaTgxErqAon6ES2AJ1K+rUAKkevGTOYZBkYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786100160; c=relaxed/simple;
	bh=yYLy53MjRAkdqvx55kptFN+hi/XqzxTCaElLscgdbA4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V0tc1WYkpFsJGCs9DCJiSUJzUK7yDC9qnc5QxWOhQn2olAszIWlL/768ojydWpT6p97HxC5J4fQ7DcfCVvZ6Zkvk93cCupJxsI5ARlq/yAo4rLcFtUZ1qOmE8DmVnmKzMZij4EVr4QtF+9BZgdtcTC8ZD6u/veQ+JBZXdl7c+p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VdODDgEx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VdODDgEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D701F000E9;
	Fri,  7 Aug 2026 10:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786100158;
	bh=ngqp4nRAttx2b+P2gus0ty8d2qcikqYKkrNllluqntw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VdODDgExu1gg/JgPElwQS+Cvih1UonENtmSAnyIke8/49qt7v5eUKR5ktl9NAxqUC
	 ivpayKWAsbJlk5CTZ8FKsMSN1YsG68YDKey2xXeHy00lu9KuTT+AhaiEREqFBXrDnF
	 zcv6rtCg8duKqhKApF3cKsxZ1+QuXGPvpH7GacWdtjnzfS+kJsAh2qOlgCyUJpaMX9
	 R+kiJDRW1lzVpFih02xEViDNRczREjBaSQQQVWoj7xrp4we9WgKYVZ8UgVPlST2D4j
	 iKKTRGRhkVygskSLfBWq/3KsHqwCIXIQy5pSzGWM42R6oEB7CRVbpc3wUYdf+RwwiJ
	 3WyH9DEFmh+Fw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Don't leak the SPI array when
 init is retried
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807104102.2410744-3-fuad.tabba@linux.dev>
References: <20260807104102.2410744-1-fuad.tabba@linux.dev>
 <20260807104102.2410744-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 10:55:57 +0000
Message-Id: <20260807105558.73D701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] If `vgic_init()` fails after `vgic_v4_init()` succeeds, the VPE ar=
ray is left allocated but `vgic_initialized` remains false. Userspace can t=
hen create additional VCPUs and retry `vgic_init()`. The second `vgic_v4_in=
it()` returns early because the VPE array is already allocated, leaving the=
 new VCPUs without initialized VPE IRQs. When a new VCPU runs, `vgic_v4_loa=
d()` calls `irq_set_affinity()` with an uninitialized IRQ (0), which fails =
and triggers a host `WARN_ON`, causing a host-side denial of service.
--

--- Patch [2]: [PATCH v2 2/4] KVM: arm64: vgic: Don't leak the SPI array wh=
en init is retried ---
commit 11b9c8f9971b11e30ffc049a56071fafe4c7df73
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: vgic: Don't leak the SPI array when init is retried

This patch fixes a memory leak where up to 960 struct vgic_irq could be lea=
ked
if kvm_vgic_setup_default_irq_routing() fails and userspace retries
KVM_DEV_ARM_VGIC_CTRL_INIT. It resolves this by returning early from
kvm_vgic_dist_init() if dist->spis is already allocated.

> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-i=
nit.c
> index 907057881b26a..d4cf143f3ae6b 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -210,6 +210,9 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsign=
ed int nr_spis)
>  	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
>  	int i;
> =20
> +	if (dist->spis)
> +		return 0;
> +

[Severity: High]
This is a pre-existing issue, but since the commit message mentions mirrori=
ng
the early return behavior of vgic_v4_init(), does that original function
have a stale state bug on retry?

If vgic_init() fails after vgic_v4_init() successfully allocates
dist->its_vm.vpes, vgic_initialized remains false. If userspace then creates
an additional vCPU and retries KVM_DEV_ARM_VGIC_CTRL_INIT, vgic_v4_init()
returns early on the second attempt without allocating a VPE for the newly
created vCPU.

When the new vCPU runs, vgic_v3_load() unconditionally calls vgic_v4_load().
Because the VPE was never properly initialized for this new vCPU,
vgic_v4_load() passes an uninitialized vpe->irq (0) to irq_set_affinity():

arch/arm64/kvm/vgic/vgic-v4.c:vgic_v4_load() {
        ...
        err =3D irq_set_affinity(vpe->irq, cpumask_of(smp_processor_id()));
        ...
}

This fails with -EINVAL and triggers a WARN_ON in vgic_v3_load():

arch/arm64/kvm/vgic/vgic-v3.c:vgic_v3_load() {
        ...
        WARN_ON(vgic_v4_load(vcpu));
        ...
}

Could an unprivileged VMM repeatedly trigger this host WARN_ON by
deliberately failing the first initialization and adding a vCPU before
retrying?

Is this something that should be addressed alongside or before this leak fi=
x?

>  	dist->active_spis =3D (atomic_t)ATOMIC_INIT(0);
>  	dist->spis =3D kzalloc_objs(struct vgic_irq, nr_spis, GFP_KERNEL_ACCOUN=
T);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807104102.2410=
744-1-fuad.tabba@linux.dev?part=3D2
