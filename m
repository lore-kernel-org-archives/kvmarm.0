Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFFE36E489;
	Fri,  7 Aug 2026 13:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786110155; cv=none; b=n/YjTVeFk1vZwGZqU7QrTsIA6vwesIa1Ns6DmnOfVYqXxvu0R00SzEIK5/qoyil+BCqAi8kgWgueKotK6QT8pL4Uwm6yxs0P/7Ph91T/yxOYnh288Hn5100IwUtzUocQ0BMEpyqfH1WbNTteZKX6tBVe4lmhnJ0ongMAnHD6Pb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786110155; c=relaxed/simple;
	bh=0qTZY2rYVonI0I5bMZjWiyhf9ag9oE82Ex3GO04v+nI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lOLucXaptqfbaRiUFhU4T8srXFGzx/sojeyLPkjYRtbhBH0sVznsVb8YTW2TL6vqe3oqhu8nCPYbPMAUm76yc/F+y6Y83KFbFxNkVI4ixyJ3zn+hWSyCUCKCm7DQmTmRhhAdgycKrhkIQ7A7KxdGpvY6PbTssF53DlN72yjHmTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+/U/s7d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+/U/s7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CABB1F00A3A;
	Fri,  7 Aug 2026 13:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786110146;
	bh=nuY+faEGU5Tvk3b/r4vpPFp9mTBMycX0+Iy4afdKLiI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g+/U/s7d+RiiVDfPRZ56YyhixkiMM6PBI1ym51tbWWEQxoJTW6qTTlPObhpvWuyiD
	 MvtAMbYZo3C6iJEK90l8C6xwRBdxSpxxEnoTMVMFczq16NX4eIsOSGSDwltn4ubxYo
	 77Y1pIfXWrFhbVeoB20JgqkJfwEuSbFcsRCv/7N/+zK3K2S7ghqRnPUI5tJ6fDpFs8
	 hNSvKO/qVEN3sNkKXs+oGDkDhrAjYAs8D5tTmqn39fI22z2qGH2OjemUkdOToD978r
	 Zb9nOArIDVRSlc+vtl3DK8sfbS4aGI8GUofOwy33jm3YfYil2H/YN82DJK4bf40KFM
	 YstFKto46LBYQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 14/49] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260807111159.429128-15-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-15-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 13:42:25 +0000
Message-Id: <20260807134226.3CABB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Double-teardown vulnerability allows corrupted VMTE slots to be re=
used, subverting the explicit VM ID leak mechanism.
- [Medium] vgic_v5_create_per_vm_domain uses task_pid_nr(current) for the f=
wnode name, causing debugfs collisions for multiple VMs in the same process.
--

--- Patch [14]: [PATCH v5 14/49] KVM: arm64: gic-v5: Set up VMTEs and VPE d=
oorbells ---
commit 7e8599087432413da91f2b37e503a3ba7e749684
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells

A GICv5 VM needs a VM table entry before it can use SPIs and LPIs,
which are backed by the host IRS. The VM table itself is created at
probe time, but each VM still needs to claim and populate one VMTE
before it can use those interrupts. Allocate a VM ID during
vgic_v5_init() and create a per-VM VPE doorbell irq domain.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 2121f67d3b59c..f15a8309d7a93 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> @@ -491,20 +524,10 @@ static int vgic_v5_create_per_vm_domain(struct kvm =
*kvm)
>  	int id =3D task_pid_nr(current);
>  	int ret, db_virq =3D 0;
> =20
> -	if (!gicv5_global_data.lpi_domain) {
> -		kvm_err("LPI domain uninitialized, can't set up KVM Doorbells\n");
> -		return -ENODEV;
> -	}
> -
>  	vm->fwnode =3D irq_domain_alloc_named_id_fwnode("GICv5-vpe-db", id);

[Severity: Medium]
Does using task_pid_nr() here cause debugfs collisions if a single process
creates multiple VMs?

If userspace instantiates multiple GICv5 VMs within the same process, they
will share the same PID. The irq_domain_alloc_named_id_fwnode() call would
then create a fwnode based on the PID instead of a unique identifier like
the VM ID.

Destroying the first VM removes the shared directory, breaking it for the
remaining VMs.

[ ... ]
> +void vgic_v5_teardown(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist =3D &kvm->arch.vgic;
> +	struct kvm_vcpu *vcpu, *vcpu0;
> +	bool release_vm_id =3D true;
> +	unsigned long i;
> +	int rc;
> +
> +	lockdep_assert_held(&kvm->arch.config_lock);
> +
> +	/*
> +	 * If the VM's ID isn't valid, then we either failed init very early or
> +	 * we've been called a second time. Nothing to do here in either case.
> +	 */
> +	if (kvm->arch.vgic.gicv5_vm.vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
> +		return;
> +
> +	if (kvm->arch.vgic.gicv5_vm.vmte_allocated) {
> +		/* Make the VM invalid  */
> +		vcpu0 =3D kvm_get_vcpu(kvm, 0);
> +		rc =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_INVALID);
> +		if (rc) {
> +			kvm_err("could not make VMTE invalid\n");
> +			release_vm_id =3D false;
> +			goto out_free_doorbells;
> +		}
> +
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			if (vgic_v5_vmte_free_vpe(vcpu)) {
> +				kvm_err("Failed to free VPE\n");
> +				release_vm_id =3D false;
> +			}
> +		}
> +
> +		if (vgic_v5_vmte_release(kvm)) {
> +			kvm_err("Failed to release VM 0x%x\n", dist->gicv5_vm.vm_id);
> +			release_vm_id =3D false;
> +		}
> +	}

[Severity: High]
Could a double-teardown incorrectly release the VM ID despite a previous
failure here, allowing corrupted VMTE slots to be reused?

During the first run of vgic_v5_teardown(), if vgic_v5_vmte_free_vpe() fail=
s,
release_vm_id is set to false to leak the VM ID and prevent reuse. However,
if vgic_v5_vmte_release() then succeeds, it will clear vmte_allocated.

> +
> +out_free_doorbells:
> +	vgic_v5_free_doorbells(kvm, atomic_read(&kvm->online_vcpus));
> +	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
> +
> +	/*
> +	 * We only release the VM ID itself if we didn't fail earlier. It does
> +	 * mean that we might lose the VM ID (and associated VMTE, etc), but
> +	 * given that we've failed to tear them down correctly there's no way to
> +	 * safely reuse them. The VM ID allocating IDA will make sure we don't
> +	 * accidentally reuse this partially torn down state.
> +	 */
> +	if (release_vm_id)
> +		vgic_v5_release_vm_id(kvm);
> +}

When vgic_v5_teardown() is called a second time (e.g., on VM destruction
after an initial failure), vm_id is still valid, but vmte_allocated is now
false. This causes it to bypass the block that sets release_vm_id to false
on errors.

Because release_vm_id defaults to true at the top of the function, it then
proceeds to unconditionally release the VM ID, subverting the safety
mechanism and potentially leading to hardware state corruption.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D14
