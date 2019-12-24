Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75046C2D0D0
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:11:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 017E720409
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:11:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 017E720409
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BC7A4AF53;
	Tue, 24 Dec 2019 06:11:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lTsuixkofwKO; Tue, 24 Dec 2019 06:11:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E9704AF3A;
	Tue, 24 Dec 2019 06:11:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4B564AF3A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:11:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SU56yOtAAbAN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 06:11:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EE274AF11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:11:08 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7185A1FB;
 Tue, 24 Dec 2019 03:11:08 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB9FD3F534;
 Tue, 24 Dec 2019 03:11:07 -0800 (PST)
Date: Tue, 24 Dec 2019 11:11:06 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 10/18] arm64: KVM/debug: use EL1&0 stage 1 translation
 regime
Message-ID: <20191224111105.GF42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-11-andrew.murray@arm.com>
 <86d0cgir74.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86d0cgir74.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Sun, Dec 22, 2019 at 10:34:55AM +0000, Marc Zyngier wrote:
> On Fri, 20 Dec 2019 14:30:17 +0000,
> Andrew Murray <andrew.murray@arm.com> wrote:
> > 
> > From: Sudeep Holla <sudeep.holla@arm.com>
> > 
> > Now that we have all the save/restore mechanism in place, lets enable
> > the translation regime used by buffer from EL2 stage 1 to EL1 stage 1
> > on VHE systems.
> > 
> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > [ Reword commit, don't trap to EL2 ]
> 
> Not trapping to EL2 for the case where we don't allow SPE in the
> guest is not acceptable.

Yes understood (because of this I had meant to send the series as RFC btw).


> 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  arch/arm64/kvm/hyp/switch.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 67b7c160f65b..6c153b79829b 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -100,6 +100,7 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
> >  
> >  	write_sysreg(val, cpacr_el1);
> >  
> > +	write_sysreg(vcpu->arch.mdcr_el2 | 3 << MDCR_EL2_E2PB_SHIFT, mdcr_el2);
> >  	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
> >  }
> >  NOKPROBE_SYMBOL(activate_traps_vhe);
> > @@ -117,6 +118,7 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
> >  		__activate_traps_fpsimd32(vcpu);
> >  	}
> >  
> > +	write_sysreg(vcpu->arch.mdcr_el2 | 3 << MDCR_EL2_E2PB_SHIFT, mdcr_el2);
> 
> There is a _MASK macro that can replace this '3', and is in keeping
> with the rest of the code.

OK.


> 
> It still remains that it looks like the wrong place to do this, and
> vcpu_load seems much better. Why should you write to mdcr_el2 on each
> entry to the guest, since you know whether it has SPE enabled at the
> point where it gets scheduled?

Yes OK, I'll move what I can to vcpu_load.

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
