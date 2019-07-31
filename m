Return-Path: <SRS0=xH8Q=V4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C50BC32751
	for <kvmarm@archiver.kernel.org>; Wed, 31 Jul 2019 08:18:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A2B7620693
	for <kvmarm@archiver.kernel.org>; Wed, 31 Jul 2019 08:18:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2B7620693
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=siemens.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3C404A523;
	Wed, 31 Jul 2019 04:18:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8YQFUDlzcuXr; Wed, 31 Jul 2019 04:18:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A59624A549;
	Wed, 31 Jul 2019 04:18:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 802FB4A51F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Jul 2019 04:17:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Avy1XDIuU7EE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Jul 2019 04:17:58 -0400 (EDT)
Received: from thoth.sbs.de (thoth.sbs.de [192.35.17.2])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CEBF34A4F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Jul 2019 04:17:57 -0400 (EDT)
Received: from mail1.sbs.de (mail1.sbs.de [192.129.41.35])
 by thoth.sbs.de (8.15.2/8.15.2) with ESMTPS id x6V8HsUc007864
 (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 31 Jul 2019 10:17:54 +0200
Received: from [139.22.32.241] ([139.22.32.241])
 by mail1.sbs.de (8.15.2/8.15.2) with ESMTP id x6V8HrnF023114;
 Wed, 31 Jul 2019 10:17:53 +0200
Subject: Re: [PATCH] kvm: arm: Promote KVM_ARM_TARGET_CORTEX_A7 to generic V7
 core
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 Vladimir Murzin <vladimir.murzin@arm.com>
References: <b486cb75-4b8e-c847-a019-81e822223fb6@web.de>
Message-ID: <ad19bda0-48df-1df0-7fb0-fc7d88ab1964@siemens.com>
Date: Wed, 31 Jul 2019 10:17:53 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <b486cb75-4b8e-c847-a019-81e822223fb6@web.de>
Content-Language: en-US
Cc: kvm <kvm@vger.kernel.org>
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

On 30.06.19 17:19, Jan Kiszka wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> The only difference between the currently supported A15 and A7 target
> cores is the reset state of bit 11 in SCTLR. This bit is RES1 or RAO/WI
> in other ARM cores, including ARMv8 ones. By promoting A7 to a generic
> default target, this allows to use yet unsupported core types. E.g.,
> this enables KVM on the A72 of the RPi4.
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  arch/arm/include/uapi/asm/kvm.h                |  1 +
>  arch/arm/kvm/Makefile                          |  2 +-
>  arch/arm/kvm/{coproc_a7.c => coproc_generic.c} | 18 +++++++++---------
>  arch/arm/kvm/guest.c                           |  4 +---
>  arch/arm/kvm/reset.c                           |  5 +----
>  5 files changed, 13 insertions(+), 17 deletions(-)
>  rename arch/arm/kvm/{coproc_a7.c => coproc_generic.c} (70%)
> 
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 4602464ebdfb..e0c5bbec3d3d 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -70,6 +70,7 @@ struct kvm_regs {
>  /* Supported Processor Types */
>  #define KVM_ARM_TARGET_CORTEX_A15	0
>  #define KVM_ARM_TARGET_CORTEX_A7	1
> +#define KVM_ARM_TARGET_GENERIC_V7	KVM_ARM_TARGET_CORTEX_A7
>  #define KVM_ARM_NUM_TARGETS		2
> 
>  /* KVM_ARM_SET_DEVICE_ADDR ioctl id encoding */
> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> index 531e59f5be9c..d959f89135d6 100644
> --- a/arch/arm/kvm/Makefile
> +++ b/arch/arm/kvm/Makefile
> @@ -21,7 +21,7 @@ obj-$(CONFIG_KVM_ARM_HOST) += hyp/
> 
>  obj-y += kvm-arm.o init.o interrupts.o
>  obj-y += handle_exit.o guest.o emulate.o reset.o
> -obj-y += coproc.o coproc_a15.o coproc_a7.o   vgic-v3-coproc.o
> +obj-y += coproc.o coproc_a15.o coproc_generic.o   vgic-v3-coproc.o
>  obj-y += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o
>  obj-y += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
>  obj-y += $(KVM)/arm/aarch32.o
> diff --git a/arch/arm/kvm/coproc_a7.c b/arch/arm/kvm/coproc_generic.c
> similarity index 70%
> rename from arch/arm/kvm/coproc_a7.c
> rename to arch/arm/kvm/coproc_generic.c
> index 40f643e1e05c..b32a541ad7bf 100644
> --- a/arch/arm/kvm/coproc_a7.c
> +++ b/arch/arm/kvm/coproc_generic.c
> @@ -15,28 +15,28 @@
>  #include "coproc.h"
> 
>  /*
> - * Cortex-A7 specific CP15 registers.
> + * Generic CP15 registers.
>   * CRn denotes the primary register number, but is copied to the CRm in the
>   * user space API for 64-bit register access in line with the terminology used
>   * in the ARM ARM.
>   * Important: Must be sorted ascending by CRn, CRM, Op1, Op2 and with 64-bit
>   *            registers preceding 32-bit ones.
>   */
> -static const struct coproc_reg a7_regs[] = {
> +static const struct coproc_reg generic_regs[] = {
>  	/* SCTLR: swapped by interrupt.S. */
>  	{ CRn( 1), CRm( 0), Op1( 0), Op2( 0), is32,
>  			access_vm_reg, reset_val, c1_SCTLR, 0x00C50878 },
>  };
> 
> -static struct kvm_coproc_target_table a7_target_table = {
> -	.target = KVM_ARM_TARGET_CORTEX_A7,
> -	.table = a7_regs,
> -	.num = ARRAY_SIZE(a7_regs),
> +static struct kvm_coproc_target_table generic_target_table = {
> +	.target = KVM_ARM_TARGET_GENERIC_V7,
> +	.table = generic_regs,
> +	.num = ARRAY_SIZE(generic_regs),
>  };
> 
> -static int __init coproc_a7_init(void)
> +static int __init coproc_generic_init(void)
>  {
> -	kvm_register_target_coproc_table(&a7_target_table);
> +	kvm_register_target_coproc_table(&generic_target_table);
>  	return 0;
>  }
> -late_initcall(coproc_a7_init);
> +late_initcall(coproc_generic_init);
> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
> index 684cf64b4033..d33a24e70f49 100644
> --- a/arch/arm/kvm/guest.c
> +++ b/arch/arm/kvm/guest.c
> @@ -275,12 +275,10 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>  int __attribute_const__ kvm_target_cpu(void)
>  {
>  	switch (read_cpuid_part()) {
> -	case ARM_CPU_PART_CORTEX_A7:
> -		return KVM_ARM_TARGET_CORTEX_A7;
>  	case ARM_CPU_PART_CORTEX_A15:
>  		return KVM_ARM_TARGET_CORTEX_A15;
>  	default:
> -		return -EINVAL;
> +		return KVM_ARM_TARGET_GENERIC_V7;
>  	}
>  }
> 
> diff --git a/arch/arm/kvm/reset.c b/arch/arm/kvm/reset.c
> index eb4174f6ebbd..d6e07500bab4 100644
> --- a/arch/arm/kvm/reset.c
> +++ b/arch/arm/kvm/reset.c
> @@ -43,13 +43,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	struct kvm_regs *reset_regs;
> 
>  	switch (vcpu->arch.target) {
> -	case KVM_ARM_TARGET_CORTEX_A7:
> -	case KVM_ARM_TARGET_CORTEX_A15:
> +	default:
>  		reset_regs = &cortexa_regs_reset;
>  		vcpu->arch.midr = read_cpuid_id();
>  		break;
> -	default:
> -		return -ENODEV;
>  	}
> 
>  	/* Reset core registers */
> --
> 2.16.4
> 

Any comments on this one now? Vladimir, you had some concerns in the other
thread. I'm not sure if I got them correctly, if they apply here.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
