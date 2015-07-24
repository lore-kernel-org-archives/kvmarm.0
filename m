From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: [RFC 0/2] VFIO: Add virtual MSI doorbell support.
Date: Fri, 24 Jul 2015 14:33:08 +0530
Message-ID: <1437728590-23126-1-git-send-email-pranavkumar@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84EC859166
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 04:51:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UbnSx8DV3SeG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jul 2015 04:51:09 -0400 (EDT)
Received: from mail-pd0-f173.google.com (mail-pd0-f173.google.com
 [209.85.192.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 843ED59109
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 04:51:09 -0400 (EDT)
Received: by pdjr16 with SMTP id r16so10904300pdj.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2015 02:03:23 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: rob.herring@linaro.org, arnd@arndb.de, marc.zyngier@arm.com, patches@apm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, linux-arm-kernel@lists.infradead.org, bhelgaas@google.com
List-Id: kvmarm@lists.cs.columbia.edu

In current VFIO MSI/MSI-X implementation, linux host kernel
allocates MSI/MSI-X vectors when userspace requests through vfio ioctls.
Vfio creates irqfd mappings to notify MSI/MSI-X interrupts
to the userspace when raised.
Guest OS will see emulated MSI/MSI-X controller and receives an interrupt
when kernel notifies the same via irqfd.

Host kernel allocates MSI/MSI-X using standard linux routines
like pci_enable_msix_range() and pci_enable_msi_range(). 
These routines along with requset_irq() in host kernel sets up 
MSI/MSI-X vectors with Physical MSI/MSI-X addresses provided by
interrupt controller driver in host kernel.

This means when a device is assigned with the guest OS, MSI/MSI-X addresses
present in PCIe EP are the PAs programmed by the host linux kernel.

In x86 MSI/MSI-X physical address range is reserved and iommu is aware
about these addreses and transalation is bypassed for these address range.

Unlike x86, ARM/ARM64 does not reserve MSI/MSI-X Physical address range and
all the transactions including MSI go through iommu/smmu without bypass.
This requires extending current vfio MSI layer with additional functionality
for ARM/ARM64 by
1. Programing IOVA (referred as a MSI virtual doorbell address)
   in device's MSI vector as a MSI address.
   This IOVA will be provided by the userspace based on the
   MSI/MSI-X addresses reserved for the guest.
2. Create an IOMMU mapping between this IOVA and
   Physical address (PA) assigned to the MSI vector.

This RFC is proposing a solution for MSI/MSI-X passthrough for ARM/ARM64.

Pranavkumar Sawargaonkar (2):
  drivers: vfio: iommu map and unmap device specific memory from
    kernel.
  drivers: vfio: pci: Add virtual MSI doorbell support.

 drivers/vfio/pci/vfio_pci.c         |   32 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci_intrs.c   |   64 +++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |    3 ++
 drivers/vfio/vfio.c                 |   29 ++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c     |   60 ++++++++++++++++++++++++++++++++
 include/linux/vfio.h                |   11 +++++-
 include/uapi/linux/vfio.h           |   19 +++++++++++
 7 files changed, 217 insertions(+), 1 deletion(-)

-- 
1.7.9.5
