From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2] KVM: arm/arm64: BUG FIX: Do not inject spurious
 interrupts
Date: Fri, 09 Oct 2015 17:41:11 +0300
Message-ID: <01b701d102a0$8b19c5c0$a14d5140$@samsung.com>
References: <1443189629-8744-1-git-send-email-p.fedin@samsung.com>
 <20150929072518.GC9002@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B25141390
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Oct 2015 10:39:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C+V69WtetVcc for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Oct 2015 10:39:12 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 836B741300
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Oct 2015 10:39:11 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVY00M5RJGO1J70@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 09 Oct 2015 15:41:12 +0100 (BST)
In-reply-to: <20150929072518.GC9002@cbox>
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
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I reworked the commit message and applied this patch.

 During testing i discovered a problem with this patch and vITS series by Andre.
 The problem is that compute_pending_for_cpu() does not know anything about LPIs. Therefore, we can
reset this bit even if some LPIs (and only LPIs) are pending. This causes LPI loss.
 This is the confirmation of that clearing irq_pending_on_cpu anywhere else than
__kvm_vgic_flush_hwstate() is a bad idea. I would suggest to stick back to v1 of the patch (without
clearing this bit). We can add a clarifying description to the commit message like this:

--- cut ---
In some situations level-sensitive IRQ disappears before it has been
processed. This is normal, and in this situation we lose this IRQ, the same
as real HW does. The aim of this patch is to handle this situation more
correctly. However, dist->irq_pending_on_cpu stays set until the vCPU
itself rechecks its status. Therefore, this bit does not guarantee that
something is pending at the given moment, it should be treated as attention
flag, saying that something has happened on this vCPU, and it could have
been even gone since that, but wakeup and status recheck is needed.
--- cut ---

 Would you be happy with this? An alternative would be to add a check for pending LPIs, but wouldn't
it just be too complex for a simple problem?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
