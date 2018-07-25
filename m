From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 15/16] KVM: arm64: Enumerate SVE register indices for
 KVM_GET_REG_LIST
Date: Wed, 25 Jul 2018 15:50:28 +0100
Message-ID: <20180725145027.GP4240@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-16-git-send-email-Dave.Martin@arm.com>
 <20180719141232.hm2vjld5ztfrtter@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C4A49F89
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 10:50:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sDGS3T2Zs9Cv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 10:50:33 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E35C74045F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 10:50:32 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180719141232.hm2vjld5ztfrtter@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 19, 2018 at 04:12:32PM +0200, Andrew Jones wrote:
> On Thu, Jun 21, 2018 at 03:57:39PM +0100, Dave Martin wrote:
> > This patch includes the SVE register IDs in the list returned by
> > KVM_GET_REG_LIST, as appropriate.
> > 
> > On a non-SVE-enabled vcpu, no extra IDs are added.
> > 
> > On an SVE-enabled vcpu, the appropriate number of slide IDs are
> > enumerated for each SVE register, depending on the maximum vector
> > length for the vcpu.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/kvm/guest.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 73 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 005394b..5152362 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -21,6 +21,7 @@
> >  
> >  #include <linux/errno.h>
> >  #include <linux/err.h>
> > +#include <linux/kernel.h>
> >  #include <linux/kvm_host.h>
> >  #include <linux/module.h>
> >  #include <linux/uaccess.h>
> > @@ -253,6 +254,73 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  	return err;
> >  }
> >  
> > +static void copy_reg_index_to_user(u64 __user **uind, int *total, int *cerr,
> > +				   u64 id)
> > +{
> > +	int err;
> > +
> > +	if (*cerr)
> > +		return;
> > +
> > +	if (uind) {
> > +		err = put_user(id, *uind);
> > +		if (err) {
> > +			*cerr = err;
> > +			return;
> > +		}
> > +	}
> > +
> > +	++*total;
> > +	if (uind)
> > +		++*uind;
> > +}
> > +
> > +static int enumerate_sve_regs(const struct kvm_vcpu *vcpu, u64 __user **uind)
> > +{
> > +	unsigned int n, i;
> > +	int err = 0;
> > +	int total = 0;
> > +	unsigned int slices;
> > +
> > +	if (!vcpu_has_sve(&vcpu->arch))
> > +		return 0;
> > +
> > +	slices = DIV_ROUND_UP(vcpu->arch.sve_max_vl,
> > +			      KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0)));
> > +
> > +	for (n = 0; n < SVE_NUM_ZREGS; ++n)
> > +		for (i = 0; i < slices; ++i)
> > +			copy_reg_index_to_user(uind, &total, &err,
> > +					       KVM_REG_ARM64_SVE_ZREG(n, i));
> > +
> > +	for (n = 0; n < SVE_NUM_PREGS; ++n)
> > +		for (i = 0; i < slices; ++i)
> > +			copy_reg_index_to_user(uind, &total, &err,
> > +					       KVM_REG_ARM64_SVE_PREG(n, i));
> > +
> > +	for (i = 0; i < slices; ++i)
> > +		copy_reg_index_to_user(uind, &total, &err,
> > +				       KVM_REG_ARM64_SVE_FFR(i));
> > +
> > +	if (err)
> > +		return -EFAULT;
> > +
> > +	return total;
> > +}
> > +
> > +static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
> > +{
> > +	return enumerate_sve_regs(vcpu, NULL);
> > +}
> > +
> > +static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu, u64 __user **uind)
> > +{
> > +	int err;
> > +
> > +	err = enumerate_sve_regs(vcpu, uind);
> > +	return err < 0 ? err : 0;
> > +}
> 
> I see the above functions were inspired by walk_sys_regs(), but, IMHO,
> they're a bit overcomplicated. How about this untested approach?
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 56a0260ceb11..0188a8b30d46 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -130,6 +130,52 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	return err;
>  }
>  
> +static int enumerate_sve_regs(const struct kvm_vcpu *vcpu, u64 __user *uind)
> +{
> +	unsigned int slices = DIV_ROUND_UP(vcpu->arch.sve_max_vl,
> +				KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0)));
> +	unsigned int n, i;
> +
> +	if (!vcpu_has_sve(&vcpu->arch))
> +		return 0;
> +
> +	for (n = 0; < SVE_NUM_ZREGS; ++n) {
> +		for (i = 0; i < slices; ++i) {
> +			if (put_user(KVM_REG_ARM64_SVE_ZREG(n, i), uind++))
> +				return -EFAULT;
> +		}
> +	}
> +
> +	for (n = 0; < SVE_NUM_PREGS; ++n) {
> +		for (i = 0; i < slices; ++i) {
> +			if (put_user(KVM_REG_ARM64_SVE_PREG(n, i), uind++))
> +				return -EFAULT;
> +		}
> +	}
> +
> +	for (i = 0; i < slices; ++i) {
> +		if (put_user(KVM_REG_ARM64_SVE_FFR(i), uind++))
> +			return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
> +static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
> +{
> +	unsigned int slices = DIV_ROUND_UP(vcpu->arch.sve_max_vl,
> +				KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0)));
> +
> +	if (vcpu_has_sve(&vcpu->arch))
> +		return (SVE_NUM_ZREGS + SVE_NUM_PREGS + 1) * slices;
> +
> +	return 0;
> +}
> +

I sympathise with this, though this loses the nice property that
enumerate_sve_regs() and walk_sve_regs() match by construction.

Your version is simple enough that this is obvious by inspection
though, which is probably good enough.  I'll consider abopting it
when I respin.


In the sysregs case this would be much harder to achieve.


I would prefer to keep copy_reg_index_to_user() since it is
used in a few places -- but it is basically the same thing as
sys_regs.c:copy_reg_to_user(), so I will take a look a merging
them together.

Cheers
---Dave
