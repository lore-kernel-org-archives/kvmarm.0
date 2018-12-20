From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v6 0/7] Add virtio-iommu driver
Date: Thu, 20 Dec 2018 17:59:46 +0000
Message-ID: <e1c7aee9-083d-103a-87a9-b59d5e63d7aa@arm.com>
References: <20181211182104.18241-1-jean-philippe.brucker@arm.com>
 <20181212103545.GV16835@8bytes.org>
 <9110873f-d344-b6b9-c722-9accfc329db2@arm.com>
 <20181219180417-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <virtio-dev-return-5203-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20181219180417-mutt-send-email-mst@kernel.org>
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, "tnowicki@caviumnetworks.com" <tnowicki@caviumnetworks.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>, Will Deacon <Will.Deacon@arm.com>, Robin Murphy <Robin.Murphy@arm.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "eric.auger@redhat.com" <eric.auger@redhat.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "bhelgaas@google.com" <bhelgaas@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 19/12/2018 23:09, Michael S. Tsirkin wrote:
> On Thu, Dec 13, 2018 at 12:50:29PM +0000, Jean-Philippe Brucker wrote:
>>>> [3] git://linux-arm.org/linux-jpb.git virtio-iommu/v0.9.1
>>>>      git://linux-arm.org/kvmtool-jpb.git virtio-iommu/v0.9
>>>
>>> Unfortunatly gitweb seems to be broken on linux-arm.org. What is missing
>>> in this patch-set to make this work on x86?
>>
>> You should be able to access it here:
>> http://www.linux-arm.org/git?p=linux-jpb.git;a=shortlog;h=refs/heads/virtio-iommu/devel
>>
>> That branch contains missing bits for x86 support:
>>
>> * ACPI support. We have the code but it's waiting for an IORT spec
>> update, to reserve the IORT node ID. I expect it to take a while, given
>> that I'm alone requesting a change for something that's not upstream or
>> in hardware.
> 
> Frankly I think you should take a hard look at just getting the data
> needed from the PCI device itself.  You don't need to depend on virtio,
> it can be a small driver that gets you that data from the device config
> space and then just goes away.
> 
> If you want help with writing such a small driver let me know.
> 
> If there's an advantage to virtio-iommu then that would be its
> portability, and it all goes out of the window because
> of dependencies on ACPI and DT and OF and the rest of the zoo.

But the portable solutions are ACPI and DT.

Describing the DMA dependency through a device would require the guest
to probe the device before all others. How do we communicate this?
* pass a kernel parameter saying something like "probe_first=00:01.0"
* make sure that the PCI root complex is probed before any other
platform device (since the IOMMU can manage DMA of platform devices).
* change DT, ACPI and PCI core code to handle this probe_first kernel
parameter.

Better go with something standard, that any OS and hypervisor knows how
to use, and that other IOMMU devices already use.

>> * DMA ops for x86 (see "HACK" commit). I'd like to use dma-iommu but I'm
>> not sure how to implement the glue that sets dma_ops properly.
>>
>> Thanks,
>> Jean
> 
> OK so IIUC you are looking into Christoph's suggestions to fix that up?

Eventually yes. I'll give it a try next year, once the dma-iommu changes
are on the list. It's not a priority for me, given that x86 already has
a pvIOMMU with VT-d, and that Arm still needs one. It shouldn't block
this series.

> There's still a bit of time left before the merge window,
> maybe you can make above changes.

I'll wait to see if Joerg has other concerns about the design or the
code, and resend in January. I think that IOMMU driver changes should go
through his tree.

Thanks,
Jean
