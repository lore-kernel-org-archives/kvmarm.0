Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBB433BBBA;
	Mon,  1 Jun 2026 19:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780341595; cv=none; b=kXcwya1XHs5TNqJ5ND7QgKgRVkjR1bRRl7/mcSEam3+dUOaC9nohV7k8jJctZpU+prL9dkY++rWxxWUNRVcNQoirDUmzhHU7S5r4ej+aUBYFX0ECaRaZvoJZ94v2MJRifm4Do+eqB9sKSlT3kA02DmczQwJUfnvAKWApAGQGaiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780341595; c=relaxed/simple;
	bh=u2Dst4+TBwICMq75KKlYdyt3C8VXJJomNVfFs2vidkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O7KrfruXTPDlpa7I6p2xpk9gChDhcqIeac2P9pS8QrOoliBsRGHQoHhESjXtuoNogt6stvf/Qjn/BkzkL2QtNdDu9tYHc6KDWGfIvsOESE948FPrz4Tm5H8XfIvkgs+aILaIbfXCaC1pD/HwgYahvQJ5KqN98zdyeUNhpxnZtXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CwF7GgVi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CwF7GgVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923771F0089B;
	Mon,  1 Jun 2026 19:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780341593;
	bh=NhFxldIBjPBUTua/YfxeMMHdCARnPekS5WZgGemC+8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CwF7GgViXVTYL1XEQ2gUlw926h25cBeIJxhIIw1viptMID57r7cX+f0DUXabsu03t
	 4BRMGy9VA/EfK7NbtHNvjQVSexU5wREpbHtorKHQ4zB+ZB3dxOdkXfBJPb2M38WeoB
	 es4OPC998fhMoOcv5Uk97ngxz5MPBtr/FyrlkP0vrkTX3lXcKtAFsY3X7Ypy8AxG8i
	 Jab/oU53bM1AZwe6qZHvszeaLbwE3wxPo+A1f6GZBPG6/hAZsXkorDD3A6k+ImBVPs
	 LH3n7Kv7N07piD1tddbkO76DNN+4NsHWnM0qG5pv1Crz+hAljaFYZRzmaiCes3H+g6
	 tig2fe2IztQ1g==
Date: Mon, 1 Jun 2026 12:19:52 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Flush HCR_EL2.VSE to deliver SErrors to pKVM
 guests
Message-ID: <ah3bWEOQUB27gMS3@kernel.org>
References: <20260531154548.1505799-1-tabba@google.com>
 <ah3agGh1s61HKiPG@kernel.org>
 <CA+EHjTyLWoM6_pSzC4bqN+EKpuAtDoKOZN39B0UMR_Va5Af_XQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyLWoM6_pSzC4bqN+EKpuAtDoKOZN39B0UMR_Va5Af_XQ@mail.gmail.com>

On Mon, Jun 01, 2026 at 08:17:18PM +0100, Fuad Tabba wrote:
> On Mon, 1 Jun 2026 at 20:16, Oliver Upton <oupton@kernel.org> wrote:
> >
> > On Sun, May 31, 2026 at 04:45:48PM +0100, tabba@google.com wrote:
> > > With pKVM enabled, the host injects a virtual SError by setting
> > > HCR_EL2.VSE on its vCPU copy, but flush_hyp_vcpu() only flows TWI/TWE
> > > into the hyp vCPU that runs, so VSE never reaches it and a deferred
> > > (masked) SError is never delivered. VSE is a host-owned injection
> > > control, not a trap-configuration bit, so restricting the host's
> > > trap-register values should not have dropped it. Flow it on entry;
> > > sync_hyp_vcpu() already copies hcr_el2 back, so delivery is reflected
> > > to the host.
> >
> > Might be worth mentioning that flush_hyp_vcpu() also forwards VSESR_EL2
> > from the host since that bit is _just_ out of context of this diff :)
> 
> Sure, would you like me to respin? Or would one of the maintainers
> kindly add that? :)

Marc is kindly dealing with the tree for the time being so hopefully
he can throw it in.

Thanks,
Oliver

> > > Fixes: b56680de9c648 ("KVM: arm64: Initialize trap register values in hyp in pKVM")
> > > Reported-by: Sashiko (local):gemini-3.1-pro
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> >
> > Reviewed-by: Oliver Upton <oupton@kernel.org>
> >
> > Thanks,
> > Oliver
> >
> > > ---
> > > Not an urgent fix. I should stop running Sashiko...
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > index 06db299c37a8..9e4a20df6409 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > @@ -129,9 +129,14 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> > >       hyp_vcpu->vcpu.arch.ctxt        = host_vcpu->arch.ctxt;
> > >
> > >       hyp_vcpu->vcpu.arch.mdcr_el2    = host_vcpu->arch.mdcr_el2;
> > > -     hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
> > > +     /*
> > > +      * HCR_EL2.VSE is host-owned (a pending virtual SError to inject), not a
> > > +      * trap-control bit, so it must flow to the hyp vCPU alongside TWI/TWE
> > > +      * for the vSError to be delivered. sync_hyp_vcpu() reflects it back.
> > > +      */
> > > +     hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE | HCR_VSE);
> > >       hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
> > > -                                              (HCR_TWI | HCR_TWE);
> > > +                                              (HCR_TWI | HCR_TWE | HCR_VSE);
> > >
> > >       hyp_vcpu->vcpu.arch.iflags      = host_vcpu->arch.iflags;
> > >
> > > --
> > > 2.54.0.929.g9b7fa37559-goog
> > >
