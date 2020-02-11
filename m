Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C388C352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 12:27:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC3B62082F
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 12:27:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W2FU3IlI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC3B62082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B65D4A650;
	Tue, 11 Feb 2020 07:27:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i2fOH-4xHMo6; Tue, 11 Feb 2020 07:27:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA43E4AE9E;
	Tue, 11 Feb 2020 07:27:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CAA04A650
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 07:27:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MH6P4s428fnF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 07:27:32 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5C904A578
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 07:27:32 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581424052;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ysT/sqc3he5fQb0IpIsZCQAPVEhjziWFabIs8nDoWx4=;
 b=W2FU3IlIWRXkcdp6c0wr5tHhe98+nBD7JySaSh29TxASn/Bpnqt3iRRAD3nYxBjmzkoFeY
 ydefYxbdeI1uxZ8QT8CmhPRkJAhVWPcs8hdGZpl8iABuwqwwFAo2nBR/uIkQG9xWsMVSPc
 kHRtCmNPquxhaX0HXgj3nPtwoNHZgcQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-dXMUP2FnMC-m1e7pP-SFlg-1; Tue, 11 Feb 2020 07:27:28 -0500
X-MC-Unique: dXMUP2FnMC-m1e7pP-SFlg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C1E38017CC;
 Tue, 11 Feb 2020 12:27:27 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C837560C80;
 Tue, 11 Feb 2020 12:27:25 +0000 (UTC)
Date: Tue, 11 Feb 2020 13:27:23 +0100
From: Andrew Jones <drjones@redhat.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] arm64: minor cleanups for timer test
Message-ID: <20200211122723.qrnjfnrmbwwdafhc@kamzik.brq.redhat.com>
References: <20200211083901.1478-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200211083901.1478-1-yuzenghui@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

On Tue, Feb 11, 2020 at 04:38:58PM +0800, Zenghui Yu wrote:
> Hi Drew,
> 
> There's some minor cleanups which based on your arm/queue branch for
> the timer test.  Please consider taking them if they make the code
> a bit better :)
> 
> Thanks
> 
> Zenghui Yu (3):
>   arm/arm64: gic: Move gic_state enumeration to asm/gic.h
>   arm64: timer: Use the proper RDist register name in GICv3
>   arm64: timer: Use existing helpers to access counter/timers
> 
>  arm/timer.c          | 27 ++++++++++-----------------
>  lib/arm/asm/gic-v3.h |  4 ++++
>  lib/arm/asm/gic.h    |  7 +++++++
>  3 files changed, 21 insertions(+), 17 deletions(-)
> 
> -- 
> 2.19.1
> 
>

Applied, thanks


Also, I noticed that the timer tests now take over 8 seconds to run.
I have a patch that speeds that up that I'll send for review in
just a second.

drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
