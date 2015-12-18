From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v6] arm/arm64: KVM: Detect vGIC presence at runtime
Date: Fri, 18 Dec 2015 14:33:24 +0300
Message-ID: <01ab01d13987$e8ba80c0$ba2f8240$@samsung.com>
References: <1448968304-10128-1-git-send-email-p.fedin@samsung.com>
 <20151218112716.GE32720@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 102DC49731
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2015 06:31:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TE0t0Rd8B+xM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Dec 2015 06:31:01 -0500 (EST)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36612412E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2015 06:31:00 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NZJ00FT1XFQ6B30@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 18 Dec 2015 11:33:26 +0000 (GMT)
In-reply-to: <20151218112716.GE32720@cbox>
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
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > This patch does not touch any virtual timer code, suggesting that timer
> > hardware is actually in place. Normally on boards in question it is true,
> > however since vGIC is missing, it is impossible to correctly utilize
> > interrupts from the virtual timer. Since virtual timer handling is in
> > active redevelopment now, handling in it userspace is out of scope at
> > the moment. The guest is currently suggested to use some memory-mapped
> > timer which can be emulated in userspace.
> 
> Not sure I understand this paragraph.  Either drop it or just say "The
> architectured timers are not supported without the in-kernel vGIC."

 Ok, i'll repost with changed message. But, just to let you know, with this (http://www.spinics.net/lists/kvm/msg124539.html) the
notice about architected timer loses its relevancy at all. So, i'll just drop it.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
