From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 22/25] ACPI / APEI: Kick the memory_failure() queue
 for synchronous errors
Date: Tue, 22 Jan 2019 11:51:43 +0100
Message-ID: <20190122105143.GB26587@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-23-james.morse@arm.com>
 <9d153a07-aa7a-6e0c-3bd3-994a66f9639a@huawei.com>
 <5c775aa9-ea57-dea7-6083-c1e3fc160b29@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDC084A387
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 05:51:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q4XRQMmX97hX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jan 2019 05:51:50 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D535C4A382
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 05:51:50 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <5c775aa9-ea57-dea7-6083-c1e3fc160b29@arm.com>
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-acpi@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Wang Xiongfeng <wangxiongfeng2@huawei.com>, linux-mm@kvack.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 10, 2018 at 07:15:13PM +0000, James Morse wrote:
> What happens if we miss MF_ACTION_REQUIRED?

AFAICU, the logic is to force-send a signal to the user process, i.e.,
force_sig_info() which cannot be ignored. IOW, an "enlightened" process
would know how to do recovery action from a memory error.

VS the action optional thing which you can handle at your leisure.

So the question boils down to what kind of severity do the errors
reported through SEA have? I mean, if the hw would go the trouble to do
the synchronous reporting, then something important must've happened and
it wants us to know about it and handle it.

> Surely the page still gets unmapped as its PG_Poisoned, an AO signal
> may be pending, but if user-space touches the page it will get an AR
> signal. Is this just about removing an extra AO signal to user-space?
>
> If we do need this, I'd like to pick it up from the CPER records, as x86's
> NOTIFY_NMI looks like it covers both AO/AR cases. (as does NOTIFY_SDEI). The
> Master/Target abort or Invalid-address types in the memory-error-section CPER
> records look like the best bet.

Right, and we do all kinds of severity mapping there aka ghes_severity()
so that'll be a good start, methinks.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
