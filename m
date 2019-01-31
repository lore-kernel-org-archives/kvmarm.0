From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v2 3/4] arm64: hyp-stub: Forbid kprobing of the hyp-stub
Date: Thu, 31 Jan 2019 09:04:21 +0100
Message-ID: <20190131080421.GJ13482@e113682-lin.lund.arm.com>
References: <20190124163257.233929-1-james.morse@arm.com>
 <20190124163257.233929-4-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F46C4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 03:04:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aQ9ezEDlrjRV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 03:04:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E853E4A2B6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 03:04:23 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190124163257.233929-4-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 24, 2019 at 04:32:56PM +0000, James Morse wrote:
> The hyp-stub is loaded by the kernel's early startup code at EL2
> during boot, before KVM takes ownership later. The hyp-stub's
> text is part of the regular kernel text, meaning it can be kprobed.
> 
> A breakpoint in the hyp-stub causes the CPU to spin in el2_sync_invalid.
> 
> Add it to the __hyp_text.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Cc: stable@vger.kernel.org
> ---
> 
> This has been a problem since kprobes was merged, it should
> probably have been covered in 888b3c8720e0.
> 
> I'm not sure __hyp_text is the right place. Its not idmaped,
> and as it contains a set of vectors, adding it to the host/hyp
> idmap sections could grow them beyond a page... but it does
> run with the MMU off, so does need to be cleaned to PoC when
> anything wacky, like hibernate happens. With this patch,
> hibernate should clean the __hyp_text to PoC too.

How did this code get cleaned before?

Is there a problem you can identify with putting it in __hyp_text?
Seems to me we should just stick it there if it has no negative
side-effects and otherwise we have to make up a separate section with a
specialized meaning.


Thanks,

    Christoffer

> ---
>  arch/arm64/kernel/hyp-stub.S | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> index e1261fbaa374..17f325ba831e 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -28,6 +28,8 @@
>  #include <asm/virt.h>
>  
>  	.text
> +	.pushsection	.hyp.text, "ax"
> +
>  	.align 11
>  
>  ENTRY(__hyp_stub_vectors)
> -- 
> 2.20.1
> 
