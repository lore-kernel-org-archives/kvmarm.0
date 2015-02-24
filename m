From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: kvm [2087]: load/store instruction decoding not implemented
Date: Wed, 25 Feb 2015 00:06:40 +0900
Message-ID: <CAFEAcA_8M70JS4Yy5LuSVt+iG26J0v=V1aRjirUzsMBE5manwA@mail.gmail.com>
References: <20150224115935.GA26241@redhat.com>
 <CAFEAcA-+xCkUNirq0zqQFotCSAjR25V25SkzPH7ktDOXQuhoFA@mail.gmail.com>
 <20150224122925.GL11603@redhat.com> <20150224124710.GB21364@cbox>
 <20150224142512.GN11603@redhat.com> <20150224145516.GC21364@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53A574677D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 10:01:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c2WSUxENjEIr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 10:01:21 -0500 (EST)
Received: from mail-lb0-f176.google.com (mail-lb0-f176.google.com
 [209.85.217.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2920846778
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 10:01:20 -0500 (EST)
Received: by lbjb6 with SMTP id b6so25355043lbj.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 07:07:01 -0800 (PST)
In-Reply-To: <20150224145516.GC21364@cbox>
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
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 24 February 2015 at 23:55, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> IPA is the Intermediate Physical Address (i.e. your guest physical
> address).  As far as I can tell from looking at the QEMU virt memory
> map, 0x3x........ does not belong to any devices or RAM on the board

Actually that's in PCIe space now.

-- PMM
