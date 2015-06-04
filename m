From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 08/12] KVM: arm64: re-factor hyp.S debug register code
Date: Thu, 4 Jun 2015 13:12:48 +0200
Message-ID: <20150604111248.GJ7657@cbox>
References: <1432891828-4816-1-git-send-email-alex.bennee@linaro.org>
 <1432891828-4816-9-git-send-email-alex.bennee@linaro.org>
 <20150604102308.GD7657@cbox>
 <87d21bbw3d.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87d21bbw3d.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 04, 2015 at 11:34:46AM +0100, Alex Benn=E9e wrote:
>=20
> Christoffer Dall <christoffer.dall@linaro.org> writes:
>=20
> > On Fri, May 29, 2015 at 10:30:24AM +0100, Alex Benn=E9e wrote:
> >> This is a pre-cursor to sharing the code with the guest debug supp=
ort.
> >> This replaces the big macro that fishes data out of a fixed locati=
on
> >> with a more general helper macro to restore a set of debug registe=
rs. It
> >> uses macro substitution so it can be re-used for debug control and=
 value
> >> registers. It does however rely on the debug registers being 64 bi=
t
> >> aligned (as they happen to be in the hyp ABI).
>=20
> Oops I'd better fix that commit comment.
>=20
> >>=20
> >> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> >>=20
> >> ---
> >> v3:
> >>   - return to the patch series
> >>   - add save and restore targets
> >>   - change register use and document
> >> v4:
> >>   - keep original setup/restore names
> >>   - don't use split u32/u64 structure yet
> >> ---
> >>  arch/arm64/kvm/hyp.S | 519 ++++++++++++++------------------------=
-------------
> >>  1 file changed, 140 insertions(+), 379 deletions(-)
> >>=20
> >> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> >> index 74e63d8..9c4897d 100644
> >> --- a/arch/arm64/kvm/hyp.S
> >> +++ b/arch/arm64/kvm/hyp.S
> >
> >
> > [...]
> >
> >> @@ -465,195 +318,52 @@
> >>  	msr	mdscr_el1,	x25
> >>  .endm
> >> =20
> >> -.macro restore_debug
> >> -	// x2: base address for cpu context
> >> -	// x3: tmp register
> >> -
> >> -	mrs	x26, id_aa64dfr0_el1
> >> -	ubfx	x24, x26, #12, #4	// Extract BRPs
> >> -	ubfx	x25, x26, #20, #4	// Extract WRPs
> >> -	mov	w26, #15
> >> -	sub	w24, w26, w24		// How many BPs to skip
> >> -	sub	w25, w26, w25		// How many WPs to skip
> >> -
> >> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> >> +.macro restore_debug type
> >> +        // x4: pointer to register set
> >> +        // x5: number of registers to skip
> >
> > nit: use tabs instead of spaces here...
> >
> >> +	// x6..x22 trashed
> >> =20
> >
> > [...]
> >
> >> @@ -887,12 +597,63 @@ __restore_sysregs:
> >>  	restore_sysregs
> >>  	ret
> >> =20
> >> +/* Save debug state */
> >>  __save_debug:
> >> -	save_debug
> >> +	// x0: base address for vcpu context
> >> +	// x2: ptr to current CPU context
> >> +	// x4/x5: trashed
> >
> > I had a bunch of questions here which I think you missed last time
> > around:
> >  1. why do we need the vcpu context?
>=20
> We don't, I'll drop that
>=20
> >  2. what does 'current' mean here?
>=20
> Either the host or vcpu context depending which way we are currently =
going.
>=20

drop 'current' please.

> >  3. you're also trashing everything that save_debug trashes, so x4/=
5,
> >     x6-x22 trashed would be more correct
>=20
> OK
>=20
> >
> >> +
> >> +	mrs	x26, id_aa64dfr0_el1
> >> +	ubfx	x24, x26, #12, #4	// Extract BRPs
> >> +	ubfx	x25, x26, #20, #4	// Extract WRPs
> >> +	mov	w26, #15
> >> +	sub	w24, w26, w24		// How many BPs to skip
> >> +	sub	w25, w26, w25		// How many WPs to skip
> >> +
> >> +	mov     x5, x24
> >> +	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> >> +	save_debug dbgbcr
> >> +	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBVR0_EL1)
> >> +	save_debug dbgbvr
> >> +
> >> +	mov     x5, x25
> >> +	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWCR0_EL1)
> >> +	save_debug dbgwcr
> >> +	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWVR0_EL1)
> >> +	save_debug dbgwvr
> >> +
> >> +	mrs	x21, mdccint_el1
> >> +	str	x21, [x2, #CPU_SYSREG_OFFSET(MDCCINT_EL1)]
> >>  	ret
> >> =20
> >> +/* Restore debug state */
> >>  __restore_debug:
> >> -	restore_debug
> >> +	// x0: base address for cpu context
> >> +	// x2: ptr to current CPU context
> >> +	// x4/x5: trashed
> >
> > and you missed these comments too, basically same stuff, but why wa=
s it
> > 'cpu' here and not 'vcpu' like above?
>=20
> Again we use the functions both for restoring host and vcpu debug con=
text.
>=20
Well, the two functions operate on the same structures, so I would like
them to be consistent...

-Christoffer
