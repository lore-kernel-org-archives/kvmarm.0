Return-Path: <SRS0=JhHZ=SS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D786C10F13
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 13:01:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D0F1E20868
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 13:01:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0F1E20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B5794A4C6;
	Tue, 16 Apr 2019 09:01:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z9Xrc8jkkBd0; Tue, 16 Apr 2019 09:01:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34EE94A501;
	Tue, 16 Apr 2019 09:01:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 825C44A4CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 09:01:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ivj+IiU+LZbO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Apr 2019 09:01:13 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 504FA4A4C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 09:01:13 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id C1958300413F;
 Tue, 16 Apr 2019 13:01:05 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 64820608A4;
 Tue, 16 Apr 2019 13:00:57 +0000 (UTC)
Date: Tue, 16 Apr 2019 15:00:54 +0200
From: Andrew Jones <drjones@redhat.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 09/14] KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS
 array sizing
Message-ID: <20190416130054.6kv3tmpejnyrdart@kamzik.brq.redhat.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
 <1555086498-26691-10-git-send-email-Dave.Martin@arm.com>
 <20190415152037.d4ewqbxw7fbbbo3b@kamzik.brq.redhat.com>
 <20190416124142.GO3567@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190416124142.GO3567@e103592.cambridge.arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.46]); Tue, 16 Apr 2019 13:01:12 +0000 (UTC)
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
Message-ID: <20190416130054.z9yMj3xhJU0GiSfTnDiifSKkIs3Y1wlX7uNYhECB38o@z>

On Tue, Apr 16, 2019 at 01:41:42PM +0100, Dave Martin wrote:
> On Mon, Apr 15, 2019 at 05:20:37PM +0200, Andrew Jones wrote:
> > On Fri, Apr 12, 2019 at 05:28:13PM +0100, Dave Martin wrote:
> > > A complicated DIV_ROUND_UP() expression is currently written out
> > > explicitly in multiple places in order to specify the size of the
> > > bitmap exchanged with userspace to represent the value of the
> > > KVM_REG_ARM64_SVE_VLS pseudo-register.
> > > 
> > > To make this more readable, this patch replaces these with a single
> > > define.
> > > 
> > > Since the number of words in a bitmap is just the index of the last
> > > word used + 1, this patch expresses the bound that way instead.
> > > This should make it clearer what is being expressed.
> > > 
> > > Since use of DIV_ROUND_UP() was the only reason for including
> > > <linux/kernel.h> in guest.c, this patch removes that #include.
> > > 
> > > No functional change.
> > > 
> > > Suggested-by: Andrew Jones <drjones@redhat.com>
> > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > ---
> > >  arch/arm64/kvm/guest.c | 9 +++++----
> > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > index 73044e3..f025a2f 100644
> > > --- a/arch/arm64/kvm/guest.c
> > > +++ b/arch/arm64/kvm/guest.c
> > > @@ -23,7 +23,6 @@
> > >  #include <linux/errno.h>
> > >  #include <linux/err.h>
> > >  #include <linux/nospec.h>
> > > -#include <linux/kernel.h>
> > >  #include <linux/kvm_host.h>
> > >  #include <linux/module.h>
> > >  #include <linux/stddef.h>
> > > @@ -209,8 +208,10 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > >  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
> > >  #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
> > >  
> > > +#define SVE_VLS_WORDS (vq_word(SVE_VQ_MAX) + 1)
> > > +
> > >  static bool vq_present(
> > > -	const u64 (*const vqs)[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)],
> > > +	const u64 (*const vqs)[SVE_VLS_WORDS],
> > >  	unsigned int vq)
> > >  {
> > >  	return (*vqs)[vq_word(vq)] & vq_mask(vq);
> > > @@ -219,7 +220,7 @@ static bool vq_present(
> > >  static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > >  {
> > >  	unsigned int max_vq, vq;
> > > -	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
> > > +	u64 vqs[SVE_VLS_WORDS];
> > >  
> > >  	if (!vcpu_has_sve(vcpu))
> > >  		return -ENOENT;
> > > @@ -243,7 +244,7 @@ static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > >  static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > >  {
> > >  	unsigned int max_vq, vq;
> > > -	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
> > > +	u64 vqs[SVE_VLS_WORDS];
> > >  
> > >  	if (!vcpu_has_sve(vcpu))
> > >  		return -ENOENT;
> > > -- 
> > > 2.1.4
> > >
> > 
> > This is good, but I wonder if we could define the number of VLS words in
> > the documentation in terms of SVE_VQ_MAX too. Currently it's just the
> > hard coded 8 ("__u64 vector_lengths[8]").
> > 
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> I see your point, but SVE_VQ_MAX isn't really part of the KVM API, so I
> was avoiding it here.

It's not part of the KVM API, but it is uapi (asm/sigcontext.h). I'd
prefer we use it than to encourage KVM userspace to scatter 8's around.

> 
> [8] is at least impossible to misinterpret, even if it's not the most
> self-explanatory option.

It's impossible to misinterpret, but also begs the questions of where
it comes from and if it will always be that way forever and ever.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
