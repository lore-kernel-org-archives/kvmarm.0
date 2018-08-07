From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 09/16] KVM: arm64: Allow ID registers to by
 dynamically read-as-zero
Date: Tue, 7 Aug 2018 12:09:58 +0100
Message-ID: <20180807110958.GC9097@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-10-git-send-email-Dave.Martin@arm.com>
 <20180806130324.GA5985@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBC2449F8B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Aug 2018 07:10:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5hFYfuPFx2M8 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Aug 2018 07:10:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76F644005D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Aug 2018 07:10:03 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180806130324.GA5985@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 06, 2018 at 03:03:24PM +0200, Christoffer Dall wrote:
> Hi Dave,
> =

> I think there's a typo in the subject "to be" rather than "to by".
> =

> On Thu, Jun 21, 2018 at 03:57:33PM +0100, Dave Martin wrote:
> > When a feature-dependent ID register is hidden from the guest, it
> > needs to exhibit read-as-zero behaviour as defined by the Arm
> > architecture, rather than appearing to be entirely absent.
> > =

> > This patch updates the ID register emulation logic to make use of
> > the new check_present() method to determine whether the register
> > should read as zero instead of yielding the host's sanitised
> > value.  Because currently a false result from this method truncates
> > the trap call chain before the sysreg's emulate method() is called,
> > a flag is added to distinguish this special case, and helpers are
> > refactored appropriately.
> =

> I don't understand this last sentence.
> =

> And I'm not really sure I understand the code either.
> =

> I can't seem to see any registers which are defined as !present && !raz,
> which is what I thought this feature was all about.

!present and !raz is the default behaviour for everything that is not
ID-register-like.  This patch is adding the !present && raz case (though
that may not be a helpful way to descibe it ... see below).

> In other words, what is the benefit of this more generic method as
> opposed to having a wrapper around read_id_reg() for read_sve_id_reg()
> which sets RAZ if there is no support for SVE in this context?

There may be other ways to factor this.  I can't now remember whay I
went with this particular approach, except that I vaguely recall
hitting some obstacles when doing things another way.

Can you take a look at my attempted explanation below and then we
can reconsider this?

[...]

> =

> > =

> > This invloves some trivial updates to pass the vcpu pointer down
> > into the ID register emulation/access functions.
> > =

> > A new ID_SANITISED_IF() macro is defined for declaring
> > conditionally visible ID registers.
> > =

> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 51 ++++++++++++++++++++++++++++++---------=
--------
> >  arch/arm64/kvm/sys_regs.h | 11 ++++++++++
> >  2 files changed, 44 insertions(+), 18 deletions(-)
> > =


[...]

> > @@ -1840,7 +1855,7 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
> >  =

> >  	r =3D find_reg(params, table, num);
> >  =

> > -	if (likely(r) && sys_reg_present(vcpu, r)) {
> > +	if (likely(r) && sys_reg_present_or_raz(vcpu, r)) {
> >  		perform_access(vcpu, params, r);
> >  		return 0;
> >  	}
> > @@ -2016,7 +2031,7 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
> >  	if (!r)
> >  		r =3D find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
> >  =

> > -	if (likely(r) && sys_reg_present(vcpu, r)) {
> > +	if (likely(r) && sys_reg_present_or_raz(vcpu, r)) {
> >  		perform_access(vcpu, params, r);
> >  	} else {
> >  		kvm_err("Unsupported guest sys_reg access at: %lx\n",
> > @@ -2313,7 +2328,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu=
, const struct kvm_one_reg *reg
> >  	if (!r)
> >  		return get_invariant_sys_reg(reg->id, uaddr);
> >  =

> > -	if (!sys_reg_present(vcpu, r))
> > +	if (!sys_reg_present_or_raz(vcpu, r))
> >  		return -ENOENT;
> >  =

> >  	if (r->get_user)
> > @@ -2337,7 +2352,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu=
, const struct kvm_one_reg *reg
> >  	if (!r)
> >  		return set_invariant_sys_reg(reg->id, uaddr);
> >  =

> > -	if (!sys_reg_present(vcpu, r))
> > +	if (!sys_reg_present_or_raz(vcpu, r))
> >  		return -ENOENT;

On Wed, Jul 25, 2018 at 04:46:55PM +0100, Alex Benn=E9e wrote:
> It's all very well being raz, but shouldn't you catch this further down
> and not attempt to write the register that doesn't exist?

To be clear, is this a question about factoring, or do you think there's
a bug here?


In response to both sets of comments, I think the way the code is
factored is causing some confusion.

The idea in my head was something like this:

System register encodings fall into two classes:

 a) encodings that we emulate in some way
 b) encodings that we unconditionally reflect back to the guest as an
    Undef.

Architecturally defined system registers fall into two classes:

 i) registers whose removal turns all accesses into an Undef
 ii) registers whose removal exhibits some other behaviour.

These two classifications overlap somwehat.


>From an emulation perspective, (b), and (i) in the "register not
present" case, look the same: we trap the register and reflect an Undef
directly back to the guest with no further action required.

>From an emulation perspective, (a) and (ii) are also somewhat the
same: we need to emulate something, although precisely what we need
to do depends on which register it is and on whether the register is
deemed present or not.

sys_reg_check_present_or_raz() thus means "falls under (a) or (ii)",
i.e., some emulation is required and we need to call sysreg-specific
methods to figure out precisely what we need to do.

Conversely !sys_reg_check_present_or_raz() means that we can just
Undef the guest with no further logic required.

Does this rationale make things clearer?  The naming is perhaps
unfortunate.

Cheers,
---Dave
