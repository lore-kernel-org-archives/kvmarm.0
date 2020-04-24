Return-Path: <SRS0=H2W4=6I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A3DC2BA1A
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 08:41:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD7E020728
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 08:41:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nx1BPylM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD7E020728
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 653254B187;
	Fri, 24 Apr 2020 04:41:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pJxmYlPByiaX; Fri, 24 Apr 2020 04:41:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 296BA4B1BB;
	Fri, 24 Apr 2020 04:41:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B68754B187
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 04:41:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lqoBrjP6IMBx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2020 04:41:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD4E54B185
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 04:41:10 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 89F2220728;
 Fri, 24 Apr 2020 08:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587717669;
 bh=oZe8ljfxPGxN1bDhlz9zeRGuvpzrhShXdGSjTaCbdcg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Nx1BPylMgb/sh/adC2mC0DATtR2+IDk+9KVESKE1cX27VP2maygL7IDwNfoK/t2ff
 fje776J+Zitqo16kU6UeXA60Wtckmd0UsQOw9dEWlfLYpC25EXnxDAFfQ0xMmg6hwh
 jCTngLq1HY029jEgkvyDf8U4W8Ekk3zjiQ3bqKjw=
Date: Fri, 24 Apr 2020 09:41:05 +0100
From: Will Deacon <will@kernel.org>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool v4 1/5] virtio-mmio: Assign IRQ line directly
 before registering device
Message-ID: <20200424084104.GB20801@willie-the-truck>
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <20200423173844.24220-2-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200423173844.24220-2-andre.przywara@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Raphael Gault <raphael.gault@arm.com>, Sami Mujawar <sami.mujawar@arm.com>,
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

On Thu, Apr 23, 2020 at 06:38:40PM +0100, Andre Przywara wrote:
> At the moment the IRQ line for a virtio-mmio device is assigned in the
> generic device__register() routine in devices.c, by calling back into
> virtio-mmio.c. This does not only sound slightly convoluted, but also
> breaks when we try to register an MMIO device that is not a virtio-mmio
> device. In this case container_of will return a bogus pointer (as it
> assumes a struct virtio_mmio), and the IRQ allocation routine will
> corrupt some data in the device_header (for instance the first byte
> of the "data" pointer).
> 
> Simply assign the IRQ directly in virtio_mmio_init(), before calling
> device__register(). This avoids the problem and looks actually much more
> straightforward.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  devices.c                 |  4 ----
>  include/kvm/virtio-mmio.h |  1 -
>  virtio/mmio.c             | 10 ++--------
>  3 files changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/devices.c b/devices.c
> index a7c666a7..2c8b2665 100644
> --- a/devices.c
> +++ b/devices.c
> @@ -1,7 +1,6 @@
>  #include "kvm/devices.h"
>  #include "kvm/kvm.h"
>  #include "kvm/pci.h"
> -#include "kvm/virtio-mmio.h"
>  
>  #include <linux/err.h>
>  #include <linux/rbtree.h>
> @@ -33,9 +32,6 @@ int device__register(struct device_header *dev)
>  	case DEVICE_BUS_PCI:
>  		pci__assign_irq(dev);
>  		break;
> -	case DEVICE_BUS_MMIO:
> -		virtio_mmio_assign_irq(dev);
> -		break;

Hmm, but then it's a bit ugly to handle these differently to PCI. How
difficult is it to add a new bus type instead? e.g. stick the virtio mmio
devices on DEVICE_BUS_VIRTIO_MMIO and then add the non-virtio MMIO devices
to DEVICE_BUS_MMIO?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
