From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: fix reference to uninitialised VGIC
Date: Thu, 04 Feb 2016 10:36:10 +0300
Message-ID: <009701d15f1e$b8398510$28ac8f30$@samsung.com>
References: <1454518611-15694-1-git-send-email-andre.przywara@arm.com>
 <56B23A02.7070804@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C64CB4130A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 02:30:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EmiEWLgvg4gD for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2016 02:30:46 -0500 (EST)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD701412F3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 02:30:46 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0O20007HRIGB2J90@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 04 Feb 2016 07:36:12 +0000 (GMT)
In-reply-to: <56B23A02.7070804@arm.com>
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
To: 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, 'Cosmin Gorgovan' <cosmin@linux-geek.org>, kvmarm@lists.cs.columbia.edu, stable@vger.kernel.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > Fix this by bailing out early of kvm_timer_flush_hwstate() if we don't
> > have a VGIC at all.
> >
> > Reported-by: Cosmin Gorgovan <cosmin@linux-geek.org>
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > Cc: <stable@vger.kernel.org> # 4.4.x
> 
> Nice catch, thanks.

 Can you check this: http://www.spinics.net/lists/kvm/msg124540.html ? It also should fix this issue. Just omit the very first hunk
from it, if you don't want to apply the whole set.


Kind regards,
Pavel Fedin
Senior Engineer
Samsung Electronics Research center Russia
