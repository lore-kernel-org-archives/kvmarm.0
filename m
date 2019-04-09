From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] lib: arm: Use correct halt() prototype
 from smp.h
Date: Tue, 9 Apr 2019 09:40:05 +0200
Message-ID: <20190409074005.6fc5sve4kbpq6e5r@kamzik.brq.redhat.com>
References: <20190408151125.32080-1-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C96A54A452
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 03:40:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xxh8slN9GaAr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Apr 2019 03:40:09 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D008F4A369
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 03:40:09 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190408151125.32080-1-alexandru.elisei@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

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
