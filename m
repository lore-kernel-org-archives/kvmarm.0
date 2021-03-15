Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F08C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 17:57:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8BE7B64F17
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 17:57:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BE7B64F17
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 064384B487;
	Mon, 15 Mar 2021 13:57:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dEck0b9RW3lZ; Mon, 15 Mar 2021 13:57:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE9A84B486;
	Mon, 15 Mar 2021 13:57:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F05C4B3EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 13:57:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B3ZODu+mK0Qr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 13:57:26 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D93D4B3EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 13:57:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615831046;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=h+y0usr72Ee/zjTmbgFGxyDSJMLMasj+Kgfz5NATV/w=;
 b=ZwVfuCJYF4Jn4N8xU6jYIbU88LIpZyXGfGphunCLbsUZjVvPvXG9ONtxDm/8gdhfs4tYts
 p1MgEY1qoDZ6wNYZvTKNsU8k5mA9dJ0yqbYzqziPMohw5L/8/OKhmu5BCd35TtV47MrfJv
 /JO1yRuFmNjiQlJ/2XGapEZNI6iioog=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-2PQ3uPSWOJ2pTIZ1PdP8Qw-1; Mon, 15 Mar 2021 13:57:24 -0400
X-MC-Unique: 2PQ3uPSWOJ2pTIZ1PdP8Qw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37066881282;
 Mon, 15 Mar 2021 17:57:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.151])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 006295D9C0;
 Mon, 15 Mar 2021 17:57:14 +0000 (UTC)
Date: Mon, 15 Mar 2021 18:57:11 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH v4 00/11] GIC fixes and improvements
Message-ID: <20210315175711.qs3ksosr7smtjgs6@kamzik.brq.redhat.com>
References: <20210219121337.76533-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210219121337.76533-1-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Fri, Feb 19, 2021 at 12:13:26PM +0000, Alexandru Elisei wrote:
> What started this series is Andre's SPI and group interrupts tests [1],
> which prompted me to attempt to rewrite check_acked() so it's more flexible
> and not so complicated to review. When I was doing that I noticed that the
> message passing pattern for accesses to the acked, bad_irq and bad_sender
> arrays didn't look quite right, and that turned into the first 7 patches of
> the series. Even though the diffs are relatively small, they are not
> trivial and the reviewer can skip them for the more palatable patches that
> follow. I would still appreciate someone having a look at the memory
> ordering fixes.
> 
> Patch #8 ("Split check_acked() into two functions") is where check_acked()
> is reworked with an eye towards supporting different timeout values or
> silent reporting without adding too many arguments to check_acked().
> 
> After changing the IPI tests, I turned my attention to the LPI tests, which
> followed the same memory synchronization patterns, but invented their own
> interrupt handler and testing functions. Instead of redoing the work that I
> did for the IPI tests, I decided to convert the LPI tests to use the same
> infrastructure.
>

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/tree/arm/queue

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
