From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2] arm64: KVM: VHE: Context switch MDSCR_EL1
Date: Thu, 21 Jul 2016 15:17:20 +0200
Message-ID: <20160721131720.GA32739@potion>
References: <1468933014-26966-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8FFE49B36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2016 09:11:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mkYrBRrpp4uN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2016 09:11:11 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9485449B2E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2016 09:11:11 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1468933014-26966-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

2016-07-19 13:56+0100, Marc Zyngier:
> The kprobe enablement work has uncovered that changes made by
> a guest to MDSCR_EL1 were propagated to the host when VHE was
> enabled, leading to unexpected exception being delivered.
> 
> Moving this register to the list of registers that are always
> context-switched fixes the issue.
> 
> Fixes: 9c6c35683286 ("arm64: KVM: VHE: Split save/restore of registers shared between guest and host")
> Cc: stable@vger.kernel.org #4.6
> Reported-by: Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com>
> Tested-by: Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---

I would take this patch to 4.7 directly through the main tree.
Are your plans different?

Thanks.
