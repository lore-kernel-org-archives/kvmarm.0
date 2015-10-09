From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Fri, 09 Oct 2015 11:10:29 +0300
Message-ID: <00ec01d10269$f6c82af0$e45880d0$@samsung.com>
References: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org>
 <00e601d10264$61cdafb0$25690f10$@samsung.com> <56177592.2080702@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2373D41F30
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Oct 2015 04:08:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lVaFCVYTLC-7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Oct 2015 04:08:31 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 513D341457
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Oct 2015 04:08:30 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVY00EMM1DIY280@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 09 Oct 2015 09:10:30 +0100 (BST)
In-reply-to: <56177592.2080702@arm.com>
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
To: 'Marc Zyngier' <marc.zyngier@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: 'Andre Przywara' <andre.przywara@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> How do you reconcile the two? What's the point of trying to shoehorn a
> different concept into the existing API?

 Keeping amount of #define's as small as possible, and try to reuse everything that can be reused.
 It's just my personal taste, nothing serious. :) The question was just a clarification. Ok, this is
not a problem. By the way, i've just finished v5 patchset, now need to rewrite qemu and test before
posting it.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
