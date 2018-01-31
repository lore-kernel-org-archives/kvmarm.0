From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Fix arch timers with userspace
 irqchips
Date: Wed, 31 Jan 2018 14:28:07 +0000
Message-ID: <2417c8c5-e09c-a2fb-a4c5-b04cc39b35a5@arm.com>
References: <20180131121425.7252-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180131121425.7252-1-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: stable-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Alexander Graf <agraf@suse.de>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 31/01/18 12:14, Christoffer Dall wrote:
> When introducing support for irqchip in userspace we needed a way to
> mask the timer signal to prevent the guest continuously exiting due to a
> screaming timer.
> 
> We did this by disabling the corresponding percpu interrupt on the
> host interrupt controller, because we cannot rely on the host system
> having a GIC, and therefore cannot make any assumptions about having an
> active state to hide the timer signal.
> 
> Unfortunately, when introducing this feature, it became entirely
> possible that a VCPU which belongs to a VM that has a userspace irqchip
> can disable the vtimer irq on the host on some physical CPU, and then go
> away without ever enabling the vtimer irq on that physical CPU again.
> 
> This means that using irqchips in userspace on a system that also
> supports running VMs with an in-kernel GIC can prevent forward progress
> from in-kernel GIC VMs.
> 
> Later on, when we started taking virtual timer interrupts in the arch
> timer code, we would also leave this timer state active for userspace
> irqchip VMs, because we leave it up to a VGIC-enabled guest to
> deactivate the hardware IRQ using the HW bit in the LR.
> 
> Both issues are solved by only using the enable/disable trick on systems
> that do not have a host GIC which supports the active state, because all
> VMs on such systems must use irqchips in userspace.  Systems that have a
> working GIC with support for an active state use the active state to
> mask the timer signal for both userspace and in-kernel irqchips.
> 
> Cc: Alexander Graf <agraf@suse.de>
> Cc: <stable@vger.kernel.org> # v4.12+
> Fixes: d9e139778376 ("KVM: arm/arm64: Support arch timers with a userspace gic")
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
