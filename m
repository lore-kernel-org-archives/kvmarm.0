Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35040C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 15:00:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9197864FC3
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 15:00:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9197864FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 067FD4B3B1;
	Fri, 12 Mar 2021 10:00:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RS2f0GI+y9hS; Fri, 12 Mar 2021 10:00:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D15524B3BE;
	Fri, 12 Mar 2021 10:00:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15D584B3B8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 09:59:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vCQyHoH8jJal for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 09:59:58 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A1F94B3B1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 09:59:58 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615561197;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=rjGcZs7Vy2maRevaHJ9Zv8LK1uzd9Lhozx0sgGCsnz8=;
 b=jHZ36SaI91dtcgPQFFvJN/jO7yknZ7sKqUvkUiaLFxwHP8OrTGpORi6bQbchQHcrEe9EXS
 84Vii5si1T5FK2fRrpqRw+YFt2QFXoAlNCmlu907WAE/mcw7XjYukUQW63SrqN0JlHzGpY
 jhC7JKh5s3Hji1jDGM4k6n78OvZEYow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-JB7uhuwoOqSXK344pdd6bg-1; Fri, 12 Mar 2021 09:59:56 -0500
X-MC-Unique: JB7uhuwoOqSXK344pdd6bg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C37FA81746C;
 Fri, 12 Mar 2021 14:59:54 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.104])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C4A255D6D7;
 Fri, 12 Mar 2021 14:59:53 +0000 (UTC)
Date: Fri, 12 Mar 2021 15:59:50 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 3/6] arm/arm64: Remove unnecessary ISB
 when doing dcache maintenance
Message-ID: <20210312145950.whq7ofrhbklwhprx@kamzik.brq.redhat.com>
References: <20210227104201.14403-1-alexandru.elisei@arm.com>
 <20210227104201.14403-4-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210227104201.14403-4-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Sat, Feb 27, 2021 at 10:41:58AM +0000, Alexandru Elisei wrote:
> The dcache_by_line_op macro executes a DSB to complete the cache
> maintenance operations. According to ARM DDI 0487G.a, page B2-150:
> 
> "In addition, no instruction that appears in program order after the DSB
> instruction can alter any state of the system or perform any part of its
> functionality until the DSB completes other than:
> 
> - Being fetched from memory and decoded.
> - Reading the general-purpose, SIMD and floating-point, Special-purpose, or
>   System registers that are directly or indirectly read without causing
>   side-effects."
> 
> Similar definition for ARM in ARM DDI 0406C.d, page A3-150:
> 
> "In addition, no instruction that appears in program order after the DSB
> instruction can execute until the DSB completes."
> 
> This means that we don't need the ISB to prevent reordering of the cache
> maintenance instructions.
> 
> We are also not doing icache maintenance, where an ISB would be required
> for the PE to discard instructions speculated before the invalidation.
> 
> In conclusion, the ISB is unnecessary, so remove it.

Hi Alexandru,

We can go ahead and take this patch, since you've written quite a
convincing commit message, but in general I'd prefer we be overly cautious
in our common code. We'd like to ensure we don't introduce difficult to
debug issues there, and we don't care about optimizations, let alone
micro-optimizations. Testing barrier needs to the letter of the spec is a
good idea, but it's probably better to do that in the test cases.

Thanks,
drew

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/cstart.S   | 1 -
>  arm/cstart64.S | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 954748b00f64..2d62c1e6d40d 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -212,7 +212,6 @@ asm_mmu_disable:
>  	ldr	r1, [r1]
>  	sub	r1, r1, r0
>  	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
> -	isb
>  
>  	mov     pc, lr
>  
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 046bd3914098..c1deff842f03 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -219,7 +219,6 @@ asm_mmu_disable:
>  	ldr	x1, [x1, :lo12:__phys_end]
>  	sub	x1, x1, x0
>  	dcache_by_line_op civac, sy, x0, x1, x2, x3
> -	isb
>  
>  	ret
>  
> -- 
> 2.30.1
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
