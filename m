From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Tue, 07 Jul 2015 13:57:51 +0300
Message-ID: <023301d0b8a3$c5a30680$50e91380$@samsung.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com> <5596503E.6040902@arm.com>
 <00fd01d0b7b6$f6cf3550$e46d9ff0$@samsung.com> <559A3C9C.6050302@arm.com>
 <20150706093026.GA11590@cbox> <559A52E6.5050402@arm.com>
 <20150706103755.GC11590@cbox> <559A6164.1000401@redhat.com>
 <559A6527.1040107@arm.com> <559A6BBC.2040901@redhat.com>
 <024301d0b7f0$2b13b410$813b1c30$@samsung.com> <559AA0D6.7070703@arm.com>
 <014c01d0b884$deff46d0$9cfdd470$@samsung.com> <559BA3BD.60404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0248057DEC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 06:46:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jeHle3vz5A1Y for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2015 06:46:24 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D665A57DE1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 06:46:24 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NR400FV26GHWU80@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 07 Jul 2015 11:57:53 +0100 (BST)
In-reply-to: <559BA3BD.60404@arm.com>
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
To: 'Andre Przywara' <andre.przywara@arm.com>, 'Paolo Bonzini' <pbonzini@redhat.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: eric.auger@st.com, kvm@vger.kernel.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

> I just don't want to end up with something like:
> (GICV3 && ARM64) || (GICV3 && ARM && KERNEL>4.4) || (SuperIRQC && i986)
> or
> (ARM || ARM64) && HAS_IRQ_ROUTING
> 
> Instead: If the kernel needs it, it tells you. Full stop.

 Agree.

> To be honest it's me to blame here to not having introduced the
> capability earlier. At the moment ARM has a different code path for
> KVM_SIGNAL_MSI, which does not bail out if the flag field is set. With
> Eric's patches this changes and we use the irqchip.c generic code, which
> returns -EINVAL atm. So I plan to introduce this capability already with
> the ITS emulation series, so we can just pick it up in the IRQ routing
> series.

 Then may be you follow https://lkml.org/lkml/2015/7/7/115 and replace flag with something like
KVM_SIGNAL_EXT_MSI ioctl ? After all you were one of people who voted against using flags.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
