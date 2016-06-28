From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Tue, 28 Jun 2016 13:02:55 +0200
Message-ID: <6fc9f102-0d73-68cc-592b-5d74479c0351@redhat.com>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
 <20160627091619.GB26498@cbox>
 <CAKv+Gu9u2f6+HLYMzqtkq0z=Xk5gTq=_11QvAKMaBZj_oRMwTA@mail.gmail.com>
 <20160627103421.GC26498@cbox>
 <CAKv+Gu9uBow4FqmA701J76CZ9Npi2j6ADXEJhXAax5whiQkP1A@mail.gmail.com>
 <20160627133508.GI26498@cbox>
 <CAKv+Gu_zQErcMy6h0J71TfrkwRC0TqoQxmjRCNoeyJeD-zX7Kg@mail.gmail.com>
 <BFB29C33-2C3B-4C59-B38A-DACF6D13C2F9@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAAA849B4A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 06:57:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qCmzv3YnDSwV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2016 06:57:49 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A155049B46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 06:57:49 -0400 (EDT)
In-Reply-To: <BFB29C33-2C3B-4C59-B38A-DACF6D13C2F9@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/27/16 16:29, Alexander Graf wrote:
> 
> 
>> Am 27.06.2016 um 15:57 schrieb Ard Biesheuvel <ard.biesheuvel@linaro.org>:
>>
>>> On 27 June 2016 at 15:35, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>>>> On Mon, Jun 27, 2016 at 02:30:46PM +0200, Ard Biesheuvel wrote:
>>>>> On 27 June 2016 at 12:34, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>>>>>> On Mon, Jun 27, 2016 at 11:47:18AM +0200, Ard Biesheuvel wrote:
>>>>>>> On 27 June 2016 at 11:16, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I'm going to ask some stupid questions here...
>>>>>>>
>>>>>>>> On Fri, Jun 24, 2016 at 04:04:45PM +0200, Ard Biesheuvel wrote:
>>>>>>>> Hi all,
>>>>>>>>
>>>>>>>> This old subject came up again in a discussion related to PCIe support
>>>>>>>> for QEMU/KVM under Tianocore. The fact that we need to map PCI MMIO
>>>>>>>> regions as cacheable is preventing us from reusing a significant slice
>>>>>>>> of the PCIe support infrastructure, and so I'd like to bring this up
>>>>>>>> again, perhaps just to reiterate why we're simply out of luck.
>>>>>>>>
>>>>>>>> To refresh your memories, the issue is that on ARM, PCI MMIO regions
>>>>>>>> for emulated devices may be backed by memory that is mapped cacheable
>>>>>>>> by the host. Note that this has nothing to do with the device being
>>>>>>>> DMA coherent or not: in this case, we are dealing with regions that
>>>>>>>> are not memory from the POV of the guest, and it is reasonable for the
>>>>>>>> guest to assume that accesses to such a region are not visible to the
>>>>>>>> device before they hit the actual PCI MMIO window and are translated
>>>>>>>> into cycles on the PCI bus.
>>>>>>>
>>>>>>> For the sake of completeness, why is this reasonable?
>>>>>>
>>>>>> Because the whole point of accessing these regions is to communicate
>>>>>> with the device. It is common to use write combining mappings for
>>>>>> things like framebuffers to group writes before they hit the PCI bus,
>>>>>> but any caching just makes it more difficult for the driver state and
>>>>>> device state to remain synchronized.
>>>>>>
>>>>>>> Is this how any real ARM system implementing PCI would actually work?
>>>>>>
>>>>>> Yes.
>>>>>>
>>>>>>>> That means that mapping such a region
>>>>>>>> cacheable is a strange thing to do, in fact, and it is unlikely that
>>>>>>>> patches implementing this against the generic PCI stack in Tianocore
>>>>>>>> will be accepted by the maintainers.
>>>>>>>>
>>>>>>>> Note that this issue not only affects framebuffers on PCI cards, it
>>>>>>>> also affects emulated USB host controllers (perhaps Alex can remind us
>>>>>>>> which one exactly?) and likely other emulated generic PCI devices as
>>>>>>>> well.
>>>>>>>>
>>>>>>>> Since the issue exists only for emulated PCI devices whose MMIO
>>>>>>>> regions are backed by host memory, is there any way we can already
>>>>>>>> distinguish such memslots from ordinary ones? If we can, is there
>>>>>>>> anything we could do to treat these specially? Perhaps something like
>>>>>>>> using read-only memslots so we can at least trap guest writes instead
>>>>>>>> of having main memory going out of sync with the caches unnoticed? I
>>>>>>>> am just brainstorming here ...
>>>>>>>
>>>>>>> I think the only sensible solution is to make sure that the guest and
>>>>>>> emulation mappings use the same memory type, either cached or
>>>>>>> non-cached, and we 'simply' have to find the best way to implement this.
>>>>>>>
>>>>>>> As Drew suggested, forcing some S2 mappings to be non-cacheable is the
>>>>>>> one way.
>>>>>>>
>>>>>>> The other way is to use something like what you once wrote that rewrites
>>>>>>> stage-1 mappings to be cacheable, does that apply here ?
>>>>>>>
>>>>>>> Do we have a clear picture of why we'd prefer one way over the other?
>>>>>>
>>>>>> So first of all, let me reiterate that I could only find a single
>>>>>> instance in QEMU where a PCI MMIO region is backed by host memory,
>>>>>> which is vga-pci.c. I wonder of there are any other occurrences, but
>>>>>> if there aren't any, it makes much more sense to prohibit PCI BARs
>>>>>> backed by host memory rather than spend a lot of effort working around
>>>>>> it.
>>>>>
>>>>> Right, ok.  So Marc's point during his KVM Forum talk was basically,
>>>>> don't use the legacy VGA adapter on ARM and use virtio graphics, right?
>>>>
>>>> Yes. But nothing is preventing you currently from using that, and I
>>>> think we should prefer crappy performance but correct operation over
>>>> the current situation. So in general, we should either disallow PCI
>>>> BARs backed by host memory, or emulate them, but never back them by a
>>>> RAM memslot when running under ARM/KVM.
>>>
>>> agreed, I just think that emulating accesses by trapping them is not
>>> just slow, it's not really possible in practice and even if it is, it's
>>> probably *unusably* slow.
>>
>> Well, it would probably involve a lot of effort to implement emulation
>> of instructions with multiple output registers, such as ldp/stp and
>> register writeback. And indeed, trapping on each store instruction to
>> the framebuffer is going to be sloooooowwwww.
>>
>> So let's disregard that option for now ...
>>
>>>>
>>>>> What is the proposed solution for someone shipping an ARM server and
>>>>> wishing to provide a graphical output for that server?
>>>>
>>>> The problem does not exist on bare metal. It is an implementation
>>>> detail of KVM on ARM that guest PCI BAR mappings are incoherent with
>>>> the view of the emulator in QEMU.
>>>>
>>>>> It feels strange to work around supporting PCI VGA adapters in ARM VMs,
>>>>> if that's not a supported real hardware case.  However, I don't see what
>>>>> would prevent someone from plugging a VGA adapter into the PCI slot on
>>>>> an ARM server, and people selling ARM servers probably want this to
>>>>> happen, I'm guessing.
>>>>
>>>> As I said, the problem does not exist on bare metal.
>>>>
>>>>>>
>>>>>> If we do decide to fix this, the best way would be to use uncached
>>>>>> attributes for the QEMU userland mapping, and force it uncached in the
>>>>>> guest via a stage 2 override (as Drews suggests). The only problem I
>>>>>> see here is that the host's kernel direct mapping has a cached alias
>>>>>> that we need to get rid of.
>>>>>
>>>>> Do we have a way to accomplish that?
>>>>>
>>>>> Will we run into a bunch of other problems if we begin punching holes in
>>>>> the direct mapping for regular RAM?
>>>>
>>>> I think the policy up until now has been not to remap regions in the
>>>> kernel direct mapping for the purposes of DMA, and I think by the same
>>>> reasoning, it is not preferable for KVM either
>>>
>>> I guess the difference is that from the (host) kernel's point of view
>>> this is not DMA memory, but just regular RAM.  I just don't know enough
>>> about the kernel's VM mappings to know what's involved here, but we
>>> should find out somehow...
>>
>> Whether it is DMA memory or not does not make a difference. The point
>> is simply that arm64 maps all RAM owned by the kernel as cacheable,
>> and remapping arbitrary ranges with different attributes is
>> problematic, since it is also likely to involve splitting of regions,
>> which is cumbersome with a mapping that is always live.
>>
>> So instead, we'd have to reserve some system memory early on and
>> remove it from the linear mapping, the complexity of which is more
>> than we are probably prepared to put up with.
>>
>> So if vga-pci.c is the only problematic device, for which a reasonable
>> alternative exists (virtio-gpu), I think the only feasible solution is
>> to educate QEMU not to allow RAM memslots being exposed via PCI BARs
>> when running under KVM/ARM.
> 
> That's ok, if there is a viable alternative. So if we had working virtio-gpu support in OVMF, we could just disable the legacy vga device with kvm on arm altogether - it'd either crash your guest (unhandled opcode in mmio emulation) or give you broken graphics.
> 
> But first, someone would need to sit down and make virtio-gpu work in OVMF.

I've offered to (attempt to) implement a GOP driver for virtio-gpu, to
be used by OvmfPkg and ArmVirtPkg, once the virtio-gpu bits become part
of the official virtio specification.

However, as I mentioned elsewhere in this thread, a GOP driver for
virtio-gpu could provide the Blt() kind of display output *only*.
Virtio-gpu (the device model) lacks a linear framebuffer by design,
hence no GOP can expose it. The GOP can only offer the Blt() member
function, which would internally turn the block transfer requests into
virtio-gpu request.

Unfortunately, offering Blt() *only* is not good enough. Some UEFI boot
laoders (on x86 at least) depend on direct framebuffer access.

Let me put it this way: the UEFI spec describes a possibility for the
GOP implementor to expose a linear framebuffer for the display device if
there is one. If there is one, great; if there isn't, that's fine too,
the GOP specification allows it as well. It is the UEFI boot loaders
(well, some of them) that ultimately depend on the linear framebuffer,
which is what virtio-gpu (the device model) lacks.

Thanks
Laszlo
