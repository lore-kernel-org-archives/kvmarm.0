From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 1/5] arm/arm64: vgic-new: Implement support for
 userspace access
Date: Mon, 12 Sep 2016 09:51:43 +0100
Message-ID: <57D66C9F.8070003@arm.com>
References: <1473510138-4719-1-git-send-email-vijay.kilari@gmail.com>
 <1473510138-4719-2-git-send-email-vijay.kilari@gmail.com>
 <57D66679.3020804@arm.com>
 <CALicx6sHYqwGdW_zwE9d8BWO2BucQM6gEoLZAtJ6XG0AjAuGGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 350AA40F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 04:43:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jex1DwzcrS-E for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Sep 2016 04:43:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C81540C9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 04:43:06 -0400 (EDT)
In-Reply-To: <CALicx6sHYqwGdW_zwE9d8BWO2BucQM6gEoLZAtJ6XG0AjAuGGw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vijay Kilari <vijay.kilari@gmail.com>
Cc: Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 12/09/16 09:46, Vijay Kilari wrote:
> On Mon, Sep 12, 2016 at 1:55 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 10/09/16 13:22, vijay.kilari@gmail.com wrote:
>>> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>>>
>>> +
>>> +void vgic_uaccess_write_pending(struct kvm_vcpu *vcpu,
>>> +                             gpa_t addr, unsigned int len,
>>> +                             unsigned long val)
>>> +{
>>> +     u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>>> +     int i;
>>> +
>>> +     for (i = 0; i < len * 8; i++) {
>>> +             struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>> +
>>> +             spin_lock(&irq->irq_lock);
>>> +             if (test_bit(i, &val)) {
>>> +                     irq->pending = true;
>>> +                     irq->soft_pending = true;
>>> +                     vgic_queue_irq_unlock(vcpu->kvm, irq);
>>> +             } else {
>>> +                     irq->soft_pending = false;
>>> +                     if (irq->config == VGIC_CONFIG_EDGE ||
>>> +                         (irq->config == VGIC_CONFIG_LEVEL &&
>>> +                         !irq->line_level))
>>> +                             irq->pending = false;
>>> +                     spin_unlock(&irq->irq_lock);
>>> +             }
>>> +
>>> +             vgic_put_irq(vcpu->kvm, irq);
>>> +     }
>>> +}
>>> +
>>
>> These two functions only seems to be called from the GICv3 code. What is
>> the rational for making them globally accessible? Or should they also be
>> wired into the GICv2 code?
> 
> Yes, probably this might be required for V2. But I don't have GICv2 platform
> to implement and verify it. Also not aware if someone is looking at
> migration with GICv2
> platform with this new vgic code.

Migration is already supported, and we can always verify it once you've
made the change.

> 
> Can be kept here for later to wire into GICv2 code.

I don't think so. You are implementing this code, so please wire it into
the potential users.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
