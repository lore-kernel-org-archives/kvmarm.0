Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5918DC433E2
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 13:39:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF347208E4
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 13:39:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SYXtmeZj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF347208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 033F34B175;
	Thu, 10 Sep 2020 09:39:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V31UAdIddDq3; Thu, 10 Sep 2020 09:39:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E49EA4B113;
	Thu, 10 Sep 2020 09:39:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B9BF4B113
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 09:39:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XvjzOohWBqob for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 09:39:32 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 936EE4B10D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 09:39:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599745172;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7Y7Gme+6mP2kIxJBsfheP4T3JUU/zqQQOzX9yjwzzBo=;
 b=SYXtmeZjawLn6nE8Y3E+FaXBAm+5R0T0AR0TljniRwcukmDjUH9B/A2azCzd9wla+IqTWx
 jdOgXTBUCfvGmyfXLPFmKIq8YxZMglMIvrRVyW2b/nKtBpkUoClZKC3stiK6Wl22XISnso
 qgYTOLa7kzN+aZRxzanP37g3nlzydP0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-D1iJLJKcOje_PlRAcUXcZg-1; Thu, 10 Sep 2020 09:39:28 -0400
X-MC-Unique: D1iJLJKcOje_PlRAcUXcZg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34B0118BA283;
 Thu, 10 Sep 2020 13:39:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.124])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACD1E5D9E8;
 Thu, 10 Sep 2020 13:39:22 +0000 (UTC)
Date: Thu, 10 Sep 2020 15:39:19 +0200
From: Andrew Jones <drjones@redhat.com>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v2 0/2] MTE support for KVM guest
Message-ID: <20200910133919.rkmki6x7iscbaymh@kamzik.brq.redhat.com>
References: <20200904160018.29481-1-steven.price@arm.com>
 <20200909152540.ylnrljd6aelxoxrf@kamzik.brq.redhat.com>
 <5cb1d7ed-54a5-4337-6c3d-2e3e7df89f17@linaro.org>
 <20200910054440.pvnzk7p7riiy45e2@kamzik.brq.redhat.com>
 <20200910132748.GF2814@work-vm>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200910132748.GF2814@work-vm>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: Peter Maydell <Peter.Maydell@arm.com>, linux-kernel@vger.kernel.org,
 Juan Quintela <quintela@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
 Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Dave Martin <Dave.Martin@arm.com>
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

On Thu, Sep 10, 2020 at 02:27:48PM +0100, Dr. David Alan Gilbert wrote:
> * Andrew Jones (drjones@redhat.com) wrote:
> > On Wed, Sep 09, 2020 at 06:45:33PM -0700, Richard Henderson wrote:
> > > On 9/9/20 8:25 AM, Andrew Jones wrote:
> > > >>  * Provide a KVM-specific method to extract the tags from guest memory.
> > > >>    This might also have benefits in terms of providing an easy way to
> > > >>    read bulk tag data from guest memory (since the LDGM instruction
> > > >>    isn't available at EL0).
> > > > 
> > > > Maybe we need a new version of KVM_GET_DIRTY_LOG that also provides
> > > > the tags for all addresses of each dirty page.
> > > 
> > > KVM_GET_DIRTY_LOG just provides one bit per dirty page, no?  Then VMM copies
> > > the data out from its local address to guest memory.
> > > 
> > > There'd be no difference with or without tags, afaik.  It's just about how VMM
> > > copies the data, with or without tags.
> > 
> > Right, as long as it's fast enough to do
> > 
> >   for_each_dirty_page(page, dirty_log)
> >     for (i = 0; i < host-page-size/16; i += 16)
> >       append_tag(LDG(page + i))
> > 
> > to get all the tags for each dirty page. I understood it would be faster
> > to use LDGM, but we'd need a new ioctl for that. So I was proposing we
> > just piggyback on a new dirty-log ioctl instead.
> 
> That feels a bad idea to me; there's a couple of different ways dirty
> page checking work; lets keep extracting the tags separate.
>

It's sounding like it was a premature optimization anyway. We don't yet
know if an ioctl for LDGM is worth it. Looping over LDG may work fine.

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
