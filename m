Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC1BC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 31 Jan 2022 16:04:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44A384B1A9;
	Mon, 31 Jan 2022 11:04:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uvx6X4uoU-xm; Mon, 31 Jan 2022 11:04:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E45B4B1BA;
	Mon, 31 Jan 2022 11:04:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 606094B175
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jan 2022 11:04:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kja+8Sh+5SGt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jan 2022 11:04:39 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4ADB54A500
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jan 2022 11:04:39 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1A43361464
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jan 2022 16:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3184C340E8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jan 2022 16:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643645077;
 bh=wiO4ZRw1b6lmTh/6Zr4lNCCO143MzKfI73CvCo4t9g0=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=VuYcUinyVP4PwMfR0pjx7RHVlU6GA+2SVHtjpillF1M+1nKoRnYcwCfMRncXLZyXL
 WJaaOXpMcW0bDqxAQRQhTgOjEKNvHf9BR3ESydDQQ7F+qHnv+DS0H10TINCbwXHHDq
 r6ckXGsdRQKr69EOF2VkEncvQtpTiFNCXwoiC1CkA7EbLXF6vj2is0uSz6g5cjn/UG
 2yiSbBVqq5/zV5eDZnGYn3Kn8wKDQu8xF1nubHjEJZ9GoFQDO8+l2uWORH5ORML807
 AbfOGuZOCmQeGOdq5RaoaE532UEZ6EITxfSnMxAN035Tpv5pUki7lpytIL8eXpNU+1
 OynvC+XoEUXxw==
Received: by mail-wm1-f41.google.com with SMTP id
 l12-20020a7bc34c000000b003467c58cbdfso13993747wmj.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jan 2022 08:04:37 -0800 (PST)
X-Gm-Message-State: AOAM5332ylTnDizCxZypzkKgs7BiIADjBnm9uDitCthptWO0ZXazjdpS
 U04vXPvTMl+Qut90qgN51PZ+H1iXE5cU3Z2+s+g=
X-Google-Smtp-Source: ABdhPJyrC268GgYJ+693n0Flvtu/v6yIY2XkRh9X0P4iHuW1vA3wxV7WPlnD1Ke6ieXGc/oN7Kea0gsztKjxDpxWbh0=
X-Received: by 2002:a05:600c:4248:: with SMTP id
 r8mr19183690wmm.56.1643645076306; 
 Mon, 31 Jan 2022 08:04:36 -0800 (PST)
MIME-Version: 1.0
References: <20220131160242.2665191-1-maz@kernel.org>
In-Reply-To: <20220131160242.2665191-1-maz@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 31 Jan 2022 17:04:24 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHyxfe8E028OnN3Ac2PCC4HdyDdonHo785YTDjyXv=1qQ@mail.gmail.com>
Message-ID: <CAMj1kXHyxfe8E028OnN3Ac2PCC4HdyDdonHo785YTDjyXv=1qQ@mail.gmail.com>
Subject: Re: [PATCH][kvmtool] virtio/pci: Signal INTx interrupts as level
 instead of edge
To: Marc Zyngier <maz@kernel.org>
Cc: Pierre Gondois <pierre.gondois@arm.com>, Will Deacon <will@kernel.org>,
 Andre Przywara <andre.przywara@arm.com>, Sami Mujawar <sami.mujawar@arm.com>,
 Android Kernel Team <kernel-team@android.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Mon, 31 Jan 2022 at 17:03, Marc Zyngier <maz@kernel.org> wrote:
>
> It appears that the way INTx is emulated is "slightly" out of spec
> in kvmtool. We happily inject an edge interrupt, even if the spec
> mandates a level.
>
> This doesn't change much for either the guest or userspace (only
> KVM will have a bit more work tracking the EOI), but at least
> this is correct.
>
> Reported-by: Pierre Gondois <pierre.gondois@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Sami Mujawar <sami.mujawar@arm.com>
> Cc: Will Deacon <will@kernel.org>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  pci.c        | 2 +-
>  virtio/pci.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/pci.c b/pci.c
> index e5930331..a769ae27 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -61,7 +61,7 @@ int pci__assign_irq(struct pci_device_header *pci_hdr)
>         pci_hdr->irq_line       = irq__alloc_line();
>
>         if (!pci_hdr->irq_type)
> -               pci_hdr->irq_type = IRQ_TYPE_EDGE_RISING;
> +               pci_hdr->irq_type = IRQ_TYPE_LEVEL_HIGH;
>
>         return pci_hdr->irq_line;
>  }
> diff --git a/virtio/pci.c b/virtio/pci.c
> index 41085291..2777d1c8 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -413,7 +413,7 @@ int virtio_pci__signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq)
>                         kvm__irq_trigger(kvm, vpci->gsis[vq]);
>         } else {
>                 vpci->isr = VIRTIO_IRQ_HIGH;
> -               kvm__irq_trigger(kvm, vpci->legacy_irq_line);
> +               kvm__irq_line(kvm, vpci->legacy_irq_line, VIRTIO_IRQ_HIGH);
>         }
>         return 0;
>  }
> --
> 2.34.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
