From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 07/27] arm64/sve: Low-level SVE architectural state
 manipulation functions
Date: Mon, 21 Aug 2017 15:38:18 +0100
Message-ID: <20170821143818.GR6321@e103592.cambridge.arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-8-git-send-email-Dave.Martin@arm.com>
 <878tid5ixn.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D59EB49C2F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Aug 2017 10:36:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OgIT87C+LRTe for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Aug 2017 10:36:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8919549C2A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Aug 2017 10:36:28 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <878tid5ixn.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 21, 2017 at 11:11:48AM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > Manipulating the SVE architectural state, including the vector and
> > predicate registers, first-fault register and the vector length,
> > requires the use of dedicated instructions added by SVE.
> >
> > This patch adds suitable assembly functions for saving and
> > restoring the SVE registers and querying the vector length.
> > Setting of the vector length is done as part of register restore.
> >
> > Since people building kernels may not all get an SVE-enabled
> > toolchain for a while, this patch uses macros that generate
> > explicit opcodes in place of assembler mnemonics.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/include/asm/fpsimd.h       |   5 ++
> >  arch/arm64/include/asm/fpsimdmacros.h | 137 ++++++++++++++++++++++++++=
++++++++
> >  arch/arm64/kernel/entry-fpsimd.S      |  17 +++++
> >  3 files changed, 159 insertions(+)

[...]

> > diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include=
/asm/fpsimdmacros.h
> > index 0f5fdd3..5023064 100644
> > --- a/arch/arm64/include/asm/fpsimdmacros.h
> > +++ b/arch/arm64/include/asm/fpsimdmacros.h

[...]

> > +.macro _sve_str_v nz, nxbase, offset=3D0
> > +	_sve_check_zreg \nz
> > +	_check_general_reg \nxbase
> > +	_check_num (\offset), -0x100, 0xff
> > +	.inst	0xe5804000			\
> > +		| (\nz)				\
> > +		| ((\nxbase) << 5)		\
> > +		| (((\offset) & 7) << 10)	\
> > +		| (((\offset) & 0x1f8) << 13)
> > +.endm
> =

> Can we have references to the ARM ARM titles (the section numbers keep
> changing) for each hand-hacked instruction please. Otherwise it is
> impossible to verify each one.

That's fair -- will do.

The supplement didn't exist at the time I first wrote this code...

[...]

Cheers
---Dave
