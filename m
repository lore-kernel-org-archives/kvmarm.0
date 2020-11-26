Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6FEC63697
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:25:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A81D21D1A
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:25:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="VLV1daix"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A81D21D1A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B18BB4C03C;
	Thu, 26 Nov 2020 10:25:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cYfXujMt2uwK; Thu, 26 Nov 2020 10:25:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1E1E4C03E;
	Thu, 26 Nov 2020 10:25:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91DD54C03B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:25:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ORXRqNySDN-9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:25:27 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 816E04C03A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:25:27 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 44BE12087C;
 Thu, 26 Nov 2020 15:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606404326;
 bh=ex8zM01Qf4GRjPCLPiCrNyiXTx9goms244wEAdEL7NQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=VLV1daix0z8iPONDOP+71WX/IOApqNx+Rx+fdXn3AF7cp9vVuvZmKZcWhlOFavXqy
 9dWw3lUQnequckWPtHnUH9Nt+0KKSOYtcKaeAzXAK5EK5swiKpvwHIbfwHW//M17hh
 JgCY9Z/i9HxHfVpMe9oKfq1CGBbfvZb19LNy3QB0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kiJ9A-00Dq9p-9S; Thu, 26 Nov 2020 15:25:24 +0000
MIME-Version: 1.0
Date: Thu, 26 Nov 2020 15:25:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 3/8] KVM: arm64: Refuse illegal KVM_ARM_VCPU_PMU_V3 at
 reset time
In-Reply-To: <27c74186-d9d6-4021-c561-54ae4475bf88@arm.com>
References: <20201113182602.471776-1-maz@kernel.org>
 <20201113182602.471776-4-maz@kernel.org>
 <27c74186-d9d6-4021-c561-54ae4475bf88@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <7abf75c1d1248a9c0e3fcb7737a101c0@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Alex,

On 2020-11-26 14:59, Alexandru Elisei wrote:
> Hi Marc,
> 
> On 11/13/20 6:25 PM, Marc Zyngier wrote:
>> We accept to configure a PMU when a vcpu is created, even if the
>> HW (or the host) doesn't support it. This results in failures
>> when attributes get set, which is a bit odd as we should have
>> failed the vcpu creation the first place.
>> 
>> Move the check to the point where we check the vcpu feature set,
>> and fail early if we cannot support a PMU. This further simplifies
>> the attribute handling.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/pmu-emul.c | 4 ++--
>>  arch/arm64/kvm/reset.c    | 4 ++++
>>  2 files changed, 6 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index e7e3b4629864..200f2a0d8d17 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -913,7 +913,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int 
>> irq)
>> 
>>  int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct 
>> kvm_device_attr *attr)
>>  {
>> -	if (!kvm_arm_support_pmu_v3() || !kvm_vcpu_has_pmu(vcpu))
>> +	if (!kvm_vcpu_has_pmu(vcpu))
>>  		return -ENODEV;
>> 
>>  	if (vcpu->arch.pmu.created)
>> @@ -1034,7 +1034,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu 
>> *vcpu, struct kvm_device_attr *attr)
>>  	case KVM_ARM_VCPU_PMU_V3_IRQ:
>>  	case KVM_ARM_VCPU_PMU_V3_INIT:
>>  	case KVM_ARM_VCPU_PMU_V3_FILTER:
>> -		if (kvm_arm_support_pmu_v3() && kvm_vcpu_has_pmu(vcpu))
>> +		if (kvm_vcpu_has_pmu(vcpu))
>>  			return 0;
>>  	}
>> 
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 74ce92a4988c..3e772ea4e066 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -285,6 +285,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>  			pstate = VCPU_RESET_PSTATE_EL1;
>>  		}
>> 
>> +		if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
> 
> This looks correct, but right at the beginning of the function, before 
> this
> non-preemptible section, we do kvm_pmu_vcpu_reset(), which is wrong for 
> several
> reasons:
> 
> - we don't check if the feature flag is set
> - we don't check if the hardware supports a PMU
> - kvm_pmu_vcpu_reset() relies on __vcpu_sys_reg(vcpu, PMCR_EL0), which 
> is set in
> kvm_reset_sys_regs() below when the VCPU is initialized.

I'm not sure it actually matters. Here's my rational:

- PMU support not compiled in: no problem!
- PMU support compiled in, but no HW PMU: we just reset some state to 0, 
no harm done
- HW PMU, but no KVM PMU for this vcpu: same thing
- HW PMU, and KVM PMU: we do the right thing!

Am I missing anything?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
