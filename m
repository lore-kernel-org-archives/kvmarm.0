From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 1/4] KVM: arm64: Rework detection of SVE, !VHE systems
Date: Thu, 8 Nov 2018 19:14:22 +0000
Message-ID: <20181108191421.GG3505@e103592.cambridge.arm.com>
References: <20181105143617.120602-1-marc.zyngier@arm.com>
 <20181105143617.120602-2-marc.zyngier@arm.com>
 <20181106075251.GE12057@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08AAA4A344
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Nov 2018 14:14:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y9Q0BFu3hHKG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Nov 2018 14:14:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBC4F4A328
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Nov 2018 14:14:26 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181106075251.GE12057@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 06, 2018 at 08:52:51AM +0100, Christoffer Dall wrote:
> On Mon, Nov 05, 2018 at 02:36:13PM +0000, Marc Zyngier wrote:
> > An SVE system is so far the only case where we mandate VHE. As we're
> > starting to grow this requirements, let's slightly rework the way we
> > deal with that situation, allowing for easy extension of this check.
> > 
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm/include/asm/kvm_host.h   |  2 +-
> >  arch/arm64/include/asm/kvm_host.h |  7 ++-----
> >  virt/kvm/arm/arm.c                | 12 +++++++-----
> >  3 files changed, 10 insertions(+), 11 deletions(-)
> > 

[...]

> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 52fbc823ff8c..ca1714148400 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -422,17 +422,14 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
> >  	}
> >  }
> >  
> > -static inline bool kvm_arch_check_sve_has_vhe(void)
> > +static inline bool kvm_arch_sve_requires_vhe(void)
> >  {
> >  	/*
> >  	 * The Arm architecture specifies that implementation of SVE
> >  	 * requires VHE also to be implemented.  The KVM code for arm64
> >  	 * relies on this when SVE is present:
> >  	 */
> > -	if (system_supports_sve())
> > -		return has_vhe();
> > -	else
> > -		return true;
> > +	return system_supports_sve();
> >  }
> 
> nit: Can we call this function 'kvm_arch_requires_vhe()' and let it test
> for all the cases (maybe that's coming in future patches though).  I
> just find this naming confusing.

Agreed.  I was never keen on my original name, and the logic was
somewhat backwards anyway.

"kvm_arch_requires_vhe()" is a reasonable name for a function that
returns true iff the kernel needs VHE as a consequence of some other
prior runtime decision.

> >  
> >  static inline void kvm_arch_hardware_unsetup(void) {}
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 23774970c9df..66de2efddfca 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -1640,9 +1640,13 @@ int kvm_arch_init(void *opaque)
> >  		return -ENODEV;
> >  	}
> >  
> > -	if (!kvm_arch_check_sve_has_vhe()) {
> > -		kvm_pr_unimpl("SVE system without VHE unsupported.  Broken cpu?");
> > -		return -ENODEV;
> > +	in_hyp_mode = is_kernel_in_hyp_mode();
> > +
> > +	if (!in_hyp_mode) {
> > +		if (kvm_arch_sve_requires_vhe()) {

Can we just have

	if (!in_hyp_mode && kvm_arch_requires_vhe()) {

That's less nesty but still readable (for me, at least).

Otherwise, Ack.


[...]

Cheers
---Dave
