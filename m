Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BFF2ECAAD8
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 09:58:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15FDE4B641;
	Tue, 20 Sep 2022 05:58:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HICvOQxl5Ls2; Tue, 20 Sep 2022 05:58:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBFCA4B643;
	Tue, 20 Sep 2022 05:58:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2340D4B641
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 05:58:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3FLLGi5E4GQl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 05:58:10 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0E494B1B7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 05:58:10 -0400 (EDT)
Date: Tue, 20 Sep 2022 11:58:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663667890;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=RmS0I1Pb7j64z1blqOBHHrMkL9AmD0loyLLUt+93dA8=;
 b=imihoh1CmDd9PkJJDeULBdto46X38rhWBTw8XTT0HLWUPXYMBQCFjDVSyz+isgCE0ybwi/
 dy1WBjEqG7om/BskvFAgpFA/zQNUmBt3DThPp323EQNFrM+OL/pkJyMsYZuK33gl+N3+Dc
 0wsH4zi0wfLr10B/d0EMoJTQeWdfxuQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 16/19] arm/arm64: Allocate
 secondaries' stack using the page allocator
Message-ID: <20220920095802.bukms5w2phaxyaao@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-17-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-17-alexandru.elisei@arm.com>
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

On Tue, Aug 09, 2022 at 10:15:55AM +0100, Alexandru Elisei wrote:
> The vmalloc allocator returns non-id mapped addresses, where the virtual
> address is different than the physical address. This makes it impossible
> to access the stack of the secondary CPUs while the MMU is disabled.
> 
> On arm, THREAD_SIZE is 16K and PAGE_SIZE is 4K, which makes THREAD_SIZE
> a power of two multiple of PAGE_SIZE. On arm64, THREAD_SIZE is 16 when
> PAGE_SIZE is 4K or 16K, and 64K when PAGE_SIZE is 64K. In all cases,
> THREAD_SIZE is a power of two multiple of PAGE_SIZE. As a result, using
> memalign_pages() for the stack won't lead to wasted memory.
> 
> memalign_pages() allocates memory in chunks of power of two number of
> pages, aligned to the allocation size, which makes it a drop-in
> replacement for vm_memalign (which is the value for alloc_ops->memalign
> when the stack is allocated).
> 
> Using memalign_pages() has two distinct benefits:
> 
> 1. The secondary CPUs' stack can be used with the MMU off.
> 
> 2. The secondary CPUs' stack is identify mapped similar to the stack for
> the primary CPU, which makes the configuration of the CPUs consistent.
> 
> memalign_pages_flags() has been used instead of memalign_pages() to
> instruct the allocator not to zero the stack, as it's already zeroed in the
> entry code.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/asm/thread_info.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/arm/asm/thread_info.h b/lib/arm/asm/thread_info.h
> index eaa72582af86..190e082cbba0 100644
> --- a/lib/arm/asm/thread_info.h
> +++ b/lib/arm/asm/thread_info.h
> @@ -25,6 +25,7 @@
>  #ifndef __ASSEMBLY__
>  #include <asm/processor.h>
>  #include <alloc.h>
> +#include <alloc_page.h>
>  
>  #ifdef __arm__
>  #include <asm/ptrace.h>
> @@ -40,7 +41,7 @@
>  
>  static inline void *thread_stack_alloc(void)
>  {
> -	void *sp = memalign(THREAD_ALIGNMENT, THREAD_SIZE);
> +	void *sp = memalign_pages_flags(THREAD_ALIGNMENT, THREAD_SIZE, FLAG_DONTZERO);
>  	return sp + THREAD_START_SP;
>  }
>  
> -- 
> 2.37.1
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
