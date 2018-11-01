From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: kvm-unit-tests gicv2 cases fail
Date: Thu, 1 Nov 2018 11:10:48 +0100
Message-ID: <20181101101048.GJ12057@e113682-lin.lund.arm.com>
References: <CAD8of+q29DrQa4Ay6karXC19vXzX++2T8FR-V1SAjGuO0ejYhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C80FE4A2EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Nov 2018 06:10:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9iG+u3rxwWXf for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Nov 2018 06:10:51 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F1CE4A236
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Nov 2018 06:10:51 -0400 (EDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 18, 2018 at 05:17:57PM +0800, Li Zhang wrote:
> Hi,
> 
> I run kvm-units-test on ARM server(QDF2400), but gicv2-ipi,
> gicv2-active cases fail.

I didn't think QDF2400 has GICv2 on GICv3 support?

Do the test cases fail or are they reported as skipped?

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
> 

I don't think you need to care.  I believe Marc has run the
GICv2-on-GICv3 tests on his supported platforms with recent
kvm-unit-tests and other have reported succes as well.


Thanks,

    Christoffer
