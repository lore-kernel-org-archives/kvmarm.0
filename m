Return-Path: <SRS0=XNJw=ST=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A20BC282DA
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 14:01:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5A76206BA
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 14:01:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5A76206BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 440894A520;
	Wed, 17 Apr 2019 10:01:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G1XyBFV-yueW; Wed, 17 Apr 2019 10:01:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5A094A506;
	Wed, 17 Apr 2019 10:01:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1B754A506
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 10:01:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id focfkhc9-4qZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Apr 2019 10:01:39 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 576694A4FB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 10:01:39 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5546374;
 Wed, 17 Apr 2019 07:01:38 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B56FF3F557;
 Wed, 17 Apr 2019 07:01:36 -0700 (PDT)
Date: Wed, 17 Apr 2019 15:01:34 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 09/14] KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS
 array sizing
Message-ID: <20190417140134.GA3567@e103592.cambridge.arm.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
 <1555086498-26691-10-git-send-email-Dave.Martin@arm.com>
 <20190415152037.d4ewqbxw7fbbbo3b@kamzik.brq.redhat.com>
 <20190416124142.GO3567@e103592.cambridge.arm.com>
 <20190416130054.6kv3tmpejnyrdart@kamzik.brq.redhat.com>
 <20190416141054.GR3567@e103592.cambridge.arm.com>
 <20190416142831.pmcctqrphquouq3z@kamzik.brq.redhat.com>
 <20190416155228.GT3567@e103592.cambridge.arm.com>
 <20190417041656.spoe62ztefhguf3y@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190417041656.spoe62ztefhguf3y@kamzik.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190417140134.BUKu488eKJjJRo3OKvm7skvVO0_J0AynFZGFif_sF14@z>

On Wed, Apr 17, 2019 at 06:16:56AM +0200, Andrew Jones wrote:
> On Tue, Apr 16, 2019 at 04:52:28PM +0100, Dave Martin wrote:
> > On Tue, Apr 16, 2019 at 04:28:31PM +0200, Andrew Jones wrote:
> > > On Tue, Apr 16, 2019 at 03:10:55PM +0100, Dave Martin wrote:
> > 
> > [...]
> > 
> > > > arch/arm64/include/uapi/asm/kvm.h:
> > > > 
> > > > #include <asm/sve_context.h> /* which we already have anyway */
> > > > 
> > > > #define KVM_ARM64_SVE_VQ_MAX __SVE_VQ_MAX
> > > > #define KVM_ARM64_SVE_VQ_MIN __SVE_VQ_MIN
> > > > 
> > > > /* Vector lengths pseudo-register: */
> > > > #define KVM_REG_ARM64_SVE_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
> > > > 					 KVM_REG_SIZE_U512 | 0xffff)
> > > > #define KVM_ARM64_SVE_VLS_WORDS	\
> > > > 	((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
> > > > 
> > > > 
> > > > Then document as follows:
> > > > Documentation/virtual/kvm/api.txt:
> > > > 
> > > > __u64 vector_lengths[KVM_ARM64_SVE_VLS_WORDS];
> > > > 
> > > > if (vq >= KVM_ARM64_SVE_VQ_MIN && vq <= KVM_ARM64_SVE_VQ_MAX)
> > > >     (vector_lengths[(vq - KVM_ARM64_SVE_VQ_MIN) / 64] >>
> > > > 		((vq - KVM_ARM64_SVE_VQ_MIN) % 64)) & 1)
> > > > 	/* Vector length vq * 16 bytes supported */
> > > > else
> > > > 	/* Vector length vq * 16 bytes not supported */
> > > > 
> > > > 
> > > > Does that work for you?
> > > > 
> > > > Doing things this way avoids people having to include <asm/sigcontext.h>
> > > > (and the consequent clashes with glibc headers).
> > > >
> > > 
> > > I like that.
> > 
> > OK, are you happy with the following on top of this patch?
> > 
> > Cheers
> > ---Dave
> > 
> > --8<--
> > 
> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > index 68509de..03df379 100644
> > --- a/Documentation/virtual/kvm/api.txt
> > +++ b/Documentation/virtual/kvm/api.txt
> > @@ -2171,13 +2171,15 @@ and KVM_ARM_VCPU_FINALIZE for more information about this procedure.
> >  KVM_REG_ARM64_SVE_VLS is a pseudo-register that allows the set of vector
> >  lengths supported by the vcpu to be discovered and configured by
> >  userspace.  When transferred to or from user memory via KVM_GET_ONE_REG
> > -or KVM_SET_ONE_REG, the value of this register is of type __u64[8], and
> > -encodes the set of vector lengths as follows:
> > +or KVM_SET_ONE_REG, the value of this register is of type
> > +__u64[KVM_ARM64_SVE_VLS_WORDS], and encodes the set of vector lengths as
> > +follows:
> >  
> > -__u64 vector_lengths[8];
> > +__u64 vector_lengths[KVM_ARM64_SVE_VLS_WORDS];
> >  
> >  if (vq >= SVE_VQ_MIN && vq <= SVE_VQ_MAX &&
> > -    ((vector_lengths[(vq - 1) / 64] >> ((vq - 1) % 64)) & 1))
> > +    ((vector_lengths[(vq - KVM_ARM64_SVE_VQ_MIN) / 64] >>
> > +		((vq - KVM_ARM64_SVE_VQ_MIN) % 64)) & 1))
> >  	/* Vector length vq * 16 bytes supported */
> >  else
> >  	/* Vector length vq * 16 bytes not supported */
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index 2a04ef0..edd2db8 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -258,9 +258,14 @@ struct kvm_vcpu_events {
> >  	 KVM_REG_SIZE_U256 |						\
> >  	 ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
> >  
> > +#define KVM_ARM64_SVE_VQ_MIN __SVE_VQ_MIN
> > +#define KVM_ARM64_SVE_VQ_MAX __SVE_VQ_MAX
> > +
> >  /* Vector lengths pseudo-register: */
> >  #define KVM_REG_ARM64_SVE_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
> >  					 KVM_REG_SIZE_U512 | 0xffff)
> > +#define KVM_ARM64_SVE_VLS_WORDS	\
> > +	((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
> >  
> >  /* Device Control API: ARM VGIC */
> >  #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index f025a2f..5bb909c 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -208,10 +208,8 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
> >  #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
> >  
> > -#define SVE_VLS_WORDS (vq_word(SVE_VQ_MAX) + 1)
> > -
> >  static bool vq_present(
> > -	const u64 (*const vqs)[SVE_VLS_WORDS],
> > +	const u64 (*const vqs)[KVM_ARM64_SVE_VLS_WORDS],
> >  	unsigned int vq)
> >  {
> >  	return (*vqs)[vq_word(vq)] & vq_mask(vq);
> > @@ -220,7 +218,7 @@ static bool vq_present(
> >  static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> >  	unsigned int max_vq, vq;
> > -	u64 vqs[SVE_VLS_WORDS];
> > +	u64 vqs[KVM_ARM64_SVE_VLS_WORDS];
> >  
> >  	if (!vcpu_has_sve(vcpu))
> >  		return -ENOENT;
> > @@ -244,7 +242,7 @@ static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> >  	unsigned int max_vq, vq;
> > -	u64 vqs[SVE_VLS_WORDS];
> > +	u64 vqs[KVM_ARM64_SVE_VLS_WORDS];
> >  
> >  	if (!vcpu_has_sve(vcpu))
> >  		return -ENOENT;
> >
> 
> Yup
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>

OK, thanks
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
