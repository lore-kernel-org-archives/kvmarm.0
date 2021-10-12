Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C482FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 16:04:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3AF5961139
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 16:04:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3AF5961139
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 988A84B0D7;
	Tue, 12 Oct 2021 12:04:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6CDICLc1MgwU; Tue, 12 Oct 2021 12:04:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 532604B0DF;
	Tue, 12 Oct 2021 12:04:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 936834B0D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 12:04:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3QpC5UFYjuZE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 12:04:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20FF64B0B9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 12:04:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1E271FB;
 Tue, 12 Oct 2021 09:04:05 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16CE13F66F;
 Tue, 12 Oct 2021 09:04:03 -0700 (PDT)
Date: Tue, 12 Oct 2021 17:05:37 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 3/5] KVM: arm64: vgic-v3: Reduce common group trapping
 to ICV_DIR_EL1 when possible
Message-ID: <YWWx0dpdOmbeyYVT@monolith.localdoman>
References: <20211010150910.2911495-1-maz@kernel.org>
 <20211010150910.2911495-4-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211010150910.2911495-4-maz@kernel.org>
Cc: kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On Sun, Oct 10, 2021 at 04:09:08PM +0100, Marc Zyngier wrote:
> On systems that advertise ICH_VTR_EL2.SEIS, we trap all GICv3 sysreg
> accesses from the guest. From a performance perspective, this is OK
> as long as the guest doesn't hammer the GICv3 CPU interface.
> 
> In most cases, this is fine, unless the guest actively uses
> priorities and switches PMR_EL1 very often. Which is exactly what
> happens when a Linux guest runs with irqchip.gicv3_pseudo_nmi=1.
> In these condition, the performance plumets as we hit PMR each time
> we mask/unmask interrupts. Not good.
> 
> There is however an opportunity for improvement. Careful reading
> of the architecture specification indicates that the only GICv3
> sysreg belonging to the common group (which contains the SGI
> registers, PMR, DIR, CTLR and RPR) that is allowed to generate
> a SError is DIR. Everything else is safe.
> 
> It is thus possible to substitute the trapping of all the common
> group with just that of DIR if it supported by the implementation.
> Yes, that's yet another optional bit of the architecture.
> So let's just do that, as it leads to some impressive result on
> the M1:
> 
> Without this change:
> 	bash-5.1# /host/home/maz/hackbench 100 process 1000
> 	Running with 100*40 (== 4000) tasks.
> 	Time: 56.596
> 
> With this change:
> 	bash-5.1# /host/home/maz/hackbench 100 process 1000
> 	Running with 100*40 (== 4000) tasks.
> 	Time: 8.649
> 
> which is a pretty convincing result.

This is a very good idea. Checked when I reviewed the latest iteration that only
ICC_DIR_EL1/ICV_DIR_EL1 can cause SErrors, so this approach looks sensible to
me.

Also checked the bit field positions:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h |  3 +++
>  arch/arm64/kvm/vgic/vgic-v3.c   | 15 +++++++++++----
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index b268082d67ed..9412a645a1c0 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1152,6 +1152,7 @@
>  #define ICH_HCR_TC		(1 << 10)
>  #define ICH_HCR_TALL0		(1 << 11)
>  #define ICH_HCR_TALL1		(1 << 12)
> +#define ICH_HCR_TDIR		(1 << 14)
>  #define ICH_HCR_EOIcount_SHIFT	27
>  #define ICH_HCR_EOIcount_MASK	(0x1f << ICH_HCR_EOIcount_SHIFT)
>  
> @@ -1184,6 +1185,8 @@
>  #define ICH_VTR_SEIS_MASK	(1 << ICH_VTR_SEIS_SHIFT)
>  #define ICH_VTR_A3V_SHIFT	21
>  #define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
> +#define ICH_VTR_TDS_SHIFT	19
> +#define ICH_VTR_TDS_MASK	(1 << ICH_VTR_TDS_SHIFT)
>  
>  #define ARM64_FEATURE_FIELD_BITS	4
>  
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index ae59e2580bf5..467c22bbade6 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -15,6 +15,7 @@
>  static bool group0_trap;
>  static bool group1_trap;
>  static bool common_trap;
> +static bool dir_trap;
>  static bool gicv4_enable;
>  
>  void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
> @@ -296,6 +297,8 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>  		vgic_v3->vgic_hcr |= ICH_HCR_TALL1;
>  	if (common_trap)
>  		vgic_v3->vgic_hcr |= ICH_HCR_TC;
> +	if (dir_trap)
> +		vgic_v3->vgic_hcr |= ICH_HCR_TDIR;
>  }
>  
>  int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
> @@ -676,14 +679,18 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  
>  		group0_trap = true;
>  		group1_trap = true;
> -		common_trap = true;
> +		if (ich_vtr_el2 & ICH_VTR_TDS_MASK)
> +			dir_trap = true;
> +		else
> +			common_trap = true;
>  	}
>  
> -	if (group0_trap || group1_trap || common_trap) {
> -		kvm_info("GICv3 sysreg trapping enabled ([%s%s%s], reduced performance)\n",
> +	if (group0_trap || group1_trap || common_trap | dir_trap) {
> +		kvm_info("GICv3 sysreg trapping enabled ([%s%s%s%s], reduced performance)\n",
>  			 group0_trap ? "G0" : "",
>  			 group1_trap ? "G1" : "",
> -			 common_trap ? "C"  : "");
> +			 common_trap ? "C"  : "",
> +			 dir_trap    ? "D"  : "");
>  		static_branch_enable(&vgic_v3_cpuif_trap);
>  	}
>  
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
