From: Jintack Lim <jintack.lim@linaro.org>
Subject: Re: [RFC 06/55] KVM: arm64: Add EL2 execution context for nesting
Date: Mon, 3 Jul 2017 10:44:51 -0400
Message-ID: <CAHyh4xhCsEONTyTd1NQj_2O3uGjZUnsK-TJQPTGXx=aqzdmBiw@mail.gmail.com>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-7-git-send-email-jintack@cs.columbia.edu>
 <20170222111017.GB26976@cbox>
 <CAHyh4xjOvAgqQ+WLD3SHyNHXOFSuoKGu4sV+GaFm-LdEcoGYwA@mail.gmail.com>
 <20170703090344.GF4066@cbox> <9714b524-eb95-d9af-f394-5a71b3eb7f75@arm.com>
 <20170703095427.GI4066@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C26B40D1A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 10:44:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7iYCalLm-YGI for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jul 2017 10:44:36 -0400 (EDT)
Received: from mail-oi0-f44.google.com (mail-oi0-f44.google.com
 [209.85.218.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BB2140CE9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 10:44:35 -0400 (EDT)
Received: by mail-oi0-f44.google.com with SMTP id p188so81959059oia.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Jul 2017 07:44:55 -0700 (PDT)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com.
 [209.85.218.49])
 by smtp.gmail.com with ESMTPSA id p7sm20837631oia.21.2017.07.03.07.44.52
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 03 Jul 2017 07:44:52 -0700 (PDT)
Received: by mail-oi0-f49.google.com with SMTP id l130so83098903oib.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Jul 2017 07:44:52 -0700 (PDT)
In-Reply-To: <20170703095427.GI4066@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: KVM General <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kevin.brodsky@arm.com, wcohen@redhat.com, anna-maria@linutronix.de, geoff@infradead.org, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Thanks Christoffer and Marc,

On Mon, Jul 3, 2017 at 5:54 AM, Christoffer Dall <cdall@linaro.org> wrote:
> On Mon, Jul 03, 2017 at 10:32:45AM +0100, Marc Zyngier wrote:
>> On 03/07/17 10:03, Christoffer Dall wrote:
>> > On Mon, Jun 26, 2017 at 10:33:23AM -0400, Jintack Lim wrote:
>> >> Hi Christoffer,
>> >>
>> >> On Wed, Feb 22, 2017 at 6:10 AM, Christoffer Dall <cdall@linaro.org> wrote:
>> >>> On Mon, Jan 09, 2017 at 01:24:02AM -0500, Jintack Lim wrote:
>> >>>> With the nested virtualization support, the context of the guest
>> >>>> includes EL2 register states. The host manages a set of virtual EL2
>> >>>> registers.  In addition to that, the guest hypervisor supposed to run in
>> >>>> EL2 is now deprivilaged and runs in EL1. So, the host also manages a set
>> >>>> of shadow system registers to be able to run the guest hypervisor in
>> >>>> EL1.
>> >>>>
>> >>>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>> >>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> >>>> ---
>> >>>>  arch/arm64/include/asm/kvm_host.h | 54 +++++++++++++++++++++++++++++++++++++++
>> >>>>  1 file changed, 54 insertions(+)
>> >>>>
>> >>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> >>>> index c0c8b02..ed78d73 100644
>> >>>> --- a/arch/arm64/include/asm/kvm_host.h
>> >>>> +++ b/arch/arm64/include/asm/kvm_host.h
>> >>>> @@ -146,6 +146,42 @@ enum vcpu_sysreg {
>> >>>>       NR_SYS_REGS     /* Nothing after this line! */
>> >>>>  };
>> >>>>
>> >>>> +enum el2_regs {
>> >>>> +     ELR_EL2,
>> >>>> +     SPSR_EL2,
>> >>>> +     SP_EL2,
>> >>>> +     AMAIR_EL2,
>> >>>> +     MAIR_EL2,
>> >>>> +     TCR_EL2,
>> >>>> +     TTBR0_EL2,
>> >>>> +     VTCR_EL2,
>> >>>> +     VTTBR_EL2,
>> >>>> +     VMPIDR_EL2,
>> >>>> +     VPIDR_EL2,      /* 10 */
>> >>>> +     MDCR_EL2,
>> >>>> +     CNTHCTL_EL2,
>> >>>> +     CNTHP_CTL_EL2,
>> >>>> +     CNTHP_CVAL_EL2,
>> >>>> +     CNTHP_TVAL_EL2,
>> >>>> +     CNTVOFF_EL2,
>> >>>> +     ACTLR_EL2,
>> >>>> +     AFSR0_EL2,
>> >>>> +     AFSR1_EL2,
>> >>>> +     CPTR_EL2,       /* 20 */
>> >>>> +     ESR_EL2,
>> >>>> +     FAR_EL2,
>> >>>> +     HACR_EL2,
>> >>>> +     HCR_EL2,
>> >>>> +     HPFAR_EL2,
>> >>>> +     HSTR_EL2,
>> >>>> +     RMR_EL2,
>> >>>> +     RVBAR_EL2,
>> >>>> +     SCTLR_EL2,
>> >>>> +     TPIDR_EL2,      /* 30 */
>> >>>> +     VBAR_EL2,
>> >>>> +     NR_EL2_REGS     /* Nothing after this line! */
>> >>>> +};
>> >>>
>> >>> Why do we have a separate enum and array for the EL2 regs and not simply
>> >>> expand vcpu_sysreg ?
>> >>
>> >> We can expand vcpu_sysreg for the EL2 system registers. For SP_EL2,
>> >> SPSR_EL2, and ELR_EL2, where is the good place to locate them?.
>> >> SP_EL1, SPSR_EL1, and ELR_EL1 registers are saved in the kvm_regs
>> >> structure instead of sysregs[], so I wonder it's better to put them in
>> >> kvm_regs, too.
>> >>
>> >> BTW, what's the reason that those EL1 registers are in kvm_regs
>> >> instead of sysregs[] in the first place?
>> >>
>> >
>> > This has mostly to do with the way we export things to userspace, and
>> > for historical reasons.
>> >
>> > So we should either expand kvm_regs with the non-sysregs EL2 registers
>> > and expand sys_regs with the EL2 sysregs, or we should put everything
>> > EL2 into an EL2 array.  I feel like the first solution will fit more
>> > nicely into the current design, but I don't have a very strong
>> > preference.
>> >
>> > You should look at the KVM_{GET,SET}_ONE_REG API definition and think
>> > about how your choice will fit with this.
>> >
>> > Marc, any preference?
>>
>> My worry is that by changing kvm_regs, we're touching a userspace
>> visible structure. I'm not sure we can avoid it, but I'd like to avoid
>> putting too much there (SPSR_EL2 and ELR_EL2 should be enough). I just
>> had a panic moment when realizing that this structure is not versioned,
>> but the whole ONE_REG API seems to save us from a complete disaster.
>>
>> Overall, having kvm_regs as a UAPI visible thing retrospectively strikes
>> me as a dangerous design, as we cannot easily expand it. Maybe we should
>> consider having a kvm_regs_v2 that embeds kvm_regs, and not directly
>> expose it to userspace (but instead expose the indexes in that
>> structure)? Userspace that knows how to deal with EL2 will use the new
>> indexes, while existing SW will carry on using the EL1/EL0 version.
>
> We definitely cannot expand kvm_regs, that would lead to all sorts of
> potential errors, as you correctly point out.

Ok. I didn't know that kvm_regs are exposed to the user space.

>
> So we probably need something like that, or simply let it stay the way
> it is for now, and add el2_core_regs as a separate thing to the vcpu and
> only expose the indexes and encoding for those registers?
>

Sounds good to me.

So, expand sys_regs with the EL2 sysregs and put the special purpose
registers, which is the term used in ARM ARM, such as SPSR_EL2,
ELR_EL2 and SP_EL2 into el2_core_regs or el2_special_regs, right?

>>
>> sysregs are easier to deal with, as they are visible through their
>> encoding, and we can place the anywhere we want. sys_regs is as good a
>> location as any.
>>
>
> Agreed.
>
> Thanks,
> -Christoffer
