Return-Path: <SRS0=tngP=VU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6087C7618B
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jul 2019 15:10:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 99A3E223A0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jul 2019 15:10:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99A3E223A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DB6A4A57A;
	Tue, 23 Jul 2019 11:10:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a2ZHFB1oDzUp; Tue, 23 Jul 2019 11:10:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F93B4A598;
	Tue, 23 Jul 2019 11:10:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56D974A57A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jul 2019 11:10:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gIhLbEdPSjjA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jul 2019 11:10:32 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 284B84A577
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jul 2019 11:10:32 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 7AF31335E7;
 Tue, 23 Jul 2019 15:10:31 +0000 (UTC)
Received: from [10.36.116.111] (ovpn-116-111.ams2.redhat.com [10.36.116.111])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A1055C25A;
 Tue, 23 Jul 2019 15:10:28 +0000 (UTC)
From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 8/9] KVM: arm/arm64: vgic-its: Check the LPI
 translation cache on MSI injection
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-9-marc.zyngier@arm.com>
Message-ID: <485d9990-a6ad-2be0-e829-a0290d7d6a6f@redhat.com>
Date: Tue, 23 Jul 2019 17:10:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190611170336.121706-9-marc.zyngier@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.38]); Tue, 23 Jul 2019 15:10:31 +0000 (UTC)
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

On 6/11/19 7:03 PM, Marc Zyngier wrote:
> When performing an MSI injection, let's first check if the translation
> is already in the cache. If so, let's inject it quickly without
> going through the whole translation process.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 36 ++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h     |  1 +
>  2 files changed, 37 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 62932458476a..83d80ec33473 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -577,6 +577,20 @@ static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
>  	return irq;
>  }
>  
> +static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
> +					     u32 devid, u32 eventid)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_irq *irq;
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
> +	irq = __vgic_its_check_cache(dist, db, devid, eventid);
> +	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
> +
> +	return irq;
> +}
> +
>  static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
>  				       u32 devid, u32 eventid,
>  				       struct vgic_irq *irq)
> @@ -736,6 +750,25 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
>  	return 0;
>  }
>  
> +int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
> +{
> +	struct vgic_irq *irq;
> +	unsigned long flags;
> +	phys_addr_t db;
> +
> +	db = (u64)msi->address_hi << 32 | msi->address_lo;
> +	irq = vgic_its_check_cache(kvm, db, msi->devid, msi->data);

I think we miss a check of its->enabled. This is currently done in
vgic_its_resolve_lpi() but now likely to be bypassed.

Doing that in this function is needed for next patch I think.

Thanks

Eric
> +
> +	if (!irq)
> +		return -1;
> +
> +	raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +	irq->pending_latch = true;
> +	vgic_queue_irq_unlock(kvm, irq, flags);
> +
> +	return 0;
> +}
> +
>  /*
>   * Queries the KVM IO bus framework to get the ITS pointer from the given
>   * doorbell address.
> @@ -747,6 +780,9 @@ int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
>  	struct vgic_its *its;
>  	int ret;
>  
> +	if (!vgic_its_inject_cached_translation(kvm, msi))
> +		return 1;
> +
>  	its = vgic_msi_to_its(kvm, msi);
>  	if (IS_ERR(its))
>  		return PTR_ERR(its);
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 072f810dc441..ad6eba1e2beb 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -317,6 +317,7 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr);
>  int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>  			 u32 devid, u32 eventid, struct vgic_irq **irq);
>  struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
> +int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi);
>  void vgic_lpi_translation_cache_init(struct kvm *kvm);
>  void vgic_lpi_translation_cache_destroy(struct kvm *kvm);
>  void vgic_its_invalidate_cache(struct kvm *kvm);
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
