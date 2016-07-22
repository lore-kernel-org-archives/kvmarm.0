From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PULL] KVM/ARM updates for Linux 4.8, take #1
Date: Fri, 22 Jul 2016 21:50:17 +0200
Message-ID: <20160722195016.GD9019@potion>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BB7149B7B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 15:44:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X5s5VxLrb7Af for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 15:44:05 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C85249B76
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 15:44:04 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: kvmarm@lists.cs.columbia.edu

2016-07-22 18:28+0100, Marc Zyngier:
> Paolo, Radim,
> 
> Please find below the first batch of 4.8 updates for KVM/ARM. Biggest
> feature is the long awaited GICv3 ITS emulation, allowing MSIs to be
> delivered into guests running on GICv3 HW. The other big feature is
> the removal of the old vgic implementation. Less visible is the revamp
> of the way we deal with the HYP initialization (by keeping an idmap
> around), and making HYP page tables honor the kernel's own protection.
> 
> This may generate a few conflicts, all of which have been seen in
> -next. 3 which are KVM specific (and pretty easy to resolve), and
> another one in include/irqchip/arm-gic-v3.h. They should be resolved
> as in -next.
> 
> Please pull!

Pulled into kvm/next, KVM_CAP_MSI_DEVID is 131.

>  54 files changed, 2698 insertions(+), 6065 deletions(-)

<3
