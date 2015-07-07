From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: Re: [PATCH v3 08/11] KVM: arm: implement dirty bit mechanism for debug registers
Date: Tue, 07 Jul 2015 18:06:57 +0800
Message-ID: <5A7DE9A0-E7A6-40B0-80F9-896F7DED0E47@linaro.org>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org> <1434969694-7432-9-git-send-email-zhichao.huang@linaro.org> <20150630092020.GP11332@cbox> <B3B5AB0D-020C-483D-A6DE-76E355865010@linaro.org> <20150703115611.GB14220@lvm>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150703115611.GB14220@lvm>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, Christoffer Dall <christoffer.dall@linaro.org>, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi, Will,

Chazy and me are talking about how to reduce the saving/restoring
overhead for debug registers.
We want to add a state in hw_breakpoint.c to indicate whether the host
enable any hwbrpts or not (might export a fuction that kvm can call),
then we can read this state from memory instead of reading from real
hardware registers, and to decide whether we need a world switch or
not.
Does it acceptable?


On July 3, 2015 7:56:11 PM GMT+08:00, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>On Fri, Jul 03, 2015 at 05:54:47PM +0800, Zhichao Huang wrote:
>> 
>> 
>> On June 30, 2015 5:20:20 PM GMT+08:00, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>> >On Mon, Jun 22, 2015 at 06:41:31PM +0800, Zhichao Huang wrote:
>> >> The trapping code keeps track of the state of the debug registers,
>> >> allowing for the switch code to implement a lazy switching strategy.
>> >> 
>> >> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
>> >> ---
>> >>  arch/arm/include/asm/kvm_asm.h  |  3 +++
>> >>  arch/arm/include/asm/kvm_host.h |  3 +++
>> >>  arch/arm/kernel/asm-offsets.c   |  1 +
>> >>  arch/arm/kvm/coproc.c           | 39 ++++++++++++++++++++++++++++++++++++--
>> >>  arch/arm/kvm/interrupts_head.S  | 42 +++++++++++++++++++++++++++++++++++++++++
>> >>  5 files changed, 86 insertions(+), 2 deletions(-)
>> >> 
>> >> diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
>> >> index ba65e05..4fb64cf 100644
>> >> --- a/arch/arm/include/asm/kvm_asm.h
>> >> +++ b/arch/arm/include/asm/kvm_asm.h
>> >> @@ -64,6 +64,9 @@
>> >>  #define cp14_DBGDSCRext	65	/* Debug Status and Control external */
>> >>  #define NR_CP14_REGS	66	/* Number of regs (incl. invalid) */
>> >>  
>> >> +#define KVM_ARM_DEBUG_DIRTY_SHIFT	0
>> >> +#define KVM_ARM_DEBUG_DIRTY		(1 << KVM_ARM_DEBUG_DIRTY_SHIFT)
>> >> +
>> >>  #define ARM_EXCEPTION_RESET	  0
>> >>  #define ARM_EXCEPTION_UNDEFINED   1
>> >>  #define ARM_EXCEPTION_SOFTWARE    2
>> >> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> >> index 3d16820..09b54bf 100644
>> >> --- a/arch/arm/include/asm/kvm_host.h
>> >> +++ b/arch/arm/include/asm/kvm_host.h
>> >> @@ -127,6 +127,9 @@ struct kvm_vcpu_arch {
>> >>  	/* System control coprocessor (cp14) */
>> >>  	u32 cp14[NR_CP14_REGS];
>> >>  
>> >> +	/* Debug state */
>> >> +	u32 debug_flags;
>> >> +
>> >>  	/*
>> >>  	 * Anything that is not used directly from assembly code goes
>> >>  	 * here.
>> >> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
>> >> index 9158de0..e876109 100644
>> >> --- a/arch/arm/kernel/asm-offsets.c
>> >> +++ b/arch/arm/kernel/asm-offsets.c
>> >> @@ -185,6 +185,7 @@ int main(void)
>> >>    DEFINE(VCPU_FIQ_REGS,		offsetof(struct kvm_vcpu,
>> >arch.regs.fiq_regs));
>> >>    DEFINE(VCPU_PC,		offsetof(struct kvm_vcpu,
>> >arch.regs.usr_regs.ARM_pc));
>> >>    DEFINE(VCPU_CPSR,		offsetof(struct kvm_vcpu,
>> >arch.regs.usr_regs.ARM_cpsr));
>> >> +  DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu,
>> >arch.debug_flags));
>> >>    DEFINE(VCPU_HCR,		offsetof(struct kvm_vcpu, arch.hcr));
>> >>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
>> >>    DEFINE(VCPU_HSR,		offsetof(struct kvm_vcpu, arch.fault.hsr));
>> >> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
>> >> index eeee648..fc0c2ef 100644
>> >> --- a/arch/arm/kvm/coproc.c
>> >> +++ b/arch/arm/kvm/coproc.c
>> >> @@ -220,14 +220,49 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
>> >>  	return true;
>> >>  }
>> >>  
>> >> +/*
>> >> + * We want to avoid world-switching all the DBG registers all the
>> >> + * time:
>> >> + *
>> >> + * - If we've touched any debug register, it is likely that we're
>> >> + *   going to touch more of them. It then makes sense to disable the
>> >> + *   traps and start doing the save/restore dance
>> >> + * - If debug is active (ARM_DSCR_MDBGEN set), it is then mandatory
>> >> + *   to save/restore the registers, as the guest depends on them.
>> >> + *
>> >> + * For this, we use a DIRTY bit, indicating the guest has modified the
>> >> + * debug registers, used as follow:
>> >> + *
>> >> + * On guest entry:
>> >> + * - If the dirty bit is set (because we're coming back from trapping),
>> >> + *   disable the traps, save host registers, restore guest registers.
>> >> + * - If debug is actively in use (ARM_DSCR_MDBGEN set),
>> >> + *   set the dirty bit, disable the traps, save host registers,
>> >> + *   restore guest registers.
>> >> + * - Otherwise, enable the traps
>> >> + *
>> >> + * On guest exit:
>> >> + * - If the dirty bit is set, save guest registers, restore host
>> >> + *   registers and clear the dirty bit. This ensure that the host can
>> >> + *   now use the debug registers.
>> >> + *
>> >> + * Notice:
>> >> + * - For ARMv7, if the CONFIG_HAVE_HW_BREAKPOINT is set in the guest,
>> >> + *   debug is always actively in use (ARM_DSCR_MDBGEN set).
>> >> + *   We have to do the save/restore dance in this case, because the
>> >> + *   host and the guest might use their respective debug registers
>> >> + *   at any moment.
>> >
>> >so doesn't this pretty much invalidate the whole saving/dirty effort?
>> >
>> >Guests configured from for example multi_v7_defconfig will then act
>> >like
>> >this and you will save/restore all these registers always.
>> >
>> >Wouldn't a better approach be to enable trapping to hyp mode most of
>> >the
>> >time, and simply clear the enabled bit of any host-used break- or
>> >wathcpoints upon guest entry, perhaps maintaining a bitmap of which
>> >ones
>> >must be re-set when exiting the guest, and thereby drastically
>reducing
>> >the amount of save/restore code you'd have to perform.
>> >
>> >Of course, you'd also have to keep track of whether the guest has any
>> >breakpoints or watchpoints enabled for when you do the full
>> >save/restore
>> >dance.
>> >
>> >That would also avoid all issues surrounding accesses to DBGDSCRext
>> >register I think.
>> 
>> I have thought about it, which means to say, "Since we can't find
>> whether the guest has any hwbrpts enabled from the DBGDSCR, why
>> don't we find it from the DBGBCR and DBGWCR?".
>> 
>> Case 1: The host and the guest enable all the hwbrpts.
>> It's necessary to world switch the debug registers all the time.
>> 
>> Case 2: The host and the guest enable some of the hwbrpts.
>> It's necessary to world switch the debug registers which are enabled.
>> But if we want skip thouse registers which aren't enabled, we have to
>> keep track of all the debug states both in the host and the guest.
>> We need to judge which debug registers we should switch, and which
>> not. It may bring in a complex logic in the assembly code. And if the
>> host or guest enabled almost all of the hwbrpts, this operation may
>> bring in the loss outweights the grain.
>> Is it acceptable and worthy? If yes, I will do it.
>> 
>> Case 3: Neither the host nor the guest enable any hwbrpts.
>> It's the case that we can skip the whole world switch thing.
>> The only problem is that we have to read all the debug registers on each
>> guest entry to find whether the host enable any hwbrpts or not.
>> But this case is a normal case, which is worthy to do the efforts to
>> reduce the saving/restoring overhead.
>> 
>I would never try to do a partial save/restore, just look at the
>control registers to see if anything is enabled as an indication of
>whether or not we need to do the save/restore of all the registers and
>disable trapping.
>
>Reading the guest control registers (from memory) only should be much
>faster than saving/restoring the whole lot.  Perhaps there's even a
>hook
>in Linux to figure out if any of the registers are being used?
>
>Thanks,
>-Christoffer

-- 
Zhichao Huang
