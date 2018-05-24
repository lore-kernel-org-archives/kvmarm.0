From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v10 07/18] arm64: fpsimd: Eliminate task->mm checks
Date: Thu, 24 May 2018 10:33:50 +0200
Message-ID: <20180524083350.GK55598@C02W217FHV2R.local>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
 <1527005119-6842-8-git-send-email-Dave.Martin@arm.com>
 <20180523114812.GH55598@C02W217FHV2R.local>
 <20180523133158.GJ13470@e103592.cambridge.arm.com>
 <20180523145657.g7b6v2q2vxfqpoc4@armageddon.cambridge.arm.com>
 <20180523150337.GO13470@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16D114A0E2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 04:23:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZKPKDR4CI9sR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 May 2018 04:23:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7433A49F94
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 04:23:12 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180523150337.GO13470@e103592.cambridge.arm.com>
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
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 23, 2018 at 04:03:37PM +0100, Dave Martin wrote:
> On Wed, May 23, 2018 at 03:56:57PM +0100, Catalin Marinas wrote:
> > On Wed, May 23, 2018 at 02:31:59PM +0100, Dave P Martin wrote:
> > > On Wed, May 23, 2018 at 01:48:12PM +0200, Christoffer Dall wrote:
> > > > On Tue, May 22, 2018 at 05:05:08PM +0100, Dave Martin wrote:
> > > > > This is true by construction however: TIF_FOREIGN_FPSTATE is never
> > > > > cleared except when returning to userspace or returning from a
> > > > > signal: thus, for a true kernel thread no FPSIMD context is ever
> > > > > loaded, TIF_FOREIGN_FPSTATE will remain set and no context will
> > > > > ever be saved.
> > > > 
> > > > I don't understand this construction proof; from looking at the patch
> > > > below it is not obvious to me why fpsimd_thread_switch() can never have
> > > > !wrong_task && !wrong_cpu and therefore clear TIF_FOREIGN_FPSTATE for a
> > > > kernel thread?
> > > 
> > > Looking at this again, I think it is poorly worded.  This patch aims to
> > > make it true by construction, but it isn't prior to the patch.
> > > 
> > > I'm tempted to delete the paragraph: the assertion of both untrue and
> > > not the best way to justify that this patch works.
> > > 
> > > 
> > > How about:
> > > 
> > > -8<-
> > > 
> > > The context switch logic already isolates user threads from each other.
> > > This, it is sufficient for isolating user threads from the kernel,

s/This/Thus/ ?

I don't understand what 'it' refers to here?

> > > since the goal either way is to ensure that code executing in userspace
> > > cannot see any FPSIMD state except its own.  Thus, there is no special
> > > property of kernel threads that we care about except that it is
> > > pointless to save or load FPSIMD register state for them.

Actually, I'm not really sure what this paragraph is getting at.

> > > 
> > > At worst, the removal of all the kernel thread special cases by this
> > > patch would thus spuriously load and save state for kernel threads when
> > > unnecessary.
> > > 
> > > But the context switch logic is already deliberately optimised to defer
> > > reloads of the regs until ret_to_user (or sigreturn as a special case),
> > > which kernel threads by definition never reach.
> > > 
> > > ->8-
> > 
> > The "at worst" paragraph makes it look like it could happen (at least
> > until you reach the last paragraph). Maybe you can just say that
> > wrong_task and wrong_cpu (with the fpsimd_cpu = NR_CPUS addition) are
> > always true for kernel threads. You should probably mention this in a
> > comment in the code as well.
> 
> What if I just delete the second paragraph, and remove the "But" from
> the start of the third, and append:
> 
> "As a result, the wrong_task and wrong_cpu tests in
> fpsimd_thread_switch() will always yield false for kernel threads."
> 
> ...with a similar comment in the code?

...with a risk of being a bit over-pedantic and annoying, may I suggest
the following complete commit text:

------8<------
Currently the FPSIMD handling code uses the condition task->mm ==
NULL as a hint that task has no FPSIMD register context.

The ->mm check is only there to filter out tasks that cannot
possibly have FPSIMD context loaded, for optimisation purposes.
However, TIF_FOREIGN_FPSTATE must always be checked anyway before
saving FPSIMD context back to memory.  For this reason, the ->mm
checks are not useful, providing that that TIF_FOREIGN_FPSTATE is
maintained properly for kernel threads.

FPSIMD context is never preserved for kernel threads across a context
switch and therefore TIF_FOREIGN_FPSTATE should always be true for
kernel threads.  This is indeed the case, as the wrong_task and
wrong_cpu tests in fpsimd_thread_switch() will always yield false for
kernel threads.

Further, the context switch logic is already deliberately optimised to
defer reloads of the FPSIMD context until ret_to_user (or sigreturn as a
special case), which kernel threads by definition never reach, and
therefore this change introduces no additional work in the critical
path.

This patch removes the redundant checks and special-case code.
------8<------

Thanks,
-Christoffer
