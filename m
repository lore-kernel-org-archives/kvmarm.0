Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD361C43461
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 11:49:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14A9C20C09
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 11:49:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="axk1FjoE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14A9C20C09
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63BAB4B250;
	Thu, 10 Sep 2020 07:49:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4Gd5lT+d5a7M; Thu, 10 Sep 2020 07:49:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 617E44B258;
	Thu, 10 Sep 2020 07:49:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 726C54B249
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 07:49:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hZT-VjyuT-SL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 07:49:53 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D3AE4B240
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 07:49:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599738593;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Sjkjxl7XUETbHB6ANruWZFnmDHT7amDR67npklsZH2s=;
 b=axk1FjoEBm39T3DERGf/I7aCbtdmLJO950dBDaNvSQQ4y8TldqQgaV8KRtQzUSk2mzZ9Pz
 gLqoD3uMGHV7W4iEiZ0/8Amn46AV4KaytgQ/jHwAsx/Zzoql6nBx/tN1ncRfX7CARz7Q5e
 VoSYXz1g4gZq7uDQd4+qSrF+vmjpBuM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-SgqgcIBnNWOnuR5o4e7goA-1; Thu, 10 Sep 2020 07:49:51 -0400
X-MC-Unique: SgqgcIBnNWOnuR5o4e7goA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A6E9802B6C;
 Thu, 10 Sep 2020 11:49:49 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.124])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EC8FF1A923;
 Thu, 10 Sep 2020 11:49:45 +0000 (UTC)
Date: Thu, 10 Sep 2020 13:49:43 +0200
From: Andrew Jones <drjones@redhat.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v2 2/2] arm64: kvm: Introduce MTE VCPU feature
Message-ID: <20200910114943.cedbzlqfcgxg7jqs@kamzik.brq.redhat.com>
References: <20200904160018.29481-1-steven.price@arm.com>
 <20200904160018.29481-3-steven.price@arm.com>
 <20200909154804.mide6szbzgdy7jju@kamzik.brq.redhat.com>
 <3a7e18af-84bd-cee3-d68f-e08f225fc166@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3a7e18af-84bd-cee3-d68f-e08f225fc166@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: Peter Maydell <Peter.Maydell@arm.com>, Juan Quintela <quintela@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
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

On Thu, Sep 10, 2020 at 10:21:07AM +0100, Steven Price wrote:
> > We either need a KVM cap or a new CPU feature probing interface to avoid
> > making userspace try features one at a time. It's too bad that VCPU_INIT
> > doesn't clear all offending features from the feature set when returning
> > EINVAL, because then userspace could create a scratch VCPU with everything
> > it supports in order to see what KVM also supports in one go.
> 
> If Peter's TELL_ME_WHAT_YOU_HAVE idea works out then perhaps we don't need
> the cap? Or would it still be useful?
>

We wouldn't need it, but we don't _need_ it now either. It's not very
convenient to probe vcpu features with scratch vcpus, especially if we
must probe one at a time, but it works. The TELL_ME_WHAT_YOU_HAVE idea
will only fix the one at a time issue, but still require a vcpu fd. If
this feature becomes a VM feature then a cap or VM level API would help
reduce the userspace probing work.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
