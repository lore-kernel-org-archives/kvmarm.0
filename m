From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: ARM PCI/MSI KVM passthrough with GICv2M
Date: Mon, 8 Feb 2016 14:27:41 +0100
Message-ID: <56B897CD.1000402@linaro.org>
References: <1454017899.23148.0.camel@redhat.com>
	<56AB78B1.2030202@linaro.org> <1454096004.9301.1.camel@redhat.com>
	<56ABD8E0.6080409@linaro.org> <20160201140351.GE6828@arm.com>
	<20160203125047.GB13974@cbox> <20160203131057.GA20217@arm.com>
	<20160203153606.GC13974@cbox> <56B4DC97.60904@linaro.org>
	<20160205111700.726ac061@t450s.home> <20160208094826.GA620@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160208094826.GA620@cbox>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: eric.auger-qxv4g6HH51o@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex, Christoffer,
On 02/08/2016 10:48 AM, Christoffer Dall wrote:
> On Fri, Feb 05, 2016 at 11:17:00AM -0700, Alex Williamson wrote:
>> On Fri, 5 Feb 2016 18:32:07 +0100
>> Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>
>>> Hi Alex,
>>>
>>> I tried to sketch a proposal for guaranteeing the IRQ integrity when
>>> doing ARM PCI/MSI passthrough with ARM GICv2M msi-controller. This is
>>> based on extended VFIO group viability control, as detailed below.
>>>
>>> As opposed to ARM GICv3 ITS, this MSI controller does *not* support IRQ
>>> remapping. It can expose 1 or more 4kB MSI frame. Each frame contains a
>>> single register where the msi data is written.
>>>
>>> I would be grateful to you if you could tell me whether it makes any sense.
>>>
>>> Thanks in advance
>>>
>>> Best Regards
>>>
>>> Eric
>>>
>>>
>>> 1) GICv2m with a single 4kB single frame
>>>    all devices having this msi-controller as msi-parent share this
>>>    single MSI frame. Those devices can work on behalf of the host
>>>    or work on behalf of 1 or more guests (KVM assigned devices). We
>>>    must make sure either the host only or 1 single VM can access to the
>>>    single frame to guarantee interrupt integrity: a device assigned
>>>    to 1 VM should not be able to trigger MSI targeted to the host
>>>    or another VM.
>>>
>>>    I would propose to extend the VFIO notion of group viability.
>>>    Currently a VFIO group is viable if:
>>>    all devices belonging to the same group are bound to a VFIO driver
>>>    or unbound.
>>>
>>>    Let's imagine we extend the viability check as follows:
>>>
>>>    0) keep the current viable check: all the devices belonging to
>>>       the group must be vfio bound or unbound.
>>>    1) retrieve the MSI parent of the device and list all the
>>>       other devices using that MSI controller as MSI-parent (does not
>>>       look straightforward):
>>>    2) they must be VFIO driver bound or unbound as well (meaning
>>>       they are not used by the host). If not, reject device attachment
>>>    - in case they are VFIO bound (a VFIO group is set):
>>>      x if all VFIO containers are the same as the one of the device's
>>>        we try to attach, that's OK. This means the other devices
>>>        use different IOMMU mappings, eventually will target the
>>>        MSI frame but they all work for the same user space client/VM.
>>>      x 1 or more devices has a different container than the device
>>>        under attachment:
>>>        It works on behalf of a different user space client/VM,
>>>        we can't attach the new device. I think there is a case however
>>>        where severals containers can be opened by a single QEMU.
>>>
>>> Of course the dynamic aspects, ie a new device showing up or an unbind
>>> event bring significant complexity.
>>>
>>> 2) GICv2M with multiple 4kB frames
>>>    Each msi-frame is enumerated as msi-controller. The device tree
>>>    statically defines which device is attached to each msi frame.
>>>    In case devices are assigned we cannot change this attachment
>>>    anyway since there might be physical contraints behind.
>>>    So devices likely to be assigned to guests should be linked to a
>>>    different MSI frame than devices that are not.
>>>
>>>    I think extended viability concept can be used as well.
>>>
>>>    This model still is not ideal: in case we have a SR-IOV device
>>>    plugged onto an host bridge attached to a single MSI parent you won't
>>>    be able anyway to have 1 Virtual Function working for host and 1 VF
>>>    working for a guest. Only Interrupt translation (ITS) will bring that
>>>    feature.
>>>
>>> 3) GICv3 ITS
>>>    This one supports interrupt translation service ~ Intel
>>>    IRQ remapping.
>>>    This means a single frame can be used by all devices. A deviceID is
>>>    used exclusively by the host or a guest. I assume the ITS driver
>>>    allocates/populates deviceid interrupt translation table featuring
>>>    separate LPI spaces ie by construction different ITT cannot feature
>>>    same LPIs. So no need to do the extended viability test.
>>>
>>>    The MSI controller should have a property telling whether
>>>    it supports interrupt translation. This kind of property currently
>>>    exists on IOMMU side for INTEL remapping.
>>>
>>
>> Hi Eric,
>>
>> Would anyone be terribly upset if we simply assume the worst case
>> scenario on GICv2m/M, have the IOMMU not claim IOMMU_CAP_INTR_REMAP, and
>> require the user to opt-in via the allow_unsafe_interrupts on the
>> vfio_iommu_type1 module?  That would make it very compatible with what
>> we already do on x86, where it really is all or nothing.  
> 
> meaning either you allow unsafe multiplexing with passthrough in every
> flavor (unsafely) or you don't allow it at all?
that's my understanding. if the iommu does not expose
IOMMU_CAP_INTR_REMAP, the end-user must explicitly turn
allow_unsafe_interrupts on. On ARM we will have the handle the fact the
interrupt translation is handled on interrupt controller side and not on
iommu side though;
>
> I didn't know such on option existed, but it seems to me that this fits
> the bill exactly.
well I think the support of multiple GICv2m MSI frames was devised to
allow safe interrupts but extending the VFIO viability notion as
described above effectively seems a huge work with small benefits since
we don't have much HW featuring multiple frames I am afraid. So I think
it is a good compromise to have a minimal integration with GICv2m and
full feature with best fitted HW, ie. GICv3 ITS.
> 
> 
>> My assumption
>> is that GICv2 would be phased out in favor of GICv3, so there's always
>> a hardware upgrade path to having more complete isolation, but the
>> return on investment for figuring out whether a given device really has
>> this sort of isolation seems pretty low.  Often users already have some
>> degree of trust in the VMs they use for device assignment anyway.  An
>> especially prudent user can still look at the hardware specs for their
>> specific system to understand whether any devices are fully isolated
>> and only make use of those for device assignment.  Does that seem like
>> a reasonable alternative?
>>
> 
> It sounds good to me, that would allow us to release a GICv2m-based
> solution for MSI passthrough on currently available hardware like the
> Seattle.

Sounds good to me too. I am going to respin the kernel series according
to this discussion and previous comments.

Thanks for your comments!

Best Regards

Eric
> 
> Thanks,
> -Christoffer
> 
