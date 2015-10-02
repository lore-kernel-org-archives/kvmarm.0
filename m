From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 01/15] KVM: arm/arm64: VGIC: don't track used LRs in the
 distributor
Date: Fri, 02 Oct 2015 12:55:05 +0300
Message-ID: <00cb01d0fcf8$6a906000$3fb12000$@samsung.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-2-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4DB141294
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 05:53:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JzVDJQmXybcE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2015 05:53:26 -0400 (EDT)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FCB241291
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 05:53:25 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVL00LPR7JUZX40@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 02 Oct 2015 10:55:06 +0100 (BST)
In-reply-to: <1436538111-4294-2-git-send-email-andre.przywara@arm.com>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Andre Przywara' <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello! One more concern.

> Currently we track which IRQ has been mapped to which VGIC list
> register and also have to synchronize both. We used to do this
> to hold some extra state (for instance the active bit).
> It turns out that this extra state in the LRs is no longer needed and
> this extra tracking causes some pain later.

 Returning to the beginning, can you explain, what kind of pain exactly does it bring?
 For some reasons here i had to keep all this tracking mechanism, and modified your patchset. I see
no significant problems, except memory usage. I have to allocate vgic_irq_lr_map large enough to
hold indexes up to 16384, and indexes from dist->nr_irqs to 8192 appear to be not used.
 Since the map itself is actually used only for piggy-back optimization, it is possible to easily
get rid of it using for_each_set_bit(lr, vgic_cpu->lr_used, vgic->nr_lr) iteration instead. The rest
of mechanism will work as it is, there's no need to remove the state tracking bitmap and
optimization itself.
 I am currently testing this approach and preparing my alternative patch for upstreaming.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
