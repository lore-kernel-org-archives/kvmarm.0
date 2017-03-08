From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/5] KVM: arm/arm64: fix some races and allow userspace
 to set MPIDR
Date: Wed, 8 Mar 2017 09:27:12 -0800
Message-ID: <20170308172712.GE109908@lvm>
References: <20170227175504.15751-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94838408EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 12:25:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id njdh2UZ+qiSk for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Mar 2017 12:25:52 -0500 (EST)
Received: from mail-wr0-f181.google.com (mail-wr0-f181.google.com
 [209.85.128.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBDC5405DA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 12:25:51 -0500 (EST)
Received: by mail-wr0-f181.google.com with SMTP id u108so28220340wrb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Mar 2017 09:27:15 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170227175504.15751-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, ashoks@broadcom.com, imammedo@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On Mon, Feb 27, 2017 at 06:54:59PM +0100, Andrew Jones wrote:
> This series fixes four races. Two are easy to produce with a
> kvm-unit-test test[1], but the other two would be quite hard. I
> didn't even try to produce those. The two hard to produce races are
> addressed by changing vcpu->arch.pause and vcpu->arch.power_off to
> vcpu requests. The two easy to produce races are addressed in two
> different ways: the first takes advantage of power_off having been
> changed to a vcpu request, the second caches vcpu MPIDRs in order
> to avoid extracting them from sys_regs. When introducing the MPIDR
> cache we also introduce a new feature (userspace settable MPIDRs).
> 
> Support for userspace settable MPIDRs was already posted once[2],
> but rejected due to not having a use case. We have one now, which
> is to satisfy QEMU's need for the MPDIR information very early,
> before vcpu-init has even run. While the original posting author
> wasn't me, I've taken authorship now, as I've changed the patch
> substantially. If anybody disagrees with that, then feel free to
> suggest alternatives. The QEMU counterpart has been posted[3].
> 
> This series is based on Radim's recent posting[4] that improves
> the vcpu-request framework. I've tested the series on a couple
> AArch64 platforms and compile-tested the arm bits.

So as we discussed during lunch today, it would be awesome if you could
split this up into a series that fixes the identified races and a
separate series for the introduction of supporting setting the MPIDR
from user space.

Thanks a lot!
-Christoffer
