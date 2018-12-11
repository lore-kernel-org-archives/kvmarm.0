From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v6 2/4] arm64: KVM: add accessors to track guest/host
 only counters
Date: Tue, 11 Dec 2018 08:55:25 +0100
Message-ID: <20181211075525.GS30263@e113682-lin.lund.arm.com>
References: <1544435159-54781-1-git-send-email-andrew.murray@arm.com>
 <1544435159-54781-3-git-send-email-andrew.murray@arm.com>
 <20181210102634.GL30263@e113682-lin.lund.arm.com>
 <20181210234655.GB13393@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28F7A4A319
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 02:55:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G7mRv-MWETkH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 02:55:28 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CD2D4A2BA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 02:55:28 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181210234655.GB13393@e119886-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 10, 2018 at 11:46:56PM +0000, Andrew Murray wrote:
> On Mon, Dec 10, 2018 at 11:26:34AM +0100, Christoffer Dall wrote:
> > On Mon, Dec 10, 2018 at 09:45:57AM +0000, Andrew Murray wrote:
> > > In order to effeciently enable/disable guest/host only perf counters
> > > at guest entry/exit we add bitfields to kvm_cpu_context for guest and
> > > host events as well as accessors for updating them.
> > > 
> > > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h | 24 ++++++++++++++++++++++++
> > >  1 file changed, 24 insertions(+)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 1550192..800c87b 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -203,6 +203,8 @@ struct kvm_cpu_context {
> > >  	};
> > >  
> > >  	struct kvm_vcpu *__hyp_running_vcpu;
> > > +	u32 events_host;
> > > +	u32 events_guest;
> > 
> > This is confusing to me.
> > 
> > These values appear only to be used for the host instance, which makes
> > me wonder why we add them to kvm_cpu_context, which is also used for the
> > guest state?  Should we not instead consider moving them to their own
> 
> Indeed they are only used for the host instance (i.e. not arch.ctxt). I
> hadn't realised the structure was used in other contexts. So it isn't
> optimal to have additional fields that aren't always used.
> 
> 
> > data structure and add a per-cpu data structure or something more fancy
> > like having a new data structure, kvm_percpu_host_data, which contains
> > the kvm_cpu_context and the events flags?
> 
> Using a percpu for the guest/host events was an approach I took prior to
> sharing on the list - an additional hypervisor mapping is needed (such
> that the percpu can be accessed from the hyp switch code) and I assume
> there to be a very marginal additional amount of work resulting from it
> switching between host/guest.
> 
> I also considered using the unused ctxt.sys_regs[PMCNTENSET_EL0] register
> though this feels like a hack and would probably involve a system register
> read in the switch code to read the current PMU state.

Yeah, that doesn't sound overly appealing.

> 
> I attempted the fancy approach (see below) - the struct and variable
> naming isn't ideal (virt/arm/arm.c defines kvm_cpu_context_t and of course
> is shared with arm32). Also I updated asm-offsets.c to reflect the now
> nested struct (for use with get_vcpu_ptr) - it's not strictly necessary
> but adds robustness.
> 
> What are your thoughts on the best approach?

The naming and typedef is the biggest issue with the patch below, but
that can be easily fixed.

The fact that you keep the context pointer on the vcpu structure makes
this much less painful that it could have been, so I think this is
acceptable.

I can also live with mapping the additional data structure if necessary.

> 
> > 
> > I don't know much about perf, but doesn't this design also imply that
> > you can only set these modifiers at a per-cpu level, and not attach
> > the modifiers to a task/vcpu or vm ?  Is that by design?
> 
> You can set these modifiers on a task and the perf core will take care of
> disabling the perf_event when the task is scheduled in/out.

I now remember how this works, thanks for the nudge in the right
direction.

> 
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 800c87b..1f4a78a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -203,11 +203,19 @@ struct kvm_cpu_context {
>         };
> 
>         struct kvm_vcpu *__hyp_running_vcpu;
> +};
> +
> +struct kvm_pmu_events {
>         u32 events_host;
>         u32 events_guest;
>  };
> 
> -typedef struct kvm_cpu_context kvm_cpu_context_t;
> +struct kvm_host_data {
> +       struct kvm_cpu_context __kvm_cpu_state;
> +       struct kvm_pmu_events pmu_events;
> +};
> +
> +typedef struct kvm_host_data kvm_cpu_context_t;
> 

This look really strange.  I think we can just keep the old typedef, and
if you like you can introduce a kvm_host_data_t...

>  struct kvm_vcpu_arch {
>         struct kvm_cpu_context ctxt;
> @@ -243,7 +251,7 @@ struct kvm_vcpu_arch {
>         struct kvm_guest_debug_arch external_debug_state;
> 
>         /* Pointer to host CPU context */
> -       kvm_cpu_context_t *host_cpu_context;
> +       struct kvm_cpu_context *host_cpu_context;
> 
>         struct thread_info *host_thread_info;   /* hyp VA */
>         struct user_fpsimd_state *host_fpsimd_state;    /* hyp VA */
> @@ -482,16 +490,16 @@ static inline void kvm_set_pmu_events(u32 set, int flags)
>         kvm_cpu_context_t *ctx = this_cpu_ptr(&kvm_host_cpu_state);
> 
>         if (flags & KVM_PMU_EVENTS_HOST)
> -               ctx->events_host |= set;
> +               ctx->pmu_events.events_host |= set;
>         if (flags & KVM_PMU_EVENTS_GUEST)
> -               ctx->events_guest |= set;
> +               ctx->pmu_events.events_guest |= set;

...which would make it easier to understand what is going on here.

>  }
>  static inline void kvm_clr_pmu_events(u32 clr)
>  {
>         kvm_cpu_context_t *ctx = this_cpu_ptr(&kvm_host_cpu_state);
> 
> -       ctx->events_host &= ~clr;
> -       ctx->events_guest &= ~clr;
> +       ctx->pmu_events.events_host &= ~clr;
> +       ctx->pmu_events.events_guest &= ~clr;
>  }
>  #else
>  static inline void kvm_set_pmu_events(u32 set, int flags) {}
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 323aeb5..da34022 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -142,7 +142,8 @@ int main(void)
>    DEFINE(CPU_FP_REGS,          offsetof(struct kvm_regs, fp_regs));
>    DEFINE(VCPU_FPEXC32_EL2,     offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[FPEXC32_EL2]));
>    DEFINE(VCPU_HOST_CONTEXT,    offsetof(struct kvm_vcpu, arch.host_cpu_context));
> -  DEFINE(HOST_CONTEXT_VCPU,    offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
> +  DEFINE(HOST_CONTEXT_VCPU,    offsetof(struct kvm_cpu_context, __hyp_running_vcpu)
> +                               + offsetof(struct kvm_host_data, __kvm_cpu_state));
>  #endif
>  #ifdef CONFIG_CPU_PM
>    DEFINE(CPU_SUSPEND_SZ,       sizeof(struct cpu_suspend_ctx));
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index e505cad..5f0d571 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -375,8 +375,14 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
> 
>  static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
>  {
> -       u32 clr = host_ctxt->events_host & ~host_ctxt->events_guest;
> -       u32 set = host_ctxt->events_guest & ~host_ctxt->events_host;
> +       struct kvm_host_data *host;
> +       struct kvm_pmu_events *events;
> +
> +       host = container_of(host_ctxt, struct kvm_host_data, __kvm_cpu_state);
> +       pmu = &host_data->pmu_events;
> +
> +       u32 clr = pmu->events_host & ~pmu->events_guest;
> +       u32 set = pmu->events_guest & ~pmu->events_host;
> 
>         if (clr)
>                 write_sysreg(clr, pmcntenclr_el0);
> @@ -389,8 +395,11 @@ static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
> 
>  static void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
>  {
> -       u32 clr = host_ctxt->events_guest & ~host_ctxt->events_host;
> -       u32 set = host_ctxt->events_host & ~host_ctxt->events_guest;
> +       struct kvm_host_data *host = container_of(host_ctxt, struct kvm_host_data, __kvm_cpu_state);
> +       struct kvm_pmu_events *pmu = &host->pmu_events;
> +
> +       u32 clr = pmu->events_guest & ~pmu->events_host;
> +       u32 set = pmu->events_host & ~pmu->events_guest;
> 
>         if (clr)
>                 write_sysreg(clr, pmcntenclr_el0);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 150c8a6..6ba7de1 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -374,7 +374,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>         }
> 
>         vcpu->cpu = cpu;
> -       vcpu->arch.host_cpu_context = this_cpu_ptr(&kvm_host_cpu_state);
> +       vcpu->arch.host_cpu_context = &(this_cpu_ptr(&kvm_host_cpu_state)->__kvm_cpu_state);
> 
>         kvm_arm_set_running_vcpu(vcpu);
>         kvm_vgic_load(vcpu);
> 

Thanks,

    Christoffer
