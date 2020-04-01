Return-Path: <SRS0=qvC8=5R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111DFC2D0F4
	for <kvmarm@archiver.kernel.org>; Wed,  1 Apr 2020 12:25:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A2E120714
	for <kvmarm@archiver.kernel.org>; Wed,  1 Apr 2020 12:25:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hCWqmPZS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A2E120714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E88944B0FF;
	Wed,  1 Apr 2020 08:24:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O6htZpG4Z4-D; Wed,  1 Apr 2020 08:24:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 013D24B0F5;
	Wed,  1 Apr 2020 08:24:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40C534B0F4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Apr 2020 08:24:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HdTHdDh1aEd8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Apr 2020 08:24:56 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CBD34B0F6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Apr 2020 08:24:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585743896;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=MC/MjZfh7TLCzD5LcVQ13kaOfc4HlhwLTdXB+ga+Cao=;
 b=hCWqmPZSTWAnURZfrdoNJ92niyeK9sQ2lDePfY32gGSG9VGUfTyCKECfLTvKSq5lIwO5Su
 KIVKsEB8l7tJEp7j0vdroPLyWrnubQx1hDG4wfI+RBQcgvzWRC/FloV21t4ceESN4+S1Ty
 G5byEmVIKgoU4t+nV/fPGuYDGbdvsE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-NbG52YPFNSWV1xleqSh0Qw-1; Wed, 01 Apr 2020 08:24:54 -0400
X-MC-Unique: NbG52YPFNSWV1xleqSh0Qw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19DAE8017F3;
 Wed,  1 Apr 2020 12:24:53 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.155])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A198F5D9CD;
 Wed,  1 Apr 2020 12:24:50 +0000 (UTC)
Date: Wed, 1 Apr 2020 14:24:45 +0200
From: Andrew Jones <drjones@redhat.com>
To: Jingyi Wang <wangjingyi11@huawei.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] arm/arm64: Add IPI/vtimer latency
Message-ID: <20200401122445.exyobwo3a3agnuhk@kamzik.brq.redhat.com>
References: <20200401100812.27616-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200401100812.27616-1-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

On Wed, Apr 01, 2020 at 06:08:10PM +0800, Jingyi Wang wrote:
> With the development of arm gic architecture, we think it will be useful
> to add some simple performance test in kut to measure the cost of
> interrupts. X86 arch has implemented similar test.
> 
> Jingyi Wang (2):
>   arm/arm64: gic: Add IPI latency test
>   arm/arm64: Add vtimer latency test
> 
>  arm/gic.c   | 27 +++++++++++++++++++++++++++
>  arm/timer.c | 11 +++++++++++
>  2 files changed, 38 insertions(+)
> 
> -- 
> 2.19.1
> 
>

Hi Jingyi,

We already have an IPI latency test in arm/micro-bench.c I'd prefer that
one be used, if possible, rather than conflating the gic functional tests
with latency tests. Can you take a look at it and see if it satisfies
your needs, extending it if necessary?

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
