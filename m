Received: from out-11.mta1.migadu.com (out-11.mta1.migadu.com [95.215.58.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D421FDA
	for <kvmarm@lists.linux.dev>; Thu,  1 Jun 2023 06:34:25 +0000 (UTC)
Date: Thu, 1 Jun 2023 06:34:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685601263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TNu8g5bcDjZLGCC9IYSQGhuaint+Q0+//GNY41I3lck=;
	b=jiKBhEg36dfZ0tMGeUWlUzrZH3jH1dCulsgQVikqwMbAPVcbUJrnMLPIdy7rdPOece0T3F
	jiw2kbJoC1cUPbMje7zmXnRGi9b4GEpbVPOnHZ7JS1tQ5cqoJvxT4sUWL3Us6HyP3C7UNL
	h031D4V6S7UQkRknAgT4rG+YicgMvOs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 06/17] arm64: Allow EL1 physical timer access when
 running VHE
Message-ID: <ZHg76wizp5RSXTLG@linux.dev>
References: <20230526143348.4072074-1-maz@kernel.org>
 <20230526143348.4072074-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526143348.4072074-7-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Fri, May 26, 2023 at 03:33:37PM +0100, Marc Zyngier wrote:
> To initialise the timer access from EL2 when HCR_EL2.E2H is set,
> we must make use the CNTHCTL_EL2 formap used is appropriate.
> 
> This amounts to shifting the timer/counter enable bits by 10
> to the left.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/el2_setup.h | 5 +++++
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S | 9 +++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index 037724b19c5c..225bf1f2514d 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -34,6 +34,11 @@
>   */
>  .macro __init_el2_timers
>  	mov	x0, #3				// Enable EL1 physical timers
> +	mrs	x1, hcr_el2
> +	and	x1, x1, #HCR_E2H
> +	cbz	x1, .LnVHE_\@
> +	lsl	x0, x0, #10
> +.LnVHE_\@:
>  	msr	cnthctl_el2, x0
>  	msr	cntvoff_el2, xzr		// Clear virtual offset
>  .endm
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index a6d67c2bb5ae..f9ee10e29497 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -95,6 +95,15 @@ SYM_CODE_START_LOCAL(___kvm_hyp_init)
>  	ldr	x1, [x0, #NVHE_INIT_HCR_EL2]
>  	msr	hcr_el2, x1
>  
> +	mov	x2, #HCR_E2H
> +	and	x2, x1, x2
> +	cbz	x2, 1f
> +
> +	mrs	x1, cnthctl_el2
> +	and	x1, x1, #~(BIT(0) | BIT(1))
> +	orr	x1, x1, #(BIT(10) | BIT(11))
> +	msr	cnthctl_el2, x1
> +1:

Can this be done with an alternative block keyed on ARM64_KVM_HVHE?
I get that __init_el2_timers needs to run before the cpu caps have been
evaluated, but I don't think the same applies for ___kvm_hyp_init

-- 
Thanks,
Oliver
