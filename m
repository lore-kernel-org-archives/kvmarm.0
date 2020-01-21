Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887D4C2D0CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 12:48:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 131622064C
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 12:48:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V9l/RjOr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 131622064C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 816064AFDE;
	Tue, 21 Jan 2020 07:48:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WPX-tIOL493V; Tue, 21 Jan 2020 07:47:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFBDA4AFEE;
	Tue, 21 Jan 2020 07:47:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BA5C4AFDD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 07:47:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0NdffqEzwEmf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 07:47:50 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6B7A4AFD2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 07:47:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579610870;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=GY+iQRTVNqzAwyuJVyAGWCFYTd4Vb20jwokeXldetiQ=;
 b=V9l/RjOrn5bDjy2gOLBOFwkEvsrMDrQ09s5AXSFxEryBPS+7M8MWYIymWxMJLsk6HNlTff
 pXsanWHlOHpFnKuYMIJhSxIVfeArffxP8JmWjNtsfxxCCpOcwtkY3jJM5zMWm3fnvOWcbF
 jiXv3jpgKH78MfbR77W0H5qh3cxUW1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-o7pT7f5bM8uq-sa5KpjA-Q-1; Tue, 21 Jan 2020 07:47:49 -0500
X-MC-Unique: o7pT7f5bM8uq-sa5KpjA-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E385190D340;
 Tue, 21 Jan 2020 12:47:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0000E84DB3;
 Tue, 21 Jan 2020 12:47:46 +0000 (UTC)
Date: Tue, 21 Jan 2020 13:47:44 +0100
From: Andrew Jones <drjones@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests 0/3] arm/arm64: selftest for pabt
Message-ID: <20200121124744.avp3g2p24q6p44di@kamzik.brq.redhat.com>
References: <20200113130043.30851-1-drjones@redhat.com>
 <bbd1f024-2f6c-d963-57f9-e6d7f2939fda@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bbd1f024-2f6c-d963-57f9-e6d7f2939fda@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

On Tue, Jan 21, 2020 at 01:24:31PM +0100, Paolo Bonzini wrote:
> On 13/01/20 14:00, Andrew Jones wrote:
> > Patch 3/3 is a rework of Alexandru's pabt test on top of a couple of
> > framework changes allowing it to be more simply and robustly implemented.
> > 
> > Andrew Jones (3):
> >   arm/arm64: Improve memory region management
> >   arm/arm64: selftest: Allow test_exception clobber list to be extended
> >   arm/arm64: selftest: Add prefetch abort test
> > 
> >  arm/selftest.c      | 199 ++++++++++++++++++++++++++++++++------------
> >  lib/arm/asm/setup.h |   8 +-
> >  lib/arm/mmu.c       |  24 ++----
> >  lib/arm/setup.c     |  56 +++++++++----
> >  lib/arm64/asm/esr.h |   3 +
> >  5 files changed, 203 insertions(+), 87 deletions(-)
> > 
> 
> Looks good, are you going to send a pull request for this?
>

Sure. I'll send in a few minutes.

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
