Return-Path: <SRS0=H5U9=DG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF155C4727C
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 16:09:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3D4C2075E
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 16:09:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3D4C2075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECFA54B16E;
	Tue, 29 Sep 2020 12:09:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jh6yJ6Yav07s; Tue, 29 Sep 2020 12:09:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0F934B1AA;
	Tue, 29 Sep 2020 12:09:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C838B4B133
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 12:09:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N5IEVZPgw+h0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2020 12:09:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89C074B132
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 12:09:08 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36DE731B;
 Tue, 29 Sep 2020 09:09:08 -0700 (PDT)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com
 [10.1.196.255])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 018973F73B;
 Tue, 29 Sep 2020 09:09:06 -0700 (PDT)
Date: Tue, 29 Sep 2020 17:09:01 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 22/23] KVM: arm64: Add a rVIC/rVID in-kernel implementation
Message-ID: <20200929160901.GA5517@e121166-lin.cambridge.arm.com>
References: <20200903152610.1078827-1-maz@kernel.org>
 <20200903152610.1078827-23-maz@kernel.org>
 <20200929151354.GA4877@e121166-lin.cambridge.arm.com>
 <136948b6e93db336b8a87e8f16335e7c@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <136948b6e93db336b8a87e8f16335e7c@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Sep 29, 2020 at 04:27:45PM +0100, Marc Zyngier wrote:
> Hi Lorenzo,
> 
> On 2020-09-29 16:13, Lorenzo Pieralisi wrote:
> > On Thu, Sep 03, 2020 at 04:26:09PM +0100, Marc Zyngier wrote:
> > 
> > [...]
> > 
> > > +static void __rvic_sync_hcr(struct kvm_vcpu *vcpu, struct rvic *rvic,
> > > +			    bool was_signaling)
> > > +{
> > > +	struct kvm_vcpu *target = kvm_rvic_to_vcpu(rvic);
> > > +	bool signal = __rvic_can_signal(rvic);
> > > +
> > > +	/* We're hitting our own rVIC: update HCR_VI locally */
> > > +	if (vcpu == target) {
> > > +		if (signal)
> > > +			*vcpu_hcr(vcpu) |= HCR_VI;
> > > +		else
> > > +			*vcpu_hcr(vcpu) &= ~HCR_VI;
> > > +
> > > +		return;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Remote rVIC case:
> > > +	 *
> > > +	 * We kick even if the interrupt disappears, as ISR_EL1.I must
> > > +	 * always reflect the state of the rVIC. This forces a reload
> > > +	 * of the vcpu state, making it consistent.
> > 
> > Forgive me the question but this is unclear to me. IIUC here we do _not_
> > want to change the target_vcpu.hcr and we force a kick to make sure it
> > syncs the hcr (so the rvic) state on its own upon exit. Is that correct
> > ?
> 
> This is indeed correct. Changing the vcpu's hcr is racy as we sometimes
> update it on vcpu exit, so directly updating this field would require
> introducing atomic accesses between El1 and EL2. Not happening.
> 
> Instead, we force the vcpu to reload its own state as it *reenters*
> the guest (and not on exit). This way, no locking, no cmpxchg, everything
> is still single threaded.
> 
> > Furthermore, I think it would be extremely useful to elaborate (ie
> > rework the comment) further on ISR_EL1.I and how it is linked to this
> > code path - I think it is key to understanding it.
> 
> I'm not really sure what to add here, apart from paraphrasing the ARM ARM.
> ISR_EL1 always represents the interrupt input to the CPU, virtual or not,
> and we must honor this requirements by making any change of output of
> the rVIC directly observable (i.e. update HCR_EL2.VI).

Ok got it. Basically we kick the target_vcpu because there is a change
in its IRQ input signal that has to be signalled (by updating the
HCR_EL2.VI that in turns updates the ISR_EL1.I). I read the comment as
if we don't care about the target_vcpu.hcr_el2 update and was struggling
to understand the whole code path.

Back to reading the code (properly :)).

Thanks,
Lorenzo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
