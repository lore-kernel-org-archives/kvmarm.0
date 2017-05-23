From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: Move timer IRQ default init to
 arch_timer.c
Date: Tue, 23 May 2017 18:18:21 +0100
Message-ID: <96a536ca-5ae3-03b9-edb9-f55606401372@arm.com>
References: <20170516184556.26785-1-cdall@linaro.org>
 <20170516184556.26785-5-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170516184556.26785-5-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Alexander Graf <agraf@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/05/17 19:45, Christoffer Dall wrote:
> We currently initialize the arch timer IRQ numbers from the reset code,
> presumably because we once intended to model multiple CPU or SoC types
> from within the kernel and have hard-coded reset values in the reset
> code.
> 
> As we are moving towards userspace being in charge of more fine-grained
> CPU emulation and stitching together the pieces needed to emulate a
> particular type of CPU, we should no longer have a tight coupling
> between resetting a VCPU and setting IRQ numbers.
> 
> Therefore, move the logic to define and use the default IRQ numbers to
> the timer code and set the IRQ number immediately when creating the
> VCPU.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
