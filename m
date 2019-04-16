Return-Path: <SRS0=JhHZ=SS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC8CC10F14
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 12:46:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46EF8205ED
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 12:46:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46EF8205ED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF1324A4FF;
	Tue, 16 Apr 2019 08:46:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QM3-rPEkLCaM; Tue, 16 Apr 2019 08:46:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6955A4A511;
	Tue, 16 Apr 2019 08:46:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 633B14A506
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 08:46:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XSr18LUTVl2C for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Apr 2019 08:46:53 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0F754A4FF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 08:46:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BC26EBD;
 Tue, 16 Apr 2019 05:46:52 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 712493F706;
 Tue, 16 Apr 2019 05:46:50 -0700 (PDT)
Date: Tue, 16 Apr 2019 13:46:48 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 00/14] KVM: arm64: SVE cleanups
Message-ID: <20190416124647.GQ3567@e103592.cambridge.arm.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
 <20190415152213.kpxqshmfot525m2j@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190415152213.kpxqshmfot525m2j@kamzik.brq.redhat.com>
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
Message-ID: <20190416124648.SDgLu8gW6E_kifi7zoq5HafLkgfGemmuFQx5eFvGs-Q@z>

On Mon, Apr 15, 2019 at 05:22:13PM +0200, Andrew Jones wrote:
> On Fri, Apr 12, 2019 at 05:28:04PM +0100, Dave Martin wrote:
> > This series contains some cleanups applicable to the SVE KVM support
> > patches merged into kvmarm/next.  These arose from Andrew Jones'
> > review.
> > 
> > Apart from some minor changes to error codes and checking, these are
> > mostly cosmetic / sytlistic changes only.
> > 
> > Although straightforward, these changes have not been tested yet:
> > I'm posting them now so that reviewers can make a start on them.
> > 
> > The patches are based on
> > git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
> > 5d8d4af24460 ("arm64: KVM: Fix system register enumeration")
> > 
> > This series in git:
> > git://linux-arm.org/linux-dm.git sve-kvm-fixes/v1/head
> > http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve-kvm-fixes/v1/head
> > 
> > Dave Martin (14):
> >   arm64/sve: Clarify vq map semantics
> >   KVM: arm/arm64: Demote kvm_arm_init_arch_resources() to just set up
> >     SVE
> >   KVM: arm: Make vcpu finalization stubs into inline functions
> >   KVM: arm64/sve: sys_regs: Demote redundant vcpu_has_sve() checks to
> >     WARNs
> >   KVM: arm64/sve: Clean up UAPI register ID definitions
> >   KVM: arm64/sve: Miscellaneous tidyups in guest.c
> >   KVM: arm64/sve: Make register ioctl access errors more consistent
> >   KVM: arm64/sve: WARN when avoiding divide-by-zero in
> >     sve_reg_to_region()
> >   KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS array sizing
> >   KVM: arm64/sve: Explain validity checks in set_sve_vls()
> >   KVM: arm/arm64: Clean up vcpu finalization function parameter naming
> >   KVM: Clarify capability requirements for KVM_ARM_VCPU_FINALIZE
> >   KVM: Clarify KVM_{SET,GET}_ONE_REG error code documentation
> >   KVM: arm64: Clarify access behaviour for out-of-range SVE register
> >     slice IDs
> > 
> >  Documentation/virtual/kvm/api.txt | 24 ++++++-----
> >  arch/arm/include/asm/kvm_host.h   | 13 ++++--
> >  arch/arm64/include/asm/fpsimd.h   |  4 --
> >  arch/arm64/include/asm/kvm_host.h |  4 +-
> >  arch/arm64/include/uapi/asm/kvm.h | 32 ++++++++++----
> >  arch/arm64/kernel/fpsimd.c        |  7 ++-
> >  arch/arm64/kvm/guest.c            | 91 +++++++++++++++++++++++----------------
> >  arch/arm64/kvm/reset.c            |  6 +--
> >  arch/arm64/kvm/sys_regs.c         |  4 +-
> >  virt/kvm/arm/arm.c                |  2 +-
> >  10 files changed, 116 insertions(+), 71 deletions(-)
> > 
> > -- 
> > 2.1.4
> >
> 
> For the series
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks for the review
---Dave

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
