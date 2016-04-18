From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v7 1/6] KVM: arm/arm64: Add VGICv3 save/restore API
 documentation
Date: Mon, 18 Apr 2016 11:33:36 +0100
Message-ID: <CAFEAcA9qodmWdmEnB9e-0F3RdTtC5N6x82-dKHVJnncdhau+tw@mail.gmail.com>
References: <cover.1449491035.git.p.fedin@samsung.com>
 <204d6b178e611ee0b5aede2b945516e0a6048c3c.1449491035.git.p.fedin@samsung.com>
 <CAFEAcA_N7F4r6fpQTW8Duyu577=uGcRyS7VhAMxumwTDN3khcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3AA349BEE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2016 06:32:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sqZqlb2W3BHN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Apr 2016 06:32:02 -0400 (EDT)
Received: from mail-vk0-f48.google.com (mail-vk0-f48.google.com
 [209.85.213.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F2B6649BD5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2016 06:32:01 -0400 (EDT)
Received: by mail-vk0-f48.google.com with SMTP id t129so214913770vkg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2016 03:33:55 -0700 (PDT)
In-Reply-To: <CAFEAcA_N7F4r6fpQTW8Duyu577=uGcRyS7VhAMxumwTDN3khcw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 15 April 2016 at 14:58, Peter Maydell <peter.maydell@linaro.org> wrote:
> Nothing in here describes a mechanism for reading or writing the
> current interrupt line_level state from the kernel (which doesn't
> matter for edge triggered interrupts but does for level triggered
> interrupts). Do we need accessors for these or does somebody
> have a good rationale for why we don't need to migrate that data?
> (Christoffer?)

Relatedly, we should have a mechanism for directly reading and
writing the pending-latch state in the KVM GIC, which for
a level triggered interrupt is not the same as the behaviour
of reading and writing the PENDING register.

thanks
-- PMM
