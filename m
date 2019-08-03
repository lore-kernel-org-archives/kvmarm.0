Return-Path: <SRS0=TbXc=V7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD43C31E40
	for <kvmarm@archiver.kernel.org>; Sat,  3 Aug 2019 11:21:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2FFD62075C
	for <kvmarm@archiver.kernel.org>; Sat,  3 Aug 2019 11:21:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FFD62075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A15434A52E;
	Sat,  3 Aug 2019 07:21:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PVOqA9tieutc; Sat,  3 Aug 2019 07:21:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7950C4A520;
	Sat,  3 Aug 2019 07:21:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECEF34A512
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Aug 2019 07:21:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FvAF1Z6Rtlve for <kvmarm@lists.cs.columbia.edu>;
 Sat,  3 Aug 2019 07:21:32 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D16434A4E6
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Aug 2019 07:21:32 -0400 (EDT)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why)
 by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
 (Exim 4.80) (envelope-from <maz@kernel.org>)
 id 1hts6I-0007Dy-TI; Sat, 03 Aug 2019 13:21:27 +0200
Date: Sat, 3 Aug 2019 12:21:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH 3/9] KVM: arm64: Implement PV_FEATURES call
Message-ID: <20190803122124.7700f700@why>
In-Reply-To: <20190802145017.42543-4-steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-4-steven.price@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: steven.price@arm.com, catalin.marinas@arm.com,
 pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk,
 will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Fri,  2 Aug 2019 15:50:11 +0100
Steven Price <steven.price@arm.com> wrote:

> This provides a mechanism for querying which paravirtualized features
> are available in this hypervisor.
> 
> Also add the header file which defines the ABI for the paravirtualized
> clock features we're about to add.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/pvclock-abi.h | 20 ++++++++++++++++++++
>  include/linux/arm-smccc.h            | 14 ++++++++++++++
>  virt/kvm/arm/hypercalls.c            |  9 +++++++++
>  3 files changed, 43 insertions(+)
>  create mode 100644 arch/arm64/include/asm/pvclock-abi.h
> 
> diff --git a/arch/arm64/include/asm/pvclock-abi.h b/arch/arm64/include/asm/pvclock-abi.h
> new file mode 100644
> index 000000000000..1f7cdc102691
> --- /dev/null
> +++ b/arch/arm64/include/asm/pvclock-abi.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2019 Arm Ltd. */
> +
> +#ifndef __ASM_PVCLOCK_ABI_H
> +#define __ASM_PVCLOCK_ABI_H
> +
> +/* The below structures and constants are defined in ARM DEN0057A */
> +
> +struct pvclock_vcpu_stolen_time_info {
> +	__le32 revision;
> +	__le32 attributes;
> +	__le64 stolen_time;
> +	/* Structure must be 64 byte aligned, pad to that size */
> +	u8 padding[48];
> +} __packed;
> +
> +#define PV_VM_TIME_NOT_SUPPORTED	-1

Isn't the intent for this to be the same value as
SMCCC_RET_NOT_SUPPORTED?

> +#define PV_VM_TIME_INVALID_PARAMETERS	-2

It overlaps with SMCCC_RET_NOT_REQUIRED. Is that a problem? Should we
consider a spec change for this?

> +
> +#endif
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 080012a6f025..e7f129f26ebd 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -45,6 +45,7 @@
>  #define ARM_SMCCC_OWNER_SIP		2
>  #define ARM_SMCCC_OWNER_OEM		3
>  #define ARM_SMCCC_OWNER_STANDARD	4
> +#define ARM_SMCCC_OWNER_STANDARD_HYP	5
>  #define ARM_SMCCC_OWNER_TRUSTED_APP	48
>  #define ARM_SMCCC_OWNER_TRUSTED_APP_END	49
>  #define ARM_SMCCC_OWNER_TRUSTED_OS	50
> @@ -302,5 +303,18 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
>  #define SMCCC_RET_NOT_SUPPORTED			-1
>  #define SMCCC_RET_NOT_REQUIRED			-2
>  
> +/* Paravirtualised time calls (defined by ARM DEN0057A) */
> +#define ARM_SMCCC_HV_PV_FEATURES				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> +			   ARM_SMCCC_SMC_64,			\
> +			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
> +			   0x20)
> +
> +#define ARM_SMCCC_HV_PV_TIME_ST					\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> +			   ARM_SMCCC_SMC_64,			\
> +			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
> +			   0x22)
> +
>  #endif /*__ASSEMBLY__*/
>  #endif /*__LINUX_ARM_SMCCC_H*/
> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
> index f875241bd030..2906b2df99df 100644
> --- a/virt/kvm/arm/hypercalls.c
> +++ b/virt/kvm/arm/hypercalls.c
> @@ -5,6 +5,7 @@
>  #include <linux/kvm_host.h>
>  
>  #include <asm/kvm_emulate.h>
> +#include <asm/pvclock-abi.h>
>  
>  #include <kvm/arm_hypercalls.h>
>  #include <kvm/arm_psci.h>
> @@ -48,6 +49,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  				break;
>  			}
>  			break;
> +		case ARM_SMCCC_HV_PV_FEATURES:
> +			val = SMCCC_RET_SUCCESS;
> +			break;
> +		}
> +		break;
> +	case ARM_SMCCC_HV_PV_FEATURES:
> +		feature = smccc_get_arg1(vcpu);
> +		switch (feature) {
>  		}
>  		break;
>  	default:


Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
