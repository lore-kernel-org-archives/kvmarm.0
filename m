Return-Path: <SRS0=IB6K=76=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D06FBC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jun 2020 10:47:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 519F320CC7
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jun 2020 10:47:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJUFTinr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 519F320CC7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA66C4B1B7;
	Wed, 17 Jun 2020 06:47:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aE56f6-XXZlg; Wed, 17 Jun 2020 06:47:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99A124B188;
	Wed, 17 Jun 2020 06:47:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D53644B188
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2020 06:47:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DqiPdj5TMHlF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2020 06:47:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 972824B17C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2020 06:47:44 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6BF7A208B3;
 Wed, 17 Jun 2020 10:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592390863;
 bh=6JWW2IP5OHhYePQHs/w7+V8xyYWD4Gc3HpAFhwrnPQQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=GJUFTinrfqpCCrY4NycRdNUZ2Hro8zeipOC3ZMeVPii/BDDvlXnBMP143bd1M6+3w
 jZJdMZR9Zt9pg5mpCY2oNSQW932LM+KXWtSA8g/yE6ibZpH3DnLHhf5Rx/J4TtcA8a
 KLSepr+obpjiYgiYjluC3GM0PJa+Dmzj2i7W5jug=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jlVbZ-003l3h-Ua; Wed, 17 Jun 2020 11:47:42 +0100
MIME-Version: 1.0
Date: Wed, 17 Jun 2020 11:47:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] KVM: arm64: kvm_reset_vcpu() return code incorrect with
 SVE
In-Reply-To: <20200617104339.35094-1-steven.price@arm.com>
References: <20200617104339.35094-1-steven.price@arm.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <c9761495762abe174e6546122916fc38@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: steven.price@arm.com, catalin.marinas@arm.com,
 will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Dave.Martin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

Hi Steven,

On 2020-06-17 11:43, Steven Price wrote:
> If SVE is enabled then 'ret' can be assigned the return value of
> kvm_vcpu_enable_sve() which may be 0 causing future "goto out" sites to
> erroneously return 0 on failure rather than -EINVAL as expected.
> 
> Remove the initialisation of 'ret' and make setting the return value
> explicit to avoid this situation in the future.
> 
> Fixes: 9a3cdf26e336 ("KVM: arm64/sve: Allow userspace to enable SVE for 
> vcpus")
> Reported-by: James Morse <james.morse@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> The problematic chunk isn't visible in the diff, so reproduced here:
> 
> 	if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
> 		if (test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features)) {
> 			ret = kvm_vcpu_enable_sve(vcpu);
> 			if (ret)
> 				goto out;
> 		}
> 	} else {
> 		kvm_vcpu_reset_sve(vcpu);
> 	}
> 
>  arch/arm64/kvm/reset.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index d3b209023727..f1057603b756 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -245,7 +245,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu 
> *vcpu)
>   */
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  {
> -	int ret = -EINVAL;
> +	int ret;
>  	bool loaded;
>  	u32 pstate;
> 
> @@ -269,15 +269,19 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> 
>  	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
>  	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {
> -		if (kvm_vcpu_enable_ptrauth(vcpu))
> +		if (kvm_vcpu_enable_ptrauth(vcpu)) {
> +			ret = -EINVAL;
>  			goto out;
> +		}
>  	}
> 
>  	switch (vcpu->arch.target) {
>  	default:
>  		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
> -			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
> +			if (cpus_have_const_cap(ARM64_HAS_32BIT_EL1)) {

Do you really mean this? Seems counter-productive... :-(

> +				ret = -EINVAL;
>  				goto out;
> +			}
>  			pstate = VCPU_RESET_PSTATE_SVC;
>  		} else {
>  			pstate = VCPU_RESET_PSTATE_EL1;

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
