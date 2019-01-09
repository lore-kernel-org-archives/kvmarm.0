From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v4 2/6] arm64/kvm: context-switch ptrauth registers
Date: Wed, 9 Jan 2019 15:31:08 +0530
Message-ID: <CADGdYn6XTxv980DTrWfaWE4=9BQkq3=T=Ukuby_KFZ9q7+0T3w@mail.gmail.com>
References: <1545119810-12182-1-git-send-email-amit.kachhap@arm.com>
 <1545119810-12182-3-git-send-email-amit.kachhap@arm.com> <a50e3bdf-5e92-e0c3-76ab-ca49b1f4a715@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a50e3bdf-5e92-e0c3-76ab-ca49b1f4a715@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: LAK <linux-arm-kernel@lists.infradead.org>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Sat, Jan 5, 2019 at 12:05 AM James Morse <james.morse@arm.com> wrote:
>
> Hi Amit,
>
> On 18/12/2018 07:56, Amit Daniel Kachhap wrote:
> > When pointer authentication is supported, a guest may wish to use it.
> > This patch adds the necessary KVM infrastructure for this to work, with
> > a semi-lazy context switch of the pointer auth state.
> >
> > Pointer authentication feature is only enabled when VHE is built
> > into the kernel and present into CPU implementation so only VHE code
> > paths are modified.
> >
> > When we schedule a vcpu, we disable guest usage of pointer
> > authentication instructions and accesses to the keys. While these are
> > disabled, we avoid context-switching the keys. When we trap the guest
> > trying to use pointer authentication functionality, we change to eagerly
> > context-switching the keys, and enable the feature. The next time the
> > vcpu is scheduled out/in, we start again.
>
> Why start again?
> Taking the trap at all suggests the guest knows about pointer-auth, if it uses
> it, its probably in some context switch code. It would be good to avoid trapping
> that.
This is a pointer to the earlier discussion
https://lore.kernel.org/lkml/20180409125818.GE10904@cbox/.
It seems there is some agreement reached to flip ptrauth status in
every vcpu load/unload
as this would cater to both ptrauth enabled/disabled application.
>
>
> > Pointer authentication consists of address authentication and generic
> > authentication, and CPUs in a system might have varied support for
> > either. Where support for either feature is not uniform, it is hidden
> > from guests via ID register emulation, as a result of the cpufeature
> > framework in the host.
> >
> > Unfortunately, address authentication and generic authentication cannot
> > be trapped separately, as the architecture provides a single EL2 trap
> > covering both. If we wish to expose one without the other, we cannot
> > prevent a (badly-written) guest from intermittently using a feature
> > which is not uniformly supported (when scheduled on a physical CPU which
> > supports the relevant feature).
>
> Yuck!
:)
>
>
> > When the guest is scheduled on a
> > physical CPU lacking the feature, these attemts will result in an UNDEF
>
> (attempts)
ok.
>
> > being taken by the guest.
>
> Can we only expose the feature to a guest if both address and generic
> authentication are supported? (and hide it from the id register otherwise).
>
> This avoids having to know if this cpu supports address/generic when the system
> doesn't. We would need to scrub the values to avoid guest-values being left
> loaded when something else is running.
Yes it can be done. Currently it is done indirectly by userspace
option. Agree with you on this.
>
>
> > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > index 1c8393f..ac7d496 100644
> > --- a/arch/arm64/include/asm/cpufeature.h
> > +++ b/arch/arm64/include/asm/cpufeature.h
> > @@ -526,6 +526,12 @@ static inline bool system_supports_generic_auth(void)
> >               cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH);
> >  }
> >
> > +static inline bool system_supports_ptrauth(void)
> > +{
> > +     return IS_ENABLED(CONFIG_ARM64_PTR_AUTH) &&
> > +             cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH);
> > +}
>
> (mainline has a system_supports_address_auth(), I guess this will be folded
> around a bit during the rebase).
>
> system_supports_ptrauth() that checks the two architected algorithm caps?
yes. I will add.
>
>
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index ab35929..5c47a8f47 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -174,19 +174,25 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  }
> >
> >  /*
> > + * Handle the guest trying to use a ptrauth instruction, or trying to access a
> > + * ptrauth register. This trap should not occur as we enable ptrauth during
> > + * vcpu schedule itself but is anyway kept here for any unfortunate scenario.
>
> ... so we don't need this? Or if it ever runs its indicative of a bug?
Sorry This comment is confusing and is leftover of last V3 version.
>
>
> > + */
> > +void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
> > +{
> > +     if (system_supports_ptrauth())
> > +             kvm_arm_vcpu_ptrauth_enable(vcpu);
> > +     else
> > +             kvm_inject_undefined(vcpu);
> > +}
> > +
> > +/*
> >   * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
> > - * a NOP).
> > + * a NOP), or guest EL1 access to a ptrauth register.
> >   */
> >  static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  {
> > -     /*
> > -      * We don't currently support ptrauth in a guest, and we mask the ID
> > -      * registers to prevent well-behaved guests from trying to make use of
> > -      * it.
> > -      *
> > -      * Inject an UNDEF, as if the feature really isn't present.
> > -      */
> > -     kvm_inject_undefined(vcpu);
> > +     kvm_arm_vcpu_ptrauth_trap(vcpu);
> >       return 1;
> >  }
>
> > diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
> > new file mode 100644
> > index 0000000..1bfaf74
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
> > @@ -0,0 +1,73 @@
>
> > +{
> > +     return vcpu->arch.hcr_el2 & (HCR_API | HCR_APK);
> > +}
>
> (If you include the the IS_ENABLED() in here too, the compiler can work out
> pointer-auth was compiled out and prune all the unused static functions.)
ok.
>
>
> > +#define __ptrauth_save_key(regs, key)                                                \
> > +({                                                                           \
> > +     regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);       \
> > +     regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);       \
> > +})
>
> (shame we can't re-use the arch code's macros for these)
>
>
> > +static __always_inline void __hyp_text __ptrauth_save_state(struct kvm_cpu_context *ctxt)
> > +{
> > +     __ptrauth_save_key(ctxt->sys_regs, APIA);
> > +     __ptrauth_save_key(ctxt->sys_regs, APIB);
> > +     __ptrauth_save_key(ctxt->sys_regs, APDA);
> > +     __ptrauth_save_key(ctxt->sys_regs, APDB);
>
> > +     __ptrauth_save_key(ctxt->sys_regs, APGA);
>
> I thought the generic authentication bits had a separate ID-register-field/cap?
> But you only checked address-auth above. Is it possible the CPU doesn't have
> this register?
Yes it may be possible and generic ptrauth userspace patches by
Kristina has a separate
check for generic key. I will add a similar check here.
>
> (but I think we should only support this if both generic&address are supported)
>
>
> > +}
>
> > +void __hyp_text __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
> > +                                       struct kvm_cpu_context *host_ctxt,
> > +                                       struct kvm_cpu_context *guest_ctxt)
> > +{
> > +     if (!__ptrauth_is_enabled(vcpu))
> > +             return;
> > +
> > +     __ptrauth_save_state(host_ctxt);
> > +     __ptrauth_restore_state(guest_ctxt);
> > +}
> > +
> > +void __hyp_text __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
> > +                                      struct kvm_cpu_context *host_ctxt,
> > +                                      struct kvm_cpu_context *guest_ctxt)
> > +{
> > +     if (!__ptrauth_is_enabled(vcpu))
> > +             return;
> > +
> > +     __ptrauth_save_state(guest_ctxt);
> > +     __ptrauth_restore_state(host_ctxt);
> > +}
>
>
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 85a2a5c..6c57552 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -508,6 +508,8 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
> >       sysreg_restore_guest_state_vhe(guest_ctxt);
> >       __debug_switch_to_guest(vcpu);
> >
> > +     __ptrauth_switch_to_guest(vcpu, host_ctxt, guest_ctxt);
> > +
> >       __set_guest_arch_workaround_state(vcpu);
> >
> >       do {
> > @@ -519,6 +521,8 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
> >
> >       __set_host_arch_workaround_state(vcpu);
> >
> > +     __ptrauth_switch_to_host(vcpu, host_ctxt, guest_ctxt);
> > +
> >       sysreg_save_guest_state_vhe(guest_ctxt);
> >
> >       __deactivate_traps(vcpu);
>
> This is deep in the world-switch code, meaning we save/restore 10 sysregs for
> every entry/exit. As the kernel isn't using pointer-auth, wouldn't it be better
> to defer the save/restore to the preempt notifier using kvm_arch_vcpu_load()?
>
> I've seen the discussion that the kernel may start using this 'soon':
> lore.kernel.org/r/20181112223212.5o4ipc5kt5ziuupt@localhost
>
> (does anyone know when soon is?)
One version is already posted and next version is worked upon.
>
> ... but it doesn't today, and save/restoring these in C becomes impossible when
> that happens, which the arch code is doing too, so we aren't inventing a new
> problem.
Save and restore of key possible in C function with GCC function attribute like
sign-return-address=none. I left the switch function as of now and
only this change is needed
to enable it for kernel ptrauth.
>
>
> probable-tangent: {
> If the kernel starts using ptrauth, it will need to switch these registers in
> the entry asm, and in __cpu_switch_to()... there will be new asm macro's to do this.
>
> Can we make it so that the same series that does that, can easily do KVM too?
Yes it should be possible.
>
> If we use the preempt-notifier stuff the GET/SET_ONE_REG code knows that today
> the ptrauth values are always loaded on the cpu, it doesn't need to look in the
> sys_reg_descs[] array.
> This means the preempt notifier could save/restore them to a struct ptrauth_keys
> in struct kvm_vcpu_arch. This lets us use the arch codes __ptrauth_key_install()
> and ptrauth_keys_switch() helpers today, instead of duplicating them because the
> layout is slightly different.
Since vcpu is a thread so keys are allocated using the current user
ptrauth patches and
I can see in guest switch that has keys are present in guest context.
Do you see advantage
in allocating keys in the above way?
>
> Once these become asm macros, the same structure is already in use, so we can
> (cough) probably feed it a different base pointer for guest-entry/ret_to_user.
> guest-exit would almost be the same as kernel_enter, its only the
> save-guest-values that would be specific to kvm.
yes reusing will be better.
>
> (oh, and the GET/SET_ONE_REG code would need to know to look elsewhere for the
> guest values, but it looks like your patch 5 is already doing some of this).
ok.
>
> }
>
>
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 1ca592d..6af6c7d 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -986,6 +986,32 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >       { SYS_DESC(SYS_PMEVTYPERn_EL0(n)),                                      \
> >         access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
> >
> > +
> > +void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
> > +{
> > +     vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
> > +}
> > +
> > +void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
> > +{
> > +     vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
> > +}
> > +
>
> > @@ -1040,14 +1066,6 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
> >                       kvm_debug("SVE unsupported for guests, suppressing\n");
> >
> >               val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> > -     } else if (id == SYS_ID_AA64ISAR1_EL1) {
> > -             const u64 ptrauth_mask = (0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> > -                                      (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> > -                                      (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> > -                                      (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
>
> Don't we still want to remove the imp-def bits? and the APA/GPA bits if we
> decide there is incomplete support.
I think it was decided to enable all features even though they are not
supported. I cannot find the link though.
>
>
> > -             if (val & ptrauth_mask)
> > -                     kvm_debug("ptrauth unsupported for guests, suppressing\n");
> > -             val &= ~ptrauth_mask;
> >       } else if (id == SYS_ID_AA64MMFR1_EL1) {
> >               if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
> >                       kvm_debug("LORegions unsupported for guests, suppressing\n");
>
>
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index feda456..1f3b6ed 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -388,6 +388,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >               vcpu_clear_wfe_traps(vcpu);
> >       else
> >               vcpu_set_wfe_traps(vcpu);
> > +
> > +     kvm_arm_vcpu_ptrauth_config(vcpu);
>
> (doesn't this unconfigure ptrauth?!)
ok will change the name to something like kvm_arm_vcpu_ptrauth_reset.
>
> >  }
>
> Thanks,
>
> James

//Amit
