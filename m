Return-Path: <SRS0=uW/I=UL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4AEC31E46
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 08:16:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE1702086A
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 08:16:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE1702086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28E824A522;
	Wed, 12 Jun 2019 04:16:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3qyr55rJECcq; Wed, 12 Jun 2019 04:16:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C67034A4A4;
	Wed, 12 Jun 2019 04:16:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C5774A4A4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 04:16:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LSiq32OVbpuR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jun 2019 04:16:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05BF94A4A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 04:16:30 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6309B2B;
 Wed, 12 Jun 2019 01:16:30 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 83E803F246;
 Wed, 12 Jun 2019 01:16:24 -0700 (PDT)
Subject: Re: [PATCH v2 1/9] KVM: arm/arm64: vgic: Add LPI translation cache
 definition
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-2-marc.zyngier@arm.com>
From: Julien Thierry <julien.thierry@arm.com>
Message-ID: <54c8547a-51fb-8ae5-975f-261d3934221a@arm.com>
Date: Wed, 12 Jun 2019 09:16:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190611170336.121706-2-marc.zyngier@arm.com>
Content-Language: en-US
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

On 11/06/2019 18:03, Marc Zyngier wrote:
> Add the basic data structure that expresses an MSI to LPI
> translation as well as the allocation/release hooks.
> 
> THe size of the cache is arbitrarily defined as 4*nr_vcpus.
>

The size has been arbitrarily changed to 16*nr_vcpus :) .

Nit: The*

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/kvm/arm_vgic.h        |  3 +++
>  virt/kvm/arm/vgic/vgic-init.c |  5 ++++
>  virt/kvm/arm/vgic/vgic-its.c  | 49 +++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h      |  2 ++
>  4 files changed, 59 insertions(+)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index c36c86f1ec9a..ca7bcf52dc85 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -260,6 +260,9 @@ struct vgic_dist {
>  	struct list_head	lpi_list_head;
>  	int			lpi_list_count;
>  
> +	/* LPI translation cache */
> +	struct list_head	lpi_translation_cache;
> +
>  	/* used by vgic-debug */
>  	struct vgic_state_iter *iter;
>  
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 3bdb31eaed64..c7c4c77dd430 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -64,6 +64,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  
>  	INIT_LIST_HEAD(&dist->lpi_list_head);
> +	INIT_LIST_HEAD(&dist->lpi_translation_cache);
>  	raw_spin_lock_init(&dist->lpi_list_lock);
>  }
>  
> @@ -305,6 +306,7 @@ int vgic_init(struct kvm *kvm)
>  	}
>  
>  	if (vgic_has_its(kvm)) {
> +		vgic_lpi_translation_cache_init(kvm);
>  		ret = vgic_v4_init(kvm);
>  		if (ret)
>  			goto out;
> @@ -346,6 +348,9 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>  		INIT_LIST_HEAD(&dist->rd_regions);
>  	}
>  
> +	if (vgic_has_its(kvm))
> +		vgic_lpi_translation_cache_destroy(kvm);
> +
>  	if (vgic_supports_direct_msis(kvm))
>  		vgic_v4_teardown(kvm);
>  }
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 44ceaccb18cf..ce9bcddeb7f1 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -149,6 +149,14 @@ struct its_ite {
>  	u32 event_id;
>  };
>  
> +struct vgic_translation_cache_entry {
> +	struct list_head	entry;
> +	phys_addr_t		db;
> +	u32			devid;
> +	u32			eventid;
> +	struct vgic_irq		*irq;
> +};
> +
>  /**
>   * struct vgic_its_abi - ITS abi ops and settings
>   * @cte_esz: collection table entry size
> @@ -1668,6 +1676,45 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its,
>  	return ret;
>  }
>  
> +/* Default is 16 cached LPIs per vcpu */
> +#define LPI_DEFAULT_PCPU_CACHE_SIZE	16
> +
> +void vgic_lpi_translation_cache_init(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	unsigned int sz;
> +	int i;
> +
> +	if (!list_empty(&dist->lpi_translation_cache))
> +		return;
> +
> +	sz = atomic_read(&kvm->online_vcpus) * LPI_DEFAULT_PCPU_CACHE_SIZE;
> +
> +	for (i = 0; i < sz; i++) {
> +		struct vgic_translation_cache_entry *cte;
> +
> +		/* An allocation failure is not fatal */
> +		cte = kzalloc(sizeof(*cte), GFP_KERNEL);
> +		if (WARN_ON(!cte))
> +			break;
> +
> +		INIT_LIST_HEAD(&cte->entry);
> +		list_add(&cte->entry, &dist->lpi_translation_cache);

Going through the series, it looks like this list is either empty
(before the cache init) or has a fixed number
(LPI_DEFAULT_PCPU_CACHE_SIZE * nr_cpus) of entries. And the list never
grows nor shrinks throughout the series, so it seems odd to be using a
list here.

Is there a reason for not using a dynamically allocated array instead of
the list? (does list_move() provide a big perf advantage over swapping
the data from one array entry to another? Or is there some other
facility I am missing?

Cheers,

-- 
Julien Thierry
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
