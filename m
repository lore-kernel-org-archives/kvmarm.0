Return-Path: <SRS0=diMM=3E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D29C33CB2
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 14:03:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2ABC6222C3
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 14:03:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQaWytZ7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2ABC6222C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C04294B12D;
	Wed, 15 Jan 2020 09:03:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J3SsiA2YrCq8; Wed, 15 Jan 2020 09:03:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0F2E4B14F;
	Wed, 15 Jan 2020 09:03:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 133A04B119
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 09:03:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BqqaG09sTZZU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jan 2020 09:03:28 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D691C4B118
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 09:03:27 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B82C5222C3;
 Wed, 15 Jan 2020 14:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579097006;
 bh=JirmHW6SrM9Hhd8eR0okNq08LwBENG1og0f1buqr/1Y=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=fQaWytZ7KsNB89iwcVBDmdEt+rfMqlGGqtUg+R8Ieh2y8PCK5qUynF6pqnwoxIMbT
 kLYBAQ7i9EurH/JL1cvPviuEvCTxl9ZCL9wzODI8sLMvDUbVqUrdV4T4MV9MbsmmmR
 9e1OyDH3nKRPFogqMEy0l+gAhzniSWMYDe4q+wQ0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1irjGW-0000US-UF; Wed, 15 Jan 2020 14:03:25 +0000
MIME-Version: 1.0
Date: Wed, 15 Jan 2020 14:03:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v2 10/18] arm64: KVM/debug: use EL1&0 stage 1 translation
 regime
In-Reply-To: <20200113163138.GP42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-11-andrew.murray@arm.com>
 <86d0cgir74.wl-maz@kernel.org>
 <20200113163138.GP42593@e119886-lin.cambridge.arm.com>
Message-ID: <5f141f153ceec55b4428d9c2d2dd9064@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, catalin.marinas@arm.com,
 will@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 sudeep.holla@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-01-13 16:31, Andrew Murray wrote:
> On Sun, Dec 22, 2019 at 10:34:55AM +0000, Marc Zyngier wrote:
>> On Fri, 20 Dec 2019 14:30:17 +0000,
>> Andrew Murray <andrew.murray@arm.com> wrote:
>> >
>> > From: Sudeep Holla <sudeep.holla@arm.com>
>> >
>> > Now that we have all the save/restore mechanism in place, lets enable
>> > the translation regime used by buffer from EL2 stage 1 to EL1 stage 1
>> > on VHE systems.
>> >
>> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> > [ Reword commit, don't trap to EL2 ]
>> 
>> Not trapping to EL2 for the case where we don't allow SPE in the
>> guest is not acceptable.
>> 
>> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
>> > ---
>> >  arch/arm64/kvm/hyp/switch.c | 2 ++
>> >  1 file changed, 2 insertions(+)
>> >
>> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> > index 67b7c160f65b..6c153b79829b 100644
>> > --- a/arch/arm64/kvm/hyp/switch.c
>> > +++ b/arch/arm64/kvm/hyp/switch.c
>> > @@ -100,6 +100,7 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
>> >
>> >  	write_sysreg(val, cpacr_el1);
>> >
>> > +	write_sysreg(vcpu->arch.mdcr_el2 | 3 << MDCR_EL2_E2PB_SHIFT, mdcr_el2);
>> >  	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
>> >  }
>> >  NOKPROBE_SYMBOL(activate_traps_vhe);
>> > @@ -117,6 +118,7 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
>> >  		__activate_traps_fpsimd32(vcpu);
>> >  	}
>> >
>> > +	write_sysreg(vcpu->arch.mdcr_el2 | 3 << MDCR_EL2_E2PB_SHIFT, mdcr_el2);
>> 
>> There is a _MASK macro that can replace this '3', and is in keeping
>> with the rest of the code.
>> 
>> It still remains that it looks like the wrong place to do this, and
>> vcpu_load seems much better. Why should you write to mdcr_el2 on each
>> entry to the guest, since you know whether it has SPE enabled at the
>> point where it gets scheduled?
> 
> For nVHE, the only reason we'd want to change E2PB on entry/exit of 
> guest
> would be if the host is also using SPE. If the host is using SPE whilst
> the vcpu is 'loaded' but we're not in the guest, then host SPE could 
> raise
> an interrupt - we need the E2PB bits to allow access from EL1 (host).

My comment was of course for VHE. nVHE hardly makes use of load/put at 
all,
for obvious reasons.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
