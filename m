Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4132E7390
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 02:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781664804; cv=pass; b=L8ilH1B8tihtrc4bjb9PBjhBn4QNFCiQGqOegRnKVK9mhLITKFDRdNaVwH9nIWLuQj22aTAxbyELl5T4CVDdbrp4zFUvGAdppAcZtF7mztBl8ssJ30uZG2SpGhGx/oXJ2d++j3SFqeRwwhdmANj+h+CICCm+SmUsI7XQH3bWyEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781664804; c=relaxed/simple;
	bh=Y46ACdwRPouvDlauXzeDi6yuSTN7hLpQNEj3G+N9BSk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=edW2nh6zT0jDf/2yCQXNievTtEC9FW17LR1SJ1VdwHXzzVZqVyK2gp6a4AQDSjwiCkn12NS/HLOszd9bOdw0PeUxtjvm+XpND2EN0dxZxjoaSy6w7Er4fAPsESCV0z8YbRTMTto/oxKW8/+JdD5xNosCEaQFfJ9LAFmW2GY96vQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C+k6dR14; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C+k6dR14"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-68852b58d87so9343023a12.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 19:53:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781664801; cv=none;
        d=google.com; s=arc-20240605;
        b=lf5XOf7IFz36E/kCXu39TZ62MZj/Teac2ydXQWQ3RWW+FeYyeBO+ihSpyjhmddzUBG
         r1D2PTI27qAsL8FIkLOB6LB06zQSE0msq37SK5yqly5Fh0jn3M4K1F7xvWovk3A+jfM2
         dhzFYimupiViP6coFgKGgK8Pp/dRSY1kphNw/o7J/VNLMZVsMGwteM6eHrkHrFVoVkXo
         tpwEsmJj92+wgcq/4XQIoMhqxJmm307tNB629UXPnIn1PO3ToVzF9Yr0WtzbQXeAOwTX
         0PU/GV75+c8YmHPo75gXmX+shZgmaFN/TkPpTme7vrx+dXo1yiESFQ4+X/JYBa0lWvLD
         kRiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Sh64gIF09BcO/9gKi7ofc3N57Hdz3j3jieHCf8F4lzc=;
        fh=tXcL1R3gRbVPJWGV4HboKsCcspgrTTKaj+TSQXD7ExY=;
        b=QUi2YT37Mk/dx4gMZcvAi0WHKTrH0Cml4aEi5o/oALMuQ6C/6qHbeGwkm3/oh6hLmZ
         n5tcYNJQW3oHizNKNU1eytHvwFTAcfRHC2TyCHbAPj3bvKx//bXt4Sf5zMhJA1X4hRZn
         5dMlSmDvDDVsAwkdgAsSIdYlpjnIv65XX433l8HOOTPr4dM4HuedbeA4BDLaJHYfHuu/
         K5vrBqhrkONYsWPLID1S/e2DBjocWXnvm3jRTKzpFk3O94lNJ6HAB+5KW+T/rNjuZCep
         jc7nuaxuWqOYlK2iHVXop+7lTYKeiMlgSBXWPDGg5NCPG7qcuOrukwUxHionC6iFsspz
         NDYg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781664801; x=1782269601; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sh64gIF09BcO/9gKi7ofc3N57Hdz3j3jieHCf8F4lzc=;
        b=C+k6dR14WYs0aCDHBQiKxDmiFZeqpTwFw9MFXbjsR9AKL2467lftlAF/lkfAzMiaL4
         IARPI6Ugi0Vv08zMKo34+tbwiYN7IZC8N8aZTgPkgsAnRCnKd50JsmoAsO13/qPfv37U
         y2t7/R7sa0JJMVqwgP4ouuGZWSbW1+ytMa2vXF7SISIGJOmYKgVXccCRhpAkCatF1jfK
         bDP4eD2NuLvc9Mr8V3dZu2MtnMFCidVKziTNGPzN1B92NF7Tp7D1N7pHYZW/rfBzVYm0
         SqnBdWSifBREj7kZ+wYklXbLARrS1j89hZN2jWHZZtjsC57rMpcajEIKjh/0fanhW0ly
         guTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781664801; x=1782269601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sh64gIF09BcO/9gKi7ofc3N57Hdz3j3jieHCf8F4lzc=;
        b=QHrQgqgCu5pUmaQK4dk0fR00wjMvz64riqDQVyAPj1jZ0vOCJE3pTLuTLhqW4BEjYl
         ROnZrbSQdtAm3gj+GeLzRpXZa7pGYk938fuYr7pTa534lxoq71bLW6vIllIVerrrXTzu
         XFZB4YT1t3yCFR7S7aqEdAIRKJV4cWo7EhPbcCOGY0MUAJ+8RYFu6Y13IXcSm+2U2uF+
         D5F1rIsCD3m9Z83Ys+WMOznfJstVOEgIR+DciXl5hhoRPkYNgi9jSXoqCJ+h0Ge7QxxM
         mzwe9gFScFJRl4jjto1xvWaczyoB7/FjkFBpeRaYSz2Sbxq4Pamp6GMqlLCxw7O97ApB
         MNbA==
X-Forwarded-Encrypted: i=1; AFNElJ8x5FmBiSv0Dzic6LWiPTFwixT2oNfHBVciYItUZk/OkiLUn3VcMQ5bhaEiL0hU18oLXwXXPgY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyf6qsdAlNSSh31MJ4SnhwH4WUp31sCdyEjnbA2kXzpzPsR+3Q1
	ins9b1hhPr+ZRh5Uty8zxCTVumgNszutRTqV152499AZ9objplHs7fJNrcXt832X1jHpEhCDP99
	/SP84vF7C2ZPdY0Pqwc2BT/+zi6R8UZU=
X-Gm-Gg: Acq92OHcBrpMNcVsmLJXQYDiD/PFRaK4fpnvsXhIv4kJ2YHuLLPa2x9HyQ+gwC7lokB
	top3Yj1Shhtsnde4JA7zOomeqUVaUNEWTCEQcI9Plgf3qt77u7tlZdgj0sVHLGQiVMcyxGxA8I/
	iwNvYXqxyOdhpFCZvJWbLQ28hGhP8ZFqJ/X965L0Ee+dnuz8xPc9ZLzgbxhSPHvXUPoGDNwgdH1
	w5/EahCo3FitKVaWakJPXoy7jCQWeCl25ZfHyvdVkdyKeDdLRsZO8fKnApDVOx4tcqiBulo3/jt
	2s1YUlLBrEFPot3dmWucxaZnM63KpA==
X-Received: by 2002:a17:906:6a16:b0:bef:1df6:12f2 with SMTP id
 a640c23a62f3a-c05a4e0f10fmr128192266b.18.1781664800942; Tue, 16 Jun 2026
 19:53:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260616114943.81188-2-bestswngs@gmail.com> <ajGur_YEMoMLZPSF@kernel.org>
In-Reply-To: <ajGur_YEMoMLZPSF@kernel.org>
From: swing sze <bestswngs@gmail.com>
Date: Wed, 17 Jun 2026 10:52:43 +0800
X-Gm-Features: AVVi8CfN6BtGW9POfmFZun5i37f-3gFLrO1XOTWCGLSzrmyy6mEwi_EP1Bbx_rk
Message-ID: <CANgPUi2Rs0YJ3TvZSLGz1d8oFdo9oUiQFrPN-C=DPgucO9-W0w@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: nv: Translate vEL2 PSTATE to EL1 in kvm_hyp_handle_mops()
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jakub Kicinski <kuba@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Zhong Wang <wangzhong.c0ss4ck@bytedance.com>, 
	Xuanqing Shi <shixuanqing.11@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Oliver Upton <oupton@kernel.org> =E4=BA=8E2026=E5=B9=B46=E6=9C=8817=E6=97=
=A5=E5=91=A8=E4=B8=89 04:14=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Weiming,
>
> Thanks for the fix.
>
> On Tue, Jun 16, 2026 at 07:49:44PM +0800, Weiming Shi wrote:
> > When a nested virtualisation guest is running its virtual EL2 (vEL2),
> > fixup_guest_exit() rewrites vcpu_cpsr() to the guest's virtual exceptio=
n
> > level: a hardware PSTATE.M of EL1{t,h} is presented as EL2{t,h}. The
> > hardware, however, executes vEL2 at EL1.
> >
> > kvm_hyp_handle_mops() runs on the fast guest re-entry path, where it
> > clears the single-step bit and restores SPSR_EL2 directly from
> > vcpu_cpsr():
> >
> >       *vcpu_cpsr(vcpu) &=3D ~DBG_SPSR_SS;
> >       write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
> >
> > For a guest hypervisor this writes the vEL2 view (PSTATE.M =3D=3D EL2h)=
 into
> > the hardware SPSR_EL2 without translating it back. The fast path re-ent=
ers
> > the guest via __guest_enter()/ERET without going through
> > __sysreg_restore_el2_return_state(), so neither to_hw_pstate() nor the
> > "return to a less privileged mode" safety check there (which would set
> > PSR_IL_BIT) is applied. The ERET therefore restores PSTATE.M =3D EL2h a=
nd
> > re-enters the guest at the real EL2 with a guest-controlled ELR, escapi=
ng
> > stage-2 and the guest/host boundary.
> >
> > This is reachable on a kernel with FEAT_MOPS running a KVM nested guest
> > (kvm-arm.mode=3Dnested): KVM sets HCRX_EL2.MCE2, which the guest hyperv=
isor
> > cannot clear for its own context (is_nested_ctxt() is false), so a vEL2
> > MOPS exception is taken to the host and dispatched to kvm_hyp_handle_mo=
ps()
> > with VCPU_IN_HYP_CONTEXT set.
> >
> > Translate EL2{t,h} back to EL1{t,h} before writing SPSR_EL2, mirroring
> > kvm_hyp_handle_eret(). For non-nested guests vcpu_cpsr() never holds an
> > EL2 mode, so the translation is a no-op and behaviour is unchanged.
>
> The changelog is unnecessarily verbose, instead:
>
>   kvm_hyp_handle_mops() resets the single-step state machine as part of
>   rewinding state for a MOPS exception by modifying vcpu_cpsr() and
>   writing the result directly into hardware.
>
>   In the case of nested virtualization, vcpu_cpsr() is a synthetic value
>   such that the rest of KVM can deal with vEL2 cleanly. That means the
>   value requires translation before being written into hardware, which is
>   unfortunately missing from the MOPS handler.
>
>   Fix it by directly modifying SPSR_EL2 and avoiding the synthetic state
>   altogether, which will be resynchronized on the next 'full' exit back
>   to KVM.
>
> Also:
>
> Cc: stable@vger.kernel.org
>
> Definitely meets the bar :)
>
> > Fixes: 2de451a329cf ("KVM: arm64: Add handler for MOPS exceptions")
> > Assisted-by: Claude:claude-opus-4-8
> > Reported-by: Zhong Wang <wangzhong.c0ss4ck@bytedance.com>
> > Reported-by: Xuanqing Shi <shixuanqing.11@bytedance.com>
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > ---
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/h=
yp/include/hyp/switch.h
> > index e9b36a3b27bbc..a6b7963ddbf0b 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -448,6 +448,8 @@ static inline bool __populate_fault_info(struct kvm=
_vcpu *vcpu)
> >
> >  static inline bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exi=
t_code)
> >  {
> > +     u64 spsr, mode;
> > +
> >       *vcpu_pc(vcpu) =3D read_sysreg_el2(SYS_ELR);
> >       arm64_mops_reset_regs(vcpu_gp_regs(vcpu), vcpu->arch.fault.esr_el=
2);
> >       write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
> > @@ -457,7 +459,26 @@ static inline bool kvm_hyp_handle_mops(struct kvm_=
vcpu *vcpu, u64 *exit_code)
> >        * instruction.
> >        */
> >       *vcpu_cpsr(vcpu) &=3D ~DBG_SPSR_SS;
> > -     write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
> > +
> > +     /*
> > +      * For a guest hypervisor, vcpu_cpsr() holds the vEL2 view
> > +      * (PSTATE.M =3D=3D EL2h) installed by fixup_guest_exit(), but vE=
L2
> > +      * runs at EL1. Translate it back before restoring SPSR_EL2, as i=
n
> > +      * kvm_hyp_handle_eret().
> > +      */
> > +     spsr =3D *vcpu_cpsr(vcpu);
> > +     mode =3D spsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
> > +     switch (mode) {
> > +     case PSR_MODE_EL2t:
> > +             mode =3D PSR_MODE_EL1t;
> > +             break;
> > +     case PSR_MODE_EL2h:
> > +             mode =3D PSR_MODE_EL1h;
> > +             break;
> > +     }
> > +     spsr =3D (spsr & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
> > +
> > +     write_sysreg_el2(spsr, SYS_SPSR);
>
> As I allude to in the modified changelog, I'd rather we just manipulate
> the hardware value of SPSR_EL2 directly. We already do this in
> kvm_hyp_handle_eret()
>
>         spsr =3D read_sysreg_el2(SYS_SPSR);
>         write_sysreg_el2(spsr & ~DBG_SPSR_SS, SYS_SPSR);
>
> Thanks,
> Oliver

Hi Oliver,

Thanks for your review. I will send the v2 version later.

Best
Weiming Shi
