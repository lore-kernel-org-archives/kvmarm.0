From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 12/27] KVM: arm64/sve: System register context switch
 and access support
Date: Thu, 4 Apr 2019 09:47:36 +0100
Message-ID: <20190404084735.GB3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-13-git-send-email-Dave.Martin@arm.com>
 <20190403193943.nv7s36yf2nkzvzwo@kamzik.brq.redhat.com>
 <20190404080658.GX3567@e103592.cambridge.arm.com>
 <20190404083218.7mpl4hp4tbbcql7b@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 733C14A420
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 04:47:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nO-NfHEi+jc1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 04:47:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E1284A36D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 04:47:41 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190404083218.7mpl4hp4tbbcql7b@kamzik.brq.redhat.com>
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

On Thu, Apr 04, 2019 at 10:32:18AM +0200, Andrew Jones wrote:
> On Thu, Apr 04, 2019 at 09:06:58AM +0100, Dave Martin wrote:
> > On Wed, Apr 03, 2019 at 09:39:43PM +0200, Andrew Jones wrote:
> > > On Fri, Mar 29, 2019 at 01:00:37PM +0000, Dave Martin wrote:

[...]

> > > > +static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> > > > +		const struct sys_reg_desc *rd,
> > > > +		const struct kvm_one_reg *reg, void __user *uaddr)
> > > > +{
> > > > +	u64 val;
> > > > +
> > > > +	if (!vcpu_has_sve(vcpu))
> > > > +		return -ENOENT;
> > > 
> > > This shouldn't be necessary. The visibility check in
> > > kvm_arm_sys_reg_get_reg already covers it.
> > > 
> > > > +
> > > > +	val = guest_id_aa64zfr0_el1(vcpu);
> > > > +	return reg_to_user(uaddr, &val, reg->id);
> > > > +}
> > > > +
> > > > +static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> > > > +		const struct sys_reg_desc *rd,
> > > > +		const struct kvm_one_reg *reg, void __user *uaddr)
> > > > +{
> > > > +	const u64 id = sys_reg_to_index(rd);
> > > > +	int err;
> > > > +	u64 val;
> > > > +
> > > > +	if (!vcpu_has_sve(vcpu))
> > > > +		return -ENOENT;
> > > 
> > > Also not necessary.
> > 
> > Hmm, true.  Because the logic is a bit spread out I felt uneasy with
> > simply deleting these checks, but if they fire, something has
> > definitely gone wrong elsewhere.
> > 
> > In its current form the code makes it look like it could be legitimate
> > to get here with !vcpu_has_sve(vcpu), which is misleading.
> > 
> > What if we demote these to WARN_ON()?  This isn't a fast path.
> 
> A WARN_ON sounds good to me.

OK.  Are you happy to give your Reviewed-by on the following?

--8<--

>From 88aeb182ba787102e627e33728a08b70f467758c Mon Sep 17 00:00:00 2001
From: Dave Martin <Dave.Martin@arm.com>
Date: Thu, 4 Apr 2019 09:41:46 +0100
Subject: [PATCH] KVM: arm64/sve: Demote redundant sysreg vcpu_has_sve() checks
 to WARNs

Because of the logic in kvm_arm_sys_reg_{get,set}_reg() and
sve_id_visibility(), we should never call
{get,set}_id_aa64zfr0_el1() for a vcpu where !vcpu_has_sve(vcpu).

To avoid the code giving the impression that it is valid for these
functions to be called in this situation, and to help the compiler
make the right optimisation decisions, this patch adds WARN_ON()
for these cases.

Given the way the logic is spread out, this seems preferable to
dropping the checks altogether.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 09e9b06..7046c76 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1144,7 +1144,7 @@ static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u64 val;
 
-	if (!vcpu_has_sve(vcpu))
+	if (WARN_ON(!vcpu_has_sve(vcpu)))
 		return -ENOENT;
 
 	val = guest_id_aa64zfr0_el1(vcpu);
@@ -1159,7 +1159,7 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
 	int err;
 	u64 val;
 
-	if (!vcpu_has_sve(vcpu))
+	if (WARN_ON(!vcpu_has_sve(vcpu)))
 		return -ENOENT;
 
 	err = reg_from_user(&val, uaddr, id);
-- 
2.1.4
