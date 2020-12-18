Return-Path: <SRS0=w40L=FW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF87EC4361B
	for <kvmarm@archiver.kernel.org>; Fri, 18 Dec 2020 08:08:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1DD0C23A62
	for <kvmarm@archiver.kernel.org>; Fri, 18 Dec 2020 08:08:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DD0C23A62
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A4194B0D8;
	Fri, 18 Dec 2020 03:08:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WegWZkpWIlSY; Fri, 18 Dec 2020 03:08:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7226A4B114;
	Fri, 18 Dec 2020 03:08:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EF8D4B10E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2020 03:08:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UREfEt+v5ynl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Dec 2020 03:08:03 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 868544B0D8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2020 03:08:03 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1608278883;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=RPa6hLZH9TuZyafl4EET0MgXUDM3g9JcdSdA1PKueBY=;
 b=GdkyJFnXoLk37zGQb7sDdaX9HXltyZMNl+d4i/Zly6Mxe2pWfIjX3+zDcVtrbc3m7nN8KB
 Esxk6ZvUoOxn2Ovzagdm5GZ+3VDjnHHwJMzCa8y98A+y088tHVBjZ6jh/D6j9eoGDULmDu
 3+ryaFkGKJtV//7q50HixXqoidD7dMw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-R8Ic2qUUOya8ivLQyL6f7Q-1; Fri, 18 Dec 2020 03:08:01 -0500
X-MC-Unique: R8Ic2qUUOya8ivLQyL6f7Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74E091015C84;
 Fri, 18 Dec 2020 08:07:59 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.59])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3648771C94;
 Fri, 18 Dec 2020 08:07:53 +0000 (UTC)
Date: Fri, 18 Dec 2020 09:07:51 +0100
From: Andrew Jones <drjones@redhat.com>
To: Jingyi Wang <wangjingyi11@huawei.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: microbench: fix unexpected PPI
Message-ID: <20201218080751.xps77ogq2flsp4e4@kamzik.brq.redhat.com>
References: <20201218071542.15368-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201218071542.15368-1-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

On Fri, Dec 18, 2020 at 03:15:42PM +0800, Jingyi Wang wrote:
> For the origin value of CNTV_CVAL_EL0 architecturally UNKNOWN, we may
> receive an unexpected PPI before we actual trigger the timer interrupt.
> So we should set ARCH_TIMER_CTL_IMASK in timer_prep.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 362f93e..95c418c 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -227,7 +227,7 @@ static bool timer_prep(void)
>  	}
>  
>  	writel(1 << PPI(TIMER_VTIMER_IRQ), gic_isenabler);
> -	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
> +	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
>  	isb();
>  
>  	gic_prep_common();
> -- 
> 2.19.1
>

Queued, https://gitlab.com/rhdrjones/kvm-unit-tests/commits/arm/queue

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
