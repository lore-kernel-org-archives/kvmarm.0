From: Li Zhang <zhlcindy@gmail.com>
Subject: kvm-unit-tests gicv2 cases fail
Date: Thu, 18 Oct 2018 17:17:57 +0800
Message-ID: <CAD8of+q29DrQa4Ay6karXC19vXzX++2T8FR-V1SAjGuO0ejYhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41FA54A1FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Oct 2018 05:18:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5LhZPAVaZa+c for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Oct 2018 05:18:31 -0400 (EDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com
 [209.85.219.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70F2F49F93
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Oct 2018 05:18:31 -0400 (EDT)
Received: by mail-yb1-f181.google.com with SMTP id x5-v6so11544685ybl.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Oct 2018 02:18:31 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I run kvm-units-test on ARM server(QDF2400), but gicv2-ipi,
gicv2-active cases fail.
By debuging kvm-unit-tests source code, I found that interrupt is not
handled. do_handle_exception is not called.

By looking into KVM source code, it has GICv2 emulation on GICv3 support.
I've tried a lot of kernel versions, from v4.12~v4.19 in mainline,
these cases always fail.
Is it possible that hardware/software disables this?

It seems that GICv2 is a little old for ARM server, I am confused when
we can use it.
Do we need to care about these cases?

--

Best Regards
-Li
