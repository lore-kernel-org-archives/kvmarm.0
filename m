Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76312C433DF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 12:58:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 010F920899
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 12:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fYyHzoPC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 010F920899
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8550D4B5FB;
	Thu,  2 Jul 2020 08:58:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dIktBKQ6JiKt; Thu,  2 Jul 2020 08:58:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D8204B4DC;
	Thu,  2 Jul 2020 08:58:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBA164B4DC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 08:58:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ggfa1rRVkBOe for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 08:58:02 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C490D4B4D6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 08:58:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593694682;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=t9w4LZWNu2mt9GGRi97urEa0TOggkhGxJO5hmYE7QxM=;
 b=fYyHzoPCYssD1oF8qzpFlWcrv6o2lzKqaDZGtzjbSnyzIJot9mlbMvZ9aKyGO7qqFK2LLU
 wzBLQ+phsDOYoL7ct269oiULClH20NOvdCI/Lv1F4Z6OQC43b+K4KRYyFhVEL4Ly30LSMZ
 +La4ToFyMCGXSWAbFl/GN32EWZByQRg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-m7TNf4OkOJi80zD_ODUKnw-1; Thu, 02 Jul 2020 08:58:00 -0400
X-MC-Unique: m7TNf4OkOJi80zD_ODUKnw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 403FD107ACCD;
 Thu,  2 Jul 2020 12:57:59 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A4A1D10013D2;
 Thu,  2 Jul 2020 12:57:57 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
To: Jingyi Wang <wangjingyi11@huawei.com>, drjones@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <087ef371-5e7b-e0b2-900f-67b2eacb4e0f@redhat.com>
Date: Thu, 2 Jul 2020 14:57:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200702030132.20252-4-wangjingyi11@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
> If gicv4.1(sgi hardware injection) supported, we test ipi injection
> via hw/sw way separately.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c    | 45 +++++++++++++++++++++++++++++++++++++++-----
>  lib/arm/asm/gic-v3.h |  3 +++
>  lib/arm/asm/gic.h    |  1 +
>  3 files changed, 44 insertions(+), 5 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index fc4d356..80d8db3 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -91,9 +91,40 @@ static void gic_prep_common(void)
>  	assert(irq_ready);
>  }
>  
> -static void ipi_prep(void)
> +static bool ipi_prep(void)
Any reason why the bool returned value is preferred over the standard int?
>  {
> +	u32 val;
> +
> +	val = readl(vgic_dist_base + GICD_CTLR);
> +	if (readl(vgic_dist_base + GICD_TYPER2) & GICD_TYPER2_nASSGIcap) {
> +		val &= ~GICD_CTLR_ENABLE_G1A;
> +		val &= ~GICD_CTLR_nASSGIreq;
> +		writel(val, vgic_dist_base + GICD_CTLR);
> +		val |= GICD_CTLR_ENABLE_G1A;
> +		writel(val, vgic_dist_base + GICD_CTLR);
Why do we need this G1A dance?
> +	}
> +
>  	gic_prep_common();
> +	return true;
> +}
> +
> +static bool ipi_hw_prep(void)
> +{
> +	u32 val;
> +
> +	val = readl(vgic_dist_base + GICD_CTLR);
> +	if (readl(vgic_dist_base + GICD_TYPER2) & GICD_TYPER2_nASSGIcap) {
> +		val &= ~GICD_CTLR_ENABLE_G1A;
> +		val |= GICD_CTLR_nASSGIreq;
> +		writel(val, vgic_dist_base + GICD_CTLR);
> +		val |= GICD_CTLR_ENABLE_G1A;
> +		writel(val, vgic_dist_base + GICD_CTLR);
> +	} else {
> +		return false;
> +	}
> +
> +	gic_prep_common();
> +	return true;
>  }
>  
>  static void ipi_exec(void)
> @@ -147,7 +178,7 @@ static void eoi_exec(void)
>  
>  struct exit_test {
>  	const char *name;
> -	void (*prep)(void);
> +	bool (*prep)(void);
>  	void (*exec)(void);
>  	bool run;
>  };
> @@ -158,6 +189,7 @@ static struct exit_test tests[] = {
>  	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	true},
>  	{"eoi",			NULL,		eoi_exec,		true},
>  	{"ipi",			ipi_prep,	ipi_exec,		true},
> +	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		true},
>  };
>  
>  struct ns_time {
> @@ -181,9 +213,12 @@ static void loop_test(struct exit_test *test)
>  	uint64_t start, end, total_ticks, ntimes = NTIMES;
>  	struct ns_time total_ns, avg_ns;
>  
> -	if (test->prep)
> -		test->prep();
> -
> +	if (test->prep) {
> +		if(!test->prep()) {
> +			printf("%s test skipped\n", test->name);
> +			return;
> +		}
> +	}
>  	isb();
>  	start = read_sysreg(cntpct_el0);
>  	while (ntimes--)
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index cb72922..b4ce130 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -20,10 +20,13 @@
>   */
>  #define GICD_CTLR			0x0000
>  #define GICD_CTLR_RWP			(1U << 31)
> +#define GICD_CTLR_nASSGIreq		(1U << 8)
>  #define GICD_CTLR_ARE_NS		(1U << 4)
>  #define GICD_CTLR_ENABLE_G1A		(1U << 1)
>  #define GICD_CTLR_ENABLE_G1		(1U << 0)
>  
> +#define GICD_TYPER2_nASSGIcap		(1U << 8)
> +
>  /* Re-Distributor registers, offsets from RD_base */
>  #define GICR_TYPER			0x0008
>  
> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> index 38e79b2..1898400 100644
> --- a/lib/arm/asm/gic.h
> +++ b/lib/arm/asm/gic.h
> @@ -13,6 +13,7 @@
>  #define GICD_CTLR			0x0000
>  #define GICD_TYPER			0x0004
>  #define GICD_IIDR			0x0008
> +#define GICD_TYPER2			0x000C
>  #define GICD_IGROUPR			0x0080
>  #define GICD_ISENABLER			0x0100
>  #define GICD_ICENABLER			0x0180
> 

Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
