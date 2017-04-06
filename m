From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 3/5] KVM: arm/arm64: Support arch timers with a
 userspace gic
Date: Thu, 6 Apr 2017 17:49:05 +0100
Message-ID: <baaf0d40-222b-633e-77b6-75fc61f3e0ed@arm.com>
References: <20170405092815.22503-1-cdall@linaro.org>
 <20170405092815.22503-4-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ECDA40B40
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 12:46:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xR+ouUT3VApr for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Apr 2017 12:46:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6705E40A86
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 12:46:54 -0400 (EDT)
In-Reply-To: <20170405092815.22503-4-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Pekka Enberg <penberg@iki.fi>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/04/17 10:28, Christoffer Dall wrote:
> From: Alexander Graf <agraf@suse.de>
> 
> If you're running with a userspace gic or other interrupt constroller

controller

> (that is no vgic in the kernel), then you have so far not been able to
> use the architected timers, because the output of the architected
> timers, which are driven inside the kernel, was a kernel-only construct
> between the arch timer code and the vgic.
> 
> This patch implements the new KVM_CAP_ARM_USER_IRQ feature, where we use a
> side channel on the kvm_run structure, run->s.regs.device_irq_level, to
> always notify userspace of the timer output levels when using a userspace
> irqchip.
> 
> This works by ensureing that before we enter the guest, if the timer

ensuring

> output level has changed compared to what we last told userspace, we
> don't enter the guest, but instead return to userspace to notify it of
> the new level.  If we are exiting, because of an MMIO for example, and
> the level changed at the same time, the value is also updated and
> userspace can sample the line as it needs.  This is nicely achieved
> simply always updating the timer_irq_level field after the main run
> loop.
> 
> Note that the kvm_timer_update_irq trace event is changed to show the
> host IRQ number for the timer instead of the guest IRQ number, because
> the kernel no longer know which IRQ userspace wires up the timer signal
> to.
> 
> Also note that this patch implements all required functionality but does
> not yet advertise the capability.
> 
> Signed-off-by: Alexander Graf <agraf@suse.de>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Otherwise looks good.

	M.
-- 
Jazz is not dead. It just smells funny...
