From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 08/16] KVM: arm64: Optimise FPSIMD handling to reduce
 guest/host thrashing
Date: Thu, 10 May 2018 17:44:30 +0100
Message-ID: <20180510164430.ura3th2fxwwot6be@armageddon.cambridge.arm.com>
References: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
 <1525882385-29181-9-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1525882385-29181-9-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 09, 2018 at 05:12:57PM +0100, Dave P Martin wrote:
> This patch refactors KVM to align the host and guest FPSIMD
> save/restore logic with each other for arm64.  This reduces the
> number of redundant save/restore operations that must occur, and
> reduces the common-case IRQ blackout time during guest exit storms
> by saving the host state lazily and optimising away the need to
> restore the host state before returning to the run loop.
> 
> Four hooks are defined in order to enable this:
> 
>  * kvm_arch_vcpu_run_map_fp():
>    Called on PID change to map necessary bits of current to Hyp.
> 
>  * kvm_arch_vcpu_load_fp():
>    Set up FP/SIMD for entering the KVM run loop (parse as
>    "vcpu_load fp").
> 
>  * kvm_arch_vcpu_ctxsync_fp():
>    Get FP/SIMD into a safe state for re-enabling interrupts after a
>    guest exit back to the run loop.
> 
>    For arm64 specifically, this involves updating the host kernel's
>    FPSIMD context tracking metadata so that kernel-mode NEON use
>    will cause the vcpu's FPSIMD state to be saved back correctly
>    into the vcpu struct.  This must be done before re-enabling
>    interrupts because kernel-mode NEON may be used by softirqs.
> 
>  * kvm_arch_vcpu_put_fp():
>    Save guest FP/SIMD state back to memory and dissociate from the
>    CPU ("vcpu_put fp").
> 
> Also, the arm64 FPSIMD context switch code is updated to enable it
> to save back FPSIMD state for a vcpu, not just current.  A few
> helpers drive this:
> 
>  * fpsimd_bind_state_to_cpu(struct user_fpsimd_state *fp):
>    mark this CPU as having context fp (which may belong to a vcpu)
>    currently loaded in its registers.  This is the non-task
>    equivalent of the static function fpsimd_bind_to_cpu() in
>    fpsimd.c.
> 
>  * task_fpsimd_save():
>    exported to allow KVM to save the guest's FPSIMD state back to
>    memory on exit from the run loop.
> 
>  * fpsimd_flush_state():
>    invalidate any context's FPSIMD state that is currently loaded.
>    Used to disassociate the vcpu from the CPU regs on run loop exit.
> 
> These changes allow the run loop to enable interrupts (and thus
> softirqs that may use kernel-mode NEON) without having to save the
> guest's FPSIMD state eagerly.
> 
> Some new vcpu_arch fields are added to make all this work.  Because
> host FPSIMD state can now be saved back directly into current's
> thread_struct as appropriate, host_cpu_context is no longer used
> for preserving the FPSIMD state.  However, it is still needed for
> preserving other things such as the host's system registers.  To
> avoid ABI churn, the redundant storage space in host_cpu_context is
> not removed for now.
> 
> arch/arm is not addressed by this patch and continues to use its
> current save/restore logic.  It could provide implementations of
> the helpers later if desired.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
