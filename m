Return-Path: <SRS0=4/V8=2D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D017C43603
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 10:56:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0D4B02073D
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 10:56:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D4B02073D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99ED14A4F6;
	Fri, 13 Dec 2019 05:56:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id es1a9HwtGgEG; Fri, 13 Dec 2019 05:56:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 312384A65C;
	Fri, 13 Dec 2019 05:56:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 457244A54B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 05:56:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J5BaZ-YYdYit for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Dec 2019 05:56:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C55744A4F6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 05:56:49 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E41C1FB;
 Fri, 13 Dec 2019 02:56:49 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E69B03F718;
 Fri, 13 Dec 2019 02:56:48 -0800 (PST)
Date: Fri, 13 Dec 2019 11:56:47 +0100
From: Christoffer Dall <christoffer.dall@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Only sign-extend MMIO up to register width
Message-ID: <20191213105647.GH28840@e113682-lin.lund.arm.com>
References: <20191212195055.5541-1-christoffer.dall@arm.com>
 <92df358b3261598b587f95a2aa4d9bc5@www.loen.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <92df358b3261598b587f95a2aa4d9bc5@www.loen.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: djordje.kovacevic@arm.com, linux-arm-kernel@lists.infradead.org,
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

On Fri, Dec 13, 2019 at 10:12:19AM +0000, Marc Zyngier wrote:
> On 2019-12-12 19:50, Christoffer Dall wrote:
> > On AArch64 you can do a sign-extended load to either a 32-bit or 64-bit
> > register, and we should only sign extend the register up to the width of
> > the register as specified in the operation (by using the 32-bit Wn or
> > 64-bit Xn register specifier).
> 
> Nice catch. It's only been there for... Oh wait! ;-)
> 
> > 
> > As it turns out, the architecture provides this decoding information in
> > the SF ("Sixty-Four" -- how cute...) bit.
> > 
> > Let's take advantage of this with the usual 32-bit/64-bit header file
> > dance and do the right thing on AArch64 hosts.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> 
> Cc: stable?
> 

Yes, good idea.

> > ---
> >  arch/arm/include/asm/kvm_emulate.h   | 5 +++++
> >  arch/arm/include/asm/kvm_mmio.h      | 2 ++
> >  arch/arm64/include/asm/kvm_emulate.h | 5 +++++
> >  arch/arm64/include/asm/kvm_mmio.h    | 6 ++----
> >  virt/kvm/arm/mmio.c                  | 8 +++++++-
> >  5 files changed, 21 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_emulate.h
> > b/arch/arm/include/asm/kvm_emulate.h
> > index 9b118516d2db..fe55d8737a11 100644
> > --- a/arch/arm/include/asm/kvm_emulate.h
> > +++ b/arch/arm/include/asm/kvm_emulate.h
> > @@ -182,6 +182,11 @@ static inline bool kvm_vcpu_dabt_issext(struct
> > kvm_vcpu *vcpu)
> >  	return kvm_vcpu_get_hsr(vcpu) & HSR_SSE;
> >  }
> > 
> > +static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu *vcpu)
> > +{
> > +	return false;
> > +}
> > +
> >  static inline int kvm_vcpu_dabt_get_rd(struct kvm_vcpu *vcpu)
> >  {
> >  	return (kvm_vcpu_get_hsr(vcpu) & HSR_SRT_MASK) >> HSR_SRT_SHIFT;
> > diff --git a/arch/arm/include/asm/kvm_mmio.h
> > b/arch/arm/include/asm/kvm_mmio.h
> > index 7c0eddb0adb2..32fbf82e3ebc 100644
> > --- a/arch/arm/include/asm/kvm_mmio.h
> > +++ b/arch/arm/include/asm/kvm_mmio.h
> > @@ -14,6 +14,8 @@
> >  struct kvm_decode {
> >  	unsigned long rt;
> >  	bool sign_extend;
> > +	/* Not used on 32-bit arm */
> > +	bool sixty_four;
> >  };
> > 
> >  void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long
> > data);
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h
> > b/arch/arm64/include/asm/kvm_emulate.h
> > index 5efe5ca8fecf..f407b6bdad2e 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -283,6 +283,11 @@ static inline bool kvm_vcpu_dabt_issext(const
> > struct kvm_vcpu *vcpu)
> >  	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SSE);
> >  }
> > 
> > +static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu *vcpu)
> > +{
> > +	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SF);
> > +}
> > +
> >  static inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
> >  {
> >  	return (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SRT_MASK) >>
> > ESR_ELx_SRT_SHIFT;
> > diff --git a/arch/arm64/include/asm/kvm_mmio.h
> > b/arch/arm64/include/asm/kvm_mmio.h
> > index 02b5c48fd467..b204501a0c39 100644
> > --- a/arch/arm64/include/asm/kvm_mmio.h
> > +++ b/arch/arm64/include/asm/kvm_mmio.h
> > @@ -10,13 +10,11 @@
> >  #include <linux/kvm_host.h>
> >  #include <asm/kvm_arm.h>
> > 
> > -/*
> > - * This is annoying. The mmio code requires this, even if we don't
> > - * need any decoding. To be fixed.
> > - */
> >  struct kvm_decode {
> >  	unsigned long rt;
> >  	bool sign_extend;
> > +	/* Witdth of the register accessed by the faulting instruction is
> > 64-bits */
> > +	bool sixty_four;
> >  };
> > 
> >  void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long
> > data);
> > diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
> > index 70d3b449692c..e62454b2e529 100644
> > --- a/virt/kvm/arm/mmio.c
> > +++ b/virt/kvm/arm/mmio.c
> > @@ -83,7 +83,7 @@ unsigned long kvm_mmio_read_buf(const void *buf,
> > unsigned int len)
> >  int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  {
> >  	unsigned long data;
> > -	unsigned int len;
> > +	unsigned int len, regsize;
> 
> Unused variable?
> 

Ah, yes, whoops.  Guess which unstaged change I still have in my tree...

> >  	int mask;
> > 
> >  	/* Detect an already handled MMIO return */
> > @@ -105,6 +105,9 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu,
> > struct kvm_run *run)
> >  			data = (data ^ mask) - mask;
> >  		}
> > 
> > +		if (!vcpu->arch.mmio_decode.sixty_four)
> > +			data = data & 0xffffffff;
> > +
> >  		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
> >  			       &data);
> >  		data = vcpu_data_host_to_guest(vcpu, data, len);
> > @@ -125,6 +128,7 @@ static int decode_hsr(struct kvm_vcpu *vcpu, bool
> > *is_write, int *len)
> >  	unsigned long rt;
> >  	int access_size;
> >  	bool sign_extend;
> > +	bool sixty_four;
> > 
> >  	if (kvm_vcpu_dabt_iss1tw(vcpu)) {
> >  		/* page table accesses IO mem: tell guest to fix its TTBR */
> > @@ -138,11 +142,13 @@ static int decode_hsr(struct kvm_vcpu *vcpu,
> > bool *is_write, int *len)
> > 
> >  	*is_write = kvm_vcpu_dabt_iswrite(vcpu);
> >  	sign_extend = kvm_vcpu_dabt_issext(vcpu);
> > +	sixty_four = kvm_vcpu_dabt_issf(vcpu);
> >  	rt = kvm_vcpu_dabt_get_rd(vcpu);
> > 
> >  	*len = access_size;
> >  	vcpu->arch.mmio_decode.sign_extend = sign_extend;
> >  	vcpu->arch.mmio_decode.rt = rt;
> > +	vcpu->arch.mmio_decode.sixty_four = sixty_four;
> > 
> >  	return 0;
> >  }
> 
> I can't remember why we keep this mmio_decode structure as part of
> the vcpu. It isn't like it is going to change anytime soon (userspace
> cannot change the saved ESR_EL2)...

I think that was just an uninformed design decision on my part and it
could be reworked to operate on the ESR_EL2 directly or just take the
information from userspace (which we already rely on for read vs.
write).

> 
> Anyway, your patch is in keeping with the current shape of the code.
> If you're OK with, it, I'll apply it with the above nits addressed.
> 

Absolutely, I decided not to rework the mmio_decode stuff, and leave
that for some later day.


Thanks!

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
