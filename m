Return-Path: <SRS0=bMLL=C6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3562DC43465
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 14:15:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 86F0420BED
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 14:15:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GtYsAtBp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86F0420BED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA7F94B5B4;
	Mon, 21 Sep 2020 10:15:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iWjScspPhotG; Mon, 21 Sep 2020 10:15:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0D574B58F;
	Mon, 21 Sep 2020 10:15:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 774CD4B58F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 10:15:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cre7vJBUipFY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Sep 2020 10:15:43 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EAB04B3B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 10:15:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600697743;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=c28whiQjSDHabTFlVVNJ79y4LDFVv2UNDOXirF/Q+Do=;
 b=GtYsAtBpb66BnthaSBDrg9ftxgYC2FPjnccSBjKU/lUkgY496lpQwyq8ZWV6/2Cffdr8rd
 K3zYeIGe3gmFkdqHrpLMNkobZo09nblPzs9WCcZh0pMtSXEHMMsF90Ik/tNr+FiaDCSMUT
 xjn9dro/79lHoHaJ0JxQT59B7cpyb/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-m_Uo8ONVPNWahFKvXQTFXg-1; Mon, 21 Sep 2020 10:15:41 -0400
X-MC-Unique: m_Uo8ONVPNWahFKvXQTFXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E1611017DDD;
 Mon, 21 Sep 2020 14:15:40 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.131])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DDC925C1DC;
 Mon, 21 Sep 2020 14:15:38 +0000 (UTC)
Date: Mon, 21 Sep 2020 16:15:35 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Add undocumented return values for PMU
 device control group
Message-ID: <20200921141535.g7tehagozjpdfh2f@kamzik.brq.redhat.com>
References: <20200921130838.37296-1-alexandru.elisei@arm.com>
 <20200921130838.37296-2-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20200921130838.37296-2-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Mon, Sep 21, 2020 at 02:08:37PM +0100, Alexandru Elisei wrote:
> KVM_ARM_VCPU_PMU_V3_IRQ returns -EFAULT if get_user() fails when reading
> the interrupt number from kvm_device_attr.addr.
> 
> KVM_ARM_VCPU_PMU_V3_INIT returns the error value from kvm_vgic_set_owner().
> kvm_arm_pmu_v3_init() checks that the vgic has been initialized and the
> interrupt number is valid, but kvm_vgic_set_owner() can still return the
> error code -EEXIST if another device has already claimed the interrupt.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index ca374d3fe085..96d6cf77cb1e 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -25,6 +25,7 @@ Returns:
>  
>  	 =======  ========================================================
>  	 -EBUSY   The PMU overflow interrupt is already set
> +	 -EFAULT  Error reading interrupt number
>  	 -ENXIO   The overflow interrupt not set when attempting to get it
>  	 -ENODEV  PMUv3 not supported
>  	 -EINVAL  Invalid PMU overflow interrupt number supplied or
> @@ -45,6 +46,7 @@ all vcpus, while as an SPI it must be a separate number per vcpu.
>  Returns:
>  
>  	 =======  ======================================================
> +	 -EEXIST  Interrupt number already used
>  	 -ENODEV  PMUv3 not supported or GIC not initialized
>  	 -ENXIO   PMUv3 not properly configured or in-kernel irqchip not
>  		  configured as required prior to calling this attribute
> -- 
> 2.28.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
