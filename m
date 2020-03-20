Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FC2C4332D
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 03:09:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 53BF620754
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 03:09:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53BF620754
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B16E94A4FC;
	Thu, 19 Mar 2020 23:09:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HptCVn5V5bNc; Thu, 19 Mar 2020 23:08:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86C694AF1F;
	Thu, 19 Mar 2020 23:08:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 510504A4FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 23:08:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W3vWDK16-QCG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2020 23:08:56 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A5A684A4CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 23:08:56 -0400 (EDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 7D6D63D2899F173E72D0;
 Fri, 20 Mar 2020 11:08:52 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Mar 2020
 11:08:42 +0800
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
To: Auger Eric <eric.auger@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <49995ec9-3970-1f62-5dfc-118563ca00fc@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <b98855a1-6300-d323-80f6-82d3b9854290@huawei.com>
Date: Fri, 20 Mar 2020 11:08:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <49995ec9-3970-1f62-5dfc-118563ca00fc@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert
 Richter <rrichter@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020/3/20 4:38, Auger Eric wrote:
> Hi Marc,
> On 3/19/20 1:10 PM, Marc Zyngier wrote:
>> Hi Zenghui,
>>
>> On 2020-03-18 06:34, Zenghui Yu wrote:
>>> Hi Marc,
>>>
>>> On 2020/3/5 4:33, Marc Zyngier wrote:
>>>> The GICv4.1 architecture gives the hypervisor the option to let
>>>> the guest choose whether it wants the good old SGIs with an
>>>> active state, or the new, HW-based ones that do not have one.
>>>>
>>>> For this, plumb the configuration of SGIs into the GICv3 MMIO
>>>> handling, present the GICD_TYPER2.nASSGIcap to the guest,
>>>> and handle the GICD_CTLR.nASSGIreq setting.
>>>>
>>>> In order to be able to deal with the restore of a guest, also
>>>> apply the GICD_CTLR.nASSGIreq setting at first run so that we
>>>> can move the restored SGIs to the HW if that's what the guest
>>>> had selected in a previous life.
>>>
>>> I'm okay with the restore path.=A0 But it seems that we still fail to
>>> save the pending state of vSGI - software pending_latch of HW-based
>>> vSGIs will not be updated (and always be false) because we directly
>>> inject them through ITS, so vgic_v3_uaccess_read_pending() can't
>>> tell the correct pending state to user-space (the correct one should
>>> be latched in HW).
>>>
>>> It would be good if we can sync the hardware state into pending_latch
>>> at an appropriate time (just before save), but not sure if we can...
>>
>> The problem is to find the "appropriate time". It would require to define
>> a point in the save sequence where we transition the state from HW to
>> SW. I'm not keen on adding more state than we already have.
> =

> may be we could use a dedicated device group/attr as we have for the ITS
> save tables? the user space would choose.

It means that userspace will be aware of some form of GICv4.1 details
(e.g., get/set vSGI state at HW level) that KVM has implemented.
Is it something that userspace required to know? I'm open to this ;-)

> =

> Thanks
> =

> Eric
>>
>> But what we can do is to just ask the HW to give us the right state
>> on userspace access, at all times. How about this:
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index 48fd9fc229a2..281fe7216c59 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -305,8 +305,18 @@ static unsigned long
>> vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
>>  =A0=A0=A0=A0=A0 */
>>  =A0=A0=A0=A0 for (i =3D 0; i < len * 8; i++) {
>>  =A0=A0=A0=A0=A0=A0=A0=A0 struct vgic_irq *irq =3D vgic_get_irq(vcpu->kv=
m, vcpu, intid + i);
>> +=A0=A0=A0=A0=A0=A0=A0 bool state =3D irq->pending_latch;
>>
>> -=A0=A0=A0=A0=A0=A0=A0 if (irq->pending_latch)
>> +=A0=A0=A0=A0=A0=A0=A0 if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int err;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 err =3D irq_get_irqchip_state(irq->ho=
st_irq,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 IRQCHIP_STATE_PENDING,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 &state);
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 WARN_ON(err);
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (state)
>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 value |=3D (1U << i);
>>
>>  =A0=A0=A0=A0=A0=A0=A0=A0 vgic_put_irq(vcpu->kvm, irq);

Anyway this looks good to me and will do the right thing on a userspace
save.

>>
>> I can add this to "KVM: arm64: GICv4.1: Add direct injection capability
>> to SGI registers".

Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
