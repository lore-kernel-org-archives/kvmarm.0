From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 24/55] KVM: arm/arm64: vgic-new: Add ENABLE registers
 handlers
Date: Wed, 11 May 2016 15:28:42 +0100
Message-ID: <5733419A.9060001@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-25-git-send-email-andre.przywara@arm.com>
 <20160511123423.GO27623@cbox> <5733300C.9070304@arm.com>
 <57333F18.5030605@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2A07499A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 10:25:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IporJg9yH9Ny for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 10:25:19 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D55D449B2F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 10:25:18 -0400 (EDT)
In-Reply-To: <57333F18.5030605@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 11/05/16 15:18, Andre Przywara wrote:
> Would:
> 
> #define VGIC_ADDR_IRQ_MASK(bits) GENMASK_ULL((bits) + 10 - 1 - 1, 0)

Nonsense. Must be ... ilog2(bits) ..., of course.

Andre.

> #define VGIC_ADDR_TO_INTID(addr, bits) (((addr) &		\
> 			VGIC_ADDR_IRQ_MASK(bits)) * 64 / (bits) / 8)
> 
> work for all bitnesses?
