From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 23/23] arm64: Panic when VHE and non VHE CPUs coexist
Date: Mon, 8 Feb 2016 16:04:46 +0000
Message-ID: <20160208160445.GS6076@e104818-lin.cambridge.arm.com>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
 <1454522416-6874-24-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454522416-6874-24-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 03, 2016 at 06:00:16PM +0000, Marc Zyngier wrote:
> Having both VHE and non-VHE capable CPUs in the same system
> is likely to be a recipe for disaster.
> 
> If the boot CPU has VHE, but a secondary is not, we won't be
> able to downgrade and run the kernel at EL1. Add CPU hotplug
> to the mix, and this produces a terrifying mess.
> 
> Let's solve the problem once and for all. If you mix VHE and
> non-VHE CPUs in the same system, you deserve to loose, and this
> patch makes sure you don't get a chance.
> 
> This is implemented by storing the kernel execution level in
> a global variable. Secondaries will park themselves in a
> WFI loop if they observe a mismatch. Also, the primary CPU
> will detect that the secondary CPU has died on a mismatched
> execution level. Panic will follow.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/virt.h | 17 +++++++++++++++++
>  arch/arm64/kernel/head.S      | 20 ++++++++++++++++++++
>  arch/arm64/kernel/smp.c       |  3 +++
>  3 files changed, 40 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index 9f22dd6..f81a345 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -36,6 +36,11 @@
>   */
>  extern u32 __boot_cpu_mode[2];
>  
> +/*
> + * __run_cpu_mode records the mode the boot CPU uses for the kernel.
> + */
> +extern u32 __run_cpu_mode[2];
> +
>  void __hyp_set_vectors(phys_addr_t phys_vector_base);
>  phys_addr_t __hyp_get_vectors(void);
>  
> @@ -60,6 +65,18 @@ static inline bool is_kernel_in_hyp_mode(void)
>  	return el == CurrentEL_EL2;
>  }
>  
> +static inline bool is_kernel_mode_mismatched(void)
> +{
> +	/*
> +	 * A mismatched CPU will have written its own CurrentEL in
> +	 * __run_cpu_mode[1] (initially set to zero) after failing to
> +	 * match the value in __run_cpu_mode[0]. Thus, a non-zero
> +	 * value in __run_cpu_mode[1] is enough to detect the
> +	 * pathological case.
> +	 */
> +	return !!ACCESS_ONCE(__run_cpu_mode[1]);
> +}
> +
>  /* The section containing the hypervisor text */
>  extern char __hyp_text_start[];
>  extern char __hyp_text_end[];
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 6f2f377..f9b6a5b 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -578,7 +578,24 @@ ENTRY(set_cpu_boot_mode_flag)
>  1:	str	w20, [x1]			// This CPU has booted in EL1
>  	dmb	sy
>  	dc	ivac, x1			// Invalidate potentially stale cache line
> +	adr_l	x1, __run_cpu_mode
> +	ldr	w0, [x1]
> +	mrs	x20, CurrentEL
> +	cbz	x0, skip_el_check
> +	cmp	x0, x20
> +	bne	mismatched_el
>  	ret
> +skip_el_check:			// Only the first CPU gets to set the rule
> +	str	w20, [x1]
> +	dmb	sy
> +	dc	ivac, x1	// Invalidate potentially stale cache line
> +	ret
> +mismatched_el:
> +	str	w20, [x1, #4]
> +	dmb	sy
> +	dc	ivac, x1	// Invalidate potentially stale cache line
> +1:	wfi
> +	b	1b
>  ENDPROC(set_cpu_boot_mode_flag)

Do we need to wait for the D-cache maintenance completion before
entering WFI (like issuing a DSB)? Same for the skip_el_check path
before the RET.

Otherwise:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
