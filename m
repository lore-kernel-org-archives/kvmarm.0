From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: vgic: change condition for level
 interrupt resampling
Date: Mon, 12 Mar 2018 10:09:01 +0000
Message-ID: <103f560a-d7ad-ba6c-e129-eda172312576@arm.com>
References: <1520492490-7943-1-git-send-email-shunyong.yang@hxt-semitech.com>
 <9ad47673-068e-f732-d2ca-9c76a8fbdfbc@arm.com>
 <0a15633d-8944-cb9b-3e6b-b08ee5ec42b9@arm.com> <20180308161900.GC1917@lvm>
 <86r2oubho3.wl-marc.zyngier@arm.com> <20180309213612.GD1917@lvm>
 <86k1ukazr0.wl-marc.zyngier@arm.com>
 <CAEDV+g+29ZK6QQEn=2h_77dMZC7wmw+d4MZC-GU-CqeaK_xhMg@mail.gmail.com>
 <20180311121733.643fb1a5@why.wild-wind.fr.eu.org>
 <1520822024.2985.12.camel@hxt-semitech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520822024.2985.12.camel@hxt-semitech.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Shunyong" <shunyong.yang@hxt-semitech.com>, "cdall@kernel.org" <cdall@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "Zheng, Joey" <yu.zheng@hxt-semitech.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "david.daney@cavium.com" <david.daney@cavium.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 12/03/18 02:33, Yang, Shunyong wrote:
> Hi, Marc,
> 
> On Sun, 2018-03-11 at 12:17 +0000, Marc Zyngier wrote:
>> On Sun, 11 Mar 2018 01:55:08 +0000
>> Christoffer Dall <cdall@kernel.org> wrote:
>>
>>>
>>> On Sat, Mar 10, 2018 at 12:20 PM, Marc Zyngier <marc.zyngier@arm.co
>>> m> wrote:
>>>>
>>>> On Fri, 09 Mar 2018 21:36:12 +0000,
>>>> Christoffer Dall wrote:  
>>>>>
>>>>>
>>>>> On Thu, Mar 08, 2018 at 05:28:44PM +0000, Marc Zyngier wrote:  
>>>>>>
>>>>>> I'd be more confident if we did forbid P+A for such
>>>>>> interrupts
>>>>>> altogether, as they really feel like another kind of HW
>>>>>> interrupt.  
>>>>> How about a slightly bigger hammer:  Can we avoid doing P+A for
>>>>> level
>>>>> interrupts completely?  I don't think that really makes much
>>>>> sense, and
>>>>> I think we simply everything if we just come back out and
>>>>> resample the
>>>>> line.  For an edge, something like a network card, there's a
>>>>> potential
>>>>> performance win to appending a new pending state, but I doubt
>>>>> that this
>>>>> is the case for level interrupts.  
>>>> I started implementing the same thing yesterday. Somehow, it
>>>> feels
>>>> slightly better to have the same flow for all level interrupts,
>>>> including the timer, and we only use the MI on EOI as a way to
>>>> trigger
>>>> the next state of injection. Still testing, but looking good so
>>>> far.
>>>>
>>>> I'm still puzzled that we have this level-but-not-quite behaviour
>>>> for
>>>> VFIO interrupts. At some point, it is going to bite us badly.
>>>>  
>>> Where is the departure from level-triggered behavior with VFIO?  As
>>> far as I can tell, the GIC flow of the interrupts will be just a
>>> level
>>> interrupt, 
>> The GIC is fine, I believe. What is not exactly fine is the
>> signalling
>> from the device, which will never be dropped until the EOI has been
>> detected.
>>
>>>
>>> but we just need to make sure the resamplefd mechanism is
>>> supported for both types of interrupts.  Whether or not that's a
>>> decent mechanism seems orthogonal to me, but that's a discussion
>>> for
>>> another day I think.
>> Given that VFIO is built around this mechanism, I don't think we have
>> a
>> choice but to support it. Anyway, I came up with the following patch,
>> which I tested on Seattle with mtty. It also survived my usual
>> hammering of cyclictest, hackbench  and bulk VM installs.
>>
>> Shunyong, could you please give it a go?
>>
>> Thanks,
>>
>> 	M.
>>
> 
> I have tested the patch. It works on QDF2400 platform
> and kvm_notify_acked_irq() is called when state is idle.

Thanks a lot for testing.

> 
> BTW, I have following questions when I was debugging the issue.
> Coud you please give me some help?
> 1)what does "mi" mean in gic code? such as lr_signals_eoi_mi();

MI stands for Maintenance Interrupts. Life is too short to write that
all the time ;-)

> 2)In some __hyp_text code where printk() will cause "HYP panic:", such
> as in __kvm_vcpu_run(). How can I output debug information?

You can't. None of the kernel is mapped at EL2 on pre-VHE hardware.
You'll need to find indirect ways of outputting information (store data
in memory, and output it once you're back to EL1).

Thanks again,

	M.
-- 
Jazz is not dead. It just smells funny...
