From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v2 0/4] arm: add GICv2 MMIO tests
Date: Fri, 20 Jul 2018 16:42:22 +0100
Message-ID: <CAFEAcA--Uux1tTVDgR3tGZCXjQPNF4mgSnhC720Ez0AuWUQw3Q@mail.gmail.com>
References: <20180720153942.26821-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55FA0408AD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jul 2018 11:29:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PhJYcwGf-cCD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Jul 2018 11:29:33 -0400 (EDT)
Received: from mail-oi0-f65.google.com (mail-oi0-f65.google.com
 [209.85.218.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E14C40192
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jul 2018 11:29:33 -0400 (EDT)
Received: by mail-oi0-f65.google.com with SMTP id v8-v6so22109477oie.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jul 2018 08:42:43 -0700 (PDT)
In-Reply-To: <20180720153942.26821-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu, Luc Michel <luc.michel@greensocs.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 20 July 2018 at 16:39, Andre Przywara <andre.przywara@arm.com> wrote:
> I found this in one my branches: this is an updated version of what I sent
> end of 2016 [1]. I tried to address all comments that Drew and Eric had at
> the time.
> Please have a look whether this makes sense.
>
> Changelog v1..v2:
> - made many functions void
> - use symbolic name for first SPI being number 32
> - add test runs with one and three vCPUs
> - use gic_version() directly
> - factor out test_byte_access()
> - drop redundant "filling priorities" test
> - dropped GICv3 test
>
> [1] https://lists.cs.columbia.edu/pipermail/kvmarm/2016-November/022352.html
>
> Original cover letter:
> ======================
> The GIC spec mandates certain constraints on how to acccess the MMIO
> mapped registers, both in terms of which registers are available and also
> in terms of which bits within a register should be masked, for instance.
> Since we went through some lengths in the KVM emulation to implement this,
> it's about time to give this actually a test beyond what the kernel as a
> GIC user actually implements - for instance we ignore priorities in Linux.
>
> This series tries to attack some constraints, on a low-hanging-fruit base.
> It focusses on some generic registers and the PRIORITY and TARGETS registers
> of GICv2. GICv3 is not covered yet.
>
> This actually revealed genuine bugs in the KVM emulation in the past. KVM
> passes these tests now, but QEMU fails some UP and 3-way-SMP tests.

Would be interesting to see if we've fixed some of the QEMU emulation
bugs, either already in master or in Luc's on-list patchset that adds
support for emulation of the GICv2 virt extensions...

thanks
-- PMM
