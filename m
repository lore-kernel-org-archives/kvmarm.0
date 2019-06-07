Return-Path: <SRS0=SHHE=UG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A725C2BCA1
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 12:12:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1486320B7C
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 12:12:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1486320B7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A9B14A3A3;
	Fri,  7 Jun 2019 08:12:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1zaKr-73oYy2; Fri,  7 Jun 2019 08:12:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59D9B4A4A3;
	Fri,  7 Jun 2019 08:12:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6C1E4A4A3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 08:12:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P5YpwgSx7MA0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jun 2019 08:12:09 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DAF84A3A3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 08:12:09 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 2B4B085376;
 Fri,  7 Jun 2019 12:11:58 +0000 (UTC)
Received: from [10.36.116.67] (ovpn-116-67.ams2.redhat.com [10.36.116.67])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F2857D951;
 Fri,  7 Jun 2019 12:11:50 +0000 (UTC)
Subject: Re: [PATCH 2/8] KVM: arm/arm64: vgic: Add __vgic_put_lpi_locked
 primitive
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190606165455.162478-1-marc.zyngier@arm.com>
 <20190606165455.162478-3-marc.zyngier@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <8048ab7f-a429-df29-43da-05ef97c9dc7a@redhat.com>
Date: Fri, 7 Jun 2019 14:11:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190606165455.162478-3-marc.zyngier@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.25]); Fri, 07 Jun 2019 12:12:08 +0000 (UTC)
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
> Our LPI translation cache needs to be able to drop the refcount
> on an LPI whilst already holding the lpi_list_lock.
> 
> Let's add a new primitive for this.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  virt/kvm/arm/vgic/vgic.c | 26 +++++++++++++++++---------
>  virt/kvm/arm/vgic/vgic.h |  1 +
>  2 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 191deccf60bf..376a297e2169 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -130,6 +130,22 @@ static void vgic_irq_release(struct kref *ref)
>  {
>  }
>  
> +/*
> + * Drop the refcount on the LPI. Must be called with lpi_list_lock held.
> + */
> +void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +
> +	if (!kref_put(&irq->refcount, vgic_irq_release))
> +		return;
> +
> +	list_del(&irq->lpi_list);
> +	dist->lpi_list_count--;
> +
> +	kfree(irq);
> +}
> +
>  void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> @@ -139,16 +155,8 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  		return;
>  
>  	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
> -	if (!kref_put(&irq->refcount, vgic_irq_release)) {
> -		raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
> -		return;
> -	};
> -
> -	list_del(&irq->lpi_list);
> -	dist->lpi_list_count--;
> +	__vgic_put_lpi_locked(kvm, irq);
>  	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
> -
> -	kfree(irq);
>  }
>  
>  void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index a58e1b263dca..80cd40575bc9 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -172,6 +172,7 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
>  		     gpa_t addr, int len);
>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  			      u32 intid);
> +void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq);
>  void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
>  bool vgic_get_phys_line_level(struct vgic_irq *irq);
>  void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
