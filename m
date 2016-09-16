From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 4/6] arm/arm64: vgic-new: Introduce VENG0 and VENG1
 fields to vmcr struct
Date: Fri, 16 Sep 2016 14:54:48 +0100
Message-ID: <57DBF9A8.5040604@arm.com>
References: <1474028453-29132-1-git-send-email-vijay.kilari@gmail.com>
 <1474028453-29132-5-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FFEA49AFA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 09:46:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I1jUgSCX12sw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2016 09:46:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD5FD499A1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 09:45:59 -0400 (EDT)
In-Reply-To: <1474028453-29132-5-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/09/16 13:20, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> ICC_VMCR_EL2 supports virtual access to ICC_IGRPEN1_EL1.Enable
> and ICC_IGRPEN0_EL1.Enable fields. Add grpen0 and grpen1 member
> variables to struct vmcr to support read and write of these fields.
> 
> ICH_VMCR_CTLR_MASK is changed to mask only ICC_CTLR_EL1 fields.

This comment doesn't match the patch.

> Also refactor vgic_set_vmcr and vgic_get_vmcr() code.
> 
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> ---
>  include/linux/irqchip/arm-gic-v3.h | 15 +++++++++++----
>  virt/kvm/arm/vgic/vgic-mmio-v2.c   | 16 ----------------
>  virt/kvm/arm/vgic/vgic-mmio.c      | 16 ++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c        | 10 ++++++++--
>  virt/kvm/arm/vgic/vgic.h           |  5 +++++
>  5 files changed, 40 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 99ac022..88d83d3 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -352,8 +352,9 @@
>  /*
>   * CPU interface registers
>   */
> -#define ICC_CTLR_EL1_EOImode_drop_dir	(0U << 1)
> -#define ICC_CTLR_EL1_EOImode_drop	(1U << 1)
> +#define ICC_CTLR_EL1_EOImode_SHIFT	(1)
> +#define ICC_CTLR_EL1_EOImode_drop_dir	(0U << ICC_CTLR_EL1_EOImode_SHIFT)
> +#define ICC_CTLR_EL1_EOImode_drop	(1U << ICC_CTLR_EL1_EOImode_SHIFT)
>  #define ICC_SRE_EL1_SRE			(1U << 0)
>  
>  /*
> @@ -382,14 +383,20 @@
>  #define ICH_HCR_EN			(1 << 0)
>  #define ICH_HCR_UIE			(1 << 1)
>  
> -#define ICH_VMCR_CTLR_SHIFT		0
> -#define ICH_VMCR_CTLR_MASK		(0x21f << ICH_VMCR_CTLR_SHIFT)
> +#define ICH_VMCR_CBPR_SHIFT		4
> +#define ICH_VMCR_CBPR_MASK		(1 << ICH_VMCR_CBPR_SHIFT)
> +#define ICH_VMCR_EOIM_SHIFT		9
> +#define ICH_VMCR_EOIM_MASK		(1 << ICH_VMCR_EOIM_SHIFT)
>  #define ICH_VMCR_BPR1_SHIFT		18
>  #define ICH_VMCR_BPR1_MASK		(7 << ICH_VMCR_BPR1_SHIFT)
>  #define ICH_VMCR_BPR0_SHIFT		21
>  #define ICH_VMCR_BPR0_MASK		(7 << ICH_VMCR_BPR0_SHIFT)
>  #define ICH_VMCR_PMR_SHIFT		24
>  #define ICH_VMCR_PMR_MASK		(0xffUL << ICH_VMCR_PMR_SHIFT)
> +#define ICH_VMCR_ENG0_SHIFT		0
> +#define ICH_VMCR_ENG0_MASK		(1 << ICH_VMCR_ENG0_SHIFT)
> +#define ICH_VMCR_ENG1_SHIFT		1
> +#define ICH_VMCR_ENG1_MASK		(1 << ICH_VMCR_ENG1_SHIFT)
>  
>  #define ICC_IAR1_EL1_SPURIOUS		0x3ff

I've asked you to make this a separate patch, which you've ignored.
Please make this change a separate patch, independent of any KVM change.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
