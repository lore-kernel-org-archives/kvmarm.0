From: Li Zhang <zhlcindy@gmail.com>
Subject: Re: kvm-unit-tests gicv2 cases fail
Date: Fri, 19 Oct 2018 12:53:17 +0800
Message-ID: <CAD8of+qVj7=0POGXTg_5K3cHkEQ_XyxdmjS0nUXa=mGJ8fbfXw@mail.gmail.com>
References: <CAD8of+q29DrQa4Ay6karXC19vXzX++2T8FR-V1SAjGuO0ejYhQ@mail.gmail.com>
 <20181019032557.h2je3v7frp7nnnj4@kamzik.brq.redhat.com>
 <CAKv+Gu96fULFjVNyxpy_N3CVZaE2aL19HXFaov4u4eC+rFj8Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EC584A0CC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 00:53:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gSgZh7Y56LQT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Oct 2018 00:53:49 -0400 (EDT)
Received: from mail-yw1-f47.google.com (mail-yw1-f47.google.com
 [209.85.161.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8597F4A1D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 00:53:49 -0400 (EDT)
Received: by mail-yw1-f47.google.com with SMTP id d126-v6so12728577ywa.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Oct 2018 21:53:49 -0700 (PDT)
In-Reply-To: <CAKv+Gu96fULFjVNyxpy_N3CVZaE2aL19HXFaov4u4eC+rFj8Pg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: ard.biesheuvel@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 19, 2018 at 11:59 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On 19 October 2018 at 11:25, Andrew Jones <drjones@redhat.com> wrote:
> > On Thu, Oct 18, 2018 at 05:17:57PM +0800, Li Zhang wrote:
> >> Hi,
> >>
> >> I run kvm-units-test on ARM server(QDF2400), but gicv2-ipi,
> >> gicv2-active cases fail.
> >> By debuging kvm-unit-tests source code, I found that interrupt is not
> >> handled. do_handle_exception is not called.
> >>
> >> By looking into KVM source code, it has GICv2 emulation on GICv3 support.
> >> I've tried a lot of kernel versions, from v4.12~v4.19 in mainline,
> >> these cases always fail.
> >> Is it possible that hardware/software disables this?
> >>
> >> It seems that GICv2 is a little old for ARM server, I am confused when
> >> we can use it.
> >> Do we need to care about these cases?
> >
> > We care, but I haven't seen these issues, and, if this only reproduces on
> > a gicv2 emulation on gicv3 configuration, then I don't have any hardware
> > where I can reproduce/debug it.
> >
>
> Do you have access to a Socionext SynQuacer board? I use it regularly
> with QEMU/KVM running both in GICv2 and GICv3 modes, and I haven't
> noticed any issues.

I only have QDF2400 boards on my hand.

Do you mean by starting a guest with QEMU/KVM with GICv2?
I tried that once, guest hang. Guest kernel has some message with call trace.
So I checked kvm-unit-tests, GICv2 always failed.


-- 

Best Regards
-Li
