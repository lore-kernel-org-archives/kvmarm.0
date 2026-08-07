Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A03377A94;
	Fri,  7 Aug 2026 12:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786106725; cv=none; b=US5NP7zUxFz8aLLfoIAmfOOfZZ7mrEfgiO3ifh77JEtEnq3OmNG9U66d51u1UgYrLwQ6GlmcAUEnZhBL7x2IcVvjcihELqUENEyZKrtTSq2MKnS3IIb7H9Nxq7FkCLYbz9qVeYGQmoEBpVnSjuJ9D2vigrmuez1U+PZOn2m+lT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786106725; c=relaxed/simple;
	bh=z3MWH8FQ+VqnWZCXz9/GG62IWk2tLpg3iEwYrR67Ei0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=b/6MqChTLAmYPmor/C7xphZOfze2otOfkAOnHO+AZjz270GWh9T/TqAGRdHx1tQ9LVArY/Ftq+xfHvF7OCbYvMs2LfsNP47duGI+Sor2q6vYn+t2wKhTObfjLUEP36Q4sqNJiosAZZpliPpkWQ0sBwNdgXYW4Fle0aUtyMexdzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecdMOHM0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecdMOHM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED85C1F000E9;
	Fri,  7 Aug 2026 12:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786106707;
	bh=djE3xSiyAN63rSUMhMcgfW7trxnIPRyisecoCvXluok=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ecdMOHM0mcCNvw5YFZlxnBNABguGenZi9L70r4Y8ey34mnHClXGnG5ei/WMyi5bLi
	 OefFFlUzkN4zq00+U1tbSnBx9aH4Nhx7651wzkNed5JhtMESHJXP9e1d5BBJDgWvIV
	 IEsIiKY7ZID3LET5qii8DDevEpvLP9ZRvqfva9riGsJQOTUZtktabZAR2rXJvCK5m3
	 0+D8pzhDO43kzkVY9X/uhN/LxUvEx3cNgf3I8a6/5puozkc4xi+/f7B2iSK1FejxXO
	 rFDFyAV5EjJETakloeaHOsJHGjYXMS8X2sQ0owCx3lokXwmu3PzIQpu2zp1v3uNfTC
	 OL6M1cjd5O1Fw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 08/49] KVM: arm64: gic-v5: Add VPE doorbell domain
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807111159.429128-9-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-9-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 12:45:06 +0000
Message-Id: <20260807124506.ED85C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Resource leak of GICv5 VPE doorbell domain and fwnode on VGIC init=
ialization retry.
- [High] TOCTOU race between `KVM_CREATE_VCPU` and `KVM_DEV_ARM_VGIC_CTRL_I=
NIT` leads to undersized doorbell domain allocation.
- [Medium] Fwnode ID collision for VMs created by the same userspace thread.
- [Low] Unreachable dead code in doorbell domain error handling path.
--

--- Patch [8]: [PATCH v5 08/49] KVM: arm64: gic-v5: Add VPE doorbell domain=
 ---
commit 087989feef3777beedf75a01512da5b9e331b6fa
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
KVM: arm64: gic-v5: Add VPE doorbell domain

This commit adds support for a per-VM VPE doorbell irq domain for GICv5.
It creates the domain under the GICv5 LPI domain with one doorbell allocated
per VPE, and stores the state for later IRS commands and wakeups.

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 41ca2098ecb73..752329fc3d566 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> +static int vgic_v5_create_per_vm_domain(struct kvm *kvm)
> +{
> +	struct vgic_v5_vm *vm =3D &kvm->arch.vgic.gicv5_vm;
> +	int nr_vcpus =3D atomic_read(&kvm->online_vcpus);

[Severity: High]
Can a race condition here lead to an undersized doorbell domain allocation?

If a userspace thread calls the initialization ioctl, it checks for concurr=
ent
VCPU creation, but this check is performed locklessly with respect to the
kvm->lock held during VCPU creation.

Concurrently, a second thread could create a VCPU, which takes kvm->lock and
increments created_vcpus. Since initialization hasn't completed yet, VCPU
creation is allowed to proceed.

When the first thread reaches this point, it allocates exactly the number
of online VCPUs at this moment. As the second thread completes and incremen=
ts
online_vcpus, the VM now has more VCPUs than allocated doorbell IRQs, which
can lead to out-of-bounds IRQ array access later.

> +	int id =3D task_pid_nr(current);
> +	int ret, db_virq =3D 0;
> +
> +	if (!gicv5_global_data.lpi_domain) {
> +		kvm_err("LPI domain uninitialized, can't set up KVM Doorbells\n");
> +		return -ENODEV;
> +	}
> +
> +	vm->fwnode =3D irq_domain_alloc_named_id_fwnode("GICv5-vpe-db", id);

[Severity: High]
Can this leak the GICv5 VPE doorbell domain and fwnode if initialization
is retried?

If the initialization fails later in the setup process (for example, if
kvm_vgic_setup_default_irq_routing() fails in vgic_init()), the VGIC state
remains uninitialized.

If userspace then retries the initialization, this function is called again
and unconditionally allocates a new fwnode and IRQ domain, overwriting
the previous pointers without freeing them.


[Severity: Medium]
Could using the thread ID here cause fwnode naming collisions?

Since task_pid_nr(current) is used as the ID for the fwnode name, a single
VMM thread sequentially creating multiple KVM VMs will cause them to share
the exact same fwnode name.

When the IRQ domain is registered, this duplicate name causes debugfs
directory creation failures due to the directory already being present.

Would it be more reliable to use the VM's unique vm_id instead?

> +	if (!vm->fwnode)
> +		return -ENOMEM;
[ ... ]
> +	db_virq =3D irq_domain_alloc_irqs(vm->domain, nr_vcpus, NUMA_NO_NODE, v=
m);
> +	if (db_virq <=3D 0) {
> +		ret =3D db_virq;
> +		goto err;
> +	}
> +
> +	kvm->arch.vgic.gicv5_vm.vpe_db_base =3D db_virq;
> +
> +	return 0;
> +
> +err:
> +	if (db_virq > 0)

[Severity: Low]
Is this error cleanup path unreachable?

The only branch that jumps to the err label after modifying db_virq
explicitly checks that db_virq is less than or equal to 0.

Because db_virq can never be strictly positive at this label, the
irq_domain_free_irqs() block will never be executed.

> +		irq_domain_free_irqs(db_virq, nr_vcpus);
> +	if (vm->domain)
> +		irq_domain_remove(vm->domain);
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D8
