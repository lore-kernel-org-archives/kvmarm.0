From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH v3 1/4] hw/intc/arm_gicv3_common: Add state information
Date: Sat, 24 Oct 2015 13:35:44 +0100
Message-ID: <CAFEAcA-6yG=PL2LerZNFU76XV=PdEO228J3j8U7wOiSDmvTLcg@mail.gmail.com>
References: <cover.1445522263.git.p.fedin@samsung.com>
 <5dbabd5337ae85feccb64057cc21e03a1e34132c.1445522263.git.p.fedin@samsung.com>
 <CAFEAcA-B3cjHJ605HzCb2UM2mK55N+rW1WErXjm_6=jKE8hJOw@mail.gmail.com>
 <CAHzK-V2d7onpWw1V+TCW41eYYmB_2jrcmwa1B=D0uOpbY5qerw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C42ED412DD
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Oct 2015 08:33:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J5FoDxLD0Ri7 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Oct 2015 08:33:20 -0400 (EDT)
Received: from mail-vk0-f43.google.com (mail-vk0-f43.google.com
 [209.85.213.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6C6240FF5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Oct 2015 08:33:20 -0400 (EDT)
Received: by vkfw189 with SMTP id w189so76684262vkf.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Oct 2015 05:36:03 -0700 (PDT)
In-Reply-To: <CAHzK-V2d7onpWw1V+TCW41eYYmB_2jrcmwa1B=D0uOpbY5qerw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shlomo Pongratz <shlomopongratz@gmail.com>
Cc: Shlomo Pongratz <shlomo.pongratz@huawei.com>, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 24 October 2015 at 13:30, Shlomo Pongratz <shlomopongratz@gmail.com> wrote:
> Comment on the "workaround" see inline.
>

>> > +        /* Workaround!
>> > +         * Linux (drivers/irqchip/irq-gic-v3.c) is enabling only group
>> > one,
>> > +         * in gic_cpu_sys_reg_init it calls gic_write_grpen1(1);
>> > +         * but it doesn't conigure any interrupt to be in group one.
>> > +         * The same for SPIs below
>> > +         */
>>
>> Is this a bug in Linux, or is it just expecting that firmware configures
>> all interrupts into group 1 for it? (ie do we need some variation on
>> commit 8ff41f3995ad2d for gicv3 ?)
>
>
> I think it is a bug in Linux as I explain in the comment, as far as I know
> the kernel should not assume anything, that is if it wants ti use group one
> it should initialize it, but since I don't have a board with a GICv3
> (GIC500) I can't be sure.
> My purpose is to make the "virt" virtual machine work. Maybe this
> initialization should go there.

If it's a kernel bug we should just fix it in the kernel -- all
this GICv3 support is still sufficiently early that it seems to
me better to just fix the kernel than to carry around workarounds
for bugs.

thanks
-- PMM
