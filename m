From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v9 07/11] arm/arm64: vgic: Implement
 KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
Date: Wed, 30 Nov 2016 08:29:11 +0000
Message-ID: <CAFEAcA-z=+K2ceRhLFMt7VXWD=RQyDKzS68SsO_pG3p=578wTg@mail.gmail.com>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
 <1479906118-15832-8-git-send-email-vijay.kilari@gmail.com>
 <20161128195028.GH18170@cbox>
 <CALicx6uW5RmjsPPBKB5wLW4TzNmcdc9ZADqp=M2ZJe9Cd+keZg@mail.gmail.com>
 <20161129210901.GC15346@cbox>
 <CAFEAcA_1i7-ti_H_RZrTbCW2DmFPvYudKn_WFs=_XRoyKKsnbQ@mail.gmail.com>
 <20161130082411.GA6647@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AA0140596
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2016 03:28:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9qSX4twB9YRt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2016 03:28:43 -0500 (EST)
Received: from mail-ua0-f182.google.com (mail-ua0-f182.google.com
 [209.85.217.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DC8040543
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2016 03:28:42 -0500 (EST)
Received: by mail-ua0-f182.google.com with SMTP id 51so205784360uai.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2016 00:29:32 -0800 (PST)
In-Reply-To: <20161130082411.GA6647@cbox>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 30 November 2016 at 08:24, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> (Peter, I thought you once argued that it was important for user space
> to be able to save/restore the state without any ordering requirements,
> but I may have misunderstood.  It is still the option to add something
> like the above to the docs but also do our best to allow any ordering of
> level/config, but it becomes slightly more invasive.)

Hmm; perhaps I should think about this a bit more.

-- PMM
