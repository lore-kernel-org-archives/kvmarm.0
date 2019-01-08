From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v4 1/6] arm64/kvm: preserve host HCR_EL2 value
Date: Tue, 8 Jan 2019 10:46:57 +0530
Message-ID: <CADGdYn5VvAgmTbjmA_1hM0LFoOcvzMO6BziSvWax85Q1hSPxsQ@mail.gmail.com>
References: <1545119810-12182-1-git-send-email-amit.kachhap@arm.com>
 <1545119810-12182-2-git-send-email-amit.kachhap@arm.com> <47a81c5b-1b1b-2c87-8c90-af5ef63d1364@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <47a81c5b-1b1b-2c87-8c90-af5ef63d1364@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: LAK <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Sat, Jan 5, 2019 at 12:05 AM James Morse <james.morse@arm.com> wrote:
>
> Hi Amit,
>
> On 18/12/2018 07:56, Amit Daniel Kachhap wrote:
> > When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
> > is a constant value. This works today, as the host HCR_EL2 value is
> > always the same, but this will get in the way of supporting extensions
> > that require HCR_EL2 bits to be set conditionally for the host.
> >
> > To allow such features to work without KVM having to explicitly handle
> > every possible host feature combination, this patch has KVM save/restore
> > the host HCR when switching to/from a guest HCR. The saving of the
> > register is done once during cpu hypervisor initialization state and is
> > just restored after switch from guest.
> >
> > For fetching HCR_EL2 during kvm initilisation, a hyp call is made using
>
> (initialisation)
>
>
> > kvm_call_hyp and is helpful in NHVE case.
> >
> > For the hyp TLB maintenance code, __tlb_switch_to_host_vhe() is updated
> > to toggle the TGE bit with a RMW sequence, as we already do in
> > __tlb_switch_to_guest_vhe().
>
>
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index aea01a0..25ac9fa 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -73,6 +73,8 @@ extern void __vgic_v3_init_lrs(void);
> >
> >  extern u32 __kvm_get_mdcr_el2(void);
> >
> > +extern u64 __read_hyp_hcr_el2(void);
>
> How come this isn't __kvm_get_hcr_el2() like mdcr?
yes.
>
>
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 52fbc82..1b9eed9 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -196,13 +196,17 @@ enum vcpu_sysreg {
> >
> >  #define NR_COPRO_REGS        (NR_SYS_REGS * 2)
> >
> > +struct kvm_cpu_init_host_regs {
> > +     u64 hcr_el2;
> > +};
> > +
> >  struct kvm_cpu_context {
> >       struct kvm_regs gp_regs;
> >       union {
> >               u64 sys_regs[NR_SYS_REGS];
> >               u32 copro[NR_COPRO_REGS];
> >       };
> > -
> > +     struct kvm_cpu_init_host_regs init_regs;
> >       struct kvm_vcpu *__hyp_running_vcpu;
> >  };
>
> Hmm, so we grow every vcpu's struct kvm_cpu_context with some host-only registers...
>
>
> > @@ -211,7 +215,7 @@ typedef struct kvm_cpu_context kvm_cpu_context_t;
> >  struct kvm_vcpu_arch {
> >       struct kvm_cpu_context ctxt;
> >
> > -     /* HYP configuration */
> > +     /* Guest HYP configuration */
> >       u64 hcr_el2;
> >       u32 mdcr_el2;
>
> ... but they aren't actually host-only.
>
>
> I think it would be tidier to move these two into struct kvm_cpu_context (not as
> some init_host state), as both host and vcpu's have these values.
> You could then add the mdcr_el2 stashing to your __cpu_copy_host_registers()
> too. This way they both work in the same way, otherwise one is per-cpu, the
> other is in a special bit of only the host's kvm_cpu_context.
>
Your suggestion looks doable. I will implement in next iteration.
>
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index f6e02cc..85a2a5c 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -139,15 +139,15 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
> >               __activate_traps_nvhe(vcpu);
> >  }
> >
> > -static void deactivate_traps_vhe(void)
> > +static void deactivate_traps_vhe(struct kvm_cpu_context *host_ctxt)
> >  {
> >       extern char vectors[];  /* kernel exception vectors */
> > -     write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
> > +     write_sysreg(host_ctxt->init_regs.hcr_el2, hcr_el2);
> >       write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
> >       write_sysreg(vectors, vbar_el1);
> >  }
> >
> > -static void __hyp_text __deactivate_traps_nvhe(void)
> > +static void __hyp_text __deactivate_traps_nvhe(struct kvm_cpu_context *host_ctxt)
> >  {
> >       u64 mdcr_el2 = read_sysreg(mdcr_el2);
> >
> > @@ -157,12 +157,15 @@ static void __hyp_text __deactivate_traps_nvhe(void)
> >       mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
> >
> >       write_sysreg(mdcr_el2, mdcr_el2);
>
> Strangely we try to rebuild the host's mdcr value here. If we had the host mdcr
> value in host_ctxt we could restore it directly.
yes. I will check if initial value host value is same as calculated.
>
>
> > -     write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
> > +     write_sysreg(host_ctxt->init_regs.hcr_el2, hcr_el2);
> >       write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
> >  }
>
> >  static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
> >  {
> > +     struct kvm_cpu_context *host_ctxt;
> > +
> > +     host_ctxt = vcpu->arch.host_cpu_context;
> >       /*
> >        * If we pended a virtual abort, preserve it until it gets
> >        * cleared. See D1.14.3 (Virtual Interrupts) for details, but
> > @@ -173,9 +176,9 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
> >               vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
> >
> >       if (has_vhe())
> > -             deactivate_traps_vhe();
> > +             deactivate_traps_vhe(host_ctxt);
> >       else
> > -             __deactivate_traps_nvhe();
> > +             __deactivate_traps_nvhe(host_ctxt);
> >  }
>
> (Alternatively each of these deactivate_traps() calls could retrieve the
> host_ctxt directly as its a per-cpu variable, but as we have the struct vcpu
> here, this is probably better.)
>
>
> Thanks,
>
> James

//Amit
