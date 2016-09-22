From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 07/10] ARM: Introduce MPIDR_LEVEL_SHIFT macro
Date: Thu, 22 Sep 2016 10:59:34 +0100
Message-ID: <57E3AB86.1020003@arm.com>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-8-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AB4C49B2E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:50:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nTGfxVmGRARJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2016 05:50:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B6FA40F77
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:50:28 -0400 (EDT)
In-Reply-To: <1473691764-29424-8-git-send-email-vladimir.murzin@arm.com>
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
> vgic-v3 driver uses architecture specific MPIDR_LEVEL_SHIFT macro to
> encode the affinity in a form compatible with ICC_SGI* registers.
> Unfortunately, that macro is missing on ARM, so let's add it.
> 
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arch/arm/include/asm/cputype.h |    1 +
>  1 file changed, 1 insertion(+)

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
