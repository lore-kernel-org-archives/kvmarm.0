Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8285C2D0A3
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 16:37:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3252F2072E
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 16:36:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3252F2072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71FBF4B77D;
	Wed,  4 Nov 2020 11:36:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8If56bXinwdY; Wed,  4 Nov 2020 11:36:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32DB04B793;
	Wed,  4 Nov 2020 11:36:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 461194B760
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 11:36:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iZTrkLASsThH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 11:36:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 951F84B742
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 11:36:55 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B184A139F;
 Wed,  4 Nov 2020 08:36:54 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0BD183F718;
 Wed,  4 Nov 2020 08:36:53 -0800 (PST)
Date: Wed, 4 Nov 2020 16:36:50 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Remove AA64ZFR0_EL1 accessors
Message-ID: <20201104163649.GC6882@arm.com>
References: <20201102185037.49248-1-drjones@redhat.com>
 <20201102185037.49248-4-drjones@redhat.com>
 <20201103113208.GI6882@arm.com>
 <20201103134640.6hs2ggz7sqn5o5me@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201103134640.6hs2ggz7sqn5o5me@kamzik.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: maz@kernel.org, xu910121@sina.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Nov 03, 2020 at 02:46:40PM +0100, Andrew Jones wrote:
> On Tue, Nov 03, 2020 at 11:32:08AM +0000, Dave Martin wrote:
> > On Mon, Nov 02, 2020 at 07:50:37PM +0100, Andrew Jones wrote:
> > > The AA64ZFR0_EL1 accessors are just the general accessors with
> > > its visibility function open-coded. It also skips the if-else
> > > chain in read_id_reg, but there's no reason not to go there.
> > > Indeed consolidating ID register accessors and removing lines
> > > of code make it worthwhile.
> > > 
> > > No functional change intended.
> > 
> > Nit: No statement of what the patch does.
> 
> I can duplicate the summary in the commit message?

Generally, yes, though there is the opportunity to restore the missing
words and make a proper sentence out of it.  See my response to patch 2.

> > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > ---
> > >  arch/arm64/kvm/sys_regs.c | 61 +++++++--------------------------------
> > >  1 file changed, 11 insertions(+), 50 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index b8822a20b1ea..e2d6fb83280e 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -1156,6 +1156,16 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > >  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> > >  				  const struct sys_reg_desc *r)
> > >  {
> > > +	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
> > > +			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> > > +
> > > +	switch (id) {
> > > +	case SYS_ID_AA64ZFR0_EL1:
> > > +		if (!vcpu_has_sve(vcpu))
> > > +			return REG_RAZ;
> > > +		break;
> > > +	}
> > > +
> > 
> > This should work, but I'm not sure it's preferable to giving affected
> > registers their own visibility check function.
> > 
> > Multiplexing all the ID regs through this one checker function will
> > introduce a bit of overhead for always-non-RAZ ID regs, but I'd guess
> > the impact is negligible given the other overheads on these paths.
> 
> Yes, my though was that a switch isn't going to generate much overhead
> and consolidating the ID registers cleans things up a bit.

Well, no.  I don't have a particularly strong view on this.

The style of the code is being pulled in multiple directions in this
file already, so this doesn't introduce a new inconsistency as such.

If the number of registers handled in here becomes large then we might
want to review the situation again.

> 
> > 
> > >  	return 0;
> > >  }
> > >  
> > > @@ -1203,55 +1213,6 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> > >  	return REG_HIDDEN_USER | REG_HIDDEN_GUEST;
> > >  }
> > >  
> > > -/* Generate the emulated ID_AA64ZFR0_EL1 value exposed to the guest */
> > > -static u64 guest_id_aa64zfr0_el1(const struct kvm_vcpu *vcpu)
> > > -{
> > > -	if (!vcpu_has_sve(vcpu))
> > > -		return 0;
> > > -
> > > -	return read_sanitised_ftr_reg(SYS_ID_AA64ZFR0_EL1);
> > > -}
> > > -
> > > -static bool access_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> > > -				   struct sys_reg_params *p,
> > > -				   const struct sys_reg_desc *rd)
> > > -{
> > > -	if (p->is_write)
> > > -		return write_to_read_only(vcpu, p, rd);
> > > -
> > > -	p->regval = guest_id_aa64zfr0_el1(vcpu);
> > > -	return true;
> > > -}
> > > -
> > > -static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> > > -		const struct sys_reg_desc *rd,
> > > -		const struct kvm_one_reg *reg, void __user *uaddr)
> > > -{
> > > -	u64 val;
> > > -
> > > -	val = guest_id_aa64zfr0_el1(vcpu);
> > > -	return reg_to_user(uaddr, &val, reg->id);
> > > -}
> > > -
> > > -static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> > > -		const struct sys_reg_desc *rd,
> > > -		const struct kvm_one_reg *reg, void __user *uaddr)
> > > -{
> > > -	const u64 id = sys_reg_to_index(rd);
> > > -	int err;
> > > -	u64 val;
> > > -
> > > -	err = reg_from_user(&val, uaddr, id);
> > > -	if (err)
> > > -		return err;
> > > -
> > > -	/* This is what we mean by invariant: you can't change it. */
> > > -	if (val != guest_id_aa64zfr0_el1(vcpu))
> > > -		return -EINVAL;
> > > -
> > > -	return 0;
> > > -}
> > > -
> > >  /*
> > >   * cpufeature ID register user accessors
> > >   *
> > > @@ -1515,7 +1476,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> > >  	ID_SANITISED(ID_AA64PFR1_EL1),
> > >  	ID_UNALLOCATED(4,2),
> > >  	ID_UNALLOCATED(4,3),
> > > -	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, },
> > > +	ID_SANITISED(ID_AA64ZFR0_EL1),
> > 
> > If keeping a dedicated helper, we could have a special macro for that, say
> > 
> > 	ID_SANITISED_VISIBILITY(ID_AA64ZFR0_EL1, id_aa64zfr0_el1_visibility)
> 
> I considered this first, but decided the switch, like read_id_reg's
> if-else chain, is probably not going to introduce much overhead.

Agreed.

I don't have a real problem with this patch in its current form.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
