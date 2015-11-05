From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 0/3] KVM: arm/arm64: Clean up some obsolete code
Date: Thu, 5 Nov 2015 08:05:31 +0000
Message-ID: <CAFEAcA9fh05q_mCQ0AixbQYNhTS5ZL94pwoJoTRenVG58afKHQ@mail.gmail.com>
References: <cover.1445934536.git.p.fedin@samsung.com>
 <20151102211538.GA5819@cbox>
 <005201d11608$a73edf80$f5bc9e80$@samsung.com>
 <002501d1161c$4c92f5d0$e5b8e170$@samsung.com>
 <20151104142926.GA20230@cbox> <01d001d11796$4c1c4770$e454d650$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99A1B498AD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2015 03:02:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t8d0L5E7xIgL for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2015 03:02:35 -0500 (EST)
Received: from mail-yk0-f175.google.com (mail-yk0-f175.google.com
 [209.85.160.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6815449094
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2015 03:02:35 -0500 (EST)
Received: by ykba4 with SMTP id a4so117755878ykb.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Nov 2015 00:05:50 -0800 (PST)
In-Reply-To: <01d001d11796$4c1c4770$e454d650$@samsung.com>
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

On 5 November 2015 at 06:50, Pavel Fedin <p.fedin@samsung.com>
>  You know, since we are talking about this...  This definitely
> has something to do with the reset, and... Looks like nobody
> resets vGIC/vTimer, unless the userland does it explicitly by
> resetting every register by hand.

This is how KVM in-kernel device reset is supposed to work, yes.

thanks
-- PMM
