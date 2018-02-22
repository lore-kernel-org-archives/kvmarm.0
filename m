From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 26/40] KVM: arm/arm64: Prepare to handle deferred
 save/restore of SPSR_EL1
Date: Thu, 22 Feb 2018 10:25:16 +0100
Message-ID: <20180222092516.GJ29376@cbox>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-27-christoffer.dall@linaro.org>
 <867er6l7qn.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <867er6l7qn.wl-marc.zyngier@arm.com>
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

On Wed, Feb 21, 2018 at 02:47:44PM +0000, Marc Zyngier wrote:
> On Thu, 15 Feb 2018 21:03:18 +0000,
> Christoffer Dall wrote:
> > 
> > SPSR_EL1 is not used by a VHE host kernel and can be deferred, but we
> > need to rework the accesses to this register to access the latest value
> > depending on whether or not guest system registers are loaded on the CPU
> > or only reside in memory.
> > 
> > The handling of accessing the various banked SPSRs for 32-bit VMs is a
> > bit clunky, but this will be improved in following patches which will
> > first prepare and subsequently implement deferred save/restore of the
> > 32-bit registers, including the 32-bit SPSRs.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> > 
> > Notes:
> >     Changes since v2:
> >      - New patch (deferred register handling has been reworked)
> > 
> >  arch/arm/include/asm/kvm_emulate.h   | 12 ++++++++++-
> >  arch/arm/kvm/emulate.c               |  2 +-
> >  arch/arm64/include/asm/kvm_emulate.h | 41 +++++++++++++++++++++++++++++++-----
> >  arch/arm64/kvm/inject_fault.c        |  4 ++--
> >  virt/kvm/arm/aarch32.c               |  2 +-
> >  5 files changed, 51 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
> > index e27caa4b47a1..6493bd479ddc 100644
> > --- a/arch/arm/include/asm/kvm_emulate.h
> > +++ b/arch/arm/include/asm/kvm_emulate.h
> > @@ -41,7 +41,17 @@ static inline unsigned long *vcpu_reg32(struct kvm_vcpu *vcpu, u8 reg_num)
> >  	return vcpu_reg(vcpu, reg_num);
> >  }
> >  
> > -unsigned long *vcpu_spsr(struct kvm_vcpu *vcpu);
> > +unsigned long *__vcpu_spsr(struct kvm_vcpu *vcpu);
> > +
> > +static inline unsigned long vpcu_read_spsr(struct kvm_vcpu *vcpu)
> > +{
> > +	return *__vcpu_spsr(vcpu);
> > +}
> > +
> > +static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
> > +{
> > +	*__vcpu_spsr(vcpu) = v;
> > +}
> >  
> >  static inline unsigned long vcpu_get_reg(struct kvm_vcpu *vcpu,
> >  					 u8 reg_num)
> > diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
> > index fa501bf437f3..9046b53d87c1 100644
> > --- a/arch/arm/kvm/emulate.c
> > +++ b/arch/arm/kvm/emulate.c
> > @@ -142,7 +142,7 @@ unsigned long *vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num)
> >  /*
> >   * Return the SPSR for the current mode of the virtual CPU.
> >   */
> > -unsigned long *vcpu_spsr(struct kvm_vcpu *vcpu)
> > +unsigned long *__vcpu_spsr(struct kvm_vcpu *vcpu)
> >  {
> >  	unsigned long mode = *vcpu_cpsr(vcpu) & MODE_MASK;
> >  	switch (mode) {
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index d313aaae5c38..47c2406755fa 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -26,6 +26,7 @@
> >  
> >  #include <asm/esr.h>
> >  #include <asm/kvm_arm.h>
> > +#include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmio.h>
> >  #include <asm/ptrace.h>
> >  #include <asm/cputype.h>
> > @@ -143,13 +144,43 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
> >  		vcpu_gp_regs(vcpu)->regs.regs[reg_num] = val;
> >  }
> >  
> > -/* Get vcpu SPSR for current mode */
> > -static inline unsigned long *vcpu_spsr(const struct kvm_vcpu *vcpu)
> > +static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
> >  {
> > -	if (vcpu_mode_is_32bit(vcpu))
> > -		return vcpu_spsr32(vcpu);
> > +	unsigned long *p = (unsigned long *)&vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
> > +
> > +	if (vcpu_mode_is_32bit(vcpu)) {
> > +		unsigned long *p_32bit = vcpu_spsr32(vcpu);
> > +
> > +		/* KVM_SPSR_SVC aliases KVM_SPSR_EL1 */
> > +		if (p_32bit != (unsigned long *)p)
> > +			return *p_32bit;
> 
> Clunky, you said? ;-) p is already an unsigned long *, so there's no
> need to cast it.
> 

Right, I think this is a leftover from some attempts at making this less
terrible, but this was eventually the least terrible.  Believe it or
not.

> > +	}
> > +
> > +	if (vcpu->arch.sysregs_loaded_on_cpu)
> > +		return read_sysreg_el1(spsr);
> > +	else
> > +		return *p;
> > +}
> >  
> > -	return (unsigned long *)&vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
> > +static inline void vcpu_write_spsr(const struct kvm_vcpu *vcpu, unsigned long v)
> > +{
> > +	unsigned long *p = (unsigned long *)&vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
> > +
> > +	/* KVM_SPSR_SVC aliases KVM_SPSR_EL1 */
> > +	if (vcpu_mode_is_32bit(vcpu)) {
> > +		unsigned long *p_32bit = vcpu_spsr32(vcpu);
> > +
> > +		/* KVM_SPSR_SVC aliases KVM_SPSR_EL1 */
> > +		if (p_32bit != (unsigned long *)p) {
> > +			*p_32bit = v;
> > +			return;
> 
> Same remark.
> 
> > +		}
> > +	}
> > +
> > +	if (vcpu->arch.sysregs_loaded_on_cpu)
> > +		write_sysreg_el1(v, spsr);
> > +	else
> > +		*p = v;
> >  }
> >  
> >  static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
> > diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> > index e08db2f2dd75..8dda1edae727 100644
> > --- a/arch/arm64/kvm/inject_fault.c
> > +++ b/arch/arm64/kvm/inject_fault.c
> > @@ -71,7 +71,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
> >  	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
> >  
> >  	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
> > -	*vcpu_spsr(vcpu) = cpsr;
> > +	vcpu_write_spsr(vcpu, cpsr);
> >  
> >  	vcpu_write_sys_reg(vcpu, FAR_EL1, addr);
> >  
> > @@ -106,7 +106,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
> >  	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
> >  
> >  	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
> > -	*vcpu_spsr(vcpu) = cpsr;
> > +	vcpu_write_spsr(vcpu, cpsr);
> >  
> >  	/*
> >  	 * Build an unknown exception, depending on the instruction
> > diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
> > index 8bc479fa37e6..efc84cbe8277 100644
> > --- a/virt/kvm/arm/aarch32.c
> > +++ b/virt/kvm/arm/aarch32.c
> > @@ -178,7 +178,7 @@ static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
> >  	*vcpu_cpsr(vcpu) = cpsr;
> >  
> >  	/* Note: These now point to the banked copies */
> > -	*vcpu_spsr(vcpu) = new_spsr_value;
> > +	vcpu_write_spsr(vcpu, new_spsr_value);
> >  	*vcpu_reg32(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
> >  
> >  	/* Branch to exception vector */
> > -- 
> > 2.14.2
> > 
> 
> Otherwise:
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> 	M.
> 
Thanks, I'll fix the above.
-Christoffer
