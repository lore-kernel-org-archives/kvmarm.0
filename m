From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 04/18] arm64: alternatives: Enforce alignment of struct
 alt_instr
Date: Wed, 6 Dec 2017 09:48:47 -0500
Message-ID: <20171206144847.GA28074@char.us.oracle.com>
References: <20171206143839.29223-1-marc.zyngier@arm.com>
 <20171206143839.29223-5-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4588640795
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 09:45:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RqQLX6qx6BDg for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Dec 2017 09:45:44 -0500 (EST)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24AB649D54
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 09:45:44 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171206143839.29223-5-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 06, 2017 at 02:38:25PM +0000, Marc Zyngier wrote:
> We're playing a dangerous game with struct alt_instr, as we produce
> it using assembly tricks, but parse them using the C structure.
> We just assume that the respective alignments of the two will
> be the same.
> 
> But as we add more fields to this structure, the alignment requirements
> of the structure may change, and lead to all kind of funky bugs.
> 
> TO solve this, let's move the definition of struct alt_instr to its
> own file, and use this to generate the alignment constraint from
> asm-offsets.c. The various macros are then patched to take the
> alignment into account.

Would it be better to use .p2align as on 32-bit ARM you must
have it 4-byte aligned. Or at least have and BUILD_BUG_ON
to make sure the size can be divided by four??

Oh wait. You are not even touching ARM-32, how come? The alternative
code can run on ARM-32 ...
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/alternative.h       | 13 +++++--------
>  arch/arm64/include/asm/alternative_types.h | 13 +++++++++++++
>  arch/arm64/kernel/asm-offsets.c            |  4 ++++
>  3 files changed, 22 insertions(+), 8 deletions(-)
>  create mode 100644 arch/arm64/include/asm/alternative_types.h
> 
> diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
> index 4a85c6952a22..395befde7595 100644
> --- a/arch/arm64/include/asm/alternative.h
> +++ b/arch/arm64/include/asm/alternative.h
> @@ -2,28 +2,24 @@
>  #ifndef __ASM_ALTERNATIVE_H
>  #define __ASM_ALTERNATIVE_H
>  
> +#include <asm/asm-offsets.h>
>  #include <asm/cpucaps.h>
>  #include <asm/insn.h>
>  
>  #ifndef __ASSEMBLY__
>  
> +#include <asm/alternative_types.h>
> +
>  #include <linux/init.h>
>  #include <linux/types.h>
>  #include <linux/stddef.h>
>  #include <linux/stringify.h>
>  
> -struct alt_instr {
> -	s32 orig_offset;	/* offset to original instruction */
> -	s32 alt_offset;		/* offset to replacement instruction */
> -	u16 cpufeature;		/* cpufeature bit set for replacement */
> -	u8  orig_len;		/* size of original instruction(s) */
> -	u8  alt_len;		/* size of new instruction(s), <= orig_len */
> -};
> -
>  void __init apply_alternatives_all(void);
>  void apply_alternatives(void *start, size_t length);
>  
>  #define ALTINSTR_ENTRY(feature)						      \
> +	" .align " __stringify(ALTINSTR_ALIGN) "\n"			      \
>  	" .word 661b - .\n"				/* label           */ \
>  	" .word 663f - .\n"				/* new instruction */ \
>  	" .hword " __stringify(feature) "\n"		/* feature bit     */ \
> @@ -69,6 +65,7 @@ void apply_alternatives(void *start, size_t length);
>  #include <asm/assembler.h>
>  
>  .macro altinstruction_entry orig_offset alt_offset feature orig_len alt_len
> +	.align ALTINSTR_ALIGN
>  	.word \orig_offset - .
>  	.word \alt_offset - .
>  	.hword \feature
> diff --git a/arch/arm64/include/asm/alternative_types.h b/arch/arm64/include/asm/alternative_types.h
> new file mode 100644
> index 000000000000..26cf76167f2d
> --- /dev/null
> +++ b/arch/arm64/include/asm/alternative_types.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_ALTERNATIVE_TYPES_H
> +#define __ASM_ALTERNATIVE_TYPES_H
> +
> +struct alt_instr {
> +	s32 orig_offset;	/* offset to original instruction */
> +	s32 alt_offset;		/* offset to replacement instruction */
> +	u16 cpufeature;		/* cpufeature bit set for replacement */
> +	u8  orig_len;		/* size of original instruction(s) */
> +	u8  alt_len;		/* size of new instruction(s), <= orig_len */
> +};
> +
> +#endif
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 74b9a26a84b5..652165c8655a 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -25,6 +25,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/kvm_host.h>
>  #include <linux/suspend.h>
> +#include <asm/alternative_types.h>
>  #include <asm/cpufeature.h>
>  #include <asm/thread_info.h>
>  #include <asm/memory.h>
> @@ -151,5 +152,8 @@ int main(void)
>    DEFINE(HIBERN_PBE_ADDR,	offsetof(struct pbe, address));
>    DEFINE(HIBERN_PBE_NEXT,	offsetof(struct pbe, next));
>    DEFINE(ARM64_FTR_SYSVAL,	offsetof(struct arm64_ftr_reg, sys_val));
> +  BLANK();
> +  DEFINE(ALTINSTR_ALIGN,	(63 - __builtin_clzl(__alignof__(struct alt_instr))));
> +
>    return 0;
>  }
> -- 
> 2.14.2
> 
