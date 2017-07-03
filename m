From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC 06/55] KVM: arm64: Add EL2 execution context for nesting
Date: Mon, 3 Jul 2017 10:32:45 +0100
Message-ID: <9714b524-eb95-d9af-f394-5a71b3eb7f75@arm.com>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-7-git-send-email-jintack@cs.columbia.edu>
 <20170222111017.GB26976@cbox>
 <CAHyh4xjOvAgqQ+WLD3SHyNHXOFSuoKGu4sV+GaFm-LdEcoGYwA@mail.gmail.com>
 <20170703090344.GF4066@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170703090344.GF4066@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, Jintack Lim <jintack.lim@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux@armlinux.org.uk, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, vladimir.murzin@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, anna-maria@linutronix.de, Shih-Wei Li <shihwei@cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, KVM General <kvm@vger.kernel.org>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/07/17 10:03, Christoffer Dall wrote:
> On Mon, Jun 26, 2017 at 10:33:23AM -0400, Jintack Lim wrote:
>> Hi Christoffer,
>>
>> On Wed, Feb 22, 2017 at 6:10 AM, Christoffer Dall <cdall@linaro.org> wrote:
>>> On Mon, Jan 09, 2017 at 01:24:02AM -0500, Jintack Lim wrote:
>>>> With the nested virtualization support, the context of the guest
>>>> includes EL2 register states. The host manages a set of virtual EL2
>>>> registers.  In addition to that, the guest hypervisor supposed to run in
>>>> EL2 is now deprivilaged and runs in EL1. So, the host also manages a set
>>>> of shadow system registers to be able to run the guest hypervisor in
>>>> EL1.
>>>>
>>>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>>> ---
>>>>  arch/arm64/include/asm/kvm_host.h | 54 +++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 54 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>> index c0c8b02..ed78d73 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -146,6 +146,42 @@ enum vcpu_sysreg {
>>>>       NR_SYS_REGS     /* Nothing after this line! */
>>>>  };
>>>>
>>>> +enum el2_regs {
>>>> +     ELR_EL2,
>>>> +     SPSR_EL2,
>>>> +     SP_EL2,
>>>> +     AMAIR_EL2,
>>>> +     MAIR_EL2,
>>>> +     TCR_EL2,
>>>> +     TTBR0_EL2,
>>>> +     VTCR_EL2,
>>>> +     VTTBR_EL2,
>>>> +     VMPIDR_EL2,
>>>> +     VPIDR_EL2,      /* 10 */
>>>> +     MDCR_EL2,
>>>> +     CNTHCTL_EL2,
>>>> +     CNTHP_CTL_EL2,
>>>> +     CNTHP_CVAL_EL2,
>>>> +     CNTHP_TVAL_EL2,
>>>> +     CNTVOFF_EL2,
>>>> +     ACTLR_EL2,
>>>> +     AFSR0_EL2,
>>>> +     AFSR1_EL2,
>>>> +     CPTR_EL2,       /* 20 */
>>>> +     ESR_EL2,
>>>> +     FAR_EL2,
>>>> +     HACR_EL2,
>>>> +     HCR_EL2,
>>>> +     HPFAR_EL2,
>>>> +     HSTR_EL2,
>>>> +     RMR_EL2,
>>>> +     RVBAR_EL2,
>>>> +     SCTLR_EL2,
>>>> +     TPIDR_EL2,      /* 30 */
>>>> +     VBAR_EL2,
>>>> +     NR_EL2_REGS     /* Nothing after this line! */
>>>> +};
>>>
>>> Why do we have a separate enum and array for the EL2 regs and not simply
>>> expand vcpu_sysreg ?
>>
>> We can expand vcpu_sysreg for the EL2 system registers. For SP_EL2,
>> SPSR_EL2, and ELR_EL2, where is the good place to locate them?.
>> SP_EL1, SPSR_EL1, and ELR_EL1 registers are saved in the kvm_regs
>> structure instead of sysregs[], so I wonder it's better to put them in
>> kvm_regs, too.
>>
>> BTW, what's the reason that those EL1 registers are in kvm_regs
>> instead of sysregs[] in the first place?
>>
> 
> This has mostly to do with the way we export things to userspace, and
> for historical reasons.
> 
> So we should either expand kvm_regs with the non-sysregs EL2 registers
> and expand sys_regs with the EL2 sysregs, or we should put everything
> EL2 into an EL2 array.  I feel like the first solution will fit more
> nicely into the current design, but I don't have a very strong
> preference.
> 
> You should look at the KVM_{GET,SET}_ONE_REG API definition and think
> about how your choice will fit with this.
> 
> Marc, any preference?

My worry is that by changing kvm_regs, we're touching a userspace
visible structure. I'm not sure we can avoid it, but I'd like to avoid
putting too much there (SPSR_EL2 and ELR_EL2 should be enough). I just
had a panic moment when realizing that this structure is not versioned,
but the whole ONE_REG API seems to save us from a complete disaster.

Overall, having kvm_regs as a UAPI visible thing retrospectively strikes
me as a dangerous design, as we cannot easily expand it. Maybe we should
consider having a kvm_regs_v2 that embeds kvm_regs, and not directly
expose it to userspace (but instead expose the indexes in that
structure)? Userspace that knows how to deal with EL2 will use the new
indexes, while existing SW will carry on using the EL1/EL0 version.

sysregs are easier to deal with, as they are visible through their
encoding, and we can place the anywhere we want. sys_regs is as good a
location as any.

Thoughts?

	M.
-- 
Jazz is not dead. It just smells funny...
