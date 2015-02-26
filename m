From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 03/18] arm: fixups: add barriers, actually set MAIR
Date: Thu, 26 Feb 2015 12:37:55 +0100
Message-ID: <20150226113755.GB3143@cbox>
References: <1422815686-24591-1-git-send-email-drjones@redhat.com>
 <1422815686-24591-4-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6040546005
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 06:32:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yPfC6P+GEFkW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Feb 2015 06:32:11 -0500 (EST)
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E130C46ABC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 06:32:10 -0500 (EST)
Received: by labhs14 with SMTP id hs14so10333915lab.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 03:37:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1422815686-24591-4-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Feb 01, 2015 at 07:34:31PM +0100, Andrew Jones wrote:
> Sprinkle in some more isbs after context-changing operations,
> as the ARM ARM states we should. I haven't seen any problems
> without them, but we should do it right. Also, *actually* set
> the MAIR in asm_mmu_enable. We were reading, not writing...
> Luckily this was just spotted while adding the isbs, rather
> than leading to a nightmare debug session some day...
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/cstart.S        | 8 ++++++--
>  lib/arm/processor.c | 1 +
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/cstart.S b/arm/cstart.S
> index da496e9eae7e0..39fac8f1e1bd8 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -50,6 +50,7 @@ start:
>  .macro set_mode_stack mode, stack
>  	add	\stack, #S_FRAME_SIZE
>  	msr	cpsr_c, #(\mode | PSR_I_BIT | PSR_F_BIT)
> +	isb
>  	mov	sp, \stack
>  .endm
>  
> @@ -70,6 +71,7 @@ exceptions_init:
>  	set_mode_stack	FIQ_MODE, r1
>  
>  	msr	cpsr_cxsf, r2		@ back to svc mode
> +	isb
>  	mov	pc, lr
>  
I don't think you really need those after the cpsr, but whatever.

-Christoffer
