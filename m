From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 06/10] arm: simplify MMIO dispatching
Date: Wed, 17 Jun 2015 13:48:31 +0100
Message-ID: <55816C9F.1090500@arm.com>
References: <1434540121-21283-1-git-send-email-andre.przywara@arm.com> <1434540121-21283-7-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1434540121-21283-7-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <Will.Deacon@arm.com>
Cc: "penberg@kernel.org" <penberg@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 17/06/15 12:21, Andre Przywara wrote:
> Currently we separate any incoming MMIO request into one of the ARM
> memory map regions and take care to spare the GIC.
> It turns out that this is unnecessary, as we only have one special
> region (the IO port area in the first 64 KByte). The MMIO rbtree
> takes care about unhandled MMIO ranges, so we can simply drop all the
> special range checking (except that for the IO range) in
> kvm_cpu__emulate_mmio().
> As the GIC is handled in the kernel, a GIC MMIO access should never
> reach userland (and we don't know what to do with it anyway).
> This lets us delete some more code and simplifies future extensions
> (like expanding the GIC regions).
> To be in line with the other architectures, move the now simpler
> code into a header file.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/include/arm-common/kvm-arch.h     | 12 ------------
>  arm/include/arm-common/kvm-cpu-arch.h | 14 ++++++++++++--
>  arm/kvm-cpu.c                         | 16 ----------------
>  3 files changed, 12 insertions(+), 30 deletions(-)
> 
> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> index 082131d..90d6733 100644
> --- a/arm/include/arm-common/kvm-arch.h
> +++ b/arm/include/arm-common/kvm-arch.h
> @@ -45,18 +45,6 @@ static inline bool arm_addr_in_ioport_region(u64 phys_addr)
>  	return phys_addr >= KVM_IOPORT_AREA && phys_addr < limit;
>  }
>  
> -static inline bool arm_addr_in_virtio_mmio_region(u64 phys_addr)
> -{
> -	u64 limit = KVM_VIRTIO_MMIO_AREA + ARM_VIRTIO_MMIO_SIZE;
> -	return phys_addr >= KVM_VIRTIO_MMIO_AREA && phys_addr < limit;
> -}
> -
> -static inline bool arm_addr_in_pci_region(u64 phys_addr)
> -{
> -	u64 limit = KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE + ARM_PCI_MMIO_SIZE;
> -	return phys_addr >= KVM_PCI_CFG_AREA && phys_addr < limit;
> -}
> -
>  struct kvm_arch {
>  	/*
>  	 * We may have to align the guest memory for virtio, so keep the
> diff --git a/arm/include/arm-common/kvm-cpu-arch.h b/arm/include/arm-common/kvm-cpu-arch.h
> index 36c7872..329979a 100644
> --- a/arm/include/arm-common/kvm-cpu-arch.h
> +++ b/arm/include/arm-common/kvm-cpu-arch.h
> @@ -44,8 +44,18 @@ static inline bool kvm_cpu__emulate_io(struct kvm_cpu *vcpu, u16 port, void *dat
>  	return false;
>  }
>  
> -bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data,
> -			   u32 len, u8 is_write);
> +static inline bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr,
> +					 u8 *data, u32 len, u8 is_write)
> +{
> +	if (arm_addr_in_ioport_region(phys_addr)) {
> +		int direction = is_write ? KVM_EXIT_IO_OUT : KVM_EXIT_IO_IN;
> +		u16 port = (phys_addr - KVM_IOPORT_AREA) & USHRT_MAX;
> +
> +		return kvm__emulate_io(vcpu, port, data, direction, len, 1);
> +	}
> +
> +	return kvm__emulate_mmio(vcpu, phys_addr, data, len, is_write);
> +}
>  
>  unsigned long kvm_cpu__get_vcpu_mpidr(struct kvm_cpu *vcpu);
>  
> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> index ab08815..7780251 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -139,22 +139,6 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
>  	return false;
>  }
>  
> -bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data,
> -			   u32 len, u8 is_write)
> -{
> -	if (arm_addr_in_virtio_mmio_region(phys_addr)) {
> -		return kvm__emulate_mmio(vcpu, phys_addr, data, len, is_write);
> -	} else if (arm_addr_in_ioport_region(phys_addr)) {
> -		int direction = is_write ? KVM_EXIT_IO_OUT : KVM_EXIT_IO_IN;
> -		u16 port = (phys_addr - KVM_IOPORT_AREA) & USHRT_MAX;
> -		return kvm__emulate_io(vcpu, port, data, direction, len, 1);
> -	} else if (arm_addr_in_pci_region(phys_addr)) {
> -		return kvm__emulate_mmio(vcpu, phys_addr, data, len, is_write);
> -	}

Can you explain why this arm_addr_in_pci_region(phys_addr) check has
disappeared in your updated version on this function? It may be a non
issue, but I'd very much like to understand.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
