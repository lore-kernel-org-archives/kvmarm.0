Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D16B3C345B
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773224759; cv=pass; b=mDJ+czCTSdTkzV1FWJWkMNzIPq0btuZzaBb4RH0s2abjwArRw6H422U1Eqhb4wbl5qyrAqgnQGmZyR/aRVIYvGBDXRSHvrgJoN1oXbBAdLMXyHPERvbCeZlKDpiZZpXQ0d5SG3x/ztsmqAB2xPaBEGDUUTMcM9c2E+xT93bTcow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773224759; c=relaxed/simple;
	bh=URa6r9t9vX97eVQJvp91CPvfKXz1diwM4WYfbDxDcJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eIDGssoi0G/LyRiLvQJjqVpuCdN/1Gdsag8qw7PB9MyIRHCc1I75xEh8YKsM1H9Im0o2MD3/WvjGlHHba+I1MLG5nQWglWo/iHc3/n7tas3G9MmOUX6/ifo6URqd3+T4IyvGgbmamZdcbpR1p1cnfz3Vdk7hKmgwroiw9kPUqMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kBlgXvEQ; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kBlgXvEQ"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-509062d829dso414151cf.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:25:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773224757; cv=none;
        d=google.com; s=arc-20240605;
        b=jYt0xMmAF3/N7xVLN8Avf/VtoZDI+hRgnEuHJN35FToMx7cwkPn/dhrVzR0krEYQOZ
         SDJ2Q0drdYuVu2Zsrrgf54w5WmP+YIAOdGb8kRENdjCn6Cr2bv43v02YepjpNzkvsW5D
         IMlaiSzsvgRdlTpmtalwr9pV5i7FPpaY0r5itVXyyZzWmsVXiYX6pNrE1uk5cGCp3h+K
         ZCKpiUseM4RSHSgR6zyaA4L+YSjXnl4KoYYI1fukZ6bS5na3tqVOhWJU38QO7Ro1oi20
         Yfzae9TFbb7Ngw0+eoBVFFwrv8uTy+3f8iPNk8N01ZMDRt/Pqwc4fjScnyTS1B3bEgml
         YU0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yebJ9YCpziYLTqYnhDBgUOk6iV8F2gnjHE9IcQ+90M8=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=Ndh4IOExr7S07hxdBx8Nteca9j8ZgWA7a5mRhct9QTdqLZQ/ORtA/4+TKT4N/8iPH8
         uumyzRjkf5VZMy/sm4jTOqWYmwQVUiBFXZRMaX19s9nQ+SWzU0Ji9TiEj5o9o3a4dX/O
         qhU1rqijyp2LWohxRoEcVR/0TonKLbBzyEZgtqBCx6zuoSzaqWUcVMyQv/E1Io0UJrYN
         Nl3/alTZ883KkWv4r+8sN3H40roRb0HaACI9UTWAWdKG6mrfQyjVDNx4PFmL3BbLflh9
         gnGew2XFmvvKJZMY3lO+XxQhqZW03IaMeWeXQRFfxJbZ5b38MlKXds0IbCA3hIFWzwUj
         YDjA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773224757; x=1773829557; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yebJ9YCpziYLTqYnhDBgUOk6iV8F2gnjHE9IcQ+90M8=;
        b=kBlgXvEQmXOvI4uMMDJ7YaVLZ8yHP5r5uG0tfqmxKwZW3Qyfa6NcHV7GTN/BomIAxl
         4gdSaihmk+5A+kAAWdz+iWzkb7Q6VVBW1wRtSlKC1teJhb65bxVvsObB7irPNk4+0WNo
         VVbk8F63Og+V7mkA9P37p7hUktMYqwP23BXcug2+2y/i9oaThysa9Qs/bT2zA1eZ5MGd
         tJ4P/cU4NdriEWPWZfUCfaIxzX4GL35u1tiAiJ2uIzXd5kt/UZnj0sL6B2W6856xydqH
         iAPim3QetW5oeGl9/6cCLX+Y+r9TiQjyLP6XERG47X1XVlvUKhajf2RX/GxlPZv4368J
         q01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224757; x=1773829557;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yebJ9YCpziYLTqYnhDBgUOk6iV8F2gnjHE9IcQ+90M8=;
        b=c5hvf25vLjv0tIBjCYYTz5zDKlN7gCzMME4x8EDoPBPDuuzyd2Iys1xvnw/Ej6+dah
         UpNbkc0w6Y6+H58d2vNARh7bmgcbDKoj/wQ40b8m4WVKqaW36osUooV1KIn8dmK6KjBy
         vwsPJPbhwfMPJrrwRgJoRZwO38WCY88VJbZEJQdk72oFQPo7dGO43bzCC4MrCiYRV9yK
         xntjlMuLMX6xLIqx8qNCib35qYx350MyFvDhRD53MJrnlLhP4q0n9xCBW30S1Ks1TP26
         cHSc+QML4zuBvT5o6paxholFMQbnvP2/ZpcdEGvFuexAGfPr0GY5JAGV4gPL5ohvZVjo
         gNqQ==
X-Gm-Message-State: AOJu0YxQ71uWLe7EnBhVoH85bAABVsWdm46s69W2sgHOhp7csvadWHoA
	N1V3kHIwpMeRQ0BhGCisL5A8wbd2zV7CviSUU0WUce2t9s9IN25l3ZcrJAFgZxwZDiAZnYbgGaW
	Bfw4QybbF8VXk1fwzK2XmZaH8bYOEP1l9rLEWsshZ
X-Gm-Gg: ATEYQzyiNSh7M0Ut72pbePzvt9nqr/g2xvw2+NI648+b2C9BEz4EmGS7SpN6OAc42Ig
	NXZNnnJzmhaI1sJTRwyldPAs1N3/hwIewpneuInNGJdqO6FnDiq4F26LSPNW/l1E0BJYQdaVBln
	+2tsZoQ6JeDzVzsO2Znl6faTDyiR0qGrqinf+y7QvY0gARyPQo8aDMGIbfbD/beCUKCuRWNr08+
	kdDvpOtE0CslHlSgJjVKZPz9v6xNt1iP6Z3eQg2B82mYiYMvFFMZBDMvAFmasyA1hMDknk0mZEh
	r7/a18Cfyq5WeYZPjiVOHf2FKGzNAgIF/WCPQuc1EckFKiHL
X-Received: by 2002:a05:622a:1a84:b0:501:4eae:dbfc with SMTP id
 d75a77b69052e-50939a1331fmr9273301cf.5.1773224756831; Wed, 11 Mar 2026
 03:25:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-31-will@kernel.org>
In-Reply-To: <20260305144351.17071-31-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:25:19 +0000
X-Gm-Features: AaiRm51vdHkDNojRuUoHaot0Yn8S1yI6_XmLto9_5Z_0EeFcRkb2eAqyUAQ5R7M
Message-ID: <CA+EHjTzzQzqLxwTAQCS3uXzSgJS9Yk-wbkF8dxzsJBXs4oBGJA@mail.gmail.com>
Subject: Re: [PATCH v3 30/36] KVM: arm64: Allow userspace to create protected
 VMs when pKVM is enabled
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:45, Will Deacon <will@kernel.org> wrote:
>
> Introduce a new VM type for KVM/arm64 to allow userspace to request the
> creation of a "protected VM" when the host has booted with pKVM enabled.
>
> For now, this depends on CONFIG_EXPERT and results in a taint on first
> use as many aspects of a protected VM are not yet protected!
>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_pkvm.h |  2 +-
>  arch/arm64/kvm/Kconfig            | 10 ++++++++++
>  arch/arm64/kvm/arm.c              |  8 +++++++-
>  arch/arm64/kvm/mmu.c              |  3 ---
>  arch/arm64/kvm/pkvm.c             | 11 ++++++++++-
>  include/uapi/linux/kvm.h          |  5 +++++
>  6 files changed, 33 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index 7041e398fb4c..2954b311128c 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -17,7 +17,7 @@
>
>  #define HYP_MEMBLOCK_REGIONS 128
>
> -int pkvm_init_host_vm(struct kvm *kvm);
> +int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
>  int pkvm_create_hyp_vm(struct kvm *kvm);
>  bool pkvm_hyp_vm_is_created(struct kvm *kvm);
>  void pkvm_destroy_hyp_vm(struct kvm *kvm);
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 7d1f22fd490b..e71f7fb6e89a 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -82,4 +82,14 @@ config PTDUMP_STAGE2_DEBUGFS
>
>           If in doubt, say N.
>
> +config PROTECTED_VM_UAPI
> +       bool "Expose protected VMs to userspace (experimental)"
> +       depends on KVM && EXPERT
> +       help
> +         Say Y here to enable experimental (i.e. in development)
> +         support for creating protected virtual machines using KVM's
> +         KVM_CREATE_VM ioctl() when booted with pKVM enabled.
> +
> +         Unless you are a KVM developer, say N.
> +
>  endif # VIRTUALIZATION
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3589fc08266c..c2b666a46893 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -203,6 +203,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
>         int ret;
>
> +       if (type & ~KVM_VM_TYPE_ARM_MASK)
> +               return -EINVAL;
> +
>         mutex_init(&kvm->arch.config_lock);
>
>  #ifdef CONFIG_LOCKDEP
> @@ -234,9 +237,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>                  * If any failures occur after this is successful, make sure to
>                  * call __pkvm_unreserve_vm to unreserve the VM in hyp.
>                  */
> -               ret = pkvm_init_host_vm(kvm);
> +               ret = pkvm_init_host_vm(kvm, type);
>                 if (ret)
>                         goto err_uninit_mmu;
> +       } else if (type & KVM_VM_TYPE_ARM_PROTECTED) {
> +               ret = -EINVAL;
> +               goto err_uninit_mmu;
>         }
>
>         kvm_vgic_early_init(kvm);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 4e64528d86a6..7655e4c61c4e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -881,9 +881,6 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
>         u64 mmfr0, mmfr1;
>         u32 phys_shift;
>
> -       if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> -               return -EINVAL;
> -
>         phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>         if (is_protected_kvm_enabled()) {
>                 phys_shift = kvm_ipa_limit;
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index da0a45dab203..d1eb6e23367e 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -219,9 +219,13 @@ void pkvm_destroy_hyp_vm(struct kvm *kvm)
>         mutex_unlock(&kvm->arch.config_lock);
>  }
>
> -int pkvm_init_host_vm(struct kvm *kvm)
> +int pkvm_init_host_vm(struct kvm *kvm, unsigned long type)
>  {
>         int ret;
> +       bool protected = type & KVM_VM_TYPE_ARM_PROTECTED;
> +
> +       if (protected && !IS_ENABLED(CONFIG_PROTECTED_VM_UAPI))
> +               return -EINVAL;
>
>         if (pkvm_hyp_vm_is_created(kvm))
>                 return -EINVAL;
> @@ -236,6 +240,11 @@ int pkvm_init_host_vm(struct kvm *kvm)
>                 return ret;
>
>         kvm->arch.pkvm.handle = ret;
> +       kvm->arch.pkvm.is_protected = protected;
> +       if (protected) {
> +               pr_warn_once("kvm: protected VMs are for development only, tainting kernel\n");
> +               add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> +       }
>
>         return 0;
>  }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 65500f5db379..50348efe3384 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -699,6 +699,11 @@ struct kvm_enable_cap {
>  #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK  0xffULL
>  #define KVM_VM_TYPE_ARM_IPA_SIZE(x)            \
>         ((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> +
> +#define KVM_VM_TYPE_ARM_PROTECTED      (1UL << 31)
> +#define KVM_VM_TYPE_ARM_MASK           (KVM_VM_TYPE_ARM_IPA_SIZE_MASK | \
> +                                        KVM_VM_TYPE_ARM_PROTECTED)
> +
>  /*
>   * ioctls for /dev/kvm fds:
>   */
> --
> 2.53.0.473.g4a7958ca14-goog
>
