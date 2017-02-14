From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 4/5] arm64: mmu: map .text as read-only from the outset
Date: Tue, 14 Feb 2017 15:57:05 +0000
Message-ID: <20170214155704.GE23718@leverpostej>
References: <1486844586-26135-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486844586-26135-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00D3E40187
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 10:56:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tlE+MqswTqK1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Feb 2017 10:56:31 -0500 (EST)
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr50089.outbound.protection.outlook.com [40.107.5.89])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C611E400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 10:56:30 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1486844586-26135-5-git-send-email-ard.biesheuvel@linaro.org>
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

On Sat, Feb 11, 2017 at 08:23:05PM +0000, Ard Biesheuvel wrote:
> Now that alternatives patching code no longer relies on the primary
> mapping of .text being writable, we can remove the code that removes
> the writable permissions post-init time, and map it read-only from
> the outset.
> 
> Reviewed-by: Laura Abbott <labbott@redhat.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This generally looks good.

One effect of this is that even with rodata=off, external debuggers
can't install SW breakpoints via the executable mapping.

We might want to allow that to be overridden. e.g. make rodata= an
early param, and switch the permissions based on that in map_kernel(),
e.g. have:

	pgprot_t text_prot = rodata_enabled ? PAGE_KERNEL_ROX
					    : PAGE_KERNEL_EXEC);

... and use that for .text and .init.text by default.

Thanks,
Mark.

> ---
>  arch/arm64/mm/mmu.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 7ed981c7f4c0..e97f1ce967ec 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -442,9 +442,6 @@ void mark_rodata_ro(void)
>  {
>  	unsigned long section_size;
>  
> -	section_size = (unsigned long)_etext - (unsigned long)_text;
> -	create_mapping_late(__pa_symbol(_text), (unsigned long)_text,
> -			    section_size, PAGE_KERNEL_ROX);
>  	/*
>  	 * mark .rodata as read only. Use __init_begin rather than __end_rodata
>  	 * to cover NOTES and EXCEPTION_TABLE.
> @@ -484,7 +481,7 @@ static void __init map_kernel(pgd_t *pgd)
>  {
>  	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_init, vmlinux_data;
>  
> -	map_kernel_segment(pgd, _text, _etext, PAGE_KERNEL_EXEC, &vmlinux_text);
> +	map_kernel_segment(pgd, _text, _etext, PAGE_KERNEL_ROX, &vmlinux_text);
>  	map_kernel_segment(pgd, __start_rodata, __init_begin, PAGE_KERNEL, &vmlinux_rodata);
>  	map_kernel_segment(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC,
>  			   &vmlinux_init);
> -- 
> 2.7.4
> 
