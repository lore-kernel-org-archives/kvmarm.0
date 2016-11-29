From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Access CNTHCTL_EL2 bit fields correctly
Date: Tue, 29 Nov 2016 10:53:28 +0000
Message-ID: <cc94fa75-b073-6600-e7b0-d72f4d7e8ca0@arm.com>
References: <1480351570-11648-1-git-send-email-jintack@cs.columbia.edu>
 <d04fd17e-9157-07fe-4daa-9dbab149b5e6@arm.com>
 <799d03f5-a929-9547-1ae7-94026b76f116@arm.com> <20161128194221.GG18170@cbox>
 <c75fe6ae-8ae0-285d-6f47-3e28c7e8f431@arm.com> <20161129104753.GA15346@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161129104753.GA15346@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Jintack Lim <jintack@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, julien.grall@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 29/11/16 10:47, Christoffer Dall wrote:
> On Tue, Nov 29, 2016 at 09:37:07AM +0000, Marc Zyngier wrote:
>> On 28/11/16 19:42, Christoffer Dall wrote:
>>> On Mon, Nov 28, 2016 at 06:39:04PM +0000, Marc Zyngier wrote:
>>>> On 28/11/16 17:43, Marc Zyngier wrote:
>>>>> Hi Jintack,
>>>>>
>>>>> On 28/11/16 16:46, Jintack Lim wrote:
>>>>>> Bit positions of CNTHCTL_EL2 are changing depending on HCR_EL2.E2H bit.
>>>>>> EL1PCEN and EL1PCTEN are 1st and 0th bits when E2H is not set, but they
>>>>>> are 11th and 10th bits respectively when E2H is set.  Current code is
>>>>>> unintentionally setting wrong bits to CNTHCTL_EL2 with E2H set, which
>>>>>> may allow guest OS to access physical timer. So, fix it.
>>>>>>
>>>>>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>>>>>> ---
>>>>>>  arch/arm/include/asm/kvm_timer.h     | 33 +++++++++++++++++++
>>>>>>  arch/arm64/include/asm/kvm_timer.h   | 62 ++++++++++++++++++++++++++++++++++++
>>>>>>  include/clocksource/arm_arch_timer.h |  6 ++--
>>>>>>  virt/kvm/arm/hyp/timer-sr.c          |  8 ++---
>>>>>>  4 files changed, 103 insertions(+), 6 deletions(-)
>>>>>>  create mode 100644 arch/arm/include/asm/kvm_timer.h
>>>>>>  create mode 100644 arch/arm64/include/asm/kvm_timer.h
>>>>>>
>>>>
>>>> [...]
>>>>
>>>>> We could make it nicer (read "faster") by introducing a
>>>>> hyp_alternate_select construct that only returns a value instead
>>>>> of calling a function. I remember writing something like that
>>>>> at some point, and dropping it...
>>>>
>>>> So here's what this could look like (warning, wacky code ahead,
>>>> though I fixed a stupid bug that was present in the previous patch).
>>>> The generated code is quite nice (no branch, only an extra mov
>>>> instruction on the default path)... Of course, completely untested!
>>>
>>> Isn't this all about determining which bitmask to use, statically, once,
>>> after the system has booted?
>>>
>>> How about a good old fashioned static variable, or global struct like
>>> the global one we use for the VGIC, which sets the proper mit mask
>>> during kvm init, and the world-switch code just uses a variable?
>>
>> We could indeed do that (I've been carried away with my tendency for
>> weird and wonderful hacks).
>>
>> But as Jintack mentioned, there is a much better approach, which is to
>> do nothing at all on the VHE path (we can set the permission bits once
>> and for all). cntvoff_el2 also falls into the same category of things we
>> should be able to only restore and not bother resetting (as it doesn't
>> affect the EL2 virtual counter).
>>
>> Thoughts?
>>
> Yes, that sounds much better.
> 
> I have some patches to get rid of a lot of things, like cntvoff, during
> the world-switch for VHE, so if Jintack just wants to focus on the
> cnthctl I will catch cntvoff later.

Sound good to me.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
