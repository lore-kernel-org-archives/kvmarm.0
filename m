From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 20/25] ACPI / APEI: Use separate fixmap pages for
 arm64 NMI-like notifications
Date: Mon, 21 Jan 2019 18:27:43 +0100
Message-ID: <20190121172743.GN29166@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-21-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7EB04A38A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 12:27:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x3RfQEm371SI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jan 2019 12:27:47 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1E844A332
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 12:27:46 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181203180613.228133-21-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 03, 2018 at 06:06:08PM +0000, James Morse wrote:
> Now that ghes notification helpers provide the fixmap slots and
> take the lock themselves, multiple NMI-like notifications can
> be used on arm64.
> 
> These should be named after their notification method as they can't
> all be called 'NMI'. x86's NOTIFY_NMI already is, change the SEA
> fixmap entry to be called FIX_APEI_GHES_SEA.
> 
> Future patches can add support for FIX_APEI_GHES_SEI and
> FIX_APEI_GHES_SDEI_{NORMAL,CRITICAL}.
> 
> Because all of ghes.c builds on both architectures, provide a
> constant for each fixmap entry that the architecture will never
> use.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> 
> ---
> Changes since v6:
>  * Added #ifdef definitions of each missing fixmap entry.
> 
> Changes since v3:
>  * idx/lock are now in a separate struct.
>  * Add to the comment above ghes_fixmap_lock_irq so that it makes more
>    sense in isolation.
> 
> fixup for split fixmap
> ---
>  arch/arm64/include/asm/fixmap.h |  2 +-
>  drivers/acpi/apei/ghes.c        | 10 +++++++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
> index ec1e6d6fa14c..966dd4bb23f2 100644
> --- a/arch/arm64/include/asm/fixmap.h
> +++ b/arch/arm64/include/asm/fixmap.h
> @@ -55,7 +55,7 @@ enum fixed_addresses {
>  #ifdef CONFIG_ACPI_APEI_GHES
>  	/* Used for GHES mapping from assorted contexts */
>  	FIX_APEI_GHES_IRQ,
> -	FIX_APEI_GHES_NMI,
> +	FIX_APEI_GHES_SEA,
>  #endif /* CONFIG_ACPI_APEI_GHES */
>  
>  #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 849da0d43a21..6cbf9471b2a2 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -85,6 +85,14 @@
>  	((struct acpi_hest_generic_status *)				\
>  	 ((struct ghes_estatus_node *)(estatus_node) + 1))
>  
> +/* NMI-like notifications vary by architecture. Fill in the fixmap gaps */
> +#ifndef CONFIG_HAVE_ACPI_APEI_NMI
> +#define FIX_APEI_GHES_NMI	-1
> +#endif
> +#ifndef CONFIG_ACPI_APEI_SEA
> +#define FIX_APEI_GHES_SEA	-1

I'm guessing those -1 are going to cause __set_fixmap() to fail, right?

I'm wondering if we could catch that situation in ghes_map() already to
protect ourselves against future changes in the fixmap code...

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
