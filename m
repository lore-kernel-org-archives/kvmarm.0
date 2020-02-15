Return-Path: <SRS0=VO0i=4D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74142C352A3
	for <kvmarm@archiver.kernel.org>; Sat, 15 Feb 2020 07:01:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E48242082F
	for <kvmarm@archiver.kernel.org>; Sat, 15 Feb 2020 07:01:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TAahIO0B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E48242082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B9EC4AEE8;
	Sat, 15 Feb 2020 02:01:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2inbLBkrpRCM; Sat, 15 Feb 2020 02:01:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 598AF4AEDA;
	Sat, 15 Feb 2020 02:01:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 241ED4AED3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 15 Feb 2020 02:01:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3LNuCf4oRz8R for <kvmarm@lists.cs.columbia.edu>;
 Sat, 15 Feb 2020 02:01:54 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 005DD4AED1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 15 Feb 2020 02:01:53 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581750113;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=l7wUMy9Egruu5qJqfOZtroUm6Z8sbzo1YYRQ0H1qgcw=;
 b=TAahIO0Bn9kHjlVEhGHuah1ovrKJlXeK7X0NmLXK9NoeuSgHlq7ijo7/IAOV9e5TI9TI7u
 byiXigQxpgC71gJas8GQBxbX/z9OalcbzB3NZNIzDUBH3xHSqWbnzcr7+TV94wRX+753tu
 s+zp5tgoraP4ePRUcSlJ2t7BZccg+vY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-k7BnYw-COzCDfMOmSNeV9A-1; Sat, 15 Feb 2020 02:01:49 -0500
X-MC-Unique: k7BnYw-COzCDfMOmSNeV9A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C83D818A5505;
 Sat, 15 Feb 2020 07:01:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A5D5C1001B2D;
 Sat, 15 Feb 2020 07:01:43 +0000 (UTC)
Date: Sat, 15 Feb 2020 08:01:40 +0100
From: Andrew Jones <drjones@redhat.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH kvm-unit-tests v3] arm64: timer: Speed up gic-timer-state
 check
Message-ID: <20200215070140.k4h3yki46rhsjdbj@kamzik.brq.redhat.com>
References: <20200213093257.23367-1-drjones@redhat.com>
 <cb4b85c1-7b25-f930-f09d-3ef86bc33930@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cb4b85c1-7b25-f930-f09d-3ef86bc33930@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

On Sat, Feb 15, 2020 at 11:41:46AM +0800, Zenghui Yu wrote:
> Hi Drew,
> 
> On 2020/2/13 17:32, Andrew Jones wrote:
> > Let's bail out of the wait loop if we see the expected state
> > to save over six seconds of run time. Make sure we wait a bit
> > before reading the registers and double check again after,
> > though, to somewhat mitigate the chance of seeing the expected
> > state by accident.
> > 
> > We also take this opportunity to push more IRQ state code to
> > the library.
> > 
> > Cc: Zenghui Yu <yuzenghui@huawei.com>
> 
> Please feel free to replace this with:
> 
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> Tested-by: Zenghui Yu <yuzenghui@huawei.com>

Done. Thanks!

drew

> 
> > Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> 
> Thanks
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
