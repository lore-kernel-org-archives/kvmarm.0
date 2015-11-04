From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM/arm: kernel low level debug support for ARM32
 virtual platforms
Date: Wed, 4 Nov 2015 14:31:47 +0100
Message-ID: <20151104133147.GB5819@cbox>
References: <1446508313-24404-1-git-send-email-m.smarduch@samsung.com>
 <5638E1CD.8090006@codeaurora.org> <5638F294.4060409@samsung.com>
 <20151103175522.GA24856@arm.com> <56390838.3000204@samsung.com>
 <CAL_JsqJJHGwcdTDMh3WujJW0rDPxocVLEUpw95aVFC4FDEdDgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D138498B2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 08:28:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lTXal9MxW3Q1 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2015 08:28:34 -0500 (EST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 036144989A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 08:28:33 -0500 (EST)
Received: by wmff134 with SMTP id f134so41577143wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2015 05:31:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAL_JsqJJHGwcdTDMh3WujJW0rDPxocVLEUpw95aVFC4FDEdDgA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Rob Herring <robherring2@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Grant Likely <grant.likely@secretlab.ca>, Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 03, 2015 at 01:39:44PM -0600, Rob Herring wrote:
> On Tue, Nov 3, 2015 at 1:17 PM, Mario Smarduch <m.smarduch@samsung.com> wrote:
> >
> >
> > On 11/3/2015 9:55 AM, Will Deacon wrote:
> >> On Tue, Nov 03, 2015 at 09:44:52AM -0800, Mario Smarduch wrote:
> >>> On 11/3/2015 8:33 AM, Christopher Covington wrote:
> >>>> On 11/02/2015 06:51 PM, Mario Smarduch wrote:
> >>>>>    this is a re-post from couple weeks ago, please take time to review this
> >>>>> simple patch which simplifies DEBUG_LL and prevents kernel crash on virtual
> >>>>> platforms.
> >>>>>
> >>>>> Before this patch DEBUG_LL for 'dummy virtual machine':
> >>>>>
> >>>>> ( ) Kernel low-level debugging via EmbeddedICE DCC channel
> >>>>> ( ) Kernel low-level debug output via semihosting I/O
> >>>>> ( ) Kernel low-level debugging via 8250 UART
> >>>>> ( ) Kernel low-level debugging via ARM Ltd PL01x Primecell
> >>>>>
> >>>>> In summary if debug uart is not emulated kernel crashes.
> >>>>> And once you pass that hurdle, uart physical/virtual addresses are unknown.
> >>>>> DEBUG_LL comes in handy on many occasions and should be somewhat
> >>>>> intuitive to use like it is for physical platforms. For virtual platforms
> >>>>> user may start daubting the host and get into a bigger mess.
> >>>>>
> >>>>> After this patch is applied user gets:
> >>>>>
> >>>>> (X) Kernel low-level debugging on QEMU Virtual Platform
> >>>>> ( ) Kernel low-level debugging on Kvmtool Virtual Platform
> >>>>>    ..... above repeated ....
> >>>>>
> >>>>> The virtual addresses selected follow arm reference models, high in vmalloc
> >>>>> section with high mem enabled and guest running with >= 1GB of memory. The
> >>>>> offset is leftover from arm reference models.
> >>>>
> >>>> Which model? It doesn't appear to match the vexpress AEM/RTSM/FVP/whatever
> >>>> which used 0x1c090000 for UART0.
> >>>
> >>> I recall QEMU virt model had it's own physical address map, for sure I saw the
> >>> virtio-mmio regions assigned in some ARM document. Peter would you know?
> >>>
> >>> As far as kvmtool I'm not sure, currently PC1 COM1 port is used? Andre will that
> >>> stay fixed?
> >>
> >> We make absolutely no guarantees about the memory map provided by kvmtool.
> >>
> >> Will
> >>
> >
> > If that's also the case for qemu, then I guess the best you can do is find a way
> > to dump the device tree. Find the uart, physical address and try figure out the
> > virtual address.
> >
> > Pretty involved, hoped for something more automated since that's a handy feature.
> 
> You really only need LL_DEBUG now if you are debugging very early code
> before memory is setup and/or bad memory. Use earlycon instead which
> should already be supported both via the pl011 or semihosting. I used
> it with QEMU semihosting support.
> 
Then we should really document how to use that with qemu's virt platform
and kvmtool's platform on both 32-bit and 64-bit so that users can
easily figure out what they're doing wrong when they get no output.

In practice, the address for the pl011 is quite unlikely to change, I
dare speculate, so that documentation shouldn't need frequent updating.

-Christoffer
