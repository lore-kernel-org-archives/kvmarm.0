Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACE0C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 09:26:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A0B964FD5
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 09:26:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A0B964FD5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DD2B4B6FE;
	Fri, 12 Mar 2021 04:26:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nauNH7deYfLd; Fri, 12 Mar 2021 04:26:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8EC34B5D9;
	Fri, 12 Mar 2021 04:26:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9916E4B579
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 04:26:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AXWsRrC82Jxe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 04:26:03 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9AD3F4B577
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 04:26:03 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id B85FE64ED7;
 Fri, 12 Mar 2021 09:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615541162;
 bh=lt1IwrNUaz19OAxDfxgi2aiw3GOvHySCHyMhts/ttlc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=fj6Lfc2WDvpu5FN2uF4nmKoY/pKj+yD6c1fxrHH/2C9G+WxYhA5XcICxqbDZryfHb
 UILcjc19PqDMIxnxPslMIKU2n5/nLiV1Ky0Z9E//xMmLGgTQbxgeTfZU2kAWYZBxoK
 Rw0RHvov/Ewu9lspDaalDVnJc6UQlHkTT0o+ubMrV+1eER3D8uUTJ/+L6pVBO3wu1g
 kIfJ2rWYtUX9JtkeoRaoE/+5gOfR4fv6xG95DkxlY7BkzgE1Yyi8ZdhqCgebkwanaU
 mLNNKPkrM9JHPA5MDb6489q/r3qq5RVsRy0VwZST8KtNuShKhUgPjyWON19f6p7gH9
 G9dOWm5SsN/+g==
Date: Fri, 12 Mar 2021 09:25:56 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v4 13/34] KVM: arm64: Enable access to sanitized CPU
 features at EL2
Message-ID: <20210312092556.GA32016@willie-the-truck>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-14-qperret@google.com>
 <20210311193638.GE31586@willie-the-truck>
 <YEsLYX2CjNMXF9TN@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YEsLYX2CjNMXF9TN@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Fri, Mar 12, 2021 at 06:34:09AM +0000, Quentin Perret wrote:
> On Thursday 11 Mar 2021 at 19:36:39 (+0000), Will Deacon wrote:
> > On Wed, Mar 10, 2021 at 05:57:30PM +0000, Quentin Perret wrote:
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 4f2f1e3145de..84be93df52fa 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -21,6 +21,7 @@
> > >  #include <asm/debug-monitors.h>
> > >  #include <asm/esr.h>
> > >  #include <asm/kvm_arm.h>
> > > +#include <asm/kvm_cpufeature.h>
> > >  #include <asm/kvm_emulate.h>
> > >  #include <asm/kvm_hyp.h>
> > >  #include <asm/kvm_mmu.h>
> > > @@ -2775,3 +2776,23 @@ void kvm_sys_reg_table_init(void)
> > >  	/* Clear all higher bits. */
> > >  	cache_levels &= (1 << (i*3))-1;
> > >  }
> > > +
> > > +#undef KVM_HYP_CPU_FTR_REG
> > > +#define KVM_HYP_CPU_FTR_REG(id, name) \
> > > +	{ .sys_id = id, .dst = (struct arm64_ftr_reg *)&kvm_nvhe_sym(name) },
> > > +struct __ftr_reg_copy_entry {
> > > +	u32			sys_id;
> > > +	struct arm64_ftr_reg	*dst;
> > > +} hyp_ftr_regs[] __initdata = {
> > > +	#include <asm/kvm_cpufeature.h>
> > > +};
> > 
> > This looks a bit elaborate to me. Why can't you just spell things out here
> > like:
> > 
> > #define KVM_HYP_CPU_FTR_REG(id, name) \
> > 	{ .sys_id = id, .dst = (struct arm64_ftr_reg *)&kvm_nvhe_sym(name) }
> > 
> > struct __ftr_reg_copy_entry {
> > 	u32			sys_id;
> > 	struct arm64_ftr_reg	*dst;
> > } hyp_ftr_regs[] __initdata = {
> > 	KVM_HYP_CPU_FTR_REG(SYS_CTR_EL0, arm64_ftr_reg_ctrel0),
> > 	...
> > };
> > 
> > and then have the header file be a normal, guarded header which just
> > declares these things? The id parameter to the macro isn't used there.
> 
> I just tried to reduce the boilerplate as much as possible -- in the
> current form you only need to add additional features to the header
> it'll 'just work'.

I don't really think it's worth it -- people are used to having to add
declarations for things, so keeping it simple should be fine.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
