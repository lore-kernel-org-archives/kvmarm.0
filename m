Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565714AC789
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 14:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881436; cv=pass; b=Qgq3OzP15xiyt5SgwK84ahPxVf9G6UOEXrNJ1s9bauHNrGd05/id4C3MDqPlTWuHHgHBXZ+VKmY20HuH6YpiJ/C9+IdrogBn0YbooBX/b42fiSRARIAmDmUpziB8H24ZZvFYVQLSwjmgG8gQ2SEuCDWCgGxo+wqW55YZYaBFcfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881436; c=relaxed/simple;
	bh=1QDA0timfcoG8ZtW/MI90fo/ipTU9sabn6dcwMEqYDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nUCIZomNrbrnils5u0b5W4kAxPWIqtNCqDKbqYe8epMLODM3Mqxga17sB1xAQvaGioaDKVqPfyI+R++P/Foto/YjboYxly3tMYWwGN0SLq4IIRUWPWK7mJqlRoHjwqaBmcrd5uZZCre2emdQHxTcjtHcIKhm7ksC9V4hIVpq4gY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1aL6ejZf; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1aL6ejZf"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ffbaaafac4so743181cf.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Jan 2026 06:10:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767881432; cv=none;
        d=google.com; s=arc-20240605;
        b=QJFFq7GcI9tiTx0VIK+4RVjPNHA4WuRKby1kkeoVZqRIRWsoEGhyHiIpHocb0yUwJv
         Ctw9+fDYMyioootmqELY6cpUAgoEb7wFccC7OexiwEJ18IlHRUrXpvL9oSw6teJVZVli
         myLpjVNMVt32KiGBGu1Vn/ykw7gNnveYoaSTglOQN24dGPDRy7NGyKYEOUvQXx9f5KNP
         2GKNdPjFZ9InGPBnX5HGweSE6E9V8vfmL0FAAQGnEO9kFm3C0mnx2J1rjhPoOMQV9/Ck
         ZO5EYbF6OKPhTWoDX5jW/nMCmq3ZOG5qhuWj0C36uZyISjJAHHPxILnngxX8m8xaRjnK
         /JUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HErK+ZAsiLkCooDCBi0EQVptvs7VIv5Dy3Hcl1WrQnM=;
        fh=p2zaCBVzdkUFkk/qvdTfO0XDuqy7UpU0devWByYX5Y0=;
        b=W0DzZtcuC19HBQt/DY3IZ5v8TkXR9ytMwrwGLky4RTq/Hr7P55DN6h+uXxpQHwTwno
         tq+kZUY/B379vaQ6oB1KP6rWlVOUn24YUKJSCCyyCakdaRVysYqbj01JOcwCOMiUKbDO
         /EdRc/Ewr4i+2RH9469G4FFAuwM9eDk/Gb7SBGnLsMDjLGoGJ2uVuT63P22IuZT9Uxtt
         vWk7PHYgUd329FT/rHDRKnvZuKW0lpZVIkGW2cG0YwaGw7Lig0GyOxGX2jTn8jIoK+Zh
         MHMH6NN9si0IR/QnC2du+3pFGFvCp2nLS7OywpvIPMKGPJ/MnHttV+WLCyEaTiWiVp1g
         e8Vw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767881432; x=1768486232; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HErK+ZAsiLkCooDCBi0EQVptvs7VIv5Dy3Hcl1WrQnM=;
        b=1aL6ejZfG+n1Se1QPk83JDvCc3B1aazdz5fgvQ0lLWhQiRTsKw6KfaglBzvw4zT7M2
         bAqPMsJICWmp5TEprncEOV7Z3qqFxRIfOjVUxwkXEL0lrVpg/eTB6z53QUl7stAoYUgi
         ZhHdsGX2pr7pGVmPLkNIMLVC9D6s+NkLJQJK3GqKEBMwkB4FLhINhVKniyE0H86l6aX2
         K9RfREDsxjhImGF+WLcn0aUBFFDxnToe/fwvn14C+QCenX79PeZHl7HqfhKp3DmAcUUz
         bT7QqjTUwc0Hdi6FcO2erqK9nn9Yobf4RcQRUcsNlcWzu2s6g7STKUn7FGnkxRpZOsOb
         RWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881432; x=1768486232;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HErK+ZAsiLkCooDCBi0EQVptvs7VIv5Dy3Hcl1WrQnM=;
        b=gLWd+iGj0loYJqjdCyHgk09DKjDqGSOHqSYeuaLnC1koMulsGC4wl+gjEM0zYlX/mq
         CFpsBtA14g+wGvov6W2bXjn2s4nAd+IphIQijLylBjiPK7KkCI6p5llw+lmV1CG+WDUu
         LXKJS7cepNWKyuosAJD2pHbEHwuTZlCYdNhAMtV5QP2sq15j0KnAWnnYGjmaUjS3xX8o
         MinpFDcZ9w5ivhXDP8oYuQx/H8VbPrHODMQ6CgogSuMAV8xFKVMpgJFRdZP3mCmmqjbH
         eYO73gpkvlJzIRksO0Co+NEWsDLc/QZQlehGsSyH/LeNEv1RzpOPBzDH17m0iee4ZK8W
         /Tkg==
X-Forwarded-Encrypted: i=1; AJvYcCVKng5m6x1zCfkkKB5cIUzYWGV3Y3+IK5G+t5kh79F3iIwIGN2jMa/JC3+rzj6PWiAVjNrNS5Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3EwsyWvsENjQxUPNmuebkf9X8cd1RQuoAGNG7oHZGgT7s7RfU
	/J1ROT1KaiwFL97j+4wGThyzRLMVgwb6W0LREJDTkYdyMS3LdQ18lyuPymapfdUgpJOs9mmsxyc
	l4Z+3lhSsErrC4gaYaqdd5EpzA81Jrb5C4mO1uLDA
X-Gm-Gg: AY/fxX4I8TRRiemY+t8VbbhwLIbABmG024g0Ug3UBGgD1Dbvj1QU6EKcs3DwA5TQ5AX
	KXKE12CKoP+sPFRqx5aheLR3ZXEZBHrIv7A4AvDAmvgD2m5989aq1TSw52Yv/fthWKY2/YWyHh+
	28UU5o0TLJY5MIgYRP+2AqElfDi+ZTgRu8AFGYHRBZN1LY0gfEuHd40ypGpBi8zllMnYEoE1SId
	TcN712iF0H5v2PUMGp0pXqyGZa8a39lcRiTZxMLzZv03uL1DpgisFUJ1h8As3AkxTpexvck
X-Received: by 2002:a05:622a:1489:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-4ffc099853bmr8042581cf.18.1767881431457; Thu, 08 Jan 2026
 06:10:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-9-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-9-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 8 Jan 2026 14:09:54 +0000
X-Gm-Features: AQt7F2rQXIZDgc9AB-_m9obzDaZR7vHikvpjlR9mwKIH8JfARH3pHLVi2pEmeM4
Message-ID: <CA+EHjTxAzGrgxtSbhb8f5cs4mj_mD31gOGhwUEZFN21xGfoKyg@mail.gmail.com>
Subject: Re: [PATCH v9 09/30] KVM: arm64: Rename SVE finalization constants to
 be more general
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> Due to the overlap between SVE and SME vector length configuration
> created by streaming mode SVE we will finalize both at once.  Rename the
> existing finalization to use _VEC (vector) for the naming to avoid
> confusion.
>
> Since this includes the userspace API we create an alias
> KVM_ARM_VCPU_VEC for the existing KVM_ARM_VCPU_SVE capability, existing
> code which does not enable SME will be unaffected and any SME only code
> will not need to use SVE constants.
>
> No functional change.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_host.h |  8 +++++---
>  arch/arm64/include/uapi/asm/kvm.h |  6 ++++++
>  arch/arm64/kvm/guest.c            | 10 +++++-----
>  arch/arm64/kvm/hyp/nvhe/pkvm.c    |  2 +-
>  arch/arm64/kvm/reset.c            | 20 ++++++++++----------
>  5 files changed, 27 insertions(+), 19 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e6d25db10a6b..0f3d26467bf0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -988,8 +988,8 @@ struct kvm_vcpu_arch {
>
>  /* KVM_ARM_VCPU_INIT completed */
>  #define VCPU_INITIALIZED       __vcpu_single_flag(cflags, BIT(0))
> -/* SVE config completed */
> -#define VCPU_SVE_FINALIZED     __vcpu_single_flag(cflags, BIT(1))
> +/* Vector config completed */
> +#define VCPU_VEC_FINALIZED     __vcpu_single_flag(cflags, BIT(1))
>  /* pKVM VCPU setup completed */
>  #define VCPU_PKVM_FINALIZED    __vcpu_single_flag(cflags, BIT(2))
>
> @@ -1062,6 +1062,8 @@ struct kvm_vcpu_arch {
>  #define vcpu_has_sve(vcpu)     kvm_has_sve((vcpu)->kvm)
>  #endif
>
> +#define vcpu_has_vec(vcpu) vcpu_has_sve(vcpu)
> +
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  #define vcpu_has_ptrauth(vcpu)                                         \
>         ((cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH) ||                \
> @@ -1458,7 +1460,7 @@ struct kvm *kvm_arch_alloc_vm(void);
>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>
> -#define kvm_arm_vcpu_sve_finalized(vcpu) vcpu_get_flag(vcpu, VCPU_SVE_FINALIZED)
> +#define kvm_arm_vcpu_vec_finalized(vcpu) vcpu_get_flag(vcpu, VCPU_VEC_FINALIZED)
>
>  #define kvm_has_mte(kvm)                                       \
>         (system_supports_mte() &&                               \
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index a792a599b9d6..c67564f02981 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -107,6 +107,12 @@ struct kvm_regs {
>  #define KVM_ARM_VCPU_HAS_EL2           7 /* Support nested virtualization */
>  #define KVM_ARM_VCPU_HAS_EL2_E2H0      8 /* Limit NV support to E2H RES0 */
>
> +/*
> + * An alias for _SVE since we finalize VL configuration for both SVE and SME
> + * simultaneously.
> + */
> +#define KVM_ARM_VCPU_VEC               KVM_ARM_VCPU_SVE
> +
>  struct kvm_vcpu_init {
>         __u32 target;
>         __u32 features[7];
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 1c87699fd886..d15aa2da1891 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -342,7 +342,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>         if (!vcpu_has_sve(vcpu))
>                 return -ENOENT;
>
> -       if (kvm_arm_vcpu_sve_finalized(vcpu))
> +       if (kvm_arm_vcpu_vec_finalized(vcpu))
>                 return -EPERM; /* too late! */
>
>         if (WARN_ON(vcpu->arch.sve_state))
> @@ -497,7 +497,7 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>         if (ret)
>                 return ret;
>
> -       if (!kvm_arm_vcpu_sve_finalized(vcpu))
> +       if (!kvm_arm_vcpu_vec_finalized(vcpu))
>                 return -EPERM;
>
>         if (copy_to_user(uptr, vcpu->arch.sve_state + region.koffset,
> @@ -523,7 +523,7 @@ static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>         if (ret)
>                 return ret;
>
> -       if (!kvm_arm_vcpu_sve_finalized(vcpu))
> +       if (!kvm_arm_vcpu_vec_finalized(vcpu))
>                 return -EPERM;
>
>         if (copy_from_user(vcpu->arch.sve_state + region.koffset, uptr,
> @@ -599,7 +599,7 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
>                 return 0;
>
>         /* Policed by KVM_GET_REG_LIST: */
> -       WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
> +       WARN_ON(!kvm_arm_vcpu_vec_finalized(vcpu));
>
>         return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
>                 + 1; /* KVM_REG_ARM64_SVE_VLS */
> @@ -617,7 +617,7 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
>                 return 0;
>
>         /* Policed by KVM_GET_REG_LIST: */
> -       WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
> +       WARN_ON(!kvm_arm_vcpu_vec_finalized(vcpu));
>
>         /*
>          * Enumerate this first, so that userspace can save/restore in
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 8911338961c5..b402dcb7691e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -445,7 +445,7 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
>         int ret = 0;
>
>         if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
> -               vcpu_clear_flag(vcpu, VCPU_SVE_FINALIZED);
> +               vcpu_clear_flag(vcpu, VCPU_VEC_FINALIZED);
>                 return 0;
>         }
>
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 959532422d3a..f7c63e145d54 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -92,7 +92,7 @@ static void kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
>   * Finalize vcpu's maximum SVE vector length, allocating
>   * vcpu->arch.sve_state as necessary.
>   */
> -static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
> +static int kvm_vcpu_finalize_vec(struct kvm_vcpu *vcpu)
>  {
>         void *buf;
>         unsigned int vl;
> @@ -122,21 +122,21 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
>         }
>
>         vcpu->arch.sve_state = buf;
> -       vcpu_set_flag(vcpu, VCPU_SVE_FINALIZED);
> +       vcpu_set_flag(vcpu, VCPU_VEC_FINALIZED);
>         return 0;
>  }
>
>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
>  {
>         switch (feature) {
> -       case KVM_ARM_VCPU_SVE:
> -               if (!vcpu_has_sve(vcpu))
> +       case KVM_ARM_VCPU_VEC:
> +               if (!vcpu_has_vec(vcpu))
>                         return -EINVAL;
>
> -               if (kvm_arm_vcpu_sve_finalized(vcpu))
> +               if (kvm_arm_vcpu_vec_finalized(vcpu))
>                         return -EPERM;
>
> -               return kvm_vcpu_finalize_sve(vcpu);
> +               return kvm_vcpu_finalize_vec(vcpu);
>         }
>
>         return -EINVAL;
> @@ -144,7 +144,7 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
>
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>  {
> -       if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
> +       if (vcpu_has_vec(vcpu) && !kvm_arm_vcpu_vec_finalized(vcpu))
>                 return false;
>
>         return true;
> @@ -163,7 +163,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>         kfree(vcpu->arch.ccsidr);
>  }
>
> -static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
> +static void kvm_vcpu_reset_vec(struct kvm_vcpu *vcpu)
>  {
>         if (vcpu_has_sve(vcpu))
>                 memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
> @@ -203,11 +203,11 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>         if (loaded)
>                 kvm_arch_vcpu_put(vcpu);
>
> -       if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
> +       if (!kvm_arm_vcpu_vec_finalized(vcpu)) {
>                 if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE))
>                         kvm_vcpu_enable_sve(vcpu);
>         } else {
> -               kvm_vcpu_reset_sve(vcpu);
> +               kvm_vcpu_reset_vec(vcpu);
>         }
>
>         if (vcpu_el1_is_32bit(vcpu))
>
> --
> 2.47.3
>
