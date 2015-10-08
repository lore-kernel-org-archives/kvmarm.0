From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Thu, 08 Oct 2015 15:28:40 +0300
Message-ID: <009501d101c4$dde8e2e0$99baa8a0$@samsung.com>
References: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org>
 <003a01d10199$58e96590$0abc30b0$@samsung.com> <20151008082302.GE14315@cbox>
 <005e01d101a9$31ee80f0$95cb82d0$@samsung.com> <20151008092858.GA16100@cbox>
 <561641F5.4060202@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 700CC41300
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 08:26:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uPNWfKSJmkbh for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Oct 2015 08:26:45 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E16A412FA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 08:26:45 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVW00D1UINUAR70@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 08 Oct 2015 13:28:42 +0100 (BST)
In-reply-to: <561641F5.4060202@arm.com>
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
To: 'Marc Zyngier' <marc.zyngier@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, 'Andre Przywara' <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Well, compatibility with GICv2 is the biggest mistake we made when
> designing the GICv3 architecture. And that's why our emulation doesn't
> give a damn about v2 compatibility.

 Ok, i see your arguments, and after that it becomes a matter of personal taste. Three beat one, i
go your way. :) Don't know if i'll be able to roll out v5 tomorrow, but i think on monday i'll
definitely do.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
