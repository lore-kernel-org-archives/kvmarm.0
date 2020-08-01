Return-Path: <SRS0=Xpyc=BL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C794C433E0
	for <kvmarm@archiver.kernel.org>; Sat,  1 Aug 2020 16:14:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF4E92076B
	for <kvmarm@archiver.kernel.org>; Sat,  1 Aug 2020 16:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gAuZSUTI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF4E92076B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 116354B4C3;
	Sat,  1 Aug 2020 12:14:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4xTwE4TP98Md; Sat,  1 Aug 2020 12:14:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E83544B4B7;
	Sat,  1 Aug 2020 12:14:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B2764B4B7
 for <kvmarm@lists.cs.columbia.edu>; Sat,  1 Aug 2020 12:14:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ClKDmeMB1EpX for <kvmarm@lists.cs.columbia.edu>;
 Sat,  1 Aug 2020 12:14:22 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F6A94B4B5
 for <kvmarm@lists.cs.columbia.edu>; Sat,  1 Aug 2020 12:14:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596298462;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=wf28/+wlXdYgB9veI3c3RN2H8aZsx2Wnibm1Lushe+Q=;
 b=gAuZSUTInMLZfqUWbexgpaAb17LCGsa3dbbyKjljYUkXrqbmYUcGx4iYRwNYF4CuIczOx6
 ytm12BXLPW8TSY0F1QVU68oPk/r0MPIZPUxdVyx8VrjIOKk83Io6otZu+RP09Sw35yH18w
 H1E+Sq3R1YdE8Od61mTOXbaG+TP8S2E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66--WpcgJkzNvSjrdUtlu1sVg-1; Sat, 01 Aug 2020 12:14:20 -0400
X-MC-Unique: -WpcgJkzNvSjrdUtlu1sVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9658801504;
 Sat,  1 Aug 2020 16:13:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EF0B261A1;
 Sat,  1 Aug 2020 16:13:44 +0000 (UTC)
Date: Sat, 1 Aug 2020 18:13:41 +0200
From: Andrew Jones <drjones@redhat.com>
To: Jingyi Wang <wangjingyi11@huawei.com>
Subject: Re: [kvm-unit-tests PATCH v3 07/10] arm64: microbench: Add time
 limit for each individual test
Message-ID: <20200801161341.cjaqe7tkw2y7uxjm@kamzik.brq.redhat.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <20200731074244.20432-8-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200731074244.20432-8-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

On Fri, Jul 31, 2020 at 03:42:41PM +0800, Jingyi Wang wrote:
> Besides using separate running times parameter, we add time limit
> for loop_test to make sure each test should be done in a certain
> time(5 sec here).
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arm/micro-bench.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 93bd855..09d9d53 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -22,6 +22,7 @@
>  #include <asm/gic.h>
>  #include <asm/gic-v3-its.h>
>  
> +#define NS_5_SECONDS (5 * 1000 * 1000 * 1000UL)
>  static u32 cntfrq;
>  
>  static volatile bool irq_ready, irq_received;
> @@ -267,23 +268,26 @@ static void loop_test(struct exit_test *test)
>  	uint64_t start, end, total_ticks, ntimes = 0;
>  	struct ns_time total_ns, avg_ns;
>  
> +	total_ticks = 0;
>  	if (test->prep) {
>  		if(!test->prep()) {
>  			printf("%s test skipped\n", test->name);
>  			return;
>  		}
>  	}
> -	isb();
> -	start = read_sysreg(cntpct_el0);
> -	while (ntimes < test->times) {
> +
> +	while (ntimes < test->times && total_ns.ns < NS_5_SECONDS) {

total_ns.ns is now being used uninitialized here. It needs to be
initialized to zero above with total_ns = {}.

I'll do this fixup myself.

Thanks,
drew

> +		isb();
> +		start = read_sysreg(cntpct_el0);
>  		test->exec();
> +		isb();
> +		end = read_sysreg(cntpct_el0);
> +
>  		ntimes++;
> +		total_ticks += (end - start);
> +		ticks_to_ns_time(total_ticks, &total_ns);
>  	}
> -	isb();
> -	end = read_sysreg(cntpct_el0);
>  
> -	total_ticks = end - start;
> -	ticks_to_ns_time(total_ticks, &total_ns);
>  	avg_ns.ns = total_ns.ns / ntimes;
>  	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
>  
> -- 
> 2.19.1
> 
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
