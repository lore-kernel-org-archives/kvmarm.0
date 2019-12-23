Return-Path: <SRS0=P9fm=2N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863CAC2D0CF
	for <kvmarm@archiver.kernel.org>; Mon, 23 Dec 2019 11:57:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0860B20CC7
	for <kvmarm@archiver.kernel.org>; Mon, 23 Dec 2019 11:56:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0860B20CC7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5789B4AF4D;
	Mon, 23 Dec 2019 06:56:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 70x9sQQQNjgD; Mon, 23 Dec 2019 06:56:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3850D4AF47;
	Mon, 23 Dec 2019 06:56:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D25DE4AF23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 06:56:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6INS9LiTHErR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Dec 2019 06:56:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F237B4AF20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 06:56:54 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BEFA1FB;
 Mon, 23 Dec 2019 03:56:54 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B5C7F3F68F;
 Mon, 23 Dec 2019 03:56:53 -0800 (PST)
Date: Mon, 23 Dec 2019 11:56:52 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 11/18] KVM: arm64: don't trap Statistical Profiling
 controls to EL2
Message-ID: <20191223115651.GA42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-12-andrew.murray@arm.com>
 <86bls0iqv6.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86bls0iqv6.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Sun, Dec 22, 2019 at 10:42:05AM +0000, Marc Zyngier wrote:
> On Fri, 20 Dec 2019 14:30:18 +0000,
> Andrew Murray <andrew.murray@arm.com> wrote:
> > 
> > As we now save/restore the profiler state there is no need to trap
> > accesses to the statistical profiling controls. Let's unset the
> > _TPMS bit.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  arch/arm64/kvm/debug.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index 43487f035385..07ca783e7d9e 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -88,7 +88,6 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
> >   *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
> >   *  - Debug ROM Address (MDCR_EL2_TDRA)
> >   *  - OS related registers (MDCR_EL2_TDOSA)
> > - *  - Statistical profiler (MDCR_EL2_TPMS/MDCR_EL2_E2PB)
> >   *
> >   * Additionally, KVM only traps guest accesses to the debug registers if
> >   * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
> > @@ -111,7 +110,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >  	 */
> >  	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
> >  	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
> > -				MDCR_EL2_TPMS |
> 
> No. This is an *optional* feature (the guest could not be presented
> with the SPE feature, or the the support simply not be compiled in).
> 
> If the guest is not allowed to see the feature, for whichever reason,
> the traps *must* be enabled and handled.

I'll update this (and similar) to trap such registers when we don't support
SPE in the guest.

My original concern in the cover letter was in how to prevent the guest
from attempting to use these registers in the first place - I think the
solution I was looking for is to trap-and-emulate ID_AA64DFR0_EL1 such that
the PMSVer bits indicate that SPE is not emulated.

Thanks,

Andrew Murray


> 
> 	M.
> 
> -- 
> Jazz is not dead, it just smells funny.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
