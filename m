From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 04/18] ACPI / APEI: Switch NOTIFY_SEA to use the
 estatus queue
Date: Fri, 28 Sep 2018 19:04:46 +0200
Message-ID: <20180928170446.GE20768@zn.tnic>
References: <20180921221705.6478-1-james.morse@arm.com>
 <20180921221705.6478-5-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC8F34A0CC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 13:04:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hEplBTSkBHNn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Sep 2018 13:04:46 -0400 (EDT)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B76C49F86
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 13:04:46 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180921221705.6478-5-james.morse@arm.com>
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

On Fri, Sep 21, 2018 at 11:16:51PM +0100, James Morse wrote:
> Now that the estatus queue can be used by more than one notification
> method, we can move notifications that have NMI-like behaviour over to
> it, and start abstracting GHES's single in_nmi() path.
> 
> Switch NOTIFY_SEA over to use the estatus queue. This makes it behave
> in the same way as x86's NOTIFY_NMI.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
> Tested-by: Tyler Baicar <tbaicar@codeaurora.org>
> ---
>  drivers/acpi/apei/ghes.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index d7c46236b353..150fb184c7cb 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -58,6 +58,10 @@
>  
>  #define GHES_PFX	"GHES: "
>  
> +#if defined(CONFIG_HAVE_ACPI_APEI_NMI) || defined(CONFIG_ACPI_APEI_SEA)
> +#define WANT_NMI_ESTATUS_QUEUE	1
> +#endif

Is that just so that you have shorter ifdeffery lines? Because if so, an
additional level of indirection is silly. Or maybe there's more coming -
I'll see when I continue going through this set. :)

Otherwise looks good - trying to reuse the facilities and all. Better. :)

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
