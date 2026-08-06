Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E97D42A15C
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 10:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786012910; cv=none; b=qYRd8ApaGmLtbFnK24rUKvb4AYqNB3Z2Px3zlgIHx5AbLSiL8QtICw2MmpkfY1GVRLjKvLbuq7uC/XGyYggxvf8VLVE6a8Dlv4/zxsNjKsPPVbKNiOWAELUAEM+4IqPflw5rQu/O+kg41icfpXwojzEqgm0azq+aQJGUegTm3Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786012910; c=relaxed/simple;
	bh=yEGD7nqbp+CMW/yxhvfHzzaAgx6rkkvvBeARHNQ6i8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KrHpMzvhYR56qu3jd+snjfFw91PRISfIw5MT48+e1yQ00ly7tdI8SpSzHKD3/JzcaJOuBhZW03wCKPomGm+by82TgcOjMmuVgp1NQkbtmw+hjsCZn8wVjLzBVhtmmVgbX5rhGu/QuTviB8djC6aucUS51YOW10h76nc/CpID2zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RKjBID3Z; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RKjBID3Z"
X-Gm-Message-State: AOJu0YyVIoJGbJ/ZUaiLdrsvwjGZCc38f5O61S1+GP/ncxjeurCVY4t9
	jbko9de2GM4YrWLQPlmGERIrCE72s2fUzLBnebBcOyZhIZ5bVXIZi3fhCwqRwINpd8tgUQ4gUT0
	aJ0tV9i1DfShzaB+YZ/rMhEDbI9bsZPWnXWjngBKw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786012906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z1qJaH8qe3xOuKMLMRx9tLtyzADdhPNGWrKECtyXTAw=;
	b=RKjBID3Z8uXQpDZX9fKTiH3JxXv/lm20YQG+tPBYW6N/xVXhem1d2b/bd7XN6Xfhu7waIR
	7FxKW2fpMdfqX5q2yPhzUkZi6iA3crugPCsCCrg3DV4MCZ0YDfo/HT521RoDSG5YEz/m8N
	PMWYm4Kqm8bjTBaBaZODBZRt/7SLcoU=
X-Received: by 2002:a05:622a:2589:b0:51c:935d:8d74 with SMTP id
 d75a77b69052e-52cfea276f5mr5700541cf.9.1786012885009; Thu, 06 Aug 2026
 03:41:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260806100256.371164-1-fuad.tabba@linux.dev> <20260806100256.371164-2-fuad.tabba@linux.dev>
 <20260806103207.013201F000E9@smtp.kernel.org>
In-Reply-To: <20260806103207.013201F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 6 Aug 2026 11:40:48 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzAqGbjVvPSz0nKZzTmH33tJxi2htegrAzRNSjENPcmBw@mail.gmail.com>
X-Gm-Features: AUfX_mwjA9imTqbgbCmw7CTjZO9uYjppMiugnM-BRCF57kpEMD-0F264YSmLgfc
Message-ID: <CA+EHjTzAqGbjVvPSz0nKZzTmH33tJxi2htegrAzRNSjENPcmBw@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] KVM: arm64: Validate the host-provided vgic model
 in pKVM
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Thu, 6 Aug 2026 at 11:32, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] Unconditional copy of the host's mdcr_el2 to the protected V=
M's mdcr_el2 allows the host to reconfigure the guest's secure trap environ=
ment.

Coming soon in the second pKVM series.

> - [Medium] The patch fails to sanitize the explicit `__vgic_v5_save_apr` =
and `__vgic_v5_restore_vmcr_apr` hypercalls, allowing a malicious host to s=
till panic the hypervisor on GICv3 machines.

Patch 2 of this series fixes it.

/fuad

> --
>
> --- Patch [1]: [PATCH v1 1/4] KVM: arm64: Validate the host-provided vgic=
 model in pKVM ---
> commit 3364f007874647c1650c3fc747633d9c5c9b87de
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Validate the host-provided vgic model in pKVM
>
> This commit validates the host-provided vgic_model during initialization
> of a protected VM, ensuring only GICv2 and GICv3 models are permitted.
> This prevents a malicious host from causing a hypervisor panic by setting
> the model to GICv5 on a GICv3 machine.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/p=
kvm.c
> > index 24d6f164129ac..59bb15efdca42 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -340,13 +340,25 @@ static void pkvm_init_features_from_host(struct p=
kvm_hyp_vm *hyp_vm, const struc
> >  {
>
> [ ... ]
>
> > -     /* Preserve the vgic model so that GICv3 emulation works */
> > -     hyp_vm->kvm.arch.vgic.vgic_model =3D host_kvm->arch.vgic.vgic_mod=
el;
> > +     /*
> > +      * Preserve the vgic model for GICv3 emulation, but only what pKV=
M can
> > +      * run: the GICv5 world switch touches registers UNDEFINED at EL2
> > +      * without FEAT_GCIE. 0 is not a valid kvm_device_type: "no vgic"=
.
> > +      */
> > +     switch (vgic_model) {
> > +     case KVM_DEV_TYPE_ARM_VGIC_V2:
> > +     case KVM_DEV_TYPE_ARM_VGIC_V3:
> > +             break;
> > +     default:
> > +             vgic_model =3D 0;
> > +     }
> > +     hyp_vm->kvm.arch.vgic.vgic_model =3D vgic_model;
>
> [Severity: Medium]
> This is a pre-existing issue, but does this validation fully prevent a
> malicious host from triggering a GICv5 panic?
>
> Even with the model restricted here, the explicit GICv5 hypercalls
> remain unconditionally exposed in the always-on band:
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:
> static void handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt)
> {
>         DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
>
>         __vgic_v5_save_apr(kern_hyp_va(cpu_if));
> }
>
> static void handle___vgic_v5_restore_vmcr_apr(struct kvm_cpu_context *hos=
t_ctxt)
> {
>         DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
>
>         __vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
> }
>
> Can a compromised host still bypass this vgic_model sanitization by
> directly executing the HVC instruction for
> __KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr or __vgic_v5_restore_vmcr_apr?
>
> If these directly access GICv5 registers, wouldn't this still trigger an
> UNDEFINED exception on machines without FEAT_GCIE?
>
> >       /* No restrictions for non-protected VMs. */
> >       if (!kvm_vm_is_protected(kvm)) {
>
> [ ... ]
>
> Additionally, while reviewing the protected guest state handling, I notic=
ed
> another potential issue in the hypervisor main loop:
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:flush_hyp_vcpu() {
>         ...
>         /* __hyp_running_vcpu must be NULL in a guest context. */
>         hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu =3D NULL;
>
>         hyp_vcpu->vcpu.arch.mdcr_el2    =3D host_vcpu->arch.mdcr_el2;
>         /*
>          * HCR_EL2.VSE is host-owned (a pending virtual SError to inject)=
, not a
>         ...
> }
>
> [Severity: Critical]
> This isn't a bug introduced by this patch, but does this unconditional
> assignment allow the untrusted host to clobber the securely initialized
> MDCR_EL2 configuration of protected guests on every VCPU entry?
>
> Since flush_hyp_vcpu() overwrites the hyp vCPU's mdcr_el2 with the
> host-controlled host_vcpu->arch.mdcr_el2, could a compromised host use
> this to reconfigure the performance monitor (TPM) and debug (TDA/TDE)
> trap environment of a protected guest?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806100256.37=
1164-1-fuad.tabba@linux.dev?part=3D1
>
