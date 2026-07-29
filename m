Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E56476CE0
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 13:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332851; cv=none; b=HAlsVbYUiRRUnxuGZmQKQqbLinFgc88WZJK6ZtFE0pHZoN66zNRbYNIec3MYFJshXTJ4YmLFgeW3sgt4xMJ2kOezBVYchHqhBl55MLrLOcnQmvP4S84xoBZvMii5rgmJNghFE4QDwzJ8DAaiYgcIlK6AFOs9WFOjbzIfyb+PrTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332851; c=relaxed/simple;
	bh=uLPT3qPDw6PyRFoDxxyAxWqaBZfCeUSz64TubquYANA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dvLguJW6zmtXaWOfmKh5TbGjetllJEYKRkIB7Ilv0t9ubkV7KT77+tXmG65RDIgRNrP0e+xL4iTOx/V6mPsZK96vYPHNyPdZFpHs3FMF/B+TP8cMRj0reBiAtDDgpVOEA+x++IPcn+3pb5lUd9QnsI4E2FWHv1LLI3xqDaEkEJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L9vWnNe+; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L9vWnNe+"
X-Gm-Message-State: AOJu0Yx/8U7UsMbgKl7L4aISa/L6QiFRnRxeHd1FysCdYOnuLxznllVZ
	XYffR8xtlTBycn59nAszwW+fkOmFy1rx77Y4Y9JdxZsMNcVG01tOcqhh8nAYgu2ywFEsYiSCFeg
	P6PSEVwsEWTy2QnsluOyMebkeCDlX65b0PhB10uxV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785332847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ObLTe4j5+GIry/KA4AvGwNTy0S0bPjoV/ugF789jLJM=;
	b=L9vWnNe+y8B5xlalYAyoXI/VSKkNLVe9GtpAhLwSsbmdkWrkTygKRSM+cs6kxzD5Z7DtTH
	EPTuJTo0rMfZ27Xztd7Ivle/+HZotUUvMI9F3pN/BCG6fPh09avdu8DlIvvIrc1UgKbocY
	l6BF7GbTYo8NzUHrA0E9KIBd1W9LlHs=
X-Received: by 2002:a05:622a:514a:b0:51c:935d:8d74 with SMTP id
 d75a77b69052e-52b2cc85692mr9349041cf.9.1785332844512; Wed, 29 Jul 2026
 06:47:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260729131823.2021516-1-fuad.tabba@linux.dev>
 <20260729131823.2021516-9-fuad.tabba@linux.dev> <20260729133600.ABD741F000E9@smtp.kernel.org>
In-Reply-To: <20260729133600.ABD741F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 29 Jul 2026 14:46:47 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxCuAgBdRkACw26=F2-k98BrDxzwaLyhyT5uGN+-4-ZKQ@mail.gmail.com>
X-Gm-Features: AUfX_mw-VKzX9ky4UGdBykDDFy1qEMOQhp9w5ae93rayF3NMCo2lEeXnhpzdnA4
Message-ID: <CA+EHjTxCuAgBdRkACw26=F2-k98BrDxzwaLyhyT5uGN+-4-ZKQ@mail.gmail.com>
Subject: Re: [PATCH v7 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Wed, 29 Jul 2026 at 14:36, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [High] Missing HCR_EL2 state synchronization breaks virtual SError inje=
ction, causing an infinite exception loop.
> - [High] Lazy state sync fails to flush context after KVM_REQ_VCPU_RESET,=
 causing vCPU resets (e.g., PSCI CPU_ON) to be ignored.

I think this covers it:

https://lore.kernel.org/all/CA+EHjTxiyUSJqRcadSCOmR+tELSsBiGaTYH9xxXh-g-xyu=
HZdA@mail.gmail.com/

/fuad

> --
>
> --- Patch [8]: [PATCH v7 8/8] KVM: arm64: Implement lazy vCPU state sync =
for non-protected guests ---
> commit 80df5c4ca2cca0a1726813fa129b353353482892
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Implement lazy vCPU state sync for non-protected guests
>
> This commit optimizes world switches for non-protected guests by deferrin=
g
> the copy of the vCPU register context between the host and hypervisor.
> State is now only synced on entry if marked dirty, and on exit only when
> explicitly needed by the host.
>
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.=
c
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -486,9 +486,32 @@ int handle_exit(struct kvm_vcpu *vcpu, int excepti=
on_index)
> >       }
> >  }
> >
> > +static void handle_exit_pkvm_state(struct kvm_vcpu *vcpu, int exceptio=
n_index)
> > +{
> > +     int exception_code =3D ARM_EXCEPTION_CODE(exception_index);
> > +
> > +     if (!is_protected_kvm_enabled() || kvm_vm_is_protected(vcpu->kvm)=
)
> > +             return;
> > +
> > +     /*
> > +      * Sync the context back when the host will read (trap) or write
> > +      * (SError) it. Preempt-off here, so the loaded hyp vCPU is stabl=
e.
> > +      */
> > +     if (exception_code =3D=3D ARM_EXCEPTION_TRAP ||
> > +         exception_code =3D=3D ARM_EXCEPTION_EL1_SERROR ||
> > +         ARM_SERROR_PENDING(exception_index)) {
> > +             kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> > +             vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > +     } else {
> > +             vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
>
> [Severity: High]
> Is it possible for KVM_REQ_VCPU_RESET updates to be ignored due to this
> cleared flag?
>
> If a secondary vCPU is powered on (for example, via PSCI CPU_ON), it
> receives KVM_REQ_VCPU_RESET and gets kicked, leading to an exit with an
> IRQ. Since that exit takes this else branch and clears the dirty flag,
> and the reset request is processed afterward in kvm_vcpu_check_requests()
> which modifies the host-side vCPU context, wouldn't flush_hyp_vcpu() skip
> syncing this updated reset state because the flag remains cleared?
>
> This could result in the target vCPU resuming with its pre-IRQ stale
> context, eventually overwriting the new reset state on the next exit.
>
> > +     }
> > +}
> > +
>
> [ ... ]
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -203,9 +255,16 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
> >       fpsimd_sve_sync(&hyp_vcpu->vcpu);
> >       sync_debug_state(hyp_vcpu);
> >
> > -     host_vcpu->arch.ctxt            =3D hyp_vcpu->vcpu.arch.ctxt;
> > -
> > -     host_vcpu->arch.hcr_el2         =3D hyp_vcpu->vcpu.arch.hcr_el2;
>
> [Severity: High]
> Does removing this HCR_EL2 assignment break virtual SError injection and
> cause an infinite exception loop?
>
> When the host injects a virtual SError into a non-protected guest under
> pKVM by setting HCR_VSE in the host-side vcpu->arch.hcr_el2, the hardware
> automatically clears the VSE bit in the physical HCR_EL2 register once th=
e
> guest takes the exception.
>
> Without syncing this hardware-cleared state back to the host here, the
> host's HCR_VSE bit remains set. On the next entry, flush_hyp_vcpu() will
> repeatedly re-inject the stale HCR_VSE bit from the host into the hyp vCP=
U,
> locking up the guest.
>
> > +     if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> > +             host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;
> > +     } else {
> > +             /*
> > +              * PC feeds trace_kvm_exit(), PSTATE.SS the host software=
-step
> > +              * machine, and both run before the next on-demand ctxt s=
ync.
> > +              */
> > +             host_vcpu->arch.ctxt.regs.pc =3D hyp_vcpu->vcpu.arch.ctxt=
.regs.pc;
> > +             host_vcpu->arch.ctxt.regs.pstate =3D hyp_vcpu->vcpu.arch.=
ctxt.regs.pstate;
> > +     }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729131823.20=
21516-1-fuad.tabba@linux.dev?part=3D8
