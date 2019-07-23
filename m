Return-Path: <SRS0=tngP=VU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CE8C76190
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jul 2019 15:15:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46F13227BF
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jul 2019 15:15:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46F13227BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3DC54A541;
	Tue, 23 Jul 2019 11:15:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3QfaQkeXdMxF; Tue, 23 Jul 2019 11:15:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A58CB4A588;
	Tue, 23 Jul 2019 11:15:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE0B54A57A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jul 2019 11:15:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u4oWioGk9-Wf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jul 2019 11:15:02 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD5A94A52D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jul 2019 11:15:01 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id E9CE530BD1B5;
 Tue, 23 Jul 2019 15:15:00 +0000 (UTC)
Received: from [10.36.116.111] (ovpn-116-111.ams2.redhat.com [10.36.116.111])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5908A5C25A;
 Tue, 23 Jul 2019 15:14:58 +0000 (UTC)
Subject: Re: [PATCH v2 9/9] KVM: arm/arm64: vgic-irqfd: Implement
 kvm_arch_set_irq_inatomic
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-10-marc.zyngier@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <a63b08b8-9539-09b4-1060-7c0d2f2eacac@redhat.com>
Date: Tue, 23 Jul 2019 17:14:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190611170336.121706-10-marc.zyngier@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.49]); Tue, 23 Jul 2019 15:15:01 +0000 (UTC)
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
> Now that we have a cache of MSI->LPI translations, it is pretty
> easy to implement kvm_arch_set_irq_inatomic (this cache can be
> parsed without sleeping).
> 
> Hopefully, this will improve some LPI-heavy workloads.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-irqfd.c | 36 ++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
> index 99e026d2dade..9f203ed8c8f3 100644
> --- a/virt/kvm/arm/vgic/vgic-irqfd.c
> +++ b/virt/kvm/arm/vgic/vgic-irqfd.c
> @@ -77,6 +77,15 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  	return r;
>  }
>  
> +static void kvm_populate_msi(struct kvm_kernel_irq_routing_entry *e,
> +			     struct kvm_msi *msi)
> +{
> +	msi->address_lo = e->msi.address_lo;
> +	msi->address_hi = e->msi.address_hi;
> +	msi->data = e->msi.data;
> +	msi->flags = e->msi.flags;
> +	msi->devid = e->msi.devid;
> +}
>  /**
>   * kvm_set_msi: inject the MSI corresponding to the
s/:/ -
>   * MSI routing entry
> @@ -90,21 +99,36 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>  {
>  	struct kvm_msi msi;
>  
> -	msi.address_lo = e->msi.address_lo;
> -	msi.address_hi = e->msi.address_hi;
> -	msi.data = e->msi.data;
> -	msi.flags = e->msi.flags;
> -	msi.devid = e->msi.devid;
> -
>  	if (!vgic_has_its(kvm))
>  		return -ENODEV;
>  
>  	if (!level)
>  		return -1;
>  
> +	kvm_populate_msi(e, &msi);
>  	return vgic_its_inject_msi(kvm, &msi);
>  }
>  
> +/**
> + * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
s/:/ -
> + *
> + * Currently only direct MSI injecton is supported.
injection
> + */
> +int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
> +			      struct kvm *kvm, int irq_source_id, int level,
> +			      bool line_status)
> +{
> +	if (e->type == KVM_IRQ_ROUTING_MSI && vgic_has_its(kvm) && level) {
> +		struct kvm_msi msi;
> +
> +		kvm_populate_msi(e, &msi);
> +		if (!vgic_its_inject_cached_translation(kvm, &msi))
> +			return 0;
if this fails since its->enabled is false we will re-attempt the
injection though the normal injection path but that's not a big deal.
> +	}
> +
> +	return -EWOULDBLOCK;
> +}
> +
>  int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
>  {
>  	struct kvm_irq_routing_entry *entries;
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
