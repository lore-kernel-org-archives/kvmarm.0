From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v5 1/2] arm/arm64: KVM: Detect vGIC presence at runtime
Date: Thu, 21 Apr 2016 23:41:45 +0200
Message-ID: <57194919.5080007@suse.de>
References: <cover.1448874023.git.p.fedin@samsung.com>
 <f759b4ba37d4cacdc971d2a416cdc8ecf0c3c3d9.1448874023.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <f759b4ba37d4cacdc971d2a416cdc8ecf0c3c3d9.1448874023.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 30.11.15 10:40, Pavel Fedin wrote:
> Before commit 662d9715840aef44dcb573b0f9fab9e8319c868a
> ("arm/arm64: KVM: Kill CONFIG_KVM_ARM_{VGIC,TIMER}") is was possible to
> compile the kernel without vGIC and vTimer support. Commit message says
> about possibility to detect vGIC support in runtime, but this has never
> been implemented.
> 
> This patch introdices runtime check, restoring the lost functionality.
> It again allows to use KVM on hardware without vGIC. Interrupt
> controller has to be emulated in userspace in this case.
> 
> -ENODEV return code from probe function means there's no GIC at all.
> -ENXIO happens when, for example, there is GIC node in the device tree,
> but it does not specify vGIC resources. Normally this means that vGIC
> hardware is defunct. Any other error code is still treated as full stop
> because it might mean some really serious problems.
> 
> This patch does not touch any virtual timer code, suggesting that timer
> hardware is actually in place. Normally on boards in question it is true,
> however since vGIC is missing, it is impossible to correctly utilize
> interrupts from the virtual timer. Since virtual timer handling is in

So effectively all we'd need is to set CNTHCTL_EL2.EL1PCEN to 0 for
guests that have no in-kernel irqchip, no? We should then trap on all
timer accesses and be able to emulate them in user space where we can
inject IRQs into an emulated GIC again.


Alex
