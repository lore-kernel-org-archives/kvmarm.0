From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v11 02/19] thread_info: Add update_thread_flag() helpers
Date: Thu, 24 May 2018 19:02:09 +0200
Message-ID: <20180524170209.GK12198@hirez.programming.kicks-ass.net>
References: <1527181008-13549-1-git-send-email-Dave.Martin@arm.com>
 <1527181008-13549-3-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF3CB401CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 12:55:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2QkwV7GXuDB9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 May 2018 12:54:58 -0400 (EDT)
Received: from merlin.infradead.org (merlin.infradead.org [205.233.59.134])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEB454A101
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 12:51:34 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1527181008-13549-3-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 24, 2018 at 05:56:31PM +0100, Dave Martin wrote:
> There are a number of bits of code sprinkled around the kernel to
> set a thread flag if a certain condition is true, and clear it
> otherwise.
> =

> To help make those call sites terser and less cumbersome, this
> patch adds a new family of thread flag manipulators
> =

> 	update*_thread_flag([...,] flag, cond)
> =

> which do the equivalent of:
> =

> 	if (cond)
> 		set*_thread_flag([...,] flag);
> 	else
> 		clear*_thread_flag([...,] flag);
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@redhat.com>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
