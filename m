From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [PATCH v8 1/7] arm/arm64: vgic: Implement support for userspace
 access
Date: Thu, 17 Nov 2016 16:56:53 +0530
Message-ID: <CALicx6vbFj3aoSiqc4n_92rZgONeQVhp-GtTkEhW3=pt9P1hGQ@mail.gmail.com>
References: <1478258013-6669-1-git-send-email-vijay.kilari@gmail.com>
 <1478258013-6669-2-git-send-email-vijay.kilari@gmail.com>
 <20161116185215.GC3811@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E76F040428
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 06:26:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xgLluUBvkIzD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2016 06:26:21 -0500 (EST)
Received: from mail-vk0-f68.google.com (mail-vk0-f68.google.com
 [209.85.213.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E23E1401E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 06:26:21 -0500 (EST)
Received: by mail-vk0-f68.google.com with SMTP id p9so14227344vkd.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 03:26:54 -0800 (PST)
In-Reply-To: <20161116185215.GC3811@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 17, 2016 at 12:22 AM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Fri, Nov 04, 2016 at 04:43:27PM +0530, vijay.kilari@gmail.com wrote:
>> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>>
>> Read and write of some registers like ISPENDR and ICPENDR
>> from userspace requires special handling when compared to
>> guest access for these registers.
>>
>> Refer to Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>> for handling of ISPENDR, ICPENDR registers handling.
>>
>> Add infrastructure to support guest and userspace read
>> and write for the required registers
>> Also moved vgic_uaccess from vgic-mmio-v2.c to vgic-mmio.c
>>
>> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 25 ----------
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 98 ++++++++++++++++++++++++++++++++--------
>>  virt/kvm/arm/vgic/vgic-mmio.c    | 78 ++++++++++++++++++++++++++++----
>>  virt/kvm/arm/vgic/vgic-mmio.h    | 19 ++++++++
>>  4 files changed, 169 insertions(+), 51 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> index b44b359..0b32f40 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> @@ -406,31 +406,6 @@ int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>>       return -ENXIO;
>>  }
>>
>> -/*
>> - * When userland tries to access the VGIC register handlers, we need to
>> - * create a usable struct vgic_io_device to be passed to the handlers and we
>> - * have to set up a buffer similar to what would have happened if a guest MMIO
>> - * access occurred, including doing endian conversions on BE systems.
>> - */
>> -static int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
>> -                     bool is_write, int offset, u32 *val)
>> -{
>> -     unsigned int len = 4;
>> -     u8 buf[4];
>> -     int ret;
>> -
>> -     if (is_write) {
>> -             vgic_data_host_to_mmio_bus(buf, len, *val);
>> -             ret = kvm_io_gic_ops.write(vcpu, &dev->dev, offset, len, buf);
>> -     } else {
>> -             ret = kvm_io_gic_ops.read(vcpu, &dev->dev, offset, len, buf);
>> -             if (!ret)
>> -                     *val = vgic_data_mmio_bus_to_host(buf, len);
>> -     }
>> -
>> -     return ret;
>> -}
>> -
>>  int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>>                         int offset, u32 *val)
>>  {
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index 0d3c76a..ce2708d 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -209,6 +209,62 @@ static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
>>       return 0;
>>  }
>>
>> +static unsigned long vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
>> +                                               gpa_t addr, unsigned int len)
>> +{
>> +     u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>> +     u32 value = 0;
>> +     int i;
>> +
>> +     /*
>> +      * A level triggerred interrupt pending state is latched in both
>> +      * "soft_pending" and "line_level" variables. Userspace will save
>> +      * and restore soft_pending and line_level separately.
>> +      * Refer to Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>> +      * handling of ISPENDR and ICPENDR.
>> +      */
>> +     for (i = 0; i < len * 8; i++) {
>> +             struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> +
>> +             if (irq->config == VGIC_CONFIG_LEVEL && irq->soft_pending)
>> +                     value |= (1U << i);
>> +             if (irq->config == VGIC_CONFIG_EDGE && irq->pending)
>> +                     value |= (1U << i);
>> +
>> +             vgic_put_irq(vcpu->kvm, irq);
>> +     }
>> +
>> +     return value;
>> +}
>> +
>> +static void vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
>> +                                       gpa_t addr, unsigned int len,
>> +                                       unsigned long val)
>> +{
>> +     u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>> +     int i;
>> +
>> +     for (i = 0; i < len * 8; i++) {
>> +             struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> +
>> +             spin_lock(&irq->irq_lock);
>> +             if (test_bit(i, &val)) {
>> +                     irq->pending = true;
>> +                     irq->soft_pending = true;
>
> In the vgic_mmio_write_spending function we only set the soft_pending
> state to true if the interrupt is a level-triggered interrupt.
>
> Should we check if that's the case here as well before setting the
> soft_pending state?

Yes, can be done. But it puts hard requirement that irq config should
be restored
before updating pending state.
In any case, the soft_pending is used only if interrupt is level-triggered.

>
> Otherwise, this patch looks good.
>
> Thanks,
> -Christoffer
>
