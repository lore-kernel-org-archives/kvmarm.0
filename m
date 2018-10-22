From: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 3/7] PCI: OF: Allow endpoints to bypass the iommu
Date: Mon, 22 Oct 2018 12:27:50 +0100
Message-ID: <e5c44d21-7b43-32dd-4f5f-3136bacb07e0@arm.com>
References: <20181012145917.6840-1-jean-philippe.brucker@arm.com>
	<20181012145917.6840-4-jean-philippe.brucker@arm.com>
	<20181012194158.GX5906@bhelgaas-glaptop.roam.corp.google.com>
	<20181015065024-mutt-send-email-mst@kernel.org>
	<482d0eb9-8c4c-9d64-7b32-25d5d11a8b8f@gmail.com>
	<20181017111100-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20181017111100-mutt-send-email-mst-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-philippe Brucker <jphilippe.brucker-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, robin.murphy-5wv7dgnIgG8@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On 17/10/2018 16:14, Michael S. Tsirkin wrote:
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

I suspect that most other OS will also solve this class of problem using
a standard such as DT or ACPI, because they also provide dependency for
clock, interrupts, power management, etc. We can add a self-contained
PROBE method if someone makes a case for it, but it's unlikely to get
used at all, and nearly impossible to implement in Linux. The host would
still need a method to tell the guest which device to probe first, for
example with kernel parameters.

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

In drivers/base/dd.c, really_probe() calls dma_configure() before the
device driver's probe(). dma_configure() ends up calling either
of_dma_configure() or acpi_dma_configure(), which return -EPROBE_DEFER
if the device's IOMMU isn't yet available. In that case the device is
added to the deferred pending list.

After another device is successfully bound to a driver, all devices on
the pending list are retried (driver_deferred_probe_trigger()), and if
the dependency has been resolved, then dma_configure() succeeds.

Another method (used by Intel and AMD IOMMU drivers) is to initialize
the IOMMU as early as possible, after discovering it in the ACPI tables
and before probing other devices. This can't work for virtio-iommu
because the driver might be a module, in which case early init isn't
possible. We have to defer probe of all dependent devices until the
virtio and virtio-iommu modules are loaded.

Thanks,
Jean
