From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 18/26] KVM: arm64/sve: Add SVE support to register
 access ioctl interface
Date: Fri, 1 Mar 2019 14:45:55 +0000
Message-ID: <20190301144555.GH3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-19-git-send-email-Dave.Martin@arm.com>
 <f6d9f731-e9f8-a54d-1165-2b188e22b4df@arm.com>
 <20190226121336.GS3567@e103592.cambridge.arm.com>
 <9d0aa022-200c-460f-fc4d-771a5232ae23@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <9d0aa022-200c-460f-fc4d-771a5232ae23@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Julien Thierry <julien.thierry@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 01, 2019 at 01:03:36PM +0000, Julien Thierry wrote:
> 
> 
> On 26/02/2019 12:13, Dave Martin wrote:
> > On Thu, Feb 21, 2019 at 03:23:37PM +0000, Julien Thierry wrote:
> >> Hi Dave,
> >>
> >> On 18/02/2019 19:52, Dave Martin wrote:
> >>> This patch adds the following registers for access via the
> >>> KVM_{GET,SET}_ONE_REG interface:
> >>>
> >>>  * KVM_REG_ARM64_SVE_ZREG(n, i) (n = 0..31) (in 2048-bit slices)
> >>>  * KVM_REG_ARM64_SVE_PREG(n, i) (n = 0..15) (in 256-bit slices)
> >>>  * KVM_REG_ARM64_SVE_FFR(i) (in 256-bit slices)
> >>>
> >>> In order to adapt gracefully to future architectural extensions,
> >>> the registers are logically divided up into slices as noted above:
> >>> the i parameter denotes the slice index.
> >>>
> >>> This allows us to reserve space in the ABI for future expansion of
> >>> these registers.  However, as of today the architecture does not
> >>> permit registers to be larger than a single slice, so no code is
> >>> needed in the kernel to expose additional slices, for now.  The
> >>> code can be extended later as needed to expose them up to a maximum
> >>> of 32 slices (as carved out in the architecture itself) if they
> >>> really exist someday.
> >>>
> >>> The registers are only visible for vcpus that have SVE enabled.
> >>> They are not enumerated by KVM_GET_REG_LIST on vcpus that do not
> >>> have SVE.
> >>>
> >>> Accesses to the FPSIMD registers via KVM_REG_ARM_CORE is not
> >>> allowed for SVE-enabled vcpus: SVE-aware userspace can use the
> >>> KVM_REG_ARM64_SVE_ZREG() interface instead to access the same
> >>> register state.  This avoids some complex and pointless emulation
> >>> in the kernel to convert between the two views of these aliased
> >>> registers.
> >>>
> >>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

[...]

> >>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> >>> index f491456..8cfa889 100644
> >>> --- a/arch/arm64/kvm/guest.c
> >>> +++ b/arch/arm64/kvm/guest.c

[...]

> >>> +struct sve_state_region {
> >>
> >> This sve_state_region feels a bit too generic too me.
> >>
> >> So far it is only used to access a single (slice of a) register at a
> >> time. Is there a plan to use it for more?
> > 
> > It's there as a way to factor out security-sensitive range computations
> > that we otherwise have to do twice -- I'd rather have the (potential)
> > bugs in one place.  sve_state is particularly awkward because it is
> > heterogeneous, with variably sized members for which no C declaration
> > is avaiable (or possible).
> > 
> > Previously it was used in four places, because I tried to emulate the
> > VFP get/set functions for SVE vcpus.  Now that functionality has been
> > dropped I agree that this function looks like a bit like overkill.  But
> > I didn't come up with a good way to split it without duplicating an
> > undesirable amount of fiddly logic.
> > 
> > "sve_state" in the name comes from the naming of the kernel field(s)
> > that this computes ranges on: vcpu->arch.sve_state (and thread->
> > sve_state, which we don't operate on here, but which has the same
> > format).
> > 
> > So, this struct describes a slice of "sve_state", hence the name.  But
> > you're right, it is only ever supposed to span a single SVE register
> > within there.
> > 
> >> Otherwise I'd suggest at least naming it something like sve_reg_region,
> >> sve_reg_mem_region or sve_reg_mem_desc.
> > 
> > It used to be called struct kreg_region.  The name "sve_state_region"
> > was an attempt to make it look less generic, which doesn't appear to
> > have worked too well.
> > 
> > Maybe "sve_state_reg_region" would narrow the apparent scope of this a
> > little further.
> > 
> > Thoughts?
> > 
> 
> Yes, I think that the name fits better. That + the comment you suggested
> would set things clear.
> 
> > I'll take a look, and at least add a comment explaining what this
> > struct is supposed to represent.
> > 
> 
> Yes, that might prevent people looking into to much possibilities of its
> usage.

OK, both done.

Cheers
---Dave
