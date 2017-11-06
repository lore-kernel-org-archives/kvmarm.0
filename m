From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 04/37] KVM: arm/arm64: Get rid of vcpu->arch.irq_lines
Date: Mon, 6 Nov 2017 18:58:43 +0100
Message-ID: <20171106175843.oahi24paaiwqzkgn@kamzik.brq.redhat.com>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-5-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171012104141.26902-5-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 12, 2017 at 12:41:08PM +0200, Christoffer Dall wrote:
> We currently have a separate read-modify-write of the HCR_EL2 on entry
> to the guest for the sole purpose of setting the VF and VI bits, if set.
> Since this is most rarely the case (only when using userspace IRQ chip
> and interrupts are in flight), let's get rid of this operation and
> instead modify the bits in the vcpu->arch.hcr[_el2] directly when
> needed.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm/include/asm/kvm_emulate.h   |  9 ++-------
>  arch/arm/include/asm/kvm_host.h      |  3 ---
>  arch/arm/kvm/emulate.c               |  2 +-
>  arch/arm/kvm/hyp/switch.c            |  2 +-
>  arch/arm64/include/asm/kvm_emulate.h |  9 ++-------
>  arch/arm64/include/asm/kvm_host.h    |  3 ---
>  arch/arm64/kvm/hyp/switch.c          |  6 ------
>  arch/arm64/kvm/inject_fault.c        |  2 +-
>  virt/kvm/arm/arm.c                   | 11 ++++++-----
>  virt/kvm/arm/mmu.c                   |  6 +++---
>  10 files changed, 16 insertions(+), 37 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
