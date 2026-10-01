Received: from mta0.migadu.com (out-202.mta0.migadu.com [91.218.175.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8945226B0
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867259; cv=none; b=Y41OIfRk1hQxtkxguNZTuiG+CUCBBv5eK3UD9U1O0VvNGFjP4SO+KfkvUyrYI8CxxEpOMnIqIi0amx/tDHiKVp/aBrJvNg38DvqdUUJrCpEdrSCBKN1fgyjTAH9PSRvHk96gjqh8BQGkiGllVWXZynSMvHVTB2H7Y+EplFQMReo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867259; c=relaxed/simple;
	bh=nAtQiDApLhCPVgj7Yq1VbX7po3hVPR72jdU3V8V1SDA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aJ4QQFs8wZbDDf1GrqtxwreqSheQIhdtZEWhHIsU56/8gdcCnIk/yCvA3JZ2IPtlZdPUbGrERUWegStVHZRj3V2ae82kgbTMnOUaPpA47Ko/xQaYyS03oRkjWAHHIiyhObaTpuLAyFI3k9TdNQ+UjG5utMtC+U9mGayOS6O9Who=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cP8FnLg8; arc=none smtp.client-ip=91.218.175.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cP8FnLg8"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=nAtQiDApLhCPVgj7Yq1VbX7po3hVPR72jdU3V8V1SDA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790867252; v=1; x=1791472052;
 b=cP8FnLg8FPHS0IShHcVDtpfOgmbFIp4iQmz+UAcVof4c+N6P5W8v3WRXUIlqsLMFzDlJqG3k
 gy3U+x0ZykwmL7b1/JiqGSJ7UiIlXCwsmFhAwJgC+tR8cxoaUIGg6Pz02WLASK+EM+lMGv9YACd
 5BfsuhnK85iY+SDTFecpbWGU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b38215a03ce78eec;
	Thu, 01 Oct 2026 15:07:32 +0000
X-Mizu-Trace-ID: b38215a03ce78eec
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5ba4065fa07so9179e87.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 08:07:29 -0700 (PDT)
X-Gm-Message-State: AFq9FYIAZlFzgST1oAk5H/va01xJWtvTTdiCFx8yh85sNdEnA+sZkDJo
	+qwKakiFb0x0lGSkJnfy7xrZRkDv/sU1QmuKggNE6qbVPyUFi1vHUi3jgM39zy6PF7GQQMIVo9n
	OTmI4lkY7Rp61338GtLqjALt9f8tbR+igYFRtMEL9
X-Received: by 2002:a05:6512:3089:b0:5ba:3534:fb8f with SMTP id
 2adb3069b0e04-5ba4419623dmr146718e87.15.1790867248689; Thu, 01 Oct 2026
 08:07:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
 <20261001135711.1640520-7-fuad.tabba@linux.dev> <20261001141928.87F621F000FF@smtp.kernel.org>
In-Reply-To: <20261001141928.87F621F000FF@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 1 Oct 2026 16:06:52 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyLOCBmFwFDK130U8unjA2V2vBqWT9WCNmVEC=40t=LZA@mail.gmail.com>
X-Gm-Features: AclHuK9-pshdeMgQIYlcNOB37uw3lYCk14jRj8TLlRSlJOhoHmYnuHcNwUeiPGY
Message-ID: <CA+EHjTyLOCBmFwFDK130U8unjA2V2vBqWT9WCNmVEC=40t=LZA@mail.gmail.com>
Subject: Re: [PATCH v4 06/18] KVM: arm64: Skip fixed-feature state flush for
 protected vCPUs
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Oct 2026 at 15:19, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] kvm: arm64: host hardware breakpoints leak into protected guests

No hardware breakpoint/watchpoint support for protected guests yet. A
protected guest sees DebugVer as 0.

/fuad

> --
>
> commit 678dfb9fd1576272693dba360820510bcb1ec938
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
>     KVM: arm64: Skip fixed-feature state flush for protected vCPUs
>
> This commit moves the mdcr_el2 and TWI/TWE copies into the non-protected
> branch. It returns early from flush_debug_state() and sync_debug_state() =
for
> protected vCPUs, as their debug registers are hypervisor-owned, and
> configures HPMN at vCPU load.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index e3f4bbb623492..b7b9f5afb673b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -200,6 +200,9 @@ static void flush_debug_state(struct pkvm_hyp_vcpu =
*hyp_vcpu)
> >  {
> >       struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> >
> > +     if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> > +             return;
> > +
>
> [Severity: High]
> Could this early return cause a regression by allowing the host's hardwar=
e
> breakpoints to leak into the protected guest?
>
> By returning early here, the hyp vCPU's debug_owner remains VCPU_DEBUG_FR=
EE (0)
> for protected VMs.
>
> During the world switch, this causes the hypervisor to skip context-switc=
hing
> the hardware debug registers because kvm_debug_regs_in_use() evaluates to=
 false:
>
> arch/arm64/kvm/hyp/include/hyp/debug-sr.h:__debug_switch_to_guest_common(=
) {
>     ...
>         if (!kvm_debug_regs_in_use(vcpu))
>                 return;
>     ...
> }
>
> As a result, the host's physical breakpoints remain active in hardware.
>
> If the guest implements DebugVer, MDCR_EL2.TDA is not set:
>
> arch/arm64/kvm/hyp/nvhe/pkvm.c:pvm_init_traps_mdcr() {
>     ...
>         if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, IMP))
>                 val |=3D MDCR_EL2_TDRA | MDCR_EL2_TDA;
>     ...
> }
>
> This gives the guest untrapped access to MDSCR_EL1. If the guest sets
> MDSCR_EL1.MDE=3D1, the host's hardware breakpoints could fire inside the =
guest
> at EL1, circumventing guest isolation.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001135711.16=
40520-1-fuad.tabba@linux.dev?part=3D6
