From: Adam Wallis <awallis@codeaurora.org>
Subject: Re: [PATCH v4 10/21] arm64: entry.S: move SError handling into a C
 function for future expansion
Date: Tue, 2 Jan 2018 16:07:05 -0500
Message-ID: <b99e7738-f8dd-26bf-a050-f970c2f8d03b@codeaurora.org>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-11-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A686340D25
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jan 2018 16:02:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DeASvVgZQtaK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Jan 2018 16:02:46 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7821B406D0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jan 2018 16:02:46 -0500 (EST)
In-Reply-To: <20171019145807.23251-11-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, Wang Xiongfeng <wangxiongfengi2@huawei.com>, wangxiongfeng2@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

James

On 10/19/2017 10:57 AM, James Morse wrote:
[..]
>  	kernel_ventry	el1_fiq_invalid			// FIQ EL1h
> -	kernel_ventry	el1_error_invalid		// Error EL1h
> +	kernel_ventry	el1_error			// Error EL1h
>  
>  	kernel_ventry	el0_sync			// Synchronous 64-bit EL0
>  	kernel_ventry	el0_irq				// IRQ 64-bit EL0
>  	kernel_ventry	el0_fiq_invalid			// FIQ 64-bit EL0
> -	kernel_ventry	el0_error_invalid		// Error 64-bit EL0
> +	kernel_ventry	el0_error			// Error 64-bit EL0
>  
>  #ifdef CONFIG_COMPAT
>  	kernel_ventry	el0_sync_compat			// Synchronous 32-bit EL0
>  	kernel_ventry	el0_irq_compat			// IRQ 32-bit EL0
>  	kernel_ventry	el0_fiq_invalid_compat		// FIQ 32-bit EL0
> -	kernel_ventry	el0_error_invalid_compat	// Error 32-bit EL0
> +	kernel_ventry	el0_error_compat		// Error 32-bit EL0
>  #else
>  	kernel_ventry	el0_sync_invalid		// Synchronous 32-bit EL0
>  	kernel_ventry	el0_irq_invalid			// IRQ 32-bit EL0
> @@ -455,10 +455,6 @@ ENDPROC(el0_error_invalid)
>  el0_fiq_invalid_compat:
>  	inv_entry 0, BAD_FIQ, 32
>  ENDPROC(el0_fiq_invalid_compat)
> -
> -el0_error_invalid_compat:
> -	inv_entry 0, BAD_ERROR, 32
> -ENDPROC(el0_error_invalid_compat)
>  #endif

Perhaps I missed something quite obvious, but is there any reason to not also
remove el1_error_invalid, since SError handling now jumps to el1_error?

>  el1_sync_invalid:
> @@ -663,6 +659,10 @@ el0_svc_compat:
>  el0_irq_compat:
>  	kernel_entry 0, 32
>  	b	el0_irq_naked
> +
> +el0_error_compat:
> +	kernel_entry 0, 32
> +	b	el0_error_naked
>  #endif
>  
>  el0_da:
> @@ -780,6 +780,28 @@ el0_irq_naked:
>  	b	ret_to_user
>  ENDPROC(el0_irq)
>  
> +el1_error:
> +	kernel_entry 1
> +	mrs	x1, esr_el1
> +	enable_dbg
> +	mov	x0, sp
> +	bl	do_serror
> +	kernel_exit 1
> +ENDPROC(el1_error)
> +
> +el0_error:
> +	kernel_entry 0
> +el0_error_naked:
> +	mrs	x1, esr_el1
> +	enable_dbg
> +	mov	x0, sp
> +	bl	do_serror
> +	enable_daif
> +	ct_user_exit
> +	b	ret_to_user
> +ENDPROC(el0_error)
[..]
Thanks

Adam

-- 
Adam Wallis
Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
