Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9887C2D0A3
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 16:31:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 29802206DB
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 16:31:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29802206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C4FB4B7D0;
	Wed,  4 Nov 2020 11:31:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MC8gAaBbnz9b; Wed,  4 Nov 2020 11:31:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21F894B75F;
	Wed,  4 Nov 2020 11:31:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6223D4B76F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 11:31:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CLCa51x3T998 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 11:31:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E04134B75F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 11:31:12 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F76A139F;
 Wed,  4 Nov 2020 08:31:12 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF3F93F718;
 Wed,  4 Nov 2020 08:31:11 -0800 (PST)
Date: Wed, 4 Nov 2020 16:31:08 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Check RAZ visibility in ID register
 accessors
Message-ID: <20201104163107.GB6882@arm.com>
References: <20201102185037.49248-1-drjones@redhat.com>
 <20201102185037.49248-3-drjones@redhat.com>
 <20201103112354.GH6882@arm.com>
 <20201103133836.q2laxsosxevpkvgq@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201103133836.q2laxsosxevpkvgq@kamzik.brq.redhat.com>
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

On Tue, Nov 03, 2020 at 02:38:36PM +0100, Andrew Jones wrote:
> On Tue, Nov 03, 2020 at 11:23:54AM +0000, Dave Martin wrote:
> > On Mon, Nov 02, 2020 at 07:50:36PM +0100, Andrew Jones wrote:
> > > The instruction encodings of ID registers are preallocated. Until an
> > > encoding is assigned a purpose the register is RAZ. KVM's general ID
> > > register accessor functions already support both paths, RAZ or not.
> > > If for each ID register we can determine if it's RAZ or not, then all
> > > ID registers can build on the general functions. The register visibility
> > > function allows us to check whether a register should be completely
> > > hidden or not, extending it to also report when the register should
> > > be RAZ or not allows us to use it for ID registers as well.
> > 
> > Nit: no statement of what the patch does.
> 
> Hmm, I'm not sure what "...extending it to also report when the register
> should be RAZ or not allows us to use it for ID registers as well." is
> missing, other than spelling out that a new flag is being added for the
> extension. Please provide a suggestion.

Well, that's a subordinate clause, not a statement.  The containing
sentence is a statement about the _implications_ of doing it, but
nothing says that it is actually done.

Often, a less condensed repeat of the subject line is enough, say,
something like the following, as a separate paragraph at the end:

	Check for RAZ visibility in the ID register accessor functions.

(Or rather, there should be a concise statement in the commit message
saying what the patch does, and the subject line should be a suitably
condensed version of _that_.)

You might want to add a simple statement of what is achieved:

	This allows the RAZ case to be handled in a generic way
	for all system registers.

That makes the intention and value of the patch easy to spot, while the
wordy paragraph is available for anyone who wants to understand the
background and rationale in more detail.

(This is just my view, but I think it's generally helpful to reviewers
to follow this rough pattern -- it makes it easy to skip non-critical
parts of the description and come back to them later on.  I might
propose edits in submitting-patches.rst to make this clearer -- and if
they are shot down in flames then I will shut up ;)

> 
> > 
> > You might want to point out that the introduced REG_RAZ functionality is
> > intentionally not used in this patch.
> 
> OK
> 
> > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > ---
> > >  arch/arm64/kvm/sys_regs.c | 19 ++++++++++++++++---
> > >  arch/arm64/kvm/sys_regs.h | 10 ++++++++++
> > >  2 files changed, 26 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 6ff0c15531ca..b8822a20b1ea 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -1153,6 +1153,12 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > >  	return val;
> > >  }
> > >  
> > > +static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> > > +				  const struct sys_reg_desc *r)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > >  /* cpufeature ID register access trap handlers */
> > >  
> > >  static bool __access_id_reg(struct kvm_vcpu *vcpu,
> > > @@ -1171,7 +1177,9 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
> > >  			  struct sys_reg_params *p,
> > >  			  const struct sys_reg_desc *r)
> > >  {
> > > -	return __access_id_reg(vcpu, p, r, false);
> > > +	bool raz = sysreg_visible_as_raz(vcpu, r);
> > > +
> > > +	return __access_id_reg(vcpu, p, r, raz);
> > >  }
> > >  
> > >  static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
> > > @@ -1283,13 +1291,17 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
> > >  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > >  		      const struct kvm_one_reg *reg, void __user *uaddr)
> > >  {
> > > -	return __get_id_reg(vcpu, rd, uaddr, false);
> > > +	bool raz = sysreg_visible_as_raz(vcpu, rd);
> > > +
> > > +	return __get_id_reg(vcpu, rd, uaddr, raz);
> > >  }
> > >  
> > >  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > >  		      const struct kvm_one_reg *reg, void __user *uaddr)
> > >  {
> > > -	return __set_id_reg(vcpu, rd, uaddr, false);
> > > +	bool raz = sysreg_visible_as_raz(vcpu, rd);
> > > +
> > > +	return __set_id_reg(vcpu, rd, uaddr, raz);
> > >  }
> > >  
> > >  static int get_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > > @@ -1381,6 +1393,7 @@ static bool access_mte_regs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> > >  	.access	= access_id_reg,		\
> > >  	.get_user = get_id_reg,			\
> > >  	.set_user = set_id_reg,			\
> > > +	.visibility = id_visibility,		\
> > 
> > This is just the default for ID_SANITISED, right?
> 
> The default was not to have a visibility function. Now it has one. It
> still behaves the same way in this patch, though, because it just returns
> zero.

Ack.

Don't worry about this; again, I was halfway through remembering how the
code in this file worked...

[...]

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
