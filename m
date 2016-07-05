From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v7 10/17] KVM: arm64: introduce new KVM ITS device
Date: Tue, 5 Jul 2016 09:59:46 +0100
Message-ID: <95a09591-8915-9ebf-1edd-675e83a1a09b@arm.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
 <20160628123230.26255-11-andre.przywara@arm.com>
 <2525bd7b-5df1-54bc-1999-25c8c7fe88a3@redhat.com>
 <173c3704-180e-0385-623c-5dbcced2d762@arm.com>
 <da2ac9c4-e29b-e74f-a11e-b2736526bf8f@redhat.com>
 <CAFEAcA96DGzW=bShwz188O0BaDy34ccEG3921AxQCf3aAFgurg@mail.gmail.com>
 <2b712bbe-1534-0206-34e7-8df433ace7c2@redhat.com>
 <fc201178-cfa4-221d-b36e-f5d959f89f74@arm.com>
 <081321b4-5bf2-29f7-018e-6d50ee74b95c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 626FC412D0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jul 2016 04:53:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dIbPUTo1PECT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jul 2016 04:53:27 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0036412A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jul 2016 04:53:27 -0400 (EDT)
In-Reply-To: <081321b4-5bf2-29f7-018e-6d50ee74b95c@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

thank you very much for the elaborate explanation!

On 05/07/16 08:40, Auger Eric wrote:
> Hi Andre,
> On 04/07/2016 19:40, Andre Przywara wrote:
>> Hi Eric,
>>
>> On 04/07/16 16:00, Auger Eric wrote:
>>> Hi Peter,
>>>
>>> On 04/07/2016 16:32, Peter Maydell wrote:
>>>> On 4 July 2016 at 15:27, Auger Eric <eric.auger@redhat.com> wrote:
>>>>> Andre,
>>>>>
>>>>> On 04/07/2016 16:05, Andre Przywara wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 04/07/16 10:00, Auger Eric wrote:
>>>>>>> From a QEMU integration point of view this means the init sequence used
>>>>>>> for KVM GIC interrupt controllers cannot be reused for ITS and more
>>>>>>> importantly this is not straightforward to have the proper sequence
>>>>>>> ordering (hence the previously reported case).
>>>>>>
>>>>>> I am confused, can you please elaborate what the problem is?
>>>>>> Or alternatively sketch what you ideally would the ITS init sequence to
>>>>>> look like? I am totally open to any changes, just need to know what
>>>>>> you/QEMU needs.
>>>>>
>>>>> in QEMU the address setting is done on a so-called qemu
>>>>> "machine_init_done_notifier", ie. a callback that is registered at ITS
>>>>> device init, to be called once the virt machine code has executed. This
>>>>> callback calls  kvm_device_ioctl(kd->dev_fd, KVM_SET_DEVICE_ATTR, attr);
>>>>>
>>>>> In case the userspace needs to explicitly "init" the ITS (actually ~
>>>>> map_resources) this must happen after the KVM_SET_DEVICE_ATTR. So you
>>>>> also must register a callback in the same way. However there is a
>>>>> framework existing to register kvm device addresses but this does not
>>>>> exist to set other attributes than device addresses.
>>>>>
>>>>> This is feasible I think but this does not fit qemu nicely. So can't the
>>>>> map_resources happen implicitly on the first VCPU run?
>>>>
>>>> I'm not clear what you think the problem here for QEMU is.
>>>> We definitely want the API for the kernel to be:
>>>>  create device
>>>>  set attributes
>>>>  explicitly complete init of the device
>>>>  [attribute setting after this is illegal]
>>>>  run CPUs
>>>>
>>>> so I'm not sure why QEMU would care if the kernel does things at
>>>> "final init" rather than "run CPUs".
>>>>
>>>> This is how the GICv3 init works and how the ITS should work too;
>>> The GICv3 explicit does not do the same as the ITS init.
>>> GICv3 init does not map the resources (KVM iodevice registration). This
>>> is done at 1st VCPU run.
>>> ITS init does map the resources. If we call the ITS init at the same
>>> place as we call the GICv3 init, in the realization function, the region
>>> mapping is not yet done so you will map resources at undefined location.
>>
>> What do you mean with "region mapping"? QEMU's internal mapping?
> 1st the device regions are created. 2d they are attached at some place
> in the guest memory PA address space. 2d is what I call "region
> mapping". and 3d you have the kvm_device_ioctl(kd->dev_fd,
> KVM_SET_DEVICE_ATTR, attr) called, setting the ITS base address on
> kernel side. This is done on the so-called machine_init_done_notifier.
> So if we follow that scheme the explicit INIT must happen after 3).

Ah, OK, so you _do_ the address setup _after_ the INIT.
My understanding of the KVM API was that this isn't allowed, as with the
INIT _everything_ should have been setup. kvmtool works this way.

So we obviously can't change this for GICv3, but I wonder if we should
make this explicit with the ITS:
1) Create the device
2) setup _all_ parameters (address, number of ...)
3) call INIT, any setup calls from here on are denied

That sounds like the proper setup sequence to me.
I don't know about your workaround you just mentioned, but maybe it's
worth to do the GICv2/v3 initialization in the same way? This would
avoid having two paths for ITS and GICv2/v3 setup in the QEMU code.

Sorry if that means more work to you!

>> But you set the GICv3 redist/dist  addresses (or the ITS address, for
>> that matter) before calling CTRL_INIT, right?
> No similarly the GICv3 base addresses are provided to the kernel very
> late (at the same place as 3, on machine init notifier). for VGIC the
> CTRL_INIT is called at device creation 1), after freezing the number of
> SPIs. if you look at the vgic_init function that is called upon
> CTRL_INIT, it never uses base addresses. It just uses dimensionning
> parameters such as the number of SPIs. for VGIC, the map_resources is
> called implicitly on first vcpu run, ie. after 3). For ITS with current
> patch this needs to be done on a machine_init_done_notifier after 3).

I see. Doing the map_resources on the first vcpu run sounds like an
anachronism from the implicit GICv2 init days to me, which we just
couldn't change for compatibility reasons and had no real reason to
change for GICv3.

>  So are you concerned that
>> the kernel "maps" the region before QEMU connects the memory region? Is
>> that really a problem? This "map_resources" equivalent for the ITS just
>> creates a kvm_io_bus mapping, which would never fire without either a
>> guest running (which we clearly don't at this point) or userland
>> explicitly requesting access (which would require QEMU to have done the
>> mapping?).
>>
>> Is that about right or do I miss something again?
>> Sorry for my ignorance on the QEMU internals in that matter ;-)
>>
>>> I am definitively not opposed to call the ITS init function explicitly
>>> from user side but this must happen after the KVM_SET_DEVICE_ATTR. So
>>> another machine_init_done function must be registered and the notifier
>>> must be called AFTER the notifier that calls the KVM_SET_DEVICE_ATTR
>>> ioctl. However you cannot easily master the machine init done notifier
>>> registration order because in target-arm/kvm.c there is a single
>>> notifier that calls all the KVM_SET_DEVICE_ATTR for all the KVM devices
>>> (kvm_arm_machine_init_done). So it is not possible to register the ITS
>>> init notifier before the "kvm_arm_set_device_addr" notifier.
>>>
>>> So my understanding is one must do things outside of the existing framework?
>>
>> While I am certainly not interested in making QEMU's (or the QEMU patch
>> author's) life harder than needed, I am wondering if we should really
>> model the userland/kernel interface according to QEMU's current
>> framework design.
>> Is the current approach a leftover of the initial vGICv2 code, that was
>> just slightly adjusted to support GICv3?
> 
> Well I don't think we need to devise the kernel API according to the
> QEMU framework. However from a kernel pov I wanted to shed the light on
> the difference between vgic_init and its_init which are not homogeneous
> in terms of actions and map_resources which in one case is called
> implicitly and in the other case must be called explicitly, with impact
> on qemu framework.

OK, got it. I see that the documentation doesn't demand any setup
activities to be finished upon INIT, though I understood it that way.
I will document the demand for the ITS INIT call.

Let me send out another revision, but still with the current sequence.
If the workaround you mentioned is too involved, I might still change
the kernel.

Cheers,
Andre.

>>>> we don't want to extend the GICv2 mistake of "no explicit complete
>>>> init" to anything else, because then you end up with ad-hoc
>>>> "do this when we first run the vCPU; oh, but also do it if
>>>> userspace tries to write a register content; and also if...".
>>>>
>>>> thanks
>>>> -- PMM
>>>>
>>>
> 
