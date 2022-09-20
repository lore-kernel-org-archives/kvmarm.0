Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF4AECAAD8
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 08:40:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F19FA4B133;
	Tue, 20 Sep 2022 04:40:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gRY3rYxdkK8u; Tue, 20 Sep 2022 04:40:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC4914B632;
	Tue, 20 Sep 2022 04:40:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 496BA4B133
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 04:40:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id plVN5K6jK7Ot for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 04:40:50 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E1FB4B125
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 04:40:50 -0400 (EDT)
Date: Tue, 20 Sep 2022 10:40:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663663248;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=lHFpp7hkEKHFOnfHwDvnl2TA13NgithyV4MAxYR7lFw=;
 b=hOLqMjZEActPJjnEsEOOMcSvEmbyxu+Is3FgBzWFo2dvi+zRY3bGLWLc2UvF37oEyft5u1
 DY1ESt1u7zNxVXVi7DaI4On4yGMStJZSFPB2gAAZul8oVeCTS2n0p3VswOK1BAXnO6/iYV
 lPzp6rpr95YEvwLxZqMrNVaQDC7WqdA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 06/19] lib/alloc_phys: Remove
 allocation accounting
Message-ID: <20220920084047.gblxkhedbugl7giz@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-7-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-7-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: nikos.nikoleris@arm.com, pbonzini@redhat.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Tue, Aug 09, 2022 at 10:15:45AM +0100, Alexandru Elisei wrote:
> The page allocator has better allocation tracking and is used by all
> architectures, while the physical allocator is now never used for
> allocating memory.
> 
> Simplify the physical allocator by removing allocation accounting. This
> accomplishes two things:
> 
> 1. It makes the allocator more useful, as the warning that was displayed
> each allocation after the 256th is removed.
> 
> 2. Together with the lock removal, the physical allocator becomes more
> appealing as a very early allocator, when using the page allocator might
> not be desirable or feasible.

How does the locking cause problems when used in an early allocator?

> 
> Also, phys_alloc_show() has received a slight change in the way it displays
> the use and free regions: the end of the region is now non-inclusive, to
> allow phys_alloc_show() to express that no memory has been used, or no
> memory is free, in which case the start and the end adresses are equal.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/alloc_phys.c | 65 ++++++++++++++----------------------------------
>  lib/alloc_phys.h |  5 ++--
>  2 files changed, 21 insertions(+), 49 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
