Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BAA274658;
	Fri,  3 Jul 2026 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096060; cv=none; b=lanPhihvL1iHNlwRmyQpF9CcsttMbbHXJxniXomgOWl5I6mew3+p6EtpeaoGKDZxdBzzY/dhzK8gUoVpkL/SfBTNMi3eECdDxJCrC8d2t9v9rV1DCVUKHb5n4qVbJGKL16zvFG5DbEntUG/rWHjhGVpYUvLwPjDF2/lSJnu8m2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096060; c=relaxed/simple;
	bh=ANAFc+sUOa+MNGc3J1iA8O/vr4C5//nH1PBaGt0U8ZQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YPb9N60YuGHKdxWg6HMpK6OFNqFfuBni+2YF1GQaQeFlGOQ+JZR+/likAWc907vdkex1Lm4uYYz4RBHQdSWNDwGgePlmsAZid1A5Mam3F0L5AlImwxgi6uvqS3kFJYD1NvkPXNdCYfatNY7Ha1cG2Rd9ozM/mYU95hkURLVonXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JaYP+Zi4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JaYP+Zi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA701F000E9;
	Fri,  3 Jul 2026 16:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096058;
	bh=rUzpNBuYFph2/QMUg9F8olOH1vGxs/0vptOS+SUrUXI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JaYP+Zi4eVafWqpdKpxCQLOTFNuWhgMOzCLNqY/DrqT3FMiYe8FFgOqGVN1S0cVnH
	 +tnQR70pvQqp/0Fv59wcXL8wHZkpvBaSFsJXYOGdA/akMZfe2eGfBaqj+KpoXpmtvF
	 uLKuQL459EE0pLfN/6zzYGLn5fa4SasRq20zdzTrYgiSeyYaP1yTHqCCjimBB8uMmn
	 chMvdQ6iF1gSg8enuORKw+eBxAmT5K08ScBOosIG7ghRvxIIcj16HXku8Ru0em4EYy
	 nt6gWrVmtlaFFO/GS/TD6nIizEnySTtcOk+WuGoyq/jFBCA8M6qiDvKO1T1raOqiv+
	 7IGlxdoJwv/yw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 14/40] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260703154811.3355680-15-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-15-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:27:37 +0000
Message-Id: <20260703162738.4DA701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Early returns in `vgic_v5_teardown()` on hardware command failure =
skip software cleanup, leaking doorbell IRQs and causing a Use-After-Free o=
f VCPU structures.
--

commit 0e7cc2cc83975127589c6dbceb977e9f1bd837a2
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells

This commit introduces the initialization and teardown paths for GICv5 VM T=
able
Entries and VPE doorbells. It allocates a VM ID, configures a per-VM doorbe=
ll
IRQ domain, and creates handlers for managing doorbell interrupts per VCPU.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 6d7d9e6ed9dbf..f1cc36696669d 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c

[ ... ]

> +void vgic_v5_teardown(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist =3D &kvm->arch.vgic;
> +	struct kvm_vcpu *vcpu, *vcpu0;
> +	unsigned long i;
> +	int rc;
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
> +			return;

[Severity: High]
If the hardware command fails, this early return skips the rest of the
software cleanup including vgic_v5_free_doorbells(). The same applies to the
early return below if vgic_v5_vmte_release() fails.

If this happens during VM destruction, the VCPU structures will eventually
be freed. Since the doorbell IRQs are left active and registered with the
VCPU pointers, could a subsequent hardware doorbell IRQ fire and cause
db_handler() to write to the freed VCPU pointer, leading to a
use-after-free?

Is it possible to continue tearing down the software resources (like
freeing the doorbells) even if the hardware invalidation or release fails?

> +		}
> +
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			if (vgic_v5_vmte_free_vpe(vcpu))
> +				kvm_err("Failed to free VPE\n");
> +		}
> +
> +		if (vgic_v5_vmte_release(kvm)) {
> +			kvm_err("Failed to release VM 0x%x\n", dist->gicv5_vm.vm_id);
> +			return;
> +		}
> +	}
> +
> +	vgic_v5_free_doorbells(kvm, atomic_read(&kvm->online_vcpus));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D14
