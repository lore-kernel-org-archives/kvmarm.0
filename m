From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm64: add esr_el2 and far_el2 to sysreg
Date: Mon, 7 Aug 2017 16:57:14 +0100
Message-ID: <9fe6aa3a-98f9-6cae-6932-054858b54744@arm.com>
References: <1502122117-6276-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A029F40C5A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Aug 2017 11:55:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yZDIdTxys7CZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Aug 2017 11:55:51 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C1B440017
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Aug 2017 11:55:50 -0400 (EDT)
In-Reply-To: <1502122117-6276-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dongjiu Geng <gengdongjiu@huawei.com>, christoffer.dall@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, James Morse <James.Morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

+James, since he deals with all things RAS. Please keep him on CC at all
times.

On 07/08/17 17:08, Dongjiu Geng wrote:
> For the firmware-first RAS solution, SEA and SEI is injected
> by the user space, user space needs to know the esr_el2 and
> far_el2's value, so add them to sysreg. user space uses
> the IOCTL KVM_GET_ONE_REG can get their value.

No.

This has zero purpose being exposed to userspace. Userspace sees a VM
that runs at EL1, and nothing else, so exposing EL2 registers doesn't
make *any* sense.

If you want something to be exposed to userspace, it has to be properly
abstracted and describe something that is relevant to the VM. An EL2
register satisfies none of these conditions.

> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Quanming Wu <wuquanming@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 6 ++++--
>  arch/arm64/kvm/sys_regs.c         | 6 ++++++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b6242fb..6063eec 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -103,10 +103,12 @@ enum vcpu_sysreg {
>  	TTBR0_EL1,	/* Translation Table Base Register 0 */
>  	TTBR1_EL1,	/* Translation Table Base Register 1 */
>  	TCR_EL1,	/* Translation Control Register */
> -	ESR_EL1,	/* Exception Syndrome Register */
> +	ESR_EL1,	/* Exception Syndrome Register for EL1 */
> +	ESR_EL2,	/* Exception Syndrome Register for EL2 */
>  	AFSR0_EL1,	/* Auxiliary Fault Status Register 0 */
>  	AFSR1_EL1,	/* Auxiliary Fault Status Register 1 */
> -	FAR_EL1,	/* Fault Address Register */
> +	FAR_EL1,	/* Fault Address Register for EL1 */
> +	FAR_EL2,	/* Fault Address Register for EL2 */
>  	MAIR_EL1,	/* Memory Attribute Indirection Register */
>  	VBAR_EL1,	/* Vector Base Address Register */
>  	CONTEXTIDR_EL1,	/* Context ID Register */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0e26f8c..0c286bf 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -987,9 +987,15 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	/* ESR_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b0101), CRm(0b0010), Op2(0b000),
>  	  access_vm_reg, reset_unknown, ESR_EL1 },
> +	/* ESR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0101), CRm(0b0010), Op2(0b000),
> +	  access_vm_reg, reset_unknown, ESR_EL2 },
>  	/* FAR_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b0110), CRm(0b0000), Op2(0b000),
>  	  access_vm_reg, reset_unknown, FAR_EL1 },
> +	/* FAR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0110), CRm(0b0000), Op2(0b000),
> +	  access_vm_reg, reset_unknown, FAR_EL2 },
>  	/* PAR_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b0111), CRm(0b0100), Op2(0b000),
>  	  NULL, reset_unknown, PAR_EL1 },
> 

Also, what do you return here? All you're doing to return to userspace
is 0x1de7ec7edbadc0deULL (which perfectly matches this patch).

So for all intents and purposes, this patch is pretty useless.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
