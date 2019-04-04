From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 26/27] KVM: Document errors for KVM_GET_ONE_REG and
 KVM_SET_ONE_REG
Date: Thu, 4 Apr 2019 11:34:15 +0200
Message-ID: <20190404093415.kt6cvagteszwmyzi@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-27-git-send-email-Dave.Martin@arm.com>
 <20190403202746.yoxwokr5uitli5q4@kamzik.brq.redhat.com>
 <20190404083526.GZ3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF0444A3EF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 05:34:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dWEFsKPfmkaz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 05:34:21 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A4644A331
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 05:34:21 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190404083526.GZ3567@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 04, 2019 at 09:35:26AM +0100, Dave Martin wrote:
> On Wed, Apr 03, 2019 at 10:27:46PM +0200, Andrew Jones wrote:
> > On Fri, Mar 29, 2019 at 01:00:51PM +0000, Dave Martin wrote:
> > > KVM_GET_ONE_REG and KVM_SET_ONE_REG return some error codes that
> > > are not documented (but hopefully not surprising either).  To give
> > > an indication of what these may mean, this patch adds brief
> > > documentation.
> > > =

> > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > ---
> > >  Documentation/virtual/kvm/api.txt | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > =

> > > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtua=
l/kvm/api.txt
> > > index 2d4f7ce..cd920dd 100644
> > > --- a/Documentation/virtual/kvm/api.txt
> > > +++ b/Documentation/virtual/kvm/api.txt
> > > @@ -1871,6 +1871,9 @@ Architectures: all
> > >  Type: vcpu ioctl
> > >  Parameters: struct kvm_one_reg (in)
> > >  Returns: 0 on success, negative value on failure
> > > +Errors:
> > > + =A0ENOENT: =A0=A0no such register
> > > + =A0EINVAL: =A0=A0other errors, such as bad size encoding for a know=
n register
> > >  =

> > >  struct kvm_one_reg {
> > >         __u64 id;
> > > @@ -2192,6 +2195,9 @@ Architectures: all
> > >  Type: vcpu ioctl
> > >  Parameters: struct kvm_one_reg (in and out)
> > >  Returns: 0 on success, negative value on failure
> > > +Errors:
> > > + =A0ENOENT: =A0=A0no such register
> > > + =A0EINVAL: =A0=A0other errors, such as bad size encoding for a know=
n register
> > >  =

> > >  This ioctl allows to receive the value of a single register implemen=
ted
> > >  in a vcpu. The register to read is indicated by the "id" field of the
> > > -- =

> > > 2.1.4
> > >
> > =

> > Are we sure all architectures have these, and only these errors? A quick
> > grep indicates not. I'm not sure we can document this easily here due to
> > it addressing all architectures at once. Maybe we could add arch-specif=
ic
> > subsections, but I'm not sure it's worth it.
> =

> Error codes are generally indicative at best, and rarely mutually
> exclusive in a given situation.
> =

> Writing a caveat to say that you shouldn't make assumptions about
> precisely what error code will be returned in a given situation would
> look odd: that really applies widely all over the kernel/user ABI, not
> just here.
> =

> _Maybe_ everything is exhaustively correct in this file already, but
> given the size of it, and the fact that many things are implemented
> per-arch, the chance of this seems zero.
> =

> I could add "invalid register ID" for EINVAL.  This allows some
> ambiguity about which error code applies for a nonexistent register.
> =

> Alternatively, we could revert this documentation instead.

Yeah, I vote we just drop this patch. It could add more confusion
when people start here to determine what to grep and then, when
grepping for it, can't find any occurrences, as would be the case
for ENOENT on at least a couple arches.

Thanks,
drew

> =

> It seemed appropriate to document the EPERM error for finalization
> ordering (added later), but since correct userspace code should never
> see this maybe it's reasonable to leave it undocumented(?)
> =

> Cheers
> ---Dave
