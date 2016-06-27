From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Mon, 27 Jun 2016 14:15:29 +0100
Message-ID: <CAFEAcA93LRGxajFPBVo+wju74QApRWDN8MSKuvtaybwruFgH_w@mail.gmail.com>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
 <20160627091619.GB26498@cbox>
 <CAKv+Gu9u2f6+HLYMzqtkq0z=Xk5gTq=_11QvAKMaBZj_oRMwTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC5CC412C2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 09:10:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KRKVrvckk8Ib for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2016 09:10:41 -0400 (EDT)
Received: from mail-vk0-f41.google.com (mail-vk0-f41.google.com
 [209.85.213.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2D4641267
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 09:10:41 -0400 (EDT)
Received: by mail-vk0-f41.google.com with SMTP id c2so200870873vkg.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 06:15:49 -0700 (PDT)
In-Reply-To: <CAKv+Gu9u2f6+HLYMzqtkq0z=Xk5gTq=_11QvAKMaBZj_oRMwTA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 27 June 2016 at 10:47, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> As for the USB case, I can't really figure out what is going on here,
> but I am fairly certain it is a different issue. If this is related to
> DMA, I wonder if adding the 'dma-coherent' property to the PCIe root
> complex node fixes anything.

I get the impression dma-coherent is the right thing to advertise
anyway. Do you have the documentation to hand that specifies what
"dma-coherent" means? The Documentation/devicetree docs in the
kernel tree seem to rather unhelpfully define it as "Present if
dma operations are coherent", which doesn't really clarify anything
to me...

thanks
-- PMM
