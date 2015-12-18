From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7] arm/arm64: KVM: Detect vGIC presence at runtime
Date: Fri, 18 Dec 2015 12:34:08 +0000
Message-ID: <20151218123408.77b0dd12@arm.com>
References: <01b201d13988$a73a3400$f5ae9c00$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <01b201d13988$a73a3400$f5ae9c00$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 18 Dec 2015 14:38:43 +0300
Pavel Fedin <p.fedin@samsung.com> wrote:

> Before commit 662d9715840aef44dcb573b0f9fab9e8319c868a
> ("arm/arm64: KVM: Kill CONFIG_KVM_ARM_{VGIC,TIMER}") is was possible to
> compile the kernel without vGIC and vTimer support. Commit message says
> about possibility to detect vGIC support in runtime, but this has never
> been implemented.
> 
> This patch introduces runtime check, restoring the lost functionality.
> It again allows to use KVM on hardware without vGIC. Interrupt
> controller has to be emulated in userspace in this case.
> 
> -ENODEV return code from probe function means there's no GIC at all.
> -ENXIO happens when, for example, there is GIC node in the device tree,
> but it does not specify vGIC resources. Any other error code is still
> treated as full stop because it might mean some really serious problems.
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Applied.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
