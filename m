Received: from mta1.migadu.com (out-73.mta1.migadu.com [95.215.58.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC3635E95A
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 10:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788257893; cv=none; b=MBJt0cUJ4mmtv5WMpJBe/iyaXqDGjfks0B9R83yVXnbNLlICBinOYRY4KafDVytG1WBkfqVOOxoedDrNihI/XJBRP9VXSNLnigcz5c7yN0VtMNo0lyRpIpYuOG11ViX4huncrrba+9jbnZNFuweMesfPEh1hsSJmTvUIPcZ/ycM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788257893; c=relaxed/simple;
	bh=uD0GgEFbux6jCH7K6cAknBBr7yR9JjdUKd7dTuffxPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kDNZ8x7xxwvEK+/u6TnH8GzwpOhhn/hBcBc4c1xKMO0/+Mg8omldTPSeW83dmwj6ezDmG7IKCvYf0aAjfSUmfbxN/UDkQ7k02l/+9ujIbTdLHKPdzhfhcOGwLBo2U6XWqcwfIZePFFDgRgW3dhpVb/saklEgnqEJI8MDvIo4oMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bmDt9COv; arc=none smtp.client-ip=95.215.58.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bmDt9COv"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=uD0GgEFbux6jCH7K6cAknBBr7yR9JjdUKd7dTuffxPI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788257889; v=1; x=1788862689;
 b=bmDt9COvmc/Y4XdTC50DsozN6lpDVN6DpxTE6g5tPaXlqdlOqDXiWBM0MwfWN5+FCgtp2D7m
 Q8NIqwq+X6ZobQLSHxe5eRp6nCtTQsczNGMtREd/6MMWgAkefjtUKuLP+LF0rCkDU/PYTWyeBSQ
 T3AnE1ML//qLPTrfy5zzoB14=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e9488623b694ea29;
	Tue, 01 Sep 2026 10:17:59 +0000
X-Mizu-Trace-ID: e9488623b694ea29
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b5e5aaf7deso6889e87.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 03:17:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzDo8kh4rR7/aOS7ALObc+k42UsCTUYUKrqBbsI8GfopWYiwFyfwky78tUr+gYLcMBamCzYx9c=@lists.linux.dev
X-Gm-Message-State: AFuF++nQj6fOYt87sike6huTc+YUuQmxp/An3wWhhaLQJfmLsIdjqP1M
	FMdanxxriyuYuBSeogqdhPGldgsO1E77FacmTD4baYua8QxLmHlehkumVOhfU6VI7cX1FeI7Hiw
	+bmdOrfUfRi8FR1n6yO2lVuuR+NRYViwvEQYAW255
X-Received: by 2002:a05:6512:1309:b0:5b6:4ae:3fef with SMTP id
 2adb3069b0e04-5b604ae4113mr20499e87.14.1788257874587; Tue, 01 Sep 2026
 03:17:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831163421.272420-1-fuad.tabba@linux.dev> <20260831163421.272420-8-fuad.tabba@linux.dev>
 <20260831202209.58EAC1F000E9@smtp.kernel.org>
In-Reply-To: <20260831202209.58EAC1F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 11:17:18 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzzVxmPv1gV2GSbn9zoavC0RXYfc96=66YANwm2mXujuw@mail.gmail.com>
X-Gm-Features: AcwNN1X2vrS7sBqUSmpOETSLoJmRWz8Nzp_ep7RH1bSPmkCbReV6dID_ak-GoIk
Message-ID: <CA+EHjTzzVxmPv1gV2GSbn9zoavC0RXYfc96=66YANwm2mXujuw@mail.gmail.com>
Subject: Re: [PATCH 07/17] KVM: arm64: Add system register reset framework for
 protected VMs
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sashiko, I challenged you, and you delievered... I'll give you 1/2 here...

On Mon, 31 Aug 2026 at 21:22, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [High] EL2 reads host-controlled system registers (ACTLR_EL1 and AMAIR_=
EL1) to initialize protected VM state, violating the pKVM trust boundary.
> - [High] Host-provided vcpu_id is used to calculate the protected VM's MP=
IDR_EL1 without uniqueness validation, violating architectural constraints.
> --
>
> commit 84ffa62c045287810116009ea32700416618900e
> Author: Fuad Tabba <fuad.tabba@linux.dev>
> Subject: KVM: arm64: Add system register reset framework for protected VM=
s
>
> Reset a protected VM's system registers at EL2 rather than taking the
> host's values: add kvm_reset_pvm_sys_regs() and the
> pvm_sys_reg_reset_vals[] table that drives it, and call it from
> init_pkvm_hyp_vcpu() for protected vCPUs. The values follow the
> host-side reset in sys_regs.c, with a poison value where it resets to
> UNKNOWN, and for VBAR_EL1 and CONTEXTIDR_EL1 in place of the 0 it
> resets them to. MPIDR_EL1 is derived from vcpu_id, as for any KVM
> guest.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nv=
he/sys_regs.c
> > index 8758c68017765..ebfd48aa15b56 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
>
> [ ... ]
>
> > +/* Hardware value, as sys_regs.c's reset_actlr()/reset_amair_el1(). */
> > +static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_de=
sc_reset *r)
> > +{
> > +     __vcpu_assign_sys_reg(vcpu, r->reg, read_sysreg(actlr_el1));
> > +}
> > +
> > +static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_re=
g_desc_reset *r)
> > +{
> > +     __vcpu_assign_sys_reg(vcpu, r->reg, read_sysreg(amair_el1));
> > +}
>
> [Severity: High]
> Does this allow the host to dictate the protected guest's initial registe=
r
> state?

I'll give you this one Sashiko... Both will reset to 0 in v2, and
these two functions go with them. Mirroring KVM's reset was the wrong
call here.

>
> Since EL1 has write access to both the actlr_el1 and amair_el1 hardware
> registers, the host could set them to arbitrary values before the vCPU
> creation hypercall is invoked. Seeding EL2-private state for a protected
> guest by reading host-modifiable hardware registers instead of using
> hardcoded architectural constants appears to breach the pKVM trust bounda=
ry.
>
> > +
> > +static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_de=
sc_reset *r)
> > +{
> > +     __vcpu_assign_sys_reg(vcpu, r->reg, kvm_calculate_mpidr(vcpu));
> > +}
>
> [Severity: High]
> Can a malicious host supply duplicate vcpu_id values?
>
> Earlier in init_pkvm_hyp_vcpu(), hyp_vcpu->vcpu.vcpu_id is directly copie=
d
> from the untrusted host_vcpu. Since kvm_calculate_mpidr() calculates the
> guest's MPIDR_EL1 value based on this unvalidated vcpu_id, could the host
> use this to instantiate a protected VM with duplicate MPIDR_EL1 values
> across its vCPUs?

... but not this one. KVM does not check for uniqueness either:
kvm_init_mpidr_data() keeps the last vCPU written into an aliased
slot.

Cheers,
/fuad




>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831163421.27=
2420-1-fuad.tabba@linux.dev?part=3D7
