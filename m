From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: vgic: change condition for level
 interrupt resampling
Date: Fri, 9 Mar 2018 14:10:52 +0100
Message-ID: <c2c51dab-3e41-5703-0f55-8469ea6bcd6c@redhat.com>
References: <1520492490-7943-1-git-send-email-shunyong.yang@hxt-semitech.com>
 <9ad47673-068e-f732-d2ca-9c76a8fbdfbc@arm.com>
 <0a15633d-8944-cb9b-3e6b-b08ee5ec42b9@arm.com> <20180308161900.GC1917@lvm>
 <86r2oubho3.wl-marc.zyngier@arm.com>
 <cf815673-e20e-c1e1-2d79-2f47261b2412@redhat.com>
 <1520565257.2583.57.camel@hxt-semitech.com>
 <959b6484-c683-65b2-a1e5-3e3784865682@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <959b6484-c683-65b2-a1e5-3e3784865682@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, "Yang, Shunyong" <shunyong.yang@hxt-semitech.com>, "cdall@kernel.org" <cdall@kernel.org>
Cc: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "david.daney@cavium.com" <david.daney@cavium.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zheng, Joey" <yu.zheng@hxt-semitech.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 09/03/18 10:40, Marc Zyngier wrote:
> On 09/03/18 03:14, Yang, Shunyong wrote:
> 
> [trimming things a bit]
> 
>>>>>>>>  static bool lr_signals_eoi_mi(u32 lr_val)
>>>>>>>>  {
>>>>>>>> -	return !(lr_val & GICH_LR_STATE) && (lr_val &
>>>>>>>> GICH_LR_EOI) &&
>>>>>>>> -	       !(lr_val & GICH_LR_HW);
>>>>>>>> +	return !((lr_val & GICH_LR_STATE) ^ GICH_LR_STATE)
>>>>>>>> &&
>>>>>>> That feels very wrong. You're now signalling the resampling
>>>>>>> in both
>>>>>>> invalid and pending+active, and the latter state doesn't mean
>>>>>>> you've
>>>>>>> EOIed anything. You're now over-signalling, and signalling
>>>>>>> the
>>>>>>> wrong event.
>>
>> I am using XOR GICH_LR_STATE(0b'11), so only 0b'11(P&A) will be
>> signaled. Other state will be false.
> 
> And that's really wrong. P+A is a state where the interrupt is still
> being processed. The only case where we can reliably detect that an
> interrupt has been EOId is when state==0.
> 
>> And I am curious why the EOI bit in LR indicate the end of interrupt
>> regardless of the state? Please bear with me as I am a newbie in this
>> part.
> 
> The EOI bit indicates that we've requested a maintenance interrupt from
> the HW. It only triggers when state==0. If you have (like you describe
> further down) a sequence of
> 
> P -> A -> (exit) -> P+A -> P -> A -> (exit) P+A ...
> 
> we can never reliably detect that an interrupt has been EOId (because
> the HW never delivers a maintenance interrupt), other than by tracking
> the states before and after exit, and hoping that you've done an exit
> because you're touching the source of the interrupt.
> 
>>>>>> Also, any guideline on how to reproduce this would be much
>>>>>> appreciated.
>>>>>> I never used this mdev/mtty thing, so please bear with me.
>>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>> 	M.
>>
>> The mdev/mtty documentation is at Documentation/vfio-mediated-
>> device.txt. It docmented how to enable mtty device.
>> And support for "vfio-pci,sysfsdev" should be availabe in your qemu
>> version (I compiled the latest version).
>> Following is my commond to run qemu with mdev support,
>> "qemu-system-aarch64 -m 1024 -cpu host -M virt,gic_version=3 -nographic
>> \
>> -kernel /home/yangsy/up-kvm/arch/arm64/boot/Image.gz \
>> -initrd /home/yangsy/kvm/ramdisk/initrd.img \
>> -netdev user,id=eth0 -device virtio-net-device,netdev=eth0 -enable-kvm
>> \
>> -append "root=/dev/ram rdinit=/sbin/init" \
>> -device vfio-pci,sysfsdev=/sys/bus/mdev/devices/83b8f4f2-509f-382f-
>> 3c1e-e6bfe0fa1001
>> "
>> For just test this vgic case, type "cat /dev/ttyS0" in guest. But if
>> test read/write multiple bytes, please apply following patch also
>> https://patchwork.kernel.org/patch/10267039/
> 
> Thanks. I'll have a look.
> 
>>
>>>>>>
>>>>>> From 66a7c4cfc1029b0169dd771e196e2876ba3f17b1 Mon Sep 17
>>>>>> 00:00:00 2001
>>>>>> From: Marc Zyngier <marc.zyngier@arm.com>
>>>>>> Date: Thu, 8 Mar 2018 11:14:06 +0000
>>>>>> Subject: [PATCH] KVM: arm/arm64: Do not rely on LR state to
>>>>>> guess EOI MI
>>>>>>  status
>>>>>>
>>>>>> We so far rely on the LR state to decide whether the guest has
>>>>>> EOI'd a level interrupt or not. While this looks like a good
>>>>>> idea on the surface, it leads to a couple of annoying corner
>>>>>> cases:
>>>>>>
>>>>>> Example 1: (P = Pending, A = Active, MI = Maintenance
>>>>>> Interrupt)
>>>>>> P -> guest IAR -> A -> exit/entry -> P+A -> guest EOI -> P ->
>>>>>> MI
>>>>> Do we really get an EOI maintenance interrupt here?  Reading the
>>>>> MISR
>>>>> and EISR descriptions make me thing this is not the case...
>>> Hum yes in EISR it is said that ICH_LR.State = 0b00!
>>>>
>>>>
>>>> Yeah, it looks like I always want EISR to do what I want, and not
>>>> to
>>>> do what it does. Man, this thing is such a piece of crap.
>>>>
>>>> OK, scratch that. We need to do it without the help of the HW.
>>
>> If convenient, maybe we can get something from HW gus. :-)
>>
>> Hi, Marc,
>>
>> Do you need me to test the patch you posted for EISR? As it seems there
>> are some things need more discussion.
> 
> Yeah, that approach doesn't work. I'll try and come up with another
> approach (basically banning P+A for interrupts that require a back
> notification).
> 
> [...]
> 
>> I have added some logs to compare level interrupt between pl011(hwirq =
>> 33) and mtty (hwirq = 36). In mtty case, vgic_queue_irq_unlock() is
>> called twice. But only called once in pl011.
>>
>> following is the log,
>> ===Without my patch===
>> ###PL011###
>>
>> <4>[  180.598266] kvm_vgic_inject_irq 453 irq:33 enabled:1 config:1
>> latch:0 level:1
>> <4>[  180.604460] ##vgic_queue_irq_unlock 388 irq->intid:33 enable:1
>> level:1
>> <4>[  180.604540] ==>90a0020000000021(active)
>> <4>[  180.614878] ==>d0a0020000000021(P&A)
>> <4>[  180.618415] kvm_vgic_inject_irq 453 irq:33 enabled:1 config:1
>> latch:0 level:0
>> <4>[  180.625508] ==>90a0020000000021(active)
>> <4>[  180.629343] ==>10a0020000000021(inactive)
>>
>> ###mtty-vfio###
>> <4>[  223.123329] kvm_vgic_inject_irq 453 irq:36 enabled:0 config:1
>> latch:0 level:1
>> <4>[  223.129736] ##vgic_queue_irq_unlock 388 irq->intid:36 enable:1
>> level:1
>> <4>[  223.136027] ==>50a0020000000024(pending)
>> <4>[  223.139954] ##vgic_queue_irq_unlock 388 irq->intid:36 enable:1
>> level:1
>> <4>[  223.146460] ==>90a0020000000024(active)
>> <4>[  223.150273] ==>d0a0020000000024(P&A)
>> <4>[  223.153827] ==>90a0020000000024(active)
>> <4>[  223.157668] ==>d0a0020000000024(P&A)
> 
> So the line is never lowered. That's very odd.
> 
>> ...........cyclic...
>>
>> I rembered in some tests the state change is cyclic P->A->P&A. But it
>> seems I cannot reproduce it. Is output LR state
>> in kvm_vgic_inject_irq() reliable?
>>
>> ===With my patch===
>> ###PL011###
>> <4>[  114.798528] kvm_vgic_inject_irq 453 irq:33 enabled:1 config:1
>> latch:0 level:1
>> <4>[  114.804743] ##vgic_queue_irq_unlock 388 irq->intid:33 enable:1
>> level:1
>> <4>[  114.804796] ==>90a0020000000021(active)
>> <4>[  114.815077] ==>d0a0020000000021(P&A)
>> <4>[  114.818628] kvm_vgic_inject_irq 453 irq:33 enabled:1 config:1
>> latch:0 level:0
>> <4>[  114.825726] ==>90a0020000000021(active)
>> <4>[  114.829560] ==>10a0020000000021(inactive)
>>
>> ###mtty-vfio###
>>
>> <4>[  161.579083] kvm_vgic_inject_irq 453 irq:36 enabled:0 config:1
>> latch:0 level:1
>> <4>[  161.585419] ##vgic_queue_irq_unlock 388 irq->intid:36 enable:1
>> level:1
>> <4>[  161.591780] ==>50a0020000000024(pending)
>> <4>[  161.595708] ##vgic_queue_irq_unlock 388 irq->intid:36 enable:1
>> level:1
>> <4>[  161.602204] ==>90a0020000000024(active)
>> <4>[  161.606023] ==>d0a0020000000024(P&A)
>> <4>[  161.609561] kvm_vgic_inject_irq 453 irq:36 enabled:1 config:1
>> latch:0 level:0
>> <4>[  161.616693] ==>10a0020000000024(inactive)
>> <4>[  161.620745] kvm_vgic_inject_irq 453 irq:36 enabled:1 config:1
>> latch:0 level:1
>> <4>[  161.627800] ##vgic_queue_irq_unlock 388 irq->intid:36 enable:1
>> level:1
>> <4>[  161.627849] ==>90a0020000000024(active)
>> <4>[  161.640076] ==>d0a0020000000024(P&A)
>> <4>[  161.642689] kvm_vgic_inject_irq 453 irq:36 enabled:1 config:1
>> latch:0 level:0
>> <4>[  161.649822] ==>10a0020000000024(inactive)
> 
> Which is really bizarre. The device only lowers the line when it is
> being told that the interrupt has been processed. That really smells of
> a bug in the device emulation. It should be lowered when the guest
> clears the interrupt status at the device level, and not when notified
> that the interrupt has been completed at the interrupt controller level.
Not sure I get what you mean. To me the guest driver may have properly
acked the interrupt at HW level. But this cannot lower the virtual line
level. The virtual line level only is set when an interrupt hits and the
VFIO irq handler signals the irqfd. only the resamplefd can lower the
virtual line level. There is no communication between the VFIO driver
and KVM to lower the virtual line level. Note the resamplefd also is
used to unmask the interrupt on VFIO driver side.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
