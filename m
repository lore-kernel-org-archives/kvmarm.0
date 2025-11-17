Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5168F28640B
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 11:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763379490; cv=none; b=mLJEFN3BxnYk9xZDijmCKGEmqc8E2aELSyV9djbA63tIjVLfJ+rXxPWxkr71mQvG+ICtv22Y7H0quWYGd35Se0OiMrdtDIf+uTNmHplm2EcWE2wJbTZB6wLM7zHbPum4jr98W90yf35GvTEZSbIVWHLcnjjEAmj/ABYPSRqAO20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763379490; c=relaxed/simple;
	bh=2H6Ycj8hrZWAkueTN2uhNz5tDY/MSS1icixCKolUVak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tx2Pp33rvE+qvIXAlRhcAV5W2QVUdNijnxd3ewFDLo9vuaViH7aHWZwAHk45uxy+iODhFJaShAdh36JMjeFBF1e+wY0kn8LY4DyvzUGS0E7gU6a74zBHIXgxNfLfpfs6DV1mhDbOu/P0Bx3h87CZz+Y+i2YcxXsdnrGvRPKb//4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GE4bfLUE; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GE4bfLUE"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee147baf7bso427351cf.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 03:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763379487; x=1763984287; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kdg5+UPrJdhmk7JGtwh9VivovQ3SmkgChrYFYtG0TWU=;
        b=GE4bfLUEPO2JevyhAM3as2stK1rUskO0r8NY7+wNTpLfd+sIbXa369L7iUehb0rjqe
         miYy8utI4jNCfB/akKzwPNvUOJRyR05bLNRLnzI/Bz8Kf6jdbFsP3rB/ACrYgfzxkQBI
         poGPfn7bVOkq/F/IvPnMxeg5K+Oax/IMj0czq81cNpywaPlDz089DSbzz50w0zMfKnYN
         nFo0jQp5o0jXhLaRdtMNOrSCu91eZiKWbQkETuaJFZdi2d5DDLeuBwaWuN9PA/Kza7v/
         XcXqTYroa4j8tdZccMj2EjiD/SAKDEmymTDVKJZqJ1yZfyPLgdeA8+20cS4+HeMJ5q8s
         /SrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763379487; x=1763984287;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdg5+UPrJdhmk7JGtwh9VivovQ3SmkgChrYFYtG0TWU=;
        b=KXEXbBB9+GE6RWlYlKXyKKud9DgZd8HLhgSJ2mUloyqOw9OBUrbd3/pjPxGXZysSlY
         BvDIEFgRxaBlaWPZr34txAIIguDkV73+4WnmbHodMOg8XCSNf5uGuCqXW79mQH+i4KiL
         7KBMF3Cep7fCPG+aGzK5vwcgvDQifMACR60r8tFBeFQfJ2Qr2OPdwCQTDDMhM0muxv3Q
         yW0OW5JaM+BG5VaRvfgXNhx8iF5ogvyLBjUJa/P+XP2z45lsDiBRh27W4RUUVShDG+jR
         Zg5hw6bEMDL/mj84RaIDWIRBosscozwGLFIfYdBiYSgPt96Xy4rJ8BKJ0taI58MtUYPG
         FEHQ==
X-Gm-Message-State: AOJu0YyorPYgFOHOMYCLy2sJ2c2UCJ+F7mSFGLHPznHgFt8UD+LC9DzJ
	CAeKpc7BlX44GGGvKvjtJ+8Wi75bm3z3i+BiCjdYWz3wEKOGPVUywY3JVBv08TbxdHazJ1EnnUM
	tgmitLge1dRA9/F7Nbomtb581Kn48IpTiCJiJQ1k6
X-Gm-Gg: ASbGncvO1wkUemqardHbzHwuGmgyzCYsiflwOiOAUCkd1U19o96QKYPnoiPQd5nxS58
	FKRrR0zsF8MvnkNDFPpCp88j5c6NKllK15I0b9GSzBzo9fEaNADgrd15kttLS5H26+JYO4N5JhN
	8j1slYYoWLsd7EuK2iVxP31a6RtGUN4eMZiUxDJ2Sb0fzrpq+c6esygvL9FrkXge6KBb8OiSkQp
	oPr3IZ0gcRd4o1CWF3INvVsDcej/RB/L0P/C0GJpb02Mb5HG+4hYZbTK1bsyS+AHbGxDBOtSHf+
	MWhxpw==
X-Google-Smtp-Source: AGHT+IEUzk1J8x9rcLQDUa8qBh/biui07QWgEMDHESbR/FCoW/EKjye7pZu/VI/SwwQaKSEzkd8zFPpkSrkKcc1IZ9E=
X-Received: by 2002:a05:622a:410:b0:4b7:9617:4b51 with SMTP id
 d75a77b69052e-4ee02c68ca6mr10730511cf.15.1763379486951; Mon, 17 Nov 2025
 03:38:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <20251117091527.1119213-4-maz@kernel.org>
 <CA+EHjTwn7PUykGngWRpK3T9gQ_w8=3+BrmEk9GthH0MgMi3FVw@mail.gmail.com> <864iqsuc46.wl-maz@kernel.org>
In-Reply-To: <864iqsuc46.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 11:37:30 +0000
X-Gm-Features: AWmQ_bl2OOGtg5EpxsSP4-l5nGFXjbgI8_cv-QkngiBO_SM1kp2CRHSJUuDRotw
Message-ID: <CA+EHjTzJhQ3RFm-kNavoSux78AeoErWKU_4Qt0NTqedgNNkgig@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] KVM: arm64: GICv3: nv: Resync LRs/VMCR/HCR early
 for better MI emulation
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 17 Nov 2025 at 11:34, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 17 Nov 2025 11:24:24 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> >
> > On Mon, 17 Nov 2025 at 09:15, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > The current approach to nested GICv3 support is to not do anything
> > > while L2 is running, wait a transition from L2 to L1 to resync
> > > LRs, VMCR and HCR, and only then evaluate the state to decide
> > > whether to generate a maintenance interrupt.
> > >
> > > This doesn't provide a good quality of emulation, and it would be
> > > far preferable to find out early that we need to perform a switch.
> > >
> > > Move the LRs/VMCR and HCR resync into vgic_v3_sync_nested(), so
> > > that we have most of the state available. As we turning the vgic
> > > off at this stage to avoid a screaming host MI, add a new helper
> > > vgic_v3_flush_nested() that switches the vgic on again. The MI can
> > > then be directly injected as required.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/kvm_hyp.h     |  1 +
> > >  arch/arm64/kvm/hyp/vgic-v3-sr.c      |  2 +-
> > >  arch/arm64/kvm/vgic/vgic-v3-nested.c | 69 ++++++++++++++++------------
> > >  arch/arm64/kvm/vgic/vgic.c           |  6 ++-
> > >  arch/arm64/kvm/vgic/vgic.h           |  1 +
> > >  5 files changed, 46 insertions(+), 33 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > > index dbf16a9f67728..76ce2b94bd97e 100644
> > > --- a/arch/arm64/include/asm/kvm_hyp.h
> > > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > > @@ -77,6 +77,7 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
> > >  int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
> > >
> > >  u64 __gic_v3_get_lr(unsigned int lr);
> > > +void __gic_v3_set_lr(u64 val, int lr);
> > >
> > >  void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if);
> > >  void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if);
> > > diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> > > index 71199e1a92940..99342c13e1794 100644
> > > --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> > > +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> > > @@ -60,7 +60,7 @@ u64 __gic_v3_get_lr(unsigned int lr)
> > >         unreachable();
> > >  }
> > >
> > > -static void __gic_v3_set_lr(u64 val, int lr)
> > > +void __gic_v3_set_lr(u64 val, int lr)
> > >  {
> > >         switch (lr & 0xf) {
> > >         case 0:
> > > diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> > > index 17bceef83269e..bf37fd3198ba7 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> > > @@ -70,13 +70,14 @@ static int lr_map_idx_to_shadow_idx(struct shadow_if *shadow_if, int idx)
> > >   * - on L2 put: perform the inverse transformation, so that the result of L2
> > >   *   running becomes visible to L1 in the VNCR-accessible registers.
> > >   *
> > > - * - there is nothing to do on L2 entry, as everything will have happened
> > > - *   on load. However, this is the point where we detect that an interrupt
> > > - *   targeting L1 and prepare the grand switcheroo.
> > > + * - there is nothing to do on L2 entry apart from enabling the vgic, as
> > > + *   everything will have happened on load. However, this is the point where
> > > + *   we detect that an interrupt targeting L1 and prepare the grand
> > > + *   switcheroo.
> > >   *
> > > - * - on L2 exit: emulate the HW bit, and deactivate corresponding the L1
> > > - *   interrupt. The L0 active state will be cleared by the HW if the L1
> > > - *   interrupt was itself backed by a HW interrupt.
> > > + * - on L2 exit: resync the LRs and VMCR, emulate the HW bit, and deactivate
> > > + *   corresponding the L1 interrupt. The L0 active state will be cleared by
> > > + *   the HW if the L1 interrupt was itself backed by a HW interrupt.
> > >   *
> > >   * Maintenance Interrupt (MI) management:
> > >   *
> > > @@ -265,15 +266,30 @@ static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu,
> > >         s_cpu_if->used_lrs = hweight16(shadow_if->lr_map);
> > >  }
> > >
> > > +void vgic_v3_flush_nested(struct kvm_vcpu *vcpu)
> > > +{
> > > +       u64 val = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
> > > +
> > > +       write_sysreg_s(val | vgic_ich_hcr_trap_bits(), SYS_ICH_HCR_EL2);
> > > +}
> > > +
> > >  void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
> > >  {
> > >         struct shadow_if *shadow_if = get_shadow_if();
> > >         int i;
> > >
> > >         for_each_set_bit(i, &shadow_if->lr_map, kvm_vgic_global_state.nr_lr) {
> > > -               u64 lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
> > > +               u64 val, host_lr, lr;
> > >                 struct vgic_irq *irq;
> > >
> > > +               host_lr = __gic_v3_get_lr(lr_map_idx_to_shadow_idx(shadow_if, i));
> > > +
> > > +               /* Propagate the new LR state */
> > > +               lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
> > > +               val = lr & ~ICH_LR_STATE;
> > > +               val |= host_lr & ICH_LR_STATE;
> > > +               __vcpu_assign_sys_reg(vcpu, ICH_LRN(i), val);
> > > +
> >
> > As I said before, I am outside of my comfort zone here. However,
> > should the following check be changed to use the merged 'val', rather
> > than the guest lr as it was?
>
> [...]
>
> >
> > >                 if (!(lr & ICH_LR_HW) || !(lr & ICH_LR_STATE))
> > >                         continue;
>
> No, this decision must be taken based on the *original* state, before
> the L2 guest was run. If the LR was in an invalid state the first
> place, there is nothing to do.
>
> > >
> > > @@ -286,12 +302,21 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
> > >                 if (WARN_ON(!irq)) /* Shouldn't happen as we check on load */
> > >                         continue;
> > >
> > > -               lr = __gic_v3_get_lr(lr_map_idx_to_shadow_idx(shadow_if, i));
> > > -               if (!(lr & ICH_LR_STATE))
> > > +               if (!(host_lr & ICH_LR_STATE))
> > >                         irq->active = false;
>
> And here, if we see that the *new* state (as fished out of the HW LRs)
> is now invalid, this means that a deactivation has taken place in L2,
> and we must propagate it to L1.

Thanks for the clarification.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
