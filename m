From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v5 03/20] arm64: Use physical counter for in-kernel reads
 when booted in EL2
Date: Fri, 27 Oct 2017 11:53:42 +0100
Message-ID: <20171027105341.rpomiwsospi76o4k@armageddon.cambridge.arm.com>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
 <1509093281-15225-4-git-send-email-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF4E849D1B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:52:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iGIYpt-OJhVF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 06:52:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC2E049D19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:52:21 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1509093281-15225-4-git-send-email-cdall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 27, 2017 at 10:34:24AM +0200, Christoffer Dall wrote:
> Using the physical counter allows KVM to retain the offset between the
> virtual and physical counter as long as it is actively running a VCPU.
> 
> As soon as a VCPU is released, another thread is scheduled or we start
> running userspace applications, we reset the offset to 0, so that
> userspace accessing the virtual timer can still read the virtual counter
> and get the same view of time as the kernel.
> 
> This opens up potential improvements for KVM performance, but we have to
> make a few adjustments to preserve system consistency.
> 
> Currently get_cycles() is hardwired to arch_counter_get_cntvct() on
> arm64, but as we move to using the physical timer for the in-kernel
> time-keeping on systems that boot in EL2, we should use the same counter
> for get_cycles() as for other in-kernel timekeeping operations.
> 
> Similarly, implementations of arch_timer_set_next_event_phys() is
> modified to use the counter specific to the timer being programmed.
> 
> VHE kernels or kernels continuing to use the virtual timer are
> unaffected.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
