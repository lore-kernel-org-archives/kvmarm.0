From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 7/7] ARM: KVM: Unlock vgic-v3 support
Date: Wed, 7 Sep 2016 16:47:25 +0200
Message-ID: <20160907144725.GS23592@cbox>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
 <1471344418-19568-8-git-send-email-vladimir.murzin@arm.com>
 <20160905112927.GL26366@cbox> <57CEC344.7030706@arm.com>
 <20160906165527.GG23592@cbox> <57CFF094.5000704@arm.com>
 <20160907125856.GP23592@cbox>
 <CAFEAcA9oXc6bO55p=vqgrzQLFGT+zvg+E2nucOvPvb7RetN3RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AF3A49AF5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 10:36:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BHtEKRMWxHsY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Sep 2016 10:36:29 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B2D2D412A2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 10:36:29 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id b187so119936309wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Sep 2016 07:44:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA9oXc6bO55p=vqgrzQLFGT+zvg+E2nucOvPvb7RetN3RQ@mail.gmail.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 07, 2016 at 03:20:14PM +0100, Peter Maydell wrote:
> On 7 September 2016 at 13:58, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Wed, Sep 07, 2016 at 11:48:52AM +0100, Vladimir Murzin wrote:
> >> On 06/09/16 17:55, Christoffer Dall wrote:
> >> > On Tue, Sep 06, 2016 at 02:23:16PM +0100, Vladimir Murzin wrote:
> >> >>
> >> >> Sorry, missed this one
> >> >>
> >> >> On 05/09/16 12:29, Christoffer Dall wrote:
> >> >>>>
> >> >>>>> +static bool __hyp_text __has_useable_gicv3_cpuif(void)
> >> >>>>> +{
> >> >>>>> +       if (IS_ENABLED(CONFIG_ARM_GIC_V3) && (read_sysreg(ID_PFR1) >> 28))
> >> >>> Do we have a define for bit 28 we could use?
> >> >>
> >> >> I'll check it.
> >> >>
> >> >>>
> >> >>> Does this actually work on all v7 boards?  The v7 ARM ARM seems to state
> >> >>> that this bitfield is Reserved, UNK.  Does that somehow mean 'is going
> >> >>> to be zero'?
> >> >>
> >> >> It is how v7ARM ARM I have defines UNK
> >> >>
> >> >> An abbreviation indicating that software must treat a field as
> >> >> containing an UNKNOWN value. Hardware must implement the bit as read as
> >> >> 0, or all 0s for a bit field. Software must not rely on the field
> >> >> reading as zero.
> >> >>
> >> >> It seems goes under 'is going to be zero' case, no?
> >> >>
> >> > The last sentence is disturbing to me, and feels slightly contradicting
> >> > itself.  Reading the UNKNOWN description doesn't help much either.
> >> >
> >> > Perhaps you can ask around internally and figure out what the precise
> >> > answer to this is?
> >>
> >> Since it is kind of implementation dependant thing the precise answer
> >> from here hardly help, IMO. We still have non-zero chance to see
> >> something scary.
> >
> > Well, if the precise answer is: This will actually always return 0
> > because of X and Y, then your code is fine.
> 
> I think the "must not rely on the field reading as zero" wording
> in the case of the ID registers is intended to mean "in a
> future rev of the architecture we may assign these bits,
> and your code mustn't do something that will break if the
> bits then read as something other than zero". (And indeed
> in v8 bits 28..31 have an assigned meaning.) It doesn't
> mean there'll be v7 hardware out there with non-zero
> values, because that would be breaking the hardware's part
> of the UNKNOWN contract ("must implement the bit as read as 0").
> 
ok, that was the kind of answer I was hoping for.  In that case, this is
a non-issue.

Thanks for the clarification.

-Christoffer
