Return-Path: <SRS0=CLkw=ZE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27115C17441
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 12:50:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D21B02196E
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 12:49:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HwNjv8wk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D21B02196E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D1FD4B1A3;
	Tue, 12 Nov 2019 07:49:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0sfGLHTEPlU2; Tue, 12 Nov 2019 07:49:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D0944B197;
	Tue, 12 Nov 2019 07:49:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D13084B18D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 07:49:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eJGPm+mkP2NW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Nov 2019 07:49:56 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCB614B17A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 07:49:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1573562996;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=g9s0JIN2xt+eywacAxoWziOVtnj6SE0YzxR2eAkIxak=;
 b=HwNjv8wkyHAUN6apxz5bJYk78NPTG4nKTgrtdI5uQo2E6leo5PTxeqPW6ds0eH+x1RJSi3
 ylaG4/a699iVP5f0j/krUiLWSskNWpy7I5v9ZqW+8kY7df2rsb5wqjwJNY7KzHaFvFEnvh
 DJeJL7GXmjXLQhIyPX2XMAT2sitjWe8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-qfzcBp8jPdia9I30u2CuOg-1; Tue, 12 Nov 2019 07:49:55 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 696978017E0;
 Tue, 12 Nov 2019 12:49:54 +0000 (UTC)
Received: from [10.36.116.54] (ovpn-116-54.ams2.redhat.com [10.36.116.54])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B2A4A10001BD;
 Tue, 12 Nov 2019 12:49:52 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 02/17] arm: gic: Generalise function names
To: Andre Przywara <andre.przywara@arm.com>, Andrew Jones
 <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-3-andre.przywara@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <b2657cf3-202a-3fc5-3268-1f2fcc1b68f2@redhat.com>
Date: Tue, 12 Nov 2019 13:49:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-3-andre.przywara@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: qfzcBp8jPdia9I30u2CuOg-1
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
> In preparation for adding functions to test SPI interrupts, generalise
> some existing functions dealing with IPIs so far, since most of them
> are actually generic for all kind of interrupts.
> This also reformats the irq_handler() function, to later expand it
> more easily.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 04b3337..a114009 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -135,28 +135,30 @@ static void check_ipi_sender(u32 irqstat)
>  	}
>  }
>  
> -static void check_irqnr(u32 irqnr)
> +static void check_irqnr(u32 irqnr, int expected)
>  {
> -	if (irqnr != IPI_IRQ)
> +	if (irqnr != expected)
>  		bad_irq[smp_processor_id()] = irqnr;
>  }
>  
> -static void ipi_handler(struct pt_regs *regs __unused)
> +static void irq_handler(struct pt_regs *regs __unused)
>  {
>  	u32 irqstat = gic_read_iar();
>  	u32 irqnr = gic_iar_irqnr(irqstat);
>  
> -	if (irqnr != GICC_INT_SPURIOUS) {
> -		gic_write_eoir(irqstat);
> -		smp_rmb(); /* pairs with wmb in stats_reset */
> -		++acked[smp_processor_id()];
> -		check_ipi_sender(irqstat);
> -		check_irqnr(irqnr);
> -		smp_wmb(); /* pairs with rmb in check_acked */
> -	} else {
> +	if (irqnr == GICC_INT_SPURIOUS) {
>  		++spurious[smp_processor_id()];
>  		smp_wmb();
> +		return;
>  	}
> +
> +	gic_write_eoir(irqstat);
> +
> +	smp_rmb(); /* pairs with wmb in stats_reset */
> +	++acked[smp_processor_id()];
> +	check_ipi_sender(irqstat);
> +	check_irqnr(irqnr, IPI_IRQ);
> +	smp_wmb(); /* pairs with rmb in check_acked */
>  }
>  
>  static void gicv2_ipi_send_self(void)
> @@ -216,20 +218,20 @@ static void ipi_test_smp(void)
>  	report_prefix_pop();
>  }
>  
> -static void ipi_enable(void)
> +static void irqs_enable(void)
>  {
>  	gic_enable_defaults();
>  #ifdef __arm__
> -	install_exception_handler(EXCPTN_IRQ, ipi_handler);
> +	install_exception_handler(EXCPTN_IRQ, irq_handler);
>  #else
> -	install_irq_handler(EL1H_IRQ, ipi_handler);
> +	install_irq_handler(EL1H_IRQ, irq_handler);
>  #endif
>  	local_irq_enable();
>  }
>  
>  static void ipi_send(void)
>  {
> -	ipi_enable();
> +	irqs_enable();
>  	wait_on_ready();
>  	ipi_test_self();
>  	ipi_test_smp();
> @@ -237,9 +239,9 @@ static void ipi_send(void)
>  	exit(report_summary());
>  }
>  
> -static void ipi_recv(void)
> +static void irq_recv(void)
>  {
> -	ipi_enable();
> +	irqs_enable();
>  	cpumask_set_cpu(smp_processor_id(), &ready);
>  	while (1)
>  		wfi();
> @@ -250,7 +252,7 @@ static void ipi_test(void *data __unused)
>  	if (smp_processor_id() == IPI_SENDER)
>  		ipi_send();
>  	else
> -		ipi_recv();
> +		irq_recv();
>  }
>  
>  static struct gic gicv2 = {
> @@ -285,7 +287,7 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>  
>  		smp_rmb(); /* pairs with wmb in stats_reset */
>  		++acked[smp_processor_id()];
> -		check_irqnr(irqnr);
> +		check_irqnr(irqnr, IPI_IRQ);
>  		smp_wmb(); /* pairs with rmb in check_acked */
>  	} else {
>  		++spurious[smp_processor_id()];
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
