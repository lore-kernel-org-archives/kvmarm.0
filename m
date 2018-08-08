From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 09/16] KVM: arm64: Allow ID registers to by
 dynamically read-as-zero
Date: Wed, 8 Aug 2018 10:11:11 +0100
Message-ID: <20180808091111.GL9097@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-10-git-send-email-Dave.Martin@arm.com>
 <20180806130324.GA5985@e113682-lin.lund.arm.com>
 <20180807110958.GC9097@e103592.cambridge.arm.com>
 <20180807193512.GH5985@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0F894A0C8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Aug 2018 05:11:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f4yZIrD21aQK for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Aug 2018 05:11:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3218640493
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Aug 2018 05:11:16 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180807193512.GH5985@e113682-lin.lund.arm.com>
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

On Tue, Aug 07, 2018 at 09:35:12PM +0200, Christoffer Dall wrote:
> On Tue, Aug 07, 2018 at 12:09:58PM +0100, Dave Martin wrote:
> > On Mon, Aug 06, 2018 at 03:03:24PM +0200, Christoffer Dall wrote:
> > > Hi Dave,
> > > =

> > > I think there's a typo in the subject "to be" rather than "to by".
> > > =

> > > On Thu, Jun 21, 2018 at 03:57:33PM +0100, Dave Martin wrote:
> > > > When a feature-dependent ID register is hidden from the guest, it
> > > > needs to exhibit read-as-zero behaviour as defined by the Arm
> > > > architecture, rather than appearing to be entirely absent.
> > > > =

> > > > This patch updates the ID register emulation logic to make use of
> > > > the new check_present() method to determine whether the register
> > > > should read as zero instead of yielding the host's sanitised
> > > > value.  Because currently a false result from this method truncates
> > > > the trap call chain before the sysreg's emulate method() is called,
> > > > a flag is added to distinguish this special case, and helpers are
> > > > refactored appropriately.
> > > =

> > > I don't understand this last sentence.
> > > =

> > > And I'm not really sure I understand the code either.
> > > =

> > > I can't seem to see any registers which are defined as !present && !r=
az,
> > > which is what I thought this feature was all about.
> > =

> > !present and !raz is the default behaviour for everything that is not
> > ID-register-like.  This patch is adding the !present && raz case (though
> > that may not be a helpful way to descibe it ... see below).
> =

> Fair enough, but I don't really see why you need to classify a register
> as !present && raz, because raz implies present AFAICT.
> =

> > =

> > > In other words, what is the benefit of this more generic method as
> > > opposed to having a wrapper around read_id_reg() for read_sve_id_reg()
> > > which sets RAZ if there is no support for SVE in this context?
> > =

> > There may be other ways to factor this.  I can't now remember whay I
> > went with this particular approach, except that I vaguely recall
> > hitting some obstacles when doing things another way.
> =

> What I don't much care for is that we now seem to be mixing the concept
> of whether something is present and the value it returns if it is
> present in the overall system register handling logic.  And I don't
> understand why this is a requirement.
> =

> > =

> > Can you take a look at my attempted explanation below and then we
> > can reconsider this?
> =

> Sure, see my comments below.
> =

> > =

> > [...]
> > =

> > > =

> > > > =

> > > > This invloves some trivial updates to pass the vcpu pointer down
> > > > into the ID register emulation/access functions.
> > > > =

> > > > A new ID_SANITISED_IF() macro is defined for declaring
> > > > conditionally visible ID registers.
> > > > =

> > > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > > ---
> > > >  arch/arm64/kvm/sys_regs.c | 51 ++++++++++++++++++++++++++++++-----=
------------
> > > >  arch/arm64/kvm/sys_regs.h | 11 ++++++++++
> > > >  2 files changed, 44 insertions(+), 18 deletions(-)
> > > > =

> > =

> > [...]
> > =

> > > > @@ -1840,7 +1855,7 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
> > > >  =

> > > >  	r =3D find_reg(params, table, num);
> > > >  =

> > > > -	if (likely(r) && sys_reg_present(vcpu, r)) {
> > > > +	if (likely(r) && sys_reg_present_or_raz(vcpu, r)) {
> > > >  		perform_access(vcpu, params, r);
> > > >  		return 0;
> > > >  	}
> > > > @@ -2016,7 +2031,7 @@ static int emulate_sys_reg(struct kvm_vcpu *v=
cpu,
> > > >  	if (!r)
> > > >  		r =3D find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
> > > >  =

> > > > -	if (likely(r) && sys_reg_present(vcpu, r)) {
> > > > +	if (likely(r) && sys_reg_present_or_raz(vcpu, r)) {
> > > >  		perform_access(vcpu, params, r);
> > > >  	} else {
> > > >  		kvm_err("Unsupported guest sys_reg access at: %lx\n",
> > > > @@ -2313,7 +2328,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *=
vcpu, const struct kvm_one_reg *reg
> > > >  	if (!r)
> > > >  		return get_invariant_sys_reg(reg->id, uaddr);
> > > >  =

> > > > -	if (!sys_reg_present(vcpu, r))
> > > > +	if (!sys_reg_present_or_raz(vcpu, r))
> > > >  		return -ENOENT;
> > > >  =

> > > >  	if (r->get_user)
> > > > @@ -2337,7 +2352,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *=
vcpu, const struct kvm_one_reg *reg
> > > >  	if (!r)
> > > >  		return set_invariant_sys_reg(reg->id, uaddr);
> > > >  =

> > > > -	if (!sys_reg_present(vcpu, r))
> > > > +	if (!sys_reg_present_or_raz(vcpu, r))
> > > >  		return -ENOENT;
> > =

> > On Wed, Jul 25, 2018 at 04:46:55PM +0100, Alex Benn=E9e wrote:
> > > It's all very well being raz, but shouldn't you catch this further do=
wn
> > > and not attempt to write the register that doesn't exist?
> > =

> > To be clear, is this a question about factoring, or do you think there's
> > a bug here?
> > =

> > =

> > In response to both sets of comments, I think the way the code is
> > factored is causing some confusion.
> > =

> > The idea in my head was something like this:
> > =

> > System register encodings fall into two classes:
> > =

> >  a) encodings that we emulate in some way
> =

> this is present, then
> =

> >  b) encodings that we unconditionally reflect back to the guest as an
> >     Undef.
> =

> this is !present, then
> =

> The previous change made this a configurable thing as opposed to a
> static compile time thing, right?
> > =

> > Architecturally defined system registers fall into two classes:
> > =

> >  i) registers whose removal turns all accesses into an Undef
> >  ii) registers whose removal exhibits some other behaviour.
> =

> I'm not sure what you mean by 'removal' here, and which architectural
> concept that relates to, which makes it hard for me to parse the rest
> here...
> =

> > =

> > These two classifications overlap somwehat.
> > =

> > =

> > From an emulation perspective, (b), and (i) in the "register not
> > present" case, look the same: we trap the register and reflect an Undef
> > directly back to the guest with no further action required.
> > =

> > From an emulation perspective, (a) and (ii) are also somewhat the
> > same: we need to emulate something, although precisely what we need
> > to do depends on which register it is and on whether the register is
> > deemed present or not.
> > =

> > sys_reg_check_present_or_raz() thus means "falls under (a) or (ii)",
> > i.e., some emulation is required and we need to call sysreg-specific
> > methods to figure out precisely what we need to do.
> =

> yes, but we've always had that without the "or_raz" stuff at the lookup
> level.  What has changed?
> =

> > =

> > Conversely !sys_reg_check_present_or_raz() means that we can just
> > Undef the guest with no further logic required.
> =

> Yes, but that's the same as !present, because raz then implies present,
> see above.
> =

> > =

> > Does this rationale make things clearer?  The naming is perhaps
> > unfortunate.
> > =

> =

> Unfortunately not so much.  I have a strong feeling you want to move
> anything relating to something being emulated as RAZ/RAO/something else
> into sysreg specific functions.


The way I integrated this seemed natural at the time, but your
reaction suggests that it may not be the right approach...


At its heart, I'm trying to abstract out the special behaviour of
all unallocated ID registers, so that we can decide at runtime which
ones to hide fro the guest: within the ID register block, each
unallocated register becomes RAZ, not UNDEFINED as would be the case
for other system registers, so we need to capture both behaviours.


If we want a generic handler for all the ID registers in sys_regs.c,
then we need a flag to tell us whether to pass the ID register through
from cpufeatures or to make it appear as zero.

For ZCR_EL1 on the other hand, we really want attempts to access that
to reflect an Undef to the guest if we are pretending that SVE is not
implemented.  Again if we want to filter out some sysregs in a runtime-
controlled way, we need a flag to tell us whether to filter out a
particular register.

So, we have two specific ways of rolling a feature that is really
implemented in the hardware back to the ARMv8-A behaviour (RAZ for ID
registers and Undef for anything else).

I tried to group these under a single concept of presence/absence,
which is what check_present() is intended to check.  However, we
don't really want ID registers to Undef when !check_present(): this
is bodged around with the additional SR_RAZ_IF_ABSENT flag so that
the decision about whether to make the register Undef or not can
be made generic.


It seems that this attempt at generalisation is creating more confusion
than it solves, so I may abandon it and just handle ID_AA64PFR0_EL1 and
ID_AA64ZFR0_EL1 specially.

When/if we've done that a few times for different features, it may
become clearer what any generic framework for doing it should look
like...

Thoughts?

---Dave
