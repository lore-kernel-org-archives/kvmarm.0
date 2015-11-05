From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v4 0/3] KVM: arm/arm64: Clean up some obsolete code
Date: Thu, 05 Nov 2015 09:50:44 +0300
Message-ID: <01d001d11796$4c1c4770$e454d650$@samsung.com>
References: <cover.1445934536.git.p.fedin@samsung.com>
 <20151102211538.GA5819@cbox> <005201d11608$a73edf80$f5bc9e80$@samsung.com>
 <002501d1161c$4c92f5d0$e5b8e170$@samsung.com> <20151104142926.GA20230@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBCA7498B2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2015 01:47:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TFQY5lhXiz1R for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2015 01:47:34 -0500 (EST)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA3CF497BD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2015 01:47:34 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NXB0019IXOMIC40@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 05 Nov 2015 06:50:46 +0000 (GMT)
In-reply-to: <20151104142926.GA20230@cbox>
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
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Actually, I seem to have been just incredibly unlucky with my test
> cycles, because I eventually reproduced the bug without your patches.

 Or lucky, without "un" :)

> I'm going to take this version of the series because that's what I
> reviewed and tested.

 It's OK, as i wrote, v5 is no different from v4 actually, just 0001 bisected. And making it was useful because it helped me to make
sure once again that i haven't messed anything up.

> Sorry for the noise.

 It's OK, thank you very much for putting efforts into testing and cooperation.
 You know, since we are talking about this...  This definitely has something to do with the reset, and... Looks like nobody resets
vGIC/vTimer, unless the userland does it explicitly by resetting every register by hand.
 I know, there is no global "reset" function for the whole VM. But, at least we have reset ioctl for vCPU. What if we hook up
vGIC/vTimer there, and reset at least per-CPU objects (CPU interface + redist + timer) at this point?

 P.S. I've seen your PULL, and it is missing a little thing that could be good for 4.4 too. I've fixed one more bug recently, it
reproduces on CP15-timer-less boards like Exynos: http://www.spinics.net/lists/kvm/msg122746.html. Just to make sure that you don't
miss it.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
