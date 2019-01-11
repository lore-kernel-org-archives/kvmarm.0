From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 09/25] ACPI / APEI: Generalise the estatus queue's
 notify code
Date: Fri, 11 Jan 2019 12:46:12 +0100
Message-ID: <20190111114612.GC4729@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-10-james.morse@arm.com>
 <20181211174449.GM27375@zn.tnic>
 <3f0f9005-f383-8a03-c7f9-15b50c099f94@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CC944A49E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jan 2019 06:46:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IxHjuLb-tAAk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jan 2019 06:46:22 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B1DF4A49C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jan 2019 06:46:22 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <3f0f9005-f383-8a03-c7f9-15b50c099f94@arm.com>
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

On Thu, Jan 10, 2019 at 06:21:21PM +0000, James Morse wrote:
> Something like:
> ghes_notify_nmi() -> in_nmi_spool_from_list(list) -> in_nmi_queue_one_entry(ghes).

Yah, but make that

ghes_notify_nmi() -> ghes_nmi_spool_from_list(list) -> ghes_nmi_queue_one_entry(ghes).

to denote it is the GHES NMI path.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
