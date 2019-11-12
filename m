Return-Path: <SRS0=CLkw=ZE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE3BC43331
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 16:51:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDE062196E
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 16:51:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDE062196E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AB5D4B1B3;
	Tue, 12 Nov 2019 11:51:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o9j67dEWU+BX; Tue, 12 Nov 2019 11:51:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35CF14B13B;
	Tue, 12 Nov 2019 11:51:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26A594B10C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 11:51:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4SKAdFgP5Qm2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Nov 2019 11:51:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 038794B0ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 11:51:06 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DDF730E;
 Tue, 12 Nov 2019 08:51:06 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B1C83F534;
 Tue, 12 Nov 2019 08:51:05 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 10/17] arm: gic: Check for writable IGROUPR
 registers
To: Andre Przywara <andre.przywara@arm.com>, Andrew Jones
 <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-11-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <30e68410-9ed4-91db-df2e-60272d4cd877@arm.com>
Date: Tue, 12 Nov 2019 16:51:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-11-andre.przywara@arm.com>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

Hi,

On 11/8/19 2:42 PM, Andre Przywara wrote:
> When both groups are avaiable to the non-secure side, the MMIO group
> registers need to be writable, so that the group that an IRQ belongs to
> can be programmed.
>
> Check that the group can be flipped, after having established that both
> groups are usable.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/arm/gic.c b/arm/gic.c
> index c882a24..485ca4f 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -683,6 +683,7 @@ static bool gicv3_check_security(void *gicd_base)
>  static void test_irq_group(void *gicd_base)
>  {
>  	bool is_gicv3 = (gic_version() == 3);
> +	u32 reg;

The return value for gic_get_irq_group is an int, not a u32. Also, maybe it should
be named group instead, so it's clear what it represents.

>  
>  	report_prefix_push("GROUP");
>  	gic_enable_defaults();
> @@ -692,6 +693,16 @@ static void test_irq_group(void *gicd_base)
>  		if (!gicv3_check_security(gicd_base))
>  			return;
>  	}
> +
> +	/*
> +	 * On a security aware GIC in non-secure world the IGROUPR registers
> +	 * are RAZ/WI. KVM emulates a single-security-state GIC, so both
> +	 * groups are available and the IGROUPR registers are writable.
> +	 */
> +	reg = gic_get_irq_group(SPI_IRQ);
> +	gic_set_irq_group(SPI_IRQ, !reg);
> +	report("IGROUPR is writable", gic_get_irq_group(SPI_IRQ) != reg);

This is nitpicking, but from a consistency point of view, shouldn't you check that
the new group is the value that you wrote, meaning the check should be
gic_get_irq_group(SPI_IRQ) == !reg?

Thanks,
Alex
> +	gic_set_irq_group(SPI_IRQ, reg);
>  }
>  
>  static void spi_send(void)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
