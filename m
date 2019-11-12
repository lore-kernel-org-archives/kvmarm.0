Return-Path: <SRS0=CLkw=ZE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A089C17448
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 20:56:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F11F82196E
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 20:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O8Ywv8KJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F11F82196E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CCCD4B1A8;
	Tue, 12 Nov 2019 15:56:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9WS8ZK70zr9y; Tue, 12 Nov 2019 15:56:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 573D44B199;
	Tue, 12 Nov 2019 15:56:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 535484B199
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 15:56:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I1HmUG4Q78fx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Nov 2019 15:56:19 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67FF24B12B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 15:56:19 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1573592179;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=iWnDUrwMNWzeWSYABRZ4rErF0Ev5zOYIDNIsGxLphw8=;
 b=O8Ywv8KJu3qbm407nxkwy9tR4CuoePBUaQmpqEBeuNS/hlLOO2fxPigoItFaGM/ZCdfFFr
 /fxFcQAEzP3kyoRr6XOygl99gDFyN2smitk/qcnTP8jqmuX9ngE/uDGWNPuLez6HwNdthu
 pvjBVygwbNd6ZieaaX1pkJ/L7AQpPCA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-x35vS6cbODWuRti3I0hJ_Q-1; Tue, 12 Nov 2019 15:56:17 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BDBE800C61;
 Tue, 12 Nov 2019 20:56:16 +0000 (UTC)
Received: from [10.36.116.54] (ovpn-116-54.ams2.redhat.com [10.36.116.54])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 52A2D66089;
 Tue, 12 Nov 2019 20:56:14 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 05/17] arm: gic: Prepare IRQ handler for
 handling SPIs
To: Andre Przywara <andre.przywara@arm.com>, Andrew Jones
 <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-6-andre.przywara@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <76947b00-816b-9363-a9d6-5e4ef92b74c5@redhat.com>
Date: Tue, 12 Nov 2019 21:56:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-6-andre.przywara@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: x35vS6cbODWuRti3I0hJ_Q-1
X-Mimecast-Spam-Score: 0
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

Hi Andre,

On 11/8/19 3:42 PM, Andre Przywara wrote:
> So far our IRQ handler routine checks that the received IRQ is actually
> the one SGI (IPI) that we are using for our testing.
> 
> To make the IRQ testing routine more versatile, also allow the IRQ to be
> one test SPI (shared interrupt).
> We use the penultimate IRQ of the first SPI group for that purpose.
I don't get the above sentence. What do you mean by group here?
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index eca9188..c909668 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -23,6 +23,7 @@
>  
>  #define IPI_SENDER	1
>  #define IPI_IRQ		1
> +#define SPI_IRQ		(GIC_FIRST_SPI + 30)
>  
>  struct gic {
>  	struct {
> @@ -162,8 +163,12 @@ static void irq_handler(struct pt_regs *regs __unused)
>  
>  	smp_rmb(); /* pairs with wmb in stats_reset */
>  	++acked[smp_processor_id()];
> -	check_ipi_sender(irqstat);
> -	check_irqnr(irqnr, IPI_IRQ);
> +	if (irqnr < GIC_NR_PRIVATE_IRQS) {
> +		check_ipi_sender(irqstat);
> +		check_irqnr(irqnr, IPI_IRQ);
> +	} else {
> +		check_irqnr(irqnr, SPI_IRQ);
I think I would rather have different handlers per test.
I have rebased the ITS series and I use a different LPI handler there.
I think you shouldn't be obliged to hardcode a specific intid in the
handler.

Can't we have
static void setup_irq(handler_t handler)?

Thanks

Eric

> +	}
>  	smp_wmb(); /* pairs with rmb in check_acked */
>  }
>  
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
