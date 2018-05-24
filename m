From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 02/14] arm64: Call ARCH_WORKAROUND_2 on transitions
 between EL0 and EL1
Date: Thu, 24 May 2018 12:23:06 +0100
Message-ID: <20180524112305.ld3jghzmb6a35h73@lakrids.cambridge.arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
 <20180522150648.28297-3-marc.zyngier@arm.com>
 <20180524110058.mrkwc3rx5l3v6wad@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180524110058.mrkwc3rx5l3v6wad@lakrids.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 24, 2018 at 12:00:58PM +0100, Mark Rutland wrote:
> On Tue, May 22, 2018 at 04:06:36PM +0100, Marc Zyngier wrote:
> > In order for the kernel to protect itself, let's call the SSBD mitigation
> > implemented by the higher exception level (either hypervisor or firmware)
> > on each transition between userspace and kernel.
> > 
> > We must take the PSCI conduit into account in order to target the
> > right exception level, hence the introduction of a runtime patching
> > callback.
> > 
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm64/kernel/cpu_errata.c | 18 ++++++++++++++++++
> >  arch/arm64/kernel/entry.S      | 22 ++++++++++++++++++++++
> >  include/linux/arm-smccc.h      |  5 +++++
> >  3 files changed, 45 insertions(+)
> > 
> > diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> > index a900befadfe8..46b3aafb631a 100644
> > --- a/arch/arm64/kernel/cpu_errata.c
> > +++ b/arch/arm64/kernel/cpu_errata.c
> > @@ -232,6 +232,24 @@ enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
> >  }
> >  #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
> >  
> > +#ifdef CONFIG_ARM64_SSBD
> > +void __init arm64_update_smccc_conduit(struct alt_instr *alt,
> > +				       __le32 *origptr, __le32 *updptr,
> > +				       int nr_inst)
> > +{
> > +	u32 insn;
> > +
> > +	BUG_ON(nr_inst != 1);
> > +
> > +	if (psci_ops.conduit == PSCI_CONDUIT_HVC)
> > +		insn = aarch64_insn_get_hvc_value();
> > +	else
> > +		insn = aarch64_insn_get_smc_value();
> 
> Shouldn't this also handle the case where there is no conduit?

Due to the config symbol not being defined yet, and various other fixups
in later patches, this is actually benign.

However, if you make this:

	switch (psci_ops.conduit) {
	case PSCI_CONDUIT_NONE:
		return;
	case PSCI_CONDUIT_HVC:
		insn = aarch64_insn_get_hvc_value();
		break;
	case PSCI_CONDUIT_SMC:
		insn = aarch64_insn_get_smc_value();
		break;
	}

... then we won't even bother patching the nop in the default case
regardless, which is nicer, IMO.

With that:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

> 
> See below comment in apply_ssbd for rationale.
> 
> > +
> > +	*updptr = cpu_to_le32(insn);
> > +}
> > +#endif	/* CONFIG_ARM64_SSBD */
> > +
> >  #define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
> >  	.matches = is_affected_midr_range,			\
> >  	.midr_range = MIDR_RANGE(model, v_min, r_min, v_max, r_max)
> > diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> > index ec2ee720e33e..f33e6aed3037 100644
> > --- a/arch/arm64/kernel/entry.S
> > +++ b/arch/arm64/kernel/entry.S
> > @@ -18,6 +18,7 @@
> >   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> >   */
> >  
> > +#include <linux/arm-smccc.h>
> >  #include <linux/init.h>
> >  #include <linux/linkage.h>
> >  
> > @@ -137,6 +138,18 @@ alternative_else_nop_endif
> >  	add	\dst, \dst, #(\sym - .entry.tramp.text)
> >  	.endm
> >  
> > +	// This macro corrupts x0-x3. It is the caller's duty
> > +	// to save/restore them if required.
> > +	.macro	apply_ssbd, state
> > +#ifdef CONFIG_ARM64_SSBD
> > +	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_2
> > +	mov	w1, #\state
> > +alternative_cb	arm64_update_smccc_conduit
> > +	nop					// Patched to SMC/HVC #0
> > +alternative_cb_end
> > +#endif
> > +	.endm
> 
> If my system doesn't have SMCCC1.1, or the FW doesn't have an
> implementation of ARCH_WORKAROUND_2, does this stay as a NOP?
> 
> It looks like this would be patched to an SMC, which would be fatal on
> systems without EL3 FW.
> 
> > +
> >  	.macro	kernel_entry, el, regsize = 64
> >  	.if	\regsize == 32
> >  	mov	w0, w0				// zero upper 32 bits of x0
> > @@ -163,6 +176,13 @@ alternative_else_nop_endif
> >  	ldr	x19, [tsk, #TSK_TI_FLAGS]	// since we can unmask debug
> >  	disable_step_tsk x19, x20		// exceptions when scheduling.
> >  
> > +	apply_ssbd 1
> 
> 
> ... and thus kernel_entry would be fatal.
> 
> Thanks,
> Mark.
