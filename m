From: Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 26/27] KVM: Document errors for KVM_GET_ONE_REG and
 KVM_SET_ONE_REG
Date: Thu, 4 Apr 2019 09:38:49 +0000
Message-ID: <20190404093846.GD27348@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-27-git-send-email-Dave.Martin@arm.com>
 <20190403202746.yoxwokr5uitli5q4@kamzik.brq.redhat.com>
 <20190404083526.GZ3567@e103592.cambridge.arm.com>
 <20190404093415.kt6cvagteszwmyzi@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D22E94A3EF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 05:38:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h4X53UNytac0 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 05:38:52 -0400 (EDT)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr150080.outbound.protection.outlook.com [40.107.15.80])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EFC94A331
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 05:38:52 -0400 (EDT)
In-Reply-To: <20190404093415.kt6cvagteszwmyzi@kamzik.brq.redhat.com>
Content-Language: en-US
Content-ID: <1D2AF4F3301D244FB2E45127E9CE9697@eurprd08.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: "tokamoto@jp.fujitsu.com" <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <Julien.Grall@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 04, 2019 at 10:34:15AM +0100, Andrew Jones wrote:
> On Thu, Apr 04, 2019 at 09:35:26AM +0100, Dave Martin wrote:
> > On Wed, Apr 03, 2019 at 10:27:46PM +0200, Andrew Jones wrote:
> > > On Fri, Mar 29, 2019 at 01:00:51PM +0000, Dave Martin wrote:
> > > > KVM_GET_ONE_REG and KVM_SET_ONE_REG return some error codes that
> > > > are not documented (but hopefully not surprising either).  To give
> > > > an indication of what these may mean, this patch adds brief
> > > > documentation.
> > > >
> > > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > > ---
> > > >  Documentation/virtual/kvm/api.txt | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >
> > > > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > > > index 2d4f7ce..cd920dd 100644
> > > > --- a/Documentation/virtual/kvm/api.txt
> > > > +++ b/Documentation/virtual/kvm/api.txt
> > > > @@ -1871,6 +1871,9 @@ Architectures: all
> > > >  Type: vcpu ioctl
> > > >  Parameters: struct kvm_one_reg (in)
> > > >  Returns: 0 on success, negative value on failure
> > > > +Errors:
> > > > +  ENOENT:   no such register
> > > > +  EINVAL:   other errors, such as bad size encoding for a known register
> > > >
> > > >  struct kvm_one_reg {
> > > >         __u64 id;
> > > > @@ -2192,6 +2195,9 @@ Architectures: all
> > > >  Type: vcpu ioctl
> > > >  Parameters: struct kvm_one_reg (in and out)
> > > >  Returns: 0 on success, negative value on failure
> > > > +Errors:
> > > > +  ENOENT:   no such register
> > > > +  EINVAL:   other errors, such as bad size encoding for a known register
> > > >
> > > >  This ioctl allows to receive the value of a single register implemented
> > > >  in a vcpu. The register to read is indicated by the "id" field of the
> > > > --
> > > > 2.1.4
> > > >
> > >
> > > Are we sure all architectures have these, and only these errors? A quick
> > > grep indicates not. I'm not sure we can document this easily here due to
> > > it addressing all architectures at once. Maybe we could add arch-specific
> > > subsections, but I'm not sure it's worth it.
> >
> > Error codes are generally indicative at best, and rarely mutually
> > exclusive in a given situation.
> >
> > Writing a caveat to say that you shouldn't make assumptions about
> > precisely what error code will be returned in a given situation would
> > look odd: that really applies widely all over the kernel/user ABI, not
> > just here.
> >
> > _Maybe_ everything is exhaustively correct in this file already, but
> > given the size of it, and the fact that many things are implemented
> > per-arch, the chance of this seems zero.
> >
> > I could add "invalid register ID" for EINVAL.  This allows some
> > ambiguity about which error code applies for a nonexistent register.
> >
> > Alternatively, we could revert this documentation instead.
>
> Yeah, I vote we just drop this patch. It could add more confusion
> when people start here to determine what to grep and then, when
> grepping for it, can't find any occurrences, as would be the case
> for ENOENT on at least a couple arches.

I guess so.  It's not like we're claiming this ioctl _can't_ fail.
So leaving interpretation of the errno values to common sense is
reasonable.

> > It seemed appropriate to document the EPERM error for finalization
> > ordering (added later), but since correct userspace code should never
> > see this maybe it's reasonable to leave it undocumented(?)

I assume you mean to remove this too?

I don't think correctly written userspace should be relying on seeing
this error code (as opposed to e.g., KVM_GET_REG_LIST's E2BIG which you
must observe in order to allocate the right amount of memory for the reg
list).

Cheers
---Dave
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
