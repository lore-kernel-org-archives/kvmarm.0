Return-Path: <SRS0=SHHE=UG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB17C2BCA1
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 14:30:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 00CE1212F5
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 14:30:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00CE1212F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8426E4A4F3;
	Fri,  7 Jun 2019 10:30:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yzk636Bt+U5b; Fri,  7 Jun 2019 10:30:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67F8A4A36B;
	Fri,  7 Jun 2019 10:30:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACFBD4A36B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 10:30:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BmByvicfzhOo for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jun 2019 10:29:59 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B17794A369
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 10:29:59 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id BBDB230832F4;
 Fri,  7 Jun 2019 14:29:46 +0000 (UTC)
Received: from [10.36.116.67] (ovpn-116-67.ams2.redhat.com [10.36.116.67])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 79CE26AD23;
 Fri,  7 Jun 2019 14:29:44 +0000 (UTC)
Subject: Re: [PATCH 3/8] KVM: arm/arm64: vgic-its: Cache successful MSI->LPI
 translation
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190606165455.162478-1-marc.zyngier@arm.com>
 <20190606165455.162478-4-marc.zyngier@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <1bf286d1-7c81-0337-66e7-6701627476c7@redhat.com>
Date: Fri, 7 Jun 2019 16:29:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190606165455.162478-4-marc.zyngier@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.44]); Fri, 07 Jun 2019 14:29:52 +0000 (UTC)
Cc: "Raslan, KarimAllah" <karahmed@amazon.de>
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

On 6/6/19 6:54 PM, Marc Zyngier wrote:
> On a successful translation, preserve the parameters in the LPI
> translation cache. Each translation is reusing the last slot
> in the list, naturally evincting the least recently used entry.
evicting
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 41 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 5758504fd934..bc370b6c5afa 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -538,6 +538,45 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
>  	return 0;
>  }
>  
> +static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
> +				       u32 devid, u32 eventid,
> +				       struct vgic_irq *irq)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_translation_cache_entry *cte;
> +	unsigned long flags;
> +
> +	/* Do not cache a directly injected interrupt */
> +	if (irq->hw)
> +		return;
> +
> +	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
> +
> +	/* Always reuse the last entry (LRU policy) */
> +	cte = list_last_entry(&dist->lpi_translation_cache,
> +			      typeof(*cte), entry);
> +
> +	/*
> +	 * Caching the translation implies having an extra reference
> +	 * to the interrupt, so drop the potential reference on what
> +	 * was in the cache, and increment it on the new interrupt.
> +	 */
> +	if (cte->irq)
> +		__vgic_put_lpi_locked(kvm, cte->irq);
> +
> +	vgic_get_irq_kref(irq);
> +
> +	cte->db		= its->vgic_its_base + GITS_TRANSLATER;
> +	cte->devid	= devid;
> +	cte->eventid	= eventid;
> +	cte->irq	= irq;
> +
> +	/* Move the new translation to the head of the list */
> +	list_move(&cte->entry, &dist->lpi_translation_cache);
> +
> +	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
> +}
> +
>  int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>  			 u32 devid, u32 eventid, struct vgic_irq **irq)
>  {
> @@ -558,6 +597,8 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>  	if (!vcpu->arch.vgic_cpu.lpis_enabled)
>  		return -EBUSY;
>  
> +	vgic_its_cache_translation(kvm, its, devid, eventid, ite->irq);
> +
>  	*irq = ite->irq;
>  	return 0;
>  }
> 
Otherwise looks good to me.

Thanks

Eric
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
