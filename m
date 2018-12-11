From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v6 0/7] Add virtio-iommu driver
Date: Tue, 11 Dec 2018 19:07:41 +0000
Message-ID: <f9cb0ebe-4d9f-50f1-9f61-89d0e55ceddc@arm.com>
References: <20181211182104.18241-1-jean-philippe.brucker@arm.com>
 <20181211183101.GA31936@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <virtio-dev-return-5185-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20181211183101.GA31936@infradead.org>
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: mark.rutland@arm.com, virtio-dev@lists.oasis-open.org, kevin.tian@intel.com, tnowicki@caviumnetworks.com, devicetree@vger.kernel.org, marc.zyngier@arm.com, linux-pci@vger.kernel.org, mst@redhat.com, will.deacon@arm.com, frowand.list@gmail.com, virtualization@lists.linux-foundation.org, iommu@lists.linux-foundation.org, robh+dt@kernel.org, kvmarm@lists.cs.columbia.edu, bhelgaas@google.com, robin.murphy@arm.com, jasowang@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 11/12/2018 18:31, Christoph Hellwig wrote:
> On Tue, Dec 11, 2018 at 06:20:57PM +0000, Jean-Philippe Brucker wrote:
>> Implement the virtio-iommu driver, following specification v0.9 [1].
>>
>> Only minor changes since v5 [2]. I fixed issues reported by Michael and
>> added tags from Eric and Bharat. Thanks!
>>
>> You can find Linux driver and kvmtool device on v0.9 branches [3],
>> module and x86 support on virtio-iommu/devel. Also tested with Eric's
>> QEMU device [4].
> 
> Just curious, what is the use case for it?

The main use case is assigning a device to guest userspace, using VFIO
both in the host and in the guest (the most cited example being DPDK).
There are others, and I wrote a little more about them last week:
https://www.spinics.net/lists/linux-pci/msg78529.html

Thanks,
Jean
