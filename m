Return-Path: <SRS0=oQwk=VB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6334CC0650E
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jul 2019 08:35:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E4E18218A3
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jul 2019 08:35:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4E18218A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 703214A417;
	Thu,  4 Jul 2019 04:35:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id beBd9o5IP+tQ; Thu,  4 Jul 2019 04:35:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 213E54A4E9;
	Thu,  4 Jul 2019 04:35:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FBD54A417
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jul 2019 04:35:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PKvX+8Q7LgBK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jul 2019 04:35:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AFE94A1FA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jul 2019 04:35:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38F39344;
 Thu,  4 Jul 2019 01:35:05 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B9F413F703;
 Thu,  4 Jul 2019 01:35:03 -0700 (PDT)
Date: Thu, 4 Jul 2019 09:35:01 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] KVM: arm64/sve: Fix vq_present() macro to yield a bool
Message-ID: <20190704083459.GY2790@e103592.cambridge.arm.com>
References: <1562175770-10952-1-git-send-email-Dave.Martin@arm.com>
 <20190704030252.4gzvoh4rxdmmddu5@vireshk-i7>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190704030252.4gzvoh4rxdmmddu5@vireshk-i7>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Jul 04, 2019 at 08:32:52AM +0530, Viresh Kumar wrote:
> On 03-07-19, 18:42, Dave Martin wrote:
> > From: Zhang Lei <zhang.lei@jp.fujitsu.com>
> > 
> > The original implementation of vq_present() relied on aggressive
> > inlining in order for the compiler to know that the code is
> > correct, due to some const-casting issues.  This was causing sparse
> > and clang to complain, while GCC compiled cleanly.
> > 
> > Commit 0c529ff789bc addressed this problem, but since vq_present()
> > is no longer a function, there is now no implicit casting of the
> > returned value to the return type (bool).
> > 
> > In set_sve_vls(), this uncast bit value is compared against a bool,
> > and so may spuriously compare as unequal when both are nonzero.  As
> > a result, KVM may reject valid SVE vector length configurations as
> > invalid, and vice versa.
> > 
> > Fix it by forcing the returned value to a bool.
> > 
> > Signed-off-by: Zhang Lei <zhang.lei@jp.fujitsu.com>
> > Fixes: 0c529ff789bc ("KVM: arm64: Implement vq_present() as a macro")
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com> [commit message rewrite]
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > 
> > ---
> > 
> > Posting this under Zhang Lei's authorship, due to the need to turn this
> > fix around quickly.  The fix is as per the original suggestion [1].
> > 
> > Originally observed with the QEMU KVM SVE support under review:
> > https://lists.gnu.org/archive/html/qemu-devel/2019-06/msg04945.html
> > 
> > Bug reproduced and fix tested on the Arm Fast Model, with
> > http://linux-arm.org/git?p=kvmtool-dm.git;a=shortlog;h=refs/heads/sve/v3/head
> > (After rerunning util/update_headers.sh.)
> > 
> > (the --sve-vls command line argument was removed in v4 of the
> > kvmtool patches).
> > 
> > [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2019-July/664633.html
> > ---
> >  arch/arm64/kvm/guest.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index c2afa79..dfd6264 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -208,7 +208,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  
> >  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
> >  #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
> > -#define vq_present(vqs, vq) ((vqs)[vq_word(vq)] & vq_mask(vq))
> > +#define vq_present(vqs, vq) (!!((vqs)[vq_word(vq)] & vq_mask(vq)))
> >  
> >  static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> 
> It was a really nice bug :)
> 
> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks for the quick review!

Maybe it makes sense to write equality comparisons on bools as !x == !y
to be more defensive against this kind of thing.  Anyway, probably best
to leave this as-is while the dust settles.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
