Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972B8ECAAD8
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 09:05:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2D754B64C;
	Tue, 20 Sep 2022 05:05:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QJdfa+jp8VrE; Tue, 20 Sep 2022 05:05:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF3604B63B;
	Tue, 20 Sep 2022 05:05:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28C1D4B634
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 05:05:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ou6FBi+IuPP9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 05:05:13 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D34CA4B62D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 05:05:13 -0400 (EDT)
Date: Tue, 20 Sep 2022 11:05:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663664713;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Lic4VqJwH8G8xBgMbRztRy4JLPWsDMcumTEkF8Sc/kM=;
 b=jGmrSCsCaVmNO+MuboYs+bgPKEDUBpGga9UeiCmENxDIxI3OFkePgZR8olCIO0iNZkM1Tl
 5ikd1/voQogkfj2OsRI5jcoVKF01zNaKATWENDqE5RcQGviWNq5EslIGHxLjBQv+JwBOF7
 4tnukEg09KWms2G0caw7FTIVy8o3jZw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 08/19] arm/arm64: Use pgd_alloc() to
 allocate mmu_idmap
Message-ID: <20220920090512.2633rhzqt62frxdn@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-9-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-9-alexandru.elisei@arm.com>
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

On Tue, Aug 09, 2022 at 10:15:47AM +0100, Alexandru Elisei wrote:
> Until commit 031755dbfefb ("arm: enable vmalloc"), the idmap was allocated
> using pgd_alloc(). After that commit, all the page table allocator
> functions were switched to using the page allocator, but pgd_alloc() was
> left unchanged and became unused, with the idmap now being allocated with
> alloc_page().
> 
> For arm64, the pgd table size varies based on the page size, which is
> configured by the user. For arm, it will always contain 4 entries (it
> translates bits 31:30 of the input address). To keep things simple and
> consistent with the other functions and across both architectures, modify
> pgd_alloc() to use alloc_page() instead of memalign like the rest of the
> page table allocator functions and use it to allocate the idmap.
> 
> Note that when the idmap is created, alloc_ops->memalign is
> memalign_pages() which allocates memory with page granularity. Using
> memalign() as before would still have allocated a full page.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/asm/pgtable.h   | 4 ++--
>  lib/arm/mmu.c           | 4 ++--
>  lib/arm64/asm/pgtable.h | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
