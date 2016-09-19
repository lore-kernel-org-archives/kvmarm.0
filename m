From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 5/6] arm/arm64: vgic-new: Implement VGICv3 CPU interface
 access
Date: Mon, 19 Sep 2016 11:11:25 +0100
Message-ID: <CAFEAcA9aax2w4yUQ48fWxNCbrAZdyLNVxef5RgvrJ+CaQWF=ZQ@mail.gmail.com>
References: <1474028453-29132-1-git-send-email-vijay.kilari@gmail.com>
 <1474028453-29132-6-git-send-email-vijay.kilari@gmail.com>
 <57DC0366.8060304@arm.com>
 <CALicx6u-uYLY3DtDGMh3n6NbNH3kD9fn9aYHHJC=LVUQfFjTsQ@mail.gmail.com>
 <57DC26C5.2060800@arm.com>
 <CALicx6ucEH3w58Rhb8Urk0V5kRcqtUdwDYDtSLXrkas-Jatv=A@mail.gmail.com>
 <20160917123756.0a05a904@arm.com>
 <CALicx6s=FOVv8t-6s4VJYwqUGaCfqMxrjXuop=JX6UYrYVj7Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C8144113E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2016 06:02:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5WKD+dGwmFUK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2016 06:02:47 -0400 (EDT)
Received: from mail-yw0-f171.google.com (mail-yw0-f171.google.com
 [209.85.161.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1696B40FA7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2016 06:02:46 -0400 (EDT)
Received: by mail-yw0-f171.google.com with SMTP id u82so134431991ywc.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2016 03:11:46 -0700 (PDT)
In-Reply-To: <CALicx6s=FOVv8t-6s4VJYwqUGaCfqMxrjXuop=JX6UYrYVj7Fg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vijay Kilari <vijay.kilari@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 19 September 2016 at 08:36, Vijay Kilari <vijay.kilari@gmail.com> wrote:
> In order to track the PRI and ID bits written by guest,
> VGIC needs to store these values when ICC_CTRL_EL1 is updated.
> However,  QEMU is reseting VGIC by writing 0's to all the
> registers after VGIC initialization and hence the back up values are
> always reset to 0 and hence when guest read back, VGIC returns wrong value.
>
> One option is to drop VGIC reset from QEMU which is not doing much.

No, if QEMU's reset is not resetting registers to the right value
the correct thing to do is fix the reset code. The way device
reset is supposed to work is that QEMU knows the right values
to use and it writes them to the kernel.

QEMU doesn't reset ICC_CTLR_EL1 to 0 for TCG:
    cs->icc_ctlr_el1[GICV3_NS] = ICC_CTLR_EL1_A3V |
        (1 << ICC_CTLR_EL1_IDBITS_SHIFT) |
        (7 << ICC_CTLR_EL1_PRIBITS_SHIFT);

but I don't think that code gets run for the KVM VGIC.

thanks
-- PMM
