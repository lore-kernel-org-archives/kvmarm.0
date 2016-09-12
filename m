From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [PATCH v4 1/5] arm/arm64: vgic-new: Implement support for
 userspace access
Date: Mon, 12 Sep 2016 14:16:02 +0530
Message-ID: <CALicx6sHYqwGdW_zwE9d8BWO2BucQM6gEoLZAtJ6XG0AjAuGGw@mail.gmail.com>
References: <1473510138-4719-1-git-send-email-vijay.kilari@gmail.com>
 <1473510138-4719-2-git-send-email-vijay.kilari@gmail.com>
 <57D66679.3020804@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 440E740F90
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 04:37:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y7yE+nNCNlLc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Sep 2016 04:37:23 -0400 (EDT)
Received: from mail-oi0-f68.google.com (mail-oi0-f68.google.com
 [209.85.218.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6146D40C9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 04:37:23 -0400 (EDT)
Received: by mail-oi0-f68.google.com with SMTP id y2so16801750oie.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 01:46:03 -0700 (PDT)
In-Reply-To: <57D66679.3020804@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 12, 2016 at 1:55 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 10/09/16 13:22, vijay.kilari@gmail.com wrote:
>> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>>
>> +
>> +void vgic_uaccess_write_pending(struct kvm_vcpu *vcpu,
>> +                             gpa_t addr, unsigned int len,
>> +                             unsigned long val)
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
>> +                     vgic_queue_irq_unlock(vcpu->kvm, irq);
>> +             } else {
>> +                     irq->soft_pending = false;
>> +                     if (irq->config == VGIC_CONFIG_EDGE ||
>> +                         (irq->config == VGIC_CONFIG_LEVEL &&
>> +                         !irq->line_level))
>> +                             irq->pending = false;
>> +                     spin_unlock(&irq->irq_lock);
>> +             }
>> +
>> +             vgic_put_irq(vcpu->kvm, irq);
>> +     }
>> +}
>> +
>
> These two functions only seems to be called from the GICv3 code. What is
> the rational for making them globally accessible? Or should they also be
> wired into the GICv2 code?

Yes, probably this might be required for V2. But I don't have GICv2 platform
to implement and verify it. Also not aware if someone is looking at
migration with GICv2
platform with this new vgic code.

Can be kept here for later to wire into GICv2 code.

>>
>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
