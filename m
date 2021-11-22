Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54504C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Nov 2021 14:57:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA3364B0C5;
	Mon, 22 Nov 2021 09:57:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id diKccFuGIMVE; Mon, 22 Nov 2021 09:57:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 990754B105;
	Mon, 22 Nov 2021 09:57:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC19B4B0C5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 09:57:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HN0uxWG+-IsP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Nov 2021 09:57:40 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E91914B0BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 09:57:39 -0500 (EST)
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com
 [66.24.58.225])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 873866054E;
 Mon, 22 Nov 2021 14:57:37 +0000 (UTC)
Date: Mon, 22 Nov 2021 09:57:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: Re: [RFC PATCH 1/2] arm64/tracing: add cntvct based trace clock
Message-ID: <20211122095735.2340f38f@gandalf.local.home>
In-Reply-To: <20211119102117.22304-2-nsaenzju@redhat.com>
References: <20211119102117.22304-1-nsaenzju@redhat.com>
 <20211119102117.22304-2-nsaenzju@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, will@kernel.org,
 maz@kernel.org, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
 mingo@redhat.com, catalin.marinas@arm.com, nilal@redhat.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, 19 Nov 2021 11:21:17 +0100
Nicolas Saenz Julienne <nsaenzju@redhat.com> wrote:

> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_ARM64_TRACE_CLOCK_H
> +#define _ASM_ARM64_TRACE_CLOCK_H
> +
> +#include <linux/types.h>
> +
> +extern u64 notrace trace_clock_arm64_cntvct(void);
> +
> +# define ARCH_TRACE_CLOCKS \
> +	{ trace_clock_arm64_cntvct, "cntvct", .in_ns = 0 },
> +
> +#endif  /* _ASM_ARM64_TRACE_CLOCK_H */

So this will appear as a usable clock in trace-cmd.

And since this will be used to synchronize between host and guest like the
x86_tsc is used, that means that trace-cmd needs to know that this is the
an arch "CPU" clock. I wonder if we should rename x86_clock (or at least
make it an alias) to "kvm_clock". Then we can have trace-cmd use
"kvm_clock" as the clock for synchronization between host and guests for
all architectures?

Thinking about this, instead of renaming it, I'll add code to create an
alias to these clocks. Then every arch can pick what clock is used that is
the same between hosts and guests such that user space tooling doesn't have
to keep a database of what clocks are used for synchronization between
hosts and guests for each arch.

I'll go add some code ;-)

-- Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
