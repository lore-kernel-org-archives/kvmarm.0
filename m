Return-Path: <SRS0=Xpyc=BL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E4BC433E0
	for <kvmarm@archiver.kernel.org>; Sat,  1 Aug 2020 17:40:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C82102065E
	for <kvmarm@archiver.kernel.org>; Sat,  1 Aug 2020 17:40:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WY3sqMf8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C82102065E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 381264B1A8;
	Sat,  1 Aug 2020 13:40:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wBXhOBz1D19L; Sat,  1 Aug 2020 13:40:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FC1D4B1E3;
	Sat,  1 Aug 2020 13:40:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32FF64B19D
 for <kvmarm@lists.cs.columbia.edu>; Sat,  1 Aug 2020 13:40:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gjSnGHsBKMX5 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  1 Aug 2020 13:40:37 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 411114B18B
 for <kvmarm@lists.cs.columbia.edu>; Sat,  1 Aug 2020 13:40:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596303637;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=vpj3C7kx5Z6iBWpdy9lLsyzXogIM+N52quvOGcyPpVM=;
 b=WY3sqMf8/vVg08sj7D2UV1PDaHRM/LwaRdpkexa5on7+G+PkRmPlDlYjWYx7gQkB7NTvBM
 Hkg7lkRIeTt32QCkr2LQ+f9XSLW8TzavFa4FIgY7CG9Qac5wY1ORa2sykUenjrrYSeLtaU
 HtkCOcmX4J9ArVFb/gPyLcaL3ppstCE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-4m6wk7Z2OjiM0tW2xDaeeA-1; Sat, 01 Aug 2020 13:40:33 -0400
X-MC-Unique: 4m6wk7Z2OjiM0tW2xDaeeA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E16F800688;
 Sat,  1 Aug 2020 17:40:31 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FB7F5D98F;
 Sat,  1 Aug 2020 17:40:25 +0000 (UTC)
Date: Sat, 1 Aug 2020 19:40:23 +0200
From: Andrew Jones <drjones@redhat.com>
To: Jingyi Wang <wangjingyi11@huawei.com>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
Message-ID: <20200801174023.jgjt3slser3fvprv@kamzik.brq.redhat.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200731074244.20432-1-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Pushed

(to the new repo at https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git)

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
