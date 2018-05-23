From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v10 01/18] arm64: fpsimd: Fix TIF_FOREIGN_FPSTATE after
 invalidating cpu regs
Date: Wed, 23 May 2018 14:46:42 +0100
Message-ID: <20180523134642.tr4vvlvgpjbzxcwo@armageddon.cambridge.arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
 <1527005119-6842-2-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1527005119-6842-2-git-send-email-Dave.Martin@arm.com>
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
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 22, 2018 at 05:05:02PM +0100, Dave P Martin wrote:
> fpsimd_last_state.st is set to NULL as a way of indicating that
> current's FPSIMD registers are no longer loaded in the cpu.  In
> particular, this is done when the kernel temporarily uses or
> clobbers the FPSIMD registers for its own purposes, as in CPU PM or
> kernel-mode NEON, resulting in them being populated with garbage
> data not belonging to a task.
> 
> Commit 17eed27b02da ("arm64/sve: KVM: Prevent guests from using
> SVE") factors this operation out as a new helper
> fpsimd_flush_cpu_state() to make it clearer what is being done
> here, and on SVE systems this helper is now used, via
> kvm_fpsimd_flush_cpu_state(), to invalidate the registers after KVM
> has run a vcpu.  The reason for this is that KVM does not yet
> understand how to restore the full host SVE registers itself after
> loading the guest FPSIMD context into them.
> 
> This exposes a particular problem: if fpsimd_last_state.st is set
> to NULL without also setting TIF_FOREIGN_FPSTATE, the kernel may
> continue to think that current's FPSIMD registers are live even
> though they have actually been clobbered.
> 
> Prior to the aforementioned commit, the only path where
> fpsimd_last_state.st is set to NULL without setting
> TIF_FOREIGN_FPSTATE is when kernel_neon_begin() is called by a
> kernel thread (where current->mm can be NULL).  This does not
> matter, because the only harm is that at context-switch time
> fpsimd_thread_switch() may unnecessarily save the FPSIMD registers
> back to current's thread_struct (even though kernel threads are not
> considered to have any FPSIMD context of their own and the
> registers will never be reloaded).
> 
> Note that although CPU_PM_ENTER lacks the TIF_FOREIGN_FPSTATE
> setting, every CPU passing through that path must subsequently pass
> through CPU_PM_EXIT before it can re-enter the kernel proper.
> CPU_PM_EXIT sets the flag.
> 
> The sve_flush_cpu_state() function added by commit 17eed27b02da
> also lacks the proper maintenance of TIF_FOREIGN_FPSTATE.  This may
> cause the bits of a host task's SVE registers that do not alias the
> FPSIMD register file to spontaneously appear zeroed if a KVM vcpu
> runs in the same task in the meantime.  Although this effect is
> hidden by the fact that the non-FPSIMD bits of the SVE registers
> are zeroed by a syscall anyway, it is doubtless a bad idea to rely
> on these different code paths interacting correctly under future
> maintenance.
> 
> This patch makes TIF_FOREIGN_FPSTATE an unconditional side-effect
> of fpsimd_flush_cpu_state(), and removes the set_thread_flag()
> calls that become redunant as a result.  This ensures that
> TIF_FOREIGN_FPSTATE cannot remain clear if the FPSIMD state in the
> FPSIMD registers is invalid.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
