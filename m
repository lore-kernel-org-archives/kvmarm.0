Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99557C64E7B
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 16:37:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BBA2F20691
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 16:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MhFrPsJf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBA2F20691
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E896A4C27F;
	Tue,  1 Dec 2020 11:37:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DoV3VIJCJ36d; Tue,  1 Dec 2020 11:37:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC43C4C269;
	Tue,  1 Dec 2020 11:37:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93AB74C264
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 11:37:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9hvo0cr4tyV9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 11:37:21 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DAF04C238
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 11:37:21 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1606840641;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Yf2+yvwSxhBGm/bSuBR8fGgsM6o+l4r46kvMPzsQn7k=;
 b=MhFrPsJf0HW5DsQdSJ7X067FVDQLl2A+VRxXWnnXJ2oZNEPcvbuvNHAfV0Q32uIM0KlyKZ
 BvP8hUO/+JKaU/FDV/ftRbIhdclrG8HsiBzdZoiPhdWVWxFMaaJ63THpiYXInU+Ahy+zPy
 Qsp98Al37HsnZqKRCL48kHkjOyc08Kg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-NuVz9-rUN0-4Ip9mcOqaCQ-1; Tue, 01 Dec 2020 11:37:19 -0500
X-MC-Unique: NuVz9-rUN0-4Ip9mcOqaCQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 165318030D4;
 Tue,  1 Dec 2020 16:37:18 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C593819C44;
 Tue,  1 Dec 2020 16:37:16 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 03/10] arm/arm64: gic: Remove memory
 synchronization from ipi_clear_active_handler()
To: Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, drjones@redhat.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-4-alexandru.elisei@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <038402be-a119-c162-04f2-d32db26e8a96@redhat.com>
Date: Tue, 1 Dec 2020 17:37:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201125155113.192079-4-alexandru.elisei@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: andre.przywara@arm.com
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

Hi Alexandru,

On 11/25/20 4:51 PM, Alexandru Elisei wrote:
> The gicv{2,3}-active test sends an IPI from the boot CPU to itself, then
> checks that the interrupt has been received as expected. There is no need
> to use inter-processor memory synchronization primitives on code that runs
> on the same CPU, so remove the unneeded memory barriers.
> 
> The arrays are modified asynchronously (in the interrupt handler) and it is
> possible for the compiler to infer that they won't be changed during normal
> program flow and try to perform harmful optimizations (like stashing a
> previous read in a register and reusing it). To prevent this, for GICv2,
> the smp_wmb() in gicv2_ipi_send_self() is replaced with a compiler barrier.
> For GICv3, the wmb() barrier in gic_ipi_send_single() already implies a
> compiler barrier.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/gic.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 401ffafe4299..4e947e8516a2 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -12,6 +12,7 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  #include <libcflat.h>
> +#include <linux/compiler.h>
>  #include <errata.h>
>  #include <asm/setup.h>
>  #include <asm/processor.h>
> @@ -260,7 +261,8 @@ static void check_lpi_hits(int *expected, const char *msg)
>  
>  static void gicv2_ipi_send_self(void)
>  {> -	smp_wmb();
nit: previous patch added it and this patch removes it. maybe squash the
modifs into the previous patch saying only a barrier() is needed for self()?
> +	/* Prevent the compiler from optimizing memory accesses */
> +	barrier();
>  	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
>  }
>  
> @@ -359,6 +361,7 @@ static struct gic gicv3 = {
>  	},
>  };
>  
> +/* Runs on the same CPU as the sender, no need for memory synchronization */
>  static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>  {
>  	u32 irqstat = gic_read_iar();
> @@ -375,13 +378,10 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>  
>  		writel(val, base + GICD_ICACTIVER);
>  
> -		smp_rmb(); /* pairs with wmb in stats_reset */
the comment says it is paired with wmd in stats_reset. So is it OK to
leave the associated wmb?
>  		++acked[smp_processor_id()];
>  		check_irqnr(irqnr);
> -		smp_wmb(); /* pairs with rmb in check_acked */
same here.
>  	} else {
>  		++spurious[smp_processor_id()];
> -		smp_wmb();
>  	}
>  }
>  
> 
Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
