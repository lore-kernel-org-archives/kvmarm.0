From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 05/23] KVM: arm: Add arch vcpu uninit hook
Date: Thu, 15 Nov 2018 16:40:31 +0000
Message-ID: <20181115164031.GN3505@e103592.cambridge.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-6-git-send-email-Dave.Martin@arm.com>
 <20181102080536.GQ12057@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A06E74A32F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 11:40:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gdc2o9hb3g9g for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Nov 2018 11:40:36 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A8E94A32C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 11:40:36 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181102080536.GQ12057@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 02, 2018 at 09:05:36AM +0100, Christoffer Dall wrote:
> On Fri, Sep 28, 2018 at 02:39:09PM +0100, Dave Martin wrote:
> > In preparation for adding support for SVE in guests on arm64, a
> > hook is needed for freeing additional per-vcpu memory when a vcpu
> > is freed.
> 
> Can this commit motivate why we can't do the work in kvm_arch_vcpu_free,
> which we use for freeing other data structures?
> 
> (Presumably, uninit is needed when you need to do something at the very
> last step after releasing the struct pid.

It wasn't to do with that.

Rather, the division of responsibility between the vcpu_uninit and
vcpu_free paths is not very clear.

In the earlier version of the series, I think SVE state may have been
allocated rather early and we may have needed to free it in the failure
path of kvm_arch_vcpu_create() (which just calls kvm_vcpu_uninit()).
(Alternatively, I may just have been wrong.)

Now, the vcpu must be fully created before the KVM_ARM_SVE_CONFIG ioctl
on it (which is what allocates sve_state) can succeed anyway.

So the distinction between these two teardown phases is probably no
longer important.

I'll see whether I can get rid of this hook and free the SVE state in
kvm_arch_vcpu_free() instead.

Does that make sense?

Cheers
---Dave
