Return-Path: <SRS0=Wnhb=5E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58742C4332B
	for <kvmarm@archiver.kernel.org>; Thu, 19 Mar 2020 16:16:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E65D20775
	for <kvmarm@archiver.kernel.org>; Thu, 19 Mar 2020 16:16:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HbGhDGE8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E65D20775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABB934A578;
	Thu, 19 Mar 2020 12:16:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qF0fAwZlTu4J; Thu, 19 Mar 2020 12:16:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85DF14AF1F;
	Thu, 19 Mar 2020 12:16:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4BD84A500
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 12:16:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LhMHV6xPacQ7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2020 12:16:45 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A78594A4E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 12:16:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584634605;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=6L0/RW+VybIY9YlBcySb8qcqc4y1OrahRYFLfqqgB0g=;
 b=HbGhDGE8w8Vg3HCNyxS3XxXytMxdkGppt25xuowXMSVh7UnXUcqCbZbzZAfe6f71whm5ca
 BIFRHjuQkeMby8CUJSHaosWyzW7DDlBD+ppl+1eAbav58TBzx1b22x5LS6Ckx7UsnIwHMi
 1sIILETg1no26g+dT2qNLEt8cAZbijg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-vX5yTDLbP-aj3TcYLVcNAw-1; Thu, 19 Mar 2020 12:16:43 -0400
X-MC-Unique: vX5yTDLbP-aj3TcYLVcNAw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 129021005516;
 Thu, 19 Mar 2020 16:16:41 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D7D6F60BF1;
 Thu, 19 Mar 2020 16:16:37 +0000 (UTC)
Subject: Re: [PATCH v5 19/23] KVM: arm64: GICv4.1: Allow SGIs to switch
 between HW and SW interrupts
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-20-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <8a6cf87a-7eee-5502-3b54-093ea0ab5e2d@redhat.com>
Date: Thu, 19 Mar 2020 17:16:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-20-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>
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

On 3/4/20 9:33 PM, Marc Zyngier wrote:
> In order to let a guest buy in the new, active-less SGIs, we
> need to be able to switch between the two modes.
> 
> Handle this by stopping all guest activity, transfer the state
> from one mode to the other, and resume the guest. Nothing calls
> this code so far, but a later patch will plug it into the MMIO
> emulation.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  include/kvm/arm_vgic.h      |  3 ++
>  virt/kvm/arm/vgic/vgic-v4.c | 94 +++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h    |  1 +
>  3 files changed, 98 insertions(+)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 63457908c9c4..69f4164d6477 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -231,6 +231,9 @@ struct vgic_dist {
>  	/* distributor enabled */
>  	bool			enabled;
>  
> +	/* Wants SGIs without active state */
> +	bool			nassgireq;
> +
>  	struct vgic_irq		*spis;
>  
>  	struct vgic_io_device	dist_iodev;
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index c2fcde104ea2..a65dc1c85363 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -97,6 +97,100 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
>  	return IRQ_HANDLED;
>  }
>  
> +static void vgic_v4_sync_sgi_config(struct its_vpe *vpe, struct vgic_irq *irq)
> +{
> +	vpe->sgi_config[irq->intid].enabled	= irq->enabled;
> +	vpe->sgi_config[irq->intid].group 	= irq->group;
> +	vpe->sgi_config[irq->intid].priority	= irq->priority;
> +}
> +
> +static void vgic_v4_enable_vsgis(struct kvm_vcpu *vcpu)
> +{
> +	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
> +	int i;
> +
> +	/*
> +	 * With GICv4.1, every virtual SGI can be directly injected. So
> +	 * let's pretend that they are HW interrupts, tied to a host
> +	 * IRQ. The SGI code will do its magic.
> +	 */
> +	for (i = 0; i < VGIC_NR_SGIS; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
> +		struct irq_desc *desc;
> +		int ret;
Is is safe without holding the irq->irq_lock?
> +
> +		if (irq->hw) {
> +			vgic_put_irq(vcpu->kvm, irq);
> +			continue;
> +		}
> +
> +		irq->hw = true;
> +		irq->host_irq = irq_find_mapping(vpe->sgi_domain, i);
> +
> +		/* Transfer the full irq state to the vPE */
> +		vgic_v4_sync_sgi_config(vpe, irq);
> +		desc = irq_to_desc(irq->host_irq);
> +		ret = irq_domain_activate_irq(irq_desc_get_irq_data(desc),
> +					      false);
> +		if (!WARN_ON(ret)) {
> +			/* Transfer pending state */
> +			ret = irq_set_irqchip_state(irq->host_irq,
> +						    IRQCHIP_STATE_PENDING,
> +						    irq->pending_latch);
> +			WARN_ON(ret);
> +			irq->pending_latch = false;
> +		}
> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +}
> +
> +static void vgic_v4_disable_vsgis(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +
> +	for (i = 0; i < VGIC_NR_SGIS; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
> +		struct irq_desc *desc;
> +		int ret;
> +
> +		if (!irq->hw) {
> +			vgic_put_irq(vcpu->kvm, irq);
> +			continue;
> +		}
> +
> +		irq->hw = false;
> +		ret = irq_get_irqchip_state(irq->host_irq,
> +					    IRQCHIP_STATE_PENDING,
> +					    &irq->pending_latch);
> +		WARN_ON(ret);
> +
> +		desc = irq_to_desc(irq->host_irq);
> +		irq_domain_deactivate_irq(irq_desc_get_irq_data(desc));
> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +}
> +
> +/* Must be called with the kvm lock held */
> +void vgic_v4_configure_vsgis(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	kvm_arm_halt_guest(kvm);
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (dist->nassgireq)
> +			vgic_v4_enable_vsgis(vcpu);
> +		else
> +			vgic_v4_disable_vsgis(vcpu);
> +	}
> +
> +	kvm_arm_resume_guest(kvm);
> +}
> +
>  /**
>   * vgic_v4_init - Initialize the GICv4 data structures
>   * @kvm:	Pointer to the VM being initialized
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index c7fefd6b1c80..769e4802645e 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -316,5 +316,6 @@ void vgic_its_invalidate_cache(struct kvm *kvm);
>  bool vgic_supports_direct_msis(struct kvm *kvm);
>  int vgic_v4_init(struct kvm *kvm);
>  void vgic_v4_teardown(struct kvm *kvm);
> +void vgic_v4_configure_vsgis(struct kvm *kvm);
>  
>  #endif
> 
Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
