Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873BCECAAD8
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 09:37:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14E1E4B653;
	Tue, 20 Sep 2022 05:37:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b2QyuaZc-2ZN; Tue, 20 Sep 2022 05:37:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F175F4B640;
	Tue, 20 Sep 2022 05:37:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1423A4B640
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 05:37:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ULffWBZod4Zn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 05:37:41 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0F314B62E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 05:37:41 -0400 (EDT)
Date: Tue, 20 Sep 2022 11:37:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663666660;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=SyFC0KJGAwjjfK8g+X0MjVckVUVCJL+c1Ewito/NJAg=;
 b=pFVXVy6ygSWbbhZG0Fq6o4wfNZ682N7xfolZ2zGOta6IHVnBOrVq1KV+AM76LrwbYniXwg
 1AmcNm/1bF4UOTqTVXnlwEsda0m4p3iFqx65k5x8BgAJn6twYK3hgkNg7Sf+ybYkfLMcXl
 cqWYbNwUydxPvYkRN7b+DkT3dTqghC4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 12/19] arm/arm64: assembler.h: Replace
 size with end address for dcache_by_line_op
Message-ID: <20220920093739.owclltsryhpxkh6h@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-13-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-13-alexandru.elisei@arm.com>
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

On Tue, Aug 09, 2022 at 10:15:51AM +0100, Alexandru Elisei wrote:
> Commit b5f659be4775 ("arm/arm64: Remove dcache_line_size global
> variable") moved the dcache_by_line_op macro to assembler.h and changed
> it to take the size of the regions instead of the end address as
> parameter. This was done to keep the file in sync with the upstream
> Linux kernel implementation at the time.
> 
> But in both places where the macro is used, the code has the start and
> end address of the region, and it has to compute the size to pass it to
> dcache_by_line_op. Then the macro itsef computes the end by adding size
> to start.
> 
> Get rid of this massaging of parameters and change the macro to the end
> address as parameter directly.
> 
> Besides slightly simplyfing the code by remove two unneeded arithmetic
> operations, this makes the macro compatible with the current upstream
> version of Linux (which was similarly changed to take the end address in
> commit 163d3f80695e ("arm64: dcache_by_line_op to take end parameter
> instead of size")), which will allow us to reuse (part of) the Linux C
> wrappers over the assembly macro.
> 
> The change has been tested with the same snippet of code used to test
> commit 410b3bf09e76 ("arm/arm64: Perform dcache clean + invalidate after
> turning MMU off").
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/cstart.S              |  1 -
>  arm/cstart64.S            |  1 -
>  lib/arm/asm/assembler.h   | 11 +++++------
>  lib/arm64/asm/assembler.h | 11 +++++------
>  4 files changed, 10 insertions(+), 14 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
