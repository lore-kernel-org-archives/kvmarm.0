From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 11/28] arm64/sve: Core task context handling
Date: Fri, 27 Oct 2017 13:45:51 +0100
Message-ID: <20171027124550.hul2skr5uxxwidbr@armageddon.cambridge.arm.com>
References: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
 <1509101470-7881-12-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6838541185
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 08:44:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rysO1lN47bLo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 08:44:31 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F365E40D25
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 08:44:30 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1509101470-7881-12-git-send-email-Dave.Martin@arm.com>
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
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 27, 2017 at 11:50:53AM +0100, Dave P Martin wrote:
> This patch adds the core support for switching and managing the SVE
> architectural state of user tasks.
> =

> Calls to the existing FPSIMD low-level save/restore functions are
> factored out as new functions task_fpsimd_{save,load}(), since SVE
> now dynamically may or may not need to be handled at these points
> depending on the kernel configuration, hardware features discovered
> at boot, and the runtime state of the task.  To make these
> decisions as fast as possible, const cpucaps are used where
> feasible, via the system_supports_sve() helper.
> =

> The SVE registers are only tracked for threads that have explicitly
> used SVE, indicated by the new thread flag TIF_SVE.  Otherwise, the
> FPSIMD view of the architectural state is stored in
> thread.fpsimd_state as usual.
> =

> When in use, the SVE registers are not stored directly in
> thread_struct due to their potentially large and variable size.
> Because the task_struct slab allocator must be configured very
> early during kernel boot, it is also tricky to configure it
> correctly to match the maximum vector length provided by the
> hardware, since this depends on examining secondary CPUs as well as
> the primary.  Instead, a pointer sve_state in thread_struct points
> to a dynamically allocated buffer containing the SVE register data,
> and code is added to allocate and free this buffer at appropriate
> times.
> =

> TIF_SVE is set when taking an SVE access trap from userspace, if
> suitable hardware support has been detected.  This enables SVE for
> the thread: a subsequent return to userspace will disable the trap
> accordingly.  If such a trap is taken without sufficient system-
> wide hardware support, SIGILL is sent to the thread instead as if
> an undefined instruction had been executed: this may happen if
> userspace tries to use SVE in a system where not all CPUs support
> it for example.
> =

> The kernel will clear TIF_SVE and disable SVE for the thread
> whenever an explicit syscall is made by userspace.  For backwards
> compatibility reasons and conformance with the spirit of the base
> AArch64 procedure call standard, the subset of the SVE register
> state that aliases the FPSIMD registers is still preserved across a
> syscall even if this happens.  The remainder of the SVE register
> state logically becomes zero at syscall entry, though the actual
> zeroing work is currently deferred until the thread next tries to
> use SVE, causing another trap to the kernel.  This implementation
> is suboptimal: in the future, the fastpath case may be optimised
> to zero the registers in-place and leave SVE enabled for the task,
> where beneficial.
> =

> TIF_SVE is also cleared in the following slowpath cases, which are
> taken as reasonable hints that the task may no longer use SVE:
>  * exec
>  * fork and clone
> =

> Code is added to sync data between thread.fpsimd_state and
> thread.sve_state whenever enabling/disabling SVE, in a manner
> consistent with the SVE architectural programmer's model.
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Alex Benn=E9e <alex.bennee@linaro.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
