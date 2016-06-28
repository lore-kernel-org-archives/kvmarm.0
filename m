From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Tue, 28 Jun 2016 15:14:00 +0200
Message-ID: <CAKv+Gu-5CffcgsWwOUpXukVQJaSxRtvHTFiQjf+OmG380iKWaA@mail.gmail.com>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
 <20160627091619.GB26498@cbox>
 <CAKv+Gu9u2f6+HLYMzqtkq0z=Xk5gTq=_11QvAKMaBZj_oRMwTA@mail.gmail.com>
 <20160627103421.GC26498@cbox>
 <52f1a2e2-63c9-a5d2-9b78-7264923e04c4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4E2C49B46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 09:08:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9tSVkZUzQRyd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2016 09:08:51 -0400 (EDT)
Received: from mail-io0-f180.google.com (mail-io0-f180.google.com
 [209.85.223.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBC9949B32
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 09:08:51 -0400 (EDT)
Received: by mail-io0-f180.google.com with SMTP id s63so16048763ioi.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 06:14:02 -0700 (PDT)
In-Reply-To: <52f1a2e2-63c9-a5d2-9b78-7264923e04c4@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Laszlo Ersek <lersek@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 28 June 2016 at 12:55, Laszlo Ersek <lersek@redhat.com> wrote:
> On 06/27/16 12:34, Christoffer Dall wrote:
>> On Mon, Jun 27, 2016 at 11:47:18AM +0200, Ard Biesheuvel wrote:
>
>>> So first of all, let me reiterate that I could only find a single
>>> instance in QEMU where a PCI MMIO region is backed by host memory,
>>> which is vga-pci.c. I wonder of there are any other occurrences, but
>>> if there aren't any, it makes much more sense to prohibit PCI BARs
>>> backed by host memory rather than spend a lot of effort working around
>>> it.
>>
>> Right, ok.  So Marc's point during his KVM Forum talk was basically,
>> don't use the legacy VGA adapter on ARM and use virtio graphics, right?
>
> The EFI GOP (Graphics Output Protocol) abstraction provides two ways for
> UEFI applications to access the display, and one way for a runtime OS to
> inherit the display hardware from the firmware (without OS native drivers).
>
> (a) For UEFI apps:
> - direct framebuffer access
> - Blt() (block transfer) member function
>
> (b) For runtime OS:
> - direct framebuffer access ("efifb" in Linux)
>
> Virtio-gpu lacks a linear framebuffer by design. Therefore the above
> methods are reduced to the following:
>
> (c) UEFI apps can access virtio-gpu with:
> - GOP.Blt() member function only
>
> (d) The runtime guest OS can access the virtio-gpu device as-inherited
> from the firmware (i.e., without native drivers) with:
> - n/a.
>
> Given that we expect all aarch64 OSes to include native virtio-gpu
> drivers on their install media, (d) is actually not a problem. Whenever
> the OS kernel runs, we except to have no need for "efifb", ever. So
> that's good.
>
> The problem is (c). UEFI boot loaders would have to be taught to call
> GOP.Blt() manually, whenever they need to display something. I'm not
> sure about grub2's current status, but it is free software, so in theory
> it should be doable. However, UEFI windows boot loaders are proprietary
> *and* they require direct framebuffer access (on x86 at least); they
> don't work with Blt()-only. (I found some Microsoft presentations about
> this earlier.)
>
> So, virtio-gpu is an almost universal solution for the problem, but not
> entirely. For any given GOP, offering Blt() *only* (i.e., not exposing a
> linear framebuffer) conforms to the UEFI spec, but some boot loaders are
> known to present further requirements (on x86 anyway).
>

Even if virtio-gpu would expose a linear framebuffer, it would likely
expose it as a PCI BAR, and we would be in the exact same situation.

The only way we can work around this is to emulate a DMA coherent
device that uses a framebuffer in system RAM. I looked at the PL111,
which is already supported both in EDK2 and the Linux kernel, and
would only require minor changes to support DMA coherent devices.
Unfortunately, we would not be able to advertise its presence when
running under ACPI, since it is not a PCI device.

In any case, reconciling software that requires a framebuffer with a
GPU emulation that does not expose one by design is going to be
problematic even without this issue. How is this supposed to work on
x86?
