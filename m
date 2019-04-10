From: Vincent =?utf-8?Q?Stehl=C3=A9?= <vincent.stehle@arm.com>
Subject: Re: [PATCH v6 09/22] vfio: VFIO_IOMMU_BIND/UNBIND_MSI
Date: Wed, 10 Apr 2019 14:35:32 +0200
Message-ID: <20190410123531.GA19023@debian>
References: <20190317172232.1068-1-eric.auger@redhat.com>
 <20190317172232.1068-10-eric.auger@redhat.com>
 <20190321170159.38358f38@x1.home>
 <16931d58-9c88-8cfb-a392-408ea7afdf16@redhat.com>
 <20190322160947.3f8dacdb@x1.home>
 <b47128de-88d0-1971-1fbc-86e43439c7ee@redhat.com>
 <20190403113800.51503693@x1.home>
 <4b27b707-4917-2c3e-a13c-3b978e850d09@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4b27b707-4917-2c3e-a13c-3b978e850d09@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com, kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 04, 2019 at 08:55:25AM +0200, Auger Eric wrote:
> Hi Marc, Robin, Alex,
(..)
> Do you think this is a reasonable assumption to consider devices within
> the same host iommu group share the same MSI doorbell?

Hi Eric,

I am not sure this assumption always hold.

Marc, Robin and Alex can correct me, but for example I think the following
topology is valid for Arm systems:

 +------------+  +------------+
 | Endpoint A |  | Endpoint B |
 +------------+  +------------+
            v     v
          /---------\
         |  Non-ACS  |
         |  Switch   |
          \---------/
               v
       +---------------+
       |     PCIe      |
       | Root Complex  |
       +---------------+
               v
         +-----------+
         |   SMMU    |
         +-----------+
               v
  +--------------------------+
  |   System interconnect    |
  +--------------------------+
        v              v
  +-----------+  +-----------+
  |   ITS A   |  |   ITS B   |
  +-----------+  +-----------+

All PCIe Endpoints and ITS could be in the same ITS Group 0, meaning
devices could send their MSI at any ITS in hardware.

For Linux the two PCIe Endpoints would be in the same iommu group, because
the switch in this example does not support ACS.

I think the devicetree msi-map property could be used to "map" the RID of
Endpoint A to ITS A and the RID of Endpoint B to ITS B, which would violate
the assumption.

See the monolithic example in [1], the example system in [2], appendices
D, E and F in [3] and the msi-map property in [4].

Best regards,
Vincent.

[1] https://static.docs.arm.com/100336/0102/corelink_gic600_generic_interrupt_controller_technical_reference_manual_100336_0102_00_en.pdf
[2] http://infocenter.arm.com/help/topic/com.arm.doc.den0049d/DEN0049D_IO_Remapping_Table.pdf
[3] https://static.docs.arm.com/den0029/50/Q1-DEN0029B_SBSA_5.0.pdf
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/pci/pci-msi.txt
