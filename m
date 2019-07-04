Return-Path: <SRS0=oQwk=VB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DA3C06513
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jul 2019 10:04:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C9FC218A3
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jul 2019 10:04:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C9FC218A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jp.fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A145F40217;
	Thu,  4 Jul 2019 06:04:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QplYLTkzmUph; Thu,  4 Jul 2019 06:04:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6745E4A47E;
	Thu,  4 Jul 2019 06:04:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B6744A379
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jul 2019 06:04:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EtfoYBEZcrI3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jul 2019 06:04:42 -0400 (EDT)
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 230A240217
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jul 2019 06:04:41 -0400 (EDT)
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [192.168.231.130]) by
 mgwkm03.jp.fujitsu.com with smtp
 id 564c_6037_323b92be_1498_4356_b69b_8996055b68f0;
 Thu, 04 Jul 2019 19:04:33 +0900
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 3DB1BAC015C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jul 2019 19:04:33 +0900 (JST)
Received: from G01JPEXCHKW16.g01.fujitsu.local
 (G01JPEXCHKW16.g01.fujitsu.local [10.0.194.55])
 by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 30060692720;
 Thu,  4 Jul 2019 19:04:10 +0900 (JST)
Received: from G01JPEXMBKW03.g01.fujitsu.local ([10.0.194.67]) by
 g01jpexchkw16 ([10.0.194.55]) with mapi id 14.03.0439.000; Thu, 4 Jul 2019
 19:04:11 +0900
From: "Zhang, Lei" <zhang.lei@jp.fujitsu.com>
To: 'Dave Martin' <Dave.Martin@arm.com>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: RE: [PATCH] KVM: arm64/sve: Fix vq_present() macro to yield a bool
Thread-Topic: [PATCH] KVM: arm64/sve: Fix vq_present() macro to yield a bool
Thread-Index: AQHVMcbm4thAjrk2VU+dkXrvfiHl5Ka5L4IAgABczYCAAK3FQA==
Date: Thu, 4 Jul 2019 10:04:08 +0000
Message-ID: <8898674D84E3B24BA3A2D289B872026A78BAAE43@G01JPEXMBKW03>
References: <1562175770-10952-1-git-send-email-Dave.Martin@arm.com>
 <20190704030252.4gzvoh4rxdmmddu5@vireshk-i7>
 <20190704083459.GY2790@e103592.cambridge.arm.com>
In-Reply-To: <20190704083459.GY2790@e103592.cambridge.arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.18.70.226]
MIME-Version: 1.0
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-GCONF: 00
Cc: "Okamoto, Takayuki" <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Julien Grall <julien.grall@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi guys,

I have started up KVM guest os successfully with SVE feature with Dave' patch.

Tested-by: Zhang Lei <zhang.lei@jp.fujitsu.com >

> -----Original Message-----
> From: Dave Martin <Dave.Martin@arm.com>
> Sent: Thursday, July 04, 2019 5:35 PM
> To: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Okamoto, Takayuki/岡本 高幸 <tokamoto@jp.fujitsu.com>; Christoffer
> Dall <cdall@kernel.org>; Ard Biesheuvel <ard.biesheuvel@linaro.org>; Marc
> Zyngier <marc.zyngier@arm.com>; Catalin Marinas
> <catalin.marinas@arm.com>; Will Deacon <will.deacon@arm.com>; Zhang,
> Lei/張 雷 <zhang.lei@jp.fujitsu.com>; Julien Grall <julien.grall@arm.com>;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] KVM: arm64/sve: Fix vq_present() macro to yield a bool
> 
> On Thu, Jul 04, 2019 at 08:32:52AM +0530, Viresh Kumar wrote:
> > On 03-07-19, 18:42, Dave Martin wrote:
> > > From: Zhang Lei <zhang.lei@jp.fujitsu.com>
> > >
> > > The original implementation of vq_present() relied on aggressive
> > > inlining in order for the compiler to know that the code is correct,
> > > due to some const-casting issues.  This was causing sparse and clang
> > > to complain, while GCC compiled cleanly.
> > >
> > > Commit 0c529ff789bc addressed this problem, but since vq_present()
> > > is no longer a function, there is now no implicit casting of the
> > > returned value to the return type (bool).
> > >
> > > In set_sve_vls(), this uncast bit value is compared against a bool,
> > > and so may spuriously compare as unequal when both are nonzero.  As
> > > a result, KVM may reject valid SVE vector length configurations as
> > > invalid, and vice versa.
> > >
> > > Fix it by forcing the returned value to a bool.
> > >
> > > Signed-off-by: Zhang Lei <zhang.lei@jp.fujitsu.com>
> > > Fixes: 0c529ff789bc ("KVM: arm64: Implement vq_present() as a
> > > macro")
> > > Signed-off-by: Dave Martin <Dave.Martin@arm.com> [commit message
> > > rewrite]
> > > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > >
> > > ---
> > >
> > > Posting this under Zhang Lei's authorship, due to the need to turn
> > > this fix around quickly.  The fix is as per the original suggestion [1].
> > >
> > > Originally observed with the QEMU KVM SVE support under review:
> > > https://lists.gnu.org/archive/html/qemu-devel/2019-06/msg04945.html
> > >
> > > Bug reproduced and fix tested on the Arm Fast Model, with
> > > http://linux-arm.org/git?p=kvmtool-dm.git;a=shortlog;h=refs/heads/sv
> > > e/v3/head (After rerunning util/update_headers.sh.)
> > >
> > > (the --sve-vls command line argument was removed in v4 of the
> > > kvmtool patches).
> > >
> > > [1]
> > > http://lists.infradead.org/pipermail/linux-arm-kernel/2019-July/6646
> > > 33.html
> > > ---
> > >  arch/arm64/kvm/guest.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c index
> > > c2afa79..dfd6264 100644
> > > --- a/arch/arm64/kvm/guest.c
> > > +++ b/arch/arm64/kvm/guest.c
> > > @@ -208,7 +208,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu,
> > > const struct kvm_one_reg *reg)
> > >
> > >  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)  #define vq_mask(vq)
> > > ((u64)1 << ((vq) - SVE_VQ_MIN) % 64) -#define vq_present(vqs, vq)
> > > ((vqs)[vq_word(vq)] & vq_mask(vq))
> > > +#define vq_present(vqs, vq) (!!((vqs)[vq_word(vq)] & vq_mask(vq)))
> > >
> > >  static int get_sve_vls(struct kvm_vcpu *vcpu, const struct
> > > kvm_one_reg *reg)  {
> >
> > It was a really nice bug :)
> >
> > Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Thanks for the quick review!
> 
> Maybe it makes sense to write equality comparisons on bools as !x == !y to be
> more defensive against this kind of thing.  Anyway, probably best to leave this
> as-is while the dust settles.
> 
> Cheers
> ---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
