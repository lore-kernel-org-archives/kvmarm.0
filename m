From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 01/10] arm64: KVM: Use static keys for selecting the
 GIC backend
Date: Thu, 22 Sep 2016 11:01:10 +0100
Message-ID: <57E3ABE6.6000703@arm.com>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-2-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01B9449B2E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:52:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zg9pcASiFVBe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2016 05:52:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D16F40F77
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:52:05 -0400 (EDT)
In-Reply-To: <1473691764-29424-2-git-send-email-vladimir.murzin@arm.com>
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
> Currently GIC backend is selected via alternative framework and this
> is fine. We are going to introduce vgic-v3 to 32-bit world and there
> we don't have patching framework in hand, so we can either check
> support for GICv3 every time we need to choose which backend to use or
> try to optimise it by using static keys. The later looks quite
> promising because we can share logic involved in selecting GIC backend
> between architectures if both uses static keys.
> 
> This patch moves arm64 from alternative to static keys framework for
> selecting GIC backend. For that we embed static key into vgic_global
> and enable the key during vgic initialisation based on what has
> already been exposed by the host GIC driver.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arch/arm64/kvm/hyp/switch.c   |   21 +++++++++++----------
>  include/kvm/arm_vgic.h        |    4 ++++
>  virt/kvm/arm/vgic/vgic-init.c |    4 ++++
>  virt/kvm/arm/vgic/vgic.c      |    2 +-
>  4 files changed, 20 insertions(+), 11 deletions(-)

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
