From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [RFC PATCH v2 20/23] KVM: arm64: Add arch vm ioctl hook
Date: Tue, 20 Nov 2018 11:58:52 +0100
Message-ID: <20181120105852.GJ3835@e113682-lin.lund.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-21-git-send-email-Dave.Martin@arm.com>
 <20181102083227.GU12057@e113682-lin.lund.arm.com>
 <20181115180421.GS3505@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D77AC4A312
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Nov 2018 05:58:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eU2G6gt5trSk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Nov 2018 05:58:55 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91B654A2E8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Nov 2018 05:58:55 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181115180421.GS3505@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 15, 2018 at 06:04:22PM +0000, Dave Martin wrote:
> On Fri, Nov 02, 2018 at 09:32:27AM +0100, Christoffer Dall wrote:
> > On Fri, Sep 28, 2018 at 02:39:24PM +0100, Dave Martin wrote:
> > > To enable arm64-specific vm ioctls to be added cleanly, this patch
> > > adds a kvm_arm_arch_vm_ioctl() hook so that these don't pollute the
> > > common code.
> > 
> > Hmmm, I don't really see the strenght of that argument, and have the
> > same concern as before.  I'd like to avoid the additional indirection
> > and instead just follow the existing pattern with a dummy implementation
> > on the 32-bit side that returns an error.
> 
> So for this and the similar comment on patch 18, this was premature (or
> at least, overzealous) factoring on my part.
> 
> I'm happy to merge this back together for arm and arm64 as you prefer.
> 
> Do we have a nice way of writing the arch check, e.g.
> 
> 	case KVM_ARM_SVE_CONFIG:
> 		if (!IS_ENABLED(ARM64))
> 			return -EINVAL;
> 		else
> 			return kvm_vcpu_sve_config(NULL, userp);
> 
> should work, but looks a bit strange.  Maybe I'm just being fussy.

I prefer just doing:

	case KVM_ARM_SVE_CONFIG:
		return kvm_vcpu_sve_config(NULL, userp);


And having this in arch/arm/include/asm/kvm_foo.h:

static inline int kvm_vcpu_sve_config(...)
{
	return -EINVAL;
}


Thanks,

    Christoffer
