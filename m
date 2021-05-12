Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041AEC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 16:22:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D43F6127A
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 16:22:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D43F6127A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AC414B559;
	Wed, 12 May 2021 12:22:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8sXPn1WE2Yrp; Wed, 12 May 2021 12:22:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 421494B463;
	Wed, 12 May 2021 12:22:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3688F4B42D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 12:22:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hXbRFo1rK92N for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 12:22:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E26004B421
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 12:22:03 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 256DA1FB;
 Wed, 12 May 2021 09:22:03 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 594EB3F719;
 Wed, 12 May 2021 09:22:01 -0700 (PDT)
Subject: Re: [PATCH v3 0/9] KVM: arm64: Initial host support for the Apple M1
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210510134824.1910399-1-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3a21048a-a084-a884-7a3d-9b283f8b15ed@arm.com>
Date: Wed, 12 May 2021 17:22:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210510134824.1910399-1-maz@kernel.org>
Content-Language: en-US
Cc: Hector Martin <marcan@marcan.st>, kernel-team@android.com
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

On 5/10/21 2:48 PM, Marc Zyngier wrote:
> This is a new version of the series previously posted at [2], reworking
> the vGIC and timer code to cope with the M1 braindead^Wamusing nature.
>
> Hardly any change this time around, mostly rebased on top of upstream
> now that the dependencies have made it in.
>
> Tested with multiple concurrent VMs running from an initramfs.
>
> * From v2:
>   - Rebased on 5.13-rc1
>   - Fixed a couple of nits in the GIC registration code
>
> * From v1 [1]:
>   - Rebased on Hector's v4 posting[0]
>   - Dropped a couple of patches that have been merged in the above series
>   - Fixed irq_ack callback on the timer path
>
> [0] https://lore.kernel.org/r/20210402090542.131194-1-marcan@marcan.st
> [1] https://lore.kernel.org/r/20210316174617.173033-1-maz@kernel.org
> [2] https://lore.kernel.org/r/20210403112931.1043452-1-maz@kernel.org

This looks interesting and I want to take a look. For now, I can only review the
series, but maybe at some point I'll take the leap and try to run Linux on my
Macbook Air.

Can I find something resembling a specification for the Apple interrupt
controller, or the only available documentation is in the Linux driver and patches
on the mailing list?

Thanks,

Alex

>
> Marc Zyngier (9):
>   irqchip/gic: Split vGIC probing information from the GIC code
>   KVM: arm64: Handle physical FIQ as an IRQ while running a guest
>   KVM: arm64: vgic: Be tolerant to the lack of maintenance interrupt
>   KVM: arm64: vgic: Let an interrupt controller advertise lack of HW
>     deactivation
>   KVM: arm64: vgic: move irq->get_input_level into an ops structure
>   KVM: arm64: vgic: Implement SW-driven deactivation
>   KVM: arm64: timer: Refactor IRQ configuration
>   KVM: arm64: timer: Add support for SW-based deactivation
>   irqchip/apple-aic: Advertise some level of vGICv3 compatibility
>
>  arch/arm64/kvm/arch_timer.c            | 161 +++++++++++++++++++++----
>  arch/arm64/kvm/hyp/hyp-entry.S         |   6 +-
>  arch/arm64/kvm/vgic/vgic-init.c        |  34 +++++-
>  arch/arm64/kvm/vgic/vgic-v2.c          |  19 ++-
>  arch/arm64/kvm/vgic/vgic-v3.c          |  19 ++-
>  arch/arm64/kvm/vgic/vgic.c             |  14 +--
>  drivers/irqchip/irq-apple-aic.c        |   8 ++
>  drivers/irqchip/irq-gic-common.c       |  13 --
>  drivers/irqchip/irq-gic-common.h       |   2 -
>  drivers/irqchip/irq-gic-v3.c           |   6 +-
>  drivers/irqchip/irq-gic.c              |   6 +-
>  include/kvm/arm_vgic.h                 |  41 +++++--
>  include/linux/irqchip/arm-gic-common.h |  25 +---
>  include/linux/irqchip/arm-vgic-info.h  |  43 +++++++
>  14 files changed, 291 insertions(+), 106 deletions(-)
>  create mode 100644 include/linux/irqchip/arm-vgic-info.h
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
