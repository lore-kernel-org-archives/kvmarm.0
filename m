From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC] KVM API extensions for SVE
Date: Tue, 21 Nov 2017 13:49:16 +0000
Message-ID: <20171121134913.GI22781@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70EDD40D25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Nov 2017 08:46:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TV7gNtfYeJW0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Nov 2017 08:46:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 133EC40651
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Nov 2017 08:46:48 -0500 (EST)
Content-Disposition: inline
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi all,

SVE adds some new registers, and their size depends on the hardware ando
on runtime sysreg settings.

Before coding something, I'd like to get people's views on my current
approach here.

--8<--

New vcpu feature flag:
/*
 * userspace can support regs up to at least 2048 bits in size via ioctl,
 * and will honour the size field in the reg iD
 */
#define KVM_ARM_VCPU_LARGE_REGS	4

Should we just error out of userspace fails to set this on a system that
supports SVE, or is that too brutal?  If we do treat that as an error,
then we can unconditionally enable SVE for the guest when the host
supports it -- which cuts down on unnecessary implementation complexity.

Alternatively, we would need logic to disable SVE if userspace is too
old, i.e., doesn't set this flag.  Then we might need to enforce that
the flag is set the same on every vcpu -- but from the kernel's PoV
it probably doesn't matter.


/*
 * For the SVE regs, we add some new reg IDs.
 * Zn are presented in 2048-bit slices; Pn, FFR are presented in 256-bit
 * slices.  This is sufficient for only a single slice to be required
 * per register for SVE, but ensures expansion room in case future arch
 * versions grow the maximum size.
 */
#define KVM_REG_SIZE_U2048 (ULL(8) << KVM_REG_SIZE_MASK)
#define KVM_REG_ARM64_SVE_Z(n, i) /* Zn[2048 * (i + 1) - 1 : 2048 * i] */ \
	((0x0014 << KVM_REG_ARM_COPROC_SHIFT) | KVM_REG_SIZE_U2048 |	\
		((n) << 5) | (i))
#define KVM_REG_ARM64_SVE_P(n, i) /* Pn[256 * (i + 1) - 1 : 256 * i] */	\
	((0x0014 << KVM_REG_ARM_COPROC_SHIFT) | KVM_REG_SIZE_U256 |	\
		(((n) + 32) << 5) | (i))
#define KVM_REG_ARM64_SVE_FFR(i) /* FFR[256 * (i + 1) - 1 : 256 * i] */	\
	 KVM_REG_ARM64_SVE_P(16, i)

For j in [0,3], KVM_REG_ARM64_SVE_Z(n, 0) bits [32(j + 1) - 1 : 32 * j]
	alias KVM_REG_ARM_CORE_REG(fp_regs.vregs[n]) + j


Bits above the max vector length could be
 * don't care (or not copied at all) on read; ignored on write
 * zero on read; ignored on write
 * zero on read; must be zero on write

Bits between the current and max vector length are trickier to specify:
the "current" vector length for ioctl access is ill-defined, because
we would need to specify ordering dependencies between Zn/Pn/FFR access
and access to ZCR_EL1.

So, it may be simpler to expose the full maximum supported vector size
unconditionally through ioctl, and pack/unpack as necessary.

Currently, data is packed in the vcpu struct in a vector length
dependent format, since this seems optimal for low-level save/restore,
so there will be potential data loss / zero padding when converting.

This may cause some unexpected effects.  For example:

KVM_SET_ONE_REG(ZCR_EL1, 0) 
/* Guest's current vector length will be 128 bits when started */

KVM_SET_ONE_REG(Z0, (uint256_t)1 << 128)
KVM_GET_ONE_REG(Z0) /* yields (uint256_t)1 << 128 */

KVM_RUN /* reg data packed down to 128-bit in vcpu struct */

KVM_GET_ONE_REG(Z0) /* yields 0 even if guest doesn't use SVE */


Since the guest should be treated mostly as a black box, I'm not sure
how big a deal this is.  The guest _might_ have explicitly set those
bits to 0... who are we to say?

Can anyone think of a scenario where effects like this would matter?

Cheers
---Dave
