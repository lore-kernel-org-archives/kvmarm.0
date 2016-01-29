From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/10] KVM PCIe/MSI passthrough on ARM/ARM64
Date: Fri, 29 Jan 2016 22:25:52 +0100
Message-ID: <56ABD8E0.6080409@linaro.org>
References: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
	<1454017899.23148.0.camel@redhat.com> <56AB78B1.2030202@linaro.org>
	<1454096004.9301.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1454096004.9301.1.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, eric.auger-qxv4g6HH51o@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,
On 01/29/2016 08:33 PM, Alex Williamson wrote:
> On Fri, 2016-01-29 at 15:35 +0100, Eric Auger wrote:
>> Hi Alex,
>> On 01/28/2016 10:51 PM, Alex Williamson wrote:
>>> On Tue, 2016-01-26 at 13:12 +0000, Eric Auger wrote:
>>>> This series addresses KVM PCIe passthrough with MSI enabled on ARM/ARM64.
>>>> It pursues the efforts done on [1], [2], [3]. It also aims at covering the
>>>> same need on some PowerPC platforms.
>>>>  
>>>> On x86 all accesses to the 1MB PA region [FEE0_0000h - FEF0_000h] are directed
>>>> as interrupt messages: accesses to this special PA window directly target the
>>>> APIC configuration space and not DRAM, meaning the downstream IOMMU is bypassed.
>>>>  
>>>> This is not the case on above mentionned platforms where MSI messages emitted
>>>> by devices are conveyed through the IOMMU. This means an IOVA/host PA mapping
>>>> must exist for the MSI to reach the MSI controller. Normal way to create
>>>> IOVA bindings consists in using VFIO DMA MAP API. However in this case
>>>> the MSI IOVA is not mapped onto guest RAM but on host physical page (the MSI
>>>> controller frame).
>>>>  
>>>> Following first comments, the spirit of [2] is kept: the guest registers
>>>> an IOVA range reserved for MSI mapping. When the VFIO-PCIe driver allocates
>>>> its MSI vectors, it overwrites the MSI controller physical address with an IOVA,
>>>> allocated within the window provided by the userspace. This IOVA is mapped
>>>> onto the MSI controller frame physical page.
>>>>  
>>>> The series does not address yet the problematic of telling the userspace how
>>>> much IOVA he should provision.
>>>  
>>> I'm sort of on a think-different approach today, so bear with me; how is
>>> it that x86 can make interrupt remapping so transparent to drivers like
>>> vfio-pci while for ARM and ppc we seem to be stuck with doing these
>>> fixups of the physical vector ourselves, implying ugly (no offense)
>>> paths bouncing through vfio to connect the driver and iommu backends?
>>>  
>>> We know that x86 handles MSI vectors specially, so there is some
>>> hardware that helps the situation.  It's not just that x86 has a fixed
>>> range for MSI, it's how it manages that range when interrupt remapping
>>> hardware is enabled.  A device table indexed by source-ID references a
>>> per device table indexed by data from the MSI write itself.  So we get
>>> much, much finer granularity,
>> About the granularity, I think ARM GICv3 now provides a similar
>> capability with GICv3 ITS (interrupt translation service). Along with
>> the MSI MSG write transaction, the device outputs a DeviceID conveyed on
>> the bus. This DeviceID (~ your source-ID) enables to index a device
>> table. The entry in the device table points to a DeviceId interrupt
>> translation table indexed by the EventID found in the msi msg. So the
>> entry in the interrupt translation table eventually gives you the
>> eventual interrupt ID targeted by the MSI MSG.
>> This translation capability if not available in GICv2M though, ie. the
>> one I am currently using.
>>  
>> Those tables currently are built by the ITS irqchip (irq-gic-v3-its.c)
> 
> So it sounds like the interrupt remapping plumbing needs to be
> implemented for those chips.  How does ITS identify an MSI versus any
> other DMA write?  Does it need to be within a preconfigured address
> space like on x86 or does it know this implicitly by the transaction
> (which doesn't seem possible on PCIe)?

It seems there is a kind of misunderstanding here. Assuming a "simple"
system with a single ITS, all devices likely to produce MSI must write
those messages in a single register, located in the ITS MSI 64kB frame
(this register is called GITS_TRANSLATER). Then the ITS discriminates
between senders using the DeviceID conveyed out-of-band on the bus (or
by other implementation defined means). For those DeviceId, a deviceId
interrupt translation table is supposed to exist, else it is going to
fault. If any "undeclared" device is writing into that register, its
deviceid will be unknown. It looks like on Intel the interrupt remapping
HW rather is abstracted on the IOMMU side; I did not take time yet to
carefully read the VT-d spec but maybe the Intel interrupt remapping HW
rather acts as an IOMMU that takes an input MSI address within the
famous window and apply a translation scheme based on the MSI address &
data? On ARM the input MSI address always is the GITS_TRANSLATER and
then the translation scheme is based on out-of-band info (deviceid) +
data content(eventid). I Hope this clarifies.
> 
> Along with this discussion, we should probably be revisiting whether
> existing ARM SMMUs should be exposing the IOMMU_CAP_INTR_REMAP
> capability.

so according to the above explanation not sure it is relevant. Will/Marc
might correct me if I told some wrong things.
  This capability is meant to indicate interrupt isolation,
> but if an entire page of IOVA space is mapped through the IOMMU to a
> range of interrupts and some of those interrupts are shared with host
> devices or other VMs, then we really don't have that isolation and the
> system is susceptible to one VM interfering with another or with the
> host.  If that's the case, the SMMU should not be claiming
> IOMMU_CAP_INTR_REMAP.
My understanding is a PCI device working for the host must have its own
deviceid translation table while another one assigned to a guest needs
to have another one. Each of those will then trigger different final
interrupt IDs in separate domains.

To be honest for the time being I was not addressing the ITS case but
just the simpler GICv2m case where we do not have interrupt translation.
In GICv2m with a single 4kB MSI frame you still have a single register
written by devices. The msg data content then induces a given interrupt ID.

My kernel series "just" aimed at allowing the device to reach the
physical address of the GICv2m MSI frame through the IOMMU.

But you're right here I think I should have a larger vision of what is
targeted with ITS. In GICv2m with a single MSI frame the discrimination
only works on the msi data (there is no deviceid). However it is also
possible to have several GICv2M MSI 4kB frames and in that case you can
give 1 MSI 4kB frame per VM but it is yet another use case. My AMD
system currently exposes a single MSI frame - in which case we have poor
isolation as you say -.
> 
>>  but there's still effectively an interrupt
>>> domain per device that's being transparently managed under the covers
>>> whenever we request an MSI vector for a device.
>>>  
>>> So why can't we do something more like that here?  There's no predefined
>>> MSI vector range, so defining an interface for the user to specify that
>>> is unavoidable.
>> Do you confirm that VFIO user API still still is the good choice to
>> provide that IOVA range?
> 
> I don't see that we have an option there unless ARM wants to
> retroactively reserve a range of IOVA space in the spec, which is
> certainly not going to happen.  The only other thing that comes to mind
> would be if there was an existing address space which could never be
> backed by RAM or other DMA capable targets.  But that seems far fetched
> as well.
I don't think there is a plan for such change and I am afraid we need to
integrate above configurations (GICv2M with a single frame, GICv2M with
several frames, ITS and there may be others not covered here that I am
not aware of).
> 
>>   But why shouldn't everything else be transparent?  We
>>> could add an interface to the IOMMU API that allows us to register that
>>> reserved range for the IOMMU domain.  IOMMU-core (or maybe interrupt
>>> remapping) code might allocate an IOVA domain for this just as you've
>>> done in the type1 code here.
>> I have no objection to move that iova allocation scheme somewhere else.
>> I just need to figure out how to deal with the fact iova.c is not
>> compiled everywhere as I noticed too late ;-)
>>   But rather than having any interaction
>>> with vfio-pci, why not do this at lower levels such that the platform
>>> interrupt vector allocation code automatically uses one of those IOVA
>>> ranges and returns the IOVA rather than the physical address for the PCI
>>> code to program into the device?  I think we know what needs to be done,
>>> but we're taking the approach of managing the space ourselves and doing
>>> a fixup of the device after the core code has done its job when we
>>> really ought to be letting the core code manage a space that we define
>>> and programming the device so that it doesn't need a fixup in the
>>> vfio-pci code.  Wouldn't it be nicer if pci_enable_msix_range() returned
>>> with the device properly programmed or generate an error if there's not
>>> enough reserved mapping space in IOMMU domain?  Can it be done?
>> I agree with you on the fact it would be cleaner to manage that natively
>> at MSI controller level instead of patching the address value in
>> vfio_pci_intrs.c. I will investigate in that direction but I need some
>> more time to understand the links between the MSI controller, the PCI
>> device and the IOMMU.
> 
> Since the current interrupt remapping schemes seem to operate in a
> different address space, I expect there will be work to do to fit the
> interrupt remapping within a provided address space, but it seems like a
> very reasonable constraint to add.  Thanks,

I hope this discussion will help. Please ARM guys, correct me if there
are some unclarities or wrong statements.

Thank you for reading up to here and have a nice WE!

Best Regards

Eric
> 
> Alex
> 
