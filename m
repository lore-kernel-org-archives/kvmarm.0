Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF96C433E1
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 05:29:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E18B207E8
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 05:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UtOzSPZ5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E18B207E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF75E4B566;
	Thu,  2 Jul 2020 01:29:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id USI2DYpMFYkF; Thu,  2 Jul 2020 01:29:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D96D74B585;
	Thu,  2 Jul 2020 01:29:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24F3D4B56B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 01:29:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xH7gOF8JmRLO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 01:29:53 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28EBB4B566
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 01:29:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593667793;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=iGQdjHVib8qISNc7IzTrXVvygz3qc1VGj0SJ1dQqdgY=;
 b=UtOzSPZ5q6dKFLIQLnLVJ1vmfsNkjnBiK/v4UsKtdGDrbYyacEcPFlht4Fr1/4ZDarcrAi
 A/Gq/8b6HWcdmJvJGJJlxtLdv8Qm88L9TS/wmEn4RxsbFfLzNy+cuenSLEMzwHa5ocVgWV
 rSnhW/qIl3INw88ai+gxg6+ArTeiNFQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-pHsuURx5OMG-ZC5xX3kfIQ-1; Thu, 02 Jul 2020 01:29:51 -0400
X-MC-Unique: pHsuURx5OMG-ZC5xX3kfIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22F20802ED4;
 Thu,  2 Jul 2020 05:29:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.87])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 309AC60CD3;
 Thu,  2 Jul 2020 05:29:44 +0000 (UTC)
Date: Thu, 2 Jul 2020 07:29:42 +0200
From: Andrew Jones <drjones@redhat.com>
To: Jingyi Wang <wangjingyi11@huawei.com>
Subject: Re: [kvm-unit-tests PATCH v2 6/8] arm64: microbench: Allow each test
 to specify its running times
Message-ID: <20200702052942.laodlgq2yrlxwsh4@kamzik.brq.redhat.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-7-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200702030132.20252-7-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

On Thu, Jul 02, 2020 at 11:01:30AM +0800, Jingyi Wang wrote:
> For some test in micro-bench can be time consuming, we add a
> micro-bench test parameter to allow each individual test to specify
> its running times.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index aeb60a7..506d2f9 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -223,17 +223,18 @@ struct exit_test {
>  	const char *name;
>  	bool (*prep)(void);
>  	void (*exec)(void);
> +	u32 times;
>  	bool run;
>  };
>  
>  static struct exit_test tests[] = {
> -	{"hvc",			NULL,		hvc_exec,		true},
> -	{"mmio_read_user",	NULL,		mmio_read_user_exec,	true},
> -	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	true},
> -	{"eoi",			NULL,		eoi_exec,		true},
> -	{"ipi",			ipi_prep,	ipi_exec,		true},
> -	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		true},
> -	{"lpi",			lpi_prep,	lpi_exec,		true},
> +	{"hvc",			NULL,		hvc_exec,		NTIMES,		true},
> +	{"mmio_read_user",	NULL,		mmio_read_user_exec,	NTIMES,		true},
> +	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	NTIMES,		true},
> +	{"eoi",			NULL,		eoi_exec,		NTIMES,		true},
> +	{"ipi",			ipi_prep,	ipi_exec,		NTIMES,		true},
> +	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		NTIMES,		true},
> +	{"lpi",			lpi_prep,	lpi_exec,		NTIMES,		true},

Now that we no longer use 'NTIMES' in functions we don't really need the
define at all. We can just put 65536 directly into the table here for
each test that needs 65536 times.

Thanks,
drew

>  };
>  
>  struct ns_time {
> @@ -254,7 +255,7 @@ static void ticks_to_ns_time(uint64_t ticks, struct ns_time *ns_time)
>  
>  static void loop_test(struct exit_test *test)
>  {
> -	uint64_t start, end, total_ticks, ntimes = NTIMES;
> +	uint64_t start, end, total_ticks, ntimes = 0;
>  	struct ns_time total_ns, avg_ns;
>  
>  	if (test->prep) {
> @@ -265,15 +266,17 @@ static void loop_test(struct exit_test *test)
>  	}
>  	isb();
>  	start = read_sysreg(cntpct_el0);
> -	while (ntimes--)
> +	while (ntimes < test->times) {
>  		test->exec();
> +		ntimes++;
> +	}
>  	isb();
>  	end = read_sysreg(cntpct_el0);
>  
>  	total_ticks = end - start;
>  	ticks_to_ns_time(total_ticks, &total_ns);
> -	avg_ns.ns = total_ns.ns / NTIMES;
> -	avg_ns.ns_frac = total_ns.ns_frac / NTIMES;
> +	avg_ns.ns = total_ns.ns / ntimes;
> +	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
>  
>  	printf("%-30s%15" PRId64 ".%-15" PRId64 "%15" PRId64 ".%-15" PRId64 "\n",
>  		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
> -- 
> 2.19.1
> 
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
