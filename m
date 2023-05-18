Received: from out-21.mta1.migadu.com (out-21.mta1.migadu.com [95.215.58.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD89753A8
	for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 16:06:37 +0000 (UTC)
Date: Thu, 18 May 2023 18:06:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684425995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KHGguFp+orUyyeGUiq903ZvHKiCDRzmx4cH7McznNKM=;
	b=JMei6YcyuQd3irjiVZHAGYMGwYB+IjxvE5FJo/Sx6/SIggPXHwYhBj0EdK/Mfnw/RhnCCO
	pPSk8cqV5Vdvgc0F5IC73wDo08rrzdIZv4gGJxMTQPOxs/hOWTfWDne1Htkzt14wOZsGtM
	u/8a98qcafuwA0fIA+jAo3nXBMYskAs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, luc.maranget@inria.fr
Subject: Re: [kvm-unit-tests PATCH] arm64: Make vector_table and vector_stub
 weak symbols
Message-ID: <20230518-d8bd66e7bf671f5df706a216@orel>
References: <20230515221517.646549-1-nikos.nikoleris@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515221517.646549-1-nikos.nikoleris@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, May 15, 2023 at 11:15:17PM +0100, Nikos Nikoleris wrote:
> This changes allows a test to define and override the declared symbols,
> taking control of the whole vector_table or a vector_stub.

Hi Nikos,

Can you add some motivation for this change to the commit message or
submit it along with some test that needs it?

Thanks,
drew

> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  arm/cstart64.S | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index e4ab7d06..eda0daa5 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -275,8 +275,11 @@ exceptions_init:
>  /*
>   * Vector stubs
>   * Adapted from arch/arm64/kernel/entry.S
> + * Declare as weak to allow external tests to redefine and override a
> + * vector_stub.
>   */
>  .macro vector_stub, name, vec
> +.weak \name
>  \name:
>  	stp	 x0,  x1, [sp, #-S_FRAME_SIZE]!
>  	stp	 x2,  x3, [sp,  #16]
> @@ -369,7 +372,13 @@ vector_stub	el0_error_32, 15
>  	b	\label
>  .endm
>  
> +
> +/*
> + * Declare as weak to allow external tests to redefine and override the
> + * default vector table.
> + */
>  .align 11
> +.weak vector_table
>  vector_table:
>  	ventry	el1t_sync			// Synchronous EL1t
>  	ventry	el1t_irq			// IRQ EL1t
> -- 
> 2.25.1
> 
