From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 37/59] KVM: arm/arm64: vgic: Move kvm_vgic_destroy
 call around
Date: Sat, 26 Aug 2017 21:49:00 +0200
Message-ID: <20170826194900.GC11074@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-38-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170731172637.29355-38-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 31, 2017 at 06:26:15PM +0100, Marc Zyngier wrote:
> The way we call kvm_vgic_destroy is a bit bizarre. We call it
> *after* having freed the vcpus, which sort of defeats the point
> of cleaning up things before that point.
> 
> Let's move kvm_vgic_destroy towards the beginning of kvm_arch_destroy_vm,
> which seems more sensible.
> 

Acked-by: Christoffer Dall <cdall@linaro.org>

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/arm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 7846a578db1a..ebab6c29e3be 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -177,6 +177,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
>  	int i;
>  
> +	kvm_vgic_destroy(kvm);
> +
>  	free_percpu(kvm->arch.last_vcpu_ran);
>  	kvm->arch.last_vcpu_ran = NULL;
>  
> @@ -186,8 +188,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  			kvm->vcpus[i] = NULL;
>  		}
>  	}
> -
> -	kvm_vgic_destroy(kvm);
>  }
>  
>  int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> -- 
> 2.11.0
> 
