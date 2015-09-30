From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2] KVM: arm/arm64: BUG FIX: Do not inject spurious
 interrupts
Date: Wed, 30 Sep 2015 13:24:12 +0300
Message-ID: <026c01d0fb6a$2701d100$75057300$@samsung.com>
References: <1443189629-8744-1-git-send-email-p.fedin@samsung.com>
 <20150929072518.GC9002@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB33E41049
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 06:22:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uhh7k9eAzqGv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2015 06:22:39 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E82FF40FB5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 06:22:38 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVH00FDNJKDWJ40@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 30 Sep 2015 11:24:13 +0100 (BST)
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
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I reworked the commit message and applied this patch.

 Thank you very much.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
