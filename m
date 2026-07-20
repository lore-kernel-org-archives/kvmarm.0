Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE07145BD4E
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 18:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784570568; cv=none; b=UtEfBL1tUNr43J5q0yXGXqJ4VxOmJM6VHEmFm96W7IcPsui14os8Uwfy2ZmcvrQJiJU04r/uWqmJaDFdg0g4FUWMzMEtyd16cCyu2/kRyot3TbXTQYiRx8wl6oe0cK+3X2EwM5T6FeiSTVEIfIE3UoB2vNGBfzkJXNi/gxTVKuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784570568; c=relaxed/simple;
	bh=FbxTSG7B0R0fDQI4Zt96E7iHeP2B4xF124Fz2FykG0s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nLWafzZrkaO5OlOXfztfGKce7pRpd/jL1R7STPlzMo6kjE42SXTo9yFeFl0Q1cYaNmM7RhDVTzFDEwppflHcseBDV2NFsRDmZgbMK1nO8m8YNMjgm3ya46v09m5v5FV1TqswMEaU6w/dc98ZpAiTWicIUlT7Rwv2FFrKKqpw0vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OOJyRi4j; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OOJyRi4j"
X-Gm-Message-State: AOJu0Ywy/eQW7aOUMkvKCis2nZSEb4n9LaMMhPMFlH6OQMnkz2NYbpEI
	w/imyrkZaDqxudzvgb2cfBH+3b0NSyTW08bvOk4eURyLuKOq2lkSxPIOoM55oNcLxE4iwel5t9K
	XwA0prPU1CZVKQrF+Fr+MwaDDO6ybYG6hLjfzD5zG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784570562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G+753BV2OTKBKhIRsjvrO6VQ0UCpvoUpMC/Bxc7JhBQ=;
	b=OOJyRi4jKU73iIrSdSpVLG8QtadfNZUHshQ5QvkYMERMvmXJR/6Hl2XX9u0VNVddz7pqUu
	CGFGSJBTIdhRQI/jIqEXZfQ9gFsHCz4mwz4t2pEiyqE0lzRaOz2KyvMuCeMQf/GVdimeQN
	R1KFxChyRwtCect61YG2M9vHLF+70wg=
X-Received: by 2002:a05:622a:2447:b0:517:6dc0:698d with SMTP id
 d75a77b69052e-525fd38e85cmr4534891cf.0.1784570554772; Mon, 20 Jul 2026
 11:02:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720161343.1367007-1-fuad.tabba@linux.dev>
 <20260720162412.1401272-1-fuad.tabba@linux.dev> <20260720174229.DF3AB1F000E9@smtp.kernel.org>
In-Reply-To: <20260720174229.DF3AB1F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 20 Jul 2026 19:01:57 +0100
X-Gmail-Original-Message-ID: <CA+EHjTznttX+cqdrndR28OeOLqaZX4suaG_E5an7_ER_gYwz3g@mail.gmail.com>
X-Gm-Features: AUfX_my_ve-rpD8E3GBCRW9xQhL7dBOd9z6G87B0ydP5HJBiOOPLWHMpdNutBTw
Message-ID: <CA+EHjTznttX+cqdrndR28OeOLqaZX4suaG_E5an7_ER_gYwz3g@mail.gmail.com>
Subject: Re: [PATCH v1 10/11] KVM: arm64: nVHE: Check hypercall handlers
 against the declared ABI
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Mon, 20 Jul 2026 at 18:42, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] The MDCR_EL2 trap configuration register is unconditionally =
copied from the untrusted host VCPU on every guest entry, violating pKVM is=
olation guarantees for protected VMs.
> - [Critical] The protected VM's register context (`ctxt`) is copied back =
to the untrusted host VCPU on every exit, leaking confidential guest state.

I'm working on it [1]. This is part of upstreaming pKVM. We'll get
there eventually...

/fuad

https://lore.kernel.org/all/20260715081238.1891918-1-fuad.tabba@linux.dev/
> --
>
> --- Patch [10]: [PATCH v1 10/11] KVM: arm64: nVHE: Check hypercall handle=
rs against the declared ABI ---
> commit 3f8ed457b3a7f1b8aabe10f15d93afe4df7e93a2
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: nVHE: Check hypercall handlers against the declared ABI
>
> This commit generates the unmarshalling of hypercall handlers using
> DEFINE_KVM_HOST_HCALL. It checks the handler's parameter list against the
> signature declared in kvm_hcall.h to prevent caller/handler disagreements=
.
> Manual DECLARE_REG casts are removed from the handler bodies.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>
> [ ... ]
>
> > @@ -228,15 +282,11 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_=
context *host_ctxt)
> >                * loading a vcpu. Therefore, if SME features enabled the=
 host
> >                * is misbehaving.
> >                */
> > -             if (unlikely(system_supports_sme() && read_sysreg_s(SYS_S=
VCR))) {
> > -                     ret =3D -EINVAL;
> > -                     goto out;
> > -             }
> > +             if (unlikely(system_supports_sme() && read_sysreg_s(SYS_S=
VCR)))
> > +                     return -EINVAL;
> >
> > -             if (!hyp_vcpu) {
> > -                     ret =3D -EINVAL;
> > -                     goto out;
> > -             }
> > +             if (!hyp_vcpu)
> > +                     return -EINVAL;
> >
> >               flush_hyp_vcpu(hyp_vcpu);
>
> [Severity: Critical]
> This is a pre-existing issue, but does this function allow the untrusted
> host to bypass pKVM isolation guarantees?
>
> Looking at flush_hyp_vcpu() in arch/arm64/kvm/hyp/nvhe/hyp-main.c, the
> MDCR_EL2 trap configuration is copied unconditionally from the untrusted
> host vCPU on every guest entry:
>
> hyp_vcpu->vcpu.arch.mdcr_el2 =3D host_vcpu->arch.mdcr_el2;
>
> For a protected VM, the MDCR_EL2 trap configuration should be strictly
> EL2-private and initialized internally. By syncing this from the host on
> every entry, could the host maliciously reconfigure the guest's debug
> traps?
>
> [Severity: Critical]
> This is also a pre-existing issue, but does the exit path leak
> confidential guest execution state to the host?
>
> In the corresponding sync_hyp_vcpu() function called after the guest
> run, the protected VM's register context is copied back to the host
> vCPU:
>
> host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;
>
> Since this copies the hypervisor's private copy of the guest's context
> back into the host-controlled structure, won't this allow the host EL1
> to directly inspect highly confidential execution state (including
> general purpose registers and system registers) after the hypercall
> returns?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720162412.14=
01272-1-fuad.tabba@linux.dev?part=3D10
