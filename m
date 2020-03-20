Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A388EC4332D
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 08:00:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D3F920775
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 08:00:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D72QvPDx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D3F920775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 734044A4FC;
	Fri, 20 Mar 2020 04:00:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id loub46GQBUii; Fri, 20 Mar 2020 04:00:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08A274B083;
	Fri, 20 Mar 2020 04:00:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AEAA4A4A9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 04:00:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3M+Stbbz9aRJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 03:59:57 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [216.205.24.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD2A74A483
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 03:59:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584691197;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=NCLldPyucn2EtjkD/YGvXmu67T8oQjms+EaHjNLuyLQ=;
 b=D72QvPDxgZNPrq1/x/jF8QihyTmFn/XiU/SM0xyc+VSmO6Wh+GAADgohEcuN0K3h6K6CvY
 AjXaWkk3UStGKnaYBWzShcU9fMviP+I8TsU0OayrhH4Plgh6urUtkGX4DcczHejgYbouKM
 mWIlQC6OitgMLDtI1cW8VfrqoM2r9XE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-KENkeixLMkCVD1dP4OHYhg-1; Fri, 20 Mar 2020 03:59:54 -0400
X-MC-Unique: KENkeixLMkCVD1dP4OHYhg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBAB8800D53;
 Fri, 20 Mar 2020 07:59:52 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B2F365C1A5;
 Fri, 20 Mar 2020 07:59:49 +0000 (UTC)
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
To: Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <49995ec9-3970-1f62-5dfc-118563ca00fc@redhat.com>
 <b98855a1-6300-d323-80f6-82d3b9854290@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <e60578b5-910c-0355-d231-29322900679d@redhat.com>
Date: Fri, 20 Mar 2020 08:59:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <b98855a1-6300-d323-80f6-82d3b9854290@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Zenghui,

On 3/20/20 4:08 AM, Zenghui Yu wrote:
> On 2020/3/20 4:38, Auger Eric wrote:
>> Hi Marc,
>> On 3/19/20 1:10 PM, Marc Zyngier wrote:
>>> Hi Zenghui,
>>>
>>> On 2020-03-18 06:34, Zenghui Yu wrote:
>>>> Hi Marc,
>>>>
>>>> On 2020/3/5 4:33, Marc Zyngier wrote:
>>>>> The GICv4.1 architecture gives the hypervisor the option to let
>>>>> the guest choose whether it wants the good old SGIs with an
>>>>> active state, or the new, HW-based ones that do not have one.
>>>>>
>>>>> For this, plumb the configuration of SGIs into the GICv3 MMIO
>>>>> handling, present the GICD_TYPER2.nASSGIcap to the guest,
>>>>> and handle the GICD_CTLR.nASSGIreq setting.
>>>>>
>>>>> In order to be able to deal with the restore of a guest, also
>>>>> apply the GICD_CTLR.nASSGIreq setting at first run so that we
>>>>> can move the restored SGIs to the HW if that's what the guest
>>>>> had selected in a previous life.
>>>>
>>>> I'm okay with the restore path.=A0 But it seems that we still fail to
>>>> save the pending state of vSGI - software pending_latch of HW-based
>>>> vSGIs will not be updated (and always be false) because we directly
>>>> inject them through ITS, so vgic_v3_uaccess_read_pending() can't
>>>> tell the correct pending state to user-space (the correct one should
>>>> be latched in HW).
>>>>
>>>> It would be good if we can sync the hardware state into pending_latch
>>>> at an appropriate time (just before save), but not sure if we can...
>>>
>>> The problem is to find the "appropriate time". It would require to
>>> define
>>> a point in the save sequence where we transition the state from HW to
>>> SW. I'm not keen on adding more state than we already have.
>>
>> may be we could use a dedicated device group/attr as we have for the ITS
>> save tables? the user space would choose.
> =

> It means that userspace will be aware of some form of GICv4.1 details
> (e.g., get/set vSGI state at HW level) that KVM has implemented.
> Is it something that userspace required to know? I'm open to this ;-)
Not sure we would be obliged to expose fine details. This could be a
generic save/restore device group/attr whose implementation at KVM level
could differ depending on the version being implemented, no?

Thanks

Eric
> =

>>
>> Thanks
>>
>> Eric
>>>
>>> But what we can do is to just ask the HW to give us the right state
>>> on userspace access, at all times. How about this:
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> index 48fd9fc229a2..281fe7216c59 100644
>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> @@ -305,8 +305,18 @@ static unsigned long
>>> vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
>>> =A0=A0=A0=A0=A0=A0 */
>>> =A0=A0=A0=A0=A0 for (i =3D 0; i < len * 8; i++) {
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 struct vgic_irq *irq =3D vgic_get_irq(vcpu-=
>kvm, vcpu, intid
>>> + i);
>>> +=A0=A0=A0=A0=A0=A0=A0 bool state =3D irq->pending_latch;
>>>
>>> -=A0=A0=A0=A0=A0=A0=A0 if (irq->pending_latch)
>>> +=A0=A0=A0=A0=A0=A0=A0 if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int err;
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 err =3D irq_get_irqchip_state(irq->h=
ost_irq,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 IRQCHIP_STATE_PENDING,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 &state);
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 WARN_ON(err);
>>> +=A0=A0=A0=A0=A0=A0=A0 }
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 if (state)
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 value |=3D (1U << i);
>>>
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 vgic_put_irq(vcpu->kvm, irq);
> =

> Anyway this looks good to me and will do the right thing on a userspace
> save.
> =

>>>
>>> I can add this to "KVM: arm64: GICv4.1: Add direct injection capability
>>> to SGI registers".
> =

> Thanks,
> Zenghui
> =


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
