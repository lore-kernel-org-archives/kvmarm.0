Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A25C4741F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 09:14:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CC66720897
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 09:14:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="db/A4TvE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC66720897
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C93624B59B;
	Mon,  9 Nov 2020 04:14:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fVouyFtwWkMU; Mon,  9 Nov 2020 04:14:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B714F4B6FE;
	Mon,  9 Nov 2020 04:14:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDD834B59B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 04:14:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d6bSoLwcRlez for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 04:14:31 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE68C4B435
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 04:14:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604913271;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=KihTEpPcQ9L598DE5g+gOSNJvgiBXCjZmgQm64yE1sM=;
 b=db/A4TvElJMuu4BCtw15GiPQWF1gEJdlxf4Cv5lXwVPM1mCYnFqhmIw7YA4UAjcMvkaNMt
 ci1SDw7T2gUysZt6Gp/xRk1dXpHl0PR5nckJUm6/e6sElah0HpsyJXq0WTYG3HvwABI/kO
 d9gpZbewGs3EM6L4YRW37nSFhRWU3ak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-j2dZGLI5P1KQahwIHa-MKg-1; Mon, 09 Nov 2020 04:14:29 -0500
X-MC-Unique: j2dZGLI5P1KQahwIHa-MKg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C3931868416;
 Mon,  9 Nov 2020 09:14:28 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.176])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E70845D9D2;
 Mon,  9 Nov 2020 09:14:22 +0000 (UTC)
Date: Mon, 9 Nov 2020 10:14:20 +0100
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 0/4] KVM: selftests: Add get-reg-list regression test
Message-ID: <20201109091420.s2ie4ae3ffsvupx2@kamzik.brq.redhat.com>
References: <20201029201703.102716-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201029201703.102716-1-drjones@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: pbonzini@redhat.com, Dave.Martin@arm.com, maz@kernel.org
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

On Thu, Oct 29, 2020 at 09:16:59PM +0100, Andrew Jones wrote:
> Since Eric complained in his KVM Forum talk that there weren't any
> aarch64-specific KVM selftests, now he gets to review one. This test
> was inspired by recent regression report about get-reg-list losing
> a register between an old kernel version and a new one.
> 
> Thanks,
> drew
> 
> 
> Andrew Jones (4):
>   KVM: selftests: Don't require THP to run tests
>   KVM: selftests: Add aarch64 get-reg-list test
>   KVM: selftests: Update aarch64 get-reg-list blessed list
>   KVM: selftests: Add blessed SVE registers to get-reg-list
>

Paolo,

I see you silently applied this series to kvm/master, but there's a
v2 of the series on the list which incorporates Marc's comments. And,
the application of the series is bad, because you've squashed "Update
aarch64 get-reg-list blessed list" into "Add aarch64 get-reg-list test".
Those were created as separate patches on purpose in order for the
commit message of "Add aarch64 get-reg-list test" to reflect the kernel
version from which the blessed reg list was primed and the commit
message of "Update aarch64 get-reg-list blessed list" to explicitly
point out the new commits that introduce the new registers since the
priming kernel version up to the current kernel version. The division
was also done to ensure the same pattern is used for future updates of
the list.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
