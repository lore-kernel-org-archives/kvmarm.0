From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v10 07/18] arm64: fpsimd: Eliminate task->mm checks
Date: Wed, 23 May 2018 16:03:37 +0100
Message-ID: <20180523150337.GO13470@e103592.cambridge.arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
 <1527005119-6842-8-git-send-email-Dave.Martin@arm.com>
 <20180523114812.GH55598@C02W217FHV2R.local>
 <20180523133158.GJ13470@e103592.cambridge.arm.com>
 <20180523145657.g7b6v2q2vxfqpoc4@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180523145657.g7b6v2q2vxfqpoc4@armageddon.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 23, 2018 at 03:56:57PM +0100, Catalin Marinas wrote:
> On Wed, May 23, 2018 at 02:31:59PM +0100, Dave P Martin wrote:
> > On Wed, May 23, 2018 at 01:48:12PM +0200, Christoffer Dall wrote:
> > > On Tue, May 22, 2018 at 05:05:08PM +0100, Dave Martin wrote:
> > > > This is true by construction however: TIF_FOREIGN_FPSTATE is never
> > > > cleared except when returning to userspace or returning from a
> > > > signal: thus, for a true kernel thread no FPSIMD context is ever
> > > > loaded, TIF_FOREIGN_FPSTATE will remain set and no context will
> > > > ever be saved.
> > > 
> > > I don't understand this construction proof; from looking at the patch
> > > below it is not obvious to me why fpsimd_thread_switch() can never have
> > > !wrong_task && !wrong_cpu and therefore clear TIF_FOREIGN_FPSTATE for a
> > > kernel thread?
> > 
> > Looking at this again, I think it is poorly worded.  This patch aims to
> > make it true by construction, but it isn't prior to the patch.
> > 
> > I'm tempted to delete the paragraph: the assertion of both untrue and
> > not the best way to justify that this patch works.
> > 
> > 
> > How about:
> > 
> > -8<-
> > 
> > The context switch logic already isolates user threads from each other.
> > This, it is sufficient for isolating user threads from the kernel,
> > since the goal either way is to ensure that code executing in userspace
> > cannot see any FPSIMD state except its own.  Thus, there is no special
> > property of kernel threads that we care about except that it is
> > pointless to save or load FPSIMD register state for them.
> > 
> > At worst, the removal of all the kernel thread special cases by this
> > patch would thus spuriously load and save state for kernel threads when
> > unnecessary.
> > 
> > But the context switch logic is already deliberately optimised to defer
> > reloads of the regs until ret_to_user (or sigreturn as a special case),
> > which kernel threads by definition never reach.
> > 
> > ->8-
> 
> The "at worst" paragraph makes it look like it could happen (at least
> until you reach the last paragraph). Maybe you can just say that
> wrong_task and wrong_cpu (with the fpsimd_cpu = NR_CPUS addition) are
> always true for kernel threads. You should probably mention this in a
> comment in the code as well.

What if I just delete the second paragraph, and remove the "But" from
the start of the third, and append:

"As a result, the wrong_task and wrong_cpu tests in
fpsimd_thread_switch() will always yield false for kernel threads."

...with a similar comment in the code?

Cheers
---Dave
