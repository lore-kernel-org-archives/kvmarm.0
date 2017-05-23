From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 5/9] KVM: arm/arm64: Allow setting the timer IRQ
 numbers from userspace
Date: Tue, 23 May 2017 18:45:58 +0100
Message-ID: <a150922a-3131-7616-5cf2-38fa12f0133b@arm.com>
References: <20170516184556.26785-1-cdall@linaro.org>
 <20170516184556.26785-6-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170516184556.26785-6-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Alexander Graf <agraf@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/05/17 19:45, Christoffer Dall wrote:
> First we define an ABI using the vcpu devices that lets userspace set
> the interrupt numbers for the various timers on both the 32-bit and
> 64-bit KVM/ARM implementations.
> 
> Second, we add the definitions for the groups and attributes introduced
> by the above ABI.  (We add the PMU define on the 32-bit side as well for
> symmetry and it may get used some day.)
> 
> Third, we set up the arch-specific vcpu device operation handlers to
> call into the timer code for anything related to the
> KVM_ARM_VCPU_TIMER_CTRL group.
> 
> Fourth, we implement support for getting and setting the timer interrupt
> numbers using the above defined ABI in the arch timer code.
> 
> Fifth, we introduce error checking upon enabling the arch timer (which
> is called when first running a VCPU) to check that all VCPUs are
> configured to use the same PPI for the timer (as mandated by the
> architecture) and that the virtual and physical timers are not
> configured to use the same IRQ number.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
