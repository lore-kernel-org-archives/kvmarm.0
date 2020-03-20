Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53ECCC4332E
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 10:57:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D0F6320773
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 10:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IiV3UIqt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0F6320773
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85E114A5A0;
	Fri, 20 Mar 2020 06:57:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sw2zwY5ZLFcD; Fri, 20 Mar 2020 06:57:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85A1B4AF1F;
	Fri, 20 Mar 2020 06:57:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A27C94A578
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 06:56:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Ae60KgZmnnp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 06:56:58 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0EAD4A4A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 06:56:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584701818;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=H3cw3n7DECAvhMsR5v/8iVgWxi7rS06XuVpILiRCFOk=;
 b=IiV3UIqtf4LiqVN/IxurQ4ZJETozXRNvU8qK0zlmUXcOkHmXdUdWU/Uax4ioWbl0UE9Ucs
 bQKZMATTCt8LPoav/fI3gEmsVyWoTA+vbYzE2EVVEOcbjY5/DpsdNmr339xqFSf0g2hry4
 mtotcPjTtM77Mvocxv4iY8xLBnjJSbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-OwZAXjqLMAKh5q-K0N9TJQ-1; Fri, 20 Mar 2020 06:56:56 -0400
X-MC-Unique: OwZAXjqLMAKh5q-K0N9TJQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB188800EBD;
 Fri, 20 Mar 2020 10:56:53 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C5565C1D8;
 Fri, 20 Mar 2020 10:56:49 +0000 (UTC)
Subject: Re: [PATCH v5 18/23] KVM: arm64: GICv4.1: Add direct injection
 capability to SGI registers
To: Marc Zyngier <maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-19-maz@kernel.org>
 <06705d70-0f99-e719-af52-1a5f778562d8@redhat.com>
 <3f7094ffd77a6615d7179be94dbecc60@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <9b1ce453-f24f-7974-99ca-1608ad7c6a13@redhat.com>
Date: Fri, 20 Mar 2020 11:56:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <3f7094ffd77a6615d7179be94dbecc60@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Hi Marc,

On 3/20/20 11:05 AM, Marc Zyngier wrote:
> Hi Eric,
> =

> On 2020-03-20 08:11, Auger Eric wrote:
>> Hi Marc,
>> On 3/4/20 9:33 PM, Marc Zyngier wrote:
>>> Most of the GICv3 emulation code that deals with SGIs now has to be
>>> aware of the v4.1 capabilities in order to benefit from it.
>>>
>>> Add such support, keyed on the interrupt having the hw flag set and
>>> being a SGI.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>> =A0virt/kvm/arm/vgic/vgic-mmio-v3.c | 15 +++++-
>>> =A0virt/kvm/arm/vgic/vgic-mmio.c=A0=A0=A0 | 88 ++++++++++++++++++++++++=
++++++--
>>> =A02 files changed, 96 insertions(+), 7 deletions(-)
>>>
> =

> [...]
> =

>>> @@ -113,7 +125,21 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
>>> =A0=A0=A0=A0=A0=A0=A0=A0 struct vgic_irq *irq =3D vgic_get_irq(vcpu->kv=
m, vcpu, intid +
>>> i);
>>>
>>> =A0=A0=A0=A0=A0=A0=A0=A0 raw_spin_lock_irqsave(&irq->irq_lock, flags);
>>> -=A0=A0=A0=A0=A0=A0=A0 if (vgic_irq_is_mapped_level(irq)) {
>>> +=A0=A0=A0=A0=A0=A0=A0 if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!irq->enabled) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct irq_data *data;
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 irq->enabled =3D true;
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 data =3D &irq_to_desc(ir=
q->host_irq)->irq_data;
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 while (irqd_irq_disabled=
(data))
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enable_irq(i=
rq->host_irq);
>> could you explain me why the while() is requested?
> =

> Ah, interesting question: disable_irq() (and its variants) can nest. This
> means that if you have done two disable_irq(), you must do two enable_irq=
()
> to get back to the interrupt being enabled.
> =

> The locking should ensure that this nesting doesn't happen, but I'm
> paranoid
> (see the GICv4.0 doorbell handling). It also makes it easier to reason
> about
> the initial state.

OK! thank you for this explanation.

Thanks

Eric
> =

> [...]
> =

>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> =

> Thanks!
> =

> =A0=A0=A0=A0=A0=A0=A0=A0 M.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
