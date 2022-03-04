Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401E1C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  4 Mar 2022 14:27:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DD6349F0C;
	Fri,  4 Mar 2022 09:27:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nbHlgpv5A-mu; Fri,  4 Mar 2022 09:27:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2380249F2F;
	Fri,  4 Mar 2022 09:27:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98A2849F26
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Mar 2022 09:27:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s7SMEBkprdCW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Mar 2022 09:27:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 414EE49F0C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Mar 2022 09:27:33 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 562451424;
 Fri,  4 Mar 2022 06:27:32 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.22.160])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 109173F70D;
 Fri,  4 Mar 2022 06:27:30 -0800 (PST)
Date: Fri, 4 Mar 2022 14:27:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Only open the interrupt window on exit due
 to an interrupt
Message-ID: <YiIekBoAJqz4rI+Q@FVFF77S0Q05N>
References: <20220304135914.1464721-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220304135914.1464721-1-maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Fri, Mar 04, 2022 at 01:59:14PM +0000, Marc Zyngier wrote:
> Now that we properly account for interrupts taken whilst the guest
> was running, it becomes obvious that there is no need to open
> this accounting window if we didn't exit because of an interrupt.
> 
> This saves a number of system register accesses and other barriers
> if we exited for any other reason (such as a trap, for example).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kvm/arm.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fefd5774ab55..f49ebdd9c990 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -887,9 +887,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		 * context synchronization event) is necessary to ensure that
>  		 * pending interrupts are taken.
>  		 */
> -		local_irq_enable();
> -		isb();
> -		local_irq_disable();
> +		if (ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_IRQ) {
> +			local_irq_enable();
> +			isb();
> +			local_irq_disable();
> +		}
>  
>  		guest_timing_exit_irqoff();
>  
> -- 
> 2.34.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
