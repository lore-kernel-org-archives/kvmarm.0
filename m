Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475EEC63697
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 14:36:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76BB52065E
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 14:36:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G4/hlBjA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76BB52065E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA3C14C067;
	Thu, 26 Nov 2020 09:36:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5Zf75tyu0c3Y; Thu, 26 Nov 2020 09:36:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92D3A4C06D;
	Thu, 26 Nov 2020 09:36:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0BE64C066
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 09:36:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RDDkTlCo7cMD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 09:36:43 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12C384BAEF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 09:36:43 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1606401402;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=NrB+lMSLj+Fdrrp2wJGqC8XL5+BZOKP4iK+YINRbCi0=;
 b=G4/hlBjAF5vWoRVOnj/ZgzulWyvwdqpbSs9TS4Ni2sbR7pZZ1L+RHEZKHb4KxN8kEINpko
 eOhJICkwncr+s0FrbQAiLSj9kV+dt+y7X21isTCAjvjDTIEnnzZ/+xi9XVl2aliRhu4tyg
 XIQja/OIWEz/m0HxXBO6S+sM/4S9xLM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-8DsSDpbjNMCvhHgfLNBmTw-1; Thu, 26 Nov 2020 09:36:40 -0500
X-MC-Unique: 8DsSDpbjNMCvhHgfLNBmTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C38341005E61;
 Thu, 26 Nov 2020 14:36:39 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.141])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 525845D6AC;
 Thu, 26 Nov 2020 14:36:38 +0000 (UTC)
Date: Thu, 26 Nov 2020 15:36:35 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/2] KVM: arm64: CSSELR_EL1 max is 13
Message-ID: <20201126143635.hsp6l74fon62p47t@kamzik.brq.redhat.com>
References: <20201126134641.35231-1-drjones@redhat.com>
 <20201126134641.35231-2-drjones@redhat.com>
 <163d00024402dbb518a6f8d669579bfa@kernel.org>
 <20201126143200.eezs474ks3xdlnsl@kamzik.brq.redhat.com>
 <5106d82b42174b86dd62bc9637b2b6a4@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5106d82b42174b86dd62bc9637b2b6a4@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Thu, Nov 26, 2020 at 02:34:05PM +0000, Marc Zyngier wrote:
> On 2020-11-26 14:32, Andrew Jones wrote:
> > On Thu, Nov 26, 2020 at 02:13:44PM +0000, Marc Zyngier wrote:
> > > On 2020-11-26 13:46, Andrew Jones wrote:
> > > > Not counting TnD, which KVM doesn't currently consider, CSSELR_EL1
> > > > can have a maximum value of 0b1101 (13), which corresponds to an
> > > > instruction cache at level 7. With CSSELR_MAX set to 12 we can
> > > > only select up to cache level 6. Change it to 14.
> > > >
> > > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > > ---
> > > >  arch/arm64/kvm/sys_regs.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > > index c1fac9836af1..ef453f7827fa 100644
> > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > @@ -169,7 +169,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64
> > > > val, int reg)
> > > >  static u32 cache_levels;
> > > >
> > > >  /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
> > > > -#define CSSELR_MAX 12
> > > > +#define CSSELR_MAX 14
> > > >
> > > >  /* Which cache CCSIDR represents depends on CSSELR value. */
> > > >  static u32 get_ccsidr(u32 csselr)
> > > 
> > > Huh, nice catch. Do we need a CC: stable tag for this?
> > > 
> > 
> > Hi Marc,
> > 
> > I wasn't thinking so, because I'm not expecting there to actually
> > be hardware with seven cache levels in the wild any time soon. You
> > have more knowledge about what's out there and coming, though, so
> > feel free CC stable if needed.
> 
> That's actually what I was wondering, whether you had seen that in the
> wild already. Since you haven't (and I'm not aware of such a monstrosity),
> I'll queue it for 5.11.
> 
> Do you want me to take the selftest stuff at the same time?
>

Yes, please :)

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
