Return-Path: <SRS0=2Aw4=XW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A64C4360C
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 12:26:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B36E21850
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 12:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B36E21850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0EB44A661;
	Fri, 27 Sep 2019 08:26:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ib00D6Y6eLc5; Fri, 27 Sep 2019 08:26:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA8FA4A6F9;
	Fri, 27 Sep 2019 08:26:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17BB14A6F9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 08:26:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BUloBM93rv1D for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 08:26:40 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E0384A661
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 08:26:40 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 86F4A301A3AE;
 Fri, 27 Sep 2019 12:26:39 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 157176092F;
 Fri, 27 Sep 2019 12:26:37 +0000 (UTC)
Date: Fri, 27 Sep 2019 14:26:35 +0200
From: Andrew Jones <drjones@redhat.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH 4/6] arm: selftest: Split variable output
 data from test name
Message-ID: <20190927122635.mqrmbltk2qevfl24@kamzik.brq.redhat.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
 <20190927104227.253466-5-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190927104227.253466-5-andre.przywara@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.41]); Fri, 27 Sep 2019 12:26:39 +0000 (UTC)
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Sep 27, 2019 at 11:42:25AM +0100, Andre Przywara wrote:
> For some tests we mix variable diagnostic output with the test name,
> which leads to variable test line, confusing some higher level
> frameworks.
> 
> Split the output to always use the same test name for a certain test,
> and put diagnostic output on a separate line using the INFO: tag.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/selftest.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 28a17f7..a0c1ab8 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -43,13 +43,16 @@ static void check_setup(int argc, char **argv)
>  			phys_addr_t memsize = PHYS_END - PHYS_OFFSET;
>  			phys_addr_t expected = ((phys_addr_t)val)*1024*1024;
>  
> -			report("size = %" PRIu64 " MB", memsize == expected,
> -							memsize/1024/1024);
> +			report("memory size matches expectation",
> +			       memsize == expected);
> +			report_info("found %" PRIu64 " MB", memsize/1024/1024);
>  			++nr_tests;
>  
>  		} else if (strcmp(argv[i], "smp") == 0) {
>  
> -			report("nr_cpus = %d", nr_cpus == (int)val, nr_cpus);
> +			report("number of CPUs matches expectation",
> +			       nr_cpus == (int)val);
> +			report_info("found %d CPUs", nr_cpus);
>  			++nr_tests;
>  		}
>  
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
