Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4699D339A1
	for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716388613; cv=none; b=DfpKHvMiYD8RQNWfmNVC/WQw9FP2BQ9ich2SY6HuIWDxf4BLTedh/10dSmyVYJKS37gXSa/jeH4qpOJLlwrT97Za8blyToxRtou6K1vYeO7QuDdVR+xLaTNm8uNcmsptprFjqrS3xSJzEPBBa7RlpWD2E2QsvaUdLUNW8LU2O0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716388613; c=relaxed/simple;
	bh=+9MtXmKr60GdcY0Gi+zeixKPRPxXxvKgWKC/KF3Jq9I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gd5cRMSkeN9n9q/d3wmUHa7WCglkFz29m0nw9N0nb7BFQ/vaZcXTqEN9UhXmlSMXiFtq86ZtEqTVgB+o6bY5FZdhYcycVHS694h8LgszLX37g4VRpTks3dmo4m7Ho0uqXLO6iiAmSd9CbNjRajkGC3IgtHA3dRpcJhvJcPaIFTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CtCK0lKh; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CtCK0lKh"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-47ef7e85cf0so1568508137.1
        for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 07:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716388611; x=1716993411; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9K59l2vRw3+Qt8d94j2uXZXagsSqYZYFq7iGK8ThrM=;
        b=CtCK0lKh/wyp2MtLrgYtJ9WYGhsOm44tmZfvuio8bVJU9/MMg8DIg2D3SNEGowb7L1
         c5b9dBOpCzar6G0daUEpHeXKHVkITI+fuCC+QfS9iXLIL31N0GlOERziUvuLiwr5sTqA
         MN5ReKAG2SUv+lNwLQ5TOwA5GLiWe3rPucgNmXyHDH1PJiXjruMJgrbfGECi7KwCiC8D
         n4r+bxSDDyOlTXHabwW5hE/3mOVqV046nFQr8OjrE4hX8bBjnbMEymLZbNHC/Dbaq74A
         6O5YhnxsU5ZfqStT+LF/aqXSyc/xP/IATh8e0OObii5UqvX1DzB3DHDurqGYgc14CWUq
         bTmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716388611; x=1716993411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q9K59l2vRw3+Qt8d94j2uXZXagsSqYZYFq7iGK8ThrM=;
        b=QhB/nQDD7e5WxGmgur1R4eaunL4MVGE7rtCyiPdZrdzTavImqIfak4OV3plW6Ox5eU
         wKR0UQJF9AidPWJ3fgsLsvULvbyHvzXwlZAqkvLbnvg5XeZztAE5BnxvKMxjZM34iwVF
         hv5ULw9biGDgbz6ldiZuFgXR3PlfZWlp/2nA56MvBL5rvd7Upoc6fHKCwfDd7QETLMfc
         GwH5QPACZgMEgobBEdieBFzDXl15Oza/hZorL7WS9aLkruK9x4lgRZpWqlU6m9fovAf1
         cGMgZvI5cW39vqQxsjn8FHxEvrgco+Ep2MPHmmAlJx2vU7EMkJ5+JfIdmPTrJtLMyvkN
         G3jg==
X-Gm-Message-State: AOJu0YyasE1deKUI8TGWZ5DSH8yBz/+0dMeccaolPq0Q3xLf5aWHz7Sw
	plPpa1UXW57yevvwTbEu255/Z9Fmz1CZBLJUemE9REQHOPc5fWbuP1oFeKyjybjDXsCe2q5YlTK
	pNJ3h7Z32YCtXQLREEAAb02Rro8GSZzIESr+N
X-Google-Smtp-Source: AGHT+IHciaxRJEeVsQN/tNQfOQVJhEPJbHcKDFhFYUT0uSAZvyBvQvtmdSEqSa3lwT6cuH5Aq/6f006deC35g9QCJYA=
X-Received: by 2002:a05:6102:3754:b0:47d:9617:b1dd with SMTP id
 ada2fe7eead31-48904d98e2amr2430840137.19.1716388610947; Wed, 22 May 2024
 07:36:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240521163720.3812851-1-tabba@google.com> <20240521163720.3812851-5-tabba@google.com>
 <86r0dun9nm.wl-maz@kernel.org>
In-Reply-To: <86r0dun9nm.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 22 May 2024 15:36:13 +0100
Message-ID: <CA+EHjTySE1V+2q2wKOuop00P0vSjpG8DVvWiw5NWNo0+ESWHXg@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: arm64: Store the maximum sve vector length at hyp
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	mark.rutland@arm.com, broonie@kernel.org, joey.gouly@arm.com, 
	rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Tue, May 21, 2024 at 10:21=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Tue, 21 May 2024 17:37:17 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > In subsequent patches, hyp needs to know the maximum sve vector
> > length for the host, without needing the trust the host for that.
> > This is used when allocating memory for the host sve state in the
> > following patch, as well as for allocating and restricting guest
> > sve state in a future patch series.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 1 +
> >  arch/arm64/include/asm/kvm_hyp.h  | 1 +
> >  arch/arm64/kvm/arm.c              | 1 +
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c    | 2 ++
> >  arch/arm64/kvm/reset.c            | 2 ++
> >  5 files changed, 7 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 8170c04fde91..0a5fceb20f3a 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -76,6 +76,7 @@ static inline enum kvm_mode kvm_get_mode(void) { retu=
rn KVM_MODE_NONE; };
> >  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> >
> >  extern unsigned int __ro_after_init kvm_sve_max_vl;
> > +extern unsigned int __ro_after_init kvm_host_sve_max_vl;
> >  int __init kvm_arm_init_sve(void);
> >
> >  u32 __attribute_const__ kvm_target_cpu(void);
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/=
kvm_hyp.h
> > index 2ab23589339a..d313adf53bef 100644
> > --- a/arch/arm64/include/asm/kvm_hyp.h
> > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > @@ -143,5 +143,6 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
> >
> >  extern unsigned long kvm_nvhe_sym(__icache_flags);
> >  extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
> > +extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
> >
> >  #endif /* __ARM64_KVM_HYP_H__ */
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 9996a989b52e..9e565ea3d645 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -2378,6 +2378,7 @@ static void kvm_hyp_init_symbols(void)
> >       kvm_nvhe_sym(id_aa64smfr0_el1_sys_val) =3D read_sanitised_ftr_reg=
(SYS_ID_AA64SMFR0_EL1);
> >       kvm_nvhe_sym(__icache_flags) =3D __icache_flags;
> >       kvm_nvhe_sym(kvm_arm_vmid_bits) =3D kvm_arm_vmid_bits;
> > +     kvm_nvhe_sym(kvm_host_sve_max_vl) =3D kvm_host_sve_max_vl;
> >  }
> >
> >  static int __init kvm_hyp_init_protection(u32 hyp_va_bits)
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/p=
kvm.c
> > index 16aa4875ddb8..25e9a94f6d76 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -18,6 +18,8 @@ unsigned long __icache_flags;
> >  /* Used by kvm_get_vttbr(). */
> >  unsigned int kvm_arm_vmid_bits;
> >
> > +unsigned int kvm_host_sve_max_vl;
> > +
> >  /*
> >   * Set trap register values based on features in ID_AA64PFR0.
> >   */
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index 1b7b58cb121f..e818727900ec 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -46,11 +46,13 @@ static u32 __ro_after_init kvm_ipa_limit;
> >                                PSR_AA32_I_BIT | PSR_AA32_F_BIT)
> >
> >  unsigned int __ro_after_init kvm_sve_max_vl;
> > +unsigned int __ro_after_init kvm_host_sve_max_vl;
> >
> >  int __init kvm_arm_init_sve(void)
> >  {
> >       if (system_supports_sve()) {
> >               kvm_sve_max_vl =3D sve_max_virtualisable_vl();
> > +             kvm_host_sve_max_vl =3D sve_max_vl();
>
> Why the intermediate storage?

It's not needed for this patch, but rather for the one that allocates
the memory for the host sve state, to be able to reuse the same
functions at el1 and hyp, e.g., pkvm_host_sve_state_size() . I'll move
it to where it's used or find a way of getting rid of it altogether.

> Setting kvm_nvhe_sym(kvm_host_sve_max_vl) to sve_max_vl() should be
> enough. But it doesn't mean that all the CPUs support the same max VL,
> and I wonder whether we end-up with the wrong in-memory layout in this
> case...

Looking at how the value behind sve_max_vl() is calculated
(vl_info[ARM64_VEC_SVE].max_vl;): it seems to store the maximum VL in
common to all CPUs, which in turn becomes a limit to the usable VLs in
the system as a whole.

So for example PR_SVE_SET_VL (sve_set_current_vl()) eventually comes
down to find_supported_vector_length(), which limits the VL set to the
lengths supported in vl_info[ARM64_VEC_SVE], which are system-wide
rather than per cpu.

So if my understanding is correct, I don't think we need to allocate
more memory than sve_max_vl() to store the host state. It shouldn't be
a problem in terms of layout either, as long as we consistently use it
for save and restore. Similar to how kvm_arch_vcpu_put_fp() always
uses the vcpu_sve_max_vq(). It does need to be documented, as you
mention in a later patch.

Thanks,
/fuad




>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
