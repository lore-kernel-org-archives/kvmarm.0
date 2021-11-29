Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6ED1C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 16:57:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 127174B173;
	Mon, 29 Nov 2021 11:57:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xIlgyhdB3QTT; Mon, 29 Nov 2021 11:57:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49B2D4B199;
	Mon, 29 Nov 2021 11:57:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B28E94B17B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 11:57:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BptX-a4U4iXy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 11:57:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C7AA4B173
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 11:57:31 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A0371063;
 Mon, 29 Nov 2021 08:57:30 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B16303F5A1;
 Mon, 29 Nov 2021 08:57:28 -0800 (PST)
Date: Mon, 29 Nov 2021 16:59:21 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Add minimal handling for the ARMv8.7 PMU
Message-ID: <YaUG6TtiiIRyzL/y@monolith.localdoman>
References: <20211126115533.217903-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211126115533.217903-1-maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Tested on FVP and the nasty splat goes away, so it works for me:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

The guest visible PMCR_EL0.FZ0 bit added by FEAT_PMUv3p7 is cleared on
register reset/write because ARMV8_PMU_PMCR_MASK is 0xff. This makes the
bit behave as RES0, which is the architectural value for the field when
FEAT_PMUv3p7 is absent. So the patch looks correct to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

On Fri, Nov 26, 2021 at 11:55:33AM +0000, Marc Zyngier wrote:
> When running a KVM guest hosted on an ARMv8.7 machine, the host
> kernel complains that it doesn't know about the architected number
> of events.
> 
> Fix it by adding the PMUver code corresponding to PMUv3 for ARMv8.7.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 1 +
>  arch/arm64/kvm/pmu-emul.c       | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index cdb590840b3f..5de90138d0a4 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1036,6 +1036,7 @@
>  #define ID_AA64DFR0_PMUVER_8_1		0x4
>  #define ID_AA64DFR0_PMUVER_8_4		0x5
>  #define ID_AA64DFR0_PMUVER_8_5		0x6
> +#define ID_AA64DFR0_PMUVER_8_7		0x7
>  #define ID_AA64DFR0_PMUVER_IMP_DEF	0xf
>  
>  #define ID_AA64DFR0_PMSVER_8_2		0x1
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index a5e4bbf5e68f..ca92cc5c71c6 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -28,6 +28,7 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
>  	case ID_AA64DFR0_PMUVER_8_1:
>  	case ID_AA64DFR0_PMUVER_8_4:
>  	case ID_AA64DFR0_PMUVER_8_5:
> +	case ID_AA64DFR0_PMUVER_8_7:
>  		return GENMASK(15, 0);
>  	default:		/* Shouldn't be here, just for sanity */
>  		WARN_ONCE(1, "Unknown PMU version %d\n", kvm->arch.pmuver);
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
