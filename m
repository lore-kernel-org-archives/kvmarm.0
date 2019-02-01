From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v8 18/26] ACPI / APEI: Make GHES estatus header
 validation more user friendly
Date: Fri, 1 Feb 2019 15:30:40 +0100
Message-ID: <20190201143040.GJ31854@zn.tnic>
References: <20190129184902.102850-1-james.morse@arm.com>
 <20190129184902.102850-19-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA5554A332
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 09:30:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rx7uU1GdiXJC for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Feb 2019 09:30:51 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BEB1D4A319
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 09:30:51 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190129184902.102850-19-james.morse@arm.com>
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 29, 2019 at 06:48:54PM +0000, James Morse wrote:
> ghes_read_estatus() checks various lengths in the top-level header to
> ensure the CPER records to be read aren't obviously corrupt.
> 
> Take the opportunity to make this more user-friendly, printing a
> (ratelimited) message about the nature of the header format error.
> 
> Suggested-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  drivers/acpi/apei/ghes.c | 46 ++++++++++++++++++++++++++++------------
>  1 file changed, 32 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index f95db2398dd5..9391fff71344 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -293,6 +293,30 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
>  	}
>  }
>  
> +/* Check the top-level record header has an appropriate size. */
> +int __ghes_check_estatus(struct ghes *ghes,

static.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
