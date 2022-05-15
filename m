Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1157BC433F5
	for <kvmarm@archiver.kernel.org>; Sun, 15 May 2022 09:46:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 732F149EEB;
	Sun, 15 May 2022 05:46:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UKgPlNjO2rZZ; Sun, 15 May 2022 05:46:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A4AF4B0BA;
	Sun, 15 May 2022 05:46:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC73E49EEB
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 05:46:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ufSmSXjKgJJ2 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 May 2022 05:46:12 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DA8549EE6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 05:46:12 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 729DAB80B42;
 Sun, 15 May 2022 09:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D9EC385B8;
 Sun, 15 May 2022 09:46:07 +0000 (UTC)
Date: Sun, 15 May 2022 10:46:03 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: vgic-v3: List M1 Pro/Max as requiring the
 SEIS workaround
Message-ID: <YoDL2xsqFxOPo46p@arm.com>
References: <20220514102524.3188730-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220514102524.3188730-1-maz@kernel.org>
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>, marcan@marcan.st,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Sat, May 14, 2022 at 11:25:24AM +0100, Marc Zyngier wrote:
> Unsusprisingly, Apple M1 Pro/Max have the exact same defect as the
> original M1 and generate random SErrors in the host when a guest
> tickles the GICv3 CPU interface the wrong way.
> 
> Add the part numbers for both the CPU types found in these two
> new implementations, and add them to the hall of shame. This also
> applies to the Ultra version, as it is composed of 2 Max SoCs.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/cputype.h | 8 ++++++++
>  arch/arm64/kvm/vgic/vgic-v3.c    | 4 ++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
> index ff8f4511df71..60647bdc0b09 100644
> --- a/arch/arm64/include/asm/cputype.h
> +++ b/arch/arm64/include/asm/cputype.h
> @@ -118,6 +118,10 @@
>  
>  #define APPLE_CPU_PART_M1_ICESTORM	0x022
>  #define APPLE_CPU_PART_M1_FIRESTORM	0x023
> +#define APPLE_CPU_PART_M1_ICESTORM_PRO	0x024
> +#define APPLE_CPU_PART_M1_FIRESTORM_PRO	0x025
> +#define APPLE_CPU_PART_M1_ICESTORM_MAX	0x028
> +#define APPLE_CPU_PART_M1_FIRESTORM_MAX	0x029
>  
>  #define MIDR_CORTEX_A53 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A53)
>  #define MIDR_CORTEX_A57 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A57)
> @@ -164,6 +168,10 @@
>  #define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
>  #define MIDR_APPLE_M1_ICESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM)
>  #define MIDR_APPLE_M1_FIRESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM)
> +#define MIDR_APPLE_M1_ICESTORM_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM_PRO)
> +#define MIDR_APPLE_M1_FIRESTORM_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM_PRO)
> +#define MIDR_APPLE_M1_ICESTORM_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM_MAX)
> +#define MIDR_APPLE_M1_FIRESTORM_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM_MAX)

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
