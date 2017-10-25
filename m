From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 05/20] KVM: arm/arm64: Support calling
 vgic_update_irq_pending from irq context
Date: Wed, 25 Oct 2017 14:45:28 +0100
Message-ID: <86k1zjcpdz.fsf@arm.com>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
 <20171020114939.12554-6-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F275149D37
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 09:44:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0L+buIrxgG3X for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Oct 2017 09:44:13 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02B7040651
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 09:44:13 -0400 (EDT)
In-Reply-To: <20171020114939.12554-6-christoffer.dall@linaro.org> (Christoffer
 Dall's message of "Fri, 20 Oct 2017 13:49:24 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Christoffer Dall <cdall@linaro.org>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 20 2017 at  1:49:24 pm BST, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> From: Christoffer Dall <cdall@linaro.org>
>
> We are about to optimize our timer handling logic which involves
> injecting irqs to the vgic directly from the irq handler.
>
> Unfortunately, the injection path can take any AP list lock and irq lock
> and we must therefore make sure to use spin_lock_irqsave where ever
> interrupts are enabled and we are taking any of those locks, to avoid
> deadlocking between process context and the ISR.
>
> This changes a lot of the VGIC code, but The good news are that the
> changes are mostly mechanical.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc,zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
