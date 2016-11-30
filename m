From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Access CNTHCTL_EL2 bit fields correctly
Date: Wed, 30 Nov 2016 13:31:43 +0000
Message-ID: <129e316b-0a05-9114-f29f-c8935144720c@arm.com>
References: <1480351570-11648-1-git-send-email-jintack@cs.columbia.edu>
 <d04fd17e-9157-07fe-4daa-9dbab149b5e6@arm.com>
 <799d03f5-a929-9547-1ae7-94026b76f116@arm.com>
 <CAHyh4xhXoFWsbnNNePthWp2-ZAOtCuUVmLn-JKRe4sc=nqrYNw@mail.gmail.com>
 <0a475329-6f50-42ae-3244-f0767c56ce09@arm.com>
 <ee2dacff-691c-7548-ff71-3a992f399333@arm.com>
 <CAHyh4xi2oq8m2B_3oZu+BNeyk-++L2ziMY66+XZ+SDRjOHDN6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAHyh4xi2oq8m2B_3oZu+BNeyk-++L2ziMY66+XZ+SDRjOHDN6A@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Jintack Lim <jintack@cs.columbia.edu>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: KVM General <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 29/11/16 21:05, Jintack Lim wrote:
> On Tue, Nov 29, 2016 at 11:53 AM, Suzuki K Poulose
> <suzuki.poulose@arm.com> wrote:
>> On 29/11/16 09:36, Marc Zyngier wrote:
>>>
>>> On 29/11/16 03:28, Jintack Lim wrote:
>>>>
>>>> On Mon, Nov 28, 2016 at 1:39 PM, Marc Zyngier <marc.zyngier@arm.com>
>>>> wrote:
>>>>>
>>>>> On 28/11/16 17:43, Marc Zyngier wrote:
>>>>
>>>> This looks much cleaner than my patch.
>>>> While we are at it, is it worth to consider that we just need to set
>>>> those bits once for VHE case, not for every world switch as an
>>>> optimization?
>>>
>>>
>>> Ah! That's a much better idea indeed! And we could stop messing with
>>> cntvoff_el2 as well, as it doesn't need to be restored to zero on exit.
>>> Could you try and respin something along those lines?
>>>
>>
>> fyi, we have a static_key based cpus_have_const_cap() for Constant cap
>> checking (like this case) available in linux-next. May be you could make use
>> of that instead of alternatives.
> 
> Thanks Suzuki. This looks very useful.
> 
> Marc, can I write a patch based on linux-next? The commit which has
> cpus_have_const_cap() is not in master and next branch in kvm/arm
> repo.

You can. It is just that I won't be able to apply it immediately (I'll
wait for -rc1 to be out, and send it as a fix).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
