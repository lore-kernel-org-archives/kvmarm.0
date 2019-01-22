From: Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH 2/4] arm64: kprobe: Always blacklist the KVM
 world-switch code
Date: Tue, 22 Jan 2019 11:47:46 +0900
Message-ID: <20190122114746.437af5a57eb9bcf706916cf3@kernel.org>
References: <20190121170404.142966-1-james.morse@arm.com>
 <20190121170404.142966-3-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190121170404.142966-3-james.morse@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 21 Jan 2019 17:04:02 +0000
James Morse <james.morse@arm.com> wrote:

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

Looks good to me!

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you,

> Signed-off-by: James Morse <james.morse@arm.com>
> Fixes: 888b3c8720e0 ("arm64: Treat all entry code as non-kprobe-able")
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


-- 
Masami Hiramatsu <mhiramat@kernel.org>
