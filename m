Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D245E757E4
	for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 15:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713193363; cv=none; b=ctE+o9gFngzfG8rKbciQHI5/3+VSidA/Ag34SpisVg+TCHcLPmxMvZaage8KQeu015olT20vY5RFX6cN3kpHXUeNU0EosqWjXnWFoRxVrhWpcUxspFqXHnpS2G2RWbTlmuFkSrubCqVGGVDlzVFgLxB2CR+X6x9GurxO7Qy2KHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713193363; c=relaxed/simple;
	bh=MCYNoH7PrazBCsDWjG1dvSB+ZnBvW3GCVR9i6SzixEo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=knwdzkVtxJXNWjKWl4xqT9ousdSv7+HI4d7ZShx2oOYl8ku972NgDYSfPMkEpE0dmltoNG+8niAM2ocgbE5OPOpKBwKWsnnbE6j/dLnFqnRzvbZZdpa5/MtabgM1R41Z6kLRwCqLlgCpobo+aFvoSfZQceVK4mD4tBvAv8DtSeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=quByWudN; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="quByWudN"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-437274f3bd4so3096391cf.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 08:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713193360; x=1713798160; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1WCARKWgXwk1xt3R/5igMgTYxmUJix52oeLuBeqa68g=;
        b=quByWudNaYBwvue0WlP06omskg9YnHJL8OCKQS4UqCgZ/PdCvKUPnUNPqHOfh6QSr8
         cvAb3w5sAQiJisFTyrX9pVj0fBJN8uyZZrwprn7heByqdSgEpkCW0ENzGb1tBXargBMg
         ItTO5/UuG+Kn7dxKpW9jFRfe4xgYkCmZZN+VnNb/qDW7H5dP/EkNjAb3SwPAsXRTb+IN
         t4v32K/b560wIdM/6j5BCPdrPv2xK/I6bh2Q7Mw4MWiRvbl0dOdzGY1yfEWt9r0FY9TT
         brctTN4wsi0i68NqlIKIE1sI/QHKfH2glP0pBdQ7lsnBpMwJpQxAF+/nqT6ruGmmTrdY
         5+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713193360; x=1713798160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1WCARKWgXwk1xt3R/5igMgTYxmUJix52oeLuBeqa68g=;
        b=idDRJz1EW2WeDgEDy6rrBZKHNlUI8YCL/KO3g5UkLUfBaflylPHx+93vF9T/vbxJ+c
         TbxUHAztutUswPd1LkP4kdrWLWUCpADvpZKbvdB85aD9Ocluo2HQYfV2Vn3D23nIUWJw
         AlBe7vt0QoMxmKhCC7qPZXomhwZQXPTLUJsb0yv5NpPaxk1i5Y/dWISn1ODlpAa8yG5b
         L2o1eA1eN0Fi4nD1266jJ6fRuD0O69p6GoKaTkZGkFtNbIoVlJSuoOH0mi6HX7QGpXDD
         T0TdZptcORXrvx2Exn1K+zrMultunByzgvXtfsK0/V9tGSBp6BCKisyK7xG2uPlmvE9n
         ESOQ==
X-Gm-Message-State: AOJu0YxiYJD6ukiQ25G67E61+Jk0EOh+HIhYs9rF5tyYoJDJWV00wuks
	3I4ITarQdfxMPMnqGf+ZiniHCoqBJEwvSTwu4LIFnmKcoYd2ttyt1JIWtPDE6Zs6M0Ql0GjGMn1
	2aRkLTeGtDvvn9lETnSHDUvBiytinTmj0BXNX
X-Google-Smtp-Source: AGHT+IF59xRceaQM22TeY0Lz1Epj1rgVJp+va5tyf7eITSy6nXszNEi+XOhkI/9k3fMU4fe5TSwizliB2vS7u+CEWGk=
X-Received: by 2002:ac8:41c6:0:b0:436:f864:8d1a with SMTP id
 o6-20020ac841c6000000b00436f8648d1amr5088235qtm.18.1713193359573; Mon, 15 Apr
 2024 08:02:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com> <20240327173531.1379685-8-tabba@google.com>
 <867cgysvqq.wl-maz@kernel.org>
In-Reply-To: <867cgysvqq.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Apr 2024 16:02:02 +0100
Message-ID: <CA+EHjTwHdCuzsiE1xGVgY1ZrWzty9wVF7yr5wHx=9UCC4_bc6g@mail.gmail.com>
Subject: Re: [PATCH v1 07/44] KVM: arm64: Support TLB invalidation in guest context
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Mon, Apr 15, 2024 at 12:36=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Wed, 27 Mar 2024 17:34:54 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > From: Will Deacon <will@kernel.org>
> >
> > Typically, TLB invalidation of guest stage-2 mappings using nVHE is
> > performed by a hypercall originating from the host. For the invalidatio=
n
> > instruction to be effective, therefore, __tlb_switch_to_{guest,host}()
> > swizzle the active stage-2 context around the TLBI instruction.
> >
> > With guest-to-host memory sharing and unsharing hypercalls
> > originating from the guest under pKVM, there is need to support
> > both guest and host VMID invalidations issued from guest context.
> >
> > Replace the __tlb_switch_to_{guest,host}() functions with a more genera=
l
> > {enter,exit}_vmid_context() implementation which supports being invoked
> > from guest context and acts as a no-op if the target context matches th=
e
> > running context.
> >
> > Signed-off-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/tlb.c | 114 +++++++++++++++++++++++++++-------
> >  1 file changed, 90 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tl=
b.c
> > index a60fb13e2192..05a66b2ed76d 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> > @@ -11,13 +11,23 @@
> >  #include <nvhe/mem_protect.h>
> >
> >  struct tlb_inv_context {
> > -     u64             tcr;
> > +     struct kvm_s2_mmu       *mmu;
> > +     u64                     tcr;
> > +     u64                     sctlr;
> >  };
> >
> > -static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
> > -                               struct tlb_inv_context *cxt,
> > -                               bool nsh)
> > +static void enter_vmid_context(struct kvm_s2_mmu *mmu,
> > +                            struct tlb_inv_context *cxt,
> > +                            bool nsh)
> >  {
> > +     struct kvm_s2_mmu *host_s2_mmu =3D &host_mmu.arch.mmu;
> > +     struct kvm_cpu_context *host_ctxt;
> > +     struct kvm_vcpu *vcpu;
> > +
> > +     host_ctxt =3D &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> > +     vcpu =3D host_ctxt->__hyp_running_vcpu;
> > +     cxt->mmu =3D NULL;
> > +
> >       /*
> >        * We have two requirements:
> >        *
> > @@ -40,20 +50,52 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu=
 *mmu,
> >       else
> >               dsb(ish);
> >
> > +     /*
> > +      * If we're already in the desired context, then there's nothing
> > +      * to do.
> > +      */
> > +     if (vcpu) {
> > +             /* We're in guest context */
> > +             if (mmu =3D=3D vcpu->arch.hw_mmu || WARN_ON(mmu !=3D host=
_s2_mmu))
> > +                     return;
>
> I'm a bit concerned about this one, not so much for what it does, but
> because it outlines an inconsistency we have.
>
> Under memory pressure, we can end-up unmapping a page via the MMU
> notifiers, and will provide a s2_mmu context for the TLBI. This can
> happen while *another* context is loaded (a vcpu from a different VM)
> and that vcpu faults.
>
> You'd end up with a scenario very similar to the one I debugged here:
>
> https://lore.kernel.org/kvmarm/86y1gfn67v.wl-maz@kernel.org
>
> Now, this doesn't break here because __hyp_running_vcpu is set to NULL
> on each exit from the HYP code. But that only happens on nVHE, and not
> on VHE, which bizarrely only sets this on entry and leaves a dangling
> pointer...
>
> I think we need to clarify how and when this pointer is considered
> valid.

Right.  I'll add the patch to fix the dangling pointer in VHE. Should
I add a comment about the validity of the pointer where it's defined
as well?

> > +
> > +             cxt->mmu =3D vcpu->arch.hw_mmu;
> > +     } else {
> > +             /* We're in host context */
> > +             if (mmu =3D=3D host_s2_mmu)
> > +                     return;
> > +
> > +             cxt->mmu =3D host_s2_mmu;
> > +     }
> > +
> >       if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
> >               u64 val;
> >
> >               /*
> >                * For CPUs that are affected by ARM 1319367, we need to
> > -              * avoid a host Stage-1 walk while we have the guest's
> > -              * VMID set in the VTTBR in order to invalidate TLBs.
> > -              * We're guaranteed that the S1 MMU is enabled, so we can
> > -              * simply set the EPD bits to avoid any further TLB fill.
> > +              * avoid a Stage-1 walk with the old VMID while we have
> > +              * the new VMID set in the VTTBR in order to invalidate T=
LBs.
> > +              * We're guaranteed that the host S1 MMU is enabled, so
> > +              * we can simply set the EPD bits to avoid any further
> > +              * TLB fill. For guests, we ensure that the S1 MMU is
> > +              * temporarily enabled in the next context.
> >                */
> >               val =3D cxt->tcr =3D read_sysreg_el1(SYS_TCR);
> >               val |=3D TCR_EPD1_MASK | TCR_EPD0_MASK;
> >               write_sysreg_el1(val, SYS_TCR);
> >               isb();
> > +
> > +             if (vcpu) {
> > +                     val =3D cxt->sctlr =3D read_sysreg_el1(SYS_SCTLR)=
;
> > +                     if (!(val & SCTLR_ELx_M)) {
> > +                             val |=3D SCTLR_ELx_M;
> > +                             write_sysreg_el1(val, SYS_SCTLR);
> > +                             isb();
> > +                     }
> > +             } else {
> > +                     /* The host S1 MMU is always enabled. */
> > +                     cxt->sctlr =3D SCTLR_ELx_M;
> > +             }
> >       }
> >
> >       /*
> > @@ -62,20 +104,44 @@ static void __tlb_switch_to_guest(struct kvm_s2_mm=
u *mmu,
> >        * ensuring that we always have an ISB, but not two ISBs back
> >        * to back.
> >        */
> > -     __load_stage2(mmu, kern_hyp_va(mmu->arch));
> > +     if (vcpu)
> > +             __load_host_stage2();
> > +     else
> > +             __load_stage2(mmu, kern_hyp_va(mmu->arch));
> > +
> >       asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
> >  }
> >
> > -static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
> > +static void exit_vmid_context(struct tlb_inv_context *cxt)
> >  {
> > -     __load_host_stage2();
> > +     struct kvm_s2_mmu *mmu =3D cxt->mmu;
> > +     struct kvm_cpu_context *host_ctxt;
> > +     struct kvm_vcpu *vcpu;
> > +
> > +     host_ctxt =3D &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> > +     vcpu =3D host_ctxt->__hyp_running_vcpu;
> > +
> > +     if (!mmu)
> > +             return;
> > +
> > +     if (vcpu)
> > +             __load_stage2(mmu, kern_hyp_va(mmu->arch));
> > +     else
> > +             __load_host_stage2();
> >
> >       if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
> > -             /* Ensure write of the host VMID */
> > +             /* Ensure write of the old VMID */
> >               isb();
> > -             /* Restore the host's TCR_EL1 */
> > +
> > +             if (!(cxt->sctlr & SCTLR_ELx_M)) {
> > +                     write_sysreg_el1(cxt->sctlr, SYS_SCTLR);
> > +                     isb();
> > +             }
> > +
> >               write_sysreg_el1(cxt->tcr, SYS_TCR);
> >       }
> > +
> > +     cxt->mmu =3D NULL;
>
> nit: do we actually need this last line?

Nope. Will remove it.

Thanks,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
