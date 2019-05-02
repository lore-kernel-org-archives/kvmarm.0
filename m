From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] KVM: arm64: fix ptrauth ID register masking logic
Date: Thu, 2 May 2019 09:53:23 +0100
Message-ID: <20190502085322.GN3567@e103592.cambridge.arm.com>
References: <20190501161008.31498-1-kristina.martsenko@arm.com>
 <5dbccc2a-655b-00d4-a168-e9ff60a455a7@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD5694A4DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 May 2019 04:53:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dg26VDMBDec8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 May 2019 04:53:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A07A4A4D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 May 2019 04:53:28 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <5dbccc2a-655b-00d4-a168-e9ff60a455a7@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, Amit Kachhap <amit.kachhap@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 01, 2019 at 05:20:49PM +0100, Marc Zyngier wrote:
> On 01/05/2019 17:10, Kristina Martsenko wrote:
> > When a VCPU doesn't have pointer auth, we want to hide all four pointer
> > auth ID register fields from the guest, not just one of them.
> > 
> > Fixes: 384b40caa8af ("KVM: arm/arm64: Context-switch ptrauth registers")
> > Reported-by: Andrew Murray <andrew.murray@arm.com>
> > Fsck-up-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 9d02643bc601..857b226bcdde 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1088,10 +1088,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >  	if (id == SYS_ID_AA64PFR0_EL1 && !vcpu_has_sve(vcpu)) {
> >  		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> >  	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
> > -		val &= ~(0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> > -			(0xfUL << ID_AA64ISAR1_API_SHIFT) |
> > -			(0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> > -			(0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> > +		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> > +			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> > +			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> > +			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
> >  	}
> >  
> >  	return val;
> > 
> 
> Applied and pushed to -next. Thanks Andrew for reporting it, and
> Kristina for putting me right!

I was worried this was my mistake... but it looks like my original
suggstion did have the extra ().

Anyway, FWIW,

Acked-by: Dave Martin <Dave.Martin@arm.com>
