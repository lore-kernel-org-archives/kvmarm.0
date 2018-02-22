From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 34/40] KVM: arm64: Cleanup __activate_traps and
 __deactive_traps for VHE and non-VHE
Date: Thu, 22 Feb 2018 20:04:03 +0100
Message-ID: <20180222190403.GX29376@cbox>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-35-christoffer.dall@linaro.org>
 <86vaeqjj1c.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <86vaeqjj1c.wl-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Tomasz Nowicki <tn@semihalf.com>, kvmarm@lists.cs.columbia.edu, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 21, 2018 at 06:26:39PM +0000, Marc Zyngier wrote:
> On Thu, 15 Feb 2018 21:03:26 +0000,
> Christoffer Dall wrote:
> > 
> > To make the code more readable and to avoid the overhead of a function
> > call, let's get rid of a pair of the alternative function selectors and
> > explicitly call the VHE and non-VHE functions using the has_vhe() static
> > key based selector instead, telling the compiler to try to inline the
> > static function if it can.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/kvm/hyp/switch.c | 30 ++++++++++++++----------------
> >  1 file changed, 14 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 5e94955b89ea..0e54fe2aab1c 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -85,7 +85,7 @@ static void __hyp_text __deactivate_traps_common(void)
> >  	write_sysreg(0, pmuserenr_el0);
> >  }
> >  
> > -static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
> > +static inline void activate_traps_vhe(struct kvm_vcpu *vcpu)
> >  {
> >  	u64 val;
> >  
> > @@ -97,7 +97,7 @@ static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
> >  	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
> >  }
> >  
> > -static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
> > +static inline void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
> 
> Having both inline and __hyp_text does not make much sense (the
> function will be emitted in the section defined by the caller).

Is that true even if the function is not inlined?

> I
> suggest you drop the inline and let the compiler do its magic.
> 

We were using an older compiler (I believe GCC 4.8) when doing some of
the initial experiements, and saw that some of these small functions
weren't inlined without the inline hint.  However, this doesn't seem to
be an issue on any of the compilers I'm using today.  So I'll remove
the inline.

Thanks,
-Christoffer

> >  {
> >  	u64 val;
> >  
> > @@ -108,11 +108,7 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
> >  	write_sysreg(val, cptr_el2);
> >  }
> >  
> > -static hyp_alternate_select(__activate_traps_arch,
> > -			    __activate_traps_nvhe, __activate_traps_vhe,
> > -			    ARM64_HAS_VIRT_HOST_EXTN);
> > -
> > -static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
> > +static inline void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
> 
> Same here, and in other spots in this file.
> 
> >  {
> >  	u64 hcr = vcpu->arch.hcr_el2;
> >  
> > @@ -122,10 +118,13 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
> >  		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
> >  
> >  	__activate_traps_fpsimd32(vcpu);
> > -	__activate_traps_arch()(vcpu);
> > +	if (has_vhe())
> > +		activate_traps_vhe(vcpu);
> > +	else
> > +		__activate_traps_nvhe(vcpu);
> >  }
> >  
> > -static void __hyp_text __deactivate_traps_vhe(void)
> > +static inline void deactivate_traps_vhe(void)
> >  {
> >  	extern char vectors[];	/* kernel exception vectors */
> >  	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
> > @@ -133,7 +132,7 @@ static void __hyp_text __deactivate_traps_vhe(void)
> >  	write_sysreg(vectors, vbar_el1);
> >  }
> >  
> > -static void __hyp_text __deactivate_traps_nvhe(void)
> > +static inline void __hyp_text __deactivate_traps_nvhe(void)
> >  {
> >  	u64 mdcr_el2 = read_sysreg(mdcr_el2);
> >  
> > @@ -147,11 +146,7 @@ static void __hyp_text __deactivate_traps_nvhe(void)
> >  	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
> >  }
> >  
> > -static hyp_alternate_select(__deactivate_traps_arch,
> > -			    __deactivate_traps_nvhe, __deactivate_traps_vhe,
> > -			    ARM64_HAS_VIRT_HOST_EXTN);
> > -
> > -static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
> > +static inline void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
> >  {
> >  	/*
> >  	 * If we pended a virtual abort, preserve it until it gets
> > @@ -162,7 +157,10 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
> >  	if (vcpu->arch.hcr_el2 & HCR_VSE)
> >  		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
> >  
> > -	__deactivate_traps_arch()();
> > +	if (has_vhe())
> > +		deactivate_traps_vhe();
> > +	else
> > +		__deactivate_traps_nvhe();
> >  }
> >  
> >  void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
> > -- 
> > 2.14.2
> > 
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Jazz is not dead, it just smell funny.
