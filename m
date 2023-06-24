Received: from out-49.mta0.migadu.com (out-49.mta0.migadu.com [91.218.175.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C198820F2
	for <kvmarm@lists.linux.dev>; Sat, 24 Jun 2023 10:18:31 +0000 (UTC)
Date: Sat, 24 Jun 2023 12:18:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687601909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9paM0IXeN8Es0mZ9N31eHxIOiO36IiFBTqHVRWg9yIw=;
	b=KrO1NcdN4ow0Zdd/ZSSKHmMd/AKO6mMBrKQ2KWDQCwFZHhiiSLbIst1OZ4Nna0hKf1GzHi
	wCRIIMIgsQXgVzCHN7FNvMn6bgUz9Vd9IjCr57RzFtUlu1YVTh+/TsmSgFNbeVX5PATfW0
	6/XEUfeSeNVD4DkFtl/UfMSkA0nRjs4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Nadav Amit <namit@vmware.com>
Subject: Re: [kvm-unit-tests PATCH 4/6] arm64: stack: update trace stack on
 exception
Message-ID: <20230624-25ca6a39aec469a817e45422@orel>
References: <20230617014930.2070-1-namit@vmware.com>
 <20230617014930.2070-5-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230617014930.2070-5-namit@vmware.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 17, 2023 at 01:49:28AM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Using gdb for backtracing or dumping the stack following an exception is
> not very helpful as the exact location of the exception is not saved.
> 
> Add an additional frame to save the location of the exception.
> 
> One delicate point is dealing with the pretty_print_stacks script. When
> the stack is dumped, the script would not print the right address for
> the exception address: for every return address it deducts "1" before
> looking for the instruction location in the code (using addr2line). As a
> somewhat hacky solution add "1" for the exception address when dumping
> the stack.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  arm/cstart64.S          | 13 +++++++++++++
>  lib/arm64/asm-offsets.c |  3 ++-
>  lib/arm64/stack.c       | 16 ++++++++++++++++
>  3 files changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index cbd6b51..61e27d3 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -314,6 +314,13 @@ exceptions_init:
>  	mrs	x2, spsr_el1
>  	stp	x1, x2, [sp, #S_PC]
>  
> +	/*
> +	 * Save a frame pointer using the link to allow unwinding of
> +	 * exceptions.
> +	 */
> +	stp	x29, x1, [sp, #S_FP]
> +	add 	x29, sp, #S_FP
> +
>  	mov	x0, \vec
>  	mov	x1, sp
>  	mrs	x2, esr_el1
> @@ -349,6 +356,9 @@ exceptions_init:
>  	eret
>  .endm
>  
> +vector_stub_start:
> +.globl vector_stub_start

nit: I'd prefer the .globl directives above the labels to match the
rest of the file.

> +
>  vector_stub	el1t_sync,     0
>  vector_stub	el1t_irq,      1
>  vector_stub	el1t_fiq,      2
> @@ -369,6 +379,9 @@ vector_stub	el0_irq_32,   13
>  vector_stub	el0_fiq_32,   14
>  vector_stub	el0_error_32, 15
>  
> +vector_stub_end:
> +.globl vector_stub_end
> +
>  .section .text.ex
>  
>  .macro ventry, label
> diff --git a/lib/arm64/asm-offsets.c b/lib/arm64/asm-offsets.c
> index 53a1277..7b8bffb 100644
> --- a/lib/arm64/asm-offsets.c
> +++ b/lib/arm64/asm-offsets.c
> @@ -25,6 +25,7 @@ int main(void)
>  	OFFSET(S_PSTATE, pt_regs, pstate);
>  	OFFSET(S_ORIG_X0, pt_regs, orig_x0);
>  	OFFSET(S_SYSCALLNO, pt_regs, syscallno);
> -	DEFINE(S_FRAME_SIZE, sizeof(struct pt_regs));
> +	DEFINE(S_FRAME_SIZE, (sizeof(struct pt_regs) + 16));
> +	DEFINE(S_FP, sizeof(struct pt_regs));

It'd be good to comment this, something like

  ...
  OFFSET(S_ORIG_X0, pt_regs, orig_x0);
  OFFSET(S_SYSCALLNO, pt_regs, syscallno);

  /* FP and LR (16 bytes) go on the frame above pt_regs */
  DEFINE(S_FP, sizeof(struct pt_regs));
  DEFINE(S_FRAME_SIZE, (sizeof(struct pt_regs) + 16));

  return 0;

>  	return 0;
>  }
> diff --git a/lib/arm64/stack.c b/lib/arm64/stack.c
> index 1e2568a..a48ecbb 100644
> --- a/lib/arm64/stack.c
> +++ b/lib/arm64/stack.c
> @@ -12,6 +12,8 @@ int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
>  	const void *fp = frame;
>  	void *lr;
>  	int depth;
> +	bool is_exception = false;
> +	unsigned long addr;
>  
>  	/*
>  	 * ARM64 stack grows down. fp points to the previous fp on the stack,
> @@ -25,6 +27,20 @@ int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
>  				  : );
>  
>  		return_addrs[depth] = lr;
> +
> +		/*
> +		 * If this is an exception, add 1 to the pointer so when the
> +		 * pretty_print_stacks script is run it would get the right
> +		 * address (it deducts 1 to find the call address, but we want
> +		 * the actual address).
> +		 */
> +		if (is_exception)
> +			return_addrs[depth] += 1;
> +
> +		/* Check if we are in the exception handlers for the next entry */
> +		addr = (unsigned long)lr;
> +		is_exception = (addr >= (unsigned long)&vector_stub_start &&
> +				addr < (unsigned long)&vector_stub_end);
>  	}
>  
>  	return depth;
> -- 
> 2.34.1
>

Thanks,
drew
