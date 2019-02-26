From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 02/26] arm64: fpsimd: Always set TIF_FOREIGN_FPSTATE
 on task state flush
Date: Tue, 26 Feb 2019 12:06:02 +0000
Message-ID: <20190226120601.GF3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-3-git-send-email-Dave.Martin@arm.com>
 <7e358d11-4896-1f09-0496-70a78eb60736@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <7e358d11-4896-1f09-0496-70a78eb60736@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Julien Grall <julien.grall@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 21, 2019 at 12:39:39PM +0000, Julien Grall wrote:
> Hi Dave,
> =

> On 18/02/2019 19:52, Dave Martin wrote:
> >This patch updates fpsimd_flush_task_state() to mirror the new
> >semantics of fpsimd_flush_cpu_state() introduced by commit
> >d8ad71fa38a9 ("arm64: fpsimd: Fix TIF_FOREIGN_FPSTATE after
> >invalidating cpu regs").  Both functions now implicitly set
> =

> NIT: Double-space before "Both"
> =

> >TIF_FOREIGN_FPSTATE to indicate that the task's FPSIMD state is not
> >loaded into the cpu.
> >
> >As a side-effect, fpsimd_flush_task_state() now sets
> >TIF_FOREIGN_FPSTATE even for non-running tasks.  In the case of
> =

> NIT: Double sppace before "In".
> =

> >non-running tasks this is not useful but also harmless, because the
> >flag is live only while the corresponding task is running.  This
> >function is not called from fast paths, so special-casing this for
> >the task =3D=3D current case is not really worth it.
> >
> >Compiler barriers previously present in restore_sve_fpsimd_context()
> >are pulled into fpsimd_flush_task_state() so that it can be safely
> >called with preemption enabled if necessary.
> >
> >Explicit calls to set TIF_FOREIGN_FPSTATE that accompany
> >fpsimd_flush_task_state() calls and are now redundant are removed
> >as appropriate.
> >
> >fpsimd_flush_task_state() is used to get exclusive access to the
> >representation of the task's state via task_struct, for the purpose
> >of replacing the state.  Thus, the call to this function should
> =

> NIT: Double-space before "Thus".
> =

> >happen before manipulating fpsimd_state or sve_state etc. in
> >task_struct.  Anomalous cases are reordered appropriately in order
> =

> NIT: Double-space before "Anomalous".

A habit rather than a mistake [1], and I don't propose to change it ;)


> >to make the code more consistent, although there should be no
> >functional difference since these cases are protected by
> >local_bh_disable() anyway.
> >
> >Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> >Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> Reviewed-by: Julien Grall <julien.grall@arm.com>

Thanks for the review
--Dave


[1] https://en.wikipedia.org/wiki/Sentence_spacing

Interestingly around 11% of commits in mainline appear to follow the
two-space convention for their commit messages.  I won't speculate as
to why...

$ git log --oneline --grep=3D'[a-z]\.  [A-Z]' | wc -l
94638
$ git log --oneline | wc -l
812542
