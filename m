Received: from out-44.mta1.migadu.com (out-44.mta1.migadu.com [95.215.58.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7415CBC
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 07:27:00 +0000 (UTC)
Date: Tue, 11 Jul 2023 00:26:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689060418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UZp+2dSUEdVCGGRFW1CPgFgXy+OUgRsqZUY67+xIuoA=;
	b=IoJHyLrdKEvp3/n87qPkewUxJZx5PmiS93d6sM8sNVq28MEu3v9UVVAf4Qd3eoEtm9kv3W
	rcCsiZDFf8ZDIyBsRso/hirLqUoc/PqVFijscWB9UGlE0b9Knrsw6npNKTg0K3MN4cxVAk
	g9ObaTowV2qxOfvr8tiYW311P8Pjm1I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org,
	Xiang Chen <chenxiang66@hisilicon.com>
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Consistently request doorbell irq
 for blocking vCPU
Message-ID: <ZK0EPhvLzhaFepGk@linux.dev>
References: <20230710175553.1477762-1-oliver.upton@linux.dev>
 <86jzv6x66q.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86jzv6x66q.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 11, 2023 at 08:23:25AM +0100, Marc Zyngier wrote:
> On Mon, 10 Jul 2023 18:55:53 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Xiang reports that VMs occasionally fail to boot on GICv4.1 systems when
> > running a preemptible kernel, as it is possible that a vCPU is blocked
> > without requesting a doorbell interrupt.
> > 
> > The issue is that any preemption that occurs between vgic_v4_put() and
> > schedule() on the block path will mark the vPE as nonresident and *not*
> > request a doorbell irq.
> 
> It'd be worth spelling out. You need to go via *three* schedule()
> calls: one to be preempted (with DB set), one to be made resident
> again, and then the final one in kvm_vcpu_halt(), clearing the DB on
> vcpu_put() due to the bug.

Yeah, a bit lazy in the wording. What I had meant to imply was
preemption happening after the doorbell is set up and before the thread
has an opportunity to explicitly schedule out. Perhaps I should just say
that.

> > 
> > Fix it by consistently requesting a doorbell irq in the vcpu put path if
> > the vCPU is blocking. While this technically means we could drop the
> > early doorbell irq request in kvm_vcpu_wfi(), deliberately leave it
> > intact such that vCPU halt polling can properly detect the wakeup
> > condition before actually scheduling out a vCPU.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 8e01d9a396e6 ("KVM: arm64: vgic-v4: Move the GICv4 residency flow to be driven by vcpu_load/put")
> > Reported-by: Xiang Chen <chenxiang66@hisilicon.com>
> > Tested-by: Xiang Chen <chenxiang66@hisilicon.com>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/vgic/vgic-v3.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > index c3b8e132d599..8c467e9f4f11 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -749,7 +749,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> >  
> > -	WARN_ON(vgic_v4_put(vcpu, false));
> > +	WARN_ON(vgic_v4_put(vcpu, kvm_vcpu_is_blocking(vcpu)));
> >  
> >  	vgic_v3_vmcr_sync(vcpu);
> >  
> 
> Other than the above nitpicking, this looks good. Thanks both for the
> very detailed report and the fix.
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>

Thanks!

--
Best,
Oliver
