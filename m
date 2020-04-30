Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E7A1C47247
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 13:47:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F00D52082E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 13:46:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRMV7Fau"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F00D52082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CA334B497;
	Thu, 30 Apr 2020 09:46:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QtXMkiGKTaPM; Thu, 30 Apr 2020 09:46:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AEB34B498;
	Thu, 30 Apr 2020 09:46:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF2824B490
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 09:46:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vr+tfhRU4+0S for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 09:46:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D92504B470
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 09:46:55 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6A1732082E;
 Thu, 30 Apr 2020 13:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588254414;
 bh=cIGsayzyQrmoAosJwNbheDRWF4TGcuP/5fJyINZP78U=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=BRMV7FauM4SoitKAPFxH/263TwK51GMEbX2WUTdzhWUPJYlLMMchtTpkp3VX4JOUR
 7ifde/j5zTwb0Zt2UrTSiL0TrRKM9w9fUc4hJ0F5NYKAx1p9Qc9Ah6bCL5S6NGIudW
 7MDW0NUmac55807mzyt0EoogYvL7pcm3ttyAYaNk=
Date: Thu, 30 Apr 2020 14:46:50 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix 32bit PC wrap-around
Message-ID: <20200430134649.GC22842@willie-the-truck>
References: <20200430101513.318541-1-maz@kernel.org>
 <20200430102556.GE19932@willie-the-truck>
 <897baec2a3fad776716bccf3027340fa@kernel.org>
 <20200430123104.GB22842@willie-the-truck>
 <1c0175a09a90d2b7c0243e5bcec7cc9a@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1c0175a09a90d2b7c0243e5bcec7cc9a@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Apr 30, 2020 at 01:45:51PM +0100, Marc Zyngier wrote:
> On 2020-04-30 13:31, Will Deacon wrote:
> > On Thu, Apr 30, 2020 at 11:59:05AM +0100, Marc Zyngier wrote:
> > > On 2020-04-30 11:25, Will Deacon wrote:
> > > > On Thu, Apr 30, 2020 at 11:15:13AM +0100, Marc Zyngier wrote:
> > > > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > > > index 23ebe51410f0..2a159af82429 100644
> > > > > --- a/arch/arm64/kvm/guest.c
> > > > > +++ b/arch/arm64/kvm/guest.c
> > > > > @@ -200,6 +200,10 @@ static int set_core_reg(struct kvm_vcpu *vcpu,
> > > > > const struct kvm_one_reg *reg)
> > > > >  	}
> > > > >
> > > > >  	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
> > > > > +
> > > > > +	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK)
> > > > > +		*vcpu_pc(vcpu) = lower_32_bits(*vcpu_pc(vcpu));
> > > >
> > > > It seems slightly odd to me that we don't enforce this for *all* the
> > > > registers when running as a 32-bit guest. Couldn't userspace be equally
> > > > confused by a 64-bit lr or sp?
> > > 
> > > Fair point. How about this on top, which wipes the upper 32 bits for
> > > each and every register in the current mode:
> > > 
> > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > index 2a159af82429..f958c3c7bf65 100644
> > > --- a/arch/arm64/kvm/guest.c
> > > +++ b/arch/arm64/kvm/guest.c
> > > @@ -201,9 +201,12 @@ static int set_core_reg(struct kvm_vcpu *vcpu,
> > > const
> > > struct kvm_one_reg *reg)
> > > 
> > >  	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
> > > 
> > > -	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK)
> > > -		*vcpu_pc(vcpu) = lower_32_bits(*vcpu_pc(vcpu));
> > > +	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK) {
> > > +		int i;
> > > 
> > > +		for (i = 0; i < 16; i++)
> > > +			*vcpu_reg32(vcpu, i) = (u32)*vcpu_reg32(vcpu, i);
> > 
> > I think you're missing all the funny banked registers that live all the
> > way
> > up to x30 iirc.
> 
> No, they are all indirected via vcpu_reg32(), which has the magic tables.
> And the whole point is that we only want to affect the current mode (no
> point
> in repainting the FIQ registers if the PSR says USR).
> 
> Or am I missing something obvious?

Nope, just my inability to parse vcpu_reg32 the first time around! So, for
the updated patch:

Acked-by: Will Deacon <will@kernel.org?

Thanks,

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
