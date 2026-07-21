Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1759582866
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 10:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784631154; cv=none; b=VLoIPSd1kPTecMgicPFbU1gnj8J0n3o1bFW0BW7XoMxmy/aQnxe/LLtmk8u6+DnS/MPpc8hl7vYxrU+BmdLXcHNKOLkVcr/Md3h0qNGl5/JIzJwt2q3QoC2fSM7amVBlgNA7qbbWyitTu7BGtfDHQGk/m7fCOMVbD+O8RQm02tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784631154; c=relaxed/simple;
	bh=jZb+AH6CvociyFjei0lbIoOfTKMS44c3rrgpAak1+0I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AuElsLr49hs/EpJQ8agnof2jTk2hGbaRfpikPly4zSJGNoyKDYKxDPxDZNAYK9BkwYCQ5fE+Vej3pM1mrz5iaK8mFv5zgMqR7uxBZF/NBjhQjKfiNd69S8LePYB7WkFTPfxKNH1gyk4TAYY4lGuDKDkBRhKr6AzPOEziJa2DGKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xCSa3agi; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xCSa3agi"
X-Forwarded-Encrypted: i=1; AHgh+RomV8YPaMkUO5kUkuDSMUoNWDWPFMJJuQ2za6MugfSNIwCPThr+rHsR69Ea7lqtkMoPTqhkmtM=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784631148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qwxGjo3C3PaTbZ1upD/wKWCbmcm+Dks40hLiS0mMgj0=;
	b=xCSa3agiFOnxctcvGKc07FCmHaL8ZUBMbhgz9xeL3c6WzOUbrl7caNkY/eAGYvNyoW4dPs
	gs/ZniO+iG/D+9WEXaR5o/PCyh5tP0ARCP/GhfvBv098GkH7hf5ZLLRxXFuUCrqTqN1mEy
	dFFvZHinDYwDHH7sBz69KQcEyDp+ksg=
X-Gm-Message-State: AOJu0YwJcnHllHHXW6CHdfdvEy6tcuDceIyaQbmwWHGHrUEW9NbJOXL9
	Jfm/1GpUDQEIzuZg+Z9lbssUvxa+1s2ed2w0/gv5aFYKtiu1nbAjAM0xCpNiS1vFIGQqXxnNDSz
	Oz1XkaZ6BOFMfMyIZEcgTuO9WQAU/IsxcYwd8Ff9r
X-Received: by 2002:a05:622a:2b47:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-525fcfa53f6mr13372511cf.0.1784631143501; Tue, 21 Jul 2026
 03:52:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260721100654.476582-1-alexandru.elisei@arm.com>
In-Reply-To: <20260721100654.476582-1-alexandru.elisei@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 21 Jul 2026 11:51:46 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxE_nzEmos5SKso5GuwVD=xzdiVWwe_PweRugw0Ry9LCg@mail.gmail.com>
X-Gm-Features: AUfX_mxoUdDr3Z0VPtcSLj2d9seKYTW01ZdyS0410ymZuRA_6deg14RYY6K9Jbo
Message-ID: <CA+EHjTxE_nzEmos5SKso5GuwVD=xzdiVWwe_PweRugw0Ry9LCg@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: arm64: Reject guest_memfd memslots when the VM
 has MTE
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	catalin.marinas@arm.com, will@kernel.org, steven.price@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Alex,

...

>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a5f9ee92f43e..53547fac5e37 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8414,6 +8414,11 @@ When this capability is enabled all memory in memslots must be mapped as
>  attempts to create a memslot with an invalid mmap will result in an
>  -EINVAL return.
>
> +``guest_memfd``, even though is an anonymous file, is incompatible with MTE.
> +Attempting to create a memslot backed by ``guest_memfd`` when the MTE capability
> +is enabled, or attempting to enable the MTE capability after ``guest_memfd``
> +backed memslots have been created, will result in an error.

A few couple of smaller things first: "even though _it_ is an
anonymous file". "guest_memfd backed memslots" could be hyphenated,
and "will result in an error" could be "will result in an -EINVAL
return" to match the paragraph above it.

On the wording itself, I would lean towards "not supported" rather
than "incompatible". The gmem fault path currently doesn't handle MTE
tags, but I don't think there's a fundamental reason this can't be
changed in the future.

With these fixed:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


>  When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
>  perform a bulk copy of tags to/from the guest.
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
