Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E2DC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 17:17:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BBA7264EE7
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 17:17:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBA7264EE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DB2A4B675;
	Wed, 17 Mar 2021 13:17:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c-2QgG90yUqW; Wed, 17 Mar 2021 13:17:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AF814B686;
	Wed, 17 Mar 2021 13:17:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 932724B675
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 13:17:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OKdV-b5K+1tM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 13:17:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A18054B51C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 13:17:45 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87EA864DDA;
 Wed, 17 Mar 2021 17:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616001464;
 bh=f3UV9P1ez1H29l2EmF0j0dk0b+DNBxiRJEGlA20Jt7M=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=qCOwbD4OrXNYihuHcVUWjgB96Cox8G+wQdO8UjpBecet6+c9mVYfBWE96NBhWa6KF
 N6rOyg/RIK28DWvYCjPAudJELrpnPW1bAUnQLHffda+AOY8HGbiJtvdkP2ke8H1Xrw
 iDYaQo27HauVEDJGrIzwEX6gwTb+qGumbdqXvjgRDpqssM8VxiCBzYBLP++jIhfbP4
 iPWbrNEIQw7x9Ojg15j2CFxtbLMQGj+SweOWIkh7FqJmygEPPifeSbcmZAL8Afu481
 BdeP8Ml9tx/JhvR/YwDSJL0ojBN4XRFXsyrGmJicZM8LxBiqiLu9et1MjsX9SjRdXq
 aFC62mSOLlFDw==
Date: Wed, 17 Mar 2021 17:17:39 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 07/10] KVM: arm64: Save guest's ZCR_EL1 before saving the
 FPSIMD state
Message-ID: <20210317171738.GA5640@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-8-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-8-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, broonie@kernel.org, kernel-team@android.com,
 dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, daniel.kiss@arm.com
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

On Tue, Mar 16, 2021 at 10:13:09AM +0000, Marc Zyngier wrote:
> Make sure the guest's ZCR_EL1 is saved before we save/flush the
> state. This will be useful in later patches.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 84afca5ed6f2..b5f95abd23f5 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -121,10 +121,10 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  	local_irq_save(flags);
>  
>  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> -		fpsimd_save_and_flush_cpu_state();
> -
>  		if (guest_has_sve)
>  			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
> +
> +		fpsimd_save_and_flush_cpu_state();

I _think_ fpsimd_save_and_flush_cpu_state() contains a RDVL instruction
to get at the vector length for sve_get_vl(), and this ends up reading from
ZCR_EL1. So I'm not sure it's save to move it like this.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
