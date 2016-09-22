From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 08/10] ARM: Move system register accessors to asm/cp15.h
Date: Thu, 22 Sep 2016 10:59:04 +0100
Message-ID: <57E3AB68.80208@arm.com>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-9-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 368A349B2E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:50:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V6208sIMZmUP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2016 05:49:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D5B540F77
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:49:59 -0400 (EDT)
In-Reply-To: <1473691764-29424-9-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, Russell King <rmk+kernel@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/09/16 15:49, Vladimir Murzin wrote:
> Headers linux/irqchip/arm-gic.v3.h and arch/arm/include/asm/kvm_hyp.h
> are included in virt/kvm/arm/hyp/vgic-v3-sr.c and both define macros
> called __ACCESS_CP15 and __ACCESS_CP15_64 which obviously creates a
> conflict. These macros were introduced independently for GIC and KVM
> and, in fact, do the same thing.
> 
> As an option we could add prefixes to KVM and GIC version of macros so
> they won't clash, but it'd introduce code duplication.  Alternatively,
> we could keep macro in, say, GIC header and include it in KVM one (or
> vice versa), but such dependency would not look nicer.
> 
> So we follow arm64 way (it handles this via sysreg.h) and move only
> single set of macros to asm/cp15.h
> 
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arch/arm/include/asm/arch_gicv3.h |   27 +++++++++++----------------
>  arch/arm/include/asm/cp15.h       |   15 +++++++++++++++
>  arch/arm/include/asm/kvm_hyp.h    |   15 +--------------
>  3 files changed, 27 insertions(+), 30 deletions(-)

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
