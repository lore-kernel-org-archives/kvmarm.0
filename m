From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v2 2/4] arm64: kprobe: Always blacklist the KVM
 world-switch code
Date: Thu, 31 Jan 2019 09:08:49 +0100
Message-ID: <20190131080849.GL13482@e113682-lin.lund.arm.com>
References: <20190124163257.233929-1-james.morse@arm.com>
 <20190124163257.233929-3-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59D2D4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 03:08:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lt+abtVuR1B7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 03:08:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 231724A2B6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 03:08:52 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190124163257.233929-3-james.morse@arm.com>
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

On Thu, Jan 24, 2019 at 04:32:55PM +0000, James Morse wrote:
> On systems with VHE the kernel and KVM's world-switch code run at the
> same exception level. Code that is only used on a VHE system does not
> need to be annotated as __hyp_text as it can reside anywhere in the
>  kernel text.
> 
> __hyp_text was also used to prevent kprobes from patching breakpoint
> instructions into this region, as this code runs at a different
> exception level. While this is no longer true with VHE, KVM still
> switches VBAR_EL1, meaning a kprobe's breakpoint executed in the
> world-switch code will cause a hyp-panic.
> 
> Move the __hyp_text check in the kprobes blacklist so it applies on
> VHE systems too, to cover the common code and guest enter/exit
> assembly.
> 
> Fixes: 888b3c8720e0 ("arm64: Treat all entry code as non-kprobe-able")
> Signed-off-by: James Morse <james.morse@arm.com>
> Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>

> ---
>  arch/arm64/kernel/probes/kprobes.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
> index 2a5b338b2542..f17afb99890c 100644
> --- a/arch/arm64/kernel/probes/kprobes.c
> +++ b/arch/arm64/kernel/probes/kprobes.c
> @@ -478,13 +478,13 @@ bool arch_within_kprobe_blacklist(unsigned long addr)
>  	    addr < (unsigned long)__entry_text_end) ||
>  	    (addr >= (unsigned long)__idmap_text_start &&
>  	    addr < (unsigned long)__idmap_text_end) ||
> +	    (addr >= (unsigned long)__hyp_text_start &&
> +	    addr < (unsigned long)__hyp_text_end) ||
>  	    !!search_exception_tables(addr))
>  		return true;
>  
>  	if (!is_kernel_in_hyp_mode()) {
> -		if ((addr >= (unsigned long)__hyp_text_start &&
> -		    addr < (unsigned long)__hyp_text_end) ||
> -		    (addr >= (unsigned long)__hyp_idmap_text_start &&
> +		if ((addr >= (unsigned long)__hyp_idmap_text_start &&
>  		    addr < (unsigned long)__hyp_idmap_text_end))
>  			return true;
>  	}
> -- 
> 2.20.1
> 
