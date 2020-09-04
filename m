Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F222CC43461
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 14:39:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7BBCF206F2
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 14:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BBCF206F2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=Huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 019174B3B0;
	Fri,  4 Sep 2020 10:39:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vPckBtmyeWh3; Fri,  4 Sep 2020 10:39:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0D204B205;
	Fri,  4 Sep 2020 10:39:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0155A4B1FD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 10:39:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CvKusT+Xwpp0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 10:39:21 -0400 (EDT)
Received: from huawei.com (lhrrgout.huawei.com [185.176.76.210])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAB954B1FC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 10:39:21 -0400 (EDT)
Received: from lhreml710-chm.china.huawei.com (unknown [172.18.7.108])
 by Forcepoint Email with ESMTP id 4A63B9CD8D0D45539EAA;
 Fri,  4 Sep 2020 15:39:20 +0100 (IST)
Received: from localhost (10.52.125.29) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 4 Sep 2020
 15:39:19 +0100
Date: Fri, 4 Sep 2020 15:37:46 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 05/23] KVM: arm64: Move GIC model out of the distributor
Message-ID: <20200904153746.0000521c@Huawei.com>
In-Reply-To: <20200903152610.1078827-6-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
 <20200903152610.1078827-6-maz@kernel.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
X-Originating-IP: [10.52.125.29]
X-ClientProxiedBy: lhreml743-chm.china.huawei.com (10.201.108.193) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
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

On Thu,  3 Sep 2020 16:25:52 +0100
Marc Zyngier <maz@kernel.org> wrote:

> In order to allow more than just GIC implementations in the future,
> let's move the GIC model outside of the distributor. This also
> allows us to back irqchip_in_kernel() with its own irqchip type
> (IRQCHIP_USER), removing another field from the distributor.
> 
> New helpers are provided as a convenience.

Patch looks fine to me. One observation inline.

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h     |  2 ++
>  arch/arm64/include/asm/kvm_irq.h      | 20 ++++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic-debug.c      |  5 +++--
>  arch/arm64/kvm/vgic/vgic-init.c       | 26 ++++++++++++--------------
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 16 ++++++++++++----
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c    |  2 +-
>  arch/arm64/kvm/vgic/vgic-mmio.c       | 10 ++++------
>  arch/arm64/kvm/vgic/vgic-v3.c         | 20 ++++++++------------
>  include/kvm/arm_vgic.h                |  5 -----
>  9 files changed, 62 insertions(+), 44 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_irq.h
> 

...

> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 76e2d85789ed..c6fdb1222453 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -32,7 +32,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
> -	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> +	bool is_v3 = irqchip_is_gic_v3(vcpu->kvm);
>  	int lr;
>  
>  	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
> @@ -48,7 +48,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>  		cpuid = val & GICH_LR_PHYSID_CPUID;
>  		cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
>  
> -		if (model == KVM_DEV_TYPE_ARM_VGIC_V3) {
> +		if (is_v3) {
>  			intid = val & ICH_LR_VIRTUAL_ID_MASK;
>  		} else {
>  			intid = val & GICH_LR_VIRTUALID;
> @@ -117,12 +117,11 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>  /* Requires the irq to be locked already */
>  void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>  {
> -	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> +	bool is_v2 = irqchip_is_gic_v2(vcpu->kvm);
>  	u64 val = irq->intid;
>  	bool allow_pending = true, is_v2_sgi;
>  
> -	is_v2_sgi = (vgic_irq_is_sgi(irq->intid) &&
> -		     model == KVM_DEV_TYPE_ARM_VGIC_V2);
> +	is_v2_sgi = (vgic_irq_is_sgi(irq->intid) && is_v2);
>  
>  	if (irq->active) {
>  		val |= ICH_LR_ACTIVE_BIT;
> @@ -163,8 +162,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>  		if (irq->config == VGIC_CONFIG_EDGE)
>  			irq->pending_latch = false;
>  
> -		if (vgic_irq_is_sgi(irq->intid) &&
> -		    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
> +		if (vgic_irq_is_sgi(irq->intid) && is_v2) {

Clearly its true in the original code, but I'm not sure why we
have a local variable for is_v2_sgi above, but don't use it here.

Looks like it might just be because is_v2_sgi was introduced
as part of a bug fix that didn't go near this block of code?

>  			u32 src = ffs(irq->source);
>  
>  			if (WARN_RATELIMIT(!src, "No SGI source for INTID %d\n",
> @@ -205,10 +203,9 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
>  void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>  {
>  	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> -	u32 model = vcpu->kvm->arch.vgic.vgic_model;
>  	u32 vmcr;
>  
> -	if (model == KVM_DEV_TYPE_ARM_VGIC_V2) {
> +	if (irqchip_is_gic_v2(vcpu->kvm)) {
>  		vmcr = (vmcrp->ackctl << ICH_VMCR_ACK_CTL_SHIFT) &
>  			ICH_VMCR_ACK_CTL_MASK;
>  		vmcr |= (vmcrp->fiqen << ICH_VMCR_FIQ_EN_SHIFT) &
> @@ -235,12 +232,11 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>  void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>  {
>  	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> -	u32 model = vcpu->kvm->arch.vgic.vgic_model;
>  	u32 vmcr;
>  
>  	vmcr = cpu_if->vgic_vmcr;
>  
> -	if (model == KVM_DEV_TYPE_ARM_VGIC_V2) {
> +	if (irqchip_is_gic_v2(vcpu->kvm)) {
>  		vmcrp->ackctl = (vmcr & ICH_VMCR_ACK_CTL_MASK) >>
>  			ICH_VMCR_ACK_CTL_SHIFT;
>  		vmcrp->fiqen = (vmcr & ICH_VMCR_FIQ_EN_MASK) >>
> @@ -285,7 +281,7 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>  	 * Also, we don't support any form of IRQ/FIQ bypass.
>  	 * This goes with the spec allowing the value to be RAO/WI.
>  	 */
> -	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
> +	if (irqchip_is_gic_v3(vcpu->kvm)) {
>  		vgic_v3->vgic_sre = (ICC_SRE_EL1_DIB |
>  				     ICC_SRE_EL1_DFB |
>  				     ICC_SRE_EL1_SRE);


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
