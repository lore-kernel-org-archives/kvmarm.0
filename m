From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 09/10] ARM: gic-v3: Introduce 32-to-64-bit mappings for
 GICv3 cpu registers
Date: Thu, 22 Sep 2016 10:57:34 +0100
Message-ID: <57E3AB0E.5070308@arm.com>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-10-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D102B49B51
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:48:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0i5IVX9W7UDm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2016 05:48:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B939949B50
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:48:29 -0400 (EDT)
In-Reply-To: <1473691764-29424-10-git-send-email-vladimir.murzin@arm.com>
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
> vgic-v3 save/restore routines are written in such way that they map
> arm64 system register naming nicely, but it does not fit to arm
> world. To keep virt/kvm/arm/hyp/vgic-v3-sr.c untouched we create a
> mapping with a function for each register mapping the 32-bit to the
> 64-bit accessors.
> 
> Please, note that 64-bit wide ICH_LR is split in two 32-bit halves
> (ICH_LR and ICH_LRC) accessed independently.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arch/arm/include/asm/arch_gicv3.h |   64 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
