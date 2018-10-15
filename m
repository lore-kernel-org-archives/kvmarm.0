From: Jean-philippe Brucker <jphilippe.brucker-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 3/7] PCI: OF: Allow endpoints to bypass the iommu
Date: Mon, 15 Oct 2018 20:46:41 +0100
Message-ID: <482d0eb9-8c4c-9d64-7b32-25d5d11a8b8f@gmail.com>
References: <20181012145917.6840-1-jean-philippe.brucker@arm.com>
	<20181012145917.6840-4-jean-philippe.brucker@arm.com>
	<20181012194158.GX5906@bhelgaas-glaptop.roam.corp.google.com>
	<20181015065024-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20181015065024-mutt-send-email-mst-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

[Replying with my personal address because we're having SMTP issues]

On 15/10/2018 11:52, Michael S. Tsirkin wrote:
> On Fri, Oct 12, 2018 at 02:41:59PM -0500, Bjorn Helgaas wrote:
>> s/iommu/IOMMU/ in subject
>>
>> On Fri, Oct 12, 2018 at 03:59:13PM +0100, Jean-Philippe Brucker wrote:
>>> Using the iommu-map binding, endpoints in a given PCI domain can be
>>> managed by different IOMMUs. Some virtual machines may allow a subset of
>>> endpoints to bypass the IOMMU. In some case the IOMMU itself is presented
>>
>> s/case/cases/
>>
>>> as a PCI endpoint (e.g. AMD IOMMU and virtio-iommu). Currently, when a
>>> PCI root complex has an iommu-map property, the driver requires all
>>> endpoints to be described by the property. Allow the iommu-map property to
>>> have gaps.
>>
>> I'm not an IOMMU or virtio expert, so it's not obvious to me why it is
>> safe to allow devices to bypass the IOMMU.  Does this mean a typo in
>> iommu-map could inadvertently allow devices to bypass it?
> 
> 
> Thinking about this comment, I would like to ask: can't the
> virtio device indicate the ranges in a portable way?
> This would minimize the dependency on dt bindings and ACPI,
> enabling support for systems that have neither but do
> have virtio e.g. through pci.

I thought about adding a PROBE request for this in virtio-iommu, but it
wouldn't be usable by a Linux guest because of a bootstrapping problem.

Early on, Linux needs a description of device dependencies, to determine
in which order to probe them. If the device dependency was described by
virtio-iommu itself, the guest could for example initialize a NIC,
allocate buffers and start DMA on the physical address space (which aborts
if the IOMMU implementation disallows DMA by default), only to find out
once the virtio-iommu module is loaded that it needs to cancel all DMA and
reconfigure the NIC. With a static description such as iommu-map in DT or
ACPI remapping tables, the guest can defer probing of the NIC until the
IOMMU is initialized.

Thanks,
Jean
