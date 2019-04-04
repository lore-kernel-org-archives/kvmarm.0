From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 06/16] pci: Fix ioport allocation size
Date: Thu, 4 Apr 2019 14:46:02 +0100
Message-ID: <20190404144602.049922ef@donnerap.cambridge.arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
 <1551947777-13044-7-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3F254A43B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 09:46:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DDZebeYwRc-v for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 09:46:06 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9954A332
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 09:46:06 -0400 (EDT)
In-Reply-To: <1551947777-13044-7-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Sami.Mujawar@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 7 Mar 2019 08:36:07 +0000
Julien Thierry <julien.thierry@arm.com> wrote:

> The PCI Local Bus Specification, Rev. 3.0,
> Section 6.2.5.1. "Address Maps" states:
> "Devices that map control functions into I/O Space must not consume more
> than 256 bytes per I/O Base Address register."
> 
> Yet all the PCI devices allocate IO ports of IOPORT_SIZE (= 1024 bytes).
> 
> Fix this by having PCI devices use 256 bytes ports for IO BARs.

Good catch!

> Signed-off-by: Julien Thierry <julien.thierry@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  hw/pci-shmem.c       |  4 ++--
>  hw/vesa.c            |  4 ++--
>  include/kvm/ioport.h |  1 -
>  pci.c                |  2 +-
>  virtio/pci.c         | 14 +++++++-------
>  5 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/hw/pci-shmem.c b/hw/pci-shmem.c
> index a0c5ba8..2e1474b 100644
> --- a/hw/pci-shmem.c
> +++ b/hw/pci-shmem.c
> @@ -357,8 +357,8 @@ int pci_shmem__init(struct kvm *kvm)
>  		return 0;
>  
>  	/* Register MMIO space for MSI-X */
> -	r = pci_get_io_port_block(IOPORT_SIZE);
> -	r = ioport__register(kvm, r, &shmem_pci__io_ops, IOPORT_SIZE, NULL);
> +	r = pci_get_io_port_block(PCI_IO_SIZE);
> +	r = ioport__register(kvm, r, &shmem_pci__io_ops, PCI_IO_SIZE, NULL);
>  	if (r < 0)
>  		return r;
>  	ivshmem_registers = (u16)r;
> diff --git a/hw/vesa.c b/hw/vesa.c
> index 404a8a3..71935d5 100644
> --- a/hw/vesa.c
> +++ b/hw/vesa.c
> @@ -60,8 +60,8 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>  
>  	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
>  		return NULL;
> -	r = pci_get_io_space_block(IOPORT_SIZE);
> -	r = ioport__register(kvm, r, &vesa_io_ops, IOPORT_SIZE, NULL);
> +	r = pci_get_io_space_block(PCI_IO_SIZE);
> +	r = ioport__register(kvm, r, &vesa_io_ops, PCI_IO_SIZE, NULL);
>  	if (r < 0)
>  		return ERR_PTR(r);
>  
> diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
> index b10fcd5..8c86b71 100644
> --- a/include/kvm/ioport.h
> +++ b/include/kvm/ioport.h
> @@ -14,7 +14,6 @@
>  
>  /* some ports we reserve for own use */
>  #define IOPORT_DBG			0xe0
> -#define IOPORT_SIZE			0x400
>  
>  struct kvm;
>  
> diff --git a/pci.c b/pci.c
> index cd749db..228a628 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -23,7 +23,7 @@ static u16 io_port_blocks		= PCI_IOPORT_START;
>  
>  u16 pci_get_io_port_block(u32 size)
>  {
> -	u16 port = ALIGN(io_port_blocks, IOPORT_SIZE);
> +	u16 port = ALIGN(io_port_blocks, PCI_IO_SIZE);
>  	io_port_blocks = port + size;
>  	return port;
>  }
> diff --git a/virtio/pci.c b/virtio/pci.c
> index c8e16dd..5a6c0d0 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -406,7 +406,7 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
>  {
>  	struct virtio_pci *vpci = ptr;
>  	int direction = is_write ? KVM_EXIT_IO_OUT : KVM_EXIT_IO_IN;
> -	u16 port = vpci->port_addr + (addr & (IOPORT_SIZE - 1));
> +	u16 port = vpci->port_addr + (addr & (PCI_IO_SIZE - 1));
>  
>  	kvm__emulate_io(vcpu, port, data, direction, len, 1);
>  }
> @@ -420,14 +420,14 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  	vpci->kvm = kvm;
>  	vpci->dev = dev;
>  
> -	r = pci_get_io_port_block(IOPORT_SIZE);
> -	r = ioport__register(kvm, r, &virtio_pci__io_ops, IOPORT_SIZE, vdev);
> +	r = pci_get_io_port_block(PCI_IO_SIZE);
> +	r = ioport__register(kvm, r, &virtio_pci__io_ops, PCI_IO_SIZE, vdev);
>  	if (r < 0)
>  		return r;
>  	vpci->port_addr = (u16)r;
>  
> -	vpci->mmio_addr = pci_get_io_space_block(IOPORT_SIZE);
> -	r = kvm__register_mmio(kvm, vpci->mmio_addr, IOPORT_SIZE, false,
> +	vpci->mmio_addr = pci_get_io_space_block(PCI_IO_SIZE);
> +	r = kvm__register_mmio(kvm, vpci->mmio_addr, PCI_IO_SIZE, false,
>  			       virtio_pci__io_mmio_callback, vpci);
>  	if (r < 0)
>  		goto free_ioport;
> @@ -457,8 +457,8 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  							| PCI_BASE_ADDRESS_SPACE_MEMORY),
>  		.status			= cpu_to_le16(PCI_STATUS_CAP_LIST),
>  		.capabilities		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
> -		.bar_size[0]		= cpu_to_le32(IOPORT_SIZE),
> -		.bar_size[1]		= cpu_to_le32(IOPORT_SIZE),
> +		.bar_size[0]		= cpu_to_le32(PCI_IO_SIZE),
> +		.bar_size[1]		= cpu_to_le32(PCI_IO_SIZE),
>  		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
>  	};
>  
