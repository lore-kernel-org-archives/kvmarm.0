From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 0/4] KVM: arm64: Increase number of user memslots
Date: Thu, 9 Mar 2017 00:53:26 -0800
Message-ID: <20170309085326.GA114347@lvm>
References: <1488953315-22375-1-git-send-email-linucherian@gmail.com>
 <87zigux4i3.fsf@on-the-bus.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBE0C40962
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 03:52:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IISJdrTCsbuV for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 03:52:07 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50A9240905
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 03:52:06 -0500 (EST)
Received: by mail-wm0-f52.google.com with SMTP id n11so50320005wma.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Mar 2017 00:53:32 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <87zigux4i3.fsf@on-the-bus.cambridge.arm.com>
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
Cc: sunil.goutham@cavium.com, linucherian@gmail.com, Linu Cherian <linu.cherian@cavium.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 09, 2017 at 08:01:56AM +0000, Marc Zyngier wrote:
> On Wed, Mar 08 2017 at  6:08:31 am GMT, linucherian@gmail.com wrote:
> > From: Linu Cherian <linu.cherian@cavium.com>
> >
> > v3 -> v4:
> > - Add missing commit messages in patches 1 and 3
> >
> > v2 -> v3:
> > - Added documentation for KVM_CAP_NR_MEMSLOTS
> > - Removed KVM_PRIVATE_MEM_SLOTS which is unused
> > - KVM_USER_MEM_SLOTS changed to 512 from 508
> >  
> > v1 -> v2:
> > - Enabling KVM_CAP_NR_MEMSLOTS for arm/arm64 moved to separate patch.
> > - Updated commit message so that what is reported to userspace is explicit.
> >
> >
> > Linu Cherian (4):
> >   KVM: Add documentation for KVM_CAP_NR_MEMSLOTS
> >   KVM: arm/arm64: Enable KVM_CAP_NR_MEMSLOTS on arm/arm64
> >   KVM: arm/arm64: Remove KVM_PRIVATE_MEM_SLOTS definition that are
> >     unused
> >   KVM: arm64: Increase number of user memslots to 512
> >
> >  Documentation/virtual/kvm/api.txt | 4 ++++
> >  arch/arm/include/asm/kvm_host.h   | 1 -
> >  arch/arm/kvm/arm.c                | 3 +++
> >  arch/arm64/include/asm/kvm_host.h | 3 +--
> >  4 files changed, 8 insertions(+), 3 deletions(-)
> 
> For the whole series:
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> Christoffer: if you're happy with this series, I'll take it as part of
> the next batch of fixes.
> 
Yes:

Reviewed-by: Christoffer Dall <cdall@linaro.org>
