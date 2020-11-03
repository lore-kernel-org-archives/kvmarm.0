Return-Path: <SRS0=Iiz7=EJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BBCC2D0A3
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 13:38:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8CD2C22264
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 13:38:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KWVNkCeo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CD2C22264
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A030B4B385;
	Tue,  3 Nov 2020 08:38:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZwYWYq0TdI78; Tue,  3 Nov 2020 08:38:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BCB74B390;
	Tue,  3 Nov 2020 08:38:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F24AD4B390
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 08:38:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BaNzaFMX+AkO for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2020 08:38:46 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C73C24B385
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 08:38:46 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604410726;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=VXK9ZWiudrulknHM9hQku7vVcbsn8RcYlyIi8Fj1aCM=;
 b=KWVNkCeodnlxWJWtCQDBQHpAZ/9ObKFFdqPygdyyleDv+negjnODxrQNs+19AcnzCXk+xG
 lyAjY8xCHjV9DuGsEPiuon1Iv5CDuBeqd4+0iz3yjp6kPZVNqQ0EyBNW5zctJCw5XZqd4I
 a9lDpSCisok/Eq3ioZ7MsUTkA4JjyWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-e1Xfy7DwNIyYqo-LIaAWcg-1; Tue, 03 Nov 2020 08:38:44 -0500
X-MC-Unique: e1Xfy7DwNIyYqo-LIaAWcg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B7598058A5;
 Tue,  3 Nov 2020 13:38:43 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.252])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACB7973664;
 Tue,  3 Nov 2020 13:38:41 +0000 (UTC)
Date: Tue, 3 Nov 2020 14:38:36 +0100
From: Andrew Jones <drjones@redhat.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Check RAZ visibility in ID register
 accessors
Message-ID: <20201103133836.q2laxsosxevpkvgq@kamzik.brq.redhat.com>
References: <20201102185037.49248-1-drjones@redhat.com>
 <20201102185037.49248-3-drjones@redhat.com>
 <20201103112354.GH6882@arm.com>
MIME-Version: 1.0
In-Reply-To: <20201103112354.GH6882@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Tue, Nov 03, 2020 at 11:23:54AM +0000, Dave Martin wrote:
> On Mon, Nov 02, 2020 at 07:50:36PM +0100, Andrew Jones wrote:
> > The instruction encodings of ID registers are preallocated. Until an
> > encoding is assigned a purpose the register is RAZ. KVM's general ID
> > register accessor functions already support both paths, RAZ or not.
> > If for each ID register we can determine if it's RAZ or not, then all
> > ID registers can build on the general functions. The register visibility
> > function allows us to check whether a register should be completely
> > hidden or not, extending it to also report when the register should
> > be RAZ or not allows us to use it for ID registers as well.
> 
> Nit: no statement of what the patch does.

Hmm, I'm not sure what "...extending it to also report when the register
should be RAZ or not allows us to use it for ID registers as well." is
missing, other than spelling out that a new flag is being added for the
extension. Please provide a suggestion.

> 
> You might want to point out that the introduced REG_RAZ functionality is
> intentionally not used in this patch.

OK

> 
> > No functional change intended.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 19 ++++++++++++++++---
> >  arch/arm64/kvm/sys_regs.h | 10 ++++++++++
> >  2 files changed, 26 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 6ff0c15531ca..b8822a20b1ea 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1153,6 +1153,12 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >  	return val;
> >  }
> >  
> > +static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> > +				  const struct sys_reg_desc *r)
> > +{
> > +	return 0;
> > +}
> > +
> >  /* cpufeature ID register access trap handlers */
> >  
> >  static bool __access_id_reg(struct kvm_vcpu *vcpu,
> > @@ -1171,7 +1177,9 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
> >  			  struct sys_reg_params *p,
> >  			  const struct sys_reg_desc *r)
> >  {
> > -	return __access_id_reg(vcpu, p, r, false);
> > +	bool raz = sysreg_visible_as_raz(vcpu, r);
> > +
> > +	return __access_id_reg(vcpu, p, r, raz);
> >  }
> >  
> >  static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
> > @@ -1283,13 +1291,17 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
> >  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >  		      const struct kvm_one_reg *reg, void __user *uaddr)
> >  {
> > -	return __get_id_reg(vcpu, rd, uaddr, false);
> > +	bool raz = sysreg_visible_as_raz(vcpu, rd);
> > +
> > +	return __get_id_reg(vcpu, rd, uaddr, raz);
> >  }
> >  
> >  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >  		      const struct kvm_one_reg *reg, void __user *uaddr)
> >  {
> > -	return __set_id_reg(vcpu, rd, uaddr, false);
> > +	bool raz = sysreg_visible_as_raz(vcpu, rd);
> > +
> > +	return __set_id_reg(vcpu, rd, uaddr, raz);
> >  }
> >  
> >  static int get_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > @@ -1381,6 +1393,7 @@ static bool access_mte_regs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >  	.access	= access_id_reg,		\
> >  	.get_user = get_id_reg,			\
> >  	.set_user = set_id_reg,			\
> > +	.visibility = id_visibility,		\
> 
> This is just the default for ID_SANITISED, right?

The default was not to have a visibility function. Now it has one. It
still behaves the same way in this patch, though, because it just returns
zero.

> 
> >  }
> >  
> >  /*
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index 5a6fc30f5989..9d3ef7cfa116 100644
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -61,6 +61,7 @@ struct sys_reg_desc {
> >  
> >  #define REG_HIDDEN_USER		(1 << 0) /* hidden from userspace ioctls */
> >  #define REG_HIDDEN_GUEST	(1 << 1) /* hidden from guest */
> > +#define REG_RAZ			(1 << 2) /* RAZ from userspace ioctls and guest */
> >  
> >  static __printf(2, 3)
> >  inline void print_sys_reg_msg(const struct sys_reg_params *p,
> > @@ -129,6 +130,15 @@ static inline bool sysreg_hidden_from_user(const struct kvm_vcpu *vcpu,
> >  	return r->visibility(vcpu, r) & REG_HIDDEN_USER;
> >  }
> >  
> > +static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
> > +					 const struct sys_reg_desc *r)
> > +{
> > +	if (likely(!r->visibility))
> > +		return false;
> > +
> > +	return r->visibility(vcpu, r) & REG_RAZ;
> > +}
> > +
> 
> [...]
> 
> Looks reasonable, I think.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
