From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 20/25] ACPI / APEI: Use separate fixmap pages for
 arm64 NMI-like notifications
Date: Thu, 31 Jan 2019 14:38:42 +0100
Message-ID: <20190131133842.GK6749@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-21-james.morse@arm.com>
 <20190121172743.GN29166@zn.tnic>
 <bee87ef4-60ae-d4a4-2855-159543072fc5@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F1C44A32D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 08:38:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e0XD08Ngkr5J for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 08:38:48 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A525A4A2B6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 08:38:48 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <bee87ef4-60ae-d4a4-2855-159543072fc5@arm.com>
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

On Wed, Jan 23, 2019 at 06:33:02PM +0000, James Morse wrote:
> Was the best I had, but this trips the BUILD_BUG() too early.
> With it, x86 BUILD_BUG()s. With just the -1 the path gets pruned out, and there
> are no 'sdei' symbols in the object file.
> 
> ...at this point, I stopped caring!

Yah, you said it: __end_of_fixed_addresses will practically give you the
BUG behavior:

        if (idx >= __end_of_fixed_addresses) {
                BUG();
                return;
        }

and ARM64 does the same.

> We already skip registering notifiers if the kconfig option wasn't selected.
> 
> We can't catch this at compile time, as the dead-code elimination seems to
> happen in multiple passes.
> 
> I'll switch the SDEI ones to __end_of_fixed_addresses, as both architectures
> BUG() when they see this.

Right.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
