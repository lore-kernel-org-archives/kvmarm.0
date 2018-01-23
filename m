From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 26/41] KVM: arm64: Introduce framework for accessing
 deferred sysregs
Date: Tue, 23 Jan 2018 16:04:40 +0000
Message-ID: <20180123160431.GA5862@e103592.cambridge.arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-27-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112120747.27999-27-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 12, 2018 at 01:07:32PM +0100, Christoffer Dall wrote:
> We are about to defer saving and restoring some groups of system
> registers to vcpu_put and vcpu_load on supported systems.  This means
> that we need some infrastructure to access system registes which
> supports either accessing the memory backing of the register or directly
> accessing the system registers, depending on the state of the system
> when we access the register.
> 
> We do this by defining a set of read/write accessors for each system
> register, and letting each system register be defined as "immediate" or
> "deferrable".  Immediate registers are always saved/restored in the
> world-switch path, but deferrable registers are only saved/restored in
> vcpu_put/vcpu_load when supported and sysregs_loaded_on_cpu will be set
> in that case.
> 
> Not that we don't use the deferred mechanism yet in this patch, but only
> introduce infrastructure.  This is to improve convenience of review in
> the subsequent patches where it is clear which registers become
> deferred.

Might this table-driven approach result in a lot of branch mispredicts,
particularly across load/put boundaries?

If we were to move the whole construct to a header, then it could get
constant-folded at the call site down to the individual reg accessed,
say:

	if (sys_regs_loaded)
		read_sysreg_s(TPIDR_EL0);
	else
		__vcpu_sys_reg(v, TPIDR_EL0);

Where multiple regs are accessed close to each other, the compiler
may be able to specialise the whole sequence for the loaded and !loaded
cases so that there is only one conditional branch.


The individual accessor functions also become unnecessary in this case,
because we wouldn't need to derive function pointers from them any
more.

I don't know how performance would compare in practice though.

I'm also assuming that all calls to these accessors are const-foldable.
If not, relying on inlining would bloat the generated code a lot.

Cheers
---Dave

> 
>  [ Most of this logic was contributed by Marc Zyngier ]
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |   8 +-
>  arch/arm64/kvm/sys_regs.c         | 160 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 166 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 91272c35cc36..4b5ef82f6bdb 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -281,6 +281,10 @@ struct kvm_vcpu_arch {
>  
>  	/* Detect first run of a vcpu */
>  	bool has_run_once;
> +
> +	/* True when deferrable sysregs are loaded on the physical CPU,
> +	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
> +	bool sysregs_loaded_on_cpu;
>  };
>  
>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
> @@ -293,8 +297,8 @@ struct kvm_vcpu_arch {
>   */
>  #define __vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
>  
> -#define vcpu_read_sys_reg(v,r)	__vcpu_sys_reg(v,r)
> -#define vcpu_write_sys_reg(v,r,n)	do { __vcpu_sys_reg(v,r) = n; } while (0)
> +u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg);
> +void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, int reg, u64 val);
>  
>  /*
>   * CP14 and CP15 live in the same array, as they are backed by the
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 96398d53b462..9d353a6a55c9 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -35,6 +35,7 @@
>  #include <asm/kvm_coproc.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_host.h>
> +#include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/perf_event.h>
>  #include <asm/sysreg.h>
> @@ -76,6 +77,165 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
>  	return false;
>  }
>  
> +struct sys_reg_accessor {
> +	u64	(*rdsr)(struct kvm_vcpu *, int);
> +	void	(*wrsr)(struct kvm_vcpu *, int, u64);
> +};
> +
> +#define DECLARE_IMMEDIATE_SR(i)						\
> +	static u64 __##i##_read(struct kvm_vcpu *vcpu, int r)		\
> +	{								\
> +		return __vcpu_sys_reg(vcpu, r);				\
> +	}								\
> +									\
> +	static void __##i##_write(struct kvm_vcpu *vcpu, int r, u64 v)	\
> +	{								\
> +		__vcpu_sys_reg(vcpu, r) = v;				\
> +	}								\
> +
> +#define DECLARE_DEFERRABLE_SR(i, s)					\
> +	static u64 __##i##_read(struct kvm_vcpu *vcpu, int r)		\
> +	{								\
> +		if (vcpu->arch.sysregs_loaded_on_cpu) {			\
> +			WARN_ON(kvm_arm_get_running_vcpu() != vcpu);	\
> +			return read_sysreg_s((s));			\
> +		}							\
> +		return __vcpu_sys_reg(vcpu, r);				\
> +	}								\
> +									\
> +	static void __##i##_write(struct kvm_vcpu *vcpu, int r, u64 v)	\
> +	{								\
> +		if (vcpu->arch.sysregs_loaded_on_cpu) {			\
> +			WARN_ON(kvm_arm_get_running_vcpu() != vcpu);	\
> +			write_sysreg_s(v, (s));				\
> +		} else {						\
> +			__vcpu_sys_reg(vcpu, r) = v;			\
> +		}							\
> +	}								\
> +
> +
> +#define SR_HANDLER_RANGE(i,e)						\
> +	[i ... e] =  (struct sys_reg_accessor) {			\
> +		.rdsr = __##i##_read,					\
> +		.wrsr = __##i##_write,					\
> +	}
> +
> +#define SR_HANDLER(i)	SR_HANDLER_RANGE(i, i)
> +
> +static void bad_sys_reg(int reg)
> +{
> +	WARN_ONCE(1, "Bad system register access %d\n", reg);
> +}
> +
> +static u64 __default_read_sys_reg(struct kvm_vcpu *vcpu, int reg)
> +{
> +	bad_sys_reg(reg);
> +	return 0;
> +}
> +
> +static void __default_write_sys_reg(struct kvm_vcpu *vcpu, int reg, u64 val)
> +{
> +	bad_sys_reg(reg);
> +}
> +
> +/* Ordered as in enum vcpu_sysreg */
> +DECLARE_IMMEDIATE_SR(MPIDR_EL1);
> +DECLARE_IMMEDIATE_SR(CSSELR_EL1);
> +DECLARE_IMMEDIATE_SR(SCTLR_EL1);
> +DECLARE_IMMEDIATE_SR(ACTLR_EL1);
> +DECLARE_IMMEDIATE_SR(CPACR_EL1);
> +DECLARE_IMMEDIATE_SR(TTBR0_EL1);
> +DECLARE_IMMEDIATE_SR(TTBR1_EL1);
> +DECLARE_IMMEDIATE_SR(TCR_EL1);
> +DECLARE_IMMEDIATE_SR(ESR_EL1);
> +DECLARE_IMMEDIATE_SR(AFSR0_EL1);
> +DECLARE_IMMEDIATE_SR(AFSR1_EL1);
> +DECLARE_IMMEDIATE_SR(FAR_EL1);
> +DECLARE_IMMEDIATE_SR(MAIR_EL1);
> +DECLARE_IMMEDIATE_SR(VBAR_EL1);
> +DECLARE_IMMEDIATE_SR(CONTEXTIDR_EL1);
> +DECLARE_IMMEDIATE_SR(TPIDR_EL0);
> +DECLARE_IMMEDIATE_SR(TPIDRRO_EL0);
> +DECLARE_IMMEDIATE_SR(TPIDR_EL1);
> +DECLARE_IMMEDIATE_SR(AMAIR_EL1);
> +DECLARE_IMMEDIATE_SR(CNTKCTL_EL1);
> +DECLARE_IMMEDIATE_SR(PAR_EL1);
> +DECLARE_IMMEDIATE_SR(MDSCR_EL1);
> +DECLARE_IMMEDIATE_SR(MDCCINT_EL1);
> +DECLARE_IMMEDIATE_SR(PMCR_EL0);
> +DECLARE_IMMEDIATE_SR(PMSELR_EL0);
> +DECLARE_IMMEDIATE_SR(PMEVCNTR0_EL0);
> +/* PMEVCNTR30_EL0 */
> +DECLARE_IMMEDIATE_SR(PMCCNTR_EL0);
> +DECLARE_IMMEDIATE_SR(PMEVTYPER0_EL0);
> +/* PMEVTYPER30_EL0 */
> +DECLARE_IMMEDIATE_SR(PMCCFILTR_EL0);
> +DECLARE_IMMEDIATE_SR(PMCNTENSET_EL0);
> +DECLARE_IMMEDIATE_SR(PMINTENSET_EL1);
> +DECLARE_IMMEDIATE_SR(PMOVSSET_EL0);
> +DECLARE_IMMEDIATE_SR(PMSWINC_EL0);
> +DECLARE_IMMEDIATE_SR(PMUSERENR_EL0);
> +DECLARE_IMMEDIATE_SR(DACR32_EL2);
> +DECLARE_IMMEDIATE_SR(IFSR32_EL2);
> +DECLARE_IMMEDIATE_SR(FPEXC32_EL2);
> +DECLARE_IMMEDIATE_SR(DBGVCR32_EL2);
> +
> +static const struct sys_reg_accessor sys_reg_accessors[NR_SYS_REGS] = {
> +	[0 ... NR_SYS_REGS - 1] = {
> +		.rdsr = __default_read_sys_reg,
> +		.wrsr = __default_write_sys_reg,
> +	},
> +
> +	SR_HANDLER(MPIDR_EL1),
> +	SR_HANDLER(CSSELR_EL1),
> +	SR_HANDLER(SCTLR_EL1),
> +	SR_HANDLER(ACTLR_EL1),
> +	SR_HANDLER(CPACR_EL1),
> +	SR_HANDLER(TTBR0_EL1),
> +	SR_HANDLER(TTBR1_EL1),
> +	SR_HANDLER(TCR_EL1),
> +	SR_HANDLER(ESR_EL1),
> +	SR_HANDLER(AFSR0_EL1),
> +	SR_HANDLER(AFSR1_EL1),
> +	SR_HANDLER(FAR_EL1),
> +	SR_HANDLER(MAIR_EL1),
> +	SR_HANDLER(VBAR_EL1),
> +	SR_HANDLER(CONTEXTIDR_EL1),
> +	SR_HANDLER(TPIDR_EL0),
> +	SR_HANDLER(TPIDRRO_EL0),
> +	SR_HANDLER(TPIDR_EL1),
> +	SR_HANDLER(AMAIR_EL1),
> +	SR_HANDLER(CNTKCTL_EL1),
> +	SR_HANDLER(PAR_EL1),
> +	SR_HANDLER(MDSCR_EL1),
> +	SR_HANDLER(MDCCINT_EL1),
> +	SR_HANDLER(PMCR_EL0),
> +	SR_HANDLER(PMSELR_EL0),
> +	SR_HANDLER_RANGE(PMEVCNTR0_EL0, PMEVCNTR30_EL0),
> +	SR_HANDLER(PMCCNTR_EL0),
> +	SR_HANDLER_RANGE(PMEVTYPER0_EL0, PMEVTYPER30_EL0),
> +	SR_HANDLER(PMCCFILTR_EL0),
> +	SR_HANDLER(PMCNTENSET_EL0),
> +	SR_HANDLER(PMINTENSET_EL1),
> +	SR_HANDLER(PMOVSSET_EL0),
> +	SR_HANDLER(PMSWINC_EL0),
> +	SR_HANDLER(PMUSERENR_EL0),
> +	SR_HANDLER(DACR32_EL2),
> +	SR_HANDLER(IFSR32_EL2),
> +	SR_HANDLER(FPEXC32_EL2),
> +	SR_HANDLER(DBGVCR32_EL2),
> +};
> +
> +u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg)
> +{
> +	return sys_reg_accessors[reg].rdsr(vcpu, reg);
> +}
> +
> +void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, int reg, u64 val)
> +{
> +	sys_reg_accessors[reg].wrsr(vcpu, reg, val);
> +}
> +
>  /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
>  static u32 cache_levels;
>  
> -- 
> 2.14.2
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
