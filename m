From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 00/18] APEI in_nmi() rework
Date: Thu, 4 Oct 2018 17:15:55 +0200
Message-ID: <20181004151555.GN1864@zn.tnic>
References: <20180921221705.6478-1-james.morse@arm.com>
 <20180925124526.GD23986@zn.tnic>
 <c04d1b78-122b-d7f2-5a75-3d9c56386b11@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D3324A1E1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Oct 2018 11:16:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5CxY9yygQhPX for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Oct 2018 11:15:58 -0400 (EDT)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BECBB4A1D7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Oct 2018 11:15:58 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <c04d1b78-122b-d7f2-5a75-3d9c56386b11@arm.com>
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

On Wed, Oct 03, 2018 at 06:50:38PM +0100, James Morse wrote:

...

> The non-ghes HEST entries have a "number of records to pre-allocate" too, we
> could make this memory pool something hest.c looks after, but I can't see if the
> other error sources use those values.

Thanks for the detailed analysis!

> Hmmm, The size is capped to 64K, we could ignore the firmware description of the
> memory requirements, and allocate SZ_64K each time. Doing it per-GHES is still
> the only way to avoid allocating nmi-safe memory for irqs.

Right, so I'm thinking a lot simpler: allocate a pool which should
be large enough to handle all situations and drop all that logic
which recomputes and reallocates pool size. Just a static thing which
JustWorks(tm).

For a couple of reasons:

 - you state it above: all those synchronization issues are gone with a
 prellocated pool

 - 64K per-GHES pool is nothing if you consider the machines this thing
 runs on - fat servers with lotsa memory. And RAS there *is* important.
 And TBH 64K is nothing even on a small client sporting gigabytes of
 memory.

 - code is a lot simpler and cleaner - you don't need all that pool
 expanding and shrinking. I mean, I'm all for smarter solutions if they
 have any clear advantages warranting the complication but this is a
 lot of machinery just so that we can save a couple of KBs. Which, as a
 whole, sounds just too much to me.

But this is just me.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
