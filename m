From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH] KVM: arm/arm64: check IRQ number on userland injection
Date: Fri, 10 Apr 2015 11:29:22 -0400
Message-ID: <5527EC52.4050500@codeaurora.org>
References: <1428679079-16499-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1428679079-16499-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 04/10/2015 11:17 AM, Andre Przywara wrote:
> When userland injects a SPI via the KVM_IRQ_LINE ioctl we currently
> only check it against a fixed limit, which historically is set
> to 127. With the new dynamic IRQ allocation the effective limit may
> actually be smaller (64).
> So when now a malicious or buggy userland injects a SPI in that
> range, we spill over on our VGIC bitmaps and bytemaps memory.
> I could trigger a host kernel NULL pointer dereference with current
> mainline by injecting some bogus IRQ number from a hacked kvmtool:

> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -195,7 +195,11 @@ struct kvm_arch_memory_slot {
>  #define KVM_ARM_IRQ_CPU_IRQ		0
>  #define KVM_ARM_IRQ_CPU_FIQ		1
>  
> -/* Highest supported SPI, from VGIC_NR_IRQS */
> +/*
> + * This used to hold the highest supported SPI, but it is now obsolete
> + * and only here to provide source code level compatibility with older
> + * userland. The highest SPI number can be set via KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
> + */
>  #define KVM_ARM_IRQ_GIC_MAX		127

If that's the case should it maybe only defined when __KERNEL__ is not defined?

Chris

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
