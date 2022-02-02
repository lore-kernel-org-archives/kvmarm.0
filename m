Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191E3C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Feb 2022 11:53:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2F34B0C2;
	Wed,  2 Feb 2022 06:53:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gmW5RNCfe+cf; Wed,  2 Feb 2022 06:53:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D95244B093;
	Wed,  2 Feb 2022 06:53:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6675649F5B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Feb 2022 06:53:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rwzPCdUAkSgJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Feb 2022 06:53:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9725149F56
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Feb 2022 06:53:29 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2F691FB;
 Wed,  2 Feb 2022 03:53:28 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0FCB93F718;
 Wed,  2 Feb 2022 03:53:25 -0800 (PST)
Date: Wed, 2 Feb 2022 11:53:35 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 04/64] KVM: arm64: nv: Allow userspace to set
 PSR_MODE_EL2x
Message-ID: <YfpwvyqpL80yA8k7@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-5-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-5-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
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

On Fri, Jan 28, 2022 at 12:18:12PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> We were not allowing userspace to set a more privileged mode for the VCPU
> than EL1, but we should allow this when nested virtualization is enabled
> for the VCPU.
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/guest.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index e116c7767730..db6209622be9 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -24,6 +24,7 @@
>  #include <asm/fpsimd.h>
>  #include <asm/kvm.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/sigcontext.h>
>  
>  #include "trace.h"
> @@ -259,6 +260,11 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  			if (vcpu_el1_is_32bit(vcpu))
>  				return -EINVAL;
>  			break;
> +		case PSR_MODE_EL2h:
> +		case PSR_MODE_EL2t:
> +			if (vcpu_el1_is_32bit(vcpu) || !vcpu_has_nv(vcpu))

I'm a bit confused about the vcpu_el1_is_32bit() check. The function tests
that HCR_EL2.RW is not set. HCR_EL2.RW is cleared when the
KVM_ARM_VCPU_EL1_32BIT feature is preset for the VCPU. But the EL2 and the
32BIT features are incompatible (kvm_reset_vcpu() returns an error when
both are set). Wouldn't checking only !vcpu_has_nv() be enough here?

Thanks,
Alex

> +				return -EINVAL;
> +			break;
>  		default:
>  			err = -EINVAL;
>  			goto out;
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
