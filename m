From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v3 08/20] arm64: entry.S: convert elX_irq
Date: Wed, 11 Oct 2017 18:13:01 +0100
Message-ID: <ae8a4e66-0a07-3e1a-9ac9-adf8b6b60b06@arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
 <20171005191812.5678-9-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 922E749D43
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 13:12:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UPzmTGW5Kguj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Oct 2017 13:12:22 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72B7149D3A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 13:12:22 -0400 (EDT)
In-Reply-To: <20171005191812.5678-9-james.morse@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, wangxiongfeng2@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 05/10/17 20:18, James Morse wrote:
> Following our 'dai' order, irqs should be processed with debug and
> serror exceptions unmasked.
>  > Add a helper to unmask these two, (and fiq for good measure).
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>   arch/arm64/include/asm/assembler.h | 4 ++++
>   arch/arm64/kernel/entry.S          | 4 ++--
>   2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index c2a37e2f733c..7ffb2a629dc9 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -54,6 +54,10 @@
>   	msr	daif, \tmp
>   	.endm
>   
> +	.macro enable_da_f
> +	msr	daifclr, #(8 | 4 | 1)
> +	.endm
> +

We use this in irq entries because we are inheriting daif + we want to 
disable irqs while we process irqs right?

I don't know if it's worth adding a comment but I find it easier to 
think about it like this.

Otherwise, for patches 3 to 8 (I don't have any comment on 3 to 7):
Reviewed-by: Julien Thierry <julien.thierry@arm.com>

>   /*
>    * Enable and disable interrupts.
>    */
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index f7dfe5d2b1fb..df085ec003b0 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -557,7 +557,7 @@ ENDPROC(el1_sync)
>   	.align	6
>   el1_irq:
>   	kernel_entry 1
> -	enable_dbg
> +	enable_da_f
>   #ifdef CONFIG_TRACE_IRQFLAGS
>   	bl	trace_hardirqs_off
>   #endif
> @@ -766,7 +766,7 @@ ENDPROC(el0_sync)
>   el0_irq:
>   	kernel_entry 0
>   el0_irq_naked:
> -	enable_dbg
> +	enable_da_f
>   #ifdef CONFIG_TRACE_IRQFLAGS
>   	bl	trace_hardirqs_off
>   #endif
> 

-- 
Julien Thierry
