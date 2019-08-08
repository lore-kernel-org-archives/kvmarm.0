Return-Path: <SRS0=uVDJ=WE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E34C0650F
	for <kvmarm@archiver.kernel.org>; Thu,  8 Aug 2019 09:34:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F89E2173C
	for <kvmarm@archiver.kernel.org>; Thu,  8 Aug 2019 09:34:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F89E2173C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CF9D4A562;
	Thu,  8 Aug 2019 05:34:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ELjOv-i2Pngl; Thu,  8 Aug 2019 05:34:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A47864A559;
	Thu,  8 Aug 2019 05:34:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20EBA4A54A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Aug 2019 05:34:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qtoJuVFjQg3Y for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Aug 2019 05:34:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98A414A53D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Aug 2019 05:34:37 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F5F11576;
 Thu,  8 Aug 2019 02:34:37 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50FAA3F706;
 Thu,  8 Aug 2019 02:34:36 -0700 (PDT)
Subject: Re: [PATCH 47/59] KVM: arm64: nv: Propagate CNTVOFF_EL2 to the
 virtual EL1 timer
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-48-marc.zyngier@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <95edbe3a-bd6c-11b5-cfa9-6d5252dbb50c@arm.com>
Date: Thu, 8 Aug 2019 10:34:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-48-marc.zyngier@arm.com>
Content-Language: en-US
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

On 6/21/19 10:38 AM, Marc Zyngier wrote:
> We need to allow a guest hypervisor to virtualize the virtual timer.
> FOr that, let's propagate CNTVOFF_EL2 to the guest's view of that
> timer.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 -
>  arch/arm64/kvm/sys_regs.c         |  8 ++++++--
>  include/kvm/arm_arch_timer.h      |  1 +
>  virt/kvm/arm/arch_timer.c         | 12 ++++++++++++
>  4 files changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b7c44adcdbf3..e0fe9acb46bf 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -252,7 +252,6 @@ enum vcpu_sysreg {
>  	RMR_EL2,	/* Reset Management Register */
>  	CONTEXTIDR_EL2,	/* Context ID Register (EL2) */
>  	TPIDR_EL2,	/* EL2 Software Thread ID Register */
> -	CNTVOFF_EL2,	/* Counter-timer Virtual Offset register */
>  	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
>  	SP_EL2,		/* EL2 Stack Pointer */
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1b8016330a19..2031a59fcf49 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -150,7 +150,6 @@ struct el2_sysreg_map {
>  	PURE_EL2_SYSREG( RVBAR_EL2 ),
>  	PURE_EL2_SYSREG( RMR_EL2 ),
>  	PURE_EL2_SYSREG( TPIDR_EL2 ),
> -	PURE_EL2_SYSREG( CNTVOFF_EL2 ),
>  	PURE_EL2_SYSREG( CNTHCTL_EL2 ),
>  	PURE_EL2_SYSREG( HPFAR_EL2 ),
>  	EL2_SYSREG(      SCTLR_EL2,  SCTLR_EL1,      translate_sctlr ),
> @@ -1351,6 +1350,11 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  		tmr = TIMER_PTIMER;
>  		treg = TIMER_REG_CVAL;
>  		break;
> +	case SYS_CNTVOFF_EL2:
> +		tmr = TIMER_VTIMER;
> +		treg = TIMER_REG_VOFF;
> +		break;
> +
>  	default:
>  		BUG();
>  	}
> @@ -2122,7 +2126,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_CONTEXTIDR_EL2), access_rw, reset_val, CONTEXTIDR_EL2, 0 },
>  	{ SYS_DESC(SYS_TPIDR_EL2), access_rw, reset_val, TPIDR_EL2, 0 },
>  
> -	{ SYS_DESC(SYS_CNTVOFF_EL2), access_rw, reset_val, CNTVOFF_EL2, 0 },
> +	{ SYS_DESC(SYS_CNTVOFF_EL2), access_arch_timer },
>  	{ SYS_DESC(SYS_CNTHCTL_EL2), access_rw, reset_val, CNTHCTL_EL2, 0 },
>  
>  	{ SYS_DESC(SYS_CNTHP_TVAL_EL2), access_arch_timer },
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 3a5d9255120e..3389606f3029 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -23,6 +23,7 @@ enum kvm_arch_timer_regs {
>  	TIMER_REG_CVAL,
>  	TIMER_REG_TVAL,
>  	TIMER_REG_CTL,
> +	TIMER_REG_VOFF,
>  };
>  
>  struct arch_timer_context {
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 3d84c240071d..1d53352c7d97 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -913,6 +913,10 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
>  		val = kvm_phys_timer_read() - timer->cntvoff;
>  		break;
>  
> +	case TIMER_REG_VOFF:
> +		val = timer->cntvoff;
> +		break;
> +
>  	default:
>  		BUG();
>  	}
> @@ -955,6 +959,10 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
>  		timer->cnt_cval = val;
>  		break;
>  
> +	case TIMER_REG_VOFF:
> +		timer->cntvoff = val;
> +		break;
> +
>  	default:
>  		BUG();
>  	}
> @@ -1166,6 +1174,10 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  		return -EINVAL;
>  	}
>  
> +	/* Nested virtualization requires zero offset for virtual EL2 */
> +	if (nested_virt_in_use(vcpu))
> +		vcpu_vtimer(vcpu)->cntvoff = 0;

I think this is related to the fact that the virtual offset is treated as 0 when
reading CNTVCT_EL0 from EL2, or from from EL2 and EL0 if E2H, TGE are set
(please correct me if I'm wrong).

However, when the guest runs in virtual EL2, the direct_vtimer is the hvtimer,
so the value that ends up in CNTVOFF_EL2 is vcpu_hvtimer(vcpu)->cntvoff.

Thanks,
Alex
> +
>  	get_timer_map(vcpu, &map);
>  
>  	ret = kvm_vgic_map_phys_irq(vcpu,
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
