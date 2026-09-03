Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA544AA00A
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452926; cv=none; b=fA7dsnzIvqc9MKSLSeTKpOqo8dFjqFH+YKSM3TmWBF3hpaBsjw6G+/H5Uu6WfUTngKJvsymfu0zwByz3wGLCAW93c1XXZAFyRlornbiqJaeJedTzHOAHt+AIIH/dsC/QrM59+2V7+11yni5rQFDo+YEtgnNYRFcnaGNPWWrg58k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452926; c=relaxed/simple;
	bh=0USE6Awx9VXRP0Erkb0PbxpI0mvXTdqrBT5kx6B+zcY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YxlLDJErkfxrbG6iZQIEwhUcSrjKT6AvoX1CheL7u2MG+kNlZS+CTcKzzHBxpj0QXcuW+utlGA8y6CvAvkX8k5VKjAvvSprxXm58T09a0gCZWOa5a3/hvCh2L5IjEpUfCMngoa1tsR1a0acUg1ELfwcOmX3jjmRMTrkLIfnRjVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=olLR52Y3; arc=none smtp.client-ip=91.218.175.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="olLR52Y3"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=0USE6Awx9VXRP0Erkb0PbxpI0mvXTdqrBT5kx6B+zcY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788452921; v=1; x=1789057721;
 b=olLR52Y3afNTYxxAlD8ta1ov28tmh866xMBuCq4ljoPvCGUqPf2cEWponIdKQXZ3T/CWS4dw
 7+GUbg6yM0SMKt2MlDCAFswIsayrCK6UPDn+9y1NrEaoXKWGJM6TQUmqXcYbp/MTF0WpFya6HhA
 ctbWiYrtXqoXPKkdQeut7dKg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 99422cee00a6c70d;
	Thu, 03 Sep 2026 16:28:41 +0000
X-Mizu-Trace-ID: 99422cee00a6c70d
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17358so6660e87.1
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 09:28:40 -0700 (PDT)
X-Gm-Message-State: AFuF++kjTQcSvl3oe92y0G1Rgl1rUgp6ylR9Wqa/36APcvks+asEZgRx
	BfULkoZ/4UzjAX+wYow0TOYosRsqGQvrfYE/xzhWxVmiHVwbfY8hLwHkvec6kf/kIaQ+1vVIOgc
	51wevwfYHe7NOO52YatBfDsJepI94fJabzCSc1d1c
X-Received: by 2002:a05:6512:3e16:b0:5b6:bcb:26c4 with SMTP id
 2adb3069b0e04-5b60eccaa8bmr183949e87.16.1788452919742; Thu, 03 Sep 2026
 09:28:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260903160819.831518-1-fuad.tabba@linux.dev> <20260903162541.A32DC1F000E9@smtp.kernel.org>
In-Reply-To: <20260903162541.A32DC1F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 3 Sep 2026 17:28:03 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw=cTvcorcYHjBk_73ODSyNxz9NBoLN64H9P3G1WoLSXA@mail.gmail.com>
X-Gm-Features: AcwNN1VCcv9YNULLmWDEFfrOBTKE0uld1vl6M3VH-xt2lWn7L03-F_jkNljXbe0
Message-ID: <CA+EHjTw=cTvcorcYHjBk_73ODSyNxz9NBoLN64H9P3G1WoLSXA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Sept 2026 at 17:25, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] KVM fails to trap guest accesses to MPAM registers when the sani=
tized MPAM capability evaluates to false (e.g., due to `arm64.nompam` boot =
parameter or asymmetric CPU topologies), allowing the guest to directly acc=
ess physical host MPAM hardware.

See : https://lore.kernel.org/all/20260903084809.2027326-1-fuad.tabba@linux=
.dev/

/fuad


> --
>
> commit 4af5e7631ab3a7072311a3251a8c2768e198ef2e
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
>
> This patch updates KVM to trap guest accesses to MPAM registers based sol=
ely
> on the ID registers rather than the ARM64_MPAM capability, which also
> requires MPAMEN to be set.
>
> Link: https://lore.kernel.org/all/CA+EHjTxeWxZiuSmnKLGLxTBXP4oJT7-LuffbPA=
yCSZZ5TW=3D5Ew@mail.gmail.com/
>
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeat=
ure.c
> > index 17b83a2518a8f..36a27692e5cf7 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -2501,6 +2501,13 @@ test_has_mpam(const struct arm64_cpu_capabilitie=
s *entry, int scope)
> >       return (read_sysreg_s(SYS_MPAM1_EL1) & MPAM1_EL1_MPAMEN);
> >  }
> >
> > +static bool
> > +test_has_mpam_sysregs(const struct arm64_cpu_capabilities *entry, int =
__unused)
> > +{
> > +     /* The registers exist whether or not firmware enabled MPAM. */
> > +     return detect_ftr_has_mpam();
> > +}
> > +
>
> [Severity: High]
> This isn't a bug introduced by this patch, but it appears to be a
> pre-existing issue. Does relying on detect_ftr_has_mpam() here leave the
> physical MPAM hardware exposed?
>
> The detect_ftr_has_mpam() function checks the sanitised CPU feature
> registers. If the host is booted with the arm64.nompam parameter, or on
> systems with asymmetric CPU topologies where the boot CPU lacks MPAM, thi=
s
> check will evaluate to false even if the physical hardware on the current
> CPU implements MPAM.
>
> [ ... ]
>
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/h=
yp/include/hyp/switch.h
> > index 1ce7130e25490..8941335724f6b 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -298,7 +298,7 @@ static inline void  __activate_traps_mpam(struct kv=
m_vcpu *vcpu)
> >       u64 clr =3D MPAM2_EL2_EnMPAMSM;
> >       u64 set =3D MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
> >
> > -     if (!system_supports_mpam())
> > +     if (!system_supports_mpam_sysregs())
> >               return;
> >
> >       /* trap guest access to MPAMIDR_EL1 */
>
> [Severity: High]
> This is also part of the pre-existing issue mentioned above.
>
> When system_supports_mpam_sysregs() returns false due to the sanitised
> feature registers, this early return skips setting the TRAPMPAM0EL1 and
> TRAPMPAM1EL1 trap bits in SYS_MPAM2_EL2.
>
> Since the hardware traps remain disabled, could this allow a malicious
> guest to directly access physical MPAM configuration registers (such as
> MPAM0_EL1) and bypass hypervisor isolation? This might allow the guest to
> manipulate host cache and memory bandwidth partitioning, potentially
> causing a denial of service against the host or other VMs.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160819.83=
1518-1-fuad.tabba@linux.dev?part=3D1
