From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 14/23] KVM: Allow 2048-bit register access via
 ioctl interface
Date: Mon, 19 Nov 2018 17:07:27 +0000
Message-ID: <20181119170727.GY3505@e103592.cambridge.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-15-git-send-email-Dave.Martin@arm.com>
 <87r2fhhv2z.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B00184A2FE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Nov 2018 12:07:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fYICUH3PIMdJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Nov 2018 12:07:32 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F754A0C9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Nov 2018 12:07:32 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <87r2fhhv2z.fsf@linaro.org>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 19, 2018 at 04:48:36PM +0000, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > The Arm SVE architecture defines registers that are up to 2048 bits
> > in size (with some possibility of further future expansion).
> >
> > In order to avoid the need for an excessively large number of
> > ioctls when saving and restoring a vcpu's registers, this patch
> > adds a #define to make support for individual 2048-bit registers
> > through the KVM_{GET,SET}_ONE_REG ioctl interface official.  This
> > will allow each SVE register to be accessed in a single call.
> >
> > There are sufficient spare bits in the register id size field for
> > this change, so there is no ABI impact providing that
> > KVM_GET_REG_LIST does not enumerate any 2048-bit register unless
> > userspace explicitly opts in to the relevant architecture-specific
> > features.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  include/uapi/linux/kvm.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 251be35..7c3c5cc 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1110,6 +1110,7 @@ struct kvm_dirty_tlb {
> >  #define KVM_REG_SIZE_U256	0x0050000000000000ULL
> >  #define KVM_REG_SIZE_U512	0x0060000000000000ULL
> >  #define KVM_REG_SIZE_U1024	0x0070000000000000ULL
> > +#define KVM_REG_SIZE_U2048	0x0080000000000000ULL
> =

> Yeah OK I guess - but it does make me question if KVM_REG_SIZE_MASK is
> part of the ABI because although we have space for another few bits that
> is the last one without changing the mask.

Debatable, but KVM_REG_SIZE_MASK is UAPI and suggests a clear intent not
to recycle bit 55 for another purpose.  This allows for reg sizes up to
262144 bits which is hopefully more than enough for the foreseeable
future.

Even if bits 56-59 are currently always 0, KVM_REG_ARCH_MASK suggests
that these bits aren't going to be used for size field bits.


Or am I missing something?

> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Thanks
---Dave
