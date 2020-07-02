Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB494C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:37:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35E34207CD
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lr1u6vWe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35E34207CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99AE34B5DD;
	Thu,  2 Jul 2020 09:37:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Aj1cAap6W4MM; Thu,  2 Jul 2020 09:36:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B9404B4A3;
	Thu,  2 Jul 2020 09:36:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83A324B47E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:36:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HGv4979ZLLtS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 09:36:57 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F1B94B45E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:36:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593697017;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UBt7WDGG3AuC3POK4Z/zy7X33K5DaaqbcL+Q5p9yjSY=;
 b=Lr1u6vWe8MZcLOm2qFGHEp3ljRDCehHmZLtKw0PvawGBl/NJp/sAaRN7mndAWWyb24owd3
 G7lr4VCPk6KWLGzIX9PD0rD13ObQxJoI7yBljCHBqlH1FggMLwuIZuOjI5vsBnlXHFwDvs
 h/wJINarrDKHT2jDvpfQpkkSdFv2BcY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-xeZLLrofP3W9P8xs8rOW7A-1; Thu, 02 Jul 2020 09:36:55 -0400
X-MC-Unique: xeZLLrofP3W9P8xs8rOW7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF7F7100CD11;
 Thu,  2 Jul 2020 13:36:53 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F8B460BE1;
 Thu,  2 Jul 2020 13:36:52 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 8/8] arm64: microbench: Add vtimer
 latency test
To: Jingyi Wang <wangjingyi11@huawei.com>, drjones@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-9-wangjingyi11@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <88eacd00-1951-f6de-aa7c-bda48ece4fde@redhat.com>
Date: Thu, 2 Jul 2020 15:36:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200702030132.20252-9-wangjingyi11@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: maz@kernel.org
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

Hi Jingyi,

On 7/2/20 5:01 AM, Jingyi Wang wrote:
> Trigger PPIs by setting up a 10msec timer and test the latency.

so for each iteration the accumulated valued is 10 ms + latency, right?
and what is printed at the end does include the accumulated periods.
Wouldn't it make sense to have a test->post() that substract this value.
You would need to store the actual number of iterations.

Thanks

Eric
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
>  #define MAX_NS (5 * 1000 * 1000 * 1000UL)
>  
> +#define IRQ_VTIMER		27
> +#define ARCH_TIMER_CTL_ENABLE	(1 << 0)
> +#define ARCH_TIMER_CTL_IMASK	(1 << 1)
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
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
