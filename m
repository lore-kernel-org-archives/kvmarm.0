From: Mario Smarduch <m.smarduch@samsung.com>
Subject: tlbi  va, vaa vs. val, vaal
Date: Thu, 26 Feb 2015 16:12:32 -0800
Message-ID: <54EFB670.2070501@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C580A46BD8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 19:07:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mXqN+wqjF8Zl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Feb 2015 19:07:04 -0500 (EST)
Received: from usmailout1.samsung.com (mailout1.w2.samsung.com
 [211.189.100.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B86646BCC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 19:07:03 -0500 (EST)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKE00K5YLXE57C0@mailout1.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 26 Feb 2015 19:12:50 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

I noticed kernel tlbflush.h use tlbi va*, vaa* variants instead of
val, vaal ones. Reading the manual D.5.7.2 it appears that
va*, vaa* versions invalidate intermediate caching of
translation structures.

With stage2 enabled that may result in 20+ memory lookups
for a 4 level page table walk. That's assuming that intermediate
caching structures cache mappings from stage1 table entry to
host page.

- Mario
