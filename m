From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 22/36] KVM: arm64: Prepare to handle traps on deferred
 VM sysregs
Date: Tue, 12 Dec 2017 16:46:40 +0100
Message-ID: <20171212154640.GM910@cbox>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-23-christoffer.dall@linaro.org>
 <7f4ecd66-fca1-4da9-3524-ee64d999a501@arm.com>
 <20171211112436.GH910@cbox>
 <622521ec-013c-cf89-3222-5f40237d0ada@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <622521ec-013c-cf89-3222-5f40237d0ada@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 12, 2017 at 01:08:30PM +0000, Marc Zyngier wrote:
> On 11/12/17 11:24, Christoffer Dall wrote:
> > On Mon, Dec 11, 2017 at 11:10:36AM +0000, Marc Zyngier wrote:
> >> On 07/12/17 17:06, Christoffer Dall wrote:
> >>> When we defer the save/restore of system registers to vcpu_load and
> >>> vcpu_put, we need to take care of the emulation code that handles traps
> >>> to these registers, since simply reading the memory array will return
> >>> stale data.
> >>>
> >>> Therefore, introduce two functions to directly read/write the registers
> >>> from the physical CPU when we're on a VHE system that has loaded the
> >>> system registers onto the physical CPU.
> >>>
> >>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >>> ---
> >>>
> >>> Notes:
> >>>     Changes since v1:
> >>>      - Removed spurious white space
> >>>
> >>>  arch/arm64/include/asm/kvm_host.h |  4 +++
> >>>  arch/arm64/kvm/sys_regs.c         | 53 +++++++++++++++++++++++++++++++++++++--
> >>>  2 files changed, 55 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >>> index de0d55b30b61..f6afe685a280 100644
> >>> --- a/arch/arm64/include/asm/kvm_host.h
> >>> +++ b/arch/arm64/include/asm/kvm_host.h
> >>> @@ -279,6 +279,10 @@ struct kvm_vcpu_arch {
> >>>  
> >>>  	/* Detect first run of a vcpu */
> >>>  	bool has_run_once;
> >>> +
> >>> +	/* True when deferrable sysregs are loaded on the physical CPU,
> >>> +	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
> >>> +	bool sysregs_loaded_on_cpu;
> >>>  };
> >>>  
> >>>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
> >>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >>> index 62c12ab9e6c4..80adbec933de 100644
> >>> --- a/arch/arm64/kvm/sys_regs.c
> >>> +++ b/arch/arm64/kvm/sys_regs.c
> >>> @@ -35,6 +35,7 @@
> >>>  #include <asm/kvm_coproc.h>
> >>>  #include <asm/kvm_emulate.h>
> >>>  #include <asm/kvm_host.h>
> >>> +#include <asm/kvm_hyp.h>
> >>>  #include <asm/kvm_mmu.h>
> >>>  #include <asm/perf_event.h>
> >>>  #include <asm/sysreg.h>
> >>> @@ -111,6 +112,54 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
> >>>  	return true;
> >>>  }
> >>>  
> >>> +static u64 read_deferrable_vm_reg(struct kvm_vcpu *vcpu, int reg)
> >>> +{
> >>> +	if (vcpu->arch.sysregs_loaded_on_cpu) {
> >>> +		switch (reg) {
> >>> +		case SCTLR_EL1:		return read_sysreg_el1(sctlr);
> >>> +		case TTBR0_EL1:		return read_sysreg_el1(ttbr0);
> >>> +		case TTBR1_EL1:		return read_sysreg_el1(ttbr1);
> >>> +		case TCR_EL1:		return read_sysreg_el1(tcr);
> >>> +		case ESR_EL1:		return read_sysreg_el1(esr);
> >>> +		case FAR_EL1:		return read_sysreg_el1(far);
> >>> +		case AFSR0_EL1:		return read_sysreg_el1(afsr0);
> >>> +		case AFSR1_EL1:		return read_sysreg_el1(afsr1);
> >>> +		case MAIR_EL1:		return read_sysreg_el1(mair);
> >>> +		case AMAIR_EL1:		return read_sysreg_el1(amair);
> >>> +		case CONTEXTIDR_EL1:	return read_sysreg_el1(contextidr);
> >>> +		case DACR32_EL2:	return read_sysreg(dacr32_el2);
> >>> +		case IFSR32_EL2:	return read_sysreg(ifsr32_el2);
> >>> +		default:		BUG();
> >>> +		}
> >>> +	}
> >>> +
> >>> +	return vcpu_sys_reg(vcpu, reg);
> >>> +}
> >>> +
> >>> +static void write_deferrable_vm_reg(struct kvm_vcpu *vcpu, int reg, u64 val)
> >>> +{
> >>> +	if (vcpu->arch.sysregs_loaded_on_cpu) {
> >>> +		switch (reg) {
> >>> +		case SCTLR_EL1:		write_sysreg_el1(val, sctlr);	return;
> >>> +		case TTBR0_EL1:		write_sysreg_el1(val, ttbr0);	return;
> >>> +		case TTBR1_EL1:		write_sysreg_el1(val, ttbr1);	return;
> >>> +		case TCR_EL1:		write_sysreg_el1(val, tcr);	return;
> >>> +		case ESR_EL1:		write_sysreg_el1(val, esr);	return;
> >>> +		case FAR_EL1:		write_sysreg_el1(val, far);	return;
> >>> +		case AFSR0_EL1:		write_sysreg_el1(val, afsr0);	return;
> >>> +		case AFSR1_EL1:		write_sysreg_el1(val, afsr1);	return;
> >>> +		case MAIR_EL1:		write_sysreg_el1(val, mair);	return;
> >>> +		case AMAIR_EL1:		write_sysreg_el1(val, amair);	return;
> >>> +		case CONTEXTIDR_EL1:	write_sysreg_el1(val, contextidr); return;
> >>> +		case DACR32_EL2:	write_sysreg(val, dacr32_el2); return;
> >>> +		case IFSR32_EL2:	write_sysreg(val, ifsr32_el2); return;
> >>> +		default:		BUG();
> >>> +		}
> >>> +	}
> >>> +
> >>> +	vcpu_sys_reg(vcpu, reg) = val;
> >>> +}
> >>> +
> >>>  /*
> >>>   * Generic accessor for VM registers. Only called as long as HCR_TVM
> >>>   * is set. If the guest enables the MMU, we stop trapping the VM
> >>> @@ -133,14 +182,14 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
> >>>  	if (!p->is_aarch32 || !p->is_32bit) {
> >>>  		val = p->regval;
> >>>  	} else {
> >>> -		val = vcpu_sys_reg(vcpu, reg);
> >>> +		val = read_deferrable_vm_reg(vcpu, reg);
> >>>  		if (r->reg % 2)
> >>>  			val = (p->regval << 32) | (u64)lower_32_bits(val);
> >>>  		else
> >>>  			val = ((u64)upper_32_bits(val) << 32) |
> >>>  				(u64)lower_32_bits(p->regval);
> >>>  	}
> >>> -	vcpu_sys_reg(vcpu, reg) = val;
> >>> +	write_deferrable_vm_reg(vcpu, reg, val);
> >>>  
> >>>  	kvm_toggle_cache(vcpu, was_enabled);
> >>>  	return true;
> >>>
> >>
> >> I'm slightly uneasy with this. It means that the rest of the KVM code
> >> has to know whether a given register is deferrable or not (or face the
> >> wrath of the BUG). I'd be more inclined to hide the "loaded on cpu"
> >> magic in the vcpu_sys_reg() accessors.
> >>
> >> Thoughts?
> >>
> > 
> > Yes, this is the main reservation I also have with the series.
> > 
> > I did start out with a giant "rewrite everything to vcpu_get_sys_reg and
> > vcpu_get_sys_reg" which hides this logic, and we may want to go back to
> > that.
> > 
> > That does mean that we need a giant switch statement which knows how to
> > read any deferrable EL1 (and EL0) system register from hardware, and
> > still BUG/WARN if someone adds a system register but forgets to add that
> > handler and test on VHE.  Unless there's some fantastic auto-gen
> > mechanism that can take a hash define and figure out which sysreg
> > instruction to use - I couldn't think of that.
> 
> Coming back to this, as I'm currently prototyping something.
> 
> What is the rational for the BUG()? It is not like we can add a random
> sysreg and expect it to be deferred. It is a conscious decision to do
> so, and I feel that the default should be that the sysreg should be
> save/restored. What am I missing?
> 

The rationale is simply that as we're developing code, if we start
accessing registers while the sysregs are still loaded on the CPU, which
we haven't accessed before, and don't have an accessor for (new sysregs,
rework other parts of the flow etc.,), I wanted to have a clear point
where we realize that we forgot something.  Especially if we mostly test
on non-VHE systems.

But, actually, BUG() may be too hard, as it would only ever affect the
VM, and not the host, so reads could be WARN+RAZ, and writes could be
WARN+WI.

Thanks,
-Christoffer
