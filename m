From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 3/7] PCI: OF: Allow endpoints to bypass the iommu
Date: Thu, 18 Oct 2018 11:47:18 +0100
Message-ID: <e609de5e-1be2-594e-a4a9-ec1a40d997ab@arm.com>
References: <20181012145917.6840-1-jean-philippe.brucker@arm.com>
 <20181012145917.6840-4-jean-philippe.brucker@arm.com>
 <20181012194158.GX5906@bhelgaas-glaptop.roam.corp.google.com>
 <20181015065024-mutt-send-email-mst@kernel.org>
 <482d0eb9-8c4c-9d64-7b32-25d5d11a8b8f@gmail.com>
 <20181017111100-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 384304A1D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Oct 2018 06:47:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KagqbgsED6kI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Oct 2018 06:47:24 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B923749F94
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Oct 2018 06:47:24 -0400 (EDT)
In-Reply-To: <20181017111100-mutt-send-email-mst@kernel.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Michael S. Tsirkin" <mst@redhat.com>, Jean-philippe Brucker <jphilippe.brucker@gmail.com>
Cc: devicetree@vger.kernel.org, kevin.tian@intel.com, tnowicki@caviumnetworks.com, marc.zyngier@arm.com, linux-pci@vger.kernel.org, jasowang@redhat.com, will.deacon@arm.com, virtualization@lists.linux-foundation.org, iommu@lists.linux-foundation.org, robh+dt@kernel.org, Bjorn Helgaas <helgaas@kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 17/10/18 16:14, Michael S. Tsirkin wrote:
> On Mon, Oct 15, 2018 at 08:46:41PM +0100, Jean-philippe Brucker wrote:
>> [Replying with my personal address because we're having SMTP issues]
>>
>> On 15/10/2018 11:52, Michael S. Tsirkin wrote:
>>> On Fri, Oct 12, 2018 at 02:41:59PM -0500, Bjorn Helgaas wrote:
>>>> s/iommu/IOMMU/ in subject
>>>>
>>>> On Fri, Oct 12, 2018 at 03:59:13PM +0100, Jean-Philippe Brucker wrote:
>>>>> Using the iommu-map binding, endpoints in a given PCI domain can be
>>>>> managed by different IOMMUs. Some virtual machines may allow a subset of
>>>>> endpoints to bypass the IOMMU. In some case the IOMMU itself is presented
>>>>
>>>> s/case/cases/
>>>>
>>>>> as a PCI endpoint (e.g. AMD IOMMU and virtio-iommu). Currently, when a
>>>>> PCI root complex has an iommu-map property, the driver requires all
>>>>> endpoints to be described by the property. Allow the iommu-map property to
>>>>> have gaps.
>>>>
>>>> I'm not an IOMMU or virtio expert, so it's not obvious to me why it is
>>>> safe to allow devices to bypass the IOMMU.  Does this mean a typo in
>>>> iommu-map could inadvertently allow devices to bypass it?
>>>
>>>
>>> Thinking about this comment, I would like to ask: can't the
>>> virtio device indicate the ranges in a portable way?
>>> This would minimize the dependency on dt bindings and ACPI,
>>> enabling support for systems that have neither but do
>>> have virtio e.g. through pci.
>>
>> I thought about adding a PROBE request for this in virtio-iommu, but it
>> wouldn't be usable by a Linux guest because of a bootstrapping problem.
> 
> Hmm. At some level it seems wrong to design hardware interfaces
> around how Linux happens to probe things. That can change at any time
> ...

This isn't Linux-specific though. In general it's somewhere between 
difficult and impossible to pull in an IOMMU underneath a device after 
at device is active, so if any OS wants to use an IOMMU, it's going to 
want to know up-front that it's there and which devices it translates so 
that it can program said IOMMU appropriately *before* potentially 
starting DMA and/or interrupts from the relevant devices. Linux happens 
to do things in that order (either by firmware-driven probe-deferral or 
just perilous initcall ordering) because it is the only reasonable order 
in which to do them. AFAIK the platforms which don't rely on any 
firmware description of their IOMMU tend to have a fairly static system 
architecture (such that the OS simply makes hard-coded assumptions), so 
it's not necessarily entirely clear how they would cope with 
virtio-iommu either way.

Robin.

>> Early on, Linux needs a description of device dependencies, to determine
>> in which order to probe them. If the device dependency was described by
>> virtio-iommu itself, the guest could for example initialize a NIC,
>> allocate buffers and start DMA on the physical address space (which aborts
>> if the IOMMU implementation disallows DMA by default), only to find out
>> once the virtio-iommu module is loaded that it needs to cancel all DMA and
>> reconfigure the NIC. With a static description such as iommu-map in DT or
>> ACPI remapping tables, the guest can defer probing of the NIC until the
>> IOMMU is initialized.
>>
>> Thanks,
>> Jean
> 
> Could you point me at the code you refer to here?
> 
