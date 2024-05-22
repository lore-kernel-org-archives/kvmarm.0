Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498A9134AB
	for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 14:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716388713; cv=none; b=kE5x8jZrcZD/+BpCcfjotiJMcERrdPC9DwIbLPmUQwDYBjuCRayLqz5uOdSfXJaRTFSeOyFpWtkkKFUhlQAROudkvlOaffEvE54fRD9DupZNKmU+MDauE0uAfUgsZI0j64OVdPqZDEs0e4u89dCbTbXYKgCNBlQQk+hv5DfKF0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716388713; c=relaxed/simple;
	bh=86mekDN753abUNkTrRxUkRG4HZ/NstqepZc4uVqO8x4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pk7TvBX7LLdm2Oy5W1WGSflKnr9J/wpvXgU7rtqkjGSZvIcfNkVi2W4IQ8whaTL70zhQmflJ4fKBjCpUBAtZ52+q49h2yHWXGGiIbgwHJUjClUhyVsWQjs3KF/ZJYBQrEEoXt/m5+X6ZCXXjzKsiOSG04BX8cFBtLNzs2r54vOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bbHKYiwH; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bbHKYiwH"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-48571ec053dso474075137.0
        for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 07:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716388711; x=1716993511; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWhzq7pEgGq18Jmr/PAkWSm3ew+0wmK6EGNhRhC2MSQ=;
        b=bbHKYiwHDgqB9xxl5/EFFsar/PrWfknRJQDjFyLECx1miAzMcHfCvNgEkPb0O1c9BB
         U8W2S7onZnTKtSnajfxfVA8CdaWvinGX19+SHOUL0eOccIynrE5D/MSbHNLbeRyKVF5V
         ci6ltR8MAF8BiIvUKsDvEZdhin+yL3kmpiRD2VA/ORbv/e2j5McHUwxZivbCyCenbs1z
         bs0m+G0RDP/wFgq6PV/s08qlGBtbhXSwTm3QCCoP2m2a3L9Ml+TVeXy+X+FV2BVTbYS0
         rl+fPXO3ZnDps839pvkgEpD5RtJd0KEl+bDbcOiCCrx6EjyilGfCFNdrXFKsk3tX3X8A
         4bLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716388711; x=1716993511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XWhzq7pEgGq18Jmr/PAkWSm3ew+0wmK6EGNhRhC2MSQ=;
        b=J23dKb6Fu0MIQXhbMkqzfSZpnGbobxc8KttPjzyfRQlGaIvK5TlLyTf7ev+6UEF0Z7
         wpsRyl1cyKP7wrC27oVqJBxL8oZkhSAJJ0bI1gpf9PvhY2ls4MfF1Tp1hb7sG+Oy+oj9
         XJd8K1wY1gaC8K0t4RhY4kSpev5tjlGxL4aujC9FWhhC7ulwMoCjegUCMyt/UXYj/i0C
         kciN0OwKk6wdmHwhyfpvcdQHnzCzvnqh6H0Tzhm1JrObtMP9ywGRwCti1mnF/ZSa36OB
         5AL9H1cprahqtXiuofACfaeZOqd1KxyW1ZkXgPkRXB5J+ud+xZSe4NyHZ9xZ6ZyvGc4V
         8xgw==
X-Gm-Message-State: AOJu0YzohdMsad5puNcfGbD02SYJtmTvLt+VK3X67mUUfhUwTXKZpOgg
	KBb1fsbg3s6jalKqQ4qzqDPlTO7KSgK9duTqYafrBlHBV3QS5Zuc6KWDxSVJwB5KLHzbcgHhr3Y
	kmrwOXNXWZqEdr5EETU05vRp4l0vjgUdTpZuMLg0/5s1//CmS9A==
X-Google-Smtp-Source: AGHT+IE/4S1NXTfRbWppNYUqGXKdygo5MU8xzy6Wy5AKwUfDUH8KKHGSL03j5AO03AMd9AAumzt1YZeiDLiPpcOEoPE=
X-Received: by 2002:a67:ee17:0:b0:487:861d:97cc with SMTP id
 ada2fe7eead31-488503f2370mr8817865137.7.1716388711049; Wed, 22 May 2024
 07:38:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240521163720.3812851-1-tabba@google.com> <20240521163720.3812851-6-tabba@google.com>
 <86plten8kr.wl-maz@kernel.org>
In-Reply-To: <86plten8kr.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 22 May 2024 15:37:53 +0100
Message-ID: <CA+EHjTwVe0VXPuJ2OnHR40GMtCBAkRyTei=MpOocLWPmgtCaeQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] KVM: arm64: Allocate memory at hyp for host sve
 state in pKVM
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

On Tue, May 21, 2024 at 10:44=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Tue, 21 May 2024 17:37:18 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Protected mode needs to maintain (save/restore) the host's sve
> > state, rather than relying on the host kernel to do that. This is
> > to avoid leaking information to the host about guests and the
> > type of operations they are performing.
> >
> > As a first step towards that, allocate memory at hyp, per cpu, to
> > hold the host sve data. The following patch will use this memory
> > to save/restore the host state.
>
> What I read in the code contradicts this statement. The memory is
> definitely allocated on the *host*.

You're right. I should say memory mapped at hyp.

> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> > Note that the last patch in this series will consolidate the
> > setup of the host's fpsimd and sve states, which currently take
> > place in two different locations. Moreover, that last patch will
> > also place the host fpsimd and sve_state pointers in a union.
> > ---
> >  arch/arm64/include/asm/kvm_host.h    |  2 +
> >  arch/arm64/include/asm/kvm_pkvm.h    |  9 ++++
> >  arch/arm64/include/uapi/asm/ptrace.h | 14 ++++++
> >  arch/arm64/kvm/arm.c                 | 68 ++++++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/setup.c      | 24 ++++++++++
> >  5 files changed, 117 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 0a5fceb20f3a..7b3745ef1d73 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -535,7 +535,9 @@ struct kvm_cpu_context {
> >   */
> >  struct kvm_host_data {
> >       struct kvm_cpu_context host_ctxt;
> > +
> >       struct user_fpsimd_state *fpsimd_state; /* hyp VA */
> > +     struct user_sve_state *sve_state;       /* hyp VA */
> >
> >       /* Ownership of the FP regs */
> >       enum {
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm=
/kvm_pkvm.h
> > index ad9cfb5c1ff4..b9d12e123efb 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > @@ -128,4 +128,13 @@ static inline unsigned long hyp_ffa_proxy_pages(vo=
id)
> >       return (2 * KVM_FFA_MBOX_NR_PAGES) + DIV_ROUND_UP(desc_max, PAGE_=
SIZE);
> >  }
> >
> > +static inline size_t pkvm_host_sve_state_size(void)
> > +{
> > +     if (!system_supports_sve())
> > +             return 0;
> > +
> > +     return size_add(sizeof(struct user_sve_state),
> > +                     SVE_SIG_REGS_SIZE(sve_vq_from_vl(kvm_host_sve_max=
_vl)));
> > +}
> > +
> >  #endif       /* __ARM64_KVM_PKVM_H__ */
> > diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/=
uapi/asm/ptrace.h
> > index 7fa2f7036aa7..77aabf964071 100644
> > --- a/arch/arm64/include/uapi/asm/ptrace.h
> > +++ b/arch/arm64/include/uapi/asm/ptrace.h
> > @@ -120,6 +120,20 @@ struct user_sve_header {
> >       __u16 __reserved;
> >  };
> >
> > +struct user_sve_state {
> > +     __u64 zcr_el1;
> > +
> > +     /*
> > +      * Ordering is important since __sve_save_state/__sve_restore_sta=
te
> > +      * relies on it.
> > +      */
> > +     __u32 fpsr;
> > +     __u32 fpcr;
> > +
> > +     /* Must be SVE_VQ_BYTES (128 bit) aligned. */
> > +     __u8 sve_regs[];
> > +};
> > +
>
> Huh, why is this in uapi? Why should userspace even care about this at
> all? From what I can tell, this is purely internal to the kernel, and
> in any case, KVM isn't tied to that format if it doesn't dump stuff in
> the userspace thread context. Given the number of bugs this format has
> generated, I really wouldn't mind moving away from it.

I put it here since the sve_header is here, as well as other similar struct=
ures.

Should I move it to asm/kvm_pkvm.h?

> >  /* Definitions for user_sve_header.flags: */
> >  #define SVE_PT_REGS_MASK             (1 << 0)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 9e565ea3d645..a9b1b0e9c319 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1931,6 +1931,11 @@ static unsigned long nvhe_percpu_order(void)
> >       return size ? get_order(size) : 0;
> >  }
> >
> > +static size_t pkvm_host_sve_state_order(void)
> > +{
> > +     return get_order(pkvm_host_sve_state_size());
> > +}
> > +
> >  /* A lookup table holding the hypervisor VA for each vector slot */
> >  static void *hyp_spectre_vector_selector[BP_HARDEN_EL2_SLOTS];
> >
> > @@ -2316,7 +2321,15 @@ static void __init teardown_hyp_mode(void)
> >       for_each_possible_cpu(cpu) {
> >               free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
> >               free_pages(kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu], nv=
he_percpu_order());
> > +
> > +             if (system_supports_sve() && is_protected_kvm_enabled()) =
{
> > +                     struct user_sve_state *sve_state;
> > +
> > +                     sve_state =3D per_cpu_ptr_nvhe_sym(kvm_host_data,=
 cpu)->sve_state;
> > +                     free_pages((unsigned long) sve_state, pkvm_host_s=
ve_state_order());
> > +             }
> >       }
> > +
> >  }
> >
> >  static int __init do_pkvm_init(u32 hyp_va_bits)
> > @@ -2399,6 +2412,50 @@ static int __init kvm_hyp_init_protection(u32 hy=
p_va_bits)
> >       return 0;
> >  }
> >
> > +static int init_pkvm_host_sve_state(void)
> > +{
> > +     int cpu;
> > +
> > +     if (!system_supports_sve())
> > +             return 0;
> > +
> > +     /* Allocate pages for host sve state in protected mode. */
> > +     for_each_possible_cpu(cpu) {
> > +             struct page *page =3D alloc_pages(GFP_KERNEL, pkvm_host_s=
ve_state_order());
> > +
>
> See? That's definitely not a HYP allocation.

Nope :) I will fix the commit message and relevant comments in this patch.

Thanks,
/fuad



> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>
