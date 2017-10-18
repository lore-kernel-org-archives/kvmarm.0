From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 02/28] arm64: KVM: Hide unsupported AArch64 CPU
 features from guests
Date: Wed, 18 Oct 2017 15:45:10 +0100
Message-ID: <20171018144509.GZ19485@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-3-git-send-email-Dave.Martin@arm.com>
 <20171017135145.GT1845@lvm>
 <d7b9fac4-1a71-d7be-822a-1898f133aa70@arm.com>
 <20171018132026.GE8900@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171018132026.GE8900@cbox>
Sender: linux-arch-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Richard Sandiford <richard.sandiford@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 18, 2017 at 03:20:26PM +0200, Christoffer Dall wrote:
> On Tue, Oct 17, 2017 at 03:08:40PM +0100, Marc Zyngier wrote:
> > On 17/10/17 14:51, Christoffer Dall wrote:
> > > On Tue, Oct 10, 2017 at 07:38:19PM +0100, Dave Martin wrote:

[...]

> > >> +/* sys_reg_desc initialiser for known cpufeature ID registers */
> > >> +#define ID_SANITISED(name) {			\
> > >> +	SYS_DESC(SYS_##name),			\
> > >> +	.access	= access_id_reg,		\
> > >> +	.get_user = get_id_reg,			\
> > >> +	.set_user = set_id_reg,			\
> > >> +}
> > >> +
> > >> +/*
> > >> + * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
> > >> + * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
> > >> + * (1 <= crm < 8, 0 <= Op2 < 8).
> > >> + */
> > >> +#define ID_UNALLOCATED(crm, op2) {			\
> > >> +	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
> > >> +	.access = access_raz_id_reg,			\
> > >> +	.get_user = get_raz_id_reg,			\
> > >> +	.set_user = set_raz_id_reg,			\
> > >> +}
> > >> +
> > >> +/*
> > >> + * sys_reg_desc initialiser for known ID registers that we hide from guests.
> > >> + * For now, these are exposed just like unallocated ID regs: they appear
> > >> + * RAZ for the guest.
> > >> + */
> > > 
> > > What is a hidden ID register as opposed to an unallocated one?
> > 
> > A hidden register is one where all the features have been removed (RAZ),
> > making it similar to an unallocated one.
> > 
> > > Shouldn't one of them presumably cause an undefined exception in the
> > > guest?
> > 
> > No, that'd be a violation of the architecture. The unallocated ID
> > registers are required to be RAZ (see table D9-2 in D9.3.1), so that
> > software can probe for feature without running the risk of getting an UNDEF.
> > 
> Then I'm not really sure why we need the two defines.  Is that just to
> make it clear what the different rationales for dealing with various
> registers in the same way are?

Basically yes.

ID_HIDDEN() means we are bodging around something that we don't know
how to sanitise, whereas ID_UNALLOCATED() means that we follow the
architecture in returning zero for reads (maybe following an older
architecture version than the silicon).  

ID_HIDDEN()s may need to evolve SoC-specific quirkage if we need to
expose non-architectural SoC-specific features via the mechanism.
These should never simply be exposed unless the architecture is
tightened in the future in such a way as to make this safe (unlikely).

ID_UNALLOCATED()s OTOH will mostly turn into ID_SANITISED() as the
architecture gains new features.  The architecture could allocate new
IMP DEF feature regs though, in which case they would become ID_HIDDEN()
as soon as we know about them.


The distinction is drawn in attempt to help maintainers: the future
maintenance requirements for IN_UNALLOCATED()s will differ from
ID_HIDDEN()s.

Cheers
---Dave
