Return-Path: <SRS0=xcs2=UY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F492C48BD4
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jun 2019 11:50:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2739F214DA
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jun 2019 11:50:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2739F214DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DAD64A3A5;
	Tue, 25 Jun 2019 07:50:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id skIj8S4XyA2L; Tue, 25 Jun 2019 07:50:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42DBA4A479;
	Tue, 25 Jun 2019 07:50:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55C344A3A5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jun 2019 07:50:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1zaw0uPtXOYm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jun 2019 07:50:38 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A3A64A36B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jun 2019 07:50:37 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id D2A5EB1D8DF8C982AA7F;
 Tue, 25 Jun 2019 19:50:32 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Jun 2019
 19:50:26 +0800
Subject: Re: [PATCH v2 7/9] KVM: arm/arm64: vgic-its: Cache successful
 MSI->LPI translation
To: Marc Zyngier <marc.zyngier@arm.com>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <kvm@vger.kernel.org>
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-8-marc.zyngier@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <53de88e9-3550-bd7f-8266-35c5e75fae4e@huawei.com>
Date: Tue, 25 Jun 2019 19:50:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190611170336.121706-8-marc.zyngier@arm.com>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2019/6/12 1:03, Marc Zyngier wrote:
> On a successful translation, preserve the parameters in the LPI
> translation cache. Each translation is reusing the last slot
> in the list, naturally evincting the least recently used entry.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   virt/kvm/arm/vgic/vgic-its.c | 86 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 86 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 0aa0cbbc3af6..62932458476a 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -546,6 +546,90 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
>   	return 0;
>   }
>   
> +static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
> +					       phys_addr_t db,
> +					       u32 devid, u32 eventid)
> +{
> +	struct vgic_translation_cache_entry *cte;
> +	struct vgic_irq *irq = NULL;
> +
> +	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
> +		/*
> +		 * If we hit a NULL entry, there is nothing after this
> +		 * point.
> +		 */
> +		if (!cte->irq)
> +			break;
> +
> +		if (cte->db == db &&
> +		    cte->devid == devid &&
> +		    cte->eventid == eventid) {
> +			/*
> +			 * Move this entry to the head, as it is the
> +			 * most recently used.
> +			 */
> +			list_move(&cte->entry, &dist->lpi_translation_cache);

Only for performance reasons: if we hit at the "head" of the list, we
don't need to do a list_move().
In our tests, we found that a single list_move() takes nearly (sometimes
even more than) one microsecond, for some unknown reason...


Thanks,
zenghui

> +			irq = cte->irq;
> +			break;
> +		}
> +	}
> +
> +	return irq;
> +}
> +
> +static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
> +				       u32 devid, u32 eventid,
> +				       struct vgic_irq *irq)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_translation_cache_entry *cte;
> +	unsigned long flags;
> +	phys_addr_t db;
> +
> +	/* Do not cache a directly injected interrupt */
> +	if (irq->hw)
> +		return;
> +
> +	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
> +
> +	if (unlikely(list_empty(&dist->lpi_translation_cache)))
> +		goto out;
> +
> +	/*
> +	 * We could have raced with another CPU caching the same
> +	 * translation behind our back, so let's check it is not in
> +	 * already
> +	 */
> +	db = its->vgic_its_base + GITS_TRANSLATER;
> +	if (__vgic_its_check_cache(dist, db, devid, eventid))
> +		goto out;
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
> +	cte->db		= db;
> +	cte->devid	= devid;
> +	cte->eventid	= eventid;
> +	cte->irq	= irq;
> +
> +	/* Move the new translation to the head of the list */
> +	list_move(&cte->entry, &dist->lpi_translation_cache);
> +
> +out:
> +	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
> +}
> +
>   void vgic_its_invalidate_cache(struct kvm *kvm)
>   {
>   	struct vgic_dist *dist = &kvm->arch.vgic;
> @@ -589,6 +673,8 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>   	if (!vcpu->arch.vgic_cpu.lpis_enabled)
>   		return -EBUSY;
>   
> +	vgic_its_cache_translation(kvm, its, devid, eventid, ite->irq);
> +
>   	*irq = ite->irq;
>   	return 0;
>   }
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
