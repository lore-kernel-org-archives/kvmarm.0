Return-Path: <SRS0=H5U9=DG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1052C4727C
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 15:27:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24BA7207C4
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 15:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qebXSOEK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24BA7207C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6696B4B1D4;
	Tue, 29 Sep 2020 11:27:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5tisA2XoFH8I; Tue, 29 Sep 2020 11:27:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E4004B160;
	Tue, 29 Sep 2020 11:27:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 727DE4B139
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 11:27:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DdmsW91o87z9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2020 11:27:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 372AA4B134
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 11:27:49 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D3A15207F7;
 Tue, 29 Sep 2020 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601393268;
 bh=i5XygYKUbhjc8E7QHK8mBozTXBb67C6QTVJ1UnIiG+Y=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=qebXSOEKVQP7sAM/WeZKDV0h0M+ThqhsZpd2dxoZ5S+QiYYN0W5P1KjkWWawU+Eqm
 92HcIL4waMmBaLPDiYFFgLQSK3SaHjNGukYxY833e/xLElEaMKGabwNonYG/mB2eVu
 i4ERqRrGhRegCe/43k2019Q8aETP7xDt5EyMvisQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kNHXd-00Fsvn-Rl; Tue, 29 Sep 2020 16:27:45 +0100
MIME-Version: 1.0
Date: Tue, 29 Sep 2020 16:27:45 +0100
From: Marc Zyngier <maz@kernel.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 22/23] KVM: arm64: Add a rVIC/rVID in-kernel implementation
In-Reply-To: <20200929151354.GA4877@e121166-lin.cambridge.arm.com>
References: <20200903152610.1078827-1-maz@kernel.org>
 <20200903152610.1078827-23-maz@kernel.org>
 <20200929151354.GA4877@e121166-lin.cambridge.arm.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <136948b6e93db336b8a87e8f16335e7c@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lorenzo.pieralisi@arm.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, Christoffer.Dall@arm.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Hi Lorenzo,

On 2020-09-29 16:13, Lorenzo Pieralisi wrote:
> On Thu, Sep 03, 2020 at 04:26:09PM +0100, Marc Zyngier wrote:
> 
> [...]
> 
>> +static void __rvic_sync_hcr(struct kvm_vcpu *vcpu, struct rvic *rvic,
>> +			    bool was_signaling)
>> +{
>> +	struct kvm_vcpu *target = kvm_rvic_to_vcpu(rvic);
>> +	bool signal = __rvic_can_signal(rvic);
>> +
>> +	/* We're hitting our own rVIC: update HCR_VI locally */
>> +	if (vcpu == target) {
>> +		if (signal)
>> +			*vcpu_hcr(vcpu) |= HCR_VI;
>> +		else
>> +			*vcpu_hcr(vcpu) &= ~HCR_VI;
>> +
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * Remote rVIC case:
>> +	 *
>> +	 * We kick even if the interrupt disappears, as ISR_EL1.I must
>> +	 * always reflect the state of the rVIC. This forces a reload
>> +	 * of the vcpu state, making it consistent.
> 
> Forgive me the question but this is unclear to me. IIUC here we do 
> _not_
> want to change the target_vcpu.hcr and we force a kick to make sure it
> syncs the hcr (so the rvic) state on its own upon exit. Is that correct 
> ?

This is indeed correct. Changing the vcpu's hcr is racy as we sometimes
update it on vcpu exit, so directly updating this field would require
introducing atomic accesses between El1 and EL2. Not happening.

Instead, we force the vcpu to reload its own state as it *reenters*
the guest (and not on exit). This way, no locking, no cmpxchg, 
everything
is still single threaded.

> Furthermore, I think it would be extremely useful to elaborate (ie
> rework the comment) further on ISR_EL1.I and how it is linked to this
> code path - I think it is key to understanding it.

I'm not really sure what to add here, apart from paraphrasing the ARM 
ARM.
ISR_EL1 always represents the interrupt input to the CPU, virtual or 
not,
and we must honor this requirements by making any change of output of
the rVIC directly observable (i.e. update HCR_EL2.VI).

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
