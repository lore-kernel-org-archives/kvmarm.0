From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 08/12] KVM: arm64: re-factor hyp.S debug register code
Date: Wed, 24 Jun 2015 22:19:29 +0200
Message-ID: <20150624201929.GD22785@cbox>
References: <1434716630-18260-1-git-send-email-alex.bennee@linaro.org>
 <1434716630-18260-9-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2C3E56EEE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 16:08:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tWh1rOVyscBT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2015 16:08:32 -0400 (EDT)
Received: from mail-la0-f48.google.com (mail-la0-f48.google.com
 [209.85.215.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6B4B56EF1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 16:08:31 -0400 (EDT)
Received: by lagx9 with SMTP id x9so32897628lag.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 13:19:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1434716630-18260-9-git-send-email-alex.bennee@linaro.org>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, marc.zyngier@arm.com, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 19, 2015 at 01:23:46PM +0100, Alex Benn=E9e wrote:
> This is a pre-cursor to sharing the code with the guest debug support.
> This replaces the big macro that fishes data out of a fixed location
> with a more general helper macro to restore a set of debug registers. It
> uses macro substitution so it can be re-used for debug control and value
> registers. It does however rely on the debug registers being 64 bit
> aligned (as they happen to be in the hyp ABI).
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> ---
> v3:
>   - return to the patch series
>   - add save and restore targets
>   - change register use and document
> v4:
>   - keep original setup/restore names
>   - don't use split u32/u64 structure yet
> v6:
>   - fix ws and clobber info in hyp.S
> ---
>  arch/arm64/kvm/hyp.S | 517 ++++++++++++++-------------------------------=
------
>  1 file changed, 138 insertions(+), 379 deletions(-)
> =

> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index 74e63d8..ee7f649 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -228,199 +228,52 @@
>  	stp	x24, x25, [x3, #160]
>  .endm
>  =

> -.macro save_debug
> -	// x2: base address for cpu context
> -	// x3: tmp register
> -
> -	mrs	x26, id_aa64dfr0_el1
> -	ubfx	x24, x26, #12, #4	// Extract BRPs
> -	ubfx	x25, x26, #20, #4	// Extract WRPs
> -	mov	w26, #15
> -	sub	w24, w26, w24		// How many BPs to skip
> -	sub	w25, w26, w25		// How many WPs to skip
> -
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> -
> -	adr	x26, 1f
> -	add	x26, x26, x24, lsl #2
> -	br	x26
> -1:
> -	mrs	x20, dbgbcr15_el1
> -	mrs	x19, dbgbcr14_el1
> -	mrs	x18, dbgbcr13_el1
> -	mrs	x17, dbgbcr12_el1
> -	mrs	x16, dbgbcr11_el1
> -	mrs	x15, dbgbcr10_el1
> -	mrs	x14, dbgbcr9_el1
> -	mrs	x13, dbgbcr8_el1
> -	mrs	x12, dbgbcr7_el1
> -	mrs	x11, dbgbcr6_el1
> -	mrs	x10, dbgbcr5_el1
> -	mrs	x9, dbgbcr4_el1
> -	mrs	x8, dbgbcr3_el1
> -	mrs	x7, dbgbcr2_el1
> -	mrs	x6, dbgbcr1_el1
> -	mrs	x5, dbgbcr0_el1
> -
> -	adr	x26, 1f
> -	add	x26, x26, x24, lsl #2
> -	br	x26
> -
> -1:
> -	str	x20, [x3, #(15 * 8)]
> -	str	x19, [x3, #(14 * 8)]
> -	str	x18, [x3, #(13 * 8)]
> -	str	x17, [x3, #(12 * 8)]
> -	str	x16, [x3, #(11 * 8)]
> -	str	x15, [x3, #(10 * 8)]
> -	str	x14, [x3, #(9 * 8)]
> -	str	x13, [x3, #(8 * 8)]
> -	str	x12, [x3, #(7 * 8)]
> -	str	x11, [x3, #(6 * 8)]
> -	str	x10, [x3, #(5 * 8)]
> -	str	x9, [x3, #(4 * 8)]
> -	str	x8, [x3, #(3 * 8)]
> -	str	x7, [x3, #(2 * 8)]
> -	str	x6, [x3, #(1 * 8)]
> -	str	x5, [x3, #(0 * 8)]
> -
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGBVR0_EL1)
> -
> -	adr	x26, 1f
> -	add	x26, x26, x24, lsl #2
> -	br	x26
> -1:
> -	mrs	x20, dbgbvr15_el1
> -	mrs	x19, dbgbvr14_el1
> -	mrs	x18, dbgbvr13_el1
> -	mrs	x17, dbgbvr12_el1
> -	mrs	x16, dbgbvr11_el1
> -	mrs	x15, dbgbvr10_el1
> -	mrs	x14, dbgbvr9_el1
> -	mrs	x13, dbgbvr8_el1
> -	mrs	x12, dbgbvr7_el1
> -	mrs	x11, dbgbvr6_el1
> -	mrs	x10, dbgbvr5_el1
> -	mrs	x9, dbgbvr4_el1
> -	mrs	x8, dbgbvr3_el1
> -	mrs	x7, dbgbvr2_el1
> -	mrs	x6, dbgbvr1_el1
> -	mrs	x5, dbgbvr0_el1
> -
> -	adr	x26, 1f
> -	add	x26, x26, x24, lsl #2
> -	br	x26
> -
> -1:
> -	str	x20, [x3, #(15 * 8)]
> -	str	x19, [x3, #(14 * 8)]
> -	str	x18, [x3, #(13 * 8)]
> -	str	x17, [x3, #(12 * 8)]
> -	str	x16, [x3, #(11 * 8)]
> -	str	x15, [x3, #(10 * 8)]
> -	str	x14, [x3, #(9 * 8)]
> -	str	x13, [x3, #(8 * 8)]
> -	str	x12, [x3, #(7 * 8)]
> -	str	x11, [x3, #(6 * 8)]
> -	str	x10, [x3, #(5 * 8)]
> -	str	x9, [x3, #(4 * 8)]
> -	str	x8, [x3, #(3 * 8)]
> -	str	x7, [x3, #(2 * 8)]
> -	str	x6, [x3, #(1 * 8)]
> -	str	x5, [x3, #(0 * 8)]
> -
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGWCR0_EL1)
> -
> -	adr	x26, 1f
> -	add	x26, x26, x25, lsl #2
> -	br	x26
> +.macro save_debug type
> +	// x4: pointer to register set
> +	// x5: number of registers to skip
> +	// x6..x22 trashed
> +
> +	adr	x22, 1f
> +	add	x22, x22, x5, lsl #2
> +	br	x22
>  1:
> -	mrs	x20, dbgwcr15_el1
> -	mrs	x19, dbgwcr14_el1
> -	mrs	x18, dbgwcr13_el1
> -	mrs	x17, dbgwcr12_el1
> -	mrs	x16, dbgwcr11_el1
> -	mrs	x15, dbgwcr10_el1
> -	mrs	x14, dbgwcr9_el1
> -	mrs	x13, dbgwcr8_el1
> -	mrs	x12, dbgwcr7_el1
> -	mrs	x11, dbgwcr6_el1
> -	mrs	x10, dbgwcr5_el1
> -	mrs	x9, dbgwcr4_el1
> -	mrs	x8, dbgwcr3_el1
> -	mrs	x7, dbgwcr2_el1
> -	mrs	x6, dbgwcr1_el1
> -	mrs	x5, dbgwcr0_el1
> -
> -	adr	x26, 1f
> -	add	x26, x26, x25, lsl #2
> -	br	x26
> -
> -1:
> -	str	x20, [x3, #(15 * 8)]
> -	str	x19, [x3, #(14 * 8)]
> -	str	x18, [x3, #(13 * 8)]
> -	str	x17, [x3, #(12 * 8)]
> -	str	x16, [x3, #(11 * 8)]
> -	str	x15, [x3, #(10 * 8)]
> -	str	x14, [x3, #(9 * 8)]
> -	str	x13, [x3, #(8 * 8)]
> -	str	x12, [x3, #(7 * 8)]
> -	str	x11, [x3, #(6 * 8)]
> -	str	x10, [x3, #(5 * 8)]
> -	str	x9, [x3, #(4 * 8)]
> -	str	x8, [x3, #(3 * 8)]
> -	str	x7, [x3, #(2 * 8)]
> -	str	x6, [x3, #(1 * 8)]
> -	str	x5, [x3, #(0 * 8)]
> -
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGWVR0_EL1)
> -
> -	adr	x26, 1f
> -	add	x26, x26, x25, lsl #2
> -	br	x26
> +	mrs	x21, \type\()15_el1
> +	mrs	x20, \type\()14_el1
> +	mrs	x19, \type\()13_el1
> +	mrs	x18, \type\()12_el1
> +	mrs	x17, \type\()11_el1
> +	mrs	x16, \type\()10_el1
> +	mrs	x15, \type\()9_el1
> +	mrs	x14, \type\()8_el1
> +	mrs	x13, \type\()7_el1
> +	mrs	x12, \type\()6_el1
> +	mrs	x11, \type\()5_el1
> +	mrs	x10, \type\()4_el1
> +	mrs	x9, \type\()3_el1
> +	mrs	x8, \type\()2_el1
> +	mrs	x7, \type\()1_el1
> +	mrs	x6, \type\()0_el1
> +
> +	adr	x22, 1f
> +	add	x22, x22, x5, lsl #2
> +	br	x22
>  1:
> -	mrs	x20, dbgwvr15_el1
> -	mrs	x19, dbgwvr14_el1
> -	mrs	x18, dbgwvr13_el1
> -	mrs	x17, dbgwvr12_el1
> -	mrs	x16, dbgwvr11_el1
> -	mrs	x15, dbgwvr10_el1
> -	mrs	x14, dbgwvr9_el1
> -	mrs	x13, dbgwvr8_el1
> -	mrs	x12, dbgwvr7_el1
> -	mrs	x11, dbgwvr6_el1
> -	mrs	x10, dbgwvr5_el1
> -	mrs	x9, dbgwvr4_el1
> -	mrs	x8, dbgwvr3_el1
> -	mrs	x7, dbgwvr2_el1
> -	mrs	x6, dbgwvr1_el1
> -	mrs	x5, dbgwvr0_el1
> -
> -	adr	x26, 1f
> -	add	x26, x26, x25, lsl #2
> -	br	x26
> -
> -1:
> -	str	x20, [x3, #(15 * 8)]
> -	str	x19, [x3, #(14 * 8)]
> -	str	x18, [x3, #(13 * 8)]
> -	str	x17, [x3, #(12 * 8)]
> -	str	x16, [x3, #(11 * 8)]
> -	str	x15, [x3, #(10 * 8)]
> -	str	x14, [x3, #(9 * 8)]
> -	str	x13, [x3, #(8 * 8)]
> -	str	x12, [x3, #(7 * 8)]
> -	str	x11, [x3, #(6 * 8)]
> -	str	x10, [x3, #(5 * 8)]
> -	str	x9, [x3, #(4 * 8)]
> -	str	x8, [x3, #(3 * 8)]
> -	str	x7, [x3, #(2 * 8)]
> -	str	x6, [x3, #(1 * 8)]
> -	str	x5, [x3, #(0 * 8)]
> -
> -	mrs	x21, mdccint_el1
> -	str	x21, [x2, #CPU_SYSREG_OFFSET(MDCCINT_EL1)]
> +	str	x21, [x4, #(15 * 8)]
> +	str	x20, [x4, #(14 * 8)]
> +	str	x19, [x4, #(13 * 8)]
> +	str	x18, [x4, #(12 * 8)]
> +	str	x17, [x4, #(11 * 8)]
> +	str	x16, [x4, #(10 * 8)]
> +	str	x15, [x4, #(9 * 8)]
> +	str	x14, [x4, #(8 * 8)]
> +	str	x13, [x4, #(7 * 8)]
> +	str	x12, [x4, #(6 * 8)]
> +	str	x11, [x4, #(5 * 8)]
> +	str	x10, [x4, #(4 * 8)]
> +	str	x9, [x4, #(3 * 8)]
> +	str	x8, [x4, #(2 * 8)]
> +	str	x7, [x4, #(1 * 8)]
> +	str	x6, [x4, #(0 * 8)]
>  .endm
>  =

>  .macro restore_sysregs
> @@ -465,195 +318,52 @@
>  	msr	mdscr_el1,	x25
>  .endm
>  =

> -.macro restore_debug
> -	// x2: base address for cpu context
> -	// x3: tmp register
> -
> -	mrs	x26, id_aa64dfr0_el1
> -	ubfx	x24, x26, #12, #4	// Extract BRPs
> -	ubfx	x25, x26, #20, #4	// Extract WRPs
> -	mov	w26, #15
> -	sub	w24, w26, w24		// How many BPs to skip
> -	sub	w25, w26, w25		// How many WPs to skip
> -
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> +.macro restore_debug type
> +        // x4: pointer to register set
> +        // x5: number of registers to skip

there's a white space issue here, should be tabs instead of spaces.  We
can probably fix while applying, if there's no need to respin.

> +	// x6..x22 trashed
>  =

> -	adr	x26, 1f
> -	add	x26, x26, x24, lsl #2
> -	br	x26
> +	adr	x22, 1f
> +	add	x22, x22, x5, lsl #2
> +	br	x22
>  1:
> -	ldr	x20, [x3, #(15 * 8)]
> -	ldr	x19, [x3, #(14 * 8)]
> -	ldr	x18, [x3, #(13 * 8)]
> -	ldr	x17, [x3, #(12 * 8)]
> -	ldr	x16, [x3, #(11 * 8)]
> -	ldr	x15, [x3, #(10 * 8)]
> -	ldr	x14, [x3, #(9 * 8)]
> -	ldr	x13, [x3, #(8 * 8)]
> -	ldr	x12, [x3, #(7 * 8)]
> -	ldr	x11, [x3, #(6 * 8)]
> -	ldr	x10, [x3, #(5 * 8)]
> -	ldr	x9, [x3, #(4 * 8)]
> -	ldr	x8, [x3, #(3 * 8)]
> -	ldr	x7, [x3, #(2 * 8)]
> -	ldr	x6, [x3, #(1 * 8)]
> -	ldr	x5, [x3, #(0 * 8)]
> -
> -	adr	x26, 1f
> -	add	x26, x26, x24, lsl #2
> -	br	x26
> +	ldr	x21, [x4, #(15 * 8)]
> +	ldr	x20, [x4, #(14 * 8)]
> +	ldr	x19, [x4, #(13 * 8)]
> +	ldr	x18, [x4, #(12 * 8)]
> +	ldr	x17, [x4, #(11 * 8)]
> +	ldr	x16, [x4, #(10 * 8)]
> +	ldr	x15, [x4, #(9 * 8)]
> +	ldr	x14, [x4, #(8 * 8)]
> +	ldr	x13, [x4, #(7 * 8)]
> +	ldr	x12, [x4, #(6 * 8)]
> +	ldr	x11, [x4, #(5 * 8)]
> +	ldr	x10, [x4, #(4 * 8)]
> +	ldr	x9, [x4, #(3 * 8)]
> +	ldr	x8, [x4, #(2 * 8)]
> +	ldr	x7, [x4, #(1 * 8)]
> +	ldr	x6, [x4, #(0 * 8)]
> +
> +	adr	x22, 1f
> +	add	x22, x22, x5, lsl #2
> +	br	x22
>  1:
> -	msr	dbgbcr15_el1, x20
> -	msr	dbgbcr14_el1, x19
> -	msr	dbgbcr13_el1, x18
> -	msr	dbgbcr12_el1, x17
> -	msr	dbgbcr11_el1, x16
> -	msr	dbgbcr10_el1, x15
> -	msr	dbgbcr9_el1, x14
> -	msr	dbgbcr8_el1, x13
> -	msr	dbgbcr7_el1, x12
> -	msr	dbgbcr6_el1, x11
> -	msr	dbgbcr5_el1, x10
> -	msr	dbgbcr4_el1, x9
> -	msr	dbgbcr3_el1, x8
> -	msr	dbgbcr2_el1, x7
> -	msr	dbgbcr1_el1, x6
> -	msr	dbgbcr0_el1, x5
> -
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGBVR0_EL1)
> -
> -	adr	x26, 1f
> -	add	x26, x26, x24, lsl #2
> -	br	x26
> -1:
> -	ldr	x20, [x3, #(15 * 8)]
> -	ldr	x19, [x3, #(14 * 8)]
> -	ldr	x18, [x3, #(13 * 8)]
> -	ldr	x17, [x3, #(12 * 8)]
> -	ldr	x16, [x3, #(11 * 8)]
> -	ldr	x15, [x3, #(10 * 8)]
> -	ldr	x14, [x3, #(9 * 8)]
> -	ldr	x13, [x3, #(8 * 8)]
> -	ldr	x12, [x3, #(7 * 8)]
> -	ldr	x11, [x3, #(6 * 8)]
> -	ldr	x10, [x3, #(5 * 8)]
> -	ldr	x9, [x3, #(4 * 8)]
> -	ldr	x8, [x3, #(3 * 8)]
> -	ldr	x7, [x3, #(2 * 8)]
> -	ldr	x6, [x3, #(1 * 8)]
> -	ldr	x5, [x3, #(0 * 8)]
> -
> -	adr	x26, 1f
> -	add	x26, x26, x24, lsl #2
> -	br	x26
> -1:
> -	msr	dbgbvr15_el1, x20
> -	msr	dbgbvr14_el1, x19
> -	msr	dbgbvr13_el1, x18
> -	msr	dbgbvr12_el1, x17
> -	msr	dbgbvr11_el1, x16
> -	msr	dbgbvr10_el1, x15
> -	msr	dbgbvr9_el1, x14
> -	msr	dbgbvr8_el1, x13
> -	msr	dbgbvr7_el1, x12
> -	msr	dbgbvr6_el1, x11
> -	msr	dbgbvr5_el1, x10
> -	msr	dbgbvr4_el1, x9
> -	msr	dbgbvr3_el1, x8
> -	msr	dbgbvr2_el1, x7
> -	msr	dbgbvr1_el1, x6
> -	msr	dbgbvr0_el1, x5
> -
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGWCR0_EL1)
> -
> -	adr	x26, 1f
> -	add	x26, x26, x25, lsl #2
> -	br	x26
> -1:
> -	ldr	x20, [x3, #(15 * 8)]
> -	ldr	x19, [x3, #(14 * 8)]
> -	ldr	x18, [x3, #(13 * 8)]
> -	ldr	x17, [x3, #(12 * 8)]
> -	ldr	x16, [x3, #(11 * 8)]
> -	ldr	x15, [x3, #(10 * 8)]
> -	ldr	x14, [x3, #(9 * 8)]
> -	ldr	x13, [x3, #(8 * 8)]
> -	ldr	x12, [x3, #(7 * 8)]
> -	ldr	x11, [x3, #(6 * 8)]
> -	ldr	x10, [x3, #(5 * 8)]
> -	ldr	x9, [x3, #(4 * 8)]
> -	ldr	x8, [x3, #(3 * 8)]
> -	ldr	x7, [x3, #(2 * 8)]
> -	ldr	x6, [x3, #(1 * 8)]
> -	ldr	x5, [x3, #(0 * 8)]
> -
> -	adr	x26, 1f
> -	add	x26, x26, x25, lsl #2
> -	br	x26
> -1:
> -	msr	dbgwcr15_el1, x20
> -	msr	dbgwcr14_el1, x19
> -	msr	dbgwcr13_el1, x18
> -	msr	dbgwcr12_el1, x17
> -	msr	dbgwcr11_el1, x16
> -	msr	dbgwcr10_el1, x15
> -	msr	dbgwcr9_el1, x14
> -	msr	dbgwcr8_el1, x13
> -	msr	dbgwcr7_el1, x12
> -	msr	dbgwcr6_el1, x11
> -	msr	dbgwcr5_el1, x10
> -	msr	dbgwcr4_el1, x9
> -	msr	dbgwcr3_el1, x8
> -	msr	dbgwcr2_el1, x7
> -	msr	dbgwcr1_el1, x6
> -	msr	dbgwcr0_el1, x5
> -
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGWVR0_EL1)
> -
> -	adr	x26, 1f
> -	add	x26, x26, x25, lsl #2
> -	br	x26
> -1:
> -	ldr	x20, [x3, #(15 * 8)]
> -	ldr	x19, [x3, #(14 * 8)]
> -	ldr	x18, [x3, #(13 * 8)]
> -	ldr	x17, [x3, #(12 * 8)]
> -	ldr	x16, [x3, #(11 * 8)]
> -	ldr	x15, [x3, #(10 * 8)]
> -	ldr	x14, [x3, #(9 * 8)]
> -	ldr	x13, [x3, #(8 * 8)]
> -	ldr	x12, [x3, #(7 * 8)]
> -	ldr	x11, [x3, #(6 * 8)]
> -	ldr	x10, [x3, #(5 * 8)]
> -	ldr	x9, [x3, #(4 * 8)]
> -	ldr	x8, [x3, #(3 * 8)]
> -	ldr	x7, [x3, #(2 * 8)]
> -	ldr	x6, [x3, #(1 * 8)]
> -	ldr	x5, [x3, #(0 * 8)]
> -
> -	adr	x26, 1f
> -	add	x26, x26, x25, lsl #2
> -	br	x26
> -1:
> -	msr	dbgwvr15_el1, x20
> -	msr	dbgwvr14_el1, x19
> -	msr	dbgwvr13_el1, x18
> -	msr	dbgwvr12_el1, x17
> -	msr	dbgwvr11_el1, x16
> -	msr	dbgwvr10_el1, x15
> -	msr	dbgwvr9_el1, x14
> -	msr	dbgwvr8_el1, x13
> -	msr	dbgwvr7_el1, x12
> -	msr	dbgwvr6_el1, x11
> -	msr	dbgwvr5_el1, x10
> -	msr	dbgwvr4_el1, x9
> -	msr	dbgwvr3_el1, x8
> -	msr	dbgwvr2_el1, x7
> -	msr	dbgwvr1_el1, x6
> -	msr	dbgwvr0_el1, x5
> -
> -	ldr	x21, [x2, #CPU_SYSREG_OFFSET(MDCCINT_EL1)]
> -	msr	mdccint_el1, x21
> +	msr	\type\()15_el1, x21
> +	msr	\type\()14_el1, x20
> +	msr	\type\()13_el1, x19
> +	msr	\type\()12_el1, x18
> +	msr	\type\()11_el1, x17
> +	msr	\type\()10_el1, x16
> +	msr	\type\()9_el1, x15
> +	msr	\type\()8_el1, x14
> +	msr	\type\()7_el1, x13
> +	msr	\type\()6_el1, x12
> +	msr	\type\()5_el1, x11
> +	msr	\type\()4_el1, x10
> +	msr	\type\()3_el1, x9
> +	msr	\type\()2_el1, x8
> +	msr	\type\()1_el1, x7
> +	msr	\type\()0_el1, x6
>  .endm
>  =

>  .macro skip_32bit_state tmp, target
> @@ -887,12 +597,61 @@ __restore_sysregs:
>  	restore_sysregs
>  	ret
>  =

> +/* Save debug state */
>  __save_debug:
> -	save_debug
> +	// x2: ptr to CPU context
> +	// x4/x5/x6-22/x24-26: trashed
> +
> +	mrs	x26, id_aa64dfr0_el1
> +	ubfx	x24, x26, #12, #4	// Extract BRPs
> +	ubfx	x25, x26, #20, #4	// Extract WRPs
> +	mov	w26, #15
> +	sub	w24, w26, w24		// How many BPs to skip
> +	sub	w25, w26, w25		// How many WPs to skip
> +
> +	mov	x5, x24
> +	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> +	save_debug dbgbcr
> +	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBVR0_EL1)
> +	save_debug dbgbvr
> +
> +	mov	x5, x25
> +	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWCR0_EL1)
> +	save_debug dbgwcr
> +	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWVR0_EL1)
> +	save_debug dbgwvr
> +
> +	mrs	x21, mdccint_el1
> +	str	x21, [x2, #CPU_SYSREG_OFFSET(MDCCINT_EL1)]
>  	ret
>  =

> +/* Restore debug state */
>  __restore_debug:
> -	restore_debug
> +	// x2: ptr to CPU context
> +	// x4/x5/x6-22/x24-26: trashed
> +
> +	mrs	x26, id_aa64dfr0_el1
> +	ubfx	x24, x26, #12, #4	// Extract BRPs
> +	ubfx	x25, x26, #20, #4	// Extract WRPs
> +	mov	w26, #15
> +	sub	w24, w26, w24		// How many BPs to skip
> +	sub	w25, w26, w25		// How many WPs to skip
> +
> +	mov	x5, x24
> +	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> +	restore_debug dbgbcr
> +	add	x4, x2, #CPU_SYSREG_OFFSET(DBGBVR0_EL1)
> +	restore_debug dbgbvr
> +
> +	mov	x5, x25
> +	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWCR0_EL1)
> +	restore_debug dbgwcr
> +	add	x4, x2, #CPU_SYSREG_OFFSET(DBGWVR0_EL1)
> +	restore_debug dbgwvr
> +
> +	ldr	x21, [x2, #CPU_SYSREG_OFFSET(MDCCINT_EL1)]
> +	msr	mdccint_el1, x21
> +
>  	ret
>  =

>  __save_fpsimd:
> -- =

> 2.4.3
> =


Besides the whitespace nit:
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
