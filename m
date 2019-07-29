Return-Path: <SRS0=m0cG=V2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCEDC433FF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jul 2019 11:23:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0D78E2067D
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jul 2019 11:23:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D78E2067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AC0D4A4F5;
	Mon, 29 Jul 2019 07:23:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fnSKQxaytIyH; Mon, 29 Jul 2019 07:23:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F3CF4A52E;
	Mon, 29 Jul 2019 07:23:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C10534A4F5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jul 2019 07:23:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wbS56PVf7jIO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jul 2019 07:23:13 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3A6C4A4DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jul 2019 07:23:13 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 11EAD4E8AC;
 Mon, 29 Jul 2019 11:23:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D41FA60C5F;
 Mon, 29 Jul 2019 11:23:11 +0000 (UTC)
Date: Mon, 29 Jul 2019 13:23:09 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm: timer: Fix potential deadlock when
 waiting for interrupt
Message-ID: <20190729112309.wooytkz7g6qtvvc2@kamzik.brq.redhat.com>
References: <1564392532-7692-1-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1564392532-7692-1-git-send-email-alexandru.elisei@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.38]); Mon, 29 Jul 2019 11:23:13 +0000 (UTC)
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Mon, Jul 29, 2019 at 10:28:52AM +0100, Alexandru Elisei wrote:
> Commit 204e85aa9352 ("arm64: timer: a few test improvements") added a call
> to report_info after enabling the timer and before the wfi instruction. The
> uart that printf uses is emulated by userspace and is slow, which makes it
> more likely that the timer interrupt will fire before executing the wfi
> instruction, which leads to a deadlock.
> 
> An interrupt can wake up a CPU out of wfi, regardless of the
> PSTATE.{A, I, F} bits. Fix the deadlock by masking interrupts on the CPU
> before enabling the timer and unmasking them after the wfi returns so the
> CPU can execute the timer interrupt handler.
> 
> Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/timer.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index 6f2ad1d76ab2..f2f60192ba62 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -242,9 +242,11 @@ static void test_timer(struct timer_info *info)
>  	/* Test TVAL and IRQ trigger */
>  	info->irq_received = false;
>  	info->write_tval(read_sysreg(cntfrq_el0) / 100);	/* 10 ms */
> +	local_irq_disable();
>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
>  	report_info("waiting for interrupt...");
>  	wfi();
> +	local_irq_enable();
>  	left = info->read_tval();
>  	report("interrupt received after TVAL/WFI", info->irq_received);
>  	report("timer has expired (%d)", left < 0, left);
> -- 
> 2.7.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks Alexandru. It now makes more sense to me that wfi wakes up on
an interrupt, even when interrupts are masked, as it's clearly to
avoid these types of races. I see we have the same type of race in
arm/gic.c. I'll try to get around to fixing that at some point, unless
somebody beats me to it :)

drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
