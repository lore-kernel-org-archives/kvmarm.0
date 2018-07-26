From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 13/16] KVM: Allow 2048-bit register access via
 KVM_{GET, SET}_ONE_REG
Date: Thu, 26 Jul 2018 13:58:35 +0100
Message-ID: <20180726125834.GV4240@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-14-git-send-email-Dave.Martin@arm.com>
 <874lgntihl.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3FA04A0C7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jul 2018 08:58:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aiZ1N4YXJGzf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Jul 2018 08:58:39 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0E3D4045F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jul 2018 08:58:39 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <874lgntihl.fsf@linaro.org>
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

On Wed, Jul 25, 2018 at 04:58:30PM +0100, Alex Benn=E9e wrote:
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
> =

> Does it? It's not in this patch and looking at the final tree:
> =

>   unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
>   {
>           unsigned long res =3D 0;
> =

>           res +=3D num_core_regs();
>           res +=3D num_sve_regs(vcpu);
>           res +=3D kvm_arm_num_sys_reg_descs(vcpu);
>           res +=3D kvm_arm_get_fw_num_regs(vcpu);
>           res +=3D NUM_TIMER_REGS;
> =

>           return res;
>   }
> =

> =

> which leads to:
> =

>   static int enumerate_sve_regs(const struct kvm_vcpu *vcpu, u64 __user *=
*uind)
>   {
>           unsigned int n, i;
>           int err =3D 0;
>           int total =3D 0;
>           unsigned int slices;
> =

>           if (!vcpu_has_sve(&vcpu->arch))
>                   return 0;
> =

> Which enumerates the SVE regs if vcpu_has_sve() which AFAICT is true if
> the host supports it, not if the user has requested it.
> =

> I'll have to check what but given the indirection of kvm_one_reg I
> wonder if existing binaries might end up spamming a badly sized array
> when run on a new SVE supporting kernel?

That shouldn't be the case: vcpu_has_sve() checks for the
KVM_ARM64_GUEST_HAS_SVE flag, which should only be set if userspace asks
for it.

Give me a shout if this doesn't seem to be the case...

Cheers
---Dave
