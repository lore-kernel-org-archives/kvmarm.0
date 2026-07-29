Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AB522424C
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 13:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332724; cv=none; b=lc8BOO64atszVO5FANG9n1TBhPNi0/Gmf56st/ixoFqZzxdSyQtHS4Q0wDEYV/actR4V7R6FWykq7NC/AW8hBeGSvo8z5XQI/nuIosaZbnT9rmMSzJi83qtm7ZbdpgawswZamBJZS9eIijYpU+kd847RJiP0QRK3SgDQbe/nEJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332724; c=relaxed/simple;
	bh=MM8urWYQILEO8KYnwhxkBDOCBTvPnqCx3vrYzCLLSps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=on9te5lKrZ8u8N7T0eCowNxOOW9+O1/7jEyX4fs6JHY05+bXra5ruhL7JjVRYEbv69kklt/SeYfe2u/FDyuuJfrtkt4Xu6cwTyLwbsJ/LSdElW0coGGyl2Y03a3LAn/S++xh0yLQ/MjExOTq/wIH0Qbb/QucvkLdrJyPYCL0hVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a/MrGmuZ; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a/MrGmuZ"
X-Forwarded-Encrypted: i=1; AHgh+Rr+cR/EaFHDLZH8DTdb0HhKY/caIv0LyiYBpyt/7sHuBbLnhNQj8j++LnW25vxd6tDXwNmQAEw=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785332719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wj6IB87otqR0ZGNUVqx/U0Bak0+2XxP9cfbv6FFIQt0=;
	b=a/MrGmuZk89ws4MtJS6oo4jmSlE3Q/9gKwlZdFh2uxniKBsrdRJEWpG4g1Vf0wEVulBG2d
	92x9KUnJCeICNwfn8JtlsDK6XQ/4tp45hlSTcpk5sv8AKeXdqE4gPibu7+TBlblsEX867S
	pJihZU1qUw7hagsvwT9cKqZPNI3s8tY=
X-Gm-Message-State: AOJu0Yxfx4G5r5ZcIwyT+ekcwO8tFotfMgryGttbV9bBVn4VMq8vzGg4
	9p9UjLe8V3phbYscpJxLX0xnfJ9xbUiB3Syrv+y/mUoz9v3iDI/JyuzVMSFNQDOixlob/IREkii
	DLS3nayCf5O5dCNFmaBXjAZFkREXMUQQaMOdqj4Nz
X-Received: by 2002:a05:622a:4cc5:b0:517:6dc0:698d with SMTP id
 d75a77b69052e-52b2b15be98mr11678831cf.0.1785332715601; Wed, 29 Jul 2026
 06:45:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260729131823.2021516-1-fuad.tabba@linux.dev>
 <20260729131823.2021516-7-fuad.tabba@linux.dev> <20260729133929.CFE191F00A3D@smtp.kernel.org>
In-Reply-To: <20260729133929.CFE191F00A3D@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 29 Jul 2026 14:44:38 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw-2ot0mJinAhi4FaOYXv8oLwg_US=uwG-qgQ+BJ-_x4A@mail.gmail.com>
X-Gm-Features: AUfX_myJb88jCPKXBErkJT6ISspfYJq89Mwqef8UPdgq4c1gp7AtNl5lctDDCVc
Message-ID: <CA+EHjTw-2ot0mJinAhi4FaOYXv8oLwg_US=uwG-qgQ+BJ-_x4A@mail.gmail.com>
Subject: Re: [PATCH v7 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Wed, 29 Jul 2026 at 14:39, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] The patch fixes an arbitrary host pointer dereference in GIC=
v3 hypercalls but completely misses the identical vulnerabilities in GICv5 =
hypercalls (`handle___vgic_v5_save_apr` and `handle___vgic_v5_restore_vmcr_=
apr`).
> - [Critical] Unvalidated host pointer dereference in `handle___kvm_adjust=
_pc` allows arbitrary memory modification in EL2.

https://lore.kernel.org/all/CA+EHjTyGULmVCgyoya3bXG4gRj0OYFE1gnJLhNE6kvCrZF=
tXyQ@mail.gmail.com/

/fuad

> --
>
> --- Patch [6]: [PATCH v7 6/8] KVM: arm64: Minimise EL2's exposure of host=
 VGIC state during world switch ---
> commit def324be61872b6056efce4e3eb9ff57eb9a9e10
> Author: Marc Zyngier <maz@kernel.org>
> Subject: KVM: arm64: Minimise EL2's exposure of host VGIC state during wo=
rld switch
>
> This commit restricts EL2's exposure to host VGIC state by recovering the
> host vCPU securely rather than directly dereferencing the host-provided
> vgic_v3_cpu_if pointer in __vgic_v3_save_aprs and
> __vgic_v3_restore_vmcr_aprs. It introduces a helper to fetch the host
> vCPU using container_of() and copies only the necessary state.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 45d717889f6ea..f3233ee343a39 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>
> [ ... ]
>
> > @@ -508,16 +520,63 @@ static void handle___vgic_v3_save_aprs(struct kvm=
_cpu_context *host_ctxt)
> >  {
> > -     DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
> > +     struct pkvm_hyp_vcpu *hyp_vcpu;
> > +     struct kvm_vcpu *host_vcpu;
> >
> > -     __vgic_v3_save_aprs(kern_hyp_va(cpu_if));
> > +     host_vcpu =3D get_host_hyp_vcpus_from_vgic_v3_cpu_if(host_ctxt, 1=
,
> > +                                                        &hyp_vcpu);
>
> [ ... ]
>
> [Severity: Critical]
> This is a pre-existing issue, but does the same regression exist for the
> GICv5 hypercalls?
>
> The patch replaces the direct kern_hyp_va() dereference with a secure loo=
kup
> for GICv3. However, it appears the same pattern remains in
> handle___vgic_v5_save_apr() and handle___vgic_v5_restore_vmcr_apr():
>
> handle___vgic_v5_save_apr()
>     __vgic_v5_save_apr(kern_hyp_va(cpu_if));
>
> Can a compromised host pass an arbitrary physical address here, causing
> __vgic_v5_save_apr() to write the hardware value of SYS_ICH_APR_EL2 to th=
at
> chosen address, breaking EL2 isolation?
>
> [Severity: Critical]
> This is also a pre-existing issue, but does handle___kvm_adjust_pc() have=
 a
> similar unvalidated host pointer dereference?
>
> In arch/arm64/kvm/hyp/nvhe/hyp-main.c:
>
> static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
> {
>         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
>
>         __kvm_adjust_pc(kern_hyp_va(vcpu));
> }
>
> If the host kernel passes a crafted vcpu pointer, could it point to an
> arbitrary memory region where the iflags offset has the INCREMENT_PC bit =
set?
>
> This would cause the hypervisor to execute:
>
> arch/arm64/kvm/hyp/exception.c:__kvm_adjust_pc() {
>     ...
>     } else if (vcpu_get_flag(vcpu, INCREMENT_PC)) {
>         kvm_skip_instr(vcpu);
>         ...
> }
>
> Could this allow an attacker to increment arbitrary EL2 memory by adding =
4 to
> the value at the regs.pc offset?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729131823.20=
21516-1-fuad.tabba@linux.dev?part=3D6
