From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 2/2] Detect vGIC presence at runtime
Date: Thu, 09 Jul 2015 15:50:49 +0300
Message-ID: <01b401d0ba45$e23be430$a6b3ac90$@samsung.com>
References: <cover.1436264839.git.p.fedin@samsung.com>
 <8f44081ef96f51c6f2a5753e5933d7de1e3c2c2f.1436264839.git.p.fedin@samsung.com>
 <20150709113721.GJ13530@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1213B58374
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 08:39:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3-4FiuhGQ52p for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 08:39:19 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E01CA58373
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 08:39:18 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NR800EMZ10Q3G50@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 09 Jul 2015 13:50:50 +0100 (BST)
In-reply-to: <20150709113721.GJ13530@cbox>
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

> why not report ENXIO as an error?  If probing the vgic fails due to
> being unable to request the irq or something similar, then surely your
> system has and error and this should be reported.

 It is reported by probe function itself.
 -ENODEV here means there's no GIC at all. -ENXIO happens when, for example, there is GIC node in
the device tree, but it does not specify vGIC resources. Normally this means that vGIC is defunct on
the machine.

> This may be more nicely implemented by letting the vgic init/probe
> functions set the vgic_present, or maybe better yet, just export a
> function from vgic.c:
> 
> bool kvm_vgic_present(void)
> {
> 	return vgic_ops != NULL;
> }

 Is it necessary? Actually this flag is not needed anywhere else except arch/arm/kvm/arm.c, only at
init time. Runtime should, i believe, use irqchip_in_kernel(), because userland can choose just not
to use vGIC for some reason (testing for example).

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
