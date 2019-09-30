Return-Path: <SRS0=6KZ/=XZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616CDC32792
	for <kvmarm@archiver.kernel.org>; Mon, 30 Sep 2019 14:51:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DCE0620815
	for <kvmarm@archiver.kernel.org>; Mon, 30 Sep 2019 14:51:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCE0620815
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 312504A6DB;
	Mon, 30 Sep 2019 10:51:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3PWiIJhNqXB0; Mon, 30 Sep 2019 10:51:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A5E84A6FE;
	Mon, 30 Sep 2019 10:51:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 803FC4A658
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Sep 2019 10:51:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jrYRCDeMP4yV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Sep 2019 10:51:38 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92F994A528
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Sep 2019 10:51:38 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id CA8CE59449;
 Mon, 30 Sep 2019 14:51:37 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 41A185D9C3;
 Mon, 30 Sep 2019 14:51:36 +0000 (UTC)
Date: Mon, 30 Sep 2019 16:51:33 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] lib: arm64: Add missing ISB in
 flush_tlb_page
Message-ID: <20190930145133.7hy5lkoym7mg5rce@kamzik.brq.redhat.com>
References: <20190930142508.25102-1-alexandru.elisei@arm.com>
 <20190930142508.25102-2-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190930142508.25102-2-alexandru.elisei@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.39]); Mon, 30 Sep 2019 14:51:37 +0000 (UTC)
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Sep 30, 2019 at 03:25:06PM +0100, Alexandru Elisei wrote:
> Linux commit d0b7a302d58a made it abundantly clear that certain CPU
> implementations require an ISB after a DSB. Add the missing ISB to
> flush_tlb_page. No changes are required for flush_tlb_all, as the function
> already had the ISB.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm64/asm/mmu.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
> index fa554b0c20ae..72d75eafc882 100644
> --- a/lib/arm64/asm/mmu.h
> +++ b/lib/arm64/asm/mmu.h
> @@ -24,6 +24,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
>  	dsb(ishst);
>  	asm("tlbi	vaae1is, %0" :: "r" (page));
>  	dsb(ish);
> +	isb();
>  }
>  
>  static inline void flush_dcache_addr(unsigned long vaddr)
> -- 
> 2.20.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
