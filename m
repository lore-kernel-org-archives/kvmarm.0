Return-Path: <SRS0=FDwM=5C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA440C18E5B
	for <kvmarm@archiver.kernel.org>; Tue, 17 Mar 2020 10:30:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4775220663
	for <kvmarm@archiver.kernel.org>; Tue, 17 Mar 2020 10:30:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IJ89DOJw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4775220663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 810A94A531;
	Tue, 17 Mar 2020 06:30:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2mK4c6gzN7Mc; Tue, 17 Mar 2020 06:30:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6781F4AF1F;
	Tue, 17 Mar 2020 06:30:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9791C4A4A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2020 06:30:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XL92QpPPeFjv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Mar 2020 06:30:31 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BD9A4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2020 06:30:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584441031;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=E3boV3yl7QUZP/2283Qn125pIkCavFJHZDCmoHG9RZ4=;
 b=IJ89DOJwli2fBGnmlrF2j2nGledp6LH8O5pqyZ7kf5YDSPCjJxbGrS7j4xsTJorj1Qt9or
 uzLH7zKW2MUMQj+o7OUARmrdJj9gWwNJeJxzO5i8fogvmSw705VeW5l5wSDU2vuxs1hh5a
 XXO2xOdTE4ZNVhC5pyaKHuhz1v79450=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-q__xEIZcPW-S9ONrSCl3rA-1; Tue, 17 Mar 2020 06:30:27 -0400
X-MC-Unique: q__xEIZcPW-S9ONrSCl3rA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE6F68018A4;
 Tue, 17 Mar 2020 10:30:24 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C12419C58;
 Tue, 17 Mar 2020 10:30:21 +0000 (UTC)
Subject: Re: [PATCH v5 15/23] irqchip/gic-v4.1: Add VSGI property setup
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-16-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <edfc4aa0-3e96-4fb2-731e-76a284c8ce17@redhat.com>
Date: Tue, 17 Mar 2020 11:30:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-16-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
> Add the SGI configuration entry point for KVM to use.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  drivers/irqchip/irq-gic-v3-its.c   |  2 +-
>  drivers/irqchip/irq-gic-v4.c       | 13 +++++++++++++
>  include/linux/irqchip/arm-gic-v4.h |  3 ++-
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index effb0e0b0c9d..b65fba67bd85 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -4039,7 +4039,7 @@ static int its_sgi_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
>  	struct its_cmd_info *info = vcpu_info;
>  
>  	switch (info->cmd_type) {
> -	case PROP_UPDATE_SGI:
> +	case PROP_UPDATE_VSGI:
This change rather belongs to
[PATCH v5 12/23] irqchip/gic-v4.1: Plumb set_vcpu_affinity SGI callbacks
>  		vpe->sgi_config[d->hwirq].priority = info->priority;
>  		vpe->sgi_config[d->hwirq].group = info->group;
>  		its_configure_sgi(d, false);
> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index 99b33f60ac63..0c18714ae13e 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -320,6 +320,19 @@ int its_prop_update_vlpi(int irq, u8 config, bool inv)
>  	return irq_set_vcpu_affinity(irq, &info);
>  }
>  
> +int its_prop_update_vsgi(int irq, u8 priority, bool group)
> +{
> +	struct its_cmd_info info = {
> +		.cmd_type = PROP_UPDATE_VSGI,
> +		{
> +			.priority	= priority,
> +			.group		= group,
> +		},
> +	};
> +
> +	return irq_set_vcpu_affinity(irq, &info);
> +}
> +
>  int its_init_v4(struct irq_domain *domain,
>  		const struct irq_domain_ops *vpe_ops,
>  		const struct irq_domain_ops *sgi_ops)
> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
> index 0bb111b4a504..6976b8331b60 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -105,7 +105,7 @@ enum its_vcpu_info_cmd_type {
>  	SCHEDULE_VPE,
>  	DESCHEDULE_VPE,
>  	INVALL_VPE,
> -	PROP_UPDATE_SGI,
> +	PROP_UPDATE_VSGI,
same
>  };
>  
>  struct its_cmd_info {
> @@ -134,6 +134,7 @@ int its_map_vlpi(int irq, struct its_vlpi_map *map);
>  int its_get_vlpi(int irq, struct its_vlpi_map *map);
>  int its_unmap_vlpi(int irq);
>  int its_prop_update_vlpi(int irq, u8 config, bool inv);
> +int its_prop_update_vsgi(int irq, u8 priority, bool group);
>  
>  struct irq_domain_ops;
>  int its_init_v4(struct irq_domain *domain,
> 
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
