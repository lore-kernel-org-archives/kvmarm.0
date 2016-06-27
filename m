From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Mon, 27 Jun 2016 14:49:10 +0100
Message-ID: <20160627134910.GH1113@leverpostej>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
 <20160627091619.GB26498@cbox>
 <CAKv+Gu9u2f6+HLYMzqtkq0z=Xk5gTq=_11QvAKMaBZj_oRMwTA@mail.gmail.com>
 <CAFEAcA93LRGxajFPBVo+wju74QApRWDN8MSKuvtaybwruFgH_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8D5149B40
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 09:44:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9-v7l6DDMtgm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2016 09:44:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 326D449B21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 09:44:09 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA93LRGxajFPBVo+wju74QApRWDN8MSKuvtaybwruFgH_w@mail.gmail.com>
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

On Mon, Jun 27, 2016 at 02:15:29PM +0100, Peter Maydell wrote:
> On 27 June 2016 at 10:47, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > As for the USB case, I can't really figure out what is going on here,
> > but I am fairly certain it is a different issue. If this is related to
> > DMA, I wonder if adding the 'dma-coherent' property to the PCIe root
> > complex node fixes anything.
> 
> I get the impression dma-coherent is the right thing to advertise
> anyway. Do you have the documentation to hand that specifies what
> "dma-coherent" means? The Documentation/devicetree docs in the
> kernel tree seem to rather unhelpfully define it as "Present if
> dma operations are coherent", which doesn't really clarify anything
> to me...

It's ill-defined today, and the precise definition is an open question.
See replies to [1], which seems to have stalled as of [2].

My view is that for arm/arm64 this should mean the device makes accesses
which are coherent with Inner Shareable Normal Inner-WB Outer-WB
attributes, as this is the functional de-facto semantics today, and
anything short of that is not well-defined or usable.

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-June/433626.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-June/434143.html
