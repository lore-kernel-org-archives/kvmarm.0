From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 08/18] ACPI / APEI: Move locking to the notification
 helper
Date: Fri, 12 Oct 2018 13:08:19 +0200
Message-ID: <20181012110819.GB580@zn.tnic>
References: <20180921221705.6478-1-james.morse@arm.com>
 <20180921221705.6478-9-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 814C84A1E1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Oct 2018 07:08:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bCAHRc2fUzoJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Oct 2018 07:08:32 -0400 (EDT)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8BCC04A0C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Oct 2018 07:08:32 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180921221705.6478-9-james.morse@arm.com>
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

On Fri, Sep 21, 2018 at 11:16:55PM +0100, James Morse wrote:
> ghes_copy_tofrom_phys() takes different locks depending on in_nmi().
> This doesn't work when we have multiple NMI-like notifications, that
> can interrupt each other.
> 
> Now that NOTIFY_SEA is always called as an NMI, move the lock-taking
> to the notification helper. The helper will always know which lock
> to take. This avoids ghes_copy_tofrom_phys() taking a guess based
> on in_nmi().
> 
> This splits NOTIFY_NMI and NOTIFY_SEA to use different locks. All
> the other notifications use ghes_proc(), and are called in process
> or IRQ context. Move the spin_lock_irqsave() around their ghes_proc()
> calls.

Right, should ghes_proc() be renamed to ghes_proc_irq() now, to be
absolutely clear on the processing context it is operating in?

Other than that:

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
