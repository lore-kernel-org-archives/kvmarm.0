Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE85222562
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 09:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762768118; cv=none; b=r0Poig980PpBMhyCtriaQAKx8+3DpWzFipyFk3hsFYCGPoM9RiO0d16/ZLFocy9AoBaQpMveeY04gg3QcezuMvCyeaPed5hm6y8lKd5CHPfV0pOvPJZQgo0w24JN/FDMM9ZaBmIAH7jw5Vhg05wkKJVvWQCMtxohYzd4+SIMRSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762768118; c=relaxed/simple;
	bh=uiycPl7Dut5gfeg4yUbnZ+b+uMj6Md5jFkgp82SdrPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WiRB98rXVcCw8njX0oqJ10A/IQBYJSmz7QDemYDMqc0ZpHcxuEVsc577B3yVMgdUeCU0VsVgpslaYkjEXWSd6DdbXzidR6fH4D8GizL9d+vy3SB+gigiDeI2sxnnXwdvUm/pEJKAgcnORntRzpH/qGmA7GeW+ujvm4HwFBK7J0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cCMy8bqX; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cCMy8bqX"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762768112; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=2z4dGI6pY2qYULVKlOheBpEWKW9LxPbnHe465RmS/ko=;
	b=cCMy8bqXiVsxdbqkEE3mfIbW0vnxVZi/s7ZUWXKFdcIzov0JG8jzKnO3Nffen7lf742w7M7AZfgz70VEiIMaB68UG2JgtiBPcNogoDGUiK2vIQ40dqL7MiLuF+w26EJn4/xzZn0leh/jYEIGETWKfr8vk2Jv+nTGUssp+bz+vZs=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0Ws1o7uu_1762768111 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 10 Nov 2025 17:48:32 +0800
Date: Mon, 10 Nov 2025 17:48:31 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: Re: [PATCH v2 12/45] KVM: arm64: GICv3: Extract LR folding primitive
Message-ID: <kjr4rlg6wajbv6f2dggydbjusslqomtreu5x7ugdrvaqmk7hwb@igganp2dw7go>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-13-maz@kernel.org>
 <3tb7ekdzl5f4rs24bla63vw22awejhbn7ngvttid7v7bzaer2m@62bxshf7uj34>
 <868qgeutxm.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868qgeutxm.wl-maz@kernel.org>

On Mon, Nov 10, 2025 at 09:18:45AM +0800, Marc Zyngier wrote:
> On Mon, 10 Nov 2025 09:01:21 +0000,
> Yao Yuan <yaoyuan@linux.alibaba.com> wrote:
> >
> > On Sun, Nov 09, 2025 at 05:15:46PM +0800, Marc Zyngier wrote:
> > > As we are going to need to handle deactivation for interrupts that
> > > are not in the LRs, split vgic_v3_fold_lr_state() into a helper
> > > that deals with a single interrupt, and the function that loops
> > > over the used LRs.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/vgic/vgic-v3.c | 88 +++++++++++++++++------------------
> > >  1 file changed, 43 insertions(+), 45 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > > index 3ede79e381513..0fccfe9e3e8dd 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > > @@ -33,78 +33,76 @@ static bool lr_signals_eoi_mi(u64 lr_val)
> > >  	       !(lr_val & ICH_LR_HW);
> > >  }
> > >
> > > -void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> > > +static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 val)
> > >  {
> > > -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> > > -	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
> > > -	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> > > -	int lr;
> > > -
> > > -	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
> > > -
> > > -	cpuif->vgic_hcr &= ~ICH_HCR_EL2_UIE;
> > > -
> > > -	for (lr = 0; lr < cpuif->used_lrs; lr++) {
> > > -		u64 val = cpuif->vgic_lr[lr];
> > > -		u32 intid, cpuid;
> > > -		struct vgic_irq *irq;
> > > -		bool is_v2_sgi = false;
> > > -		bool deactivated;
> > > -
> > > -		cpuid = val & GICH_LR_PHYSID_CPUID;
> > > -		cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
> > > -
> > > -		if (model == KVM_DEV_TYPE_ARM_VGIC_V3) {
> > > -			intid = val & ICH_LR_VIRTUAL_ID_MASK;
> > > -		} else {
> > > -			intid = val & GICH_LR_VIRTUALID;
> > > -			is_v2_sgi = vgic_irq_is_sgi(intid);
> > > -		}
> > > +	struct vgic_irq *irq;
> > > +	bool is_v2_sgi = false;
> > > +	bool deactivated;
> > > +	u32 intid;
> > >
> > > -		/* Notify fds when the guest EOI'ed a level-triggered IRQ */
> > > -		if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
> > > -			kvm_notify_acked_irq(vcpu->kvm, 0,
> > > -					     intid - VGIC_NR_PRIVATE_IRQS);
> > > +	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
> > > +		intid = val & ICH_LR_VIRTUAL_ID_MASK;
> > > +	} else {
> > > +		intid = val & GICH_LR_VIRTUALID;
> > > +		is_v2_sgi = vgic_irq_is_sgi(intid);
> > > +	}
> > >
> > > -		irq = vgic_get_vcpu_irq(vcpu, intid);
> > > -		if (!irq)	/* An LPI could have been unmapped. */
> > > -			continue;
> > > +	irq = vgic_get_vcpu_irq(vcpu, intid);
> > > +	if (!irq)	/* An LPI could have been unmapped. */
> > > +		return;
> > >
> > > -		raw_spin_lock(&irq->irq_lock);
> > > +	/* Notify fds when the guest EOI'ed a level-triggered IRQ */
> > > +	if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
> > > +		kvm_notify_acked_irq(vcpu->kvm, 0,
> > > +				     intid - VGIC_NR_PRIVATE_IRQS);
> >
> > The fds notifiy happens before checking irq's mapping before
> > this patch, and now in reversal order w/ above change. It's
> > fine for vLPI, and for vSPI no necessary call
> > kvm_notify_acked_irq() if the it has been remapped, no

Oops.. I want to say "and for vSPI no necessary call
kvm_notify_acked_irq() if it has been unmapped...".

> > gsi<->pin mapping there. Is above understanding correct ?
>
> We can only notify an irqfd for an SPI, never for an LPI. Given that

> only looking up an LPI can result in a NULL pointer (if it has been
> concurrently removed), this change is immaterial

You're right. The spis is allocated in vgic_init().

>
> This results in something that is easier to understand, as I find it
> more logical to weed out the error cases first before taking any
> significant action.

Yes, this makes the code better than beforem and thanks for your explanation!

>
> Thanks,
>
> 	M.
>
> --
> Without deviation from the norm, progress is not possible.
