From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 19/27] KVM: arm64: Enumerate SVE register indices for
 KVM_GET_REG_LIST
Date: Fri, 5 Apr 2019 12:11:15 +0100
Message-ID: <20190405111115.GX3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-20-git-send-email-Dave.Martin@arm.com>
 <20190404140832.5ryfi35df5skg4ke@kamzik.brq.redhat.com>
 <20190405093545.GK3567@e103592.cambridge.arm.com>
 <20190405094556.6hp24jkjcrfnirsb@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E01674A36C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 07:11:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CmFEJPP9Fch1 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Apr 2019 07:11:20 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9D854A331
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 07:11:20 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190405094556.6hp24jkjcrfnirsb@kamzik.brq.redhat.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 05, 2019 at 11:45:56AM +0200, Andrew Jones wrote:
> On Fri, Apr 05, 2019 at 10:35:45AM +0100, Dave Martin wrote:
> > On Thu, Apr 04, 2019 at 04:08:32PM +0200, Andrew Jones wrote:
> > > On Fri, Mar 29, 2019 at 01:00:44PM +0000, Dave Martin wrote:
> > > > This patch includes the SVE register IDs in the list returned by
> > > > KVM_GET_REG_LIST, as appropriate.
> > > > 
> > > > On a non-SVE-enabled vcpu, no new IDs are added.
> > > > 
> > > > On an SVE-enabled vcpu, IDs for the FPSIMD V-registers are removed
> > > > from the list, since userspace is required to access the Z-
> > > > registers instead in order to access the V-register content.  For
> > > > the variably-sized SVE registers, the appropriate set of slice IDs
> > > > are enumerated, depending on the maximum vector length for the
> > > > vcpu.
> > > > 
> > > > As it currently stands, the SVE architecture never requires more
> > > > than one slice to exist per register, so this patch adds no
> > > > explicit support for enumerating multiple slices.  The code can be
> > > > extended straightforwardly to support this in the future, if
> > > > needed.
> > > > 
> > > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > > Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> > > > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> > > > 
> > > > ---

[...]

> > > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c

[...]

> > > > +static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
> > > > +				u64 __user *uindices)
> > > > +{
> > > > +	/* Only the first slice ever exists, for now */

[...]

> > > > +	const unsigned int slices = vcpu_sve_slices(vcpu);
> > > > +	u64 reg;
> > > > +	unsigned int i, n;
> > > > +	int num_regs = 0;
> > > > +
> > > > +	if (!vcpu_has_sve(vcpu))
> > > > +		return 0;
> > > > +
> > > > +	for (i = 0; i < slices; i++) {
> > > > +		for (n = 0; n < SVE_NUM_ZREGS; n++) {
> > > > +			reg = KVM_REG_ARM64_SVE_ZREG(n, i);
> > > > +			if (put_user(reg, uindices++))
> > > > +				return -EFAULT;
> > > > +
> > > > +			num_regs++;
> > > > +		}
> > > > +
> > > > +		for (n = 0; n < SVE_NUM_PREGS; n++) {
> > > > +			reg = KVM_REG_ARM64_SVE_PREG(n, i);
> > > > +			if (put_user(reg, uindices++))
> > > > +				return -EFAULT;
> > > > +
> > > > +			num_regs++;
> > > > +		}
> > > > +
> > > > +		reg = KVM_REG_ARM64_SVE_FFR(i);
> > > > +		if (put_user(reg, uindices++))
> > > > +			return -EFAULT;
> > > > +
> > > > +		num_regs++;
> > > > +	}
> > > 
> > > nit: the extra blank lines above the num_regs++'s give the code an odd
> > >      look (to me)
> > 
> > There's no guaranteed fall-through onto the increments: the blank line
> > was there to highlight the fact that we may jump out using a return
> > instead.
> > 
> > But I'm happy enough to change it if you have a strong preference or
> > you feel the code is equally clear without.
> 
> It's just a nit, so I don't have a strong preference :)

OK, well given that you mentioned it and there are other tweaks to make
on top of this patch anyway, I'll go ahead and make the change.

This saves a few lines, if nothing else.

Cheers
---Dave
