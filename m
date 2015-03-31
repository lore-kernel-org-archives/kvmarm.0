From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 01/25] arm: Use bool function return values of
 true/false not 1/0
Date: Tue, 31 Mar 2015 17:05:30 +0100
Message-ID: <20150331170530.0479b9ab@arm.com>
References: <cover.1427759009.git.joe@perches.com>
 <912ed0ebae3c6a16f58b1452d5ce9226681bc8df.1427759009.git.joe@perches.com>
 <551AC424.9010802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1E7B4A7E6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2015 11:58:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4GdUziAhNrOM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Mar 2015 11:58:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDF504A7E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2015 11:58:45 -0400 (EDT)
In-Reply-To: <551AC424.9010802@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Joe Perches <joe@perches.com>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 31 Mar 2015 16:58:28 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 31/03/2015 01:45, Joe Perches wrote:
> > Use the normal return values for bool functions
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  arch/arm/include/asm/dma-mapping.h |  8 ++++----
> >  arch/arm/include/asm/kvm_emulate.h |  2 +-
> >  arch/arm/mach-omap2/powerdomain.c  | 14 +++++++-------
> >  3 files changed, 12 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> > index b52101d..166e1e1 100644
> > --- a/arch/arm/include/asm/dma-mapping.h
> > +++ b/arch/arm/include/asm/dma-mapping.h
> > @@ -151,18 +151,18 @@ static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
> >  	u64 limit, mask;
> >  
> >  	if (!dev->dma_mask)
> > -		return 0;
> > +		return false;
> >  
> >  	mask = *dev->dma_mask;
> >  
> >  	limit = (mask + 1) & ~mask;
> >  	if (limit && size > limit)
> > -		return 0;
> > +		return false;
> >  
> >  	if ((addr | (addr + size - 1)) & ~mask)
> > -		return 0;
> > +		return false;
> >  
> > -	return 1;
> > +	return true;
> >  }
> >  
> >  static inline void dma_mark_clean(void *addr, size_t size) { }
> > diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
> > index a9c80a2..ad200a0 100644
> > --- a/arch/arm/include/asm/kvm_emulate.h
> > +++ b/arch/arm/include/asm/kvm_emulate.h
> > @@ -51,7 +51,7 @@ static inline void vcpu_set_hcr(struct kvm_vcpu *vcpu, unsigned long hcr)
> >  
> >  static inline bool vcpu_mode_is_32bit(struct kvm_vcpu *vcpu)
> >  {
> > -	return 1;
> > +	return true;
> >  }
> >  
> >  static inline unsigned long *vcpu_pc(struct kvm_vcpu *vcpu)
> > diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
> > index 78af6d8..897f9fb 100644
> > --- a/arch/arm/mach-omap2/powerdomain.c
> > +++ b/arch/arm/mach-omap2/powerdomain.c
> > @@ -950,7 +950,7 @@ int pwrdm_disable_hdwr_sar(struct powerdomain *pwrdm)
> >   */
> >  bool pwrdm_has_hdwr_sar(struct powerdomain *pwrdm)
> >  {
> > -	return (pwrdm && pwrdm->flags & PWRDM_HAS_HDWR_SAR) ? 1 : 0;
> > +	return pwrdm && (pwrdm->flags & PWRDM_HAS_HDWR_SAR);
> >  }
> >  
> >  int pwrdm_state_switch_nolock(struct powerdomain *pwrdm)
> > @@ -1185,24 +1185,24 @@ bool pwrdm_can_ever_lose_context(struct powerdomain *pwrdm)
> >  	if (!pwrdm) {
> >  		pr_debug("powerdomain: %s: invalid powerdomain pointer\n",
> >  			 __func__);
> > -		return 1;
> > +		return true;
> >  	}
> >  
> >  	if (pwrdm->pwrsts & PWRSTS_OFF)
> > -		return 1;
> > +		return true;
> >  
> >  	if (pwrdm->pwrsts & PWRSTS_RET) {
> >  		if (pwrdm->pwrsts_logic_ret & PWRSTS_OFF)
> > -			return 1;
> > +			return true;
> >  
> >  		for (i = 0; i < pwrdm->banks; i++)
> >  			if (pwrdm->pwrsts_mem_ret[i] & PWRSTS_OFF)
> > -				return 1;
> > +				return true;
> >  	}
> >  
> >  	for (i = 0; i < pwrdm->banks; i++)
> >  		if (pwrdm->pwrsts_mem_on[i] & PWRSTS_OFF)
> > -			return 1;
> > +			return true;
> >  
> > -	return 0;
> > +	return false;
> >  }
> > 
> 
> Marc/Christoffer, please pick this up yourself.

Given that it touches a range of completely unrelated files, for the
KVM part:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
