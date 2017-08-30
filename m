From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: stop propagating DAIF flags between kernel
 and VHE's world switch
Date: Wed, 30 Aug 2017 19:01:39 +0100
Message-ID: <59A6FD83.2090904@arm.com>
References: <20170810113021.1110-1-james.morse@arm.com>
 <20170824152304.GB2150@lvm> <59A5A021.1090102@arm.com>
 <20170830083317.GB24522@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85BA240C5A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 14:00:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eW1eJFA+kU8W for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Aug 2017 14:00:48 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BDE140017
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 14:00:48 -0400 (EDT)
In-Reply-To: <20170830083317.GB24522@cbox>
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
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 30/08/17 09:33, Christoffer Dall wrote:
> On Tue, Aug 29, 2017 at 06:10:57PM +0100, James Morse wrote:
>> On 24/08/17 16:23, Christoffer Dall wrote:
>>> On Thu, Aug 10, 2017 at 12:30:21PM +0100, James Morse wrote:
>>>> debug exceptions remain disabled due to the guest exit exception,
>>>> (as does SError: today this is the only time SError is unmasked in the
>>>> kernel). The flags stay in this state until we return to userspace.
>>>>
>>>> We have a __vhe_hyp_call() function that does the isb that we implicitly
>>>> have on non-vhe systems, add the DAIF save/restore here, instead of in
>>>> __sysreg_{save,restore}_host_state() which would require an extra isb()
>>>> between the hosts VBAR_EL1 being restored and DAIF being restored.
>>
>>> This also means that anyone else calling kvm_call_hyp(), which we are
>>> beginning to do more often, would also do this save/restore which
>>> shouldn't really be necessary, doesn't it?
>>
>> I think it is, its done implicitly via SPSR_EL2 by the HVC/ERET on non-VHE.
>> Does the HYP code on the other end of kvm_call_hyp() expect to be called with
>> DAIF masked? What about the other way, if the HYP code modifies the DAIF flags
>> should that spread back into the kernel?
> 
> Well, for VHE I don't think this is any different than any other
> function.  There really is no concept of 'hyp code' --- or we should aim
> for there not to be --- with VHE, so if some code expects interrupts
> disabled or other changes to the DAIF flags, that code should really do
> that for VHE.

Aha, this is where I see the world differently.
/me adjusts world-view,

I will scrap this patch and re-do it along these lines.


> The rationale being that in the long run we want to keep "jumping to
> hyp" the oddball legacy case, where everything else is just the
> kernel/hypervisor functionality.

This makes sense.


[ ... trims your excellent argument ... ]


> Have we actually looked at the places where we call kvm_call_hyp() and
> do they require a different setting of the DAIF flags from other kernel
> code running at EL2 with VHE ?

I can go through them, but I think its just world-switch as it modifies
debug-registers, vbar_el1 and enters/exits the guest.


> I understand that the behavior is currently different, but what I'm
> asking is, instead of having to save and restore anything to the stack,
> can you simply do:
> 
>      __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>      {
>          if (has_vhe())
>              asm("msr     daifset, #0xf");
> 
> 	...
>         exit_code = __guest_enter(vcpu, host_ctxt);
> 	...
> 
> 	if (has_vhe())
>              asm("msr     daifclr, #0xd");
>      }

Sure, this can be done as late as setting vbar_el1 for VHE, at which point the
reason for masking these is clear. Before this point the hosts vectors will
happily handle debug/fiq/serror.

Your right KVM can 'just know' the values to set so the noise around


> (not sure about the FIQ flag - does the kernel usually 

This is some of the stuff we need to clear up. Today we never expect SError or
FIQ and should panic() if we get one. But these flags are largely ignored so
when the CPU masks them on exception we leave them like that.
After the SError rework process-context should have everything unmasked, today
its just debug+irqs unmasked.


Sorry if this email exchange has been frustrating, I didn't have your view of
where all this should end up.


Thanks,

James
