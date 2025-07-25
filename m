Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62C82376F8
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 22:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753484065; cv=none; b=fQO1FS1npbTG/ZJ3G+yZDVl45Izz4PpUgp7LlI4qJFmwSmrYp0lCucD7d34Hska+eLEgs77Olnnv6gOl4EY7Z4I/Ynkvnt+4kp238Bx3C9RYXm7hmfTH87HjDooYyOIilxAS1uHocVy/nw6Dhe7MHJctdiHobwRFba3bJBctQWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753484065; c=relaxed/simple;
	bh=DS26vaBRgwahRFAlqRPBAoUd6fSy9hPCYTaFg82VRkI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ak9sSaaEVbRUZjj12RVfcktdPEYd+Nt/2+ysxNexZcohLwM/L3Mk4Yx2QGo/1Y479rPf8C4uMtH25oKkGepiw+1mcsAWtn+SQq/oNuoK2Fi1PcmQgANsW+Hu0wDg0qUcuQi6nA9VJzSeq69D9elRQXk1Fkm8WgWhUt5cmaRD6ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lUTO4Nhy; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lUTO4Nhy"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4562b2d98bcso7915e9.1
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 15:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753484062; x=1754088862; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SrH0YNsJJUyH6a6DVSuV6GhoCitszYqU7WFGsnyX9bU=;
        b=lUTO4NhyZncwu86JsDW0+xlFo6OJkE7YbbggHpu0cYI2M9W3OEFvjZa1FvOOt9uftI
         zrGd90dut9ef7AshNe0PqVsSbRw/PZJbnd/xsihvY6YDazTeZrODiSvi+ChUGG0VUh9W
         yJuhU9pgHxfyNt13ilZIGgfX19iQWwLgzPqaTQEHVGtmQp03++s8tXg3ZE51PVvHgJNB
         p1HO4BPH0XgU5/h9eBE0JC2BIYkVesstY56n8W/Jd2zv22dGeQXN5mN1TBM9IHRegnQe
         L746Sd6Dv4g9wZegH5J+cQQSyTrPdj5R44O96Z0mEwOsMstzfnf0Gjj2tr4w3zJUNaJZ
         pRkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753484062; x=1754088862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SrH0YNsJJUyH6a6DVSuV6GhoCitszYqU7WFGsnyX9bU=;
        b=NIZCbSDds1E+8oMkjF28QqOwuexk/VT+cqrZzsbTq3bDL4nmpNidCtt/SmXuOHutOU
         vzrSgAHQlKZbSMWt9Nlrggn04eb4kSmqd2EHR15MJnbayV7nlqZQhJtdECxPW5VJgdVe
         AuzbGHHB9SOkswABrl6gGAMc6W08Jg5glb3HZbHEztLDyl5QICddMQaT62y8rynoBVNI
         y6voC7orrRVk2Jwa5COIzN3KC97FL19Lf87D4RgMabOVCQ6AS/eNDEkjxAv7n/wRoApY
         ULg8pnuJgf6aEN+/ppBiEgREdf9ZkRW2dZds9H7PDKP0THLsn+x1OPSkiEyZJj+oqdXK
         oGew==
X-Forwarded-Encrypted: i=1; AJvYcCVp0Fk6tplENl818W9u/11GYS4sdpjVzYfUpfzroCptpmfAYNLdIUHXj/G3U5yThay0gHhoYMI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxu6Rf3a3VGLkEKMBdB7m7vaefwN/OgPmEqClBOoYT4U5gtuB9e
	Pev9KamewakoH3gE9BtLJHlUSNH8H19ByCBKgIMaZhs32Pvxhoz5kMmiT/2P8KXeSBknyZJAWMo
	RJ9R4+wZArgqwRjlAOu+2iUCZtQqylBGjnGOCKboJ
X-Gm-Gg: ASbGncsp4DrYCS2/poD5+IJcWljRCBDD+EZep5w6yiwY6kTl33fj/QuyJ24IO+91Ek8
	UaH9zSG8JZAmCOzXhN1sxTxz4QB8Xd49+juJSVQ9I/aqSIgEskGzC+6B2EwNjx5TDGlbJmYCzrC
	sxxrGPoSfDuayj5ZDpvs6yjqV1UOVxJFVm9v9AYO8SPceY7sAz+dRcdyCVUiq8kBxbtac+4m5Mn
	P6X4gdMGNRHKMh1uMkPQmASQ1aQwpBRB1ciXA==
X-Google-Smtp-Source: AGHT+IEXVboywdhHKbB21FrYI19SVE/5eWAE9USxvMw9lAL1b7BTPdyv52TpToqz3CvoLCcmj+yjtDmKNzHRxga+43I=
X-Received: by 2002:a05:600c:3ba3:b0:450:cb25:ead with SMTP id
 5b1f17b1804b1-4587c99bf66mr125825e9.7.1753484061777; Fri, 25 Jul 2025
 15:54:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250604050902.3944054-1-jiaqiyan@google.com> <20250604050902.3944054-2-jiaqiyan@google.com>
 <aHFohmTb9qR_JG1E@linux.dev> <CACw3F509B=AHhpaTcuH9O851rrDdHh1baC8uRYy7bDa7BSMhgg@mail.gmail.com>
 <aHK-DPufhLy5Dtuk@linux.dev> <CACw3F53TYZ1KFv0Yc-GCyOxn7TF3iYjTNSE8bd3nte=KaCN0UQ@mail.gmail.com>
In-Reply-To: <CACw3F53TYZ1KFv0Yc-GCyOxn7TF3iYjTNSE8bd3nte=KaCN0UQ@mail.gmail.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 25 Jul 2025 15:54:10 -0700
X-Gm-Features: Ac12FXyZ0np7ePqY2RtGzxlS12fDizdwLAcMXNFO9IJOKnf3jD-9veylvlP7J20
Message-ID: <CACw3F50Q_G75wf2rBm-P-NkyyO72i1NKqR9se99QrgipfD62yg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: arm64: VM exit to userspace to handle SEA
To: Oliver Upton <oliver.upton@linux.dev>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	pbonzini@redhat.com, corbet@lwn.net, shuah@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, duenwen@google.com, rananta@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2025 at 2:24=E2=80=AFPM Jiaqi Yan <jiaqiyan@google.com> wro=
te:
>
> On Sat, Jul 12, 2025 at 12:57=E2=80=AFPM Oliver Upton <oliver.upton@linux=
.dev> wrote:
> >
> > On Fri, Jul 11, 2025 at 04:59:11PM -0700, Jiaqi Yan wrote:
> > > >  - Add some detail about FEAT_RAS where we may still exit to usersp=
ace
> > > >    for host-controlled memory, as we cannot differentiate between a
> > > >    stage-1 or stage-2 TTW SEA when taken on the descriptor PA
> > >
> > > Ah, IIUC, you are saying even if the FSC code tells fault is on TTW
> > > (esr_fsc_is_secc_ttw or esr_fsc_is_sea_ttw), it can either be guest
> > > stage-1's or stage-2's descriptor PA, and we can tell which from
> > > which.
> > >
> > > However, if ESR_ELx_S1PTW is set, we can tell this is a sub-case of
> > > stage-2 descriptor PA, their usage is for stage-1 PTW but they are
> > > stage-2 memory.
> > >
> > > Is my current understanding right?
> >
> > Yep, that's exactly what I'm getting at. As you note, stage-2 aborts
> > during a stage-1 walk are sufficiently described, but not much else.
>
> Got it, thanks!
>
> >
> > > > +/*
> > > > + * Returns true if the SEA should be handled locally within KVM if=
 the abort is
> > > > + * caused by a kernel memory allocation (e.g. stage-2 table memory=
).
> > > > + */
> > > > +static bool host_owns_sea(struct kvm_vcpu *vcpu, u64 esr)
> > > > +{
> > > > +       /*
> > > > +        * Without FEAT_RAS HCR_EL2.TEA is RES0, meaning any extern=
al abort
> > > > +        * taken from a guest EL to EL2 is due to a host-imposed ac=
cess (e.g.
> > > > +        * stage-2 PTW).
> > > > +        */
> > > > +       if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
> > > > +               return true;
> > > > +
> > > > +       /* KVM owns the VNCR when the vCPU isn't in a nested contex=
t. */
> > > > +       if (is_hyp_ctxt(vcpu) && (esr & ESR_ELx_VNCR))
> > > > +               return true;
> > > > +
> > > > +       /*
> > > > +        * Determining if an external abort during a table walk hap=
pened at
> > > > +        * stage-2 is only possible with S1PTW is set. Otherwise, s=
ince KVM
> > > > +        * sets HCR_EL2.TEA, SEAs due to a stage-1 walk (i.e. acces=
sing the PA
> > > > +        * of the stage-1 descriptor) can reach here and are report=
ed with a
> > > > +        * TTW ESR value.
> > > > +        */
> > > > +       return esr_fsc_is_sea_ttw(esr) && (esr & ESR_ELx_S1PTW);
> > >
> > > Should we include esr_fsc_is_secc_ttw? like
> > >   (esr_fsc_is_sea_ttw(esr) || esr_fsc_is_secc_ttw(esr)) && (esr & ESR=
_ELx_S1PTW)
> >
> > Parity / ECC errors are not permitted if FEAT_RAS is implemented (which
> > is tested for up front).
>
> Ah, thanks for pointing this out.
>
> >
> > > > +}
> > > > +
> > > >  int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
> > > >  {
> > > > +       u64 esr =3D kvm_vcpu_get_esr(vcpu);
> > > > +       struct kvm_run *run =3D vcpu->run;
> > > > +       struct kvm *kvm =3D vcpu->kvm;
> > > > +       u64 esr_mask =3D ESR_ELx_EC_MASK  |
> > > > +                      ESR_ELx_FnV      |
> > > > +                      ESR_ELx_EA       |
> > > > +                      ESR_ELx_CM       |
> > > > +                      ESR_ELx_WNR      |
> > > > +                      ESR_ELx_FSC;
> > >
> > > Do you (and why) exclude ESR_ELx_IL on purpose?
> >
> > Unintended :)
>
> Will add into my patch.
>
> >
> > > BTW, if my previous statement about TTW SEA is correct, then I also
> > > understand why we need to explicitly exclude ESR_ELx_S1PTW.
> >
> > Right, we shouldn't be exposing genuine stage-2 external aborts to user=
space.
> >
> > > > +       u64 ipa;
> > > > +
> > > > +
> > > >         /*
> > > >          * Give APEI the opportunity to claim the abort before hand=
ling it
> > > >          * within KVM. apei_claim_sea() expects to be called with I=
RQs
> > > > @@ -1824,7 +1864,32 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vc=
pu)
> > > >         if (apei_claim_sea(NULL) =3D=3D 0)
> > >
> > > I assume kvm should still lockdep_assert_irqs_enabled(), right? That
> > > is, a WARN_ON_ONCE is still useful in case?
> >
> > Ah, this is diffed against my VNCR prefix which has this context. Yes, =
I
> > want to preserve the lockdep assertion.
>
> Thanks for sharing the patch! Should I wait for you to send and queue
> to kvmarm/next and rebase my v3 to it? Or should I insert it into my
> v3 patch series with you as the commit author, and Signed-off-by you?

Friendly ping for this question, my v3 is ready but want to confirm
the best option here.

Recently we found even the newer ARM64 platforms used by our org has
to rely on KVM to more gracefully handle SEA (lacking support from
APEI), so we would really want to work with upstream to lock down the
proposed approach/UAPI asap.

Thanks!

>
> BTW, while I am working on v3, I think it is probably better to
> decouple the current patchset into two. The first one for
> KVM_EXIT_ARM_SEA, and the second one for injecting (D|I)ABT with
> user-supplemented esr. This way may help KVM_EXIT_ARM_SEA, the more
> important feature, get reviewed and accepted sooner. I will send out a
> separate patchset for enhancing the guest SEA injection.
>
> >
> >
> > From eb63dbf07b3d1f42b059f5c94abd147d195299c8 Mon Sep 17 00:00:00 2001
> > From: Oliver Upton <oliver.upton@linux.dev>
> > Date: Thu, 10 Jul 2025 17:14:51 -0700
> > Subject: [PATCH] KVM: arm64: nv: Handle SEAs due to VNCR redirection
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_mmu.h |  1 +
> >  arch/arm64/include/asm/kvm_ras.h | 25 -------------------------
> >  arch/arm64/kvm/mmu.c             | 30 ++++++++++++++++++------------
> >  arch/arm64/kvm/nested.c          |  3 +++
> >  4 files changed, 22 insertions(+), 37 deletions(-)
> >  delete mode 100644 arch/arm64/include/asm/kvm_ras.h
> >
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/=
kvm_mmu.h
> > index ae563ebd6aee..e4069f2ce642 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -180,6 +180,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
> >  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >                           phys_addr_t pa, unsigned long size, bool writ=
able);
> >
> > +int kvm_handle_guest_sea(struct kvm_vcpu *vcpu);
> >  int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
> >
> >  phys_addr_t kvm_mmu_get_httbr(void);
> > diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/asm/=
kvm_ras.h
> > deleted file mode 100644
> > index 9398ade632aa..000000000000
> > --- a/arch/arm64/include/asm/kvm_ras.h
> > +++ /dev/null
> > @@ -1,25 +0,0 @@
> > -/* SPDX-License-Identifier: GPL-2.0 */
> > -/* Copyright (C) 2018 - Arm Ltd */
> > -
> > -#ifndef __ARM64_KVM_RAS_H__
> > -#define __ARM64_KVM_RAS_H__
> > -
> > -#include <linux/acpi.h>
> > -#include <linux/errno.h>
> > -#include <linux/types.h>
> > -
> > -#include <asm/acpi.h>
> > -
> > -/*
> > - * Was this synchronous external abort a RAS notification?
> > - * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
> > - */
> > -static inline int kvm_handle_guest_sea(void)
> > -{
> > -       /* apei_claim_sea(NULL) expects to mask interrupts itself */
> > -       lockdep_assert_irqs_enabled();
> > -
> > -       return apei_claim_sea(NULL);
> > -}
> > -
> > -#endif /* __ARM64_KVM_RAS_H__ */
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 1c78864767c5..6934f4acdc45 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -4,19 +4,20 @@
> >   * Author: Christoffer Dall <c.dall@virtualopensystems.com>
> >   */
> >
> > +#include <linux/acpi.h>
> >  #include <linux/mman.h>
> >  #include <linux/kvm_host.h>
> >  #include <linux/io.h>
> >  #include <linux/hugetlb.h>
> >  #include <linux/sched/signal.h>
> >  #include <trace/events/kvm.h>
> > +#include <asm/acpi.h>
> >  #include <asm/pgalloc.h>
> >  #include <asm/cacheflush.h>
> >  #include <asm/kvm_arm.h>
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/kvm_pgtable.h>
> >  #include <asm/kvm_pkvm.h>
> > -#include <asm/kvm_ras.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_emulate.h>
> >  #include <asm/virt.h>
> > @@ -1811,6 +1812,20 @@ static void handle_access_fault(struct kvm_vcpu =
*vcpu, phys_addr_t fault_ipa)
> >         read_unlock(&vcpu->kvm->mmu_lock);
> >  }
> >
> > +int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
> > +{
> > +       /*
> > +        * Give APEI the opportunity to claim the abort before handling=
 it
> > +        * within KVM. apei_claim_sea() expects to be called with IRQs
> > +        * enabled.
> > +        */
> > +       lockdep_assert_irqs_enabled();
> > +       if (apei_claim_sea(NULL) =3D=3D 0)
> > +               return 1;
> > +
> > +       return kvm_inject_serror(vcpu);
> > +}
> > +
> >  /**
> >   * kvm_handle_guest_abort - handles all 2nd stage aborts
> >   * @vcpu:      the VCPU pointer
> > @@ -1834,17 +1849,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu=
)
> >         gfn_t gfn;
> >         int ret, idx;
> >
> > -       /* Synchronous External Abort? */
> > -       if (kvm_vcpu_abt_issea(vcpu)) {
> > -               /*
> > -                * For RAS the host kernel may handle this abort.
> > -                * There is no need to pass the error into the guest.
> > -                */
> > -               if (kvm_handle_guest_sea())
> > -                       return kvm_inject_serror(vcpu);
> > -
> > -               return 1;
> > -       }
> > +       if (kvm_vcpu_abt_issea(vcpu))
> > +               return kvm_handle_guest_sea(vcpu);
> >
> >         esr =3D kvm_vcpu_get_esr(vcpu);
> >
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 096747a61bf6..38b0e3a9a6db 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -1289,6 +1289,9 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
> >
> >         BUG_ON(!(esr & ESR_ELx_VNCR_SHIFT));
> >
> > +       if (kvm_vcpu_abt_issea(vcpu))
> > +               return kvm_handle_guest_sea(vcpu);
> > +
> >         if (esr_fsc_is_permission_fault(esr)) {
> >                 inject_vncr_perm(vcpu);
> >         } else if (esr_fsc_is_translation_fault(esr)) {
> > --
> > 2.39.5
> >
