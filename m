From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 25/40] KVM: arm64: Introduce framework for accessing
 deferred sysregs
Date: Thu, 22 Feb 2018 15:56:09 +0100
Message-ID: <20180222145609.GQ29376@cbox>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-26-christoffer.dall@linaro.org>
 <20180222134052.fej4yyf5fq57kk3g@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180222134052.fej4yyf5fq57kk3g@kamzik.brq.redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, kvmarm@lists.cs.columbia.edu, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 22, 2018 at 02:40:52PM +0100, Andrew Jones wrote:
> On Thu, Feb 15, 2018 at 10:03:17PM +0100, Christoffer Dall wrote:
> > We are about to defer saving and restoring some groups of system
> > registers to vcpu_put and vcpu_load on supported systems.  This means
> > that we need some infrastructure to access system registes which
> > supports either accessing the memory backing of the register or directly
> > accessing the system registers, depending on the state of the system
> > when we access the register.
> > 
> > We do this by defining read/write accessor functions, which can handle
> > both "immediate" and "deferrable" system registers.  Immediate registers
> > are always saved/restored in the world-switch path, but deferrable
> > registers are only saved/restored in vcpu_put/vcpu_load when supported
> > and sysregs_loaded_on_cpu will be set in that case.
> > 
> > Note that we don't use the deferred mechanism yet in this patch, but only
> > introduce infrastructure.  This is to improve convenience of review in
> > the subsequent patches where it is clear which registers become
> > deferred.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> > 
> > Notes:
> >     Changes since v3:
> >      - Changed to a switch-statement based approach to improve
> >        readability.
> >     
> >     Changes since v2:
> >      - New patch (deferred register handling has been reworked)
> > 
> >  arch/arm64/include/asm/kvm_host.h |  8 ++++++--
> >  arch/arm64/kvm/sys_regs.c         | 33 +++++++++++++++++++++++++++++++++
> >  2 files changed, 39 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 68398bf7882f..b463b5e28959 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -284,6 +284,10 @@ struct kvm_vcpu_arch {
> >  
> >  	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
> >  	u64 vsesr_el2;
> > +
> > +	/* True when deferrable sysregs are loaded on the physical CPU,
> > +	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
> > +	bool sysregs_loaded_on_cpu;
> >  };
> >  
> >  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
> > @@ -296,8 +300,8 @@ struct kvm_vcpu_arch {
> >   */
> >  #define __vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
> >  
> > -#define vcpu_read_sys_reg(v,r)	__vcpu_sys_reg(v,r)
> > -#define vcpu_write_sys_reg(v,r,n)	do { __vcpu_sys_reg(v,r) = n; } while (0)
> > +u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg);
> > +void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, int reg, u64 val);
> >  
> >  /*
> >   * CP14 and CP15 live in the same array, as they are backed by the
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index a05d2c01c786..b3c3f014aa61 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -35,6 +35,7 @@
> >  #include <asm/kvm_coproc.h>
> >  #include <asm/kvm_emulate.h>
> >  #include <asm/kvm_host.h>
> > +#include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/perf_event.h>
> >  #include <asm/sysreg.h>
> > @@ -76,6 +77,38 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
> >  	return false;
> >  }
> >  
> > +u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg)
> > +{
> > +	if (!vcpu->arch.sysregs_loaded_on_cpu)
> > +		goto immediate_read;
> > +
> > +	/*
> > +	 * All system registers listed in the switch are not saved on every
> > +	 * exit from the guest but are only saved on vcpu_put.
> 
> The "All ... are not" doesn't flow well for me. How about
> 
>  /*
>   * None of the system registers listed in the switch are saved on guest
>   * exit. These registers are only saved on vcpu_put.
>   */
> 
> > +	 */
> > +	switch (reg) {
> > +	}
> > +
> > +immediate_read:
> > +	return __vcpu_sys_reg(vcpu, reg);
> > +}
> > +
> > +void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, int reg, u64 val)
> > +{
> > +	if (!vcpu->arch.sysregs_loaded_on_cpu)
> > +		goto immediate_write;
> > +
> > +	/*
> > +	 * All system registers listed in the switch are not restored on every
> > +	 * entry to the guest but are only restored on vcpu_load.
> > +	 */
> 
>  /*
>   * None of the system registers listed in the switch are restored on
>   * guest entry. If these registers were saved due to a vcpu_put, then
>   * they will be restored by vcpu_load.
>   */
> 

Hmmm, not sure the last sentence helps here.

I'll think about some nicer wording for you for the next version.

> > +	switch (reg) {
> > +	}
> > +
> > +immediate_write:
> > +	 __vcpu_sys_reg(vcpu, reg) = val;
> > +}
> > +
> >  /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
> >  static u32 cache_levels;
> >  
> > -- 
> > 2.14.2
> >
> 
> Otherwise
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
-Christoffer
