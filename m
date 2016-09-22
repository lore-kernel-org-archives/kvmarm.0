From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 06/10] KVM: arm: vgic: Support 64-bit data manipulation
 on 32-bit host systems
Date: Thu, 22 Sep 2016 11:00:07 +0100
Message-ID: <57E3ABA7.2060003@arm.com>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-7-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7018249B2E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:51:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 14K41m1+HT+P for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2016 05:51:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 580FD40F77
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:51:02 -0400 (EDT)
In-Reply-To: <1473691764-29424-7-git-send-email-vladimir.murzin@arm.com>
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
Cc: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/09/16 15:49, Vladimir Murzin wrote:
> We have couple of 64-bit registers defined in GICv3 architecture, so
> unsigned long accesses to these registers will only access a single
> 32-bit part of that regitser. On the other hand these registers can't
> be accessed as 64-bit with a single instruction like ldrd/strd or
> ldmia/stmia if we run a 32-bit host because KVM does not support
> access to MMIO space done by these instructions.
> 
> It means that a 32-bit guest accesses these registers in 32-bit
> chunks, so the only thing we need to do is to ensure that
> extract_bytes() always takes 64-bit data.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v3.c |    2 +-
>  virt/kvm/arm/vgic/vgic-mmio.h    |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
