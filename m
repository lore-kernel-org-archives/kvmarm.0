From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v4 28/40] KVM: arm64: Defer saving/restoring 64-bit
 sysregs to vcpu load/put on VHE
Date: Thu, 22 Feb 2018 18:30:11 +0000
Message-ID: <ece29cf2-4c60-dc3d-b2a9-e7e06380f860@arm.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-29-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180215210332.8648-29-christoffer.dall@linaro.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 15/02/18 21:03, Christoffer Dall wrote:
> Some system registers do not affect the host kernel's execution and can
> therefore be loaded when we are about to run a VCPU and we don't have to
> restore the host state to the hardware before the time when we are
> actually about to return to userspace or schedule out the VCPU thread.
> 
> The EL1 system registers and the userspace state registers only
> affecting EL0 execution do not need to be saved and restored on every
> switch between the VM and the host, because they don't affect the host
> kernel's execution.
> 
> We mark all registers which are now deffered as such in the

NIT: s/deffered/deferred/ I think.

> vcpu_{read,write}_sys_reg accessors in sys-regs.c to ensure the most
> up-to-date copy is always accessed.
> 
> Note MPIDR_EL1 (controlled via VMPIDR_EL2) is accessed from other vcpu
> threads, for example via the GIC emulation, and therefore must be
> declared as immediate, which is fine as the guest cannot modify this
> value.
> 
> The 32-bit sysregs can also be deferred but we do this in a separate
> patch as it requires a bit more infrastructure.


[...]

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b3c3f014aa61..f060309337aa 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -87,6 +87,26 @@ u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg)
>   	 * exit from the guest but are only saved on vcpu_put.
>   	 */
>   	switch (reg) {
> +	case CSSELR_EL1:	return read_sysreg_s(SYS_CSSELR_EL1);
> +	case SCTLR_EL1:		return read_sysreg_s(sctlr_EL12);
> +	case ACTLR_EL1:		return read_sysreg_s(SYS_ACTLR_EL1);
> +	case CPACR_EL1:		return read_sysreg_s(cpacr_EL12);
> +	case TTBR0_EL1:		return read_sysreg_s(ttbr0_EL12);
> +	case TTBR1_EL1:		return read_sysreg_s(ttbr1_EL12);
> +	case TCR_EL1:		return read_sysreg_s(tcr_EL12);
> +	case ESR_EL1:		return read_sysreg_s(esr_EL12);
> +	case AFSR0_EL1:		return read_sysreg_s(afsr0_EL12);
> +	case AFSR1_EL1:		return read_sysreg_s(afsr1_EL12);
> +	case FAR_EL1:		return read_sysreg_s(far_EL12);
> +	case MAIR_EL1:		return read_sysreg_s(mair_EL12);
> +	case VBAR_EL1:		return read_sysreg_s(vbar_EL12);
> +	case CONTEXTIDR_EL1:	return read_sysreg_s(contextidr_EL12);
> +	case TPIDR_EL0:		return read_sysreg_s(SYS_TPIDR_EL0);
> +	case TPIDRRO_EL0:	return read_sysreg_s(SYS_TPIDRRO_EL0);

I find a bit confusing to have some EL0 registers in the middle of EL1 
ones. Is it because they are listed by encoding?

> +	case TPIDR_EL1:		return read_sysreg_s(SYS_TPIDR_EL1);
> +	case AMAIR_EL1:		return read_sysreg_s(amair_EL12);
> +	case CNTKCTL_EL1:	return read_sysreg_s(cntkctl_EL12);
> +	case PAR_EL1:		return read_sysreg_s(SYS_PAR_EL1);
>   	}
>   
>   immediate_read:
> @@ -103,6 +123,26 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, int reg, u64 val)
>   	 * entry to the guest but are only restored on vcpu_load.
>   	 */
>   	switch (reg) {
> +	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	return;
> +	case SCTLR_EL1:		write_sysreg_s(val, sctlr_EL12);	return;
> +	case ACTLR_EL1:		write_sysreg_s(val, SYS_ACTLR_EL1);	return;
> +	case CPACR_EL1:		write_sysreg_s(val, cpacr_EL12);	return;
> +	case TTBR0_EL1:		write_sysreg_s(val, ttbr0_EL12);	return;
> +	case TTBR1_EL1:		write_sysreg_s(val, ttbr1_EL12);	return;
> +	case TCR_EL1:		write_sysreg_s(val, tcr_EL12);		return;
> +	case ESR_EL1:		write_sysreg_s(val, esr_EL12);		return;
> +	case AFSR0_EL1:		write_sysreg_s(val, afsr0_EL12);	return;
> +	case AFSR1_EL1:		write_sysreg_s(val, afsr1_EL12);	return;
> +	case FAR_EL1:		write_sysreg_s(val, far_EL12);		return;
> +	case MAIR_EL1:		write_sysreg_s(val, mair_EL12);		return;
> +	case VBAR_EL1:		write_sysreg_s(val, vbar_EL12);		return;
> +	case CONTEXTIDR_EL1:	write_sysreg_s(val, contextidr_EL12);	return;
> +	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	return;
> +	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	return;
> +	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	return;
> +	case AMAIR_EL1:		write_sysreg_s(val, amair_EL12);	return;
> +	case CNTKCTL_EL1:	write_sysreg_s(val, cntkctl_EL12);	return;
> +	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	return;
>   	}
>   
>   immediate_write:
> 

Cheers,

-- 
Julien Grall
