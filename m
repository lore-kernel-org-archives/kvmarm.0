Return-Path: <SRS0=N2lg=SL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F78BC10F0E
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 07:40:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E51C20880
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 07:40:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E51C20880
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 724FD4A46F;
	Tue,  9 Apr 2019 03:40:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IVB2SV6y90Oa; Tue,  9 Apr 2019 03:40:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6465F4A452;
	Tue,  9 Apr 2019 03:40:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C96A54A452
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 03:40:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xxh8slN9GaAr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Apr 2019 03:40:09 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D008F4A369
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 03:40:09 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 1ED5F3082B68;
 Tue,  9 Apr 2019 07:40:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 08E205D9C9;
 Tue,  9 Apr 2019 07:40:07 +0000 (UTC)
Date: Tue, 9 Apr 2019 09:40:05 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH] lib: arm: Use correct halt() prototype
 from smp.h
Message-ID: <20190409074005.6fc5sve4kbpq6e5r@kamzik.brq.redhat.com>
References: <20190408151125.32080-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190408151125.32080-1-alexandru.elisei@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.45]); Tue, 09 Apr 2019 07:40:09 +0000 (UTC)
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190409074005.lXybokpGpz0FgEuMwmxJ76iAj48uC27IgKJVAgqpCHU@z>

On Mon, Apr 08, 2019 at 04:11:25PM +0100, Alexandru Elisei wrote:
> The prototype for the halt() function is incorrect, because halt() doesn't
> take any arguments. Fix it by using the prototype from smp.h.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/io.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 8226b765bdc5..6d3d7afed002 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -15,11 +15,10 @@
>  #include <asm/psci.h>
>  #include <asm/spinlock.h>
>  #include <asm/io.h>
> +#include <asm/smp.h>
>  
>  #include "io.h"
>  
> -extern void halt(int code);
> -
>  static struct spinlock uart_lock;
>  /*
>   * Use this guess for the uart base in order to make an attempt at
> @@ -93,6 +92,6 @@ void exit(int code)
>  {
>  	chr_testdev_exit(code);
>  	psci_system_off();
> -	halt(code);
> +	halt();
>  	__builtin_unreachable();
>  }
> -- 
> 2.17.0
>

I don't mind this change, because per the code it is the "correct"
thing to do. However, I was being a bit tricky here when I wrote it.
By changing the prototype to take 'code' as argument we guarantee
that 'code' will be in x0/r0 when we halt, giving us a last chance
to see it when inspecting the halted unit test state.

Anyway, like I said, I'm fine with the cleanup, but the prototype
abuse does serve a purpose - maybe just not a good enough purpose
to justify the weirdness.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
