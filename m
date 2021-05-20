Return-Path: <SRS0=DM5G=KP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC4EC433ED
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 14:06:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7FACA613B4
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 14:06:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FACA613B4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB7DE4B475;
	Thu, 20 May 2021 10:06:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PyIChgCLzMFp; Thu, 20 May 2021 10:06:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1DE84B47B;
	Thu, 20 May 2021 10:06:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C2EC4B475
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 10:06:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ofCk1nDKts4j for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 May 2021 10:06:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A12164B473
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 10:06:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 110E011D4;
 Thu, 20 May 2021 07:06:20 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.7.235])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 917B53F73B;
 Thu, 20 May 2021 07:06:18 -0700 (PDT)
Date: Thu, 20 May 2021 15:06:15 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Prevent mixed-width VM creation
Message-ID: <20210520140615.GH17233@C02TD0UTHF1T.local>
References: <20210520122253.171545-1-maz@kernel.org>
 <20210520124434.GD17233@C02TD0UTHF1T.local>
 <87zgwptvcg.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87zgwptvcg.wl-maz@kernel.org>
Cc: stable@vger.kernel.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Steven Price <steven.price@arm.com>
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

On Thu, May 20, 2021 at 01:58:55PM +0100, Marc Zyngier wrote:
> On Thu, 20 May 2021 13:44:34 +0100,
> Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> > On Thu, May 20, 2021 at 01:22:53PM +0100, Marc Zyngier wrote:
> > > It looks like we have tolerated creating mixed-width VMs since...
> > > forever. However, that was never the intention, and we'd rather
> > > not have to support that pointless complexity.
> > > 
> > > Forbid such a setup by making sure all the vcpus have the same
> > > register width.
> > > 
> > > Reported-by: Steven Price <steven.price@arm.com>
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  arch/arm64/kvm/reset.c | 28 ++++++++++++++++++++++++----
> > >  1 file changed, 24 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > > index 956cdc240148..1cf308be6ef3 100644
> > > --- a/arch/arm64/kvm/reset.c
> > > +++ b/arch/arm64/kvm/reset.c
> > > @@ -166,6 +166,25 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
> > >  	return 0;
> > >  }
> > >  
> > > +static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct kvm_vcpu *tmp;
> > > +	int i;
> > > +
> > > +	/* Check that the vcpus are either all 32bit or all 64bit */
> > > +	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> > > +		bool w;
> > > +
> > > +		w  = test_bit(KVM_ARM_VCPU_EL1_32BIT, tmp->arch.features);
> > > +		w ^= test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features);
> > > +
> > > +		if (w)
> > > +			return false;
> > > +	}
> > 
> > I think this is wrong for a single-cpu VM. In that case, the loop will
> > have a single iteration, and tmp == vcpu, so w must be 0 regardless of
> > the value of arch.features.
> 
> I don't immediately see what is wrong with a single-cpu VM. 'w' will
> be zero indeed, and we'll return that this is allowed. After all, each
> VM starts by being a single-CPU VM.

Sorry; I should have been clearer. I had assumed that this was trying to
rely on a difference across vcpus implicitly providing an equivalent of
the removed check for the KVM_ARM_VCPU_EL1_32BIT cap. I guess from the
below that was not the case. :)

Thanks,
Mark.

> But of course...
> 
> > IIUC that doesn't prevent KVM_ARM_VCPU_EL1_32BIT being set when we don't
> > have the ARM64_HAS_32BIT_EL1 cap, unless that's checked elsewhere?
> 
> ... I mistakenly removed the check against ARM64_HAS_32BIT_EL1...
> 
> > 
> > How about something like:
> > 
> > | static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> > | {
> > | 	bool is_32bit = vcpu_features_32bit(vcpu);
> > | 	struct kvm_vcpu *tmp;
> > | 	int i;
> > | 
> > | 	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is_32bit)
> > | 		return false;
> > | 
> > | 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> > | 		if (is_32bit != vcpu_features_32bit(tmp))
> > | 			return false;
> > | 	}
> > | 
> > | 	return true;
> > | }
> > 
> > ... with a helper in <asm/kvm_emulate.h> like:
> > 
> > | static bool vcpu_features_32bit(struct kvm_vcpu *vcpu)
> > | {
> > | 	return test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features);
> > | }
> > 
> > ... or
> > 
> > | static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
> > | {
> > | 	return test_bit(feature, vcpu->arch.features);
> > | }
> > 
> > ... so that we can avoid the line splitting required by the length of
> > the test_bit() expression?
> 
> Yup, looks OK to me (with a preference for the latter).
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
