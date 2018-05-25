From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v11 08/19] arm64: fpsimd: Eliminate task->mm checks
Date: Fri, 25 May 2018 11:48:04 +0100
Message-ID: <20180525104803.GC13470@e103592.cambridge.arm.com>
References: <1527181008-13549-1-git-send-email-Dave.Martin@arm.com>
 <1527181008-13549-9-git-send-email-Dave.Martin@arm.com>
 <87r2m0rqzw.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <87r2m0rqzw.fsf@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 25, 2018 at 11:04:03AM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > Currently the FPSIMD handling code uses the condition task->mm =3D=3D
> > NULL as a hint that task has no FPSIMD register context.
> >
> > The ->mm check is only there to filter out tasks that cannot
> > possibly have FPSIMD context loaded, for optimisation purposes.
> > Also, TIF_FOREIGN_FPSTATE must always be checked anyway before
> > saving FPSIMD context back to memory.  For these reasons, the ->mm
> > checks are not useful, providing that TIF_FOREIGN_FPSTATE is
> > maintained in a consistent way for all threads.
> >
> > The context switch logic is already deliberately optimised to defer
> > reloads of the regs until ret_to_user (or sigreturn as a special
> > case), and save them only if they have been previously loaded.
> > These paths are the only places where the wrong_task and wrong_cpu
> > conditions can be made false, by calling fpsimd_bind_task_to_cpu().
> > Kernel threads by definition never reach these paths.  As a result,
> > the wrong_task and wrong_cpu tests in fpsimd_thread_switch() will
> > always yield true for kernel threads.
> >
> > This patch removes the redundant checks and special-case code,         =
         ensuring that TIF_FOREIGN_FPSTATE is set whenever a kernel thread =
              is scheduled in, and ensures that this flag is set for the in=
it
> > task.  The fpsimd_flush_task_state() call already present in
> > copy_thread() ensures the same for any new task.
> >
> > With TIF_FOREIGN_FPSTATE always set for kernel threads, this patch
> > ensures that no extra context save work is added for kernel
> > threads, and eliminates the redundant context saving that may
> > currently occur for kernel threads that have acquired an mm via
> > use_mm().
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> Still good (although obviously without the ws damage in the commit).

Agreed -- I'll coordinate with Marc to make sure that gets fixed.

Thanks for the review.

[...]

Cheers
---Dave
