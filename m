From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 05/25] ACPI / APEI: Make estatus pool allocation a
 static size
Date: Tue, 11 Dec 2018 17:54:14 +0100
Message-ID: <20181211165414.GJ27375@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-6-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 600A04A2E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 11:54:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RtBxUMKxEjsf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 11:54:18 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85CE84A1DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 11:54:18 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181203180613.228133-6-james.morse@arm.com>
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

On Mon, Dec 03, 2018 at 06:05:53PM +0000, James Morse wrote:
> Adding new NMI-like notifications duplicates the calls that grow
> and shrink the estatus pool. This is all pretty pointless, as the
> size is capped to 64K. Allocate this for each ghes and drop
> the code that grows and shrinks the pool.
> 
> Suggested-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  drivers/acpi/apei/ghes.c | 49 +++++-----------------------------------
>  drivers/acpi/apei/hest.c |  2 +-
>  include/acpi/ghes.h      |  2 +-
>  3 files changed, 8 insertions(+), 45 deletions(-)

Nice and simple, cool. Thanks for doing that.

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
