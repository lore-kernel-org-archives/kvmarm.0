From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v7 0/7] arm/arm64: vgic: Implement API for vGICv3 live
 migration
Date: Wed, 2 Nov 2016 17:22:48 +0100
Message-ID: <20161102162248.GB11122@cbox>
References: <1474645482-28131-1-git-send-email-vijay.kilari@gmail.com>
 <CALicx6uFBF=J5J4L6sVspqMx-sjGCjoAgONHAe5Q4msonfVYEA@mail.gmail.com>
 <CAMJs5B8aLZCDeAVhJN7Cajt4PL4HBtXc3BiNzMyjK1tOSjMwmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D713C40421
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2016 12:22:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sj+2lEUrnmRq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2016 12:22:44 -0400 (EDT)
Received: from mail-lf0-f51.google.com (mail-lf0-f51.google.com
 [209.85.215.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE06740290
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2016 12:22:43 -0400 (EDT)
Received: by mail-lf0-f51.google.com with SMTP id t196so17395856lff.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2016 09:22:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAMJs5B8aLZCDeAVhJN7Cajt4PL4HBtXc3BiNzMyjK1tOSjMwmg@mail.gmail.com>
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

Hi Vijay,

On Thu, Oct 06, 2016 at 02:14:13PM +0200, Christoffer Dall wrote:
> Hi Vijay,
> 
> On Wed, Oct 5, 2016 at 4:33 PM, Vijay Kilari <vijay.kilari@gmail.com> wrote:
> > Hi Marc, Christoffer,
> >
> >   Do you have any review comments on this patch set?.
> >
> Since we missed the 4.9 merge window there is no urgency just yet, and
> I'm tied up with other things for a while, and Marc is away this week
> on holiday.  I'm sure he'll have a look when he's back and I'll follow
> up later.
> 
I think it would be useful for you to post a v7 of your patch set
rebased v4.9-rcX and addressing the issue you found yourself with a
wrong parameter.

Then I'll have another look.

Thanks,
-Christoffer
