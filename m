From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Filter out invalid core register IDs
 in KVM_GET_REG_LIST
Date: Thu, 13 Dec 2018 19:11:45 +0000
Message-ID: <20181213191144.GD3505@e103592.cambridge.arm.com>
References: <1544645824-16461-1-git-send-email-Dave.Martin@arm.com>
 <1544645824-16461-2-git-send-email-Dave.Martin@arm.com>
 <20181213183038.GC3505@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181213183038.GC3505@e103592.cambridge.arm.com>
Sender: stable-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 13, 2018 at 06:30:39PM +0000, Dave Martin wrote:
> On Wed, Dec 12, 2018 at 08:17:03PM +0000, Dave Martin wrote:
> > Since commit d26c25a9d19b ("arm64: KVM: Tighten guest core register
> > access from userspace"), KVM_{GET,SET}_ONE_REG rejects register IDs
> > that do not correspond to a single underlying architectural register.
> > 
> > KVM_GET_REG_LIST was not changed to match however: instead, it
> > simply yields a list of 32-bit register IDs that together cover the
> > whole kvm_regs struct.  This means that if userspace tries to use
> > the resulting list of IDs directly to drive calls to KVM_*_ONE_REG,
> > some of those calls will now fail.
> > 
> > This was not the intention.  Instead, iterating KVM_*_ONE_REG over
> > the list of IDs returned by KVM_GET_REG_LIST should be guaranteed
> > to work.
> > 
> > This patch fixes the problem by splitting validate_core_reg_id()
> > into a backend core_reg_size_from_offset() which does all of the
> > work except for checking that the size field in the register ID
> > matches, and kvm_arm_copy_reg_indices() and num_core_regs() are
> > converted to use this to enumerate the valid offsets.
> > 
> > kvm_arm_copy_reg_indices() now also sets the register ID size field
> > appropriately based on the value returned, so the register ID
> > supplied to userspace is fully qualified for use with the register
> > access ioctls.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: d26c25a9d19b ("arm64: KVM: Tighten guest core register access from userspace")
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 
> Tested now with [1], which obtains the reg list with KVM_GET_REG_LIST
> and then tries to read each register listed.
> 
> (Comparing v4.19 with a patches v4.20-rc5 was a bit lazy here, but there
> is no reason to suppose the results would be different.)
> 
> 
> This confirms both the exactly expected bug behaviour and the fix.
> 
> 
> I have not yet checked what qemu does with the KVM_GET_REG_LIST data.

Further to this, qemu seems only to use the non-KVM_REG_ARM_CORE
registers from the KVM_GET_REG_LIST output, and uses its own built-in
knowledge to enumerate the core regs (since that is a fixed set anyway).

qemu already explicitly marks core regs with the correct size (32-/64-
or 128-bit) when doing KVM_GET_ONE_REG/KVM_SET_ONE_REG.  So it shouldn't
be affected by this patch.

[...]

Cheers
---Dave
