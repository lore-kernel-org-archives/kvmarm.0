Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4117C64E7A
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 16:37:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D59020691
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 16:37:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EmzvNsR5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D59020691
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C50A4C280;
	Tue,  1 Dec 2020 11:37:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yRUBKX709aeU; Tue,  1 Dec 2020 11:37:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F8214C29D;
	Tue,  1 Dec 2020 11:37:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C45C04C27F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 11:37:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qEYZXL6z9Uyx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 11:37:46 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9A6B4C251
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 11:37:46 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1606840666;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wL2V5kfaTVmKlTWvGK7gg88wZom4tKDt3zAUF8Om/YU=;
 b=EmzvNsR5b0EgptNT7MIuOvTKr83Vab+cvICs712V0jsyrseZwVvFayq4zYHMirgxA8V0DH
 gOEpDIniuN46lBDD6tWxvbbMFzD4uaASssawd6nxQ2MtV/TG+jD0X0QNoTWmkR9hycPhgt
 jg8cAumEgscPdEdqErH8TXEio4u+Kbo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-hpEhJVE0NSG96_dM23Mb9Q-1; Tue, 01 Dec 2020 11:37:32 -0500
X-MC-Unique: hpEhJVE0NSG96_dM23Mb9Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB5371DDEA;
 Tue,  1 Dec 2020 16:37:30 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B0B760C0F;
 Tue,  1 Dec 2020 16:37:29 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 02/10] lib: arm/arm64: gicv2: Add missing
 barrier when sending IPIs
To: Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, drjones@redhat.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-3-alexandru.elisei@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <43a43738-3169-c989-1067-4fa1964a83d7@redhat.com>
Date: Tue, 1 Dec 2020 17:37:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201125155113.192079-3-alexandru.elisei@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: andre.przywara@arm.com
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

Hi Alexandru,

On 11/25/20 4:51 PM, Alexandru Elisei wrote:
> GICv2 generates IPIs with a MMIO write to the GICD_SGIR register. A common
> pattern for IPI usage is for the IPI receiver to read data written to
> memory by the sender. The armv7 and armv8 architectures implement a
> weakly-ordered memory model, which means that barriers are required to make
> sure that the expected values are observed.
> 
> It turns out that because the receiver CPU must observe the write to memory
> that generated the IPI when reading the GICC_IAR MMIO register, we only
> need to ensure ordering of memory accesses, and not completion. Use a
> smp_wmb (DMB ISHST) barrier before sending the IPI.
> 
> This also matches what the Linux GICv2 irqchip driver does (more details
> in commit 8adbf57fc429 ("irqchip: gic: use dmb ishst instead of dsb when
> raising a softirq")).
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  lib/arm/gic-v2.c | 4 ++++
>  arm/gic.c        | 2 ++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/lib/arm/gic-v2.c b/lib/arm/gic-v2.c
> index dc6a97c600ec..da244c82de34 100644
> --- a/lib/arm/gic-v2.c
> +++ b/lib/arm/gic-v2.c
> @@ -45,6 +45,8 @@ void gicv2_ipi_send_single(int irq, int cpu)
>  {
>  	assert(cpu < 8);
>  	assert(irq < 16);
> +
> +	smp_wmb();
>  	writel(1 << (cpu + 16) | irq, gicv2_dist_base() + GICD_SGIR);
>  }
>  
> @@ -53,5 +55,7 @@ void gicv2_ipi_send_mask(int irq, const cpumask_t *dest)
>  	u8 tlist = (u8)cpumask_bits(dest)[0];
>  
>  	assert(irq < 16);
> +
> +	smp_wmb();
>  	writel(tlist << 16 | irq, gicv2_dist_base() + GICD_SGIR);
>  }
> diff --git a/arm/gic.c b/arm/gic.c
> index 512c83636a2e..401ffafe4299 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -260,11 +260,13 @@ static void check_lpi_hits(int *expected, const char *msg)
>  
>  static void gicv2_ipi_send_self(void)
>  {
> +	smp_wmb();
>  	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
>  }
>  
>  static void gicv2_ipi_send_broadcast(void)
>  {
> +	smp_wmb();
>  	writel(1 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
>  }
>  
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
