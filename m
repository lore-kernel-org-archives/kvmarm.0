Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF883D6CC4
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 10:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786012652; cv=none; b=t1NMlJpONvOG6cEBk4FuFeKLlGOVltgiRjbnR3OjQA3+1rS3rhRFT9anXQykQcYPV0NqLQkgOwW9Yor7HgT6cGU9btmReyM8nOTNCO+SXMPHPLWinuMJarUwOfdZ2de6tSspRZ0kQzCRGUIsGoLtFFGqh2+1o198SFB6l+rO7gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786012652; c=relaxed/simple;
	bh=CyQj0ikYbWqPj+cKb65E0rL3Em87q7eo5SfyA74yzAk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OpANORD5UoolYt66Kdbi9CA9aQLUipYr/3hU8YVAFF8djQh9Sc4ZJMD589vXN94/Mn1lmrItApVffO9GWA1MtIGojHA42ZT/r+Y58yyiZkSkwuHt8aYF+3K3rqACGk/ySmIjlvL5wGGeIUBCEHiK4mdzHJdMlrMCucRpZLB7HKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d2gjAsNx; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d2gjAsNx"
X-Forwarded-Encrypted: i=1; AHgh+RpcEqqR3OrQTvVMFgr3s2ykvZhvunSAzBRJFAsPM10ZExi1e+0/hOjxrThM8ceyK+wsiU6+HEY=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786012646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=usAjdnBKFODlJjVhafWrgc8KxpEqvovna4+uO2ZWV1o=;
	b=d2gjAsNxZkmgQUSLtj/VwqukYQr+R8eNdBj3qdsuCTBlVNNJ+tRmD2UijkFRn6v5XEFXXS
	qcDq1JSY7dIbjlDIspsU7Sudto3ADhizUCpRC0YoI59LXAwi8gnNDXmN37C5UiJdKamYzK
	clC2phixysg3QrTeL/eDHkWGJBaLb2g=
X-Gm-Message-State: AOJu0YwHbCWmGNfLF7tnHpphu09evWh5UDWgvZC1KMkGbagrNFHKEwiP
	QsjDsbSXbkghPTs3Y2wVqK4oNFDioSCD0el+ybx9uppTBL/wMTD16Nn8zNM05e1n/zQBxEcX/3x
	GIfdc0JFNbP3dBvMfW7Qg6U2C6ZiwIlK2xUyMUvg9
X-Received: by 2002:a05:622a:aa84:20b0:51b:ff0a:2048 with SMTP id
 d75a77b69052e-52cfe9f1040mr11390661cf.3.1786012627807; Thu, 06 Aug 2026
 03:37:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260806100256.371164-1-fuad.tabba@linux.dev> <20260806100256.371164-3-fuad.tabba@linux.dev>
 <20260806102022.4C7921F000E9@smtp.kernel.org>
In-Reply-To: <20260806102022.4C7921F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 6 Aug 2026 11:36:31 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzn8+7N9QU7fNNaMGVaUwUzd3J_QOi3RUakY-qC3o1-WA@mail.gmail.com>
X-Gm-Features: AUfX_myQP5_Gv4bHKWGHGnskzU3RV15QZN9DNjM1MOl4Dfl2GONNEPDCquUTUK0
Message-ID: <CA+EHjTzn8+7N9QU7fNNaMGVaUwUzd3J_QOi3RUakY-qC3o1-WA@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] KVM: arm64: Reject the GICv5 CPU interface
 hypercalls under pKVM
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Thu, 6 Aug 2026 at 11:20, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] Missing pointer validation in always-on legacy hypercalls al=
lows arbitrary hypervisor memory corruption and information leaks by the ho=
st.

Under pKVM this patch removes the dereference: the early return is
before cpu_if is used. Without pKVM the host is trusted.
__kvm_adjust_pc() is WIP for the upcoming pKVM series.

> - [High] Missing Context Synchronization Event (`isb()`) after writing to=
 `SYS_ICC_ICSR_EL1`.

ERET into the guest is a context synchronization event.

> - [High] Missing Context Synchronization Event (`isb()`) after writing to=
 `SYS_SCTLR`.

ERET back to the host on hypercall return is a context synchronization even=
t.

/fuad

> --
>
> --- Patch [2]: [PATCH v1 2/4] KVM: arm64: Reject the GICv5 CPU interface =
hypercalls under pKVM ---
> commit ecfed0b01b70bb8a7e96b451e64a9f311953ed53
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM
>
> __vgic_v5_save_apr() and __vgic_v5_restore_vmcr_apr() remain callable
> after pKVM finalises. pKVM never registers a GICv5 vgic, so neither has
> a valid caller in protected mode, and on a GICv3 machine the registers
> they access are UNDEFINED at EL2 and panic the hypervisor.
>
> Reject both when protected mode is enabled.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index d3df96ed8ba42..a9afd350b1fb3 100644
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
> This is a pre-existing issue, but could the missing pointer validation in
> these always-on legacy hypercalls allow hypervisor memory corruption and
> information leaks by the host?
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___kvm_adjust_pc() {
>         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
>
>         __kvm_adjust_pc(kern_hyp_va(vcpu));
> }
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v3_save_aprs() {
>         DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
>
>         __vgic_v3_save_aprs(kern_hyp_va(cpu_if));
> }
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v3_restore_vmcr_aprs() {
>         DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
>
>         __vgic_v3_restore_vmcr_aprs(kern_hyp_va(cpu_if));
> }
>
> By exploiting the idempotence of kern_hyp_va() for EL2 linear-map pointer=
s,
> could a malicious host pass a pointer to EL2-private structures, tricking
> EL2 into reading or writing private memory instead of host memory?
>
> Should EL2 validate that the pointer points to host memory, or use the
> known pkvm_get_loaded_hyp_vcpu() state instead of trusting the
> host-supplied pointer?
>
> [Severity: High]
> This is a pre-existing issue, but does the write to SYS_ICC_ICSR_EL1
> require a Context Synchronization Event (isb()) before returning?
>
> arch/arm64/kvm/hyp/vgic-v5-sr.c:__vgic_v5_restore_state() {
> ...
>         write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
> }
>
> Since writes to most ICC_*_EL1 registers require an immediate isb(), coul=
d
> placing a function return between the write and a barrier cause the CPU
> to observe an undefined pipeline state?
>
> Would this lead to unpredictable behavior or spurious faults when
> switching to a guest?
>
> [Severity: High]
> This is a pre-existing issue, but is there a missing Context Synchronizat=
ion
> Event (isb()) after writing to SYS_SCTLR here?
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___kvm_enable_ssbs() {
>         u64 tmp;
>
>         tmp =3D read_sysreg_el2(SYS_SCTLR);
>         tmp |=3D SCTLR_ELx_DSSBS;
>         write_sysreg_el2(tmp, SYS_SCTLR);
> }
>
> If every write to a control-plane system register must be followed by an
> isb() as the very next instruction, could missing the isb() before
> returning result in executing subsequent instructions with an
> architecturally undefined pipeline state?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806100256.37=
1164-1-fuad.tabba@linux.dev?part=3D2
