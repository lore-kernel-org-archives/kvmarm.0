From: Andrew Jones <drjones@redhat.com>
Subject: Re: kvm-unit-tests gicv2 cases fail
Date: Thu, 18 Oct 2018 22:25:57 -0500
Message-ID: <20181019032557.h2je3v7frp7nnnj4@kamzik.brq.redhat.com>
References: <CAD8of+q29DrQa4Ay6karXC19vXzX++2T8FR-V1SAjGuO0ejYhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D17824A20D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Oct 2018 23:26:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q5vF8gVQc-UR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Oct 2018 23:26:08 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02E3449F93
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Oct 2018 23:26:07 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAD8of+q29DrQa4Ay6karXC19vXzX++2T8FR-V1SAjGuO0ejYhQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Li Zhang <zhlcindy@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 18, 2018 at 05:17:57PM +0800, Li Zhang wrote:
> Hi,
> 
> I run kvm-units-test on ARM server(QDF2400), but gicv2-ipi,
> gicv2-active cases fail.
> By debuging kvm-unit-tests source code, I found that interrupt is not
> handled. do_handle_exception is not called.
> 
> By looking into KVM source code, it has GICv2 emulation on GICv3 support.
> I've tried a lot of kernel versions, from v4.12~v4.19 in mainline,
> these cases always fail.
> Is it possible that hardware/software disables this?
> 
> It seems that GICv2 is a little old for ARM server, I am confused when
> we can use it.
> Do we need to care about these cases?

We care, but I haven't seen these issues, and, if this only reproduces on
a gicv2 emulation on gicv3 configuration, then I don't have any hardware
where I can reproduce/debug it.

Thanks,
drew
