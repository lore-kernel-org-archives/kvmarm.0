From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 11/25] ACPI / APEI: Move NOTIFY_SEA between the
 estatus-queue and NOTIFY_NMI
Date: Mon, 21 Jan 2019 14:01:11 +0100
Message-ID: <20190121130111.GG29166@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-12-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC5E54A376
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 08:01:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ay2wZs+gEnz9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jan 2019 08:01:20 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A7034A321
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 08:01:20 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181203180613.228133-12-james.morse@arm.com>
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

On Mon, Dec 03, 2018 at 06:05:59PM +0000, James Morse wrote:
> The estatus-queue code is currently hidden by the NOTIFY_NMI #ifdefs.
> Once NOTIFY_SEA starts using the estatus-queue we can stop hiding
> it as each architecture has a user that can't be turned off.
> 
> Split the existing CONFIG_HAVE_ACPI_APEI_NMI block in two, and move
> the SEA code into the gap.
> 
> This patch moves code around ... and changes the stale comment

s/This patch moves/Move the/

> describing why the status queue is necessary: printk() is no
> longer the issue, its the helpers like memory_failure_queue() that
> aren't nmi safe.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  drivers/acpi/apei/ghes.c | 113 ++++++++++++++++++++-------------------
>  1 file changed, 59 insertions(+), 54 deletions(-)

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
