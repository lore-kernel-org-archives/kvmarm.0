Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794396264;
	b=fuvPRczADhC1ZNhSE6RmiqfBF0oR8jGnxrB/H6e06kf+6xqjnOxDYgjwPCLyPXVZSAXx
	 5QuYOXGuS4NAR6ZduwSIyJn8Esq29KwQ5rY1l5z3YxRs3KhCAx7I56e/54hUeZ2i3wejd
	 pi0sGLnXMtPt2rRbad7xJdvOY4x6/4b3VHNyG1v+v+24jtU8jXrwwCerZu2hIIj1aCznV
	 9RxP7GlkAP4m37gZh9gmumVCYrY42zSUkpwP5cq9Th1h9wpgPbk0rhQ2m52dG29+BgVCI
	 qii941GqoDbj6EgOCQmXoKrOEFvoyOWQcRoMaNcEhR9pENQbTIRmfBZ4XwjV528T0SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794396264;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=lLJ+RytG/Z6fAA7i4XLswM02XTXV1PXuYSsk4iRByVs=;
	b=v0bIq8mjDfIXLLt7KnymQvFJWJim/uIuOdb7rabGZ8MPUONNQ815qcvpR1NRD14HmDxa
	 a/jAufdIfQAzFLGaOk4CIuI48ARaZ1mTolbj5ZUN02LFHIgM6DiXKzeQKi3h/GdTjUTh6
	 cQQcegZF/vQK2eUoAjLQpTYqQoXQ+ai+LWYeAnxvpqaNfhG+DwEKsZlcL3tIT6dcnUelY
	 T+8qL7q9VzTtq8XJi9T21qq9bz0UiTBTEh7/OiTZUmrL6ZxboO/wfuuMe0j1j3jUQKtct
	 DgY4F4YMEOItsYBxnubdJzMUxnesnGmBWFv/Z5Nm/s/PWorJRuJWW3jHRBb9Uf3Fq8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=id9u9kOY;
	arc=none smtp.remote-ip=95.215.58.200
Received: from mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A03606A897
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 11:24:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0A03606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=id9u9kOY
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=LTkmc0WCsHinhYMS/2OI3bvHrpQrAYvGB39j0bNDVNM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794396261; v=1; x=1795001061;
 b=id9u9kOYpC9lFuAM6/pI9Q1grdvEKspToGw6upajl2wr80LRXcYfrx4TmvXDEBya0Qw/AiEm
 attNCinHGH0jP5NguQ5U+iioJCxY6kFT3rDwxThzidMO5b5bbDyPFa8uXVTijKEj2a8195M1JjM
 DV5ojOJe47HuhvOARFpABTKw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f67e264b7bba1f89;
	Wed, 11 Nov 2026 11:24:21 +0000
X-Mizu-Trace-ID: f67e264b7bba1f89
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so2678e87.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 03:24:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGdT4JW3rKIkuponFOHIbL7fs+QK0YcnuCWwR5839XVxUbs5HfxmoB1IpU5VtHZ1ewrGV3OJGQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z9G4W4ogPHZnp7ocWEzuH0lrT8zlj7UhDVrYzc+p0bDh/O72OQS
	ZJgpVdsEdnlofFjZz7/BT3RoPUoVBeYh1o4nrITkVFG44t+3B3nU+tjdi8IDoKYCFwpxLIeYAVf
	I8y0CtWCP1YKvFT9dIlxSrDz6GwNTguFAX1xtp1Ch
X-Received: by 2002:a05:6512:3e0d:b0:5bf:d226:862e with SMTP id
 2adb3069b0e04-5c15d37f11cmr144047e87.2.1794396260539; Wed, 11 Nov 2026
 03:24:20 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261111082746.1064567-1-fuad.tabba@linux.dev> <86mrrf1ux8.wl-maz@kernel.org>
In-Reply-To: <86mrrf1ux8.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 11 Nov 2026 11:23:44 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxXf+os+68gTeHb9H0UaCT994+w6aCrnUXaFYkm0Eo3Cw@mail.gmail.com>
X-Gm-Features: AclHuK_tB5ygP1htfYcTK39qsoECE8_zGN_xazx4QuE8eQkwLTDZ6N_3PXY9CxQ
Message-ID: <CA+EHjTxXf+os+68gTeHb9H0UaCT994+w6aCrnUXaFYkm0Eo3Cw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Sync SCTLR_EL1 before a pVM's CPU_ON reads
 its endianness
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Nov 2026 at 11:15, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 11 Nov 2026 08:27:46 +0000,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > pKVM handles a protected guest's PSCI CPU_ON at EL2 before the guest's
> > EL1 sysregs are saved, so kvm_vcpu_is_be() reads a stale SCTLR_EL1. A
> > guest that changes SCTLR_EL1.EE and calls CPU_ON before its next exit
> > to the host starts the target vCPU with the old endianness.
> >
> > Sync SCTLR_EL1 before the read, as inject_sync64() does.
> >
> > Fixes: 9d4ec80be2eb4 ("KVM: arm64: Handle PSCI calls for protected VMs at EL2")
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >
> > Notes:
> >     inject_sync64() is the only other reader on a protected guest's exit
> >     path of a guest-writable EL1 sysreg's copy, and it syncs that register
> >     first. Saving SCTLR_EL1 before the in-loop exit handlers instead would
> >     put the save on every protected exit for two readers. A non-protected
> >     guest's CPU_ON is handled by the host, after the sysregs are saved.
> >
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index fc0475f0877d1..e421f45383e0d 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -1321,6 +1321,9 @@ static bool pvm_psci_vcpu_on(struct pkvm_hyp_vcpu *hyp_vcpu)
> >               goto error;
> >       }
> >
> > +     /* Sync SCTLR_EL1 for kvm_vcpu_is_be(), as HVCs are handled before sysregs are resync'ed. */
> > +     __vcpu_assign_sys_reg(&hyp_vcpu->vcpu, SCTLR_EL1, read_sysreg_el1(SYS_SCTLR));
> > +
> >       reset_state = &target->vcpu.arch.reset_state;
> >       WRITE_ONCE(reset_state->pc, smccc_get_arg2(&hyp_vcpu->vcpu));
> >       WRITE_ONCE(reset_state->r0, smccc_get_arg3(&hyp_vcpu->vcpu));
> >
>
> I think it'd make more sense to have a global primitive that pKVM
> calls to synchronise whatever affects the control flow of a vcpu (yes,
> control flow for PSCI_ON is a bit abusive, but hey...). It's a bit
> more invasive, but at least we have a single spot to deal with this
> stuff, and it doesn't affect the hot path.
>
> Something like the hack below.

Yes, better to have it in a single spot. Will respin with that.

Cheers,
/fuad
