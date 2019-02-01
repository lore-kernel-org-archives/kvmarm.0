From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v8 04/26] ACPI / APEI: Make hest.c manage the estatus
 memory pool
Date: Fri, 1 Feb 2019 14:20:46 +0100
Message-ID: <20190201132046.GH31854@zn.tnic>
References: <20190129184902.102850-1-james.morse@arm.com>
 <20190129184902.102850-5-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 832B94A32D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 08:20:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6-8gu+PAwhvn for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Feb 2019 08:20:58 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 427C04A319
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 08:20:58 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190129184902.102850-5-james.morse@arm.com>
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

On Tue, Jan 29, 2019 at 06:48:40PM +0000, James Morse wrote:
> ghes.c has a memory pool it uses for the estatus cache and the estatus
> queue. The cache is initialised when registering the platform driver.
> For the queue, an NMI-like notification has to grow/shrink the pool
> as it is registered and unregistered.
> 
> This is all pretty noisy when adding new NMI-like notifications, it
> would be better to replace this with a static pool size based on the
> number of users.
> 
> As a precursor, move the call that creates the pool from ghes_init(),
> into hest.c. Later this will take the number of ghes entries and
> consolidate the queue allocations.
> Remove ghes_estatus_pool_exit() as hest.c doesn't have anywhere to put
> this.
> 
> The pool is now initialised as part of ACPI's subsys_initcall():
> (acpi_init(), acpi_scan_init(), acpi_pci_root_init(), acpi_hest_init())
> Before this patch it happened later as a GHES specific device_initcall().
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
> Changes since v7:
> * Moved the pool init later, the driver isn't probed until device_init.
> ---
>  drivers/acpi/apei/ghes.c | 33 ++++++---------------------------
>  drivers/acpi/apei/hest.c | 10 +++++++++-
>  include/acpi/ghes.h      |  2 ++
>  3 files changed, 17 insertions(+), 28 deletions(-)

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
