From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 4/6] arm64: mmu: map .text as read-only from the outset
Date: Tue, 7 Mar 2017 14:10:14 +0000
Message-ID: <20170307141014.GA3514@leverpostej>
References: <1488637848-13588-1-git-send-email-ard.biesheuvel@linaro.org>
 <1488637848-13588-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A866D40A74
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 09:09:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YRzNp4YX6bpu for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Mar 2017 09:09:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39CC040A6A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 09:09:08 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1488637848-13588-5-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, labbott@fedoraproject.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Mar 04, 2017 at 02:30:46PM +0000, Ard Biesheuvel wrote:
> Now that alternatives patching code no longer relies on the primary
> mapping of .text being writable, we can remove the code that removes
> the writable permissions post-init time, and map it read-only from
> the outset.
> 
> To preserve the existing behavior under rodata=off, which is relied
> upon by external debuggers to manage software breakpoints (as pointed
> out by Mark), add an early_param() check for rodata=, and use RWX
> permissions if it set to 'off'.
> 
> Reviewed-by: Laura Abbott <labbott@redhat.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/mm/mmu.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index df377fbe464e..edd982f88714 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -416,9 +416,6 @@ void mark_rodata_ro(void)
>  {
>  	unsigned long section_size;
>  
> -	section_size = (unsigned long)_etext - (unsigned long)_text;
> -	update_mapping_prot(__pa_symbol(_text), (unsigned long)_text,
> -			    section_size, PAGE_KERNEL_ROX);
>  	/*
>  	 * mark .rodata as read only. Use __init_begin rather than __end_rodata
>  	 * to cover NOTES and EXCEPTION_TABLE.
> @@ -451,6 +448,12 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
>  	vm_area_add_early(vma);
>  }
>  
> +static int __init parse_rodata(char *arg)
> +{
> +	return strtobool(arg, &rodata_enabled);
> +}
> +early_param("rodata", parse_rodata);
> +
>  /*
>   * Create fine-grained mappings for the kernel.
>   */
> @@ -458,7 +461,9 @@ static void __init map_kernel(pgd_t *pgd)
>  {
>  	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_init, vmlinux_data;
>  
> -	map_kernel_segment(pgd, _text, _etext, PAGE_KERNEL_EXEC, &vmlinux_text);
> +	pgprot_t text_prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
> +

It might be worth having a comment as to why, e.g.

	/*
	 * External debuggers may need to write directly to the text
	 * mapping to install SW breakpoints. Allow this (only) when
	 * explicitly requested with rodata=off.
	 */

... otherwise this looks fine. FWIW, either way:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

> +	map_kernel_segment(pgd, _text, _etext, text_prot, &vmlinux_text);
>  	map_kernel_segment(pgd, __start_rodata, __init_begin, PAGE_KERNEL, &vmlinux_rodata);
>  	map_kernel_segment(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC,
>  			   &vmlinux_init);
> -- 
> 2.7.4
> 
