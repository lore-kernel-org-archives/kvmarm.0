Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6ACBC433DF
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 12:01:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41C5922B40
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 12:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L8vKXBi5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41C5922B40
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5CCB4B39E;
	Fri, 31 Jul 2020 08:01:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wNFKCccVMAJh; Fri, 31 Jul 2020 08:01:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9395D4B39F;
	Fri, 31 Jul 2020 08:01:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 444744B39C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 08:01:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J1rZyYzN-Lpj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 08:01:31 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 562EF4B398
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 08:01:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596196891;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1lZyrqI3xLbFTyVC9E3z5frdUks/QZNq3MxuxGz/sbI=;
 b=L8vKXBi5C/hwbTaL2Ma76FqkhB4+o/nQKzxUArw5W4waD5Y4S+FaH+HmjfDjYaoN4EjdWU
 t4x5li+4KwxshppcFjhJ0A4r6QkFMurZHRo1LPWJ0Kin0tnCqajZAGR4YnGUajT24nHYiI
 q5mI3HCcVTdPM7zb4TfxVb0Iyg0J04E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-bPznMw3cPcSTHCPxHfRF7g-1; Fri, 31 Jul 2020 08:01:24 -0400
X-MC-Unique: bPznMw3cPcSTHCPxHfRF7g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EEA0102C84B;
 Fri, 31 Jul 2020 12:01:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C57619C58;
 Fri, 31 Jul 2020 12:01:20 +0000 (UTC)
Date: Fri, 31 Jul 2020 14:01:17 +0200
From: Andrew Jones <drjones@redhat.com>
To: Jingyi Wang <wangjingyi11@huawei.com>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
Message-ID: <20200731120117.5kk22hx2wpbt6kpz@kamzik.brq.redhat.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200731074244.20432-1-wangjingyi11@huawei.com>
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

On Fri, Jul 31, 2020 at 03:42:34PM +0800, Jingyi Wang wrote:
> With the development of arm gic architecture, we think it will be useful
> to add some performance test in kut to measure the cost of interrupts.
> In this series, we add GICv4.1 support for ipi latency test and
> implement LPI/vtimer latency test.
> 
> This series of patches has been tested on GICv4.1 supported hardware.
> 
> Note:
> Based on patch "arm/arm64: timer: Extract irqs at setup time",
> https://www.spinics.net/lists/kvm-arm/msg41425.html
> 
> * From v2:
>   - Code and commit message cleanup
>   - Clear nr_ipi_received before ipi_exec() thanks for Tao Zeng's review
>   - rebase the patch "Add vtimer latency test" on Andrew's patch

It'd be good if you'd reposted my patch along with this series, since we
didn't merge mine yet either. Don't worry about now, though, I'll pick it
up the same time I pick up this series, which I plan to do later today
or tomorrow.

Getting this series applied will allow me to try out our new and shiny
gitlab repo :-)

Thanks,
drew

>   - Add test->post() to get actual PPI latency
> 
> * From v1:
>   - Fix spelling mistake
>   - Use the existing interface to inject hw sgi to simply the logic
>   - Add two separate patches to limit the running times and time cost
>     of each individual micro-bench test
> 
> Jingyi Wang (10):
>   arm64: microbench: get correct ipi received num
>   arm64: microbench: Generalize ipi test names
>   arm64: microbench: gic: Add ipi latency test for gicv4.1 support kvm
>   arm64: its: Handle its command queue wrapping
>   arm64: microbench: its: Add LPI latency test
>   arm64: microbench: Allow each test to specify its running times
>   arm64: microbench: Add time limit for each individual test
>   arm64: microbench: Add vtimer latency test
>   arm64: microbench: Add test->post() to further process test results
>   arm64: microbench: Add timer_post() to get actual PPI latency
> 
>  arm/micro-bench.c          | 256 ++++++++++++++++++++++++++++++-------
>  lib/arm/asm/gic-v3.h       |   3 +
>  lib/arm/asm/gic.h          |   1 +
>  lib/arm64/gic-v3-its-cmd.c |   3 +-
>  4 files changed, 219 insertions(+), 44 deletions(-)
> 
> -- 
> 2.19.1
> 
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
