From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/2] arm/arm64: KVM: Fix arthictected timer issues
Date: Fri, 04 Sep 2015 16:35:20 +0100
Message-ID: <55E9BA38.7030305@arm.com>
References: <1441376679-8341-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0206841289
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 11:34:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dZz8pwERTZcL for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2015 11:34:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD2E941280
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 11:34:56 -0400 (EDT)
In-Reply-To: <1441376679-8341-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 04/09/15 15:24, Christoffer Dall wrote:
> These two patches fix two separate issues with the architected timer and
> the corresponding interrupt injection to VMs on KVM/ARM.
> 
> The first patch fixes an issue introduced with the active timer state
> switching series recently merged for v4.3, which could cause a guest to
> loop without progress if another VCPU is run on the same physical CPU
> and preempts the original VCPU while the guest is running the ISR for
> the timer interrupt.
> 
> The second patch resets the architected timer's control register to zero
> on system reset, ensuring that interrupts are not injected when a system
> resets.  This fixes a long-standing issue with UEFI, where soft reset
> initiated from within UEFI prevented the system from booting again.

Thanks for respinning these patches. I've queued them in our -next
queue. I'll send this to Paolo some time next week, once they get some
hammering.

	M.
-- 
Jazz is not dead. It just smells funny...
