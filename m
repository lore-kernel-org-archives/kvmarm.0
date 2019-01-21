From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 19/25] ACPI / APEI: Only use queued estatus entry
 during _in_nmi_notify_one()
Date: Mon, 21 Jan 2019 18:19:10 +0100
Message-ID: <20190121171910.GM29166@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-20-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE0E74A382
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 12:19:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0ki0T5v5T7tT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jan 2019 12:19:14 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3F444A332
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 12:19:13 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181203180613.228133-20-james.morse@arm.com>
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

On Mon, Dec 03, 2018 at 06:06:07PM +0000, James Morse wrote:
> Each struct ghes has an worst-case sized buffer for storing the
> estatus. If an error is being processed by ghes_proc() in process
> context this buffer will be in use. If the error source then triggers
> an NMI-like notification, the same buffer will be used by
> _in_nmi_notify_one() to stage the estatus data, before
> __process_error() copys it into a queued estatus entry.
> 
> Merge __process_error()s work into _in_nmi_notify_one() so that
> the queued estatus entry is used from the beginning. Use the new
> ghes_peek_estatus() to know how much memory to allocate from
> the ghes_estatus_pool before reading the records.
> 
> Reported-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: James Morse <james.morse@arm.com>
> 
> Change since v6:
>  * Added a comment explaining the 'ack-error, then goto no_work'.
>  * Added missing esatus-clearing, which is necessary after reading the GAS,
> ---
>  drivers/acpi/apei/ghes.c | 59 ++++++++++++++++++++++++----------------
>  1 file changed, 35 insertions(+), 24 deletions(-)

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
