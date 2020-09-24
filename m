Return-Path: <SRS0=RYKq=DB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EA9C4363D
	for <kvmarm@archiver.kernel.org>; Thu, 24 Sep 2020 12:59:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA682235FD
	for <kvmarm@archiver.kernel.org>; Thu, 24 Sep 2020 12:59:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EuvxwRw+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA682235FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B6024B131;
	Thu, 24 Sep 2020 08:59:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id drHGXQRV65e2; Thu, 24 Sep 2020 08:59:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C6F4B141;
	Thu, 24 Sep 2020 08:59:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42F274B102
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Sep 2020 08:59:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PQXTn9Hlfatp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Sep 2020 08:59:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 311374B11C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Sep 2020 08:59:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600952380;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=MJ9LAqUJKPp2osVPq5HpA4pPqvybekZg436IfI2lYCk=;
 b=EuvxwRw+9FVHJUEXmbZ2GPaPf2BB4myV1/q2FShHqnKfKshntF7DnSmDghWjGryVT8BEwe
 hRj2HJs+V9CsDylhhE8tw1nTaSFlgJVGH+S+xDQFlo2OmxX9ZMS6RUHoSwprQbGiiV8kH+
 gBL96M0vCvwc1YjzXl5L17xKu40Lr/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-FinDcyc7MPumdkUnQ7YlAg-1; Thu, 24 Sep 2020 08:59:36 -0400
X-MC-Unique: FinDcyc7MPumdkUnQ7YlAg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79890ACE20;
 Thu, 24 Sep 2020 12:59:35 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.158])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2496C60C15;
 Thu, 24 Sep 2020 12:59:32 +0000 (UTC)
Date: Thu, 24 Sep 2020 14:59:30 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Match PMU error code descriptions
 with error conditions
Message-ID: <20200924125930.tcoz7g6kcvg4rooj@kamzik.brq.redhat.com>
References: <20200924123731.268177-1-alexandru.elisei@arm.com>
 <20200924123731.268177-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20200924123731.268177-3-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 24, 2020 at 01:37:31PM +0100, Alexandru Elisei wrote:
> Update the description of the PMU KVM_{GET, SET}_DEVICE_ATTR error codes
> to be a better match for the code that returns them.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index 96d6cf77cb1e..8c24411ece2e 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -26,8 +26,9 @@ Returns:
>  	 =======  ========================================================
>  	 -EBUSY   The PMU overflow interrupt is already set
>  	 -EFAULT  Error reading interrupt number
> -	 -ENXIO   The overflow interrupt not set when attempting to get it
> -	 -ENODEV  PMUv3 not supported
> +	 -ENXIO   PMUv3 not supported or the overflow interrupt not set
> +		  when attempting to get it
> +	 -ENODEV  KVM_ARM_VCPU_PMU_V3 feature missing from VCPU
>  	 -EINVAL  Invalid PMU overflow interrupt number supplied or
>  		  trying to set the IRQ number without using an in-kernel
>  		  irqchip.
> @@ -48,8 +49,8 @@ Returns:
>  	 =======  ======================================================
>  	 -EEXIST  Interrupt number already used
>  	 -ENODEV  PMUv3 not supported or GIC not initialized
> -	 -ENXIO   PMUv3 not properly configured or in-kernel irqchip not
> -		  configured as required prior to calling this attribute
> +	 -ENXIO   PMUv3 not supported, missing VCPU feature or interrupt
> +		  number not set
>  	 -EBUSY   PMUv3 already initialized
>  	 =======  ======================================================
>  
> -- 
> 2.28.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
