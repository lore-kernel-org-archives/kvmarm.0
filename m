From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] ARM: KVM: Fix tracepoint generation after move to
 virt/kvm/arm/
Date: Mon, 15 May 2017 08:59:35 +0200
Message-ID: <20170515065935.GE9309@cbox>
References: <20170512100452.8245-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3402D40BC5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 02:56:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xH+r8sk-5h4h for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 May 2017 02:56:21 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC69B40187
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 02:56:20 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id f135so23167807wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 14 May 2017 23:59:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170512100452.8245-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 12, 2017 at 11:04:52AM +0100, Marc Zyngier wrote:
> Moving most of the shared code to virt/kvm/arm had for consequence
> that KVM/ARM doesn't build anymore, because the code that used to
> define the tracepoints is now somewhere else.
> 
> Fix this by defining CREATE_TRACE_POINTS in coproc.c, and clean-up
> trace.h as well.
> 
> Fixes: 35d2d5d490e2 ("KVM: arm/arm64: Move shared files to virt/kvm/arm")

Whoops.

> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks, applied to kvmarm/master.

-Christoffer

> ---
>  arch/arm/kvm/coproc.c | 1 +
>  arch/arm/kvm/trace.h  | 8 ++++----
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index 2c14b69511e9..ac8d36da4d08 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -32,6 +32,7 @@
>  #include <asm/vfp.h>
>  #include "../vfp/vfpinstr.h"
>  
> +#define CREATE_TRACE_POINTS
>  #include "trace.h"
>  #include "coproc.h"
>  
> diff --git a/arch/arm/kvm/trace.h b/arch/arm/kvm/trace.h
> index fc0943776db2..b0d10648c486 100644
> --- a/arch/arm/kvm/trace.h
> +++ b/arch/arm/kvm/trace.h
> @@ -1,5 +1,5 @@
> -#if !defined(_TRACE_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
> -#define _TRACE_KVM_H
> +#if !defined(_TRACE_ARM_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_ARM_KVM_H
>  
>  #include <linux/tracepoint.h>
>  
> @@ -74,10 +74,10 @@ TRACE_EVENT(kvm_hvc,
>  		  __entry->vcpu_pc, __entry->r0, __entry->imm)
>  );
>  
> -#endif /* _TRACE_KVM_H */
> +#endif /* _TRACE_ARM_KVM_H */
>  
>  #undef TRACE_INCLUDE_PATH
> -#define TRACE_INCLUDE_PATH arch/arm/kvm
> +#define TRACE_INCLUDE_PATH .
>  #undef TRACE_INCLUDE_FILE
>  #define TRACE_INCLUDE_FILE trace
>  
> -- 
> 2.11.0
> 
