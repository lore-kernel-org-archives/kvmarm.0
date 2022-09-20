Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFCEC54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 08:58:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 375A64B634;
	Tue, 20 Sep 2022 04:58:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FvmmHOYByPnH; Tue, 20 Sep 2022 04:58:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 090724B63B;
	Tue, 20 Sep 2022 04:58:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC39A4B634
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 04:58:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9HhO2j+Ps-UG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 04:58:18 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55F834B600
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 04:58:18 -0400 (EDT)
Date: Tue, 20 Sep 2022 10:58:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663664296;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=FMTI7Vym7tvrr+o//WSBAOlcOiuOVV2FS/Ur/sM72JM=;
 b=iA1DkgSiXxTM/TN3GGsM4c/ByzvyeCMycBcn4h6DlEXtoZ8QhHyr+5nhfLFptP0NS7NIzj
 2d3V8gdlsH4qYCh1R4amY02+FgLJLftf5naX3+GGGEtzDji+mB47rGjbGUc5QmT7l6S5YB
 66v4dHtnIeyBk2NipmZ9NzwTVFIGSvM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 07/19] arm/arm64: Mark the phys_end
 parameter as unused in setup_mmu()
Message-ID: <20220920085815.qk6js67qjvken2kt@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-8-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-8-alexandru.elisei@arm.com>
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

On Tue, Aug 09, 2022 at 10:15:46AM +0100, Alexandru Elisei wrote:
> phys_end was used to cap the linearly mapped memory to 3G to allow 1G of
> room for the vmalloc area to grown down. This was made useless in commit
> c1cd1a2bed69 ("arm/arm64: mmu: Remove memory layout assumptions"), when
> setup_mmu() was changed to map all the detected memory regions without
> changing their limits.

c1cd1a2bed69 was a start, but as that commit says, the 3G-4G region was
still necessary due to assumptions in the virtual memory allocator. This
patch needs to point out a vmalloc commit which removes that assumption
as well for its justification.

Thanks,
drew

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/mmu.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index e1a72fe4941f..8f936acafe8b 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -153,14 +153,10 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>  	}
>  }
>  
> -void *setup_mmu(phys_addr_t phys_end, void *unused)
> +void *setup_mmu(phys_addr_t unused0, void *unused1)
>  {
>  	struct mem_region *r;
>  
> -	/* 3G-4G region is reserved for vmalloc, cap phys_end at 3G */
> -	if (phys_end > (3ul << 30))
> -		phys_end = 3ul << 30;
> -
>  #ifdef __aarch64__
>  	init_alloc_vpage((void*)(4ul << 30));
>  
> -- 
> 2.37.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
