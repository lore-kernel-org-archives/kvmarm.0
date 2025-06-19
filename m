Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474CC1B3923
	for <kvmarm@lists.linux.dev>; Thu, 19 Jun 2025 14:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750343758; cv=none; b=tlEahv+wX8r+wipBNkt1GYk0Ma6NiGoiU/LS0SAp6iUBcT5l+oQy0oaPTC93PGnJJUOAjJ67PtcAfbVF4T/Qyruqp52V5OSc91OjF2V0x0Yz1i55cAmHpdJ8mHwfzJH1qIYDbhQXjaPIcVzuRPqeSe7vICKHGbDs6fiVO10jwLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750343758; c=relaxed/simple;
	bh=Z/ZmwjrUc4czR5qHO4rU7Izvbpsb7lx5/j8DRvqPxMs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h1+EXi8GiFQvo0eSW4bf273Nt15qptQZ6w6zUNU0prpqxWZzaEIlzdkhn3ovsV4tRfB1m+i0maCDEaSKTRMSeyNtACFIZOaJftM6S923PL8ecz2d15nWfTvxz1uTjHT4eg2Yc3y8I25sPZBXkqvT+hk8cJjMQrPErW29V+wxXdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KeeuIbgA; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KeeuIbgA"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-47e9fea29easo350301cf.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Jun 2025 07:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750343756; x=1750948556; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GB1ZFeK0F7/foKhy2m/gacA/n223vC5lbnfCSum8o78=;
        b=KeeuIbgA3mhHEGfkqTBe4ApR1v+ehxllO1S6FvxuJw5u3oWu2h5txWrr849evLZiXb
         OutVcO16SmLd9fKAKEm3Drl2qqDMlW4O9UDbk8DlhtHxvMjT8290QxXprxfRfYNIK0CN
         DXrMCCRxQ/QN5J3v2I6HY2qbOf9hju47TO3O9gdC52oBRjSzBXU+zjmPaZI5+bZ8ls6h
         1ztOjx3g/Fd/OR6vLsMrpWcAMPDfrzGkt0xgKh4usYqYzvBYA8UAch65Z0ZbL+8KrcgP
         mSSmk6Fm6q3WKV06mS21SkhNxnVNxNJz6bClgUoOGHjrfSlrhGtMUj9g1PCNI1iZrMyE
         SoVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750343756; x=1750948556;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GB1ZFeK0F7/foKhy2m/gacA/n223vC5lbnfCSum8o78=;
        b=QfLcWSp17m61SVdCCUmFQf2la9K8CAiS4vkFGVXFoTYTpZZ2AYfKSdm/eGVcL47Svm
         B3gAzavZraPwpIx0AI3p7/zg9WWr0UGfQL1mDuSfZ/wN3AKxmAy3OcaWsf9wojVyyxCn
         oFRmHJipmUq/LISk488D4T0OnPY0TBfEYcLwL6mduIXdQMAJcKB9RGydPbzlt+kBSUaZ
         0AXM9bhw2fHUoIbABQ4mAfHc7EOK+BQqRyAsikAnoTEdoa3YAtR3tX5GAOUwZ2ZKGjts
         UyTq9zIMyukCDlhJr6Hf7nrobHL3f0lR7HsS3UT2DgVgE9/3oLHktj4j6WI0mMunxVL7
         tuYA==
X-Forwarded-Encrypted: i=1; AJvYcCVQw3eYrf/n/TvqPKYemij0A6KZxXVl+GzkhtWmcYfR9Xhy2or4O+THCgPoinSqOdS3YpuOzzk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxP/pZp/rN5uHUAznaqi+A7MMat2/t1kiPzfIlv2nWu2sZpQMS2
	1EmnLt05/GN6ZEAa3UwwMrB2nwvT1NqqJbM1Qrw8yLE8s2dSZF0/zd8a0rKfMk/9VY1BFdv/5Li
	+wMcChGmxscQ8B/Fsy7EZowsGjkNw1SYRS2sIy5Zu
X-Gm-Gg: ASbGncu6nBmo6UeymNtjFpcZh55M6Fqu9bGQ8BDfbyFrr3RQn++5q8Jv9AT6wdT1QnJ
	+Zp4OQtjUqbTKFDWKJuWFCSHQIrwf5AWNIOFnLiMiJAlfg+x8CaPM6+afWlL/TjLaX3HqT3WHCE
	tirgx0GWprzQSAyO8ikvjOKbO11cvHjevI7UoiaPdP4o4=
X-Google-Smtp-Source: AGHT+IFOXuR0RhkMrX3ZxxsSI6jbCIoGAFGDxUMS3k8eUMINFPUVszvTwPwAd5BnYl5dVCeTXrzjtZb+swp4bOehBSs=
X-Received: by 2002:a05:622a:34b:b0:4a6:f9d2:b547 with SMTP id
 d75a77b69052e-4a76ebb4dbfmr3964161cf.20.1750343755818; Thu, 19 Jun 2025
 07:35:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250619134817.4075340-1-mark.rutland@arm.com>
In-Reply-To: <20250619134817.4075340-1-mark.rutland@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 19 Jun 2025 15:35:18 +0100
X-Gm-Features: Ac12FXyjFicj4m99JQKlEGx3CWSSdfG3VGA9blZkYP0rHuRThVuDKKDqEPvH6Ts
Message-ID: <CA+EHjTxtH3JDsOmQLvw4oVMmvixTbADuVTs9ckLYwTU+EfryYg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Remove kvm_arch_vcpu_run_map_fp()
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, broonie@kernel.org, 
	catalin.marinas@arm.com, kvmarm@lists.linux.dev, maz@kernel.org, 
	oliver.upton@linux.dev, will@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 19 Jun 2025 at 14:48, Mark Rutland <mark.rutland@arm.com> wrote:
>
> Historically KVM hyp code saved the host's FPSIMD state into the hosts's
> fpsimd_state memory, and so it was necessary to map this into the hyp
> Stage-1 mappings before running a vCPU.
>
> This is no longer necessary as of commits:
>
> * fbc7e61195e2 ("KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state")
> * 8eca7f6d5100 ("KVM: arm64: Remove host FPSIMD saving for non-protected KVM")
>
> Since those commits, we eagerly save the host's FPSIMD state before
> calling into hyp to run a vCPU, and hyp code never reads nor writes the
> host's fpsimd_state memory. There's no longer any need to map the host's
> fpsimd_state memory into the hyp Stage-1, and kvm_arch_vcpu_run_map_fp()
> is unnecessary but benign.
>
> Remove kvm_arch_vcpu_run_map_fp(). Currently there is no code to perform
> a corresponding unmap, and we never mapped the host's SVE or SME state
> into the hyp Stage-1, so no other code needs to be removed.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Will Deacon <will@kernel.org>
> Cc: kvmarm@lists.linux.dev
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 -
>  arch/arm64/kvm/arm.c              |  4 ----
>  arch/arm64/kvm/fpsimd.c           | 26 --------------------------
>  3 files changed, 31 deletions(-)

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks!
/fuad

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5ccca509dff1a..f7ad74404202b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1482,7 +1482,6 @@ int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm,
>                                         struct reg_mask_range *range);
>
>  /* Guest/host FPSIMD coordination helpers */
> -int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index de2b4e9c9f9fb..1502faa460863 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -825,10 +825,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>         if (!kvm_arm_vcpu_is_finalized(vcpu))
>                 return -EPERM;
>
> -       ret = kvm_arch_vcpu_run_map_fp(vcpu);
> -       if (ret)
> -               return ret;
> -
>         if (likely(vcpu_has_run_once(vcpu)))
>                 return 0;
>
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 8f6c8f57c6b9c..15e17aca1dec0 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -14,32 +14,6 @@
>  #include <asm/kvm_mmu.h>
>  #include <asm/sysreg.h>
>
> -/*
> - * Called on entry to KVM_RUN unless this vcpu previously ran at least
> - * once and the most recent prior KVM_RUN for this vcpu was called from
> - * the same task as current (highly likely).
> - *
> - * This is guaranteed to execute before kvm_arch_vcpu_load_fp(vcpu),
> - * such that on entering hyp the relevant parts of current are already
> - * mapped.
> - */
> -int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
> -{
> -       struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
> -       int ret;
> -
> -       /* pKVM has its own tracking of the host fpsimd state. */
> -       if (is_protected_kvm_enabled())
> -               return 0;
> -
> -       /* Make sure the host task fpsimd state is visible to hyp: */
> -       ret = kvm_share_hyp(fpsimd, fpsimd + 1);
> -       if (ret)
> -               return ret;
> -
> -       return 0;
> -}
> -
>  /*
>   * Prepare vcpu for saving the host's FPSIMD state and loading the guest's.
>   * The actual loading is done by the FPSIMD access trap taken to hyp.
> --
> 2.30.2
>
