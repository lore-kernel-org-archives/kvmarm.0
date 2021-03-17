Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03FFC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 15:17:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D7AA64F75
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 15:17:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D7AA64F75
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 768DA4B67E;
	Wed, 17 Mar 2021 11:17:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KgOjtkLhWyhb; Wed, 17 Mar 2021 11:17:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34A3A4B679;
	Wed, 17 Mar 2021 11:17:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 178B74B670
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 11:17:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EYoz+jdOqLAj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 11:17:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C31064B651
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 11:17:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F569D6E;
 Wed, 17 Mar 2021 08:17:29 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 437E43F792;
 Wed, 17 Mar 2021 08:17:28 -0700 (PDT)
Subject: Re: [PATCH kvmtool v3 20/22] arm: Reorganise and document memory map
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20210315153350.19988-1-andre.przywara@arm.com>
 <20210315153350.19988-21-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <7b96fc7a-9078-cabc-85bc-8cdfcd37d791@arm.com>
Date: Wed, 17 Mar 2021 15:17:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315153350.19988-21-andre.przywara@arm.com>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Sami Mujawar <sami.mujawar@arm.com>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Hi Andre,

On 3/15/21 3:33 PM, Andre Przywara wrote:
> The hardcoded memory map we expose to a guest is currently described
> using a series of partially interconnected preprocessor constants,
> which is hard to read and follow.
>
> In preparation for moving the UART and RTC to some different MMIO
> region, document the current map with some ASCII art, and clean up the
> definition of the sections.
>
> This changes the only internally used value of ARM_MMIO_AREA, to better
> align with its actual meaning and future extensions.
>
> No functional change.

Looks good, the values in the map match the defines, and there's no forward
declaration of the serial or RTC MMIO regions:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/include/arm-common/kvm-arch.h | 41 ++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 12 deletions(-)
>
> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> index d84e50cd..a2e32953 100644
> --- a/arm/include/arm-common/kvm-arch.h
> +++ b/arm/include/arm-common/kvm-arch.h
> @@ -7,14 +7,33 @@
>  
>  #include "arm-common/gic.h"
>  
> +/*
> + * The memory map used for ARM guests (not to scale):
> + *
> + * 0      64K  16M     32M     48M            1GB       2GB
> + * +-------+----+-------+-------+--------+-----+---------+---......
> + * |  PCI  |////| plat  |       |        |     |         |
> + * |  I/O  |////| MMIO  | Flash | virtio | GIC |   PCI   |  DRAM
> + * | space |////|       |       |  MMIO  |     |  (AXI)  |
> + * |       |////|       |       |        |     |         |
> + * +-------+----+-------+-------+--------+-----+---------+---......
> + */
> +
>  #define ARM_IOPORT_AREA		_AC(0x0000000000000000, UL)
> -#define ARM_FLASH_AREA		_AC(0x0000000002000000, UL)
> -#define ARM_MMIO_AREA		_AC(0x0000000003000000, UL)
> +#define ARM_MMIO_AREA		_AC(0x0000000001000000, UL)
>  #define ARM_AXI_AREA		_AC(0x0000000040000000, UL)
>  #define ARM_MEMORY_AREA		_AC(0x0000000080000000, UL)
>  
> -#define ARM_LOMAP_MAX_MEMORY	((1ULL << 32) - ARM_MEMORY_AREA)
> -#define ARM_HIMAP_MAX_MEMORY	((1ULL << 40) - ARM_MEMORY_AREA)
> +#define KVM_IOPORT_AREA		ARM_IOPORT_AREA
> +#define ARM_IOPORT_SIZE		(1U << 16)
> +
> +
> +#define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
> +#define KVM_FLASH_MAX_SIZE	0x1000000
> +
> +#define KVM_VIRTIO_MMIO_AREA	(KVM_FLASH_MMIO_BASE + KVM_FLASH_MAX_SIZE)
> +#define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - \
> +				(KVM_VIRTIO_MMIO_AREA + ARM_GIC_SIZE))
>  
>  #define ARM_GIC_DIST_BASE	(ARM_AXI_AREA - ARM_GIC_DIST_SIZE)
>  #define ARM_GIC_CPUI_BASE	(ARM_GIC_DIST_BASE - ARM_GIC_CPUI_SIZE)
> @@ -22,19 +41,17 @@
>  #define ARM_GIC_DIST_SIZE	0x10000
>  #define ARM_GIC_CPUI_SIZE	0x20000
>  
> -#define KVM_FLASH_MMIO_BASE	ARM_FLASH_AREA
> -#define KVM_FLASH_MAX_SIZE	(ARM_MMIO_AREA - ARM_FLASH_AREA)
>  
> -#define ARM_IOPORT_SIZE		(1U << 16)
> -#define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - (ARM_MMIO_AREA + ARM_GIC_SIZE))
> +#define KVM_PCI_CFG_AREA	ARM_AXI_AREA
>  #define ARM_PCI_CFG_SIZE	(1ULL << 24)
> +#define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
>  #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
>  				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
>  
> -#define KVM_IOPORT_AREA		ARM_IOPORT_AREA
> -#define KVM_PCI_CFG_AREA	ARM_AXI_AREA
> -#define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
> -#define KVM_VIRTIO_MMIO_AREA	ARM_MMIO_AREA
> +
> +#define ARM_LOMAP_MAX_MEMORY	((1ULL << 32) - ARM_MEMORY_AREA)
> +#define ARM_HIMAP_MAX_MEMORY	((1ULL << 40) - ARM_MEMORY_AREA)
> +
>  
>  #define KVM_IOEVENTFD_HAS_PIO	0
>  
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
