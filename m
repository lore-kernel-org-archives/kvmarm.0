Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357BBC433E0
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 05:45:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF55D207E8
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 05:45:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LnC8LdEa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF55D207E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07F8E4B566;
	Thu,  2 Jul 2020 01:45:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sEam2enqthqL; Thu,  2 Jul 2020 01:45:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1E144B585;
	Thu,  2 Jul 2020 01:45:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBE884B566
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 01:45:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HFESI6q7zivR for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 01:45:10 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0BC34B4ED
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 01:45:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593668710;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=yR652oxSlxTYwM5dL/VVzR/PWCluQpeWq9VgST7Jcic=;
 b=LnC8LdEaDjtYkh9r05cDKhhjR8YGS+UoTuHM/Z2l3uQLPpenr7c+u4U5leCXsjmdOHnvnK
 V7j3V54Edm9gbWfjhU8QEkd5iPBsAKGfj3+maFu6WQrOJjP0zF8SMY59DGndVxyv4Mj0rB
 N7wSd6rZ+fpdMnH0va2/oISVudr5wTY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-raUkrbCiNB-66kWOJyRoNA-1; Thu, 02 Jul 2020 01:45:08 -0400
X-MC-Unique: raUkrbCiNB-66kWOJyRoNA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 226C810059AA;
 Thu,  2 Jul 2020 05:45:07 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.87])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 675C85DAB0;
 Thu,  2 Jul 2020 05:44:59 +0000 (UTC)
Date: Thu, 2 Jul 2020 07:44:56 +0200
From: Andrew Jones <drjones@redhat.com>
To: Jingyi Wang <wangjingyi11@huawei.com>
Subject: Re: [kvm-unit-tests PATCH v2 8/8] arm64: microbench: Add vtimer
 latency test
Message-ID: <20200702054456.bsy5njbcxu7fzwcs@kamzik.brq.redhat.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-9-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200702030132.20252-9-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Thu, Jul 02, 2020 at 11:01:32AM +0800, Jingyi Wang wrote:
> Trigger PPIs by setting up a 10msec timer and test the latency.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 4c962b7..6822084 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -23,8 +23,13 @@
>  #include <asm/gic-v3-its.h>
>  
>  #define NTIMES (1U << 16)
> +#define NTIMES_MINOR (1U << 8)

As mentioned in the previous patch, no need for this define, just put the
number in the table.

>  #define MAX_NS (5 * 1000 * 1000 * 1000UL)
>  
> +#define IRQ_VTIMER		27

As you can see in the timer test (arm/timer.c) we've been doing our best
not to hard code stuff like this. I'd prefer we don't start now. Actually,
since the timer irqs may come in handy for other tests I'll extract the
DT stuff from arm/timer.c and save those irqs at setup time. I'll send
a patch for that now, then this patch can use the new saved state.

> +#define ARCH_TIMER_CTL_ENABLE	(1 << 0)
> +#define ARCH_TIMER_CTL_IMASK	(1 << 1)

I'll put these defines somewhere common as well.

> +
>  static u32 cntfrq;
>  
>  static volatile bool irq_ready, irq_received;
> @@ -33,9 +38,16 @@ static void (*write_eoir)(u32 irqstat);
>  
>  static void gic_irq_handler(struct pt_regs *regs)
>  {
> +	u32 irqstat = gic_read_iar();
>  	irq_ready = false;
>  	irq_received = true;
> -	gic_write_eoir(gic_read_iar());
> +	gic_write_eoir(irqstat);
> +
> +	if (irqstat == IRQ_VTIMER) {
> +		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
> +			     cntv_ctl_el0);
> +		isb();
> +	}
>  	irq_ready = true;
>  }
>  
> @@ -189,6 +201,47 @@ static void lpi_exec(void)
>  	assert_msg(irq_received, "failed to receive LPI in time, but received %d successfully\n", received);
>  }
>  
> +static bool timer_prep(void)
> +{
> +	static void *gic_isenabler;
> +
> +	gic_enable_defaults();
> +	install_irq_handler(EL1H_IRQ, gic_irq_handler);
> +	local_irq_enable();
> +
> +	gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
> +	writel(1 << 27, gic_isenabler);

You should have used your define here.

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
> @@ -236,6 +289,7 @@ static struct exit_test tests[] = {
>  	{"ipi",			ipi_prep,	ipi_exec,		NTIMES,		true},
>  	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		NTIMES,		true},
>  	{"lpi",			lpi_prep,	lpi_exec,		NTIMES,		true},
> +	{"timer_10ms",		timer_prep,	timer_exec,		NTIMES_MINOR,	true},
>  };
>  
>  struct ns_time {
> -- 
> 2.19.1
> 
> 

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
