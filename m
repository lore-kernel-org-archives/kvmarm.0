From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 05/18] ACPI / APEI: Make estatus queue a Kconfig symbol
Date: Mon, 1 Oct 2018 19:59:56 +0200
Message-ID: <20181001175956.GF7269@zn.tnic>
References: <20180921221705.6478-1-james.morse@arm.com>
 <20180921221705.6478-6-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9414949E3E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Oct 2018 13:59:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9kDC0ZriRm-O for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Oct 2018 13:59:56 -0400 (EDT)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79FDB40A67
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Oct 2018 13:59:56 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180921221705.6478-6-james.morse@arm.com>
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

On Fri, Sep 21, 2018 at 11:16:52PM +0100, James Morse wrote:
> Now that there are two users of the estatus queue, and likely to be more,
> make it a Kconfig symbol selected by the appropriate notification. We
> can move the ARCH_HAVE_NMI_SAFE_CMPXCHG checks in here too.

Ok, question: why do we need to complicate things at all? I mean, why do
we even need a Kconfig symbol?

This code is being used by two arches now so why not simply build it in
unconditionally and be done with it. The couple of KB saved are simply
not worth the effort, especially if it is going to end up being enabled
on 99% of the setups...

Or?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
