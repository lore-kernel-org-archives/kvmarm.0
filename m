Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208FB27A903
	for <kvmarm@lists.linux.dev>; Tue,  1 Jul 2025 17:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751391348; cv=none; b=JJ14BGRwieaOTMoLhwxb47m74qgG0PdWRkhRMOpQNrC2TMhmSa2heGDJJjTabkEjPK/4Wv9foBIKjhojabq2YgUrtutid+nPyV7M0gJ9OZzrzuQRNLjwhhOC/czqFsmaqvbF3q+T69gK5uNUkVQZFdRmdXVnHo/BAsI82vz3NrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751391348; c=relaxed/simple;
	bh=xh8oMiXVaC/PeHk6Kze/jbe7hwsL6M09JtgNMpI+h4E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QbLx+18j6S0fJxdIv2gnf58qBs27j6M45ilszy9hCkEnn8oKRee6Bi8NJHKzAJMzLDU0/8HA3QAsL9rc/nKt3L3WRFJveoqv6KdLFhcToSxzPBxy87iM2wc/LRKyCOhOvrASxi/wtEPMEXV1Fq48zZuR0qHS0DpT0Dq+kxPVQJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yskf4oZN; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yskf4oZN"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-453663b7bf1so103405e9.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Jul 2025 10:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751391344; x=1751996144; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4JxOHWuI3ch2+TBF1eIdfpH+/9Uhav4zbNFWeCzhBaY=;
        b=yskf4oZNOhG//+FQ+umQSKgOSYjkK2dk8VwAoWk52Ud83doNTKAiloStNx1xDgiu6+
         2kzDkJW8ZMNknE7DdGgz9sHW8ZUnsg22OeKySRtVsg8czVF7ckBIRJcS/kSkIyGMm76r
         R+zBnHlk9mbmlcBvEBoMireCIvI3CPgQAQXs7clVb3hpXrJ485idCxZ39y+cRBYH0jMG
         8rYwVO8kjZRWoB1tKjVH82EO/eAnm+WhSPwd3wDBYY8J7ub+Kea5yt2IJ+2500AxYlAF
         F9VVJdORJmRQiWtI+783d5mlbLTSBqaoOZu3SKwruy+P9h7zkbjCtPo9Mq7C6AV3hBQS
         kwMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751391344; x=1751996144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JxOHWuI3ch2+TBF1eIdfpH+/9Uhav4zbNFWeCzhBaY=;
        b=ZyiXSezysds7SiVPj84ta45bAm/YpsVvMFPfygQKPB0zh3hkC91vNlYLxSCAvBUIZF
         Ll97unEv7a8bEQRnXYbQHwKn4+/K76zGokifGWRkdUYn8xLralxlcGfWgTcC0dQf5b3M
         vq8gbohbklKUJBHpUEG05DqqNthi/xc1kZRcX8S43PrROPtczlG1MnuF34TP7RB9x/cR
         xlCsqKcIat07zy2gGmdcoh4MlKGn/Uvxe7H/c3m74CWqXvyvfIYJHZTqyfPkqP2lq6c4
         QlT0sWwqfspY64i5UVsAtPIS1KXUKKCuZwQaRkuct0fXgOcDDvghCgXKwNozNO7TIjn/
         0rIg==
X-Forwarded-Encrypted: i=1; AJvYcCWj2KlyoOaoCfxilw9ijqm9arjQ01z19I1m2CS+mNJeN1jJNoi1JnbZmHAb1q4nA5r7owHDg9M=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCjP+vVYRkbIdDA6utvtZYrBTo1/RTBDLgVY3HzYySUFlX++XF
	leqS5KdlcE6cRjBVTlKauu3xDEIN+JJ8Hr/sbnQkNGpGp837by7+lpHWdrRqg33sASGP9qFRGX1
	8/6fYGO8luyMfuazLxrp3waFGLHEdbE1LgA3+edw8
X-Gm-Gg: ASbGncscKIqmiBS/+XmToVDqVKIGyZe1rB55GEQRG7U1zyV/uJpouQAGlEb2DeAqm2h
	GM2h/MkmFkac98o0DzCgYTlrnsCA+gJ3AG9Y+X1vQGOi3/l7wv+ONLjMn/5kd/F4jAy/MmVThJ9
	RkXNgWKnd/JmttXG6BMDnM6/hzMOak8Z1gRQsySy2NH4aJTqUEUrW0p1KYq6Ps5DilD5tToKvQ
X-Google-Smtp-Source: AGHT+IH3cyNoxgzPht2LqzOhs6UU7CyEtQyjSMa4i84Ds18dD0Dz3+0A1G8PQNLfFavWLYP6fk7g0RCVuvSNE/TwQYY=
X-Received: by 2002:a05:600c:2d4a:b0:453:919:1fe8 with SMTP id
 5b1f17b1804b1-453e03dc5aamr1283755e9.6.1751391343968; Tue, 01 Jul 2025
 10:35:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250604050902.3944054-1-jiaqiyan@google.com> <20250604050902.3944054-2-jiaqiyan@google.com>
In-Reply-To: <20250604050902.3944054-2-jiaqiyan@google.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 1 Jul 2025 10:35:32 -0700
X-Gm-Features: Ac12FXwKIuKQY31jgciSYsIduSpUF4_MfuIXAK2DDqxoZWkbamzT-v1JcPmSH1A
Message-ID: <CACw3F53EdrvCgTNU1049nScDBgu1UR8c+ksT_zrRPayHiHf_2Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: arm64: VM exit to userspace to handle SEA
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	duenwen@google.com, rananta@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 3, 2025 at 10:09=E2=80=AFPM Jiaqi Yan <jiaqiyan@google.com> wro=
te:
>
> When APEI fails to handle a stage-2 synchronous external abort (SEA),
> today KVM directly injects an async SError to the VCPU then resumes it,
> which usually results in unpleasant guest kernel panic.
>
> One major situation of guest SEA is when vCPU consumes recoverable
> uncorrected memory error (UER). Although SError and guest kernel panic
> effectively stops the propagation of corrupted memory, there is room
> to recover from an UER in a more graceful manner.
>
> Alternatively KVM can redirect the synchronous SEA event to VMM to
> - Reduce blast radius if possible. VMM can inject a SEA to VCPU via
>   KVM's existing KVM_SET_VCPU_EVENTS API. If the memory poison
>   consumption or fault is not from guest kernel, blast radius can be
>   limited to the triggering thread in guest userspace, so VM can
>   keep running.
> - VMM can protect from future memory poison consumption by unmapping
>   the page from stage-2, or interrupt guest of the poisoned guest page
>   so guest kernel can unmap it from stage-1.
> - VMM can also track SEA events that VM customers care about, restart
>   VM when certain number of distinct poison events have happened,
>   provide observability to customers in log management UI.
>
> Introduce an userspace-visible feature to enable VMM to handle SEA:
> - KVM_CAP_ARM_SEA_TO_USER. As the alternative fallback behavior
>   when host APEI fails to claim a SEA, userspace can opt in this new
>   capability to let KVM exit to userspace during SEA if it is not
>   caused by access on memory of stage-2 translation table.
> - KVM_EXIT_ARM_SEA. A new exit reason is introduced for this.
>   KVM fills kvm_run.arm_sea with as much as possible information about
>   the SEA, enabling VMM to emulate SEA to guest by itself.
>   - Sanitized ESR_EL2. The general rule is to keep only the bits
>     useful for userspace and relevant to guest memory. See code
>     comments for why bits are hidden/reported.
>   - If faulting guest virtual and physical addresses are available.
>   - Faulting guest virtual address if available.
>   - Faulting guest physical address if available.
>
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 67 ++++++++++++++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h    |  8 ++++
>  arch/arm64/include/asm/kvm_ras.h     |  2 +-
>  arch/arm64/kvm/arm.c                 |  5 +++
>  arch/arm64/kvm/mmu.c                 | 59 +++++++++++++++++++-----
>  include/uapi/linux/kvm.h             | 11 +++++
>  6 files changed, 141 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/as=
m/kvm_emulate.h
> index bd020fc28aa9c..ac602f8503622 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -429,6 +429,73 @@ static __always_inline bool kvm_vcpu_abt_issea(const=
 struct kvm_vcpu *vcpu)
>         }
>  }
>
> +/*
> + * Return true if SEA is on an access made for stage-2 translation table=
 walk.
> + */
> +static inline bool kvm_vcpu_sea_iss2ttw(const struct kvm_vcpu *vcpu)
> +{
> +       u64 esr =3D kvm_vcpu_get_esr(vcpu);
> +
> +       if (!esr_fsc_is_sea_ttw(esr) && !esr_fsc_is_secc_ttw(esr))
> +               return false;
> +
> +       return !(esr & ESR_ELx_S1PTW);
> +}
> +
> +/*
> + * Sanitize ESR_EL2 before KVM_EXIT_ARM_SEA. The general rule is to keep
> + * only the SEA-relevant bits that are useful for userspace and relevant=
 to
> + * guest memory.
> + */
> +static inline u64 kvm_vcpu_sea_esr_sanitized(const struct kvm_vcpu *vcpu=
)
> +{
> +       u64 esr =3D kvm_vcpu_get_esr(vcpu);
> +       /*
> +        * Starting with zero to hide the following bits:
> +        * - HDBSSF: hardware dirty state is not guest memory.
> +        * - TnD, TagAccess, AssuredOnly, Overlay, DirtyBit: they are
> +        *   for permission fault.
> +        * - GCS: not guest memory.
> +        * - Xs: it is for translation/access flag/permission fault.
> +        * - ISV: it is 1 mostly for Translation fault, Access flag fault=
,
> +        *        or Permission fault. Only when FEAT_RAS is not implemen=
ted,
> +        *        it may be set to 1 (implementation defined) for S2PTW,
> +        *        which not worthy to return to userspace anyway.
> +        * - ISS[23:14]: because ISV is already hidden.
> +        * - VNCR: VNCR_EL2 is not guest memory.
> +        */
> +       u64 sanitized =3D 0ULL;
> +
> +       /*
> +        * Reasons to make these bits visible to userspace:
> +        * - EC: tell if abort on instruction or data.
> +        * - IL: useful if userspace decides to retire the instruction.
> +        * - FSC: tell if abort on translation table walk.
> +        * - SET: tell if abort is recoverable, uncontainable, or
> +        *        restartable.
> +        * - S1PTW: userspace can tell guest its stage-1 has problem.
> +        * - FnV: userspace should avoid writing FAR_EL1 if FnV=3D1.
> +        * - CM and WnR: make ESR "authentic" in general.
> +        */
> +       sanitized |=3D esr & (ESR_ELx_EC_MASK | ESR_ELx_IL | ESR_ELx_FSC =
|
> +                           ESR_ELx_SET_MASK | ESR_ELx_S1PTW | ESR_ELx_Fn=
V |
> +                           ESR_ELx_CM | ESR_ELx_WNR);
> +
> +       return sanitized;
> +}
> +
> +/* Return true if faulting guest virtual address during SEA is valid. */
> +static inline bool kvm_vcpu_sea_far_valid(const struct kvm_vcpu *vcpu)
> +{
> +       return !(kvm_vcpu_get_esr(vcpu) & ESR_ELx_FnV);
> +}
> +
> +/* Return true if faulting guest physical address during SEA is valid. *=
/
> +static inline bool kvm_vcpu_sea_ipa_valid(const struct kvm_vcpu *vcpu)
> +{
> +       return vcpu->arch.fault.hpfar_el2 & HPFAR_EL2_NS;
> +}
> +
>  static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
>  {
>         u64 esr =3D kvm_vcpu_get_esr(vcpu);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index d941abc6b5eef..4b27e988ec768 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -349,6 +349,14 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_GUEST_HAS_SVE                    9
>         /* MIDR_EL1, REVIDR_EL1, and AIDR_EL1 are writable from userspace=
 */
>  #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS             10
> +       /*
> +        * When APEI failed to claim stage-2 synchronous external abort
> +        * (SEA) return to userspace with fault information. Userspace
> +        * can opt in this feature if KVM_CAP_ARM_SEA_TO_USER is
> +        * supported. Userspace is encouraged to handle this VM exit
> +        * by injecting a SEA to VCPU before resume the VCPU.
> +        */
> +#define KVM_ARCH_FLAG_RETURN_SEA_TO_USER               11
>         unsigned long flags;
>
>         /* VM-wide vCPU feature set */
> diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/asm/kv=
m_ras.h
> index 9398ade632aaf..760a5e34489b1 100644
> --- a/arch/arm64/include/asm/kvm_ras.h
> +++ b/arch/arm64/include/asm/kvm_ras.h
> @@ -14,7 +14,7 @@
>   * Was this synchronous external abort a RAS notification?
>   * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
>   */
> -static inline int kvm_handle_guest_sea(void)
> +static inline int kvm_delegate_guest_sea(void)
>  {
>         /* apei_claim_sea(NULL) expects to mask interrupts itself */
>         lockdep_assert_irqs_enabled();
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 505d504b52b53..99e0c6c16e437 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -133,6 +133,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 }
>                 mutex_unlock(&kvm->lock);
>                 break;
> +       case KVM_CAP_ARM_SEA_TO_USER:
> +               r =3D 0;
> +               set_bit(KVM_ARCH_FLAG_RETURN_SEA_TO_USER, &kvm->arch.flag=
s);
> +               break;
>         default:
>                 break;
>         }
> @@ -322,6 +326,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
>         case KVM_CAP_IRQFD_RESAMPLE:
>         case KVM_CAP_COUNTER_OFFSET:
>         case KVM_CAP_ARM_WRITABLE_IMP_ID_REGS:
> +       case KVM_CAP_ARM_SEA_TO_USER:
>                 r =3D 1;
>                 break;
>         case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index e445db2cb4a43..5a50d0ed76a68 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1775,6 +1775,53 @@ static void handle_access_fault(struct kvm_vcpu *v=
cpu, phys_addr_t fault_ipa)
>         read_unlock(&vcpu->kvm->mmu_lock);
>  }
>
> +/* Handle stage-2 synchronous external abort (SEA). */
> +static int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_run *run =3D vcpu->run;
> +
> +       /* Delegate to APEI for RAS and if it can claim SEA, resume guest=
. */
> +       if (kvm_delegate_guest_sea() =3D=3D 0)
> +               return 1;
> +
> +       /*
> +        * In addition to userspace opt out KVM_ARCH_FLAG_RETURN_SEA_TO_U=
SER,
> +        * when the SEA is caused on memory for stage-2 page table, retur=
ning
> +        * to userspace doesn't bring any benefit: eventually a EL2 excep=
tion
> +        * will crash the host kernel.
> +        */
> +       if (!test_bit(KVM_ARCH_FLAG_RETURN_SEA_TO_USER,
> +                     &vcpu->kvm->arch.flags) ||
> +           kvm_vcpu_sea_iss2ttw(vcpu)) {
> +               /* Fallback behavior prior to KVM_EXIT_ARM_SEA. */
> +               kvm_inject_vabt(vcpu);
> +               return 1;
> +       }
> +
> +       /*
> +        * Exit to userspace, and provide faulting guest virtual and phys=
ical
> +        * addresses in case userspace wants to emulate SEA to guest by
> +        * writing to FAR_EL1 and HPFAR_EL1 registers.
> +        */
> +       run->exit_reason =3D KVM_EXIT_ARM_SEA;
> +       run->arm_sea.esr =3D kvm_vcpu_sea_esr_sanitized(vcpu);
> +       run->arm_sea.flags =3D 0ULL;
> +       run->arm_sea.gva =3D 0ULL;
> +       run->arm_sea.gpa =3D 0ULL;
> +
> +       if (kvm_vcpu_sea_far_valid(vcpu)) {
> +               run->arm_sea.flags |=3D KVM_EXIT_ARM_SEA_FLAG_GVA_VALID;
> +               run->arm_sea.gva =3D kvm_vcpu_get_hfar(vcpu);
> +       }
> +
> +       if (kvm_vcpu_sea_ipa_valid(vcpu)) {
> +               run->arm_sea.flags |=3D KVM_EXIT_ARM_SEA_FLAG_GPA_VALID;
> +               run->arm_sea.gpa =3D kvm_vcpu_get_fault_ipa(vcpu);
> +       }
> +
> +       return 0;
> +}
> +
>  /**
>   * kvm_handle_guest_abort - handles all 2nd stage aborts
>   * @vcpu:      the VCPU pointer
> @@ -1799,16 +1846,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>         int ret, idx;
>
>         /* Synchronous External Abort? */
> -       if (kvm_vcpu_abt_issea(vcpu)) {
> -               /*
> -                * For RAS the host kernel may handle this abort.
> -                * There is no need to pass the error into the guest.
> -                */
> -               if (kvm_handle_guest_sea())
> -                       kvm_inject_vabt(vcpu);
> -
> -               return 1;
> -       }
> +       if (kvm_vcpu_abt_issea(vcpu))
> +               return kvm_handle_guest_sea(vcpu);
>
>         esr =3D kvm_vcpu_get_esr(vcpu);
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index c9d4a908976e8..4fed3fdfb13d6 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -178,6 +178,7 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_NOTIFY           37
>  #define KVM_EXIT_LOONGARCH_IOCSR  38
>  #define KVM_EXIT_MEMORY_FAULT     39
> +#define KVM_EXIT_ARM_SEA          40
>
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -446,6 +447,15 @@ struct kvm_run {
>                         __u64 gpa;
>                         __u64 size;
>                 } memory_fault;
> +               /* KVM_EXIT_ARM_SEA */
> +               struct {
> +                       __u64 esr;
> +#define KVM_EXIT_ARM_SEA_FLAG_GVA_VALID        (1ULL << 0)
> +#define KVM_EXIT_ARM_SEA_FLAG_GPA_VALID        (1ULL << 1)
> +                       __u64 flags;
> +                       __u64 gva;
> +                       __u64 gpa;
> +               } arm_sea;
>                 /* Fix the size of the union. */
>                 char padding[256];
>         };
> @@ -932,6 +942,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
>  #define KVM_CAP_ARM_EL2 240
>  #define KVM_CAP_ARM_EL2_E2H0 241
> +#define KVM_CAP_ARM_SEA_TO_USER 242
>
>  struct kvm_irq_routing_irqchip {
>         __u32 irqchip;
> --
> 2.49.0.1266.g31b7d2e469-goog
>

Humbly ping for reviews / comments
