Return-Path: <SRS0=qtHs=O2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA75C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 15:34:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8518E61154
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 15:34:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8518E61154
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 128674B2AB;
	Wed,  6 Oct 2021 11:34:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PXz513UZVpDu; Wed,  6 Oct 2021 11:34:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 718014B299;
	Wed,  6 Oct 2021 11:34:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 917D84B278
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 11:34:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3ivbDwqYJANV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Oct 2021 11:34:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39D8E4B277
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 11:34:22 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CFD106D;
 Wed,  6 Oct 2021 08:34:21 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E93213F66F;
 Wed,  6 Oct 2021 08:34:20 -0700 (PDT)
Date: Wed, 6 Oct 2021 16:35:55 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Use get_raz_reg() for userspace reads of
 PMSWINC_EL0
Message-ID: <YV3CR0RABZY15kvN@monolith.localdoman>
References: <20210927124911.191729-1-alexandru.elisei@arm.com>
 <20210927124911.191729-3-alexandru.elisei@arm.com>
 <20210930132915.cpfzxdlws2zlou47@gator>
 <YV23b6On4YrW+4en@monolith.localdoman>
 <20211006152302.2tmih2vx5x7xipml@gator.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211006152302.2tmih2vx5x7xipml@gator.home>
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Drew,

On Wed, Oct 06, 2021 at 05:23:02PM +0200, Andrew Jones wrote:
> On Wed, Oct 06, 2021 at 03:49:19PM +0100, Alexandru Elisei wrote:
> > Hi Drew,
> > 
> > Thank you for the review!
> > 
> > On Thu, Sep 30, 2021 at 03:29:15PM +0200, Andrew Jones wrote:
> > > On Mon, Sep 27, 2021 at 01:49:11PM +0100, Alexandru Elisei wrote:
> > > > PMSWINC_EL0 is a write-only register and was initially part of the VCPU
> > > > register state, but was later removed in commit 7a3ba3095a32 ("KVM:
> > > > arm64: Remove PMSWINC_EL0 shadow register"). To prevent regressions, the
> > > > register was kept accessible from userspace as Read-As-Zero (RAZ).
> > > > 
> > > > The read function that is used to handle userspace reads of this
> > > > register is get_raz_id_reg(), which, while technically correct, as it
> > > > returns 0, it is not semantically correct, as PMSWINC_EL0 is not an ID
> > > > register as the function name suggests.
> > > > 
> > > > Add a new function, get_raz_reg(), to use it as the accessor for
> > > > PMSWINC_EL0, as to not conflate get_raz_id_reg() to handle other types
> > > > of registers.
> > > > 
> > > > No functional change intended.
> > > > 
> > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > ---
> > > >  arch/arm64/kvm/sys_regs.c | 11 ++++++++++-
> > > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > > index 4adda8bf3168..1be827740f87 100644
> > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > @@ -1285,6 +1285,15 @@ static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > > >  	return __set_id_reg(vcpu, rd, uaddr, true);
> > > >  }
> > > >  
> > > > +static int get_raz_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > > > +		       const struct kvm_one_reg *reg, void __user *uaddr)
> > > > +{
> > > > +	const u64 id = sys_reg_to_index(rd);
> > > > +	const u64 val = 0;
> > > > +
> > > > +	return reg_to_user(uaddr, &val, id);
> > > > +}
> > > > +
> > > >  static int set_wi_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > > >  		      const struct kvm_one_reg *reg, void __user *uaddr)
> > > >  {
> > > > @@ -1647,7 +1656,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> > > >  	 * previously (and pointlessly) advertised in the past...
> > > >  	 */
> > > >  	{ PMU_SYS_REG(SYS_PMSWINC_EL0),
> > > > -	  .get_user = get_raz_id_reg, .set_user = set_wi_reg,
> > > > +	  .get_user = get_raz_reg, .set_user = set_wi_reg,
> > > >  	  .access = access_pmswinc, .reset = NULL },
> > > >  	{ PMU_SYS_REG(SYS_PMSELR_EL0),
> > > >  	  .access = access_pmselr, .reset = reset_pmselr, .reg = PMSELR_EL0 },
> > > > -- 
> > > > 2.33.0
> > > >
> > > 
> > > What about replacing get_raz_id_reg() with this new function? Do really need
> > > both?
> > 
> > I thought about that when writing this patch. I ultimately decided against it
> > because changing the get_user accessor to be get_raz_reg() instead of
> > get_raz_id_reg() would break the symmetry with set_user, which needs to stay
> > set_raz_id_reg(), and cannot be substituted with set_wi_reg() because that would
> > be a change in behaviour (set_raz_id_reg() checks that val == 0, set_wi_reg()
> > doesn't).
> > 
> > I do agree that get_raz_id_reg() does the exact same thing as get_raz_reg(), but
> > in a more roundabout manner. So if you still feel that I should use
> > get_raz_reg() instead, I'll do that for the next iteration of the series. What
> > do you think?
> 
> I'd prefer we avoid maintaining two implementations of the same
> functionality. If we want to keep the symmetry with set_raz_id_reg,
> then we could implement get_raz_id_reg as 'return get_raz_reg()'.

Agreed, I'll replace get_raz_id_reg() with get_raz_reg().

Thanks,
Alex

> 
> Thanks,
> drew
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
