Return-Path: <SRS0=uwID=3F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C658FC33CB1
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jan 2020 06:14:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 55BD720728
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jan 2020 06:14:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55BD720728
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C99F84B0B2;
	Thu, 16 Jan 2020 01:14:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9A3j1SO7fRJI; Thu, 16 Jan 2020 01:14:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D9CC4B18A;
	Thu, 16 Jan 2020 01:14:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D53814B133
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jan 2020 01:14:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mWnGzrQFSyuB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jan 2020 01:14:03 -0500 (EST)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBD9A4B0B2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jan 2020 01:14:02 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 02DAF9C7ADC8FB4C99BB;
 Thu, 16 Jan 2020 14:14:00 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 16 Jan 2020
 14:13:53 +0800
Subject: Re: [PATCH v3 29/32] KVM: arm64: GICv4.1: Allow SGIs to switch
 between HW and SW interrupts
To: Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
References: <20191224111055.11836-1-maz@kernel.org>
 <20191224111055.11836-30-maz@kernel.org>
 <cc5fe20c-7a0c-c266-e78a-2a85963ab20f@hisilicon.com>
 <6e24d53e-64d9-a682-6753-9e16155c7fde@huawei.com>
 <c30b23cf220a4b2965a42ea87b27285f@kernel.org>
From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <081e74f7-5f0a-bdab-fd67-a3ed79a42e63@hisilicon.com>
Date: Thu, 16 Jan 2020 14:13:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <c30b23cf220a4b2965a42ea87b27285f@kernel.org>
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
 Robert Richter <rrichter@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2020/1/15 21:32, Marc Zyngier wrote:
> On 2020-01-15 03:49, Zenghui Yu wrote:
>> Hi,
>>
>> On 2020/1/15 10:49, Shaokun Zhang wrote:
>>> Hi Marc, [This is from Nianyao]
>>>
>>> On 2019/12/24 19:10, Marc Zyngier wrote:
>>>> In order to let a guest buy in the new, active-less SGIs, we
>>>> need to be able to switch between the two modes.
>>>>
>>>> Handle this by stopping all guest activity, transfer the state
>>>> from one mode to the other, and resume the guest.
>>>>
>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>> ---
>>
>> [...]
>>
>>>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>>>> index c2fcde104ea2..063785fd2dc7 100644
>>>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>>>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>>>> @@ -97,6 +97,102 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
>>>>       return IRQ_HANDLED;
>>>>   }
>>>>   +static void vgic_v4_sync_sgi_config(struct its_vpe *vpe, struct vgic_irq *irq)
>>>> +{
>>>> +    vpe->sgi_config[irq->intid].enabled    = irq->enabled;
>>>> +    vpe->sgi_config[irq->intid].group     = irq->group;
>>>> +    vpe->sgi_config[irq->intid].priority    = irq->priority;
>>>> +}
>>>> +
>>>> +static void vgic_v4_enable_vsgis(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +    struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>>>> +    int i;
>>>> +
>>>> +    /*
>>>> +     * With GICv4.1, every virtual SGI can be directly injected. So
>>>> +     * let's pretend that they are HW interrupts, tied to a host
>>>> +     * IRQ. The SGI code will do its magic.
>>>> +     */
>>>> +    for (i = 0; i < VGIC_NR_SGIS; i++) {
>>>> +        struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
>>>> +        struct irq_desc *desc;
>>>> +        int ret;
>>>> +
>>>> +        if (irq->hw) {
>>>> +            vgic_put_irq(vcpu->kvm, irq);
>>>> +            continue;
>>>> +        }
>>>> +
>>>> +        irq->hw = true;
>>>> +        irq->host_irq = irq_find_mapping(vpe->sgi_domain, i);
>>>
>>> I think we need to check whether irq_find_mapping returns 0.
>>>
>>>> +        vgic_v4_sync_sgi_config(vpe, irq);
>>>> +        /*
>>>> +         * SGIs are initialised as disabled. Enable them if
>>>> +         * required by the rest of the VGIC init code.
>>>> +         */
>>>> +        desc = irq_to_desc(irq->host_irq);
>>>> +        ret = irq_domain_activate_irq(irq_desc_get_irq_data(desc),
>>>> +                          false);
>>>
>>> If irq->host_irq is not valid , in irq_domain_activate_irq, it will trigger NULL pointer
>>> dereference in host kernel.
>>> I meet a problem here. When hw support GIC4.1, and host kernel is started with
>>> kvm-arm.vgic_v4_enable=0, starting a virtual machine will trigger NULL pointer
>>> dereference in host.
>>
>> I think the thing is that we should _not_ try to configure vSGIs at all
>> if kvm-arm.vgic_v4_enable=0 (which indicates we don't allow use of the
>> GICv4 of direct injection).
>>
>> We currently set kvm_vgic_global_state.has_gicv4_1 to true if HW support
>> GICv4.1, regardless whatever the gicv4_enable is (see patch#23 -
>> vgic_v3_probe).  I think this is what actually needs fixing.
> 
> Yes, my point exactly. I've pushed out a potential fix [1], and I'd be
> grateful if you could let me know whether that fixes it for you.
> 

Nianyao has tested the patch, it works.

Thanks for your quick reply.


> Thanks,
> 
>         M.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=irq/gic-v4.1-devel&id=b82c2ee1d3fef66fb85793965c344260f618219d

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
