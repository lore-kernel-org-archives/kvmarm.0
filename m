From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM/arm: kernel low level debug support for ARM32
 virtual platforms
Date: Thu, 5 Nov 2015 16:04:54 +0100
Message-ID: <20151105150454.GE5819@cbox>
References: <1446508313-24404-1-git-send-email-m.smarduch@samsung.com>
 <5638E1CD.8090006@codeaurora.org>
 <5638F294.4060409@samsung.com>
 <20151103175522.GA24856@arm.com>
 <56390838.3000204@samsung.com>
 <CAL_JsqJJHGwcdTDMh3WujJW0rDPxocVLEUpw95aVFC4FDEdDgA@mail.gmail.com>
 <20151104133147.GB5819@cbox>
 <563A531C.8090003@codeaurora.org>
 <CAKv+Gu8GJgzv82fVfCU7VQB2_ckRkzUYcQOx51rT2WgnmO_fsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8GJgzv82fVfCU7VQB2_ckRkzUYcQOx51rT2WgnmO_fsw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Christopher Covington <cov@codeaurora.org>, Rob Herring <robherring2@gmail.com>, Russell King - ARM Linux <linux@arm.linux.org.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Grant Likely <grant.likely@secretlab.ca>, Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 04, 2015 at 07:51:58PM +0100, Ard Biesheuvel wrote:
> On 4 November 2015 at 19:49, Christopher Covington <cov@codeaurora.org> wrote:
> > On 11/04/2015 08:31 AM, Christoffer Dall wrote:
> >> On Tue, Nov 03, 2015 at 01:39:44PM -0600, Rob Herring wrote:
> >>> On Tue, Nov 3, 2015 at 1:17 PM, Mario Smarduch <m.smarduch@samsung.com> wrote:
> >>>> On 11/3/2015 9:55 AM, Will Deacon wrote:
> >>>>> On Tue, Nov 03, 2015 at 09:44:52AM -0800, Mario Smarduch wrote:
> >>>>>> On 11/3/2015 8:33 AM, Christopher Covington wrote:
> >>>>>>> On 11/02/2015 06:51 PM, Mario Smarduch wrote:
> >>>>>>>>    this is a re-post from couple weeks ago, please take time to review this
> >>>>>>>> simple patch which simplifies DEBUG_LL and prevents kernel crash on virtual
> >>>>>>>> platforms.
> >>>>>>>>
> >>>>>>>> Before this patch DEBUG_LL for 'dummy virtual machine':
> >>>>>>>>
> >>>>>>>> ( ) Kernel low-level debugging via EmbeddedICE DCC channel
> >>>>>>>> ( ) Kernel low-level debug output via semihosting I/O
> >>>>>>>> ( ) Kernel low-level debugging via 8250 UART
> >>>>>>>> ( ) Kernel low-level debugging via ARM Ltd PL01x Primecell
> >>>>>>>>
> >>>>>>>> In summary if debug uart is not emulated kernel crashes.
> >>>>>>>> And once you pass that hurdle, uart physical/virtual addresses are unknown.
> >>>>>>>> DEBUG_LL comes in handy on many occasions and should be somewhat
> >>>>>>>> intuitive to use like it is for physical platforms. For virtual platforms
> >>>>>>>> user may start daubting the host and get into a bigger mess.
> >>>>>>>>
> >>>>>>>> After this patch is applied user gets:
> >>>>>>>>
> >>>>>>>> (X) Kernel low-level debugging on QEMU Virtual Platform
> >>>>>>>> ( ) Kernel low-level debugging on Kvmtool Virtual Platform
> >>>>>>>>    ..... above repeated ....
> >>>>>>>>
> >>>>>>>> The virtual addresses selected follow arm reference models, high in vmalloc
> >>>>>>>> section with high mem enabled and guest running with >= 1GB of memory. The
> >>>>>>>> offset is leftover from arm reference models.
> >>>>>>>
> >>>>>>> Which model? It doesn't appear to match the vexpress AEM/RTSM/FVP/whatever
> >>>>>>> which used 0x1c090000 for UART0.
> >>>>>>
> >>>>>> I recall QEMU virt model had it's own physical address map, for sure I saw the
> >>>>>> virtio-mmio regions assigned in some ARM document. Peter would you know?
> >>>>>>
> >>>>>> As far as kvmtool I'm not sure, currently PC1 COM1 port is used? Andre will that
> >>>>>> stay fixed?
> >>>>>
> >>>>> We make absolutely no guarantees about the memory map provided by kvmtool.
> >>>>
> >>>> If that's also the case for qemu, then I guess the best you can do is find a way
> >>>> to dump the device tree. Find the uart, physical address and try figure out the
> >>>> virtual address.
> >>>>
> >>>> Pretty involved, hoped for something more automated since that's a handy feature.
> >>>
> >>> You really only need LL_DEBUG now if you are debugging very early code
> >>> before memory is setup and/or bad memory. Use earlycon instead which
> >>> should already be supported both via the pl011 or semihosting. I used
> >>> it with QEMU semihosting support.
> >>>
> >> Then we should really document how to use that with qemu's virt platform
> >> and kvmtool's platform on both 32-bit and 64-bit so that users can
> >> easily figure out what they're doing wrong when they get no output.
> >>
> >> In practice, the address for the pl011 is quite unlikely to change, I
> >> dare speculate, so that documentation shouldn't need frequent updating.
> >
> > Is it not on by default since the following change?
> >
> > http://git.qemu.org/?p=qemu.git;a=commitdiff;h=f022b8e95379b0433d13509706b66f38fc15dde8
> >
> 
> Yes, but it still requires the plain 'earlycon' argument (i.e, without
> '=pl011,...') to be passed on the kernel command line if you want
> early output.
> 
I didn't notice this. Cool!

-Christoffer
