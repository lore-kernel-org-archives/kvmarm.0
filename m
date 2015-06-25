From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Thu, 25 Jun 2015 13:40:41 +0100
Message-ID: <558BF6C9.3000009@arm.com>
References: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com> <CAFEAcA92uymQ3LjPQnuFiwvjSgc+jY54VrfK_Sh4v1DJ+=OPpw@mail.gmail.com> <558A6A84.5020603@arm.com> <20150624085128.GA22785@cbox> <558A7936.7020109@arm.com> <20150625123034.GE28244@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150625123034.GE28244@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, Suzuki Poulose <Suzuki.Poulose@arm.com>, "timur@codeaurora.org" <timur@codeaurora.org>, "vgandhi@codeaurora.org" <vgandhi@codeaurora.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 25/06/15 13:30, Christoffer Dall wrote:
> On Wed, Jun 24, 2015 at 10:32:38AM +0100, Marc Zyngier wrote:
>> Hi Christoffer,
>>
>> On 24/06/15 09:51, Christoffer Dall wrote:
>>> On Wed, Jun 24, 2015 at 09:29:56AM +0100, Marc Zyngier wrote:
>>>> On 22/06/15 09:44, Peter Maydell wrote:
>>>>> On 17 June 2015 at 10:00, Suzuki K. Poulose <suzuki.poulose@arm.com> wrote:
>>>>>> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
>>>>>>
>>>>>> This patch adds a generic ARM v8 KVM target cpu type for use
>>>>>> by the new CPUs which eventualy ends up using the common sys_reg
>>>>>> table. For backward compatibility the existing targets have been
>>>>>> preserved. Any new target CPU that can be covered by generic v8
>>>>>> sys_reg tables should make use of the new generic target.
>>>>>
>>>>> How do you intend this to work for cross-host migration?
>>>>
>>>> It is not meant to work for cross migration at all.
>>>>
>>>>> Is the idea that the kernel guarantees that "generic" looks
>>>>> 100% the same to the guest regardless of host hardware? I'm
>>>>> not sure that can be made to work, given impdef differences
>>>>> in ID register values, bp/wp registers, and so on.
>>>>>
>>>>> Given that, it seems to me that we still need to provide
>>>>> KVM_ARM_TARGET_$THISCPU defines so userspace can request
>>>>> a specific guest CPU flavour; so what does this patch
>>>>> provide that isn't already provided by just having userspace
>>>>> query for the "preferred" CPU type as it does already?
>>>>
>>>> The way I see this working is that a "generic" CPU cannot be migrated
>>>> (because we don't know anything about it). If it can be identified as a
>>>> known (non generic) implementation, then we can migrate it.
>>>>
>>> Concretely, how should this work?  Be enforced by userspace or should we
>>> deny certain SET_ONE_REG operations from working on this target?
>>
>> I can definitely see MIDR overriding failing on a generic CPU. Also, you
>> shouldn't be able to select a generic CPU if we know about the physical CPU.
>>
> 
> If I am migrating from an A57 to an A53, but the VM was started as
> "generic CPU" then we rely on the user discovering that this is not
> supported when trying to set the MIDR from userspace in KVM?

A57 to A53 is probably a bad example because we actively support both.
So let's replace your A57 with an A72. With this patch, the A72 would be
reported as "generic CPU", and MIDR access would fail on the A53.

Admittedly, this is a bit late. We could also refuse to instantiate a
"generic CPU" on A53, but that's not much better timing wise.

Not sure we can do much better though.

	M.
-- 
Jazz is not dead. It just smells funny...
