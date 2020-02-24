Return-Path: <SRS0=MUVm=4M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84B3C35671
	for <kvmarm@archiver.kernel.org>; Mon, 24 Feb 2020 13:22:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62D432072D
	for <kvmarm@archiver.kernel.org>; Mon, 24 Feb 2020 13:22:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKnBAFyI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62D432072D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC4E14B008;
	Mon, 24 Feb 2020 08:22:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d+NErSpsN7po; Mon, 24 Feb 2020 08:22:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB2904AFF8;
	Mon, 24 Feb 2020 08:22:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 860324AFC0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Feb 2020 08:22:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BB981jD+vQza for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Feb 2020 08:22:11 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DDEB4AF9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Feb 2020 08:22:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1582550531;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=AQSjOCN08tuHWwFl/AFZaF1M6yIcbXibQI3Uq0KWdfM=;
 b=VKnBAFyIRCtNeajpZXCSPoyK1odu8kmGYYF8Z/8SIYQXhQktsmmgPpWiDKDEZaR4HEbxJ4
 ItT4k7nKHQeRQ3nS6T/lZKwvN4Ehu+ap8mnVJcG8dTPFOuwFY3Oma0MFyy3fmcFHMxsHAT
 6CjU/ZvXPZX+MdhWPf+LDRZ21ONZ0qs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-vny8QQvLOrO2Y37m0onvfA-1; Mon, 24 Feb 2020 08:22:07 -0500
X-MC-Unique: vny8QQvLOrO2Y37m0onvfA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2DDC1005F6C;
 Mon, 24 Feb 2020 13:22:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 21E4C5C554;
 Mon, 24 Feb 2020 13:22:02 +0000 (UTC)
Date: Mon, 24 Feb 2020 14:22:00 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/3] KVM: arm64: Ask the compiler to __always_inline
 functions used by KVM at HYP
Message-ID: <20200224132200.ho7hgmnah2zfh27x@kamzik.brq.redhat.com>
References: <20200220165839.256881-1-james.morse@arm.com>
 <cb56f509ea0a4a9e1809af76f319daa2@kernel.org>
MIME-Version: 1.0
In-Reply-To: <cb56f509ea0a4a9e1809af76f319daa2@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Fri, Feb 21, 2020 at 12:55:16PM +0000, Marc Zyngier wrote:
> Hi James,
> 
> On 2020-02-20 16:58, James Morse wrote:
> > Hello!
> > 
> > It turns out KVM relies on the inline hint being honoured by the
> > compiler
> > in quite a few more places than expected. Something about the Shadow
> > Call
> > Stack support[0] causes the compiler to avoid inline-ing and to place
> > these functions outside the __hyp_text. This ruins KVM's day.
> > 
> > Add the simon-says __always_inline annotation to all the static
> > inlines that KVM calls from HYP code.
> > 
> > This series based on v5.6-rc2.
> 
> Many thanks for going through all this.
> 
> I'm happy to take it if Catalin or Will ack the arm64 patches.
> It case we decide to go the other way around:
> 
> Acked-by: Marc Zyngier <maz@kernel.org>
> 
> One thing I'd like to look into though is a compile-time check that
> nothing in the hyp_text section has a reference to a non-hyp_text
> symbol.
> 
> We already have checks around non-init symbols pointing to init symbols,
> and I was wondering if we could reuse this for fun and profit...

Hi Marc,

I recall that you've suggested that before, and I even tried it around
that time [*]. I wasn't happy enough with it to post a proper patch
though.

[*] https://lists.cs.columbia.edu/pipermail/kvmarm/2018-May/031629.html

Thanks,
drew

> 
> Thanks,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
