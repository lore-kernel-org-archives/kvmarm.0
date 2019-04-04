From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 12/27] KVM: arm64/sve: System register context switch
 and access support
Date: Thu, 4 Apr 2019 10:59:09 +0200
Message-ID: <20190404085909.vqwvc33jhhj7g67p@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-13-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1553864452-15080-13-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 29, 2019 at 01:00:37PM +0000, Dave Martin wrote:
> This patch adds the necessary support for context switching ZCR_EL1
> for each vcpu.
> 
> ZCR_EL1 is trapped alongside the FPSIMD/SVE registers, so it makes
> sense for it to be handled as part of the guest FPSIMD/SVE context
> for context switch purposes instead of handling it as a general
> system register.  This means that it can be switched in lazily at
> the appropriate time.  No effort is made to track host context for
> this register, since SVE requires VHE: thus the hosts's value for
> this register lives permanently in ZCR_EL2 and does not alias the
> guest's value at any time.
> 
> The Hyp switch and fpsimd context handling code is extended
> appropriately.
> 
> Accessors are added in sys_regs.c to expose the SVE system
> registers and ID register fields.  Because these need to be
> conditionally visible based on the guest configuration, they are
> implemented separately for now rather than by use of the generic
> system register helpers.  This may be abstracted better later on
> when/if there are more features requiring this model.
> 
> ID_AA64ZFR0_EL1 is RO-RAZ for MRS/MSR when SVE is disabled for the
> guest, but for compatibility with non-SVE aware KVM implementations
> the register should not be enumerated at all for KVM_GET_REG_LIST
> in this case.  For consistency we also reject ioctl access to the
> register.  This ensures that a non-SVE-enabled guest looks the same
> to userspace, irrespective of whether the kernel KVM implementation
> supports SVE.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> 
> ---
> 
> Changes since v5:
> 
>  * Port to the renamed visibility() framework.
> 
>  * Swap visiblity() helpers so that they appear by the relevant accessor
>    functions.
> 
>  * [Julien Grall] With the visibility() checks, {get,set}_zcr_el1()
>    degenerate to doing exactly what the common code does, so drop them.
> 
>    The ID_AA64ZFR0_EL1 handlers are still needed to provide contitional
>    RAZ behaviour.  This could be moved to the common code too, but since
>    this is a one-off case I don't do this for now.  We can address this
>    later if other regs need to follow the same pattern.
> 
>  * [Julien Thierry] Reset ZCR_EL1 to a fixed value using reset_val
>    instead of using relying on reset_unknown() honouring set bits in val
>    as RES0.
> 
>    Most of the bits in ZCR_EL1 are RES0 anyway, and many implementations
>    of SVE will support larger vectors than 128 bits, so 0 seems as good
>    a value as any to expose guests that forget to initialise this
>    register properly.
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/include/asm/sysreg.h   |  3 ++
>  arch/arm64/kvm/fpsimd.c           |  9 ++++-
>  arch/arm64/kvm/hyp/switch.c       |  3 ++
>  arch/arm64/kvm/sys_regs.c         | 83 ++++++++++++++++++++++++++++++++++++---
>  5 files changed, 93 insertions(+), 6 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
