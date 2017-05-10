From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: Simplify active_change_prepare and plug
 race
Date: Wed, 10 May 2017 13:01:46 +0200
Message-ID: <20170510110146.ggqox3ativf7qn63@kamzik.brq.redhat.com>
References: <20170510100118.4189-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170510100118.4189-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 10, 2017 at 12:01:18PM +0200, Christoffer Dall wrote:
> We don't need to stop a specific VCPU when changing the active state,
> because private IRQs can only be modified by a running VCPU for the
> VCPU itself and it is therefore already stopped.
> 
> However, it is also possible for two VCPUs to be modifying the active
> state of SPIs at the same time, which can cause the thread being stuck
> in the loop that checks other VCPU threads for a potentially very long
> time, or to modify the active state of a running VCPU.  Fix this by
> serializing all accesses to setting and clearing the active state of
> interrupts using the KVM mutex.
> 
> Reported-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  arch/arm/include/asm/kvm_host.h   |  2 --
>  arch/arm64/include/asm/kvm_host.h |  2 --
>  virt/kvm/arm/arm.c                | 20 ++++----------------
>  virt/kvm/arm/vgic/vgic-mmio.c     | 18 ++++++++++--------
>  virt/kvm/arm/vgic/vgic.c          | 11 ++++++-----
>  5 files changed, 20 insertions(+), 33 deletions(-)
>
 
Reviewed-by: Andrew Jones <drjones@redhat.com>
