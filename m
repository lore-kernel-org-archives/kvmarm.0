From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Mon, 27 Jun 2016 14:30:46 +0200
Message-ID: <CAKv+Gu9uBow4FqmA701J76CZ9Npi2j6ADXEJhXAax5whiQkP1A@mail.gmail.com>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
 <20160627091619.GB26498@cbox>
 <CAKv+Gu9u2f6+HLYMzqtkq0z=Xk5gTq=_11QvAKMaBZj_oRMwTA@mail.gmail.com>
 <20160627103421.GC26498@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1F9349B21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 08:25:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mJu-iVQnUS1E for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2016 08:25:39 -0400 (EDT)
Received: from mail-io0-f180.google.com (mail-io0-f180.google.com
 [209.85.223.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 874D4499A1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 08:25:39 -0400 (EDT)
Received: by mail-io0-f180.google.com with SMTP id s63so146786567ioi.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 05:30:47 -0700 (PDT)
In-Reply-To: <20160627103421.GC26498@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 27 June 2016 at 12:34, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> On Mon, Jun 27, 2016 at 11:47:18AM +0200, Ard Biesheuvel wrote:
>> On 27 June 2016 at 11:16, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>> > Hi,
>> >
>> > I'm going to ask some stupid questions here...
>> >
>> > On Fri, Jun 24, 2016 at 04:04:45PM +0200, Ard Biesheuvel wrote:
>> >> Hi all,
>> >>
>> >> This old subject came up again in a discussion related to PCIe support
>> >> for QEMU/KVM under Tianocore. The fact that we need to map PCI MMIO
>> >> regions as cacheable is preventing us from reusing a significant slice
>> >> of the PCIe support infrastructure, and so I'd like to bring this up
>> >> again, perhaps just to reiterate why we're simply out of luck.
>> >>
>> >> To refresh your memories, the issue is that on ARM, PCI MMIO regions
>> >> for emulated devices may be backed by memory that is mapped cacheable
>> >> by the host. Note that this has nothing to do with the device being
>> >> DMA coherent or not: in this case, we are dealing with regions that
>> >> are not memory from the POV of the guest, and it is reasonable for the
>> >> guest to assume that accesses to such a region are not visible to the
>> >> device before they hit the actual PCI MMIO window and are translated
>> >> into cycles on the PCI bus.
>> >
>> > For the sake of completeness, why is this reasonable?
>> >
>>
>> Because the whole point of accessing these regions is to communicate
>> with the device. It is common to use write combining mappings for
>> things like framebuffers to group writes before they hit the PCI bus,
>> but any caching just makes it more difficult for the driver state and
>> device state to remain synchronized.
>>
>> > Is this how any real ARM system implementing PCI would actually work?
>> >
>>
>> Yes.
>>
>> >> That means that mapping such a region
>> >> cacheable is a strange thing to do, in fact, and it is unlikely that
>> >> patches implementing this against the generic PCI stack in Tianocore
>> >> will be accepted by the maintainers.
>> >>
>> >> Note that this issue not only affects framebuffers on PCI cards, it
>> >> also affects emulated USB host controllers (perhaps Alex can remind us
>> >> which one exactly?) and likely other emulated generic PCI devices as
>> >> well.
>> >>
>> >> Since the issue exists only for emulated PCI devices whose MMIO
>> >> regions are backed by host memory, is there any way we can already
>> >> distinguish such memslots from ordinary ones? If we can, is there
>> >> anything we could do to treat these specially? Perhaps something like
>> >> using read-only memslots so we can at least trap guest writes instead
>> >> of having main memory going out of sync with the caches unnoticed? I
>> >> am just brainstorming here ...
>> >
>> > I think the only sensible solution is to make sure that the guest and
>> > emulation mappings use the same memory type, either cached or
>> > non-cached, and we 'simply' have to find the best way to implement this.
>> >
>> > As Drew suggested, forcing some S2 mappings to be non-cacheable is the
>> > one way.
>> >
>> > The other way is to use something like what you once wrote that rewrites
>> > stage-1 mappings to be cacheable, does that apply here ?
>> >
>> > Do we have a clear picture of why we'd prefer one way over the other?
>> >
>>
>> So first of all, let me reiterate that I could only find a single
>> instance in QEMU where a PCI MMIO region is backed by host memory,
>> which is vga-pci.c. I wonder of there are any other occurrences, but
>> if there aren't any, it makes much more sense to prohibit PCI BARs
>> backed by host memory rather than spend a lot of effort working around
>> it.
>
> Right, ok.  So Marc's point during his KVM Forum talk was basically,
> don't use the legacy VGA adapter on ARM and use virtio graphics, right?
>

Yes. But nothing is preventing you currently from using that, and I
think we should prefer crappy performance but correct operation over
the current situation. So in general, we should either disallow PCI
BARs backed by host memory, or emulate them, but never back them by a
RAM memslot when running under ARM/KVM.

> What is the proposed solution for someone shipping an ARM server and
> wishing to provide a graphical output for that server?
>

The problem does not exist on bare metal. It is an implementation
detail of KVM on ARM that guest PCI BAR mappings are incoherent with
the view of the emulator in QEMU.

> It feels strange to work around supporting PCI VGA adapters in ARM VMs,
> if that's not a supported real hardware case.  However, I don't see what
> would prevent someone from plugging a VGA adapter into the PCI slot on
> an ARM server, and people selling ARM servers probably want this to
> happen, I'm guessing.
>

As I said, the problem does not exist on bare metal.

>>
>> If we do decide to fix this, the best way would be to use uncached
>> attributes for the QEMU userland mapping, and force it uncached in the
>> guest via a stage 2 override (as Drews suggests). The only problem I
>> see here is that the host's kernel direct mapping has a cached alias
>> that we need to get rid of.
>
> Do we have a way to accomplish that?
>
> Will we run into a bunch of other problems if we begin punching holes in
> the direct mapping for regular RAM?
>

I think the policy up until now has been not to remap regions in the
kernel direct mapping for the purposes of DMA, and I think by the same
reasoning, it is not preferable for KVM either
