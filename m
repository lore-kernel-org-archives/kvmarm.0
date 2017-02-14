From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 5/5] arm64: mmu: apply strict permissions to
 .init.text and .init.data
Date: Tue, 14 Feb 2017 15:57:27 +0000
Message-ID: <20170214155727.GF23718@leverpostej>
References: <1486844586-26135-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486844586-26135-6-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42E7140A7B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 10:56:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2fl6iyIxZLbb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Feb 2017 10:56:52 -0500 (EST)
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01on0045.outbound.protection.outlook.com [104.47.1.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B6A3400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 10:56:51 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1486844586-26135-6-git-send-email-ard.biesheuvel@linaro.org>
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
Cc: keescook@chromium.org, marc.zyngier@arm.com, catalin.marinas@arm.com, kernel-hardening@lists.openwall.com, will.deacon@arm.com, andre.przywara@arm.com, nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, labbott@fedoraproject.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Feb 11, 2017 at 08:23:06PM +0000, Ard Biesheuvel wrote:
> To avoid having mappings that are writable and executable at the same
> time, split the init region into a .init.text region that is mapped
> read-only, and a .init.data region that is mapped non-executable.
> 
> This is possible now that the alternative patching occurs via the linear
> mapping, and the linear alias of the init region is always mapped writable
> (but never executable).
> 
> Since the alternatives descriptions themselves are read-only data, move
> those into the .init.text region.
> 
> Reviewed-by: Laura Abbott <labbott@redhat.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This generally looks good.

As with my comment on patch 4, we might want to allow .init.text to be
mapped writeable for the sake of external debuggers.

Thanks,
Mark.

> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index e97f1ce967ec..c53c43b4ed3f 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -479,12 +479,16 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
>   */
>  static void __init map_kernel(pgd_t *pgd)
>  {
> -	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_init, vmlinux_data;
> +	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_inittext,
> +				vmlinux_initdata, vmlinux_data;
>  
>  	map_kernel_segment(pgd, _text, _etext, PAGE_KERNEL_ROX, &vmlinux_text);
> -	map_kernel_segment(pgd, __start_rodata, __init_begin, PAGE_KERNEL, &vmlinux_rodata);
> -	map_kernel_segment(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC,
> -			   &vmlinux_init);
> +	map_kernel_segment(pgd, __start_rodata, __inittext_begin, PAGE_KERNEL,
> +			   &vmlinux_rodata);
> +	map_kernel_segment(pgd, __inittext_begin, __inittext_end, PAGE_KERNEL_ROX,
> +			   &vmlinux_inittext);
> +	map_kernel_segment(pgd, __initdata_begin, __initdata_end, PAGE_KERNEL,
> +			   &vmlinux_initdata);
>  	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data);
>  
>  	if (!pgd_val(*pgd_offset_raw(pgd, FIXADDR_START))) {
> -- 
> 2.7.4
> 
