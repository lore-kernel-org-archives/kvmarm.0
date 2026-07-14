Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DF6367F4A
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 11:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028028; cv=none; b=Sjv4k41jsUgywTra1KPIruO/EIVLPFDjZcwTdKDABh1ycuBJZgDBljpRNCI+2BQd/RBGQlH+C9lhs89/HWZus9ozGD0TaPqw4XxUrJKiwDXQkabZsVvaGJE15HFppqVh0Lma6/dmwTMyhI/k1LckWKpLlxmlRi9yhF9yp0g5JL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028028; c=relaxed/simple;
	bh=WOrw5qkPzB9oBFNLNJC9BzO5cCVnCxgoXPquHjdt+Wo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R4O4ykxZyeBuWFQhRKMDn/BdnsQRNntbkhHaZTMxE7mqF0Iy1UXWR+4aKTlZM1liAtfq5EvVoZXcwaCvIo9cYJISh7hlRrC3/fckYSvJJFccGu1rzWwk/xVUMmfiX9pqxHEIX8J7d2gh67XVS5NxTc2VzP6OS4R8jF4ea8rtnKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ppYj2fDR; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ppYj2fDR"
X-Gm-Message-State: AOJu0YygwRNFLwIMGlI4kOQjTee7I+g8NK5WJvznFMgZ6nHqVpEZnWdk
	XUI0Yy09WxBYplKEAjGf+cm/Ub6O+UL263tIkH1rBGyncK7A9vl+gkyBvdsPQ1jK5YosT4utCCA
	hyjZmxbPFTQEmr46z2/Hc16D+UKQjZGV8jRV3oU+I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784028024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jmFzw5bK929H9HFeKxXeNcRuvnnjQishKFDcT6QYAsc=;
	b=ppYj2fDRP2GLE/yuSB8MJpCL5Oiad0m0tQc+JlgQy/pxEjHEIMFkjy9bzdIt/Od/wjIEXB
	VRrxhNk15pbtMf98nbW2VkjgCUbDLdymVtg6QdNgvv3DXzR6bfCoK1cVE3xo18ych6ehy3
	+c0BF9X7rMFjw9gRtcfO0zNtsGgLYPY=
X-Received: by 2002:ac8:5cc6:0:b0:51b:fd5e:e81a with SMTP id
 d75a77b69052e-51d7c6a88e1mr14320221cf.20.1784028017417; Tue, 14 Jul 2026
 04:20:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260714101601.4142645-1-fuad.tabba@linux.dev>
 <20260714101601.4142645-3-fuad.tabba@linux.dev> <20260714104344.615DA1F00A3E@smtp.kernel.org>
In-Reply-To: <20260714104344.615DA1F00A3E@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 12:19:40 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw5H7zJSuvWhbAYpnuy0ByG1j3RWfSWRRs_tRfY7F98vQ@mail.gmail.com>
X-Gm-Features: AUfX_mz_vzWbO-_sHqGhxx3rD9jTsIh6c9xeT2ohmEmGvcHrpTax4TWHK2rpQI8
Message-ID: <CA+EHjTw5H7zJSuvWhbAYpnuy0ByG1j3RWfSWRRs_tRfY7F98vQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Tue, 14 Jul 2026 at 11:43, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Low] The WARN_ON_ONCE checks in __vcpu_read_sysreg_vhe and __vcpu_writ=
e_sysreg_vhe contain impossible conditions.
> --

That WARN_ON_ONCE() is unchanged from the current
vcpu_read_sys_reg()/vcpu_write_sys_reg() in mainline; this patch only
renames them, no functional change. It's now unreachable via the
wrapper, but since the patch exports the symbol it still guards a
direct non-VHE caller. I'd keep it and remove it in a separate patch
after this series if we decide it's worth it.

/fuad

> --- Patch [2]: [PATCH v5 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg =
available to HYP code ---
> commit fbd97ecacd267a88fbcb547ae114d7b3bbe56fb4
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
>
> This patch renames the host-only implementations to
> __vcpu_{read,write}_sysreg_vhe() and turns vcpu_{read,write}_sys_reg() in=
to
> context-dispatching wrappers. This allows helpers built on them to be sha=
red
> with hyp code.
>
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 08ba882799d48..c6a416974a61f 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -291,7 +291,7 @@ static void write_sr_to_cpu(enum vcpu_sysreg reg, u=
64 val)
> >       }
> >  }
> >
> > -u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg re=
g)
> > +u64 __vcpu_read_sysreg_vhe(const struct kvm_vcpu *vcpu, enum vcpu_sysr=
eg reg)
> >  {
> >       struct sr_loc loc =3D {};
> >
>
> [Severity: Low]
> Since the new vcpu_read_sys_reg() wrapper in kvm_emulate.h explicitly che=
cks
> has_vhe(), does this make the WARN_ON_ONCE(!has_vhe() ...) check inside t=
his
> function dead code?
>
> Specifically, just below this declaration:
>
>         locate_register(vcpu, reg, &loc);
>         WARN_ON_ONCE(!has_vhe() && loc.loc !=3D SR_LOC_MEMORY);
>
> Is it worth removing the check now that the caller guarantees has_vhe()
> is true?
>
> [ ... ]
>
> > @@ -338,7 +338,7 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, =
enum vcpu_sysreg reg)
> >       return __vcpu_sys_reg(vcpu, reg);
> >  }
> >
> > -void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysr=
eg reg)
> > +void __vcpu_write_sysreg_vhe(struct kvm_vcpu *vcpu, u64 val, enum vcpu=
_sysreg reg)
> >  {
> >       struct sr_loc loc =3D {};
> >
>
> [Severity: Low]
> Similarly, does the WARN_ON_ONCE(!has_vhe() ...) check inside this functi=
on
> become unreachable now that the wrapper only calls this when has_vhe()
> is true?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714101601.41=
42645-1-fuad.tabba@linux.dev?part=3D2
