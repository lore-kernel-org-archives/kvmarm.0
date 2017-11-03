From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH kvmtool 0/2] Add GICv2m support
Date: Fri, 3 Nov 2017 13:46:50 +0000
Message-ID: <d8086b6b-6a24-c86d-84de-75a2945cb391@arm.com>
References: <20171103113841.3066-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171103113841.3066-1-jean-philippe.brucker@arm.com>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com, punit.agrawal@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 03/11/17 11:38, Jean-Philippe Brucker wrote:
> GICv2m is an extension to GICv2 defined in the Server Base System
> Architecture (SBSA) [1], allowing pre-GICv3 platforms to support MSIs.
> 
> Presenting GICv2m frames to the guest can be useful for testing PCI
> pass-through on platforms that have a GICv2m, for example AMD Seattle.
> Otherwise they are forced to use legacy INTx.
> 
> This series adds a GICv2m frame to kvmtool, which is basically an MMIO
> register telling the guest which SPIs (Shared Peripheral Interrupts) are
> reserved for MSIs. When configuring MSI vectors, the guest writes the
> desired SPI number into the MSI data field. Then in kvmtool we create
> the IRQFD routes such that they inject the given SPI.
> 
> [1] https://developer.arm.com/products/architecture/a-profile/docs/den0029/latest/server-base-system-architecture
> 
> Jean-Philippe Brucker (2):
>   Prevent segfault when kvm_pause is called too early
>   Add GICv2m support
> 
>  Makefile                                 |   2 +-
>  arm/aarch32/include/asm/kvm.h            |   2 +
>  arm/aarch64/include/asm/kvm.h            |   2 +
>  arm/gic.c                                |  13 +++
>  arm/gicv2m.c                             | 153 +++++++++++++++++++++++++++++++
>  arm/include/arm-common/gic.h             |   3 +
>  arm/include/arm-common/kvm-config-arch.h |   2 +-
>  include/kvm/irq.h                        |  11 +++
>  irq.c                                    |  68 +++++++++++---
>  kvm.c                                    |   2 +-
>  virtio/pci.c                             |   4 +-
>  11 files changed, 245 insertions(+), 17 deletions(-)
>  create mode 100644 arm/gicv2m.c
> 

Thanks for putting this together. For both patches:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
