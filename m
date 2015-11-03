From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v4 0/3] KVM: arm/arm64: Clean up some obsolete code
Date: Tue, 03 Nov 2015 12:44:54 +0300
Message-ID: <002501d1161c$4c92f5d0$e5b8e170$@samsung.com>
References: <cover.1445934536.git.p.fedin@samsung.com>
 <20151102211538.GA5819@cbox> <005201d11608$a73edf80$f5bc9e80$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D81F14985B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 04:41:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EOlcpdKmWo22 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2015 04:41:50 -0500 (EST)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 985F349840
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 04:41:50 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NX8007ZLGEX3610@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 03 Nov 2015 09:44:57 +0000 (GMT)
In-reply-to: <005201d11608$a73edf80$f5bc9e80$@samsung.com>
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

>  By this time i'll make a very minimal version of patch 0001, for you to test it. If we have
> problems with current 0001, which we
> cannot solve quickly, we could stick to that version then, which will provide the necessary
> changes to plug in LPIs, yet with
> minimal changes (it will only remove vgic_irq_lr_map).
>  I guess i should have done it before. Or, i could even respin v5, with current 0001 split up.
> This should make it easier to bisect
> the problem.

 So, i have just sent v5, conditions are the same as before. It is OK to stop at any point, and actually you should be able to
easily throw away 0003 and apply just 1, 2, 4. The minimum needed thing for LPIs introduction is 0001.
 You can also stick to v4 if the problem does not get triggered by its first patch, if you prefer reduced commit log.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
