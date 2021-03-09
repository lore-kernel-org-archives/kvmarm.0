Return-Path: <SRS0=aIiX=IH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5373BC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 13:20:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF002650E6
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 13:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF002650E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2E1D4B346;
	Tue,  9 Mar 2021 08:20:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id srBbMgOtAqsD; Tue,  9 Mar 2021 08:20:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE5FA4B45C;
	Tue,  9 Mar 2021 08:20:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA5DF4B45A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 08:20:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uwhLQMd5KKBD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Mar 2021 08:20:34 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23FD64B409
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 08:20:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615296033;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=vnG6VAZGUSIfQJb+HRGgF9NNG2xl2aHTWM0Qb7o+3ag=;
 b=ghci+U1B5Wr2pTM2QCwNQGWBwkH65FM0rnAv4tLkPM9LQ1/oqqp1mBCCtS8phB0RIQUfzV
 XZHdVR1I4ewM70++YeIsIcw1tfrO8i6Y1bVvWrec84dfB1Zc2piPUkjtoIus+qSfggRFBA
 qaRvV8RrKqLa2NDYYO8OaEoHdJ51YOw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-1noFX22NOMKwnU5HOldGvg-1; Tue, 09 Mar 2021 08:20:29 -0500
X-MC-Unique: 1noFX22NOMKwnU5HOldGvg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4024C101F013;
 Tue,  9 Mar 2021 13:20:27 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.217])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CE895C266;
 Tue,  9 Mar 2021 13:20:24 +0000 (UTC)
Date: Tue, 9 Mar 2021 14:20:21 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Cap default IPA size to the host's own size
Message-ID: <20210309132021.7vuuf73joybhlhg3@kamzik.brq.redhat.com>
References: <20210308174643.761100-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210308174643.761100-1-maz@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

Hi Marc,

On Mon, Mar 08, 2021 at 05:46:43PM +0000, Marc Zyngier wrote:
> KVM/arm64 has forever used a 40bit default IPA space, partially
> due to its 32bit heritage (where the only choice is 40bit).
> 
> However, there are implementations in the wild that have a *cough*
> much smaller *cough* IPA space, which leads to a misprogramming of
> VTCR_EL2, and a guest that is stuck on its first memory access
> if userspace dares to ask for the default IPA setting (which most
> VMMs do).
> 
> Instead, cap the default IPA size to what the host can actually
> do, and spit out a one-off message on the console. The boot warning
> is turned into a more meaningfull message, and the new behaviour
> is also documented.
> 
> Although this is a userspace ABI change, it doesn't really change
> much for userspace:
> 
> - the guest couldn't run before this change, while it now has
>   a chance to if the memory range fits the reduced IPA space
> 
> - a memory slot that was accepted because it did fit the default
>   IPA space but didn't fit the HW constraints is now properly
>   rejected

I'm not sure deferring the misconfiguration error until memslot
request time is better than just failing to create a VM. If
userspace doesn't use KVM_CAP_ARM_VM_IPA_SIZE to determine the
limit (which it hasn't been obliged to do) and it is able to
successfully create a VM, then it will assume up to 40-bit IPAs
are supported. Later, when it tries to add memslots and fails
it may be confused, especially if that later is much, much later
with memory hotplug.

> 
> The other thing that's left doing is to convince userspace to
> actually use the IPA space setting instead of relying on the
> antiquated default.

Failing to create any VM which hasn't selected a valid IPA limit
should be pretty convincing :-)

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
