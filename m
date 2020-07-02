Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F275C433DF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:23:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C2F32088E
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:23:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Py7ZifIl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C2F32088E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 848FA4B605;
	Thu,  2 Jul 2020 09:23:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d9v41B9YJgH7; Thu,  2 Jul 2020 09:23:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83A274B5FE;
	Thu,  2 Jul 2020 09:23:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 861084B5FE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:23:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mSe8Ohql2g8K for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 09:23:24 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA3484B538
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:23:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593696204;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=lt+MVol6YDoR2oUdOzFWj33k5KFHukA6bYuMZo4OVHM=;
 b=Py7ZifIlRVcamu0mblQjNuJdJTt/1RahgxAhAwpWTIrI8xGsgZQN9rcJN8VDKVZ8gcPJli
 Fow0vRM5f3hwPxy+3B55hyQEc9DxpvtCa9SY+UWERrwklMUpJ48kPrS917AVuI9TV3bicx
 F9qMcuPCNt9ki7yuG4xzs7mmZ9N1Ahw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-60C4cSREMq2bFAXkYNTVzA-1; Thu, 02 Jul 2020 09:23:22 -0400
X-MC-Unique: 60C4cSREMq2bFAXkYNTVzA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD7C218B6474;
 Thu,  2 Jul 2020 13:23:20 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D9CAD60BE1;
 Thu,  2 Jul 2020 13:23:18 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 7/8] arm64: microbench: Add time limit
 for each individual test
To: Jingyi Wang <wangjingyi11@huawei.com>, drjones@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-8-wangjingyi11@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <49bf0b58-38b9-1cd6-8396-b8561d6f90cb@redhat.com>
Date: Thu, 2 Jul 2020 15:23:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200702030132.20252-8-wangjingyi11@huawei.com>
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
> Besides using separate running times parameter, we add time limit
> for loop_test to make sure each test should be done in a certain
> time(5 sec here).
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 506d2f9..4c962b7 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -23,6 +23,7 @@
>  #include <asm/gic-v3-its.h>
>  
>  #define NTIMES (1U << 16)
> +#define MAX_NS (5 * 1000 * 1000 * 1000UL)
>  
>  static u32 cntfrq;
>  
> @@ -258,22 +259,26 @@ static void loop_test(struct exit_test *test)
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
> +	while (ntimes < test->times && total_ns.ns < MAX_NS) {
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
you don't need the
ticks_to_ns_time(total_ticks, &total_ns);

after the loop
> -	isb();
> -	end = read_sysreg(cntpct_el0);
>  
> -	total_ticks = end - start;
>  	ticks_to_ns_time(total_ticks, &total_ns);
>  	avg_ns.ns = total_ns.ns / ntimes;
>  	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
> 

Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
