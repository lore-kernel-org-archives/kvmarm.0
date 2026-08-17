Received: from mta0.migadu.com (out-251.mta0.migadu.com [91.218.175.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85DA3BB671
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 11:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786966153; cv=none; b=pix4Q3czNimvCEWUP0deTE79AOa0043RFwwiqtjBRVkfpVvWtQyU1PKzklDO92Rb7HxU4H3+pKw4JqNFjPIN3f5RXbDkMlu0m2xDVvPOr9mFrNKD0HBeRsWhv6MtU+HGOU/LvLZVsa/fOZDik9o42kDn3ONX+P0gkqty3Tehzng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786966153; c=relaxed/simple;
	bh=gGAFBl9s0Hip9Xt/14uDPkwKVPiyseO+fC7WoteSaHE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cmzl7euiVN1k7SaVPPIbEnhnQ+PS/Rv+nm55d3MXQpfbb4CB5F7Z0EIbcyDwzwiyskbXJSTztg0bMmFGIZyEZUaRt+kXeIa7ysbFJ4hR8fO0/e3OovhFvrmkC86wO9jzMCp6Av2Se47r/JF/Rm/EcbPORKBguEpx9VGG+57Jg/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c96jmcOt; arc=none smtp.client-ip=91.218.175.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c96jmcOt"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=gGAFBl9s0Hip9Xt/14uDPkwKVPiyseO+fC7WoteSaHE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786966148; v=1; x=1787570948;
 b=c96jmcOtDsrs3BxDTSLEvIKy510pWgo+6Pt9eMr/8k8Aw3uBP0zlvczrtDWFAdBzc68XWXkV
 +wATf0ueRu4PQd3Suc6r5p5d12VOniZMDgWtlSR2bhpZTVbMuATqlKvUT4lSren7Yyb7kaZ0tYi
 fB2DdHxsFKTVflSPqMeJKGAk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f50.google.com (209.85.167.50)
	by smtp.migadu.com with ESMTPS id c0a83deb5818a132;
	Mon, 17 Aug 2026 11:28:58 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so17752e87.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 04:28:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rowd7FgEn/Y5XoNMU+fNPNhlFahMHlgLovxRjALO2nrGGU4MXiXCtu86bxPUbCdUOAPC14LP70=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxu3b8YgeGTMdFSOYubp1L98uB6M47eD9Y3GCuzR+EJ5SQSbN5O
	BDYzJG1ETXQbyBNpENu2f95c1qfVIEMmrLweCHU0I2/f6gPvsfC9cpbvX8kWiwh5AlrVafHYhzV
	EDqG7CsPpGFbjQ3ZZVJ4l2k/TSfinO8rT5DgOz95M
X-Received: by 2002:a05:6512:3e0d:b0:5b2:958b:24f with SMTP id
 2adb3069b0e04-5b4693d328fmr75321e87.4.1786966132880; Mon, 17 Aug 2026
 04:28:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817103228.1203140-1-fuad.tabba@linux.dev>
 <20260817103228.1203140-3-fuad.tabba@linux.dev> <20260817104711.26A3D1F000E9@smtp.kernel.org>
In-Reply-To: <20260817104711.26A3D1F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 17 Aug 2026 12:28:16 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzggi3U-FF=NHjb1qrLOsizV8rNtGHpbD=YSXN_SPyhAw@mail.gmail.com>
X-Gm-Features: AcwNN1W0ERaZbu3OXegRP31-Zk_Bugm9-HWpP3hC5nUI1JjHTsKcx8M9JWS5XFA
Message-ID: <CA+EHjTzggi3U-FF=NHjb1qrLOsizV8rNtGHpbD=YSXN_SPyhAw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: Reject the GICv5 CPU interface
 hypercalls under pKVM
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It's been a while...

On Mon, 17 Aug 2026 at 11:47, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [Medium] The patch manually adds runtime mode checks inside GICv5 handl=
ers instead of correctly categorizing the hypercall IDs in the pKVM availab=
ility bands, resulting in an incorrect SUCCESS return for an unsupported op=
eration.

pKVM does not support GICv5 yet but is expected to, so these are gated
off for now, not rejected outright.

> Pre-existing issues:
> - [Critical] Always-on legacy hypercalls (like `handle___vgic_v3_save_apr=
s` and `handle___kvm_adjust_pc`) dereference host-provided pointers using `=
kern_hyp_va()` without ownership validation, enabling a malicious host to a=
rbitrarily corrupt hypervisor memory.

The _proper_ fix for this one is coming soon to a series near you
(i.e., proper pVM support upstream)!

/fuad

> --
>
> --- Patch [2]: [PATCH v2 2/4] KVM: arm64: Reject the GICv5 CPU interface =
hypercalls under pKVM ---
> commit b55739e7ec2cd459ba47129f61f967475ca69c49
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM
>
> __vgic_v5_save_apr() and __vgic_v5_restore_vmcr_apr() remain callable
> after pKVM finalises. pKVM never registers a GICv5 vgic, so neither has
> a valid caller in protected mode, and on a GICv3 machine both reach a
> register that is UNDEFINED at EL2 and panic the hypervisor.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index d3c69de698f48..9159bce7515b1 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -695,6 +695,9 @@ static void handle___vgic_v5_save_apr(struct kvm_cp=
u_context *host_ctxt)
> >  {
> >       DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
> >
> > +     if (unlikely(is_protected_kvm_enabled()))
> > +             return;
> > +
>
> [Severity: Medium]
> Does this early return leave SMCCC_RET_SUCCESS in the return register
> instead of correctly rejecting the call?
>
> Because the hypercall ID remains in the always-on band in
> enum __kvm_host_smccc_func, the dispatcher will preload SMCCC_RET_SUCCESS
> and route it here. Returning early means the host receives a success code
> for an unsupported operation.
>
> Would it be better to move these hypercall IDs before
> __KVM_HOST_SMCCC_FUNC_MIN_PKVM in asm/kvm_asm.h so the dispatcher
> rejects them automatically with SMCCC_RET_NOT_SUPPORTED?
>
> >       __vgic_v5_save_apr(kern_hyp_va(cpu_if));
> >  }
> >
> > @@ -702,6 +705,9 @@ static void handle___vgic_v5_restore_vmcr_apr(struc=
t kvm_cpu_context *host_ctxt)
> >  {
> >       DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
> >
> > +     if (unlikely(is_protected_kvm_enabled()))
> > +             return;
> > +
> >       __vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
> >  }
>
> [Severity: Critical]
> This is a pre-existing issue, but while looking at how kern_hyp_va()
> is used in this file, could a host use the always-on legacy hypercalls
> to modify hypervisor memory?
>
> In handle___vgic_v3_save_aprs():
>
> static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
> {
>         DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
>         __vgic_v3_save_aprs(kern_hyp_va(cpu_if));
> }
>
> And similarly in handle___kvm_adjust_pc():
>
> static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
> {
>         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
>         __kvm_adjust_pc(kern_hyp_va(vcpu));
> }
>
> Since kern_hyp_va() transforms the pointer without validating page
> ownership, what happens if the host passes a pointer that resolves to an
> EL2-owned physical page? It appears this might give the host an
> arbitrary write or bit-clear primitive against hypervisor memory. Should
> these always-on handlers validate the host pointer before dereferencing i=
t?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817103228.12=
03140-1-fuad.tabba@linux.dev?part=3D2
