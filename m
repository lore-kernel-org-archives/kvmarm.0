From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 12/26] KVM: arm64: Support runtime sysreg visibility
 filtering
Date: Tue, 26 Feb 2019 12:12:47 +0000
Message-ID: <20190226121247.GO3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-13-git-send-email-Dave.Martin@arm.com>
 <20190220153726.GF4763@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190220153726.GF4763@lakrids.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 20, 2019 at 03:37:26PM +0000, Mark Rutland wrote:
> On Mon, Feb 18, 2019 at 07:52:25PM +0000, Dave Martin wrote:
> > Some optional features of the Arm architecture add new system
> > registers that are not present in the base architecture.
> > 
> > Where these features are optional for the guest, the visibility of
> > these registers may need to depend on some runtime configuration,
> > such as a flag passed to KVM_ARM_VCPU_INIT.
> > 
> > For example, ZCR_EL1 and ID_AA64ZFR0_EL1 need to be hidden if SVE
> > is not enabled for the guest, even though these registers may be
> > present in the hardware and visible to the host at EL2.
> > 
> > Adding special-case checks all over the place for individual
> > registers is going to get messy as the number of conditionally-
> > visible registers grows.
> > 
> > In order to help solve this problem, this patch adds a new sysreg
> > method restrictions() that can be used to hook in any needed
> > runtime visibility checks.  This method can currently return
> > REG_NO_USER to inhibit enumeration and ioctl access to the register
> > for userspace, and REG_NO_GUEST to inhibit runtime access by the
> > guest using MSR/MRS.
> > 
> > This allows a conditionally modified view of individual system
> > registers such as the CPU ID registers, in addition to completely
> > hiding register where appropriate.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > 
> > ---
> > 
> > Changes since v4:
> > 
> >  * Move from a boolean sysreg property that just suppresses register
> >    enumeration via KVM_GET_REG_LIST, to a multi-flag property that
> >    allows independent runtime control of MRS/MSR and user ioctl access.
> > 
> >    This allows registers to be either hidden completely, or to have
> >    hybrid behaviours (such as the not-enumerated, RAZ, WAZ behaviour of
> >    "non-present" CPU ID regs).
> 
> Sorry for bikeshedding...
> 
> > +	/* Check for regs disabled by runtime config */
> > +	if (restrictions(vcpu, r) & REG_NO_GUEST) {
> 
> Maybe it's worth wrapping this as something like
> 
> 	reg_runtime_hidden_from_guest(vcpu, r)
> 
> ... and avoid exposing the raw flags to all the places we have to check?
> 
> [...]
> 
> > +#define REG_NO_USER	(1 << 0) /* hidden from userspace ioctl interface */
> > +#define REG_NO_GUEST	(1 << 1) /* hidden from guest */
> 
> Perhaps REG_USER_HIDDEN and REG_GUEST_HIDDEN?

I'm not attached to any particular naming, so I'm not opposed to making
changes similar to those you suggest.

There are some anomalies right now:

1) Currently, we can express REG_NO_GUEST by itself, which is a of an
odd thing to have.  I'm not sure whether that's a problem or not.
Keeping the flags as-is at least keeps the code simple.

2) These flags do not quite have the obvious semantics: these are
overrides rather than determining precisely when a reg is/isn't
accessible.

So, REG_NO_USER means "don't even call this reg's get/set_user(): forbid
user access unconditionally", whereas lack of this flag means "call the
appropriate get/set_user() function to find out what to do, which may
or may not result in forbidding the access".

Maybe this subtlety is just a question of clear commenting.  I can't
think of obviously-correct names that won't be stupidly verbose...

Thoughts?

Cheers
---Dave
