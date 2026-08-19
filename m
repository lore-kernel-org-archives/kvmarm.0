Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A2E391853;
	Wed, 19 Aug 2026 22:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787180334; cv=none; b=ftXIcSIG7wv4EJgwKRbfcgbGwy9MjKU3R02b1uVsvq9SUOW5TFmnGoZeCar6pIw8qnbiU6Ul9GIQ6Izrabt4tedUKizHpI0k1Bc1TCuODVtq0WnQdtF9bVUYGr7Gk+Edap45xCapG458sg2nxmzbTVVlq70WwK04gnwV7j4wQVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787180334; c=relaxed/simple;
	bh=eq++xDdLzF4x+nbQ3KCPYgqYIL31XBh48l8cow/6R4o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EfucVcN8BnKibZTH/NprFb9gzBHYcwAYlTbvdriv6DVq/V9XU8nPi1gTsZelct4BAuVU0q2SejTn13Qb3GaDRK2NyYx2LcjbLOOdJsppgH8i6O6kF9g8clxe8djftpVh8ZPnyL6G88ucTyQNqVRtA5UsP/pGkfK5rL13NmYjeaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aaan+2pw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aaan+2pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2A41F000E9;
	Wed, 19 Aug 2026 22:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787180332;
	bh=JK2MMBein/PX+ITeyw7t9tA2Gdi8rOoPB11Uh/nZfOQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aaan+2pwLlcxk/JCrWZ94N3wx6fTo65weenr8xrEW6FVHZQrtv9g0UNeRRyIvwuEB
	 6LimLEiaWSDW2a3f6NGXeh3X6Uje7/6lnhj7Qz87FLmP6D61kTGHeKsY64wcMNEpAS
	 C84NxalKRO4wnnapEwYDyLiPi2IP/JhYr7DuUJNJYn2vXXhBi0a9CX2ysnJDprC3/o
	 u/9hyPWllxsyq8OuL9kapFReLo6Z7UtLYMWdD76MN294Ul2STbW3d6FvXwFd6iP9c4
	 nnEeQXStKu/71UklRFkEQvc5YcA94+wOJgc21/FOIPVT+VAczngHgsISr8CSYx4Pyv
	 aJG5mN0zjbvdw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/5] KVM: arm64: vgic-v3: Reset assignments after
 failed region setup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260819224229.82948-3-kmehltretter@gmail.com>
References: <20260819224229.82948-1-kmehltretter@gmail.com>
 <20260819224229.82948-3-kmehltretter@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Aug 2026 22:58:52 +0000
Message-Id: <20260819225852.9C2A41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Naive decrement of `rdreg->free_index` during concurrent vCPU dest=
ruction corrupts the redistributor allocation state, causing overlapping MM=
IO base addresses.
--

--- Patch [2]: [PATCH v2 2/5] KVM: arm64: vgic-v3: Reset assignments after =
failed region setup ---
commit 00ec61ba92a90418f1516339ae4c96442b750b29
Author: Karl Mehltretter <kmehltretter@gmail.com>

KVM: arm64: vgic-v3: Reset assignments after failed region setup

This commit makes redistributor unregistration clear the cached
assignment and return the region slot to address an issue where a
failed REDIST_REGION write leaves redistributors partially registered.
It also updates the rollback path in vgic_register_all_redist_iodevs().

> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgi=
c-mmio-v3.c
> index c75caadbd1d3c..331d203acb430 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -852,6 +852,7 @@ void vgic_unregister_redist_iodev(struct kvm_vcpu *vc=
pu)
>  	struct vgic_io_device *rd_dev =3D &vcpu->arch.vgic_cpu.rd_iodev;
> =20
>  	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &rd_dev->dev);
> +	vgic_unassign_redist_iodev(vcpu);

[Severity: High]
Does calling vgic_unassign_redist_iodev() here corrupt the redistributor
allocation state during concurrent vCPU destruction?

Because vgic_unregister_redist_iodev() is also called from the vCPU error
path in __kvm_vgic_vcpu_destroy(), this could be triggered if a vCPU
creation fails.

If multiple vCPUs are created concurrently, and VCPU A and VCPU B acquire
their redistributor slots sequentially (e.g., slots X and X+1), and then
VCPU A's creation fails, the error path for VCPU A will call:

__kvm_vgic_vcpu_destroy()
  vgic_unregister_redist_iodev()
    vgic_unassign_redist_iodev()

This blindly decrements the free_index from X+2 to X+1, since
vgic_unassign_redist_iodev() assumes it is unassigning the most recently
allocated slot:

arch/arm64/kvm/vgic/vgic-mmio-v3.c:vgic_unassign_redist_iodev() {
	...
	if (vgic_cpu->rdreg) {
		vgic_cpu->rdreg->free_index--;
		vgic_cpu->rdreg =3D NULL;
	}
	...
}

When VCPU C is later created, will it be assigned slot X+1, leading to an
overlap with VCPU B's MMIO base address?

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819224229.8294=
8-1-kmehltretter@gmail.com?part=3D2
