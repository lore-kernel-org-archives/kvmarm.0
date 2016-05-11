From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 19/55] KVM: arm/arm64: vgic-new: Add GICv3 world
 switch backend
Date: Wed, 11 May 2016 11:39:19 +0200
Message-ID: <20160511093919.GJ27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-20-git-send-email-andre.przywara@arm.com>
 <20160510140454.GG27623@cbox>
 <CAFEAcA9U9qqsSJt7RfNJmDutCsYwnaPGfi-sEcnxYYjSm5C8sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DEA449B7B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 05:35:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3J4+6sJoMstv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 05:35:47 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 032CD49B6B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 05:35:46 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id g17so71843313wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 02:38:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA9U9qqsSJt7RfNJmDutCsYwnaPGfi-sEcnxYYjSm5C8sA@mail.gmail.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 10, 2016 at 03:15:12PM +0100, Peter Maydell wrote:
> On 10 May 2016 at 15:04, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > On Fri, May 06, 2016 at 11:45:32AM +0100, Andre Przywara wrote:
> >> +     /*
> >> +      * Currently all guest IRQs are Group1, as Group0 would result
> >> +      * in a FIQ in the guest, which it wouldn't expect.
> >
> > I still don't like or understand this comment.  This should simply say
> > that we're making a gross assumption about all interrupts being group1
> > here.
> 
> It's not really an assumption so much as it's a missing feature (aka bug):
> there's no reason the vGIC shouldn't support group 0 interrupts. We
> just get away with only supporting group 1 because Linux guests
> happen to only use group 1 interrupts. If/when the vGIC gains support
> for group0 interrupts, then it should reset with interrupts configured
> in group0 by default.
> 
> >> +      * Eventually we want to make this configurable, so we may
> >> +      * revisit this in the future.
> >> +      */
> 
> The only reason to make it configurable is to work around a guest
> kernel bug whereby Linux assumes that all interrupts start out
> in Group1. Marc sent out a patch earlier today that fixes that bug:
>  https://lkml.org/lkml/2016/5/10/297
> Depending on how long it takes you to fix this missing vgic feature,
> such kernels may all be long-forgotten, in which case you can
> get away without the config option :-)
> 
Agreed with all of the above.  My nit here is simply that if we don't
implement grouping support now, then it's just a gross hack, and we
should just state that until we fix it properly.

-Christoffer
