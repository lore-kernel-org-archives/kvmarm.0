Return-Path: <SRS0=vYaB=VV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D72C7618B
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 07:42:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D58D2190F
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 07:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D58D2190F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D77D4A529;
	Wed, 24 Jul 2019 03:41:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PWc3Qeugo4RY; Wed, 24 Jul 2019 03:41:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D2444A55B;
	Wed, 24 Jul 2019 03:41:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A63E4A53F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 03:41:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q9yuWFvOKGEo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jul 2019 03:41:54 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B2F84A529
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 03:41:54 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 8D6A430B8DE4;
 Wed, 24 Jul 2019 07:41:53 +0000 (UTC)
Received: from [10.36.116.102] (ovpn-116-102.ams2.redhat.com [10.36.116.102])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EE5E160603;
 Wed, 24 Jul 2019 07:41:50 +0000 (UTC)
Subject: Re: [PATCH v2 8/9] KVM: arm/arm64: vgic-its: Check the LPI
 translation cache on MSI injection
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-9-marc.zyngier@arm.com>
 <485d9990-a6ad-2be0-e829-a0290d7d6a6f@redhat.com>
 <3e3bf6bc-d1ab-ec77-e94c-d5defd133c5b@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <1642a2fb-153b-070c-465d-fca27b76e3a0@redhat.com>
Date: Wed, 24 Jul 2019 09:41:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <3e3bf6bc-d1ab-ec77-e94c-d5defd133c5b@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.47]); Wed, 24 Jul 2019 07:41:53 +0000 (UTC)
Cc: "Raslan, KarimAllah" <karahmed@amazon.de>, "Saidi,
 Ali" <alisaidi@amazon.com>
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

On 7/23/19 5:45 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On 23/07/2019 16:10, Auger Eric wrote:
>> Hi Marc,
>>
>> On 6/11/19 7:03 PM, Marc Zyngier wrote:
>>> When performing an MSI injection, let's first check if the translation
>>> is already in the cache. If so, let's inject it quickly without
>>> going through the whole translation process.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-its.c | 36 ++++++++++++++++++++++++++++++++++++
>>>  virt/kvm/arm/vgic/vgic.h     |  1 +
>>>  2 files changed, 37 insertions(+)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index 62932458476a..83d80ec33473 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -577,6 +577,20 @@ static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
>>>  	return irq;
>>>  }
>>>  
>>> +static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
>>> +					     u32 devid, u32 eventid)
>>> +{
>>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>>> +	struct vgic_irq *irq;
>>> +	unsigned long flags;
>>> +
>>> +	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
>>> +	irq = __vgic_its_check_cache(dist, db, devid, eventid);
>>> +	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
>>> +
>>> +	return irq;
>>> +}
>>> +
>>>  static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
>>>  				       u32 devid, u32 eventid,
>>>  				       struct vgic_irq *irq)
>>> @@ -736,6 +750,25 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
>>>  	return 0;
>>>  }
>>>  
>>> +int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
>>> +{
>>> +	struct vgic_irq *irq;
>>> +	unsigned long flags;
>>> +	phys_addr_t db;
>>> +
>>> +	db = (u64)msi->address_hi << 32 | msi->address_lo;
>>> +	irq = vgic_its_check_cache(kvm, db, msi->devid, msi->data);
>>
>> I think we miss a check of its->enabled. This is currently done in
>> vgic_its_resolve_lpi() but now likely to be bypassed.
> 
> But why would a translation be cached if the ITS is disabled? It should
> never haver been there the first place (vgic_its_resolve_lpi does check
> for the ITS being enabled, as you pointed out).
> 
> Which makes me think that we miss an invalidate on an ITS being disabled:
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 2633b0e88981..5f2ad74ad834 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1719,6 +1719,8 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
>  		goto out;
>  
>  	its->enabled = !!(val & GITS_CTLR_ENABLE);
> +	if (!its->enabled)
> +		vgic_its_invalidate_cache(kvm);
>  
>  	/*
>  	 * Try to process any pending commands. This function bails out early
> 
> 
> What do you think?

Yes I agree this is the right way to fix it.

Thanks

Eric
> 
> 	M.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
