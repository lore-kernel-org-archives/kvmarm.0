Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65F638F239
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 11:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784029554; cv=none; b=VhDi0dd91lXgNymkIq2R1nPm2LeV+KrvgOXKCRGARs51GMACGwMGy30TAeHezL3QB+JC1ndOLgH6bF0d2mdb7oMfGsmH6nYok+J+O37KtazKMQ3qRP5PKU/QtLL9x0aZNddDt9xrRG8pWcG9zbOiY8Y1jveaLT3qx04ozEAQt0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784029554; c=relaxed/simple;
	bh=BEtUv5XHazbkKt+dlLWpdzQxAaUNzNIGDit24h4+Nwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A+igl/gjwD7uekaL2XEdoTz9em04I0uHY8uhnvBz6K4CMlCleCHZ1NQ8tHQlQTd4IvX64YpzOwutaZX0uX2dUVLzdIvgtnkO81NavlIgwSvQrSurMOVn2fkdtJ1FqL+QeIQFf8+CkjxmIhured/fiD+yx81blOVHpepT/T65WSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nv1B24vA; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nv1B24vA"
X-Forwarded-Encrypted: i=1; AHgh+Rozv4KXltemjnSg81A6sUKGUpsD+zxNk9Sc90OtiakETMxtWAXD1v630XBn/ht0J3Jy9H8ijn8=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784029549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0pDkRGaYym4iXIoAiNyXfWBGsGWfcCCYMQLXWrwDv3A=;
	b=nv1B24vAFYryvAp9Nkme/TlKmriqgOPulqdV3xxREvqQPyaGZ1iM/30P97xBmBFujfWBvq
	NiUpLnf2Xx//aOyq8bFSoFgaBL3imOa/Fpk1kjgi+imsQVEVtzRjJCBS3hunYE1QtVV+mO
	UCjgaeQwey611/h9B2a1G4YcKGVY9rE=
X-Gm-Message-State: AOJu0YxG97YANe551RKv9tmne26x5jI0EhasvDoIuHjb1KA1jMJT6bQb
	Fc6OmRrjQ0ZxqrqeUBq5iAm/4Tay48yonhAhuQjcBk1wAz9Rbj++I+wMjQp9SSTetPUZ0tIZRq/
	1p9wadi4bJQSPHr2cF57WLiGn3RmveX2App8ux4LT
X-Received: by 2002:ac8:7fd1:0:b0:51c:9ad:d76 with SMTP id d75a77b69052e-51d7c6a8b03mr14122751cf.19.1784029540491;
 Tue, 14 Jul 2026 04:45:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260714110756.116950-1-alexandru.elisei@arm.com>
In-Reply-To: <20260714110756.116950-1-alexandru.elisei@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 12:44:57 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxFAqO38zZNTM5oQ26X7eUcu3ggfhMY2gn2bB4sMbOxoQ@mail.gmail.com>
X-Gm-Features: AUfX_mzZY9UVGBmT0JoFJAIUngCEaTE6JMkLfV1PK-I1CCi-zORRCvzJSWUlQsw
Message-ID: <CA+EHjTxFAqO38zZNTM5oQ26X7eUcu3ggfhMY2gn2bB4sMbOxoQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Reject guest_memfd memslots when the VM has MTE
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	catalin.marinas@arm.com, will@kernel.org, steven.price@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Alex,

On Tue, 14 Jul 2026 at 12:08, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
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

nit: s/explicitely/explicitly/

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
> Forbid guest_memfd memslots unconditionally when the VM has MTE to prevent
> this from happening.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Is this worth a Fixes: tag?

> ---

git am chokes here: this kvmtool snippet between '---' and the real
diff parses as a stray patch fragment ("patch fragment without
header"). Worth indenting it or moving it below a scissors line ("--
>8 --") so the patch applies, though didn't test to see if this
actually works :)

>
> Tested by using Fuad's patches to add guest_memfd support for kvmtool at [1],
> with the following changes to arm64/kvm.c:
>
> @@ -125,10 +125,12 @@ static void kvm__arch_enable_mte(struct kvm *kvm)
>                 return;
>         }
>
> +       /*
>         if (kvm->cfg.arch.guest_memfd) {
>                 pr_debug("MTE is incompatible with guest_memfd");
>                 return;
>         }
> +       */
>
>         if (kvm->cfg.arch.mte_disabled) {
>                 pr_debug("MTE disabled by user");
>
> and kvm.c:
>
> @@ -332,8 +332,15 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
>                                 .guest_memfd_offset     = guest_memfd_offset,
>                         };
>
> +                       if (munmap(userspace_addr, size) < 0)
> +                               die_perror("munmap hack");
> +
>                         ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2,
>                                     &mem2);
> +
> +                       if (mmap(userspace_addr, size, PROT_RW, MAP_SHARED | MAP_FIXED,
> +                           guest_memfd, guest_memfd_offset) == MAP_FAILED)
> +                               die_perror("mmap hack");
>                 } else {
>                         struct kvm_userspace_memory_region mem = {
>                                 .slot                   = slot,
>
> (not pasting the full diff because last time I did, git got confused and
> considered the snippet part of the actual patch).
>
> Without this patch, I was able to create a VM with MTE and guest_memfd
> backed ram (the guest reported MTE as enabled, but I didn't test that it
> actually worked).
>
> With this patch, creating a VM with MTE is rejected.
>
> [1] https://lore.kernel.org/kvmarm/20260712142536.1391557-1-fuad.tabba@linux.dev/
>
>  arch/arm64/kvm/mmu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6c941aaa10c6..30c2ea235fa5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2648,8 +2648,11 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>         /*
>          * Only support guest_memfd backed memslots with mappable memory, since
>          * there aren't any CoCo VMs that support only private memory on arm64.
> +        *
> +        * MTE is also not supported with guest_memfd.
>          */
> -       if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
> +       if (kvm_slot_has_gmem(new) &&
> +           (kvm_has_mte(kvm) || !kvm_memslot_is_gmem_only(new)))
>                 return -EINVAL;

This folds two unrelated rejections into one condition. I'd split them
so each carries its own comment:

        /* guest_memfd is incompatible with MTE. */
        if (kvm_slot_has_gmem(new) && kvm_has_mte(kvm))
            return -EINVAL;

        /*
         * Only support guest_memfd backed memslots with mappable memory,
         * since there aren't any CoCo VMs that support only private memory
         * on arm64.
         */
        if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
            return -EINVAL;

More importantly, this only closes one direction.
prepare_memory_region() runs on memslot changes, but KVM_CAP_ARM_MTE
gates only on !kvm->created_vcpus and never looks at memslots, so the
reverse order still gets you there:

      1. KVM_SET_USER_MEMORY_REGION2 with a gmem slot   (no MTE yet -> ok)
      2. KVM_ENABLE_CAP(KVM_CAP_ARM_MTE) (no vCPUs -> ok)

Since the justification is that userspace can do unexpected things,
the enable-MTE path wants the symmetric check too (reject if a gmem
memslot already exists), or enforce the invariant at one choke point.

Cheers,
/fuad

>
>         hva = new->userspace_addr;
>
> base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
> --
> 2.55.0
>
