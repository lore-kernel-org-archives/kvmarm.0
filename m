From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 28/40] KVM: arm64: Defer saving/restoring 64-bit
 sysregs to vcpu load/put on VHE
Date: Fri, 23 Feb 2018 19:05:12 +0100
Message-ID: <20180223180512.GE7396@cbox>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-29-christoffer.dall@linaro.org>
 <864lmal5lw.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <864lmal5lw.wl-marc.zyngier@arm.com>
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

On Wed, Feb 21, 2018 at 03:33:47PM +0000, Marc Zyngier wrote:
> On Thu, 15 Feb 2018 21:03:20 +0000,
> Christoffer Dall wrote:
> > 
> > Some system registers do not affect the host kernel's execution and can
> > therefore be loaded when we are about to run a VCPU and we don't have to
> > restore the host state to the hardware before the time when we are
> > actually about to return to userspace or schedule out the VCPU thread.
> > 
> > The EL1 system registers and the userspace state registers only
> > affecting EL0 execution do not need to be saved and restored on every
> > switch between the VM and the host, because they don't affect the host
> > kernel's execution.
> > 
> > We mark all registers which are now deffered as such in the
> > vcpu_{read,write}_sys_reg accessors in sys-regs.c to ensure the most
> > up-to-date copy is always accessed.
> > 
> > Note MPIDR_EL1 (controlled via VMPIDR_EL2) is accessed from other vcpu
> > threads, for example via the GIC emulation, and therefore must be
> > declared as immediate, which is fine as the guest cannot modify this
> > value.
> > 
> > The 32-bit sysregs can also be deferred but we do this in a separate
> > patch as it requires a bit more infrastructure.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> > 
> > Notes:
> >     Changes since v3:
> >      - Changed to switch-based sysreg approach
> > 
> >  arch/arm64/kvm/hyp/sysreg-sr.c | 39 +++++++++++++++++++++++++++++++--------
> >  arch/arm64/kvm/sys_regs.c      | 40 ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 71 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> > index 906606dc4e2c..9c60b8062724 100644
> > --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> > +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> > @@ -25,8 +25,12 @@
> >  /*
> >   * Non-VHE: Both host and guest must save everything.
> >   *
> > - * VHE: Host must save tpidr*_el0, mdscr_el1, sp_el0,
> > - * and guest must save everything.
> > + * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and pstate,
> > + * which are handled as part of the el2 return state) on every switch.
> > + * tpidr_el0 and tpidrro_el0 only need to be switched when going
> 
> How about suspend/resume, which saves/restores both of these EL0
> registers (see cpu_do_suspend)? We may not need to do anything (either
> because vcpu_put will have happened, or because we'll come back
> exactly where we were), but I'd like to make sure this hasn't been
> overlooked.
> 

Interesting question.

AFAICT, cpu_do_suspend preserves the values in these registers, which
means it will either preserve the guest's or user space's values,
depending on when cpu_do_suspend is called.  It will be the former if
cpu_do_suspend is called in between vcpu_load and vcpu_put (from
interrupt context, for example), and it will be the latter if called
after the thread goes to sleep for example.

I can't see how suspend can break this.  Am I missing something?

> > + * to host userspace or a different VCPU.  EL1 registers only need to be
> > + * switched when potentially going to run a different VCPU.  The latter two
> > + * classes are handled as part of kvm_arch_vcpu_load and kvm_arch_vcpu_put.
> >   */
> >  
> >  static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
> > @@ -93,14 +97,11 @@ void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
> >  void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
> >  {
> >  	__sysreg_save_common_state(ctxt);
> > -	__sysreg_save_user_state(ctxt);
> >  }
> >  
> >  void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
> >  {
> > -	__sysreg_save_el1_state(ctxt);
> >  	__sysreg_save_common_state(ctxt);
> > -	__sysreg_save_user_state(ctxt);
> >  	__sysreg_save_el2_return_state(ctxt);
> >  }
> >  
> > @@ -169,14 +170,11 @@ void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
> >  void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
> >  {
> >  	__sysreg_restore_common_state(ctxt);
> > -	__sysreg_restore_user_state(ctxt);
> >  }
> >  
> >  void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
> >  {
> > -	__sysreg_restore_el1_state(ctxt);
> >  	__sysreg_restore_common_state(ctxt);
> > -	__sysreg_restore_user_state(ctxt);
> >  	__sysreg_restore_el2_return_state(ctxt);
> >  }
> >  
> > @@ -240,6 +238,18 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
> >   */
> >  void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
> >  {
> > +	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
> > +	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
> > +
> > +	if (!has_vhe())
> > +		return;
> > +
> > +	__sysreg_save_user_state(host_ctxt);
> > +
> > +	__sysreg_restore_user_state(guest_ctxt);
> > +	__sysreg_restore_el1_state(guest_ctxt);
> > +
> > +	vcpu->arch.sysregs_loaded_on_cpu = true;
> >  }
> >  
> >  /**
> > @@ -255,6 +265,19 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
> >   */
> >  void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
> >  {
> > +	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
> > +	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
> > +
> > +	if (!has_vhe())
> > +		return;
> > +
> > +	__sysreg_save_el1_state(guest_ctxt);
> > +	__sysreg_save_user_state(guest_ctxt);
> > +
> > +	/* Restore host user state */
> > +	__sysreg_restore_user_state(host_ctxt);
> > +
> > +	vcpu->arch.sysregs_loaded_on_cpu = false;
> >  }
> >  
> >  void __hyp_text __kvm_set_tpidr_el2(u64 tpidr_el2)
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index b3c3f014aa61..f060309337aa 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -87,6 +87,26 @@ u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg)
> >  	 * exit from the guest but are only saved on vcpu_put.
> >  	 */
> >  	switch (reg) {
> > +	case CSSELR_EL1:	return read_sysreg_s(SYS_CSSELR_EL1);
> > +	case SCTLR_EL1:		return read_sysreg_s(sctlr_EL12);
> > +	case ACTLR_EL1:		return read_sysreg_s(SYS_ACTLR_EL1);
> > +	case CPACR_EL1:		return read_sysreg_s(cpacr_EL12);
> > +	case TTBR0_EL1:		return read_sysreg_s(ttbr0_EL12);
> > +	case TTBR1_EL1:		return read_sysreg_s(ttbr1_EL12);
> > +	case TCR_EL1:		return read_sysreg_s(tcr_EL12);
> > +	case ESR_EL1:		return read_sysreg_s(esr_EL12);
> > +	case AFSR0_EL1:		return read_sysreg_s(afsr0_EL12);
> > +	case AFSR1_EL1:		return read_sysreg_s(afsr1_EL12);
> > +	case FAR_EL1:		return read_sysreg_s(far_EL12);
> > +	case MAIR_EL1:		return read_sysreg_s(mair_EL12);
> > +	case VBAR_EL1:		return read_sysreg_s(vbar_EL12);
> > +	case CONTEXTIDR_EL1:	return read_sysreg_s(contextidr_EL12);
> > +	case TPIDR_EL0:		return read_sysreg_s(SYS_TPIDR_EL0);
> > +	case TPIDRRO_EL0:	return read_sysreg_s(SYS_TPIDRRO_EL0);
> > +	case TPIDR_EL1:		return read_sysreg_s(SYS_TPIDR_EL1);
> > +	case AMAIR_EL1:		return read_sysreg_s(amair_EL12);
> > +	case CNTKCTL_EL1:	return read_sysreg_s(cntkctl_EL12);
> > +	case PAR_EL1:		return read_sysreg_s(SYS_PAR_EL1);
> >  	}
> >  
> >  immediate_read:
> > @@ -103,6 +123,26 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, int reg, u64 val)
> >  	 * entry to the guest but are only restored on vcpu_load.
> >  	 */
> >  	switch (reg) {
> > +	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	return;
> > +	case SCTLR_EL1:		write_sysreg_s(val, sctlr_EL12);	return;
> > +	case ACTLR_EL1:		write_sysreg_s(val, SYS_ACTLR_EL1);	return;
> > +	case CPACR_EL1:		write_sysreg_s(val, cpacr_EL12);	return;
> > +	case TTBR0_EL1:		write_sysreg_s(val, ttbr0_EL12);	return;
> > +	case TTBR1_EL1:		write_sysreg_s(val, ttbr1_EL12);	return;
> > +	case TCR_EL1:		write_sysreg_s(val, tcr_EL12);		return;
> > +	case ESR_EL1:		write_sysreg_s(val, esr_EL12);		return;
> > +	case AFSR0_EL1:		write_sysreg_s(val, afsr0_EL12);	return;
> > +	case AFSR1_EL1:		write_sysreg_s(val, afsr1_EL12);	return;
> > +	case FAR_EL1:		write_sysreg_s(val, far_EL12);		return;
> > +	case MAIR_EL1:		write_sysreg_s(val, mair_EL12);		return;
> > +	case VBAR_EL1:		write_sysreg_s(val, vbar_EL12);		return;
> > +	case CONTEXTIDR_EL1:	write_sysreg_s(val, contextidr_EL12);	return;
> > +	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	return;
> > +	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	return;
> > +	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	return;
> > +	case AMAIR_EL1:		write_sysreg_s(val, amair_EL12);	return;
> > +	case CNTKCTL_EL1:	write_sysreg_s(val, cntkctl_EL12);	return;
> > +	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	return;
> >  	}
> >  
> >  immediate_write:
> > -- 
> > 2.14.2
> > 
> 
> Looks good to me otherwise.
> 

Thanks,
-Christoffer
