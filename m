From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 10/25] ACPI / APEI: Tell firmware the estatus queue
 consumed the records
Date: Fri, 11 Jan 2019 21:01:08 +0100
Message-ID: <20190111200108.GB11723@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-11-james.morse@arm.com>
 <20181211183634.GO27375@zn.tnic>
 <56cfa16b-ece4-76e0-3799-58201f8a4ff1@arm.com>
 <CABo9ajArdbYMOBGPRa185yo9MnKRb0pgS-pHqUNdNS9m+kKO-Q@mail.gmail.com>
 <20190111120322.GD4729@zn.tnic>
 <CABo9ajAk5XNBmNHRRfUb-dQzW7-UOs5826jPkrVz-8zrtMUYkg@mail.gmail.com>
 <0939c14d-de58-f21d-57a6-89bdce3bcb44@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F4AB4A49B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jan 2019 15:01:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JWwkq4OWsVJE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jan 2019 15:01:13 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CA8E4A47C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jan 2019 15:01:13 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <0939c14d-de58-f21d-57a6-89bdce3bcb44@arm.com>
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <baicar.tyler@gmail.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 11, 2019 at 06:09:28PM +0000, James Morse wrote:
> We can return on ENOENT out earlier, as nothing needs doing in that case. Its
> what the GHES_TO_CLEAR spaghetti is for, we can probably move the ack thing into
> ghes_clear_estatus(), that way that thing means 'I'm done with this memory'.

That actually sounds nice and other code in the kernel already does
that: when a failure has been encountered during reading status, you
free up resources right then and there. No need for passing retvals back
and forth. And this would simplify the spaghetti. Which is something
good(tm) on its own!

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
