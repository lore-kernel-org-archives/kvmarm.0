Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE10C433DF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 09:15:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA18F20702
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 09:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gwu002fc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA18F20702
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C9004B59D;
	Thu,  2 Jul 2020 05:15:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NQf0FBxz5u6Y; Thu,  2 Jul 2020 05:15:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E12E54B5D7;
	Thu,  2 Jul 2020 05:15:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D6414B59D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 05:15:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MWmcYX6NsylC for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 05:15:14 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E7124B45B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 05:15:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593681314;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7S7MSuE7kaFmACLQA6pqDsKKSrej9Vp477iL2LBwykI=;
 b=Gwu002fcsDTRbJqqzQhm5tKGSIoDnfIoivI7UB2Efv20oeuusKW1mbhjzOzlBP5SQSq1BJ
 FBDozhGY1J7+yJf/pHPGxCUZkNUgYjBI6euGyoYFOth5ueav7Rq/bqjZQKPr1R0ypQa9WD
 9wC77UZP53kIHD3/uczNOjmoqTSSXBM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-JyMt6KthMJ6WDQ3biDhsZA-1; Thu, 02 Jul 2020 05:15:12 -0400
X-MC-Unique: JyMt6KthMJ6WDQ3biDhsZA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E35F51B18BC1;
 Thu,  2 Jul 2020 09:15:10 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C66C477897;
 Thu,  2 Jul 2020 09:15:08 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] arm/arm64: timer: Extract irqs at setup
 time
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20200702081219.27176-1-drjones@redhat.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <105fbb98-3716-28cf-5840-2f83af7651c7@redhat.com>
Date: Thu, 2 Jul 2020 11:15:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200702081219.27176-1-drjones@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Hi Drew,

On 7/2/20 10:12 AM, Andrew Jones wrote:
> The timer can be useful for other tests besides the timer test.
> Extract the DT parsing of the irqs out of the timer test into
> setup and provide them along with some defines in a new timer.h
> file.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  arm/timer.c           | 26 ++++----------------------
>  lib/arm/asm/timer.h   | 31 +++++++++++++++++++++++++++++++
>  lib/arm/setup.c       | 42 ++++++++++++++++++++++++++++++++++++++++++
>  lib/arm64/asm/timer.h |  1 +
>  4 files changed, 78 insertions(+), 22 deletions(-)
>  create mode 100644 lib/arm/asm/timer.h
>  create mode 100644 lib/arm64/asm/timer.h
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index 44621b4f2967..09e3f8f6bd7d 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -8,15 +8,12 @@
>  #include <libcflat.h>
>  #include <devicetree.h>
>  #include <errata.h>
> +#include <asm/timer.h>
>  #include <asm/delay.h>
>  #include <asm/processor.h>
>  #include <asm/gic.h>
>  #include <asm/io.h>
>  
> -#define ARCH_TIMER_CTL_ENABLE  (1 << 0)
> -#define ARCH_TIMER_CTL_IMASK   (1 << 1)
> -#define ARCH_TIMER_CTL_ISTATUS (1 << 2)
> -
>  static void *gic_isenabler;
>  static void *gic_icenabler;
>  
> @@ -108,7 +105,6 @@ static void write_ptimer_ctl(u64 val)
>  
>  struct timer_info {
>  	u32 irq;
> -	u32 irq_flags;
>  	volatile bool irq_received;
>  	u64 (*read_counter)(void);
>  	u64 (*read_cval)(void);
> @@ -304,23 +300,9 @@ static void test_ptimer(void)
>  
>  static void test_init(void)
>  {
> -	const struct fdt_property *prop;
> -	const void *fdt = dt_fdt();
> -	int node, len;
> -	u32 *data;
> -
> -	node = fdt_node_offset_by_compatible(fdt, -1, "arm,armv8-timer");
> -	assert(node >= 0);
> -	prop = fdt_get_property(fdt, node, "interrupts", &len);
> -	assert(prop && len == (4 * 3 * sizeof(u32)));
> -
> -	data = (u32 *)prop->data;
> -	assert(fdt32_to_cpu(data[3]) == 1);
> -	ptimer_info.irq = fdt32_to_cpu(data[4]);
> -	ptimer_info.irq_flags = fdt32_to_cpu(data[5]);
> -	assert(fdt32_to_cpu(data[6]) == 1);
> -	vtimer_info.irq = fdt32_to_cpu(data[7]);
> -	vtimer_info.irq_flags = fdt32_to_cpu(data[8]);
> +	assert(TIMER_PTIMER_IRQ != -1 && TIMER_VTIMER_IRQ != -1);
> +	ptimer_info.irq = TIMER_PTIMER_IRQ;
> +	vtimer_info.irq = TIMER_VTIMER_IRQ;
>  
>  	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
>  	ptimer_info.read_ctl();
> diff --git a/lib/arm/asm/timer.h b/lib/arm/asm/timer.h
> new file mode 100644
> index 000000000000..f75cc67f3ac4
> --- /dev/null
> +++ b/lib/arm/asm/timer.h
> @@ -0,0 +1,31 @@
> +/*
> + * Copyright (C) 2020, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#ifndef _ASMARM_TIMER_H_
> +#define _ASMARM_TIMER_H_
> +
> +#define ARCH_TIMER_CTL_ENABLE  (1 << 0)
> +#define ARCH_TIMER_CTL_IMASK   (1 << 1)
> +#define ARCH_TIMER_CTL_ISTATUS (1 << 2)
> +
> +#ifndef __ASSEMBLY__
> +
> +struct timer_state {
> +	struct {
> +		u32 irq;
> +		u32 irq_flags;
> +	} ptimer;
> +	struct {
> +		u32 irq;
> +		u32 irq_flags;
> +	} vtimer;
> +};
> +extern struct timer_state __timer_state;
> +
> +#define TIMER_PTIMER_IRQ (__timer_state.ptimer.irq)
> +#define TIMER_VTIMER_IRQ (__timer_state.vtimer.irq)
> +
> +#endif /* !__ASSEMBLY__ */
> +#endif /* _ASMARM_TIMER_H_ */
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 418b4e58a5f8..78562e47c01c 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -22,6 +22,7 @@
>  #include <asm/page.h>
>  #include <asm/processor.h>
>  #include <asm/smp.h>
> +#include <asm/timer.h>
>  
>  #include "io.h"
>  
> @@ -29,6 +30,8 @@
>  
>  extern unsigned long stacktop;
>  
> +struct timer_state __timer_state;
> +
>  char *initrd;
>  u32 initrd_size;
>  
> @@ -156,6 +159,43 @@ static void mem_init(phys_addr_t freemem_start)
>  	page_alloc_ops_enable();
>  }
>  
> +static void timer_save_state(void)
> +{
> +	const struct fdt_property *prop;
> +	const void *fdt = dt_fdt();
> +	int node, len;
> +	u32 *data;
> +
> +	node = fdt_node_offset_by_compatible(fdt, -1, "arm,armv8-timer");
> +	assert(node >= 0 || node == -FDT_ERR_NOTFOUND);
> +
> +	if (node == -FDT_ERR_NOTFOUND) {
> +		__timer_state.ptimer.irq = -1;
> +		__timer_state.vtimer.irq = -1;
> +		return;
> +	}
> +
> +	/*
> +	 * From Linux devicetree timer binding documentation
> +	 *
> +	 * interrupts <type irq flags>:
> +	 *	secure timer irq
> +	 *	non-secure timer irq		(ptimer)
> +	 *	virtual timer irq		(vtimer)
> +	 *	hypervisor timer irq
> +	 */
> +	prop = fdt_get_property(fdt, node, "interrupts", &len);
> +	assert(prop && len == (4 * 3 * sizeof(u32)));
> +
> +	data = (u32 *)prop->data;
> +	assert(fdt32_to_cpu(data[3]) == 1 /* PPI */);
> +	__timer_state.ptimer.irq = fdt32_to_cpu(data[4]);
> +	__timer_state.ptimer.irq_flags = fdt32_to_cpu(data[5]);
> +	assert(fdt32_to_cpu(data[6]) == 1 /* PPI */);
> +	__timer_state.vtimer.irq = fdt32_to_cpu(data[7]);
> +	__timer_state.vtimer.irq_flags = fdt32_to_cpu(data[8]);
> +}
> +
>  void setup(const void *fdt)
>  {
>  	void *freemem = &stacktop;
> @@ -211,6 +251,8 @@ void setup(const void *fdt)
>  	io_init();
>  
>  	/* finish setup */
> +	timer_save_state();
> +
>  	ret = dt_get_bootargs(&bootargs);
>  	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
>  	setup_args_progname(bootargs);
> diff --git a/lib/arm64/asm/timer.h b/lib/arm64/asm/timer.h
> new file mode 100644
> index 000000000000..c0f5f88287de
> --- /dev/null
> +++ b/lib/arm64/asm/timer.h
> @@ -0,0 +1 @@
> +#include "../../arm/asm/timer.h"
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
