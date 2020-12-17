Return-Path: <SRS0=/4+A=FV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05B5C4361B
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 12:17:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60293238E8
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 12:17:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60293238E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAA424B1D1;
	Thu, 17 Dec 2020 07:17:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mlm9OQGwmWCz; Thu, 17 Dec 2020 07:17:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E40A4B197;
	Thu, 17 Dec 2020 07:17:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 084DC4B197
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Dec 2020 07:17:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HEyaXYG+MVxu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Dec 2020 07:17:22 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15A5E4B194
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Dec 2020 07:17:22 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1608207441;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=mwquigWlR6PgHU55KZ6NPPZP+yyXZW6wmWHqQDj557I=;
 b=K+IaJ+oaAltyqOey1y+47t7XCaGHcX+56h17TAT+fKTmfHRrWR2FM61Usmv8MvFQHddzdb
 +bUJPTbX2xoYXS7mpM5U0f76WacAMnEQAHpsd3xpeFVWm75w4+s8IB2HnNf4dw3VKeKIN3
 e+BVEVjpqEpRXhXoZF9WuzqzLgYFcqE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-qzzrljpaN-C4QweElTRBgg-1; Thu, 17 Dec 2020 07:17:19 -0500
X-MC-Unique: qzzrljpaN-C4QweElTRBgg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AA0E59;
 Thu, 17 Dec 2020 12:17:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.104])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5290A60CE7;
 Thu, 17 Dec 2020 12:17:16 +0000 (UTC)
Date: Thu, 17 Dec 2020 13:17:14 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 1/1] arm: pmu: Don't read PMCR if PMU is
 not present
Message-ID: <20201217121714.kq7z3i6mj62hcu2z@kamzik.brq.redhat.com>
References: <20201217120057.88562-1-alexandru.elisei@arm.com>
 <20201217120057.88562-2-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201217120057.88562-2-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Thu, Dec 17, 2020 at 12:00:57PM +0000, Alexandru Elisei wrote:
> For arm and arm64, the PMU is an optional part of the architecture.
> According to ARM DDI 0487F.b, page D13-3683, accessing PMCR_EL0 when the
> PMU is not present generates an undefined exception (one would assume that
> this is also true for arm).
> 
> The pmu_probe() function reads the register before checking that a PMU is
> present, so defer accessing PMCR_EL0 until after we know that it is safe.
> 
> This hasn't been a problem so far because there's no hardware in the wild
> without a PMU and KVM, contrary to the architecture, has treated the PMU
> registers as RAZ/WI if the VCPU doesn't have the PMU feature. However,
> that's about to change as KVM will start treating the registers as
> undefined when the guest doesn't have a PMU.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/pmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index cc959e6a5c76..15c542a230ea 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -988,7 +988,7 @@ static void pmccntr64_test(void)
>  /* Return FALSE if no PMU found, otherwise return TRUE */
>  static bool pmu_probe(void)
>  {
> -	uint32_t pmcr = get_pmcr();
> +	uint32_t pmcr;
>  	uint8_t implementer;
>  
>  	pmu.version = get_pmu_version();
> @@ -997,6 +997,7 @@ static bool pmu_probe(void)
>  
>  	report_info("PMU version: 0x%x", pmu.version);
>  
> +	pmcr = get_pmcr();
>  	implementer = (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK;
>  	report_info("PMU implementer/ID code: %#"PRIx32"(\"%c\")/%#"PRIx32,
>  		    (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
> -- 
> 2.29.2
>

Queued, https://gitlab.com/rhdrjones/kvm-unit-tests/commits/arm/queue

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
