Return-Path: <SRS0=ZPOc=UJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F59C282DD
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 11:39:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A4732085A
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 11:39:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A4732085A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7DFE4A513;
	Mon, 10 Jun 2019 07:39:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D39YNYU+kL4d; Mon, 10 Jun 2019 07:39:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C46E4A50B;
	Mon, 10 Jun 2019 07:39:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBD054A505
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 07:39:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TWIbren6kgtH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jun 2019 07:39:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83E454A4E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 07:39:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0842D337;
 Mon, 10 Jun 2019 04:39:12 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB7753F557;
 Mon, 10 Jun 2019 04:40:52 -0700 (PDT)
Date: Mon, 10 Jun 2019 12:39:08 +0100
From: Will Deacon <will.deacon@arm.com>
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v8 4/6] arm64: perf: extract chain helper into header
Message-ID: <20190610113908.GE15979@fuggles.cambridge.arm.com>
References: <20190522153019.18645-1-andrew.murray@arm.com>
 <20190522153019.18645-5-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190522153019.18645-5-andrew.murray@arm.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Wed, May 22, 2019 at 04:30:17PM +0100, Andrew Murray wrote:
> The ARMv8 Performance Monitors Extension includes an architectural
> event type named CHAIN which allows for chaining counters together.
> 
> Let's extract the test for this event into a header file such that
> other users, such as KVM (for PMU emulation) can make use of.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/perf_event.h | 5 +++++
>  arch/arm64/kernel/perf_event.c      | 2 +-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
> index c593761ba61c..cd13f3fd1055 100644
> --- a/arch/arm64/include/asm/perf_event.h
> +++ b/arch/arm64/include/asm/perf_event.h
> @@ -219,6 +219,11 @@
>  #define ARMV8_PMU_USERENR_CR	(1 << 2) /* Cycle counter can be read at EL0 */
>  #define ARMV8_PMU_USERENR_ER	(1 << 3) /* Event counter can be read at EL0 */
>  
> +static inline bool armv8pmu_evtype_is_chain(u64 evtype)
> +{
> +	return (evtype == ARMV8_PMUV3_PERFCTR_CHAIN);
> +}
> +
>  #ifdef CONFIG_PERF_EVENTS
>  struct pt_regs;
>  extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index 314b1adedf06..265bd835a724 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -879,7 +879,7 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
>  static int armv8pmu_filter_match(struct perf_event *event)
>  {
>  	unsigned long evtype = event->hw.config_base & ARMV8_PMU_EVTYPE_EVENT;
> -	return evtype != ARMV8_PMUV3_PERFCTR_CHAIN;
> +	return !armv8pmu_evtype_is_chain(evtype);

Acked-by: Will Deacon <will.deacon@arm.com>

Although if the definition of armv8pmu_evtype_is_chain() isn't going to
get any more complicated than a single evtype comparison, I'm not sure it's
worth this abstraction, to be honest.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
