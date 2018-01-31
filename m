From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3/3] KVM: arm/arm64: Fixup userspace irqchip static key
 optimization
Date: Wed, 31 Jan 2018 09:00:57 +0000
Message-ID: <0c5d993f-d690-abca-47bc-783756c381da@arm.com>
References: <20180130124206.12262-1-christoffer.dall@linaro.org>
 <20180130124206.12262-4-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180130124206.12262-4-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/01/18 12:42, Christoffer Dall wrote:
> When I introduced a static key to avoid work in the critical path for
> userspace irqchips which is very rarely used, I accidentally messed up
> my logic and used && where I should have used ||, because the point was
> to short-circuit the evaluation in case userspace irqchips weren't even
> in use.
> 
> This fixes an issue when running in-kernel irqchip VMs alongside
> userspace irqchip VMs.
> 
> Fixes: c44c232ee2d3 ("KVM: arm/arm64: Avoid work when userspace iqchips are not used")
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
