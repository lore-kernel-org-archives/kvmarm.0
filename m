From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [virtio-dev] [RFC PATCH v2 4/5] ACPI/IORT: Support
 paravirtualized IOMMU
Date: Wed, 29 Nov 2017 15:17:55 +0000
Message-ID: <aea995d0-333b-cfec-abe7-2e59ef37c19e@arm.com>
References: <20171117185211.32593-1-jean-philippe.brucker@arm.com>
 <20171117185211.32593-5-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20171117185211.32593-5-jean-philippe.brucker@arm.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "devel@acpica.org" <devel@acpica.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>
Cc: "jasowang@redhat.com" <jasowang@redhat.com>, "mst@redhat.com" <mst@redhat.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, Sudeep Holla <Sudeep.Holla@arm.com>, "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, "lenb@kernel.org" <lenb@kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, Marc Zyngier <Marc.Zyngier@arm.com>, Robin Murphy <Robin.Murphy@arm.com>, Will Deacon <Will.Deacon@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>, "bharat.bhushan@nxp.com" <bharat.bhushan@nxp.com>, "Jayachandran.Nair@cavium.com" <Jayachandran.Nair@cavium.com>, ashok.
List-Id: kvmarm@lists.cs.columbia.edu

On 17/11/17 18:52, Jean-Philippe Brucker wrote:
> To describe the virtual topology in relation to a virtio-iommu device,
> ACPI-based systems use a "paravirtualized IOMMU" IORT node. Add support
> for it.
> 
> This is a RFC because the IORT specification doesn't describe the
> paravirtualized node at the moment, it is only provided as an example in
> the virtio-iommu spec. What we need to do first is confirm that x86
> kernels are able to use the IORT driver with the virtio-iommu. There isn't
> anything specific to arm64 in the driver but there might be other blockers
> we're not aware of (I know for example that x86 also requires custom DMA
> ops rather than iommu-dma ones, but it's unrelated) so this needs to be
> tested on the x86 prototype.

I tested IORT with an x86 guest, putting a virtio-iommu on the PCI bus and
it worked fine :)

x86 still requires additional code [1] for using the IOMMU DMA ops,
and I'm not comfortable enough with x86 to write the patch, but for
instantiating virtio-iommus and for enumerating endpoints/buses connected
to them, IORT should suffice.

Thanks,
Jean

[1]
http://www.linux-arm.org/git?p=linux-jpb.git;a=patch;h=e910e224b58712151dda06df595a53ff07edef63;hp=e7f9475480c24c5f973711984b30cf6746ff3ec8
