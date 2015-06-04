From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH] KVM: arm64: fix misleading comments in save/restore
Date: Thu, 04 Jun 2015 11:20:33 +0100
Message-ID: <87eglrbwr2.fsf@linaro.org>
References: <1432806186-27993-1-git-send-email-alex.bennee@linaro.org> <20150604093436.GC7657@cbox> <55702205.7000908@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55702205.7000908@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu


Marc Zyngier <marc.zyngier@arm.com> writes:

> On 04/06/15 10:34, Christoffer Dall wrote:
>> On Thu, May 28, 2015 at 10:43:06AM +0100, Alex Benn=C3=A9e wrote:
>>> The elr_el2 and spsr_el2 registers in fact contain the processor st=
ate
>>> before entry into the hypervisor code.
>>=20
>> be careful with your use of the hypervisor, in the KVM design the
>> hypervisor is split across EL1 and EL2.

"before entry into EL2."

>>=20
>>> In the case of guest state it
>>> could be in either el0 or el1.
>>=20
>> true
>>=20
>>>
>>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>> ---
>>>  arch/arm64/kvm/hyp.S | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
>>> index d755922..1940a4c 100644
>>> --- a/arch/arm64/kvm/hyp.S
>>> +++ b/arch/arm64/kvm/hyp.S
>>> @@ -50,8 +50,8 @@
>>>  	stp	x29, lr, [x3, #80]
>>> =20
>>>  	mrs	x19, sp_el0
>>> -	mrs	x20, elr_el2		// EL1 PC
>>> -	mrs	x21, spsr_el2		// EL1 pstate
>>> +	mrs	x20, elr_el2		// PC before hyp entry
>>> +	mrs	x21, spsr_el2		// pstate before hyp entry
>>> =20
>>>  	stp	x19, x20, [x3, #96]
>>>  	str	x21, [x3, #112]
>>> @@ -82,8 +82,8 @@
>>>  	ldr	x21, [x3, #16]
>>> =20
>>>  	msr	sp_el0, x19
>>> -	msr	elr_el2, x20 				// EL1 PC
>>> -	msr	spsr_el2, x21 				// EL1 pstate
>>> +	msr	elr_el2, x20 		// PC to restore
>>> +	msr	spsr_el2, x21 		// pstate to restore
>>=20
>> I don't feel like 'to restore' is much more meaningful here.
>>=20
>> I would actually vote for removin the comments all together, since o=
ne
>> should really understand the code as opposed to the comments when
>> reading this kind of stuff.
>>=20
>> Meh, I'm not sure.  Your patch is definitely better than doing nothi=
ng.
>>=20
>> Marc?
>
> While I definitely agree that people should pay more attention to the
> code rather than blindly trusting comments, I still think there is so=
me
> value in disambiguating the exception entry/return, because this bit =
of
> code assumes some intimate knowledge of the ARMv8 exception model.
>
> As for the comments themselves, I'd rather have some wording that
> clearly indicate that we're dealing with guest information, i.e:
>
> 	mrs	x20, elr_el2		// Guest PC
> 	mrs	x21, spsr_el2		// Guest pstate
>
> (and the same for the exception return). The "before hyp entry" and "=
to
> restore" are not really useful (all the registers we are
> saving/restoring fall into these categories). What I wanted to convey
> here was that despite using an EL2 register, we are dealing with gues=
t
> registers.

Which would be great it we were. However the code is used to
save/restore the host context as well as the guest context hence my
weasely words.=20

>
> Would this address your concerns?
>
> Thanks,
>
> 	M.

--=20
Alex Benn=C3=A9e
