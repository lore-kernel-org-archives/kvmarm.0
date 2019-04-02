From: Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 16/27] KVM: arm64: Factor out core register ID
 enumeration
Date: Tue, 2 Apr 2019 09:54:19 +0000
Message-ID: <20190402095416.GV27348@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-17-git-send-email-Dave.Martin@arm.com>
 <86ftr15dsb.wl-marc.zyngier@arm.com>
 <20190402085917.GF3567@e103592.cambridge.arm.com>
 <865zrw69cd.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5FEF4A41A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Apr 2019 05:54:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tzANOKCaFjk4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Apr 2019 05:54:22 -0400 (EDT)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-eopbgr80042.outbound.protection.outlook.com [40.107.8.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C5B74A34E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Apr 2019 05:54:22 -0400 (EDT)
In-Reply-To: <865zrw69cd.wl-marc.zyngier@arm.com>
Content-Language: en-US
Content-ID: <8759304C539B454A91AEFAC038DC002C@eurprd08.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: "tokamoto@jp.fujitsu.com" <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <Julien.Grall@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 02, 2019 at 10:32:34AM +0100, Marc Zyngier wrote:
> On Tue, 02 Apr 2019 09:59:19 +0100,
> Dave Martin <Dave.Martin@arm.com> wrote:
> >
> > On Tue, Apr 02, 2019 at 03:41:56AM +0100, Marc Zyngier wrote:

[...]

> > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > index 086ab0508d69..4f7b26bbf671 100644
> > > --- a/arch/arm64/kvm/guest.c
> > > +++ b/arch/arm64/kvm/guest.c
> > > @@ -604,22 +604,22 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)

[...]

> > >  ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
> > > -if (ret)
> > > +if (ret < 0)
> > >  return ret;
> > >  uindices += kvm_arm_get_fw_num_regs(vcpu);
> > >
> > >  ret = copy_timer_indices(vcpu, uindices);
> > > -if (ret)
> > > +if (ret < 0)
> > >  return ret;
> > >  uindices += NUM_TIMER_REGS;
> >
> > For these two, the interface is not really the same.  These don't
> > return the number of registers, so return 0 on success.  "< 0" here
> > could be a trap for the future, though the risk looks low.
>
> I realised that, but since they all return a negative value on error,
> I went for a similar error handling.

Sure, this is more potential future maintenance thing -- and anyway not
a big deal.

I agree that your changes look like they work.

> > I can have a go at some rework on top to make this more consistent,
> > but I'd rather not muddy the water further for the moment.
> >
> > Any view on that?
>
> I don't think there is any urgency on that front. For now, I'd like to
> make sure things do not regress. Once we're sure we have something
> stable, we'll be able to make it shiny.

Agreed.

I won't worry about this for now, but we can discuss it later.

Cheers
---Dave
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
