From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Tue, 28 Jun 2016 12:05:33 +0200
Message-ID: <20160628100533.GL26498@cbox>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
 <20160627091619.GB26498@cbox>
 <CAKv+Gu9u2f6+HLYMzqtkq0z=Xk5gTq=_11QvAKMaBZj_oRMwTA@mail.gmail.com>
 <CAFEAcA93LRGxajFPBVo+wju74QApRWDN8MSKuvtaybwruFgH_w@mail.gmail.com>
 <20160627134910.GH1113@leverpostej>
 <CAFEAcA-n4ZuHs7ioxngm_2+ys5qNJSde2LNgQ4C2-Lh3NKb_ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E5D749B2F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 05:59:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sZ0ckRYmeYXc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2016 05:59:35 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AF7149B21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 05:59:35 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id f126so132874772wma.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 03:04:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA-n4ZuHs7ioxngm_2+ys5qNJSde2LNgQ4C2-Lh3NKb_ZA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 27, 2016 at 03:10:20PM +0100, Peter Maydell wrote:
> On 27 June 2016 at 14:49, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Mon, Jun 27, 2016 at 02:15:29PM +0100, Peter Maydell wrote:
> >> I get the impression dma-coherent is the right thing to advertise
> >> anyway. Do you have the documentation to hand that specifies what
> >> "dma-coherent" means? The Documentation/devicetree docs in the
> >> kernel tree seem to rather unhelpfully define it as "Present if
> >> dma operations are coherent", which doesn't really clarify anything
> >> to me...
> >
> > It's ill-defined today, and the precise definition is an open question.
> > See replies to [1], which seems to have stalled as of [2].
> >
> > My view is that for arm/arm64 this should mean the device makes accesses
> > which are coherent with Inner Shareable Normal Inner-WB Outer-WB
> > attributes, as this is the functional de-facto semantics today, and
> > anything short of that is not well-defined or usable.
> 
> OK, so for any emulated device in QEMU we should specify
> dma-coherent by those rules. I think our only DMA devices
> in the virt board are the emulated PCI devices; dma-coherent
> here is a property of the pci-controller and applies to any
> device on it, right? Presumably this means that if the host
> pci-controller doesn't advertise itself as dma-coherent then
> we cannot do any PCI passthrough of host hardware?
> 
Someone suggested a while back to have a second PCI controller
matching the host properties for this purpose...

-Christoffer
