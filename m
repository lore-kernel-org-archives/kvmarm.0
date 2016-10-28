From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/3] Support userspace irqchip with arch timers
Date: Fri, 28 Oct 2016 16:57:31 +0100
Message-ID: <56812724-4bac-8265-b6f6-b1ff00308ec0@arm.com>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
 <de375a6e-095c-a17a-0db7-876a5619df42@suse.de>
 <3e85d538-2539-f190-0d17-a2ecfe7b48ce@suse.de> <20160930154335.GB7996@cbox>
 <71b0ae9d-baea-1f65-3c01-5d87f4f4746f@suse.de>
 <3928feee-cb23-8635-20bd-4c068b649a1d@arm.com>
 <7500DEDE-EC21-4287-9B11-04C058A48747@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <7500DEDE-EC21-4287-9B11-04C058A48747@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 28/10/16 16:52, Alexander Graf wrote:
> 
> 
>> Am 28.10.2016 um 16:38 schrieb Marc Zyngier <marc.zyngier@arm.com>:
>>
>> Alex,
>>
>>> On 30/09/16 20:31, Alexander Graf wrote:
>>>
>>>
>>>> On 30.09.16 17:43, Christoffer Dall wrote:
>>>>> On Fri, Sep 30, 2016 at 05:38:11PM +0200, Alexander Graf wrote:
>>>>>
>>>>>
>>>>>> On 30.09.16 16:54, Alexander Graf wrote:
>>>>>>
>>>>>>
>>>>>>> On 27.09.16 21:08, Christoffer Dall wrote:
>>>>>>> Hi Alex,
>>>>>>>
>>>>>>> Marc and I have been looking at this during Linaro connect and have
>>>>>>> slightly reworked your patch into this small series.
>>>>>>>
>>>>>>> It would be good if you could have a look at it and test it out.
>>>>>>>
>>>>>>> I've tested it with your QEMU, and it works for UP, but secondary CPUs
>>>>>>> fail to come up, and it looks like the kernel never gets an IPI for
>>>>>>> those CPUs from userspace.  Any chance you're willing to take a look at
>>>>>>> that?
>>>>>>
>>>>>> I still need to see whether I can come up with a prettier solution, but
>>>>>> for now this works:
>>>>>>
>>>>>> diff --git a/target-i386/kvm.c b/target-i386/kvm.c
>>>>>
>>>>> Eh, no, not in i386 code :). But the problem seems to be a missing
>>>>> mpstate sync.
>>>>>
>>>> Yeah, that looked really dodgy.  Have you tested it? :)
>>>
>>> This time around tested with the correct command line parameters I hope
>>> :). I'll send a pretty patch later.
>>>
>>> diff --git a/target-arm/kvm.c b/target-arm/kvm.c
>>> index b4c8fe2..b549f00 100644
>>> --- a/target-arm/kvm.c
>>> +++ b/target-arm/kvm.c
>>> @@ -173,6 +173,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>>      */
>>>     kvm_async_interrupts_allowed = true;
>>>
>>> +    /*
>>> +     * PSCI wakes up secondary cores, so we always need to
>>> +     * have vCPUs waiting in kernel space
>>> +     */
>>> +    kvm_halt_in_kernel_allowed = true;
>>> +
>>>     cap_has_mp_state = kvm_check_extension(s, KVM_CAP_MP_STATE);
>>>
>>>     type_register_static(&host_arm_cpu_type_info);
>>
>> What the status of userspace for this thing? Are QEMU patches being
>> posted and reviewed?
> 
> I didn't see a notification that the patches were merged. Are they in
> Linus' tree yet? Then I can post enablement to qemu-devel.

I think you got it backward. I have no intention of merging them until I
see a vague consensus on the userspace API, and a set of patches ready
to be merged in QEMU.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
