From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: KVM Live migration with GICv3
Date: Tue, 11 Aug 2015 20:45:50 +0530
Message-ID: <CALicx6s4BOuHsP40r2zuqgiLh+Rx=e=UQvwV5_R7LJB9-dpkig@mail.gmail.com>
References: <CALicx6soU-pqs3XgkEHxtBVy9yR-7irSU4ZJvC3D6V2UmKHQqA@mail.gmail.com>
 <009101d0d400$c92925f0$5b7b71d0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB7DB5A88F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 11:02:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XD2rTJ3ztTiE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Aug 2015 11:02:46 -0400 (EDT)
Received: from mail-vk0-f47.google.com (mail-vk0-f47.google.com
 [209.85.213.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDCFB5A88E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 11:02:46 -0400 (EDT)
Received: by vkbf67 with SMTP id f67so14374847vkb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 08:15:50 -0700 (PDT)
In-Reply-To: <009101d0d400$c92925f0$5b7b71d0$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 11, 2015 at 12:11 PM, Pavel Fedin <p.fedin@samsung.com> wrote:
>  Hello!
>
>>    I have prototyped Live migration with GICv3.
>
>  This is interesting of course, i will need this for my project too and i was also going to take a look at this later.
>
>> For this I have made following changes
>>
>> 1) Save and Restore of GICv3 registers in QEMU.
>>     - For GICv2, QEMU is saving/restoring GICD, GICC  registers. For GICv3,
>>      we have to save/restore GICD, GICR and ICC registers.
>>      However ICC registers are system registers which cannot be
>> accessed @ EL0 level (SRE=1). So these ICC registers should be
>> accessed as mmio registers by QEMU, for this we have to add ioctl to
>> access ICC @ EL1 level similar to GICC registers of GICv2.
>
>  Sorry, your description is a bit fuzzy. What ioctl's did you have to add and why?
>  The kernel already has KVM_GET_ONE_REG and KVM_SET_ONE_REG ioctl's. And they can be used to access anything inside the VM, including system registers. I believe you would need only to implement handlers for GICv3 registers.

I mean CPU interface registers GICC* defined for vgicv2 under
"vgic_cpu_ranges[]" in
virt/kvm/arm/vgic-v2-emul.c needs to be saved and restored for vgicv3 as well.
So to  access vgic_cpu_ranges[] for vgicv3, we need to register device
for CPU registers space
similar to gicv2 in QEMU for gicv3.

-----------------------------------------------------------------------------------------
    memory_region_init_reservation(&s->cpuiomem[0], OBJECT(s),
                                   "kvm-gic_cpu", 0x1000);
    sysbus_init_mmio(sbd, &s->cpuiomem[0]);
    kvm_arm_register_device(&s->cpuiomem[0],
                            (KVM_ARM_DEVICE_VGIC_V3 << KVM_ARM_DEVICE_ID_SHIFT)
                            | KVM_VGIC_V3_ADDR_TYPE_CPU,
                            KVM_DEV_ARM_VGIC_GRP_ADDR,
                            KVM_VGIC_V3_ADDR_TYPE_CPU,
                            s->dev_fd);
-------------------------------------------------------------------------------------------

Anyway, I will send RFC patches.

>
>> Please provide your initial feedback.
>
>  Would be nice to take a look at patches.
>
>> I am attending KVM-forum next week @ Seattle. We can discuss there as well.
>
>  I would love to go there, and my company wanted to send me there. But it appears to be extremely difficult for a tech specialist from Russia to get a US visa. They are still considering me and the time is running out, so i'm unlikely to attend, unfortunately.
>
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
>
>
