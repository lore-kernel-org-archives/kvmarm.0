From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 5/5] arm64: KVM: vgic-v2: Enable GICV access from HYP if
 access from guest is unsafe
Date: Fri, 19 Aug 2016 14:31:12 +0100
Message-ID: <CAFEAcA9Q9U02KkgkYYT1O6qTHyYmBMW6ARi_bQPRjDNS+O0w7Q@mail.gmail.com>
References: <1471610295-1456-1-git-send-email-marc.zyngier@arm.com>
 <1471610295-1456-6-git-send-email-marc.zyngier@arm.com>
 <CAFEAcA99RScdr+E39Q+03L5DyDLiQgQo9x1DeP1gE2-nJ1yUig@mail.gmail.com>
 <57B7042D.1020702@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA042411E3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2016 09:23:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VN1YYpHvdHkk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Aug 2016 09:23:59 -0400 (EDT)
Received: from mail-ua0-f175.google.com (mail-ua0-f175.google.com
 [209.85.217.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB435411BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2016 09:23:58 -0400 (EDT)
Received: by mail-ua0-f175.google.com with SMTP id n59so79717819uan.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2016 06:31:33 -0700 (PDT)
In-Reply-To: <57B7042D.1020702@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 19 August 2016 at 14:05, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 19/08/16 13:53, Peter Maydell wrote:
>> Is it worth specifically saying "performance will be worse", or do we
>> expect this to only happen on systems where the h/w can't permit direct
>> access (as opposed to those with bad dt info) ?
>
> We cannot distinguish between the two, unfortunately. Even worse, ACPI
> only gives us a base address, and not the size of the region. So even if
> the HW was perfectly compliant with SBSA, we have to assume the worse case.

Right, but if we expect this is mostly going to be "you just have
to live with it on this hardware" there's less point in printing
an alarming message, whereas if there's a significant subset of
"dt is just wrong" cases then the alarm might help in getting them
fixed, maybe...

thanks
-- PMM
