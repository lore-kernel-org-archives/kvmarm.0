Return-Path: <SRS0=JhHZ=SS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B9BC10F13
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 15:36:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C4B520872
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 15:36:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C4B520872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC6A84A4C6;
	Tue, 16 Apr 2019 11:36:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6p8GA-8RY4Qx; Tue, 16 Apr 2019 11:36:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77CB94A509;
	Tue, 16 Apr 2019 11:36:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8371E4A509
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 11:36:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sm0fEOHdQEB7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Apr 2019 11:36:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D85414A502
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 11:36:07 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1608080D;
 Tue, 16 Apr 2019 08:36:07 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 242443F59C;
 Tue, 16 Apr 2019 08:36:05 -0700 (PDT)
Date: Tue, 16 Apr 2019 16:36:02 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 09/14] KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS
 array sizing
Message-ID: <20190416153600.GS3567@e103592.cambridge.arm.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
 <1555086498-26691-10-git-send-email-Dave.Martin@arm.com>
 <20190415152037.d4ewqbxw7fbbbo3b@kamzik.brq.redhat.com>
 <20190416124142.GO3567@e103592.cambridge.arm.com>
 <20190416130054.6kv3tmpejnyrdart@kamzik.brq.redhat.com>
 <20190416141054.GR3567@e103592.cambridge.arm.com>
 <20190416142831.pmcctqrphquouq3z@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190416142831.pmcctqrphquouq3z@kamzik.brq.redhat.com>
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
Message-ID: <20190416153602.okqENIa_d28XFMr2y8cq_flPUgjLAqu1vskpJf7WOMA@z>

On Tue, Apr 16, 2019 at 04:28:31PM +0200, Andrew Jones wrote:
> On Tue, Apr 16, 2019 at 03:10:55PM +0100, Dave Martin wrote:
> > On Tue, Apr 16, 2019 at 03:00:54PM +0200, Andrew Jones wrote:
> > > On Tue, Apr 16, 2019 at 01:41:42PM +0100, Dave Martin wrote:
> > > > On Mon, Apr 15, 2019 at 05:20:37PM +0200, Andrew Jones wrote:
> > > > > On Fri, Apr 12, 2019 at 05:28:13PM +0100, Dave Martin wrote:
> > > > > > A complicated DIV_ROUND_UP() expression is currently written out
> > > > > > explicitly in multiple places in order to specify the size of the
> > > > > > bitmap exchanged with userspace to represent the value of the
> > > > > > KVM_REG_ARM64_SVE_VLS pseudo-register.
> > > > > > 
> > > > > > To make this more readable, this patch replaces these with a single
> > > > > > define.
> > > > > > 
> > > > > > Since the number of words in a bitmap is just the index of the last
> > > > > > word used + 1, this patch expresses the bound that way instead.
> > > > > > This should make it clearer what is being expressed.
> > > > > > 
> > > > > > Since use of DIV_ROUND_UP() was the only reason for including
> > > > > > <linux/kernel.h> in guest.c, this patch removes that #include.
> > > > > > 
> > > > > > No functional change.
> > > > > > 
> > > > > > Suggested-by: Andrew Jones <drjones@redhat.com>
> > > > > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > > > > ---
> > > > > >  arch/arm64/kvm/guest.c | 9 +++++----
> > > > > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > > > > 
> > > > > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > > > > index 73044e3..f025a2f 100644
> > > > > > --- a/arch/arm64/kvm/guest.c
> > > > > > +++ b/arch/arm64/kvm/guest.c
> > > > > > @@ -23,7 +23,6 @@
> > > > > >  #include <linux/errno.h>
> > > > > >  #include <linux/err.h>
> > > > > >  #include <linux/nospec.h>
> > > > > > -#include <linux/kernel.h>
> > > > > >  #include <linux/kvm_host.h>
> > > > > >  #include <linux/module.h>
> > > > > >  #include <linux/stddef.h>
> > > > > > @@ -209,8 +208,10 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > > > >  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
> > > > > >  #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
> > > > > >  
> > > > > > +#define SVE_VLS_WORDS (vq_word(SVE_VQ_MAX) + 1)
> > > > > > +
> > > > > >  static bool vq_present(
> > > > > > -	const u64 (*const vqs)[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)],
> > > > > > +	const u64 (*const vqs)[SVE_VLS_WORDS],
> > > > > >  	unsigned int vq)
> > > > > >  {
> > > > > >  	return (*vqs)[vq_word(vq)] & vq_mask(vq);
> > > > > > @@ -219,7 +220,7 @@ static bool vq_present(
> > > > > >  static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > > > >  {
> > > > > >  	unsigned int max_vq, vq;
> > > > > > -	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
> > > > > > +	u64 vqs[SVE_VLS_WORDS];
> > > > > >  
> > > > > >  	if (!vcpu_has_sve(vcpu))
> > > > > >  		return -ENOENT;
> > > > > > @@ -243,7 +244,7 @@ static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > > > >  static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > > > >  {
> > > > > >  	unsigned int max_vq, vq;
> > > > > > -	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
> > > > > > +	u64 vqs[SVE_VLS_WORDS];
> > > > > >  
> > > > > >  	if (!vcpu_has_sve(vcpu))
> > > > > >  		return -ENOENT;
> > > > > > -- 
> > > > > > 2.1.4
> > > > > >
> > > > > 
> > > > > This is good, but I wonder if we could define the number of VLS words in
> > > > > the documentation in terms of SVE_VQ_MAX too. Currently it's just the
> > > > > hard coded 8 ("__u64 vector_lengths[8]").
> > > > > 
> > > > > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > > > 
> > > > I see your point, but SVE_VQ_MAX isn't really part of the KVM API, so I
> > > > was avoiding it here.
> > > 
> > > It's not part of the KVM API, but it is uapi (asm/sigcontext.h). I'd
> > > prefer we use it than to encourage KVM userspace to scatter 8's around.
> > > 
> > > > 
> > > > [8] is at least impossible to misinterpret, even if it's not the most
> > > > self-explanatory option.
> > > 
> > > It's impossible to misinterpret, but also begs the questions of where
> > > it comes from and if it will always be that way forever and ever.
> > 
> > It is sized to the maximum that makes sense without a major API
> > redesign, so the expectation is that it will never change (and userspace
> > should assume that it does not).
> > 
> > I sympathise though, since this case is less intuitive than most.
> > 
> > We could add some dedicated defines for this:
> > 
> > arch/arm64/include/uapi/asm/kvm.h:
> > 
> > #include <asm/sve_context.h> /* which we already have anyway */
> > 
> > #define KVM_ARM64_SVE_VQ_MAX __SVE_VQ_MAX
> > #define KVM_ARM64_SVE_VQ_MIN __SVE_VQ_MIN
> > 
> > /* Vector lengths pseudo-register: */
> > #define KVM_REG_ARM64_SVE_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
> > 					 KVM_REG_SIZE_U512 | 0xffff)
> > #define KVM_ARM64_SVE_VLS_WORDS	\
> > 	((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
> > 
> > 
> > Then document as follows:
> > Documentation/virtual/kvm/api.txt:
> > 
> > __u64 vector_lengths[KVM_ARM64_SVE_VLS_WORDS];
> > 
> > if (vq >= KVM_ARM64_SVE_VQ_MIN && vq <= KVM_ARM64_SVE_VQ_MAX)
> >     (vector_lengths[(vq - KVM_ARM64_SVE_VQ_MIN) / 64] >>
> > 		((vq - KVM_ARM64_SVE_VQ_MIN) % 64)) & 1)
> > 	/* Vector length vq * 16 bytes supported */
> > else
> > 	/* Vector length vq * 16 bytes not supported */
> > 
> > 
> > Does that work for you?
> > 
> > Doing things this way avoids people having to include <asm/sigcontext.h>
> > (and the consequent clashes with glibc headers).
> >
> 
> I like that.

OK, I'll do that then.

I was worried this was going to end up too cumbersome / too verbose, but
it doesn't feel too bad in practice.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
