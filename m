From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 08/16] KVM: arm64: Support dynamically hideable
 system registers
Date: Wed, 25 Jul 2018 15:36:14 +0100
Message-ID: <20180725143613.GM4240@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-9-git-send-email-Dave.Martin@arm.com>
 <878t5ztneo.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 211BC4065F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 10:36:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qEEHF8hWN86B for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 10:36:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5FC24045F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 10:36:18 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <878t5ztneo.fsf@linaro.org>
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

On Wed, Jul 25, 2018 at 03:12:15PM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > Some system registers may or may not logically exist for a vcpu
> > depending on whether certain architectural features are enabled for
> > the vcpu.
> >
> > In order to avoid spuriously emulating access to these registers
> > when they should not exist, or allowing the registers to be
> > spuriously enumerated or saved/restored through the ioctl
> > interface, a means is needed to allow registers to be hidden
> > depending on the vcpu configuration.
> >
> > In order to support this in a flexible way, this patch adds a
> > check_present() method to struct sys_reg_desc, and updates the
> > generic system register access and enumeration code to be aware of
> > it:  if check_present() returns false, the code behaves as if the
> > register did not exist.
> >
> > For convenience, the complete check is wrapped up in a new helper
> > sys_reg_present().
> >
> > An attempt has been made to hook the new check into the generic
> > accessors for trapped system registers.  This should reduce the
> > potential for future surprises, although the redundant check will
> > add a small cost.  No system register depends on this functionality
> > yet, and some paths needing the check may also need attention.
> >
> > Naturally, this facility makes sense only for registers that are
> > trapped.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 20 +++++++++++++++-----
> >  arch/arm64/kvm/sys_regs.h | 11 +++++++++++
> >  2 files changed, 26 insertions(+), 5 deletions(-)

[...]

> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index cd710f8..dfbb342 100644
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -22,6 +22,9 @@
> >  #ifndef __ARM64_KVM_SYS_REGS_LOCAL_H__
> >  #define __ARM64_KVM_SYS_REGS_LOCAL_H__
> >
> > +#include <linux/compiler.h>
> > +#include <linux/types.h>
> =

> I can see why you want compiler.h, but why types.h?

For bool (though it felt a bit pedantic).

Cheers
---Dave
