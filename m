Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD431C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 15:23:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38CAB4A417;
	Mon,  7 Mar 2022 10:23:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n+mmharn2NKi; Mon,  7 Mar 2022 10:23:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E998F4B0CC;
	Mon,  7 Mar 2022 10:23:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90B6E49F31
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 10:23:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jFHqTR0ljhbp for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 10:23:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4474249F16
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 10:23:14 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93850113E;
 Mon,  7 Mar 2022 07:23:13 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE66F3F66F;
 Mon,  7 Mar 2022 07:23:10 -0800 (PST)
Date: Mon, 7 Mar 2022 15:23:32 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 43/64] KVM: arm64: nv: arch_timer: Support hyp timer
 emulation
Message-ID: <YiYjdHbS3WeDMipR@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-44-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-44-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

On Fri, Jan 28, 2022 at 12:18:51PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> Emulating EL2 also means emulating the EL2 timers. To do so, we expand
> our timer framework to deal with at most 4 timers. At any given time,
> two timers are using the HW timers, and the two others are purely
> emulated.
> 
> The role of deciding which is which at any given time is left to a
> mapping function which is called every time we need to make such a
> decision.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> [maz: added CNTVOFF support, general reworking for v4.8]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |   4 +
>  arch/arm64/kvm/arch_timer.c       | 165 ++++++++++++++++++++++++++++--
>  arch/arm64/kvm/sys_regs.c         |   7 +-
>  arch/arm64/kvm/trace_arm.h        |   6 +-
>  arch/arm64/kvm/vgic/vgic.c        |  15 +++
>  include/kvm/arm_arch_timer.h      |   8 +-
>  include/kvm/arm_vgic.h            |   1 +
>  7 files changed, 194 insertions(+), 12 deletions(-)
> 
[..]
> @@ -1301,6 +1445,7 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		vcpu_vtimer(vcpu)->irq.irq = vtimer_irq;
>  		vcpu_ptimer(vcpu)->irq.irq = ptimer_irq;
> +		/* TODO: Add support for hv/hp timers */
>  	}
>  }
>  
> @@ -1311,6 +1456,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  	int irq;
>  
> +	/* TODO: Add support for hv/hp timers */

Is the patch unfinished?

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
