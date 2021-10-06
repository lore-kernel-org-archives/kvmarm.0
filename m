Return-Path: <SRS0=qtHs=O2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A02AC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 15:23:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A8A6F61019
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 15:23:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A8A6F61019
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 254824B299;
	Wed,  6 Oct 2021 11:23:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UVLfX78YP28N; Wed,  6 Oct 2021 11:23:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CCE84B272;
	Wed,  6 Oct 2021 11:23:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C0874B299
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 11:23:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FmA0SNx76LfT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Oct 2021 11:23:06 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB4C74B26B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 11:23:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633533786;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=do/pGVSpRPHiB5WgRi+V370Ratl/1NC3np7JtyVCV+Q=;
 b=bDKUPmcw3vc5l0O9E05kg9gWsoGC73tF5Rz7Cy2cvV/eqSKQnCSnN67VdM9NAEG0fU3h8f
 y8PRgP/VH2ZC2mXfp9f/pEqsC9n0WI8UAnxd+2VRLlLjZx3HQHeLH3/fxGMlnIVkHx41As
 jTgi+Jgb2dAWcZkOna77jNCYbmS3fLc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-UjsAFlR1OnaTGaFXXgha_w-1; Wed, 06 Oct 2021 11:23:05 -0400
X-MC-Unique: UjsAFlR1OnaTGaFXXgha_w-1
Received: by mail-ed1-f72.google.com with SMTP id
 r11-20020aa7cfcb000000b003d4fbd652b9so937609edy.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Oct 2021 08:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=do/pGVSpRPHiB5WgRi+V370Ratl/1NC3np7JtyVCV+Q=;
 b=5CbZd2VxvVCx8mZF3FwHbguI6OxFl6IdtLuYQtgFCOH8nDFqPgDH6hUWrSESwoYzBF
 7ctKXizyZ/YxmQzPKzt6rLNFD10IpE5aG5uuF8M47/psNqwE0G+S8+79o9ShCPvN0Ww7
 5kfpo4Gm3ivbNvdahp9zKQIbkjCTvvNFOvoznUzK4jDAsOohSCu6koL6YHyv4IUV/1si
 HP7k1zupVWFCC/MRpndho/gwv7n26n8xj26WcfkFCov3kE2+rETC4kWg1HME9lNwU3nO
 ARZReOzws5aw3+VrBwjuhuVzNCxjzTXaP2CF2GQ4muCnAWHltfUrm1bdltbKHmXZkYbW
 2OiA==
X-Gm-Message-State: AOAM532yldIGh58R9YlArgY4YC9VozvqnrC2tInn+zWwWLZTFcEcihwm
 bvI8XAlKqyS/LvwYMlOdRrkVmI2U8ckPPADd1NsV5VThMFwr66HA2EPU3PIygokoAsu8fzaw7eN
 /SW5tU8pGJsBoOkhll66bibJo
X-Received: by 2002:a17:906:c1c9:: with SMTP id
 bw9mr33802243ejb.3.1633533784118; 
 Wed, 06 Oct 2021 08:23:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZadaY0dpMar3g01TrDtHh0Hj0LQyWy3Z7Ntnk8LG0wWEUy7Z6IzmoVorUMKxZweUnQNieMw==
X-Received: by 2002:a17:906:c1c9:: with SMTP id
 bw9mr33802222ejb.3.1633533783937; 
 Wed, 06 Oct 2021 08:23:03 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id g2sm10186162edp.74.2021.10.06.08.23.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Oct 2021 08:23:03 -0700 (PDT)
Date: Wed, 6 Oct 2021 17:23:02 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Use get_raz_reg() for userspace reads of
 PMSWINC_EL0
Message-ID: <20211006152302.2tmih2vx5x7xipml@gator.home>
References: <20210927124911.191729-1-alexandru.elisei@arm.com>
 <20210927124911.191729-3-alexandru.elisei@arm.com>
 <20210930132915.cpfzxdlws2zlou47@gator>
 <YV23b6On4YrW+4en@monolith.localdoman>
MIME-Version: 1.0
In-Reply-To: <YV23b6On4YrW+4en@monolith.localdoman>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Wed, Oct 06, 2021 at 03:49:19PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> Thank you for the review!
> 
> On Thu, Sep 30, 2021 at 03:29:15PM +0200, Andrew Jones wrote:
> > On Mon, Sep 27, 2021 at 01:49:11PM +0100, Alexandru Elisei wrote:
> > > PMSWINC_EL0 is a write-only register and was initially part of the VCPU
> > > register state, but was later removed in commit 7a3ba3095a32 ("KVM:
> > > arm64: Remove PMSWINC_EL0 shadow register"). To prevent regressions, the
> > > register was kept accessible from userspace as Read-As-Zero (RAZ).
> > > 
> > > The read function that is used to handle userspace reads of this
> > > register is get_raz_id_reg(), which, while technically correct, as it
> > > returns 0, it is not semantically correct, as PMSWINC_EL0 is not an ID
> > > register as the function name suggests.
> > > 
> > > Add a new function, get_raz_reg(), to use it as the accessor for
> > > PMSWINC_EL0, as to not conflate get_raz_id_reg() to handle other types
> > > of registers.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > ---
> > >  arch/arm64/kvm/sys_regs.c | 11 ++++++++++-
> > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 4adda8bf3168..1be827740f87 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -1285,6 +1285,15 @@ static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > >  	return __set_id_reg(vcpu, rd, uaddr, true);
> > >  }
> > >  
> > > +static int get_raz_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > > +		       const struct kvm_one_reg *reg, void __user *uaddr)
> > > +{
> > > +	const u64 id = sys_reg_to_index(rd);
> > > +	const u64 val = 0;
> > > +
> > > +	return reg_to_user(uaddr, &val, id);
> > > +}
> > > +
> > >  static int set_wi_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > >  		      const struct kvm_one_reg *reg, void __user *uaddr)
> > >  {
> > > @@ -1647,7 +1656,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> > >  	 * previously (and pointlessly) advertised in the past...
> > >  	 */
> > >  	{ PMU_SYS_REG(SYS_PMSWINC_EL0),
> > > -	  .get_user = get_raz_id_reg, .set_user = set_wi_reg,
> > > +	  .get_user = get_raz_reg, .set_user = set_wi_reg,
> > >  	  .access = access_pmswinc, .reset = NULL },
> > >  	{ PMU_SYS_REG(SYS_PMSELR_EL0),
> > >  	  .access = access_pmselr, .reset = reset_pmselr, .reg = PMSELR_EL0 },
> > > -- 
> > > 2.33.0
> > >
> > 
> > What about replacing get_raz_id_reg() with this new function? Do really need
> > both?
> 
> I thought about that when writing this patch. I ultimately decided against it
> because changing the get_user accessor to be get_raz_reg() instead of
> get_raz_id_reg() would break the symmetry with set_user, which needs to stay
> set_raz_id_reg(), and cannot be substituted with set_wi_reg() because that would
> be a change in behaviour (set_raz_id_reg() checks that val == 0, set_wi_reg()
> doesn't).
> 
> I do agree that get_raz_id_reg() does the exact same thing as get_raz_reg(), but
> in a more roundabout manner. So if you still feel that I should use
> get_raz_reg() instead, I'll do that for the next iteration of the series. What
> do you think?

I'd prefer we avoid maintaining two implementations of the same
functionality. If we want to keep the symmetry with set_raz_id_reg,
then we could implement get_raz_id_reg as 'return get_raz_reg()'.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
