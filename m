From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 1/8] arm64: KVM: Use static keys for selecting the GIC
 backend
Date: Fri, 9 Sep 2016 18:06:14 +0100
Message-ID: <57D2EC06.5040709@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
 <1473350810-10857-2-git-send-email-vladimir.murzin@arm.com>
 <57D27EA7.2040500@arm.com> <57D281F1.5000902@arm.com>
 <57D2BCEB.3030306@arm.com> <57D2C469.1030006@arm.com> <57D2D1F0.301@arm.com>
 <57D2D486.3090100@arm.com> <57D2E0C6.1040608@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01A8C410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 12:57:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WBAtpKGYGX6w for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2016 12:57:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B066F40FA2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 12:57:43 -0400 (EDT)
In-Reply-To: <57D2E0C6.1040608@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/09/16 17:18, Vladimir Murzin wrote:
> On 09/09/16 16:25, Marc Zyngier wrote:
>> On 09/09/16 16:14, Vladimir Murzin wrote:
>>> On 09/09/16 15:17, Marc Zyngier wrote:
>>>> On 09/09/16 14:45, Vladimir Murzin wrote:
>>>>> On 09/09/16 10:33, Vladimir Murzin wrote:
>>>>>> Hi Marc,
>>>>>>
>>>>>> On 09/09/16 10:19, Marc Zyngier wrote:
>>>>>>>> Hi Vladimir,
>>>>>>>>
>>>>>> ...
>>>>>>>>>>  =

>>>>>>>>>> +extern struct static_key_false kvm_gicv3_cpuif;
>>>>>>>>
>>>>>>>> I think we should follow the model set by kvm_vgic_global_state, w=
hich
>>>>>>>> is declared in arm_vgic.h. Even better, we should *embed* the stat=
ic key
>>>>>>>> in this structure. This will reduce the clutter and we wouldn't ha=
ve to
>>>>>>>> deal with all the section stuff (the hyp_data thing is a good clea=
nup,
>>>>>>>> but I'd like to see it as a separate patch if possible).
>>>>>> Yes, it is what I was thinking about too, but was not sure about whi=
ch
>>>>>> way to go, so hyp_data seemed me something we might reuse latter.
>>>>>> However, I agree that we can defer hyp_data thing...
>>>>>>
>>>>>
>>>>> I've just tried it out and it seems that static keys are not happy to
>>>>> accept a key after kern_hyp_va is applied at &kvm_vgic_global_state:
>>>>
>>>> Ah, there is a trick. You do not need kern_hyp_va at all, because this
>>>> is not evaluated as an expression at runtime (so the pointer doesn't m=
atter).
>>>>
>>>
>>> Ah, right, thank for a tip! ;)
>>>
>>>>>> In file included from ./include/linux/jump_label.h:105:0,
>>>>>>                  from arch/arm64/kvm/hyp/switch.c:19:
>>>>>> ./arch/arm64/include/asm/jump_label.h: In function =91__guest_run=92:
>>>>>> ./arch/arm64/include/asm/jump_label.h:31:2: warning: asm operand 0 p=
robably doesn=92t match constraints
>>>>>>   asm goto("1: nop\n\t"
>>>>>>   ^
>>>>>> ./arch/arm64/include/asm/jump_label.h:31:2: warning: asm operand 0 p=
robably doesn=92t match constraints
>>>>>>   asm goto("1: nop\n\t"
>>>>>>   ^
>>>>>> ./arch/arm64/include/asm/jump_label.h:31:2: error: impossible constr=
aint in =91asm=92
>>>>>>   asm goto("1: nop\n\t"
>>>>>>   ^
>>>>>> ./arch/arm64/include/asm/jump_label.h:31:2: error: impossible constr=
aint in =91asm=92
>>>>>>   asm goto("1: nop\n\t"
>>>>>>   ^
>>>>>> make[1]: *** [arch/arm64/kvm/hyp/switch.o] Error 1
>>>>>> make: *** [arch/arm64/kvm/hyp/switch.o] Error 2
>>>>>
>>>>> it looks like we cannot avoid hyp_data thing... if you don't mind I c=
an
>>>>> do hyp_data clean-up in separate patch. Alternatively, we can do
>>>>> conversion to static keys for both architectures later as an
>>>>> optimisation step.
>>>>
>>>> Can you try the above first? I've just tried the same approach with my
>>>> vgic-trap series, and it compiles fine (untested though):
>>>
>>> I was about to try it out, but didn't manage to find a branch with
>>> vgic-trap series, so I did a quick fixup for my series and now it is
>>> running non-VHE boot tests and I don't expect issues with VHE one. I
>>> think diff bellow should work runtime too, but if you do want me to give
>>> it a try it'd be handy to have a branch I can pull from ;)
>>
>> I think Christoffer has pulled it into kvmarm/queue.
> =

> Nothing has exploded so far for both architectures.

Great. Hopefully you can respin the series next week.

Thanks,

	M.
-- =

Jazz is not dead. It just smells funny...
