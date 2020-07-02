Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C576CC433E1
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 12:36:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7899720874
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 12:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aDixymuB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7899720874
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33B7A4B5E0;
	Thu,  2 Jul 2020 08:36:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n9xKNWOwf+rU; Thu,  2 Jul 2020 08:36:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECF334B5F8;
	Thu,  2 Jul 2020 08:36:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 400534B3FF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 08:36:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lMy979GATBJH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 08:36:40 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5120C4B5DF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 08:36:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593693400;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=F6txGPJf3/pYs89gmu9iU2ZLMdOhpZiTs7tIqLOSO7M=;
 b=aDixymuBiU9PzaeWUmwp7mUDMDhpRHz6Jlbm3CHXNMuiDdQitXNf6Jky/qZoGWCv01Ijz0
 nzHeXJ6k3XQJSrhEfEH2w3B2L92OAGv7P5wsafl/6rdUOZBCCzimx9SxxygJXHwlofvrhF
 Iq+VVeqjS5kt6KwnIcKJRS6I7J1H56k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-RhTXJ50_Pp-MhGT2WywtGg-1; Thu, 02 Jul 2020 08:36:36 -0400
X-MC-Unique: RhTXJ50_Pp-MhGT2WywtGg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9C29107B7C9;
 Thu,  2 Jul 2020 12:36:34 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 39748741AF;
 Thu,  2 Jul 2020 12:36:33 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/8] arm64: microbench: Use the funcions
 for ipi test as the general functions for gic(ipi/lpi/timer) test
To: Jingyi Wang <wangjingyi11@huawei.com>, drjones@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-3-wangjingyi11@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <c862d39b-37e7-472f-c5ce-5f47ce76af87@redhat.com>
Date: Thu, 2 Jul 2020 14:36:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200702030132.20252-3-wangjingyi11@huawei.com>
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

Hi,

On 7/2/20 5:01 AM, Jingyi Wang wrote:
> The following patches will use that.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c | 39 ++++++++++++++++++++++-----------------
>  1 file changed, 22 insertions(+), 17 deletions(-)
> 
With commit message suggested by Drew,

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 794dfac..fc4d356 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -25,24 +25,24 @@
>  
>  static u32 cntfrq;
>  
> -static volatile bool ipi_ready, ipi_received;
> +static volatile bool irq_ready, irq_received;
>  static void *vgic_dist_base;
>  static void (*write_eoir)(u32 irqstat);
>  
> -static void ipi_irq_handler(struct pt_regs *regs)
> +static void gic_irq_handler(struct pt_regs *regs)
>  {
> -	ipi_ready = false;
> -	ipi_received = true;
> +	irq_ready = false;
> +	irq_received = true;
>  	gic_write_eoir(gic_read_iar());
> -	ipi_ready = true;
> +	irq_ready = true;
>  }
>  
> -static void ipi_secondary_entry(void *data)
> +static void gic_secondary_entry(void *data)
>  {
> -	install_irq_handler(EL1H_IRQ, ipi_irq_handler);
> +	install_irq_handler(EL1H_IRQ, gic_irq_handler);
>  	gic_enable_defaults();
>  	local_irq_enable();
> -	ipi_ready = true;
> +	irq_ready = true;
>  	while (true)
>  		cpu_relax();
>  }
> @@ -72,9 +72,9 @@ static bool test_init(void)
>  		break;
>  	}
>  
> -	ipi_ready = false;
> +	irq_ready = false;
>  	gic_enable_defaults();
> -	on_cpu_async(1, ipi_secondary_entry, NULL);
> +	on_cpu_async(1, gic_secondary_entry, NULL);
>  
>  	cntfrq = get_cntfrq();
>  	printf("Timer Frequency %d Hz (Output in microseconds)\n", cntfrq);
> @@ -82,13 +82,18 @@ static bool test_init(void)
>  	return true;
>  }
>  
> -static void ipi_prep(void)
> +static void gic_prep_common(void)
>  {
>  	unsigned tries = 1 << 28;
>  
> -	while (!ipi_ready && tries--)
> +	while (!irq_ready && tries--)
>  		cpu_relax();
> -	assert(ipi_ready);
> +	assert(irq_ready);
> +}
> +
> +static void ipi_prep(void)
> +{
> +	gic_prep_common();
>  }
>  
>  static void ipi_exec(void)
> @@ -96,17 +101,17 @@ static void ipi_exec(void)
>  	unsigned tries = 1 << 28;
>  	static int received = 0;
>  
> -	ipi_received = false;
> +	irq_received = false;
>  
>  	gic_ipi_send_single(1, 1);
>  
> -	while (!ipi_received && tries--)
> +	while (!irq_received && tries--)
>  		cpu_relax();
>  
> -	if (ipi_received)
> +	if (irq_received)
>  		++received;
>  
> -	assert_msg(ipi_received, "failed to receive IPI in time, but received %d successfully\n", received);
> +	assert_msg(irq_received, "failed to receive IPI in time, but received %d successfully\n", received);
>  }
>  
>  static void hvc_exec(void)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
