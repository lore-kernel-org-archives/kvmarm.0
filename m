From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [RFC 0/6] KVM: arm/arm64: gsi routing support
Date: Wed, 24 Jun 2015 15:20:33 +0300
Message-ID: <01b901d0ae78$2bed39a0$83c7ace0$@samsung.com>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
 <5587CA18.6050101@arm.com> <5587D398.8040002@linaro.org>
 <558920F7.9090301@arm.com> <558956E4.2050700@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9630956CC7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 08:09:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FtcBCmC8KXWo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2015 08:09:41 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A7A5556CC5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 08:09:40 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQG00EHW7MBHI00@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 24 Jun 2015 13:20:35 +0100 (BST)
In-reply-to: <558956E4.2050700@linaro.org>
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
To: 'Eric Auger' <eric.auger@linaro.org>, 'Andre Przywara' <andre.przywara@arm.com>, eric.auger@st.com
Cc: 'Marc Zyngier' <Marc.Zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> What I can simply do is preventing any non identity mapping for irqchip
> routing entries, ie. gsi != irqchip.pin. This fixes the problem of
> KVM_IRQ_LINE. This check can happen in arm kvm_set_routing_entry() and
> that's it.

 You cannot fix problem of KVM_IRQ_LINE because anyway with this ioctl on ARM you should OR your
value with (1 << 24), so this is actually not plain GSI any more.
 KVM_IRQ_LINE is never used for triggering MSIs, so i think the easiest thing to do is to just leave
it doing what it does.

 As to irqchip routing of irqfd's, why not? By default all GSIs would be SPIs, then this can be
changed by userspace, or reverted back... Who cares? When using direct mapping qemu never calls
routing functions, so it's OK.


Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
