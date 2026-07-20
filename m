Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2FA2BE7B6
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784560913; cv=none; b=o6QsCMQqn70advR7mGM2ZOQ12Vov3k0BfTkRKxgdK92he3OkLlsJUoNBBrJ3/xi30Fr/8sJe6WxoqLnuE036OMIvUz6Rvsl6sXbv26/9UaxQCQQwSual0cM+uFSSpba9U+8iLK7dM0lLVGWY7FRysLjYCc/Yq/iu+oHZykdJh2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784560913; c=relaxed/simple;
	bh=07MWN65rA/q+2mj3mHHooNxqH/kYq+POugcRxakmTzQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EjKWk48xYZLViUl0+iRnWRKQmYcZxNwJf0s5yf7lcVItF66o/SkCO0gSnl8lBmHMQx7MzjBDJm1oW48M1XD3JEnfHZ06QREOsDF2VrpB+xDSEA309BRyc0XuFSPy8opyha+BDvLtwe9owZADxOar2ASo7cJggtvEK9+tI9d2LoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=otGzMMgK; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="otGzMMgK"
X-Forwarded-Encrypted: i=1; AHgh+RrcFU2Cq3BiMPxGQEUJeo0vDPavwDkSWOZKqO9gpQK/jg+o0zL0IVrv88lMU1GD4dmmx03In8U=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784560909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pR0d5vXJntV8YWpyahhjgINvxifwuEFLOZnHeSDTT1U=;
	b=otGzMMgKQ4gqMbWTliFGRPzY75P3P4DXpAcmsWqfOmeHwlnar5wsXXIfHA0q/r0koFE+/v
	TYtD/8Vcvvmkfd+fD/gg3FjBcuenoZfniUyvL6nnAtPnp9K+Bmr5iGVfoavX9HXsBnCz+Y
	YkhXNfdT4pB8tSH+gGs5s0h2d4pnclw=
X-Gm-Message-State: AOJu0YwF8KMbkTwLngZEe6SoGYCL5grAZRJABu5FA9tm27dqZv/F7m2a
	oPn1l75ahpwKC4sg1l/0nv388Xhjqmgv/pzg0dvb2+GhMmOL7vLrCHhu4mR9moC6kgumQIzFzWG
	pIJbrzZqXt7NmqQ+G+MoXsx0WrS+hnBqHahb8v2/0
X-Received: by 2002:ac8:5a48:0:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-525ffcd074bmr2357411cf.1.1784560848685; Mon, 20 Jul 2026
 08:20:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720130942.135033-1-alexandru.elisei@arm.com>
In-Reply-To: <20260720130942.135033-1-alexandru.elisei@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 20 Jul 2026 16:20:11 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy90Y3mcjmWMVq0exDv+BL_ZywXS9ppab4mse8aTcprnQ@mail.gmail.com>
X-Gm-Features: AUfX_myRYMnudEm8zTjDOi3Lb7snKdugWnRSZfDpepQBEheVH7jJ17hpyI4P3QY
Message-ID: <CA+EHjTy90Y3mcjmWMVq0exDv+BL_ZywXS9ppab4mse8aTcprnQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Reject guest_memfd memslots when the VM
 has MTE
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	catalin.marinas@arm.com, will@kernel.org, steven.price@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 20 Jul 2026 at 14:10, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> The user cannot use MTE on VMAs created by mapping a guest_memfd file,
> as arch_calc_vm_flag_bits() does not set VM_MTE_ALLOWED.
>
> When creating a guest_memfd backed memslot,
> kvm_arch_prepare_memory_region() rejects the memslot if MTE is enabled for
> the VM and if guest_memfd has been mapped in a VMA that intersects the
> memslot.
>
> However, the documentation for KVM_SET_USER_MEMORY_REGION2 explicitly
> states that the only condition for userspace_addr is for it to be a legal
> userspace address, but the mapping is not required to be valid nor
> populated at memslot creation.
>
> If userspace sets userspace_addr to an address that hasn't been mapped, or
> if userspace_addr belongs to a VMA that isn't backed by the guest_memfd
> file, or if the VMA doesn't intersect the memslot, memslot creation is
> successful and KVM ends up with a VM with MTE and guest_memfd-backed
> memslots.
>
> The same happens if the order is reversed: when userspace enables MTE, KVM
> does not check if memslots backed by guest_memfd are already present.
>
> Fix both issues by rejecting guest_memfd-backed memslots when MTE is
> enabled, and by reject MTE when guest_memfd-backed memslots are already
> present.
>
> Fixes: 32e200bd6e44 ("KVM: arm64: Enable support for guest_memfd backed memory")
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>
> v1 can be found at [1].
>
> Changes in v2:
>
> * Added the Fixes tag (Fuad)
> * Split the condition in kvm_arch_prepare_memory_region() (Fuad)
> * Added the check in kvm_vm_ioctl_enable_cap() (Fuad)
>
> Tested by using Fuad's patches to add guest_memfd support for kvmtool at [2],
> with the following changes:
>
>         diff --git a/arm64/kvm.c b/arm64/kvm.c
>         index 36b3284e4a92..de83b5d7e517 100644
>         --- a/arm64/kvm.c
>         +++ b/arm64/kvm.c
>         @@ -125,10 +125,12 @@ static void kvm__arch_enable_mte(struct kvm *kvm)
>                         return;
>                 }
>
>         +       /*
>                 if (kvm->cfg.arch.guest_memfd) {
>                         pr_debug("MTE is incompatible with guest_memfd");
>                         return;
>                 }
>         +       */
>
>                 if (kvm->cfg.arch.mte_disabled) {
>                         pr_debug("MTE disabled by user");
>         diff --git a/kvm.c b/kvm.c
>         index 96583f916442..cc8628b558ea 100644
>         --- a/kvm.c
>         +++ b/kvm.c
>         @@ -332,8 +332,15 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
>                                         .guest_memfd_offset     = guest_memfd_offset,
>                                 };
>
>         +                       if (munmap(userspace_addr, size) < 0)
>         +                               die_perror("munmap hack");
>         +
>                                 ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2,
>                                             &mem2);
>         +
>         +                       if (mmap(userspace_addr, size, PROT_RW, MAP_SHARED | MAP_FIXED,
>         +                           guest_memfd, guest_memfd_offset) == MAP_FAILED)
>         +                               die_perror("mmap hack");
>                         } else {
>                                 struct kvm_userspace_memory_region mem = {
>                                         .slot                   = slot,
>
> (indentation is weird on purpose so git doesn't get confused). That's to
> test that the user can create a guest_memfd memslot after MTE has been
> enabled for the VM. Without this patch, I was able to create a VM with MTE
> and guest_memfd backed ram (the guest reported MTE as enabled, but I didn't
> test that it actually worked). With this patch, creating a VM with MTE is
> rejected.
>
> To test that KVM rejects enabling MTE *after* creating a guest_memfd backed
> memslot, I modified kvmtool to enable MTE *after* creating the memslot.
> Same situation: without this patch, KVM allows that, with this patch, KVM
> rejects enabling MTE.
>
> [1] https://lore.kernel.org/kvmarm/20260714110756.116950-1-alexandru.elisei@arm.com/
> [2] https://lore.kernel.org/kvmarm/20260712142536.1391557-1-fuad.tabba@linux.dev/
>
>  arch/arm64/kvm/arm.c | 25 +++++++++++++++++++------
>  arch/arm64/kvm/mmu.c |  4 ++++
>  2 files changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 50adfff75be8..9a6c72a18672 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -149,14 +149,27 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
>                         &kvm->arch.flags);
>                 break;
> -       case KVM_CAP_ARM_MTE:
> -               mutex_lock(&kvm->lock);
> -               if (system_supports_mte() && !kvm->created_vcpus) {
> -                       r = 0;
> -                       set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
> +       case KVM_CAP_ARM_MTE: {
> +               struct kvm_memory_slot *memslot;
> +               int bkt;
> +
> +               guard(mutex)(&kvm->lock);
> +               if (!system_supports_mte() || kvm->created_vcpus)
> +                       break;
> +
> +               r = 0;
> +               guard(mutex)(&kvm->slots_lock);
> +               kvm_for_each_memslot(memslot, bkt, kvm_memslots(kvm)) {
> +                       if (kvm_slot_has_gmem(memslot)) {
> +                               r = -EINVAL;
> +                               break;
> +                       }
>                 }
> -               mutex_unlock(&kvm->lock);
> +               if (r == 0)
> +                       set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
>                 break;
> +
> +       }
>         case KVM_CAP_ARM_SYSTEM_SUSPEND:
>                 r = 0;
>                 set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6c941aaa10c6..2d95203386ba 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2652,6 +2652,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>         if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
>                 return -EINVAL;
>
> +       /* guest_memfd is incompatible with MTE. */
> +       if (kvm_slot_has_gmem(new) && kvm_has_mte(kvm))
> +               return -EINVAL;
> +
>         hva = new->userspace_addr;
>         reg_end = hva + (new->npages << PAGE_SHIFT);
>
>
> base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
> --
> 2.55.0
>
