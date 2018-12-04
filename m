From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 02/25] ACPI / APEI: Remove silent flag from
 ghes_read_estatus()
Date: Tue, 4 Dec 2018 12:36:01 +0100
Message-ID: <20181204113601.GB11803@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-3-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93C894A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:36:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BchgVALcaRZZ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 06:36:09 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B5D349F94
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:36:09 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181203180613.228133-3-james.morse@arm.com>
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

On Mon, Dec 03, 2018 at 06:05:50PM +0000, James Morse wrote:
> Subsequent patches will split up ghes_read_estatus(), at which
> point passing around the 'silent' flag gets annoying. This is to
> suppress prink() messages, which prior to commit 42a0bb3f7138
> ("printk/nmi: generic solution for safe printk in NMI"), were
> unsafe in NMI context.
> 
> This is no longer necessary, remove the flag. printk() messages
> are batched in a per-cpu buffer and printed via irq-work, or a call
> back from panic().
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
> Changes since v6:
>  * Moved earlier in the series,
>  * Tinkered with the commit message.
>  * switched to pr_warn_ratelimited() to shut checkpatch up
> 
> shutup checkpatch
> ---
>  drivers/acpi/apei/ghes.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
