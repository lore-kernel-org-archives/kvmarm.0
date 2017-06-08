From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 8/9] KVM: arm/arm64: Disallow userspace control of
 in-kernel IRQ lines
Date: Thu, 08 Jun 2017 15:14:37 +0100
Message-ID: <8737bain1u.fsf@arm.com>
References: <20170608133446.3875-1-cdall@linaro.org>
 <20170608133446.3875-9-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0313540962
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 10:10:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7RvUzt9GGSWS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Jun 2017 10:10:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42495405DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 10:10:30 -0400 (EDT)
In-Reply-To: <20170608133446.3875-9-cdall@linaro.org> (Christoffer Dall's
 message of "Thu, 8 Jun 2017 15:34:45 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 08 2017 at  3:34:45 pm BST, Christoffer Dall <cdall@linaro.org> wrote:
> When injecting an IRQ to the VGIC, you now have to present an owner
> token for that IRQ line to show that you are the owner of that line.
>
> IRQ lines driven from userspace or via an irqfd do not have an owner and
> will simply pass a NULL pointer.
>
> Also get rid of the unused kvm_vgic_inject_mapped_irq prototype.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead, it just smell funny.
