From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v11 08/19] arm64: fpsimd: Eliminate task->mm checks
Date: Fri, 25 May 2018 10:52:12 +0100
Message-ID: <20180525095211.GB13470@e103592.cambridge.arm.com>
References: <1527181008-13549-1-git-send-email-Dave.Martin@arm.com>
 <1527181008-13549-9-git-send-email-Dave.Martin@arm.com>
 <20180525090257.GB54529@C02W217FHV2R.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01DD849F7F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 05:41:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uM0s7SwqhD5W for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 May 2018 05:41:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD5C949F7E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 05:41:32 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180525090257.GB54529@C02W217FHV2R.local>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 25, 2018 at 11:02:57AM +0200, Christoffer Dall wrote:
> On Thu, May 24, 2018 at 05:56:37PM +0100, Dave Martin wrote:
> > Currently the FPSIMD handling code uses the condition task->mm ==
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
> > This patch removes the redundant checks and special-case code,                  ensuring that TIF_FOREIGN_FPSTATE is set whenever a kernel thread               is scheduled in, and ensures that this flag is set for the init
> > task.  The fpsimd_flush_task_state() call already present in
> > copy_thread() ensures the same for any new task.
> 
> nit: formatting still funny, but you shouldn't respin just for that.

Ah jeez... it was a long day.

I guess this isn't the end of the world, but I'll fix this in my branch
and point Marc at it.

> > 
> > With TIF_FOREIGN_FPSTATE always set for kernel threads, this patch
> > ensures that no extra context save work is added for kernel
> > threads, and eliminates the redundant context saving that may
> > currently occur for kernel threads that have acquired an mm via
> > use_mm().
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>

[...]

Thanks
---Dave
