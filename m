From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v5 2/2] KVM: Make KVM_CAP_IRQFD dependent on
 KVM_CAP_IRQCHIP
Date: Mon, 30 Nov 2015 12:26:27 +0100
Message-ID: <20151130122627.12ceb244.cornelia.huck@de.ibm.com>
References: <cover.1448874023.git.p.fedin@samsung.com>
	<57888eef1c5c21337ddad384250bc5f55829ac67.1448874023.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <57888eef1c5c21337ddad384250bc5f55829ac67.1448874023.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 30 Nov 2015 12:40:45 +0300
Pavel Fedin <p.fedin@samsung.com> wrote:

> Now at least ARM is able to determine whether the machine has
> virtualization support for irqchip or not at runtime. Obviously,
> irqfd requires irqchip.
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  virt/kvm/kvm_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7873d6d..a057d5e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2716,13 +2716,15 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  	case KVM_CAP_INTERNAL_ERROR_DATA:
>  #ifdef CONFIG_HAVE_KVM_MSI
>  	case KVM_CAP_SIGNAL_MSI:
> +		/* Fallthrough */
>  #endif
> +	case KVM_CAP_CHECK_EXTENSION_VM:
> +		return 1;
>  #ifdef CONFIG_HAVE_KVM_IRQFD
>  	case KVM_CAP_IRQFD:
>  	case KVM_CAP_IRQFD_RESAMPLE:
> +		return kvm_vm_ioctl_check_extension(kvm, KVM_CAP_IRQCHIP);

This won't work for s390, as it doesn't have KVM_CAP_IRQCHIP but
KVM_CAP_S390_IRQCHIP (which needs to be enabled).

>  #endif
> -	case KVM_CAP_CHECK_EXTENSION_VM:
> -		return 1;
>  #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
>  	case KVM_CAP_IRQ_ROUTING:
>  		return KVM_MAX_IRQ_ROUTES;

