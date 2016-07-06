From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 05/17] KVM: kvm_io_bus: add kvm_io_bus_get_dev() call
Date: Wed, 6 Jul 2016 23:15:18 +0200
Message-ID: <20160706211518.GE12608@cbox>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-6-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160705112309.28877-6-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 05, 2016 at 12:22:57PM +0100, Andre Przywara wrote:
> The kvm_io_bus framework is a nice place of holding information about
> various MMIO regions for kernel emulated devices.
> Add a call to retrieve the kvm_io_device structure which is associated
> with a certain MMIO address. This avoids to duplicate kvm_io_bus'
> knowledge of MMIO regions without having to fake MMIO calls if a user
> needs the device a certain MMIO address belongs to.
> This will be used by the ITS emulation to get the associated ITS device
> when someone triggers an MSI via an ioctl from userspace.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  include/linux/kvm_host.h |  2 ++
>  virt/kvm/kvm_main.c      | 24 ++++++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0640ee9..614a981 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -164,6 +164,8 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>  			    int len, struct kvm_io_device *dev);
>  int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>  			      struct kvm_io_device *dev);
> +struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
> +					 gpa_t addr);
>  
>  #ifdef CONFIG_KVM_ASYNC_PF
>  struct kvm_async_pf {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ef54b4c..bd2eb92 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3496,6 +3496,30 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>  	return r;
>  }
>  

do you need to hold kvm->slots_lock here like the other functions
touching the io_bus framework here, which have comments specifying that?

> +struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
> +					 gpa_t addr)
> +{
> +	struct kvm_io_bus *bus;
> +	int dev_idx, srcu_idx;
> +	struct kvm_io_device *iodev = NULL;
> +
> +	srcu_idx = srcu_read_lock(&kvm->srcu);
> +
> +	bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
> +
> +	dev_idx = kvm_io_bus_get_first_dev(bus, addr, 1);
> +	if (dev_idx < 0)
> +		goto out_unlock;
> +
> +	iodev = bus->range[dev_idx].dev;
> +
> +out_unlock:
> +	srcu_read_unlock(&kvm->srcu, srcu_idx);
> +
> +	return iodev;
> +}
> +EXPORT_SYMBOL_GPL(kvm_io_bus_get_dev);
> +
>  static struct notifier_block kvm_cpu_notifier = {
>  	.notifier_call = kvm_cpu_hotplug,
>  };
> -- 
> 2.9.0
> 

You also need an ack here, but my comment-comment above notwithstanding:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

-Christoffer
