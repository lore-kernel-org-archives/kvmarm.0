Return-Path: <SRS0=Iiz7=EJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73055C388F7
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 13:46:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AEB272224E
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 13:46:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gXrGL53+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEB272224E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11FC94B31F;
	Tue,  3 Nov 2020 08:46:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pOi07ELssY91; Tue,  3 Nov 2020 08:46:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF9FE4B331;
	Tue,  3 Nov 2020 08:46:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D6154B331
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 08:46:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LHsiuYiSIZuU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2020 08:46:49 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 026354B31F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 08:46:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604411208;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=kTs14Xym6qqhUThJs1aUn8FR8dS3GYer8009tR8qEx0=;
 b=gXrGL53+wTc1QfA0JFt9y+Nw8iQklpPXIDXhJ4Nb3wTtOF21aNmD87krMEzTvOAynBygvH
 r0alL/ayzAbo85Rs+l2s732kMpNssFp/y5REZHZ4ycsqfi2QU1HHd2417UTrwSmTmdnivm
 t96+/zRzdHXMlDlhMNkBwmA3TiI26PY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-4uQNEYKCP7i1gDBacYLPIg-1; Tue, 03 Nov 2020 08:46:47 -0500
X-MC-Unique: 4uQNEYKCP7i1gDBacYLPIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53E9ECE642;
 Tue,  3 Nov 2020 13:46:45 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.252])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DDC915B4C7;
 Tue,  3 Nov 2020 13:46:43 +0000 (UTC)
Date: Tue, 3 Nov 2020 14:46:40 +0100
From: Andrew Jones <drjones@redhat.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Remove AA64ZFR0_EL1 accessors
Message-ID: <20201103134640.6hs2ggz7sqn5o5me@kamzik.brq.redhat.com>
References: <20201102185037.49248-1-drjones@redhat.com>
 <20201102185037.49248-4-drjones@redhat.com>
 <20201103113208.GI6882@arm.com>
MIME-Version: 1.0
In-Reply-To: <20201103113208.GI6882@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

On Tue, Nov 03, 2020 at 11:32:08AM +0000, Dave Martin wrote:
> On Mon, Nov 02, 2020 at 07:50:37PM +0100, Andrew Jones wrote:
> > The AA64ZFR0_EL1 accessors are just the general accessors with
> > its visibility function open-coded. It also skips the if-else
> > chain in read_id_reg, but there's no reason not to go there.
> > Indeed consolidating ID register accessors and removing lines
> > of code make it worthwhile.
> > 
> > No functional change intended.
> 
> Nit: No statement of what the patch does.

I can duplicate the summary in the commit message?

> 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 61 +++++++--------------------------------
> >  1 file changed, 11 insertions(+), 50 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index b8822a20b1ea..e2d6fb83280e 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1156,6 +1156,16 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> >  				  const struct sys_reg_desc *r)
> >  {
> > +	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
> > +			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> > +
> > +	switch (id) {
> > +	case SYS_ID_AA64ZFR0_EL1:
> > +		if (!vcpu_has_sve(vcpu))
> > +			return REG_RAZ;
> > +		break;
> > +	}
> > +
> 
> This should work, but I'm not sure it's preferable to giving affected
> registers their own visibility check function.
> 
> Multiplexing all the ID regs through this one checker function will
> introduce a bit of overhead for always-non-RAZ ID regs, but I'd guess
> the impact is negligible given the other overheads on these paths.

Yes, my though was that a switch isn't going to generate much overhead
and consolidating the ID registers cleans things up a bit.

> 
> >  	return 0;
> >  }
> >  
> > @@ -1203,55 +1213,6 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> >  	return REG_HIDDEN_USER | REG_HIDDEN_GUEST;
> >  }
> >  
> > -/* Generate the emulated ID_AA64ZFR0_EL1 value exposed to the guest */
> > -static u64 guest_id_aa64zfr0_el1(const struct kvm_vcpu *vcpu)
> > -{
> > -	if (!vcpu_has_sve(vcpu))
> > -		return 0;
> > -
> > -	return read_sanitised_ftr_reg(SYS_ID_AA64ZFR0_EL1);
> > -}
> > -
> > -static bool access_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> > -				   struct sys_reg_params *p,
> > -				   const struct sys_reg_desc *rd)
> > -{
> > -	if (p->is_write)
> > -		return write_to_read_only(vcpu, p, rd);
> > -
> > -	p->regval = guest_id_aa64zfr0_el1(vcpu);
> > -	return true;
> > -}
> > -
> > -static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> > -		const struct sys_reg_desc *rd,
> > -		const struct kvm_one_reg *reg, void __user *uaddr)
> > -{
> > -	u64 val;
> > -
> > -	val = guest_id_aa64zfr0_el1(vcpu);
> > -	return reg_to_user(uaddr, &val, reg->id);
> > -}
> > -
> > -static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> > -		const struct sys_reg_desc *rd,
> > -		const struct kvm_one_reg *reg, void __user *uaddr)
> > -{
> > -	const u64 id = sys_reg_to_index(rd);
> > -	int err;
> > -	u64 val;
> > -
> > -	err = reg_from_user(&val, uaddr, id);
> > -	if (err)
> > -		return err;
> > -
> > -	/* This is what we mean by invariant: you can't change it. */
> > -	if (val != guest_id_aa64zfr0_el1(vcpu))
> > -		return -EINVAL;
> > -
> > -	return 0;
> > -}
> > -
> >  /*
> >   * cpufeature ID register user accessors
> >   *
> > @@ -1515,7 +1476,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> >  	ID_SANITISED(ID_AA64PFR1_EL1),
> >  	ID_UNALLOCATED(4,2),
> >  	ID_UNALLOCATED(4,3),
> > -	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, },
> > +	ID_SANITISED(ID_AA64ZFR0_EL1),
> 
> If keeping a dedicated helper, we could have a special macro for that, say
> 
> 	ID_SANITISED_VISIBILITY(ID_AA64ZFR0_EL1, id_aa64zfr0_el1_visibility)

I considered this first, but decided the switch, like read_id_reg's
if-else chain, is probably not going to introduce much overhead.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
