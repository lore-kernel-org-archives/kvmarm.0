From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v4 0/4] KVM: arm64: BUG FIX: Correctly handle zero register
 transfers
Date: Mon, 07 Dec 2015 11:36:28 +0300
Message-ID: <011601d130ca$64cc9070$2e65b150$@samsung.com>
References: <cover.1449230499.git.p.fedin@samsung.com>
 <20151205003334.GB3117@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7ABD419D1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 03:34:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a-+d1PcZjt6e for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2015 03:34:58 -0500 (EST)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16A5140FA6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 03:34:57 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYZ004XDBX5AL40@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 07 Dec 2015 08:36:41 +0000 (GMT)
In-reply-to: <20151205003334.GB3117@hawk.localdomain>
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
To: 'Andrew Jones' <drjones@redhat.com>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> FYI, I tried writing test cases for this issue with kvm-unit-tests. The
> issue didn't reproduce for me. It's quite possible my test cases are
> flawed, so I'm not making any claims about the validity of the series

 This is indeed very interesting, so i'll take a look at it.
 For now i've just only took a quick glance at the code, and i have at least one suggestion. Could you happen to have sp == 0 in
check_xzr_sysreg()? In this case it will magically work.
 Also, you could try to write a test which tries to overwrite xzr. Something like:

volatile int *addr1;
volatile int *addr2;

asm volatile("str %3, [%1]\n\t"
             "ldr wzr, [%1]\n\t"
             "str wzr, [%2]\n\t",
             "ldr %0, [%2]\n\t"
             :"=r"(res):"r"(addr1), "r"(addr2), "r"(some_nonzero_val):"memory");

 Then check for res == some_nonzero_val. If they are equal, you've got the bug :)

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
