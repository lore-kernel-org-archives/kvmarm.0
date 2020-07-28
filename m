Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA44AC433E4
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 13:02:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6150920714
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 13:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ax9d4U/E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6150920714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB15D4BA3B;
	Tue, 28 Jul 2020 09:02:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hj7TT4yQcoIq; Tue, 28 Jul 2020 09:02:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7A484BA52;
	Tue, 28 Jul 2020 09:02:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E6ED4BA3B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 09:02:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WuKx9EhSLnlx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2020 09:02:04 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31CB44B9FD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 09:02:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1595941324;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=OKtEBQaZn0YzZZHRsb7SFbrApIA8b080HrT/IDEZIaQ=;
 b=ax9d4U/E0hjb5cQXwgDd7zcUG2GxDk9+2TaRhpIYEYxubMMJX/KzHmfqlYCtJ3HVyvbDDT
 84WN/4G/ss4uw7tUooblaU0eDDPhGodG5kMReFoLZdROdQx51IVvQs9y3R8yIloVm+L1XS
 6UqPd15GuhXTISTNbZDAuBis2mTqCWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-CIQdaN17OKK5X56TfILZDQ-1; Tue, 28 Jul 2020 08:59:19 -0400
X-MC-Unique: CIQdaN17OKK5X56TfILZDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 782BC1009618;
 Tue, 28 Jul 2020 12:59:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.15])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BE7031C937;
 Tue, 28 Jul 2020 12:59:14 +0000 (UTC)
Date: Tue, 28 Jul 2020 14:59:11 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/5] KVM: arm64: pvtime: Fixes and a new cap
Message-ID: <20200728125911.ym7fcdp57tbtl32m@kamzik.brq.redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <b9176783230caeb1224043ed150c4139@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b9176783230caeb1224043ed150c4139@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 steven.price@arm.com
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

On Mon, Jul 27, 2020 at 07:01:04PM +0100, Marc Zyngier wrote:
> On 2020-07-11 11:04, Andrew Jones wrote:
> > The first three patches in the series are fixes that come from testing
> > and reviewing pvtime code while writing the QEMU support (I'll reply
> > to this mail with a link to the QEMU patches after posting - which I'll
> > do shortly). The last patch is only a convenience for userspace, and I
> > wouldn't be heartbroken if it wasn't deemed worth it. The QEMU patches
> > I'll be posting are currently written without the cap. However, if the
> > cap is accepted, then I'll change the QEMU code to use it.
> > 
> > Thanks,
> > drew
> > 
> > Andrew Jones (5):
> >   KVM: arm64: pvtime: steal-time is only supported when configured
> >   KVM: arm64: pvtime: Fix potential loss of stolen time
> >   KVM: arm64: pvtime: Fix stolen time accounting across migration
> >   KVM: Documentation minor fixups
> >   arm64/x86: KVM: Introduce steal-time cap
> > 
> >  Documentation/virt/kvm/api.rst    | 20 ++++++++++++++++----
> >  arch/arm64/include/asm/kvm_host.h |  2 +-
> >  arch/arm64/kvm/arm.c              |  3 +++
> >  arch/arm64/kvm/pvtime.c           | 31 +++++++++++++++----------------
> >  arch/x86/kvm/x86.c                |  3 +++
> >  include/linux/kvm_host.h          | 19 +++++++++++++++++++
> >  include/uapi/linux/kvm.h          |  1 +
> >  7 files changed, 58 insertions(+), 21 deletions(-)
> 
> Hi Andrew,
> 
> Sorry about the time it took to get to this series.

No problem.

> Although I had a number of comments, they are all easy to
> address, and you will hopefully be able to respin it quickly

I'll address all the comments and get it respun right away.

> (assuming we agree that patch #1 is unnecessary).

I'm not sure yet. I've suggested yet another interpretation
of the spec and will see what you say about that.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
