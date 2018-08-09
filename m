From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 0/4] KVM: arm/arm64: vgic-v3: Group0 SGI support
Date: Thu, 9 Aug 2018 13:51:48 +0200
Message-ID: <39f39eb5-8a93-0538-e17d-eab5387cbeb2@redhat.com>
References: <20180808131501.584-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B8904A1D9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Aug 2018 07:51:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id laIih0HDKaif for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Aug 2018 07:51:50 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8266A40217
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Aug 2018 07:51:50 -0400 (EDT)
In-Reply-To: <20180808131501.584-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 08/08/2018 03:14 PM, Marc Zyngier wrote:
> Although we now have Group0 support, we still miss support for Group0
> SGIs (which amounts to handling ICC_SGI0R_EL1 and ICC_ASGI1R_EL1
> traps), and this small series adds such support.
> 
> I appreciate this is *very* late for 4.19, I'd like to take it in as
> they complement Christoffer's Group0 support, and It'd be annoying to
> have something incomplete in 4.19.
> 
> Please shout if you spot something that doesn't look quite right.

Series
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
> Marc Zyngier (4):
>   KVM: arm64: Remove non-existent AArch32 ICC_SGI1R encoding
>   KVM: arm/arm64: vgic-v3: Add core support for Group0 SGIs
>   KVM: arm64: vgic-v3: Add support for ICC_SGI0R_EL1 and ICC_ASGI1R_EL1
>     accesses
>   KVM: arm: vgic-v3: Add support for ICC_SGI0R and ICC_ASGI1R accesses
> 
>  arch/arm/kvm/coproc.c            | 25 ++++++++++++++++++-
>  arch/arm64/include/asm/sysreg.h  |  2 ++
>  arch/arm64/kvm/sys_regs.c        | 43 +++++++++++++++++++++++++++++---
>  include/kvm/arm_vgic.h           |  2 +-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 16 +++++++++---
>  5 files changed, 79 insertions(+), 9 deletions(-)
> 
