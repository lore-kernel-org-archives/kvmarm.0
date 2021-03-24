Return-Path: <SRS0=IgiY=IW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F14DFC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 24 Mar 2021 15:11:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C3C561A0D
	for <kvmarm@archiver.kernel.org>; Wed, 24 Mar 2021 15:11:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C3C561A0D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DC5A4B45D;
	Wed, 24 Mar 2021 11:11:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AcVEl4pMKJ-G; Wed, 24 Mar 2021 11:11:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA9AD4B451;
	Wed, 24 Mar 2021 11:11:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 540404B451
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Mar 2021 11:11:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UjsVqmvWA9-x for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Mar 2021 11:11:43 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CBB34B44E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Mar 2021 11:11:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1616598703;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=COLoYEzhl8p7Nd5f4N2/IVzBYYsgsv5l6H2MtrNaU6w=;
 b=SayNzyB5EW7WG7TRt70m2qLx/OQ9E3e2ivQpWRJMuw5neoSlnAnaLS7Vu2Wh7EXFIiNYpZ
 Rs+G6S4RFeXCi/4EGOuR3HTt2P3BoAkdO7BxklB0xxYv/xb13Zo9fApCHdLkhjSkUg6kgf
 hx/XW/mps9xWB7TVgSEikz0r6PJEViE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-Nlo_pYyJOp2zdxFjiEIUyg-1; Wed, 24 Mar 2021 11:11:40 -0400
X-MC-Unique: Nlo_pYyJOp2zdxFjiEIUyg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDBE6187D7EF;
 Wed, 24 Mar 2021 15:11:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9932C2B0DC;
 Wed, 24 Mar 2021 15:11:01 +0000 (UTC)
Date: Wed, 24 Mar 2021 16:10:58 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm: pmu: Fix failing PMU test when no
 PMU is available
Message-ID: <20210324151058.7as6ndvaz7ocho7y@kamzik.brq.redhat.com>
References: <20210324143856.2079220-1-maz@kernel.org>
 <23046a95-5876-e7a2-e4a4-6012a760815d@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <23046a95-5876-e7a2-e4a4-6012a760815d@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: Andrew Walbran <qwandor@google.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Mar 24, 2021 at 02:50:05PM +0000, Alexandru Elisei wrote:
> Hi Marc,
> 
> Thank you for the patch! I have already sent a patch for this [1], which was
> queued by Drew [2], but apparently has not landed in master yet.
> 
> [1] https://www.spinics.net/lists/kvm-arm/msg44084.html
> [2]
> https://gitlab.com/rhdrjones/kvm-unit-tests/-/commit/241dac4cadfd7d7ace8c8c3f0613376311b4e785

Thanks to you both for the patch and sorry for not getting Alexandru's
patch in early enough to avoid the double reporting and fixing. I
plan to send Paolo an MR as soon as tomorrow that includes the
patch and many others.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
