Return-Path: <SRS0=Xpyc=BL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F9DC433E0
	for <kvmarm@archiver.kernel.org>; Sat,  1 Aug 2020 16:22:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 86B1F2071E
	for <kvmarm@archiver.kernel.org>; Sat,  1 Aug 2020 16:22:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H2oWePSH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86B1F2071E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2D844B4BE;
	Sat,  1 Aug 2020 12:22:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8qWyD3IZjWQj; Sat,  1 Aug 2020 12:22:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D73E74B4BD;
	Sat,  1 Aug 2020 12:22:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCDAC4B4BD
 for <kvmarm@lists.cs.columbia.edu>; Sat,  1 Aug 2020 12:22:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V6eEb6BuxGDC for <kvmarm@lists.cs.columbia.edu>;
 Sat,  1 Aug 2020 12:22:52 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 330ED4B4BB
 for <kvmarm@lists.cs.columbia.edu>; Sat,  1 Aug 2020 12:22:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596298971;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=SVFZHd5IjOt0PGLxduG2rpqgoUVL1LQC9cA16QRBC6g=;
 b=H2oWePSH65Iwzgli99mTUnuqHx0GeD2zNwz9U1h8Fdy22T/pt/bSAeEkYMZCyFC8uDwuHM
 4fbKWCQrQZW0H++AkAphJ9wqPGFpllqOzt3J5Q/WVbwbgmC6KlEdY3IYP8xh/v3vWoUniG
 8yptzb7gXU+iPU295lX/UTltkjkPm1o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-yKFADDFLOhqG9BskZGT0Iw-1; Sat, 01 Aug 2020 12:22:50 -0400
X-MC-Unique: yKFADDFLOhqG9BskZGT0Iw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86BBC1DE0;
 Sat,  1 Aug 2020 16:22:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C830C87B30;
 Sat,  1 Aug 2020 16:22:43 +0000 (UTC)
Date: Sat, 1 Aug 2020 18:22:41 +0200
From: Andrew Jones <drjones@redhat.com>
To: Jingyi Wang <wangjingyi11@huawei.com>
Subject: Re: [kvm-unit-tests PATCH v3 08/10] arm64: microbench: Add vtimer
 latency test
Message-ID: <20200801162241.enpfjfl5ykkowchf@kamzik.brq.redhat.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <20200731074244.20432-9-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200731074244.20432-9-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvm@vger.kernel.org, maz@kernel.org, prime.zeng@hisilicon.com,
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

On Fri, Jul 31, 2020 at 03:42:42PM +0800, Jingyi Wang wrote:
> Trigger PPIs by setting up a 10msec timer and test the latency.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 09d9d53..1e1bde5 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -21,8 +21,10 @@
>  #include <libcflat.h>
>  #include <asm/gic.h>
>  #include <asm/gic-v3-its.h>
> +#include <asm/timer.h>
>  
>  #define NS_5_SECONDS (5 * 1000 * 1000 * 1000UL)
> +
>  static u32 cntfrq;
>  
>  static volatile bool irq_ready, irq_received;
> @@ -33,9 +35,16 @@ static void (*write_eoir)(u32 irqstat);
>  
>  static void gic_irq_handler(struct pt_regs *regs)
>  {
> +	u32 irqstat = gic_read_iar();
>  	irq_ready = false;
>  	irq_received = true;
> -	gic_write_eoir(gic_read_iar());
> +	gic_write_eoir(irqstat);
> +
> +	if (irqstat == PPI(TIMER_VTIMER_IRQ)) {
> +		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
> +			     cntv_ctl_el0);
> +		isb();
> +	}
>  	irq_ready = true;
>  }
>  
> @@ -198,6 +207,47 @@ static void lpi_exec(void)
>  	assert_msg(irq_received, "failed to receive LPI in time, but received %d successfully\n", received);
>  }
>  
> +static bool timer_prep(void)
> +{
> +	static void *gic_isenabler;

This doesn't need to be static.

> +
> +	gic_enable_defaults();
> +	install_irq_handler(EL1H_IRQ, gic_irq_handler);
> +	local_irq_enable();
> +
> +	gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;

We can't assume GICv3. This test also runs with GICv2.

I'll fix this up myself.

Thanks,
drew

> +	writel(1 << PPI(TIMER_VTIMER_IRQ), gic_isenabler);
> +	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
> +	isb();
> +
> +	gic_prep_common();
> +	return true;
> +}
> +
> +static void timer_exec(void)
> +{
> +	u64 before_timer;
> +	u64 timer_10ms;
> +	unsigned tries = 1 << 28;
> +	static int received = 0;
> +
> +	irq_received = false;
> +
> +	before_timer = read_sysreg(cntvct_el0);
> +	timer_10ms = cntfrq / 100;
> +	write_sysreg(before_timer + timer_10ms, cntv_cval_el0);
> +	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
> +	isb();
> +
> +	while (!irq_received && tries--)
> +		cpu_relax();
> +
> +	if (irq_received)
> +		++received;
> +
> +	assert_msg(irq_received, "failed to receive PPI in time, but received %d successfully\n", received);
> +}
> +
>  static void hvc_exec(void)
>  {
>  	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
> @@ -245,6 +295,7 @@ static struct exit_test tests[] = {
>  	{"ipi",			ipi_prep,	ipi_exec,		65536,		true},
>  	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		65536,		true},
>  	{"lpi",			lpi_prep,	lpi_exec,		65536,		true},
> +	{"timer_10ms",		timer_prep,	timer_exec,		256,		true},
>  };
>  
>  struct ns_time {
> -- 
> 2.19.1
> 
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
