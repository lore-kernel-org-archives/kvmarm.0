Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AFBC37701A;
	Thu,  6 Aug 2026 13:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786023508; cv=none; b=tpXP3ckTKwqGywyC8BpBAS2josazC9VnGPmdRWzgErp4chscalTi8dLY7/tjuEKbIHbffmKMQIft5KiUv+U8fx8SzDF27suLGjL7RxVu7nPpb4AcClrsa8vefOp9Aqrbn3qpccYOULksjvIku5rMt3ZbGSda3WsVj0Z2l4Glf2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786023508; c=relaxed/simple;
	bh=z3YSwN8nqDB8zYRT69/e2wdRfS99GYmTQ0XA1iOkQ2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eKttiMEo/9lbA0QxEMBYPshKUmJD9v9gtGQIMlOUp9f2kvXyNreU0X1aVQ92GydE3QJDwVJ66yD8wwOKewxOb8rAYmyvDpoCEwsyaH7bZ4+9kXzhSxETXGNRHkSFuMB5Ux/QOXLBD52dw8dkOhePUJgEzGMq/H7HiO32s7vFV28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UVfd6IF+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UVfd6IF+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE6B7153B;
	Thu,  6 Aug 2026 06:38:21 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6229B3F632;
	Thu,  6 Aug 2026 06:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786023506; bh=z3YSwN8nqDB8zYRT69/e2wdRfS99GYmTQ0XA1iOkQ2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UVfd6IF+LfO2/xp+dekn/5dzNIRMwsGQeIDnk2fI4wBlDDu/yHb3vJEoQvuAj8/3z
	 ZksRHB/5Rh3cVAj3QdC/iHW1Xp0iBoOJir8DDBvd8GzS+KQPgtj38lvKoQNxKxQmGT
	 mlXqYa48AyygWRGdmKfnHTnt/lcJyyGYUrxfII2E=
Date: Thu, 6 Aug 2026 14:38:11 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: sashiko-reviews@lists.linux.dev, 
	Karl Mehltretter <kmehltretter@gmail.com>
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2] KVM: arm64: nv: Keep the shadow S2 MMUs at fixed
 addresses
Message-ID: <ump35q2osiduwshuz2qoawpeirjwawch3prm4odto4mgzr37sg@3x7jvpivobji>
References: <20260806062352.93489-1-kmehltretter@gmail.com>
 <20260806063900.66A981F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260806063900.66A981F000E9@smtp.kernel.org>

On Thu, Aug 06, 2026 at 06:38:59AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [Critical] Deterministic NULL pointer dereference and Use-After-Free race on the `nested_mmus` array after `kvm_arch_flush_shadow_all` executes.
> 
> Pre-existing issues:
> - [Critical] Deterministic NULL pointer dereference in `get_s2_mmu_nested` when `nested_mmus_size` is 0.
> --
> 
> --- Patch [1]: [PATCH v2] KVM: arm64: nv: Keep the shadow S2 MMUs at fixed addresses ---
> commit 70c0982ec06bd8ebb390c1b7ff665dae83887bb8
> Author: Karl Mehltretter <kmehltretter@gmail.com>
> KVM: arm64: nv: Keep the shadow S2 MMUs at fixed addresses
> 
> This patch turns the nested_mmus array into a fixed-size pointer table
> allocated once during VM creation. The S2 MMUs are allocated individually
> during vCPU initialization to keep their addresses stable, fixing a
> slab-use-after-free issue.
> 
> v1: https://lore.kernel.org/r/20260803224405.41468-1-kmehltretter@gmail.com/
> 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -90,44 +104,44 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
> 
> [ ... ]
> 
> >  	for (i = 0; i < S2_MMU_PER_VCPU; i++) {
> >  		mmu = kzalloc_obj(*mmu, GFP_KERNEL_ACCOUNT);
> >  		if (!mmu) {
> >  			ret = -ENOMEM;
> >  			goto err_free_mmus;
> >  		}
> >  
> >  		ret = init_nested_s2_mmu(kvm, mmu);
> >  		if (ret) {
> >  			kfree(mmu);
> >  			goto err_free_vncr;
> >  		}
> >  
> >  		kvm->arch.nested_mmus[kvm->arch.nested_mmus_size + i] = mmu;
> 
> [Severity: Critical]
> Can this lead to a NULL pointer dereference or use-after-free?
> 
> The patch shifts the allocation of kvm->arch.nested_mmus to VM creation in
> kvm_init_nested(), but kvm_arch_flush_shadow_all() still frees the array and
> sets the pointer to NULL and size to 0.
> 
> If an unprivileged user process triggers kvm_mmu_notifier_release(), for
> example by passing the file descriptor to a child process and exiting,
> kvm_arch_flush_shadow_all() will free the array.
> 
> A subsequent KVM_ARM_VCPU_INIT ioctl will bypass the size check in
> kvm_vcpu_init_nested() because num_mmus is greater than 0 and
> nested_mmus_size is 0. It will allocate an MMU and write it directly to
> kvm->arch.nested_mmus[kvm->arch.nested_mmus_size + i], which dereferences
> the now NULL pointer.
> 
> Additionally, since this write happens outside mmu_lock, it could race with
> a concurrent kvm_arch_flush_shadow_all() execution and write into freed
> memory.

I don't think so. KVM_ARM_VCPU_INIT can not be run after
kvm_arch_flush_shadow_all() have started. kvm_arch_flush_shadow_all() starts
after the last use count of mm_struct is gone. Additionally vCPU/VM ioctls
require current->mm == kvm->mm. A non CLONE_VM child will fail, while a CLONE_VM
child keeps the mm_struct alive and kvm_arch_flush_shadow_all() can not run.

> 
> [ ... ]
> 
> > @@ -805,7 +819,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
> >  	for (i = kvm->arch.nested_mmus_next;
> >  	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
> >  	     i++) {
> > -		s2_mmu = &kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
> > +		s2_mmu = kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
> >  
> >  		if (atomic_read(&s2_mmu->refcnt) == 0)
> >  			break;
> >  	}
> 
> [Severity: Critical]
> This is a pre-existing issue, but can this lead to a NULL pointer
> dereference when nested_mmus_size is 0?
> 
> If kvm_arch_flush_shadow_all() executes while a vCPU is active, it sets
> kvm->arch.nested_mmus_size to 0.
> 
> When the vCPU subsequently enters get_s2_mmu_nested(), lookup_s2_mmu()
> evaluates the empty array and returns NULL, assigning NULL to s2_mmu.
> The for loop condition i < (0 + next) evaluates to false, causing the loop
> to be completely bypassed.
> 
> The function then executes BUG_ON(atomic_read(&s2_mmu->refcnt)) just below
> this loop, which dereferences the uninitialized or NULL s2_mmu pointer.
> This can be reliably triggered by terminating a VM process while it is
> executing nested virtualization workloads.

Same as the above.

Thanks,
Wei-Lin Chang

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260806062352.93489-1-kmehltretter@gmail.com?part=1
