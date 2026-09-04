Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0FD3ACF02;
	Fri,  4 Sep 2026 12:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524778; cv=none; b=qzWBidYqdwuCMgOdVXkurX8quzE2dCnBBaDWa+yhDVIseC/k8y5q+2hAc2p2ZH7g5HCu89GkU3uylMT2a2hO4ZfJ1AJhyKVgChdvb6ttR/8b1vVA0wQWvE9x/r8/WEkSOytlq/WmusBWlx5ElFxfaLji2YWfIdbQZUVqQi0jIQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524778; c=relaxed/simple;
	bh=8hWoCpG3MDz9Nai9QCYj7bpUR4/Jvr61ZoipuZF5XCU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Kw6fSrUw9+dvDH08koaPBQKyKudfplru3WJ5rQKVVUD/Y72lfBJIpJQ+dFXQXKI7nd1gW/Ykew0JOoizyRG4wxiqSIxIggsTkAf+C4Gd4FYyOrweYk1S2sjdovxcBNZvstzzksVwN1jNkqTPkgxAo8mBViwGMwcyM+Rig00wN1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O/Ah4ont; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/Ah4ont"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC971F00A3D;
	Fri,  4 Sep 2026 12:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788524776;
	bh=IbBdIDir00PwGv1WL5vJc6jAfKTNGYDBuMxIAuyFCKI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O/Ah4ontIFWLg8+rlDrSZfxqIa1SFa2Jf48T8Sx17jcX60lkWpJqOf2/0D8g+HYmc
	 7fWqHneQ1dm8w2yWshK8MmbSN9VMf8Ed/rTBrgRWHbMC/ZrmXdlk/dwFLEdaQKzh5E
	 5a1y1kC2VnZx1faG/GbG5aesvcUutCYWs0vysGpBr1Mt7OZvs0ISndEfTl+XGoy/nD
	 xKMy7h2snYb92YvZZ8RX0Vy0t3Q5n5yZtAZrU/e2GLEf06skSruev2V4vXgjij7ftA
	 WLH/TUCyDUvficOXX4vN7wnZz1JnfA15PhaWpfyBhOPMKYub9NRCEENqZK4LImdYo3
	 F+fjnp0wS3+iQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 08/49] KVM: arm64: gic-v5: Add VPE doorbell domain
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260904113404.4051341-9-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-9-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 12:26:15 +0000
Message-Id: <20260904122616.4FC971F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Concurrent VCPU creation during vGIC initialization causes und=
er-allocation of resources leading to out-of-bounds access.
--

commit e10bd8258f90674edeba15cbc5bdb3a9de97b8ef
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add VPE doorbell domain

This commit adds support for a per-VM VPE doorbell irq domain for GICv5.
It creates one doorbell per VPE under the GICv5 LPI domain and populates
the doorbell IRQ number in the GICv5 CPU interface state.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index e75a66b3920aa..60bb39421ad08 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> @@ -125,6 +126,137 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
[ ... ]
> +static int vgic_v5_create_per_vm_domain(struct kvm *kvm)
> +{
> +	struct vgic_v5_vm *vm =3D &kvm->arch.vgic.gicv5_vm;
> +	int nr_vcpus =3D atomic_read(&kvm->online_vcpus);
> +	int id =3D task_pid_nr(current);
> +	int ret, db_virq =3D 0;
> +
> +	if (!gicv5_global_data.lpi_domain) {
> +		kvm_err("LPI domain uninitialized, can't set up KVM Doorbells\n");
> +		return -ENODEV;
> +	}
> +
> +	vm->fwnode =3D irq_domain_alloc_named_id_fwnode("GICv5-vpe-db", id);
> +	if (!vm->fwnode)
> +		return -ENOMEM;
> +
> +	/*
> +	 * KVM per-VM VPE DB domain; child of LPI domain; only ever handles
> +	 * doorbells. We know how many doorbells we have, and therefore we
> +	 * create a linear domain.
> +	 */
> +	vm->domain =3D irq_domain_create_hierarchy(gicv5_global_data.lpi_domain,
> +						 0, nr_vcpus, vm->fwnode,
> +						 &vgic_v5_irq_db_domain_ops, vm);
> +	if (!vm->domain) {
> +		ret =3D -ENOMEM;
> +		goto err;
> +	}
> +
> +	db_virq =3D irq_domain_alloc_irqs(vm->domain, nr_vcpus, NUMA_NO_NODE, v=
m);

[Severity: Critical]
This is a pre-existing issue, but does this allocation race with concurrent
VCPU creation, leading to an under-sized doorbell domain and potential
out-of-bounds access?

Looking at vgic_init() in arch/arm64/kvm/vgic/vgic-init.c, it guards against
ongoing VCPU creation with a lockless check:

    if (kvm->created_vcpus !=3D atomic_read(&kvm->online_vcpus))
            return -EBUSY;

If Thread 1 calls KVM_CREATE_VCPU and acquires kvm->lock, Thread 2 could
concurrently call KVM_DEV_ARM_VGIC_CTRL_INIT and acquire config_lock.

If Thread 2 evaluates the lockless check in vgic_init() before Thread 1
increments created_vcpus, Thread 2 proceeds to allocate resources sized to
the current online_vcpus count here in vgic_v5_create_per_vm_domain().

Once Thread 1 finishes creating its VCPU and increments online_vcpus, later
accesses by the new VCPU might exceed the allocated doorbell array bounds.
While this problem already affected GICv4 VPE allocation, this patch
introduces a new vulnerable allocation for GICv5 doorbell IRQs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D8
