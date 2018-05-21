From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v9 12/16] KVM: arm64: Save host SVE context as appropriate
Date: Mon, 21 May 2018 15:49:05 +0100
Message-ID: <20180521144904.GD13470@e103592.cambridge.arm.com>
References: <1526912237-25308-1-git-send-email-Dave.Martin@arm.com>
 <1526912237-25308-13-git-send-email-Dave.Martin@arm.com>
 <eac5821b-c5e0-90c9-cdd6-73643662d68d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <eac5821b-c5e0-90c9-cdd6-73643662d68d@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 21, 2018 at 03:40:02PM +0100, Marc Zyngier wrote:
> On 21/05/18 15:17, Dave Martin wrote:
> > This patch adds SVE context saving to the hyp FPSIMD context switch
> > path.  This means that it is no longer necessary to save the host
> > SVE state in advance of entering the guest, when in use.
> > 
> > In order to avoid adding pointless complexity to the code, VHE is
> > assumed if SVE is in use.  VHE is an architectural prerequisite for
> > SVE, so there is no good reason to turn CONFIG_ARM64_VHE off in
> > kernels that support both SVE and KVM.
> > 
> > Historically, software models exist that can expose the
> > architecturally invalid configuration of SVE without VHE, so if
> > this situation is detected at kvm_init() time then KVM will be
> > disabled.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > 
> > ---
> > 
> >  * Stripped the following tags, reviewers please reconfirm:
> > 
> > Formerly-Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
> > Formerly-Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > Formerly-Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > 
> > (Creation of a new file for this one change may be deemed undesirable,
> > but there didn't seem to be a correct place to put it.  There may also
> > be a way around the circular include problem that I missed.)
> > 
> > Changes since v8:
> > 
> >  * Add kvm_arch_check_supported() hook, and move arm64-specific check
> >    for SVE-implies-VHE into arch/arm64/.
> > 
> >    Due to circular header dependency problems, it is difficult to get
> >    the prototype for kvm_pr_*() functions in <asm/kvm_host.h>, so this
> >    patch puts arm64's kvm_arch_check_supported() hook out of line.
> >    This is not a hot function.
> > ---
> >  arch/arm/include/asm/kvm_host.h   |  1 +
> >  arch/arm64/Kconfig                |  7 +++++++
> >  arch/arm64/include/asm/kvm_host.h |  1 +
> >  arch/arm64/kvm/Makefile           |  2 +-
> >  arch/arm64/kvm/fpsimd.c           |  1 -
> >  arch/arm64/kvm/hyp/switch.c       | 20 +++++++++++++++++++-
> >  arch/arm64/kvm/init.c             | 33 +++++++++++++++++++++++++++++++++
> >  virt/kvm/arm/arm.c                |  6 ++++++
> >  8 files changed, 68 insertions(+), 3 deletions(-)
> >  create mode 100644 arch/arm64/kvm/init.c
> > 

[...]

> > diff --git a/arch/arm64/kvm/init.c b/arch/arm64/kvm/init.c
> > new file mode 100644
> > index 0000000..3b6e730
> > --- /dev/null
> > +++ b/arch/arm64/kvm/init.c
> > @@ -0,0 +1,33 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * arch/arm64/kvm/init.c: KVM initialisation support
> > + *
> > + * Copyright 2018 Arm Limited
> > + * Author: Dave Martin <Dave.Martin@arm.com>
> > + */
> > +#include <linux/errno.h>
> > +#include <linux/kvm_host.h>
> > +#include <asm/cpufeature.h>
> > +#include <asm/kvm_host.h>
> > +
> > +/* Additional arch-dependent checks for KVM usability */
> > +int kvm_arch_check_supported(void)
> > +{
> > +	/*
> > +	 * VHE is a prerequisite for SVE in the Arm architecture, and
> > +	 * Kconfig ensures that if system_supports_sve() here then
> > +	 * CONFIG_ARM64_VHE is enabled, so if VHE support wasn't already
> > +	 * detected and enabled, the CPU is architecturally
> > +	 * noncompliant.
> > +	 *
> > +	 * Just in case this mismatch is seen, detect it, warn and give
> > +	 * up.  Supporting this forbidden configuration in Hyp would be
> > +	 * pointless.
> > +	 */
> > +	if (system_supports_sve() && !has_vhe()) {
> > +		kvm_pr_unimpl("SVE system without VHE unsupported.  Broken cpu?");
> > +		return -ENODEV;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> [entering bikeshedding territory]
> 
> I'm not exactly keen on this. This feels overkill, and a departure from 
> what we've been doing so far.
> 
> Why don't you simply have a helper in kvm_host.h that does:
> 
> static inline bool kvm_arm_check_sve_valid(void)
> {
> 	return !system_supports_sve() || has_vhe();
> }
> 
> (and a canonical "return true;" implementation for 32bit)
> 
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index bee226c..8518df0 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c

[...]

> > @@ -1574,6 +1576,10 @@ int kvm_arch_init(void *opaque)
> >  		return -ENODEV;
> >  	}
> >  
> > +	err = kvm_arch_check_supported();
> > +	if (err)
> > +		return err;
> > +
> 
> And turn this into:
> 
> 	if (!kvm_arm_check_sve_valid()) {
> 		kvm_pr_unimpl("SVE system without VHE unsupported. Broken cpu?");
> 		return -EINVAL;
> 	}
> 
> It has the advantage of being obvious of what we check for, and doesn't 
> add any extra file.

Making the call special-purpose makes it more natural to pull the printk
out of the call, solving the header issues.

This would be a bit gross in core code, but arm.c is supported to be
Arm-specific, so if you prefer this approach it doesn't look too bad
here.

I'm happy to rework along these lines.

Cheers
---Dave
