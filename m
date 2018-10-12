From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 11/18] ACPI / APEI: Remove silent flag from
 ghes_read_estatus()
Date: Fri, 12 Oct 2018 18:55:53 +0200
Message-ID: <20181012165553.GE580@zn.tnic>
References: <20180921221705.6478-1-james.morse@arm.com>
 <20180921221705.6478-12-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 138E849E4C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Oct 2018 12:56:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M4p7b-la51oL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Oct 2018 12:56:00 -0400 (EDT)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 371DE40A6E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Oct 2018 12:56:00 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180921221705.6478-12-james.morse@arm.com>
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
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 21, 2018 at 11:16:58PM +0100, James Morse wrote:
> Subsequent patches will split up ghes_read_estatus(), at which
> point passing around the 'silent' flag gets annoying. This is to
> suppress prink() messages, which prior to 42a0bb3f7138 ("printk/nmi:
> generic solution for safe printk in NMI"), were unsafe in NMI context.

Put that commit onto a separate line:

"... which prior to

  42a0bb3f7138 ("printk/nmi: generic solution for safe printk in NMI")

were unsafe ..."

This way it is immediately visible.

In any case, this patch looks like a cleanup so move it to the beginning
of the queue, I'd say.

> We don't need to do this anymore, remove the flag. printk() messages
> are batched in a per-cpu buffer and printed via irq-work, or a call
> back from panic().
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  drivers/acpi/apei/ghes.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 586689cbc0fd..ba5344d26a39 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -300,7 +300,7 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
>  
>  static int ghes_read_estatus(struct ghes *ghes,
>  			     struct acpi_hest_generic_status *estatus,
> -			     int silent, int fixmap_idx)
> +			     int fixmap_idx)
>  {
>  	struct acpi_hest_generic *g = ghes->generic;
>  	u64 buf_paddr;
> @@ -309,7 +309,7 @@ static int ghes_read_estatus(struct ghes *ghes,
>  
>  	rc = apei_read(&buf_paddr, &g->error_status_address);
>  	if (rc) {
> -		if (!silent && printk_ratelimit())
> +		if (printk_ratelimit())

Btw, checkpatch complains here:

WARNING: Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit
#57: FILE: drivers/acpi/apei/ghes.c:312:
+               if (printk_ratelimit())

WARNING: Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit
#66: FILE: drivers/acpi/apei/ghes.c:345:
+       if (rc && printk_ratelimit())


-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
