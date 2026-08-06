Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D5237F32F
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 06:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785998342; cv=none; b=JkBK2CiK6wzp/ZwQPUfcy+QDBs05TiPbLdZPEmG3kGE04HfYqzZFrB4Nvd0XZyKfwKV0AsVuhbL4ooV6HFAKNq+Z2TplUlqj9Cy9AEuc7INiW4heEfRs14Q/1YpqKCVYvYJ409lXJODTbMNyyk1pX7KXDs9HWj9linNcdQI8bG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785998342; c=relaxed/simple;
	bh=r04VANL75eAd3T873tXxbaxouKMgew4KzAlt7Ct2GT0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lfTSG5EocdQSOAks0xrskFnG1qYG/QpMTXQ29mq+E0Q4zNPqsKPsN1bx28Llx6qDd1BUAJzdWmlSY79M9DZP6mprC825eY+Jii1TGVoyt4xNFJ3aRPIF4cwzPuF+YrZmPKg4MElKzbVRpdzqVXGLtUx+jUQ53/ceo0HcQtFO2Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FAC/nShR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FAC/nShR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A981F000E9;
	Thu,  6 Aug 2026 06:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785998340;
	bh=LLJwu02eJqO74wAd1uevxhU0s8eEb1lbzPV8BLQ0S3k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FAC/nShR/3r0LvspkrKLLwBINtgaWZ+1P1mvDjHDyVX2Ui/i0AO2PtzmZ1yi6xudy
	 BiXtOEGtMMVEb/hLmdoh3NuZMU3i29+RD9UGqFwlt5gShQXxl7lxTlBWI3N/6GRtz1
	 8/z/yrvQSOZ7JfJqKm0ZxbqIKdUhhokyd+vEX4zj4Tk8eZ7ysGYtxusVNoDZJkOZG0
	 4e+dpMpt/ha0zlsV7WJ+jO1ycJpv1c7Fi2jaRegJsmv6MKU8P5nNPEZ6vorVXdPlXe
	 AOD0/Z2cNvIG80TuMhgigD7FRQuIjqeCzOhDRYyQPp1ZIDkVHlaQsGArNBRPtXGPLY
	 qj7n70+4/gSxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] KVM: arm64: nv: Keep the shadow S2 MMUs at fixed
 addresses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260806062352.93489-1-kmehltretter@gmail.com>
References: <20260806062352.93489-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 06:38:59 +0000
Message-Id: <20260806063900.66A981F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] Deterministic NULL pointer dereference and Use-After-Free race=
 on the `nested_mmus` array after `kvm_arch_flush_shadow_all` executes.

Pre-existing issues:
- [Critical] Deterministic NULL pointer dereference in `get_s2_mmu_nested` =
when `nested_mmus_size` is 0.
--

--- Patch [1]: [PATCH v2] KVM: arm64: nv: Keep the shadow S2 MMUs at fixed =
addresses ---
commit 70c0982ec06bd8ebb390c1b7ff665dae83887bb8
Author: Karl Mehltretter <kmehltretter@gmail.com>
KVM: arm64: nv: Keep the shadow S2 MMUs at fixed addresses

This patch turns the nested_mmus array into a fixed-size pointer table
allocated once during VM creation. The S2 MMUs are allocated individually
during vCPU initialization to keep their addresses stable, fixing a
slab-use-after-free issue.

v1: https://lore.kernel.org/r/20260803224405.41468-1-kmehltretter@gmail.com/

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -90,44 +104,44 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)

[ ... ]

>  	for (i =3D 0; i < S2_MMU_PER_VCPU; i++) {
>  		mmu =3D kzalloc_obj(*mmu, GFP_KERNEL_ACCOUNT);
>  		if (!mmu) {
>  			ret =3D -ENOMEM;
>  			goto err_free_mmus;
>  		}
> =20
>  		ret =3D init_nested_s2_mmu(kvm, mmu);
>  		if (ret) {
>  			kfree(mmu);
>  			goto err_free_vncr;
>  		}
> =20
>  		kvm->arch.nested_mmus[kvm->arch.nested_mmus_size + i] =3D mmu;

[Severity: Critical]
Can this lead to a NULL pointer dereference or use-after-free?

The patch shifts the allocation of kvm->arch.nested_mmus to VM creation in
kvm_init_nested(), but kvm_arch_flush_shadow_all() still frees the array and
sets the pointer to NULL and size to 0.

If an unprivileged user process triggers kvm_mmu_notifier_release(), for
example by passing the file descriptor to a child process and exiting,
kvm_arch_flush_shadow_all() will free the array.

A subsequent KVM_ARM_VCPU_INIT ioctl will bypass the size check in
kvm_vcpu_init_nested() because num_mmus is greater than 0 and
nested_mmus_size is 0. It will allocate an MMU and write it directly to
kvm->arch.nested_mmus[kvm->arch.nested_mmus_size + i], which dereferences
the now NULL pointer.

Additionally, since this write happens outside mmu_lock, it could race with
a concurrent kvm_arch_flush_shadow_all() execution and write into freed
memory.

[ ... ]

> @@ -805,7 +819,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kv=
m_vcpu *vcpu)
>  	for (i =3D kvm->arch.nested_mmus_next;
>  	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
>  	     i++) {
> -		s2_mmu =3D &kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
> +		s2_mmu =3D kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
> =20
>  		if (atomic_read(&s2_mmu->refcnt) =3D=3D 0)
>  			break;
>  	}

[Severity: Critical]
This is a pre-existing issue, but can this lead to a NULL pointer
dereference when nested_mmus_size is 0?

If kvm_arch_flush_shadow_all() executes while a vCPU is active, it sets
kvm->arch.nested_mmus_size to 0.

When the vCPU subsequently enters get_s2_mmu_nested(), lookup_s2_mmu()
evaluates the empty array and returns NULL, assigning NULL to s2_mmu.
The for loop condition i < (0 + next) evaluates to false, causing the loop
to be completely bypassed.

The function then executes BUG_ON(atomic_read(&s2_mmu->refcnt)) just below
this loop, which dereferences the uninitialized or NULL s2_mmu pointer.
This can be reliably triggered by terminating a VM process while it is
executing nested virtualization workloads.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806062352.9348=
9-1-kmehltretter@gmail.com?part=3D1
