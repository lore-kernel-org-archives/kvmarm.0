From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Thu, 8 Oct 2015 11:25:41 +0100
Message-ID: <CAFEAcA-3vUgB=LCsiEwGoM0G28yszw+90LFajOB8akgwiQwuuw@mail.gmail.com>
References: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org>
 <003a01d10199$58e96590$0abc30b0$@samsung.com> <20151008082302.GE14315@cbox>
 <005e01d101a9$31ee80f0$95cb82d0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CCBB41338
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 06:24:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G-Ifkr3x4Xjl for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Oct 2015 06:24:02 -0400 (EDT)
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com
 [209.85.213.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5587E41973
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 06:24:01 -0400 (EDT)
Received: by vkat63 with SMTP id t63so28853651vka.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Oct 2015 03:26:01 -0700 (PDT)
In-Reply-To: <005e01d101a9$31ee80f0$95cb82d0$@samsung.com>
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
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 8 October 2015 at 10:10, Pavel Fedin <p.fedin@samsung.com> wrote:
>  Sorry, didn't want to offend anyone. I just wanted to tell that i know
> that you, as maintainers, have much more power than i do, and you can
> always say "it's political decision, we just want it and that's final",
> and if you choose to do this, i'm perfectly OK with that, just say it.

This isn't intended to be a political decision; it's our joint
technical opinion on the best design for this API. Since we all
happened to be in one physical location the other week it was a good
opportunity for us to work through how we thought the API should
look from a technical perspective. At that point it seemed to us
to be clearer to write up the results of that discussion as a
single patch to the API documentation, rather than doing it by
(for instance) making lots of different review comments on your patches.
Christoffer's API documentation patch is a patch like any other and
it has to go through review. If there are parts where you don't
understand the rationale or you think we got something wrong you
should let us know.

thanks
-- PMM
