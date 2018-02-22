From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 33/40] KVM: arm64: Configure c15, PMU, and debug
 register traps on cpu load/put for VHE
Date: Thu, 22 Feb 2018 19:57:13 +0100
Message-ID: <20180222185713.GW29376@cbox>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-34-christoffer.dall@linaro.org>
 <86woz6jjax.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <86woz6jjax.wl-marc.zyngier@arm.com>
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

On Wed, Feb 21, 2018 at 06:20:54PM +0000, Marc Zyngier wrote:
> On Thu, 15 Feb 2018 21:03:25 +0000,
> Christoffer Dall wrote:
> > 
> > We do not have to change the c15 trap setting on each switch to/from the
> > guest on VHE systems, because this setting only affects EL0.
> 
> Did you mean EL1 instead?
> 

Not sure what I meant, but HSTR_EL2 appears to affect EL1 and EL0, and
the PMU configuration we can do on vcpu_load on VHE systems is only
about EL0 as far as I can tell.

> > 
> > The PMU and debug trap configuration can also be done on vcpu load/put
> > instead, because they don't affect how the host kernel can access the
> > debug registers while executing KVM kernel code.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/include/asm/kvm_hyp.h |  3 +++
> >  arch/arm64/kvm/hyp/switch.c      | 31 ++++++++++++++++++++++---------
> >  arch/arm64/kvm/hyp/sysreg-sr.c   |  4 ++++
> >  3 files changed, 29 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > index 2b1fda90dde4..949f2e77ae58 100644
> > --- a/arch/arm64/include/asm/kvm_hyp.h
> > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > @@ -147,6 +147,9 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
> >  void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
> >  bool __fpsimd_enabled(void);
> >  
> > +void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
> > +void deactivate_traps_vhe_put(void);
> > +
> >  u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
> >  void __noreturn __hyp_do_panic(unsigned long, ...);
> >  
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 9c40e203bd09..5e94955b89ea 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -101,6 +101,8 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
> >  {
> >  	u64 val;
> >  
> > +	__activate_traps_common(vcpu);
> > +
> >  	val = CPTR_EL2_DEFAULT;
> >  	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
> >  	write_sysreg(val, cptr_el2);
> > @@ -120,20 +122,12 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
> >  		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
> >  
> >  	__activate_traps_fpsimd32(vcpu);
> > -	__activate_traps_common(vcpu);
> >  	__activate_traps_arch()(vcpu);
> >  }
> >  
> >  static void __hyp_text __deactivate_traps_vhe(void)
> >  {
> >  	extern char vectors[];	/* kernel exception vectors */
> > -	u64 mdcr_el2 = read_sysreg(mdcr_el2);
> > -
> > -	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
> > -		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
> > -		    MDCR_EL2_TPMS;
> > -
> > -	write_sysreg(mdcr_el2, mdcr_el2);
> >  	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
> >  	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
> >  	write_sysreg(vectors, vbar_el1);
> > @@ -143,6 +137,8 @@ static void __hyp_text __deactivate_traps_nvhe(void)
> >  {
> >  	u64 mdcr_el2 = read_sysreg(mdcr_el2);
> >  
> > +	__deactivate_traps_common();
> > +
> >  	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
> >  	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
> >  
> > @@ -166,10 +162,27 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
> >  	if (vcpu->arch.hcr_el2 & HCR_VSE)
> >  		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
> >  
> > -	__deactivate_traps_common();
> >  	__deactivate_traps_arch()();
> >  }
> >  
> > +void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
> > +{
> > +	__activate_traps_common(vcpu);
> > +}
> > +
> > +void deactivate_traps_vhe_put(void)
> > +{
> > +	u64 mdcr_el2 = read_sysreg(mdcr_el2);
> > +
> > +	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
> > +		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
> > +		    MDCR_EL2_TPMS;
> > +
> > +	write_sysreg(mdcr_el2, mdcr_el2);
> > +
> > +	__deactivate_traps_common();
> > +}
> > +
> >  static void __hyp_text __activate_vm(struct kvm *kvm)
> >  {
> >  	write_sysreg(kvm->arch.vttbr, vttbr_el2);
> > diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> > index aacba4636871..b3894df6bf1a 100644
> > --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> > +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> > @@ -254,6 +254,8 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
> >  	__sysreg_restore_el1_state(guest_ctxt);
> >  
> >  	vcpu->arch.sysregs_loaded_on_cpu = true;
> > +
> > +	activate_traps_vhe_load(vcpu);
> >  }
> >  
> >  /**
> > @@ -275,6 +277,8 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
> >  	if (!has_vhe())
> >  		return;
> >  
> > +	deactivate_traps_vhe_put();
> > +
> >  	__sysreg_save_el1_state(guest_ctxt);
> >  	__sysreg_save_user_state(guest_ctxt);
> >  	__sysreg32_save_state(vcpu);
> > -- 
> > 2.14.2
> > 
> 
> I must admit that I find these two layers of trap configuration mildly
> confusing. I can see why it is done like this (there is hardly any
> other way), but still...

Perhaps the naming could be improved.

Right now we have:

_traps_common:        Same code for non-VHE/VHE.  Called:
                         non-VHE: on every switch.
		         VHE: on load/put.
_traps:               Same code for non-VHE/VHE.  Called:
                         VHE/non-VHE: On every switch.
_traps_nvhe:          Code specific to non-VHE system.  Called:
                         non-VHE: on every switch
_traps_vhe:           Code specific to VHE system.  Called:
                         VHE: on every switch
_traps_vhe_load/put:  Code  specific to VHE system.  Called:
                         VHE: on vcpu load/put

We could simplify this at the cost of code duplication to:

_traps_nvhe
_traps_vhe
_traps_vhe_load/put

Thoughts?

> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 

Thanks,
-Christoffer
