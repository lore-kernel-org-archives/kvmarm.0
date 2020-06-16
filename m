Return-Path: <SRS0=MRip=75=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA492C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jun 2020 08:53:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A3902074D
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jun 2020 08:53:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HwkSknn3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A3902074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2D4E4B0F0;
	Tue, 16 Jun 2020 04:53:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n+ecITE6T2OQ; Tue, 16 Jun 2020 04:53:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D14C54B0DD;
	Tue, 16 Jun 2020 04:53:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8BAD4B0D5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 04:53:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yc3cKeITxmfn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jun 2020 04:53:00 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8A2F4B0D3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 04:53:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1592297580;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=x6AWtnIXsr8Pf+vdCf9SuJ7M4o4r+GS5IQOCBagOKD0=;
 b=HwkSknn3XD8HR4EJjRtTuEJuD4uJxhGAWPyfChoPlABY3vBB5B6Miwbe04zYZNJcX13Oqn
 gGOVapqOvcm6UvyHsKUkx3zRMm0I8+RW3kUc26aBZZC1wTW+v+3faN6kyXSKIyez6hdyOI
 8NtmVGZP57KYAf9Cc0wKUPxxmtUY8Xk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-Kncd8T43NEerIrj_COjv7A-1; Tue, 16 Jun 2020 04:52:58 -0400
X-MC-Unique: Kncd8T43NEerIrj_COjv7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E637873429;
 Tue, 16 Jun 2020 08:52:57 +0000 (UTC)
Received: from [10.36.114.197] (ovpn-114-197.ams2.redhat.com [10.36.114.197])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ABD4260BEC;
 Tue, 16 Jun 2020 08:52:54 +0000 (UTC)
Subject: Re: [PATCH v2] KVM: arm64: Allow in-atomic injection of SPIs
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200615203844.14793-1-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <c4c2d7ec-16a2-a019-283d-18a9bd576d81@redhat.com>
Date: Tue, 16 Jun 2020 10:52:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200615203844.14793-1-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: kernel-team@android.com
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

On 6/15/20 10:38 PM, Marc Zyngier wrote:
> On a system that uses SPIs to implement MSIs (as it would be
> the case on a GICv2 system exposing a GICv2m to its guests),
> we deny the possibility of injecting SPIs on the in-atomic
> fast-path.
> 
> This results in a very large amount of context-switches
> (roughly equivalent to twice the interrupt rate) on the host,
> and suboptimal performance for the guest (as measured with
> a test workload involving a virtio interface backed by vhost-net).
> Given that GICv2 systems are usually on the low-end of the spectrum
> performance wise, they could do without the aggravation.
> 
> We solved this for GICv3+ITS by having a translation cache. But
> SPIs do not need any extra infrastructure, and can be immediately
> injected in the virtual distributor as the locking is already
> heavy enough that we don't need to worry about anything.
> 
> This halves the number of context switches for the same workload.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
> * From v1:
>   - Drop confusing comment (Zenghui, Eric)
>   - Now consistently return -EWOULDBLOCK when unable to inject (Eric)
>   - Don't inject if the vgic isn't initialized yet (Eric)
> 
>  arch/arm64/kvm/vgic/vgic-irqfd.c | 24 +++++++++++++++++++-----
>  arch/arm64/kvm/vgic/vgic-its.c   |  3 +--
>  2 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
> index d8cdfea5cc96..79f8899b234c 100644
> --- a/arch/arm64/kvm/vgic/vgic-irqfd.c
> +++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
> @@ -100,19 +100,33 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>  
>  /**
>   * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
> - *
> - * Currently only direct MSI injection is supported.
>   */
>  int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>  			      struct kvm *kvm, int irq_source_id, int level,
>  			      bool line_status)
>  {
> -	if (e->type == KVM_IRQ_ROUTING_MSI && vgic_has_its(kvm) && level) {
> +	if (!level)
> +		return -EWOULDBLOCK;
> +
> +	switch (e->type) {
> +	case KVM_IRQ_ROUTING_MSI: {
>  		struct kvm_msi msi;
>  
> +		if (!vgic_has_its(kvm))
> +			break;
> +
>  		kvm_populate_msi(e, &msi);
> -		if (!vgic_its_inject_cached_translation(kvm, &msi))
> -			return 0;
> +		return vgic_its_inject_cached_translation(kvm, &msi);
> +	}
> +
> +	case KVM_IRQ_ROUTING_IRQCHIP:
> +		/*
> +		 * Injecting SPIs is always possible in atomic context
> +		 * as long as the damn vgic is initialized.
> +		 */
> +		if (unlikely(!vgic_initialized(kvm)))
> +			break;
> +		return vgic_irqfd_set_irq(e, kvm, irq_source_id, 1, line_status);
>  	}
>  
>  	return -EWOULDBLOCK;
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index c012a52b19f5..40cbaca81333 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -757,9 +757,8 @@ int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
>  
>  	db = (u64)msi->address_hi << 32 | msi->address_lo;
>  	irq = vgic_its_check_cache(kvm, db, msi->devid, msi->data);
> -
>  	if (!irq)
> -		return -1;
> +		return -EWOULDBLOCK;
>  
>  	raw_spin_lock_irqsave(&irq->irq_lock, flags);
>  	irq->pending_latch = true;
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
