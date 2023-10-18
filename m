Received: from out-201.mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108308BEB
	for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 07:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WAge37IE"
Date: Wed, 18 Oct 2023 07:05:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697612706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TPkWzURlXqNO3Jdfyg8dZtOx24VKCQt6HkN8xUCCTA0=;
	b=WAge37IEZTIiqaajtmbd5vjDKip/5NIyfNRuDmAXbMn+G2QEaKbcy1XxndmPkW+qUQpoXt
	qGD3yoZlosu00eu6xWbmZReIjTMh0ogYfR3sLkoMEwpeifp3goLFV2fzJPI8doqrqbrjZH
	IkNWVs0NYmoVPJQELeewveYdUBQpshs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2 2/5] KVM: arm64: Restore the stage-2 context in VHE's
 __tlb_switch_to_host()
Message-ID: <ZS-DnsM4JFXZ7a_H@linux.dev>
References: <20231012205422.3924618-1-oliver.upton@linux.dev>
 <20231012205422.3924618-3-oliver.upton@linux.dev>
 <5563bffd-0b27-ac95-9e87-24f5b8c71fb7@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5563bffd-0b27-ac95-9e87-24f5b8c71fb7@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 18, 2023 at 03:00:42PM +0800, Zenghui Yu wrote:
> On 2023/10/13 4:54, Oliver Upton wrote:
> > From: Marc Zyngier <maz@kernel.org>
> > 
> > An MMU notifier could cause us to clobber the stage-2 context loaded on
> > a CPU when we switch to another VM's context to invalidate. This isn't
> > an issue right now as the stage-2 context gets reloaded on every guest
> > entry, but is disastrous when moving __load_stage2() into the
> > vcpu_load() path.
> > 
> > Restore the previous stage-2 context on the way out of a TLB
> > invalidation if we installed something else. Deliberately do this after
> > TGE=1 is synchronized to keep things safe in light of the speculative AT
> > errata.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/vhe/tlb.c | 17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
> > index f3f2e142e4f4..ef21153ce5fa 100644
> > --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> > +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
> > @@ -11,18 +11,25 @@
> >  #include <asm/tlbflush.h>
> >  struct tlb_inv_context {
> > -	unsigned long	flags;
> > -	u64		tcr;
> > -	u64		sctlr;
> > +	struct kvm_s2_mmu	*mmu;
> > +	unsigned long		flags;
> > +	u64			tcr;
> > +	u64			sctlr;
> >  };
> >  static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
> >  				  struct tlb_inv_context *cxt)
> >  {
> > +	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> >  	u64 val;
> >  	local_irq_save(cxt->flags);
> > +	if (vcpu && mmu != vcpu->arch.hw_mmu)
> > +		cxt->mmu = mmu;
> 
> Shouldn't this be
> 
> cxt->mm = vcpu->arch.hw_mmu (the "previous" S2 context)?

It absolutely should, and Marc had it right the first time.

-- 
Thanks,
Oliver
