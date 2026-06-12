Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D00D2459E1
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 08:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781251585; cv=pass; b=UkuonPjdzqvsoLvc/ebbG/FUxqXfZCzXW79zZXCPmYRuTMkx/QGWraIlTGgtYyEx03QttXTeqXUosm7BxUv+WoNshZmTgxuvUJk+Vpg10k1d4RyfUZH/ZqlWtPXGUQjgXrhon3uA8RVfi2hMCBJd0B5mc1NSyZ3vKMtr6BxydIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781251585; c=relaxed/simple;
	bh=0Ldx4JyO0VKuwyhldsYS+gAeVYKtPwlMVYPf7qkJa4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RSGJuf3P5sJpb4BNOj+CauNyICmrq13ksABT+VtW+75q57R4U6UiWkzwX31RUz7Ud/36G8RmMrFS49ZB6rpz/IwP7UGoA5r57fqUcfS53vQyn1bQzdt3n0eh7sQlJP2XsjniKHCKTsW5OgxBZwm4aFbYoScrxsHFFugj6BSLId4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qmWoRxIE; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qmWoRxIE"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5175d339e8bso410221cf.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 01:06:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781251583; cv=none;
        d=google.com; s=arc-20240605;
        b=J57BNZLw9KsUPEJiC7Dkz9J+U0X2ux732z7Wq1spwmeewnz8qwudg6lBIdK+4HySMn
         BfqLxp+/f7Ci0eTE+oHDC6j8IR1FC+7q2fiMJq2Pmjsx/LZOCLE1IPKDc9PRpMaSZaPw
         29bP7ODNqz+K5Vse5xecV3Z1G8Ldi27l1onFq27q/FPJxIpGHpbjj9KvfCMF5sj7AqkI
         ZJ8UMsz/2RyDixEM2WCEY1Un1lR/gg75DLGiIhZ0tNOZtkVcth+TMDqWB3sZyA3YpovK
         kaTPcxueO2YjJwjY7gKxiyxO4wdT23Owj529bsY3w7eYQIFaypp6GxTp9cEqObXfRRCv
         Uh8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SxtQmOqLrqBM+jtzohJpK/rlmR1tAsw/XBdMsA50ODY=;
        fh=HhTV4G5+xnJ3thQDc6cpcOYMN3AitX7qB0zPfKB89LY=;
        b=guTzJD+71EFvHfn1tagJu9SVo3J9pE83DWPP8y/HH0B3qXitkJ7+60MbdzgLV0G7dB
         qeACSK1BxlxhCmr6vEM/SkRWp8bkocDaBIgu72spgjg2hBJrBQJIarLNyjClJSjBGTxz
         8/9zL7G2o6Y+STn7gZU2iIRHBFqGOuqvaCM7k2A1euw+qLev3CtKdqY1YTWdtMnaEZkh
         DRN7PmgB8rW8Jwlxr8HttlV3VJd/yBy6bXOWP4xhr1F9u/BYQHt73Vtj+GPv8rltm+uz
         dFnrTwLtQaH2uf9izSrwXTOMW8+7rT4jjQImic30WsI8M8c5jwB6AEtg+7ROTc0cLWdz
         nlKQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781251583; x=1781856383; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SxtQmOqLrqBM+jtzohJpK/rlmR1tAsw/XBdMsA50ODY=;
        b=qmWoRxIEuzeUaJ5uP6IIiLs6TSy0wUYmaKxPFi+qJfhIDqfKQUPNyRGkrQCdM8K9t3
         dmGeNG4dtQofckP7m1uCAzfcSuW4PmwkmbIug9a9nvV7ltH3fqdUoy6PRAMxpZ98/owK
         k8oFieDhUkkXW/S+8wLTrPG3xWlu2DbNa+02EyoootxuCHzb5K9HvZaUt6snWI6Jybiw
         vImQhADSROSGIh6QnFQKz6YUKeA3/Y9/fBMDrun9JgIK404i4MtSvxMb3A4FYUHTc5QY
         NyGhKTufRBuFuez62mnXuINGfQ/IbVQ0gi7b5rVzXM78tQA1tbYBWFfWEF3fagc5L2hH
         DtfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781251583; x=1781856383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SxtQmOqLrqBM+jtzohJpK/rlmR1tAsw/XBdMsA50ODY=;
        b=TVfNphR/CzY76QusZ1Pr3v9QUyc3aEvJ2oidUV4aXUPKUkKyNHeorSA0N/jniKsEzu
         jFICRFmdiEZ6IuqTjBrrlXgyhBaLD6FECkF1P0x1EvvpjyUl/34XDOFO+bVzXYK5dROJ
         covv33RvMeS7NcCXrXxj6A5R/zPqiw68hm5N496qVyrdvgGhAfEP94VhXHtx2CpkEvFW
         g/0VUl9e6AEVgsyRtiWU1PdTleI52kYeQvCquvXKqmIfAFjVh4GEYKu8Oc1PMzIA0aq2
         RYkbpitSPxD6pn47VI/M28VeYCvWt3hw0cTzCHK0JTE37ehuZebK3/nwymFZx8LNjuSO
         evCg==
X-Gm-Message-State: AOJu0YyR96motnQOnvffo3d4cKm06ZAeAeAPkkKhH1iFJHvrmTZkdDWW
	HdpSsTN0Aq47Ue13PJvBoY+zBhOA6873vGl87x3IMwgYhFoIx04ERDKBEg+N4MW+fmzsgQx3KV+
	lqCEeUnnzdWexp4JVr7jeGKiLDaC2LxP6aVAX4JxYU4Cqj/TiogGypBWHLf4=
X-Gm-Gg: Acq92OFQnzAHGvWVLCSFGBUAfCHGacJgebWPgEz/LN46IrCCFIX5pJRDRVNQIV2tXYt
	KHUl+GnSGWzUSMhODbxZDcc32AhCmTutL9kyZesCjgV2lwC6jJlBlWlKY/DUhgc/e14dwrDrhLE
	Th/WwJHGxeGWfC95JvRkpcmWH1zfyh3RbmWNABgzpC1pDpcrzJS/KkuItdJupSvOw+h+wo9C9Sn
	RP/tMIBwoU/Y4VgzqIPmsdgSaNRiT4/BMOrVJ+wI9JPkWw+/SXfkrlqMeIUHLZga0e+N36NSQVC
	YzLUKulj
X-Received: by 2002:ac8:7d0a:0:b0:516:4f62:85ef with SMTP id
 d75a77b69052e-517fb16d601mr6237011cf.20.1781251582520; Fri, 12 Jun 2026
 01:06:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-10-tabba@google.com> <20260612072456.0F4D01F000E9@smtp.kernel.org>
In-Reply-To: <20260612072456.0F4D01F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 12 Jun 2026 09:05:45 +0100
X-Gm-Features: AVVi8CdG4_sW3_2nd8arMp-Q_cn2I-_oHA3DWyMD4OwwU1tl7fmIdtwcQoyDf9o
Message-ID: <CA+EHjTyyDJsOEhcJnuxpyia5EU_GUck_GeQRP65n75S85f31cg@mail.gmail.com>
Subject: Re: [PATCH v1 09/11] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Jun 2026 at 08:24, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] The GICv5 equivalents of the VGIC save/restore hypercalls (`=
handle___vgic_v5_save_apr` and `handle___vgic_v5_restore_vmcr_apr`) directl=
y dereference host-provided pointers without validation, allowing a complet=
e bypass of pKVM isolation.
> - [Critical] The `handle___kvm_adjust_pc` hypercall directly dereferences=
 a host-provided `vcpu` pointer without validation, granting the host an ar=
bitrary memory corruption primitive against the hypervisor.
> --
>
> commit a5d2ecd901c7ff6f71119eb6ee605aaa1a3fee90
> Author: Marc Zyngier <maz@kernel.org>
>
> KVM: arm64: Minimise EL2's exposure of host VGIC state during world switc=
h
>
> The host passes a vgic_v3_cpu_if pointer to the __vgic_v3_save_aprs and
> __vgic_v3_restore_vmcr_aprs hypercalls, which EL2 dereferences
> wholesale. That exposes the host's full VGIC emulation state to the
> hypervisor, against pKVM's isolation goals.
>
> Recover the host vCPU from the supplied cpu_if via container_of() and
> copy only vgic_vmcr and the active priority registers between EL2's
> hyp-side state and the host vCPU, so EL2 no longer dereferences the
> host's vgic_v3_cpu_if directly.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 420fb19a64760..2f165b6c7b071 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>
> [ ... ]
>
> > @@ -489,16 +501,63 @@ static void handle___vgic_v3_init_lrs(struct kvm_=
cpu_context *host_ctxt)
> >
> >  static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ct=
xt)
> >  {
> > -     DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
> > +     struct pkvm_hyp_vcpu *hyp_vcpu;
> > +     struct kvm_vcpu *host_vcpu;
> >
> > -     __vgic_v3_save_aprs(kern_hyp_va(cpu_if));
> > +     host_vcpu =3D get_host_hyp_vcpus_from_vgic_v3_cpu_if(host_ctxt, 1=
,
> > +                                                        &hyp_vcpu);
> > +     if (!host_vcpu)
> > +             return;
>
> [ ... ]
>
> > +     } else {
> > +             __vgic_v3_save_aprs(&host_vcpu->arch.vgic_cpu.vgic_v3);
> > +     }
> >  }
>
> [Severity: Critical]
> This is a pre-existing issue, but while this patch addresses the VGIC v3 =
host
> pointer dereference bypass by using get_host_hyp_vcpus_from_vgic_v3_cpu_i=
f(),
> does the same pKVM isolation bypass exist in the GICv5 equivalents?

GICv5 is not supported in protected mode. vgic-v5.c:62-64 skips
GICv5 registration entirely when is_protected_kvm_enabled(), so no
GICv5-based guest can be created under pKVM. The host never reaches
these hypercalls through any legitimate code path.

>
> Looking at handle___vgic_v5_save_apr() and handle___vgic_v5_restore_vmcr_=
apr()
> in arch/arm64/kvm/hyp/nvhe/hyp-main.c:
>
> handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt) {
>     DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
>     __vgic_v5_save_apr(kern_hyp_va(cpu_if));
> }
>
> These handlers appear to take a cpu_if pointer directly from the untruste=
d
> host context and apply kern_hyp_va() without validation. Could a maliciou=
s
> host provide an address that translates to an arbitrary EL2-private memor=
y
> location, granting an arbitrary write or read primitive when
> __vgic_v5_save_apr() or __vgic_v5_restore_vmcr_apr() is invoked?
>
> [Severity: Critical]
> This is also a pre-existing issue, but does a similar arbitrary memory
> corruption primitive exist in handle___kvm_adjust_pc()?

Yes, pre-existing. It is addressed later in this series by
"Prevent host PC adjustments for protected vCPUs" (patch 10/11).

Cheers,
/fuad

>
> Looking at handle___kvm_adjust_pc() in arch/arm64/kvm/hyp/nvhe/hyp-main.c=
:
>
> static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt) {
>     DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
>     __kvm_adjust_pc(kern_hyp_va(vcpu));
> }
>
> And __kvm_adjust_pc() in arch/arm64/kvm/hyp/exception.c:
>
> void __kvm_adjust_pc(struct kvm_vcpu *vcpu) {
>     if (vcpu_get_flag(vcpu, PENDING_EXCEPTION)) {
>         kvm_inject_exception(vcpu);
>         vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
>         vcpu_clear_flag(vcpu, EXCEPT_MASK);
>     }
>     ...
> }
>
> It seems the host-provided vcpu pointer is converted via kern_hyp_va()
> without the __get_host_hyp_vcpus() validation barrier. Could a malicious
> host inject a pointer that translates into EL2-private memory (like
> hypervisor page tables) and set the PENDING_EXCEPTION bit, forcing
> __kvm_adjust_pc() to write exception vector addresses and clear flags at
> specific offsets within the target structure?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612065925.75=
5562-1-tabba@google.com?part=3D9
