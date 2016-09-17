From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Sat, 17 Sep 2016 17:47:50 +0100
Message-ID: <CAKv+Gu91FYx4QTWd9QO0zrMYH8k3wp=CQT9zMG4ZhMLZ2xrQQA@mail.gmail.com>
References: <1474007187-18673-1-git-send-email-agraf@suse.de>
 <57DBC782.7080305@arm.com> <060ADA14-786E-400E-9B11-61C34B7081B5@suse.de>
 <20160916122937.GA14140@cbox>
 <6b92c411-8b27-a4c0-6969-38e32bbf18ab@redhat.com>
 <10C5B047-6A7F-4255-BE56-5358AF88DA5E@suse.de>
 <CAKv+Gu_+txUFT158VzJqeE3Jwdd1LL1n2kzOzYKuk03UFxW3NQ@mail.gmail.com>
 <CAFEAcA8JRscJox0Up3vRyDeOzy7PEHpm0p0cKBNeAYO6xeSZZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD7C049B2F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Sep 2016 12:38:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ubod4Ykzw8p6 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 17 Sep 2016 12:38:56 -0400 (EDT)
Received: from mail-io0-f177.google.com (mail-io0-f177.google.com
 [209.85.223.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50613412D0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Sep 2016 12:38:56 -0400 (EDT)
Received: by mail-io0-f177.google.com with SMTP id q92so55689198ioi.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Sep 2016 09:47:51 -0700 (PDT)
In-Reply-To: <CAFEAcA8JRscJox0Up3vRyDeOzy7PEHpm0p0cKBNeAYO6xeSZZQ@mail.gmail.com>
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
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 17 September 2016 at 16:38, Peter Maydell <peter.maydell@linaro.org> wrote:
> On 17 September 2016 at 16:28, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> Another thing to keep in mind is that GICv2
>> compatibility is disabled on the non-secure side if the secure side
>> elects to configure its view of the GIC as v3 (i.e., in order to
>> support >8 cores)
>
> If I'm reading the 'legacy configurations' chapter of the GICv3
> spec correctly, that is true for the NS host OS (ie the one
> handling physical interrupts) but a guest OS can still use
> the old GICv2-compat interface (assuming it was implemented
> in silicon at all).
>

Ah right, apologies for spreading misinformation. But my first point
is still valid.
