From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Reset mapped IRQs on VM reset
Date: Wed, 7 Mar 2018 13:02:07 +0000
Message-ID: <a5dbae97-7ab8-4f60-723f-d3599297f396@arm.com>
References: <20180305103638.1633-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D1B242121
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 07:55:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i0oswn-pLxAE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Mar 2018 07:54:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE5E340805
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 07:54:54 -0500 (EST)
In-Reply-To: <20180305103638.1633-1-cdall@kernel.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/03/18 10:36, Christoffer Dall wrote:
> We currently don't allow resetting mapped IRQs from userspace, because
> their state is controlled by the hardware.  But we do need to reset the
> state when the VM is reset, so we provide a function for the 'owner' of
> the mapped interrupt to reset the interrupt state.
> 
> Currently only the timer uses mapped interrupts, so we call this
> function from the timer reset logic.
> 
> Signed-off-by: Christoffer Dall <cdall@kernel.org>
> ---
> This depends on "KVM: arm/arm64: Avoid vcpu_load for other vcpu ioctls
> than KVM_RUN" from the VHE optimization series so that the reset doesn't
> get called while vtimer->loaded is true.

Queued for 4.16-rc5.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
