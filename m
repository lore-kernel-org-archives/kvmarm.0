Return-Path: <SRS0=hjn/=55=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8171BC2BBC7
	for <kvmarm@archiver.kernel.org>; Mon, 13 Apr 2020 08:56:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 133A520775
	for <kvmarm@archiver.kernel.org>; Mon, 13 Apr 2020 08:56:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AqkvWJwn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 133A520775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EEDB4B1B8;
	Mon, 13 Apr 2020 04:56:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yzqFrVuWrwYG; Mon, 13 Apr 2020 04:56:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D55E4B1BD;
	Mon, 13 Apr 2020 04:56:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BAA14B13B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 04:56:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P6QlsGLhfzpI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2020 04:56:20 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F76D4B0D3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 04:56:20 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 46B5920692;
 Mon, 13 Apr 2020 08:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586768179;
 bh=GyaHe3+UWAOxENedBfck6FDz0o/OWfUlsXv987iJQNY=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=AqkvWJwnZMdH4yXR42mVJxFY/122uUYZTeh7KQvVG+ONwnyKmUxp9fytp/Gh8FWWT
 AI4cBPOoNZVA6p9TtCZIWKf00hKXhEUZB/OdlcC0LTrjyfenJ6jTsMxmZad3EKR4Ht
 PvT2YKdfwvlUky+dnidjFPIYDuwnuPS8JBFpAneI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jNut7-002oec-J1; Mon, 13 Apr 2020 09:56:17 +0100
MIME-Version: 1.0
Date: Mon, 13 Apr 2020 09:56:17 +0100
From: Marc Zyngier <maz@kernel.org>
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: Re: [PATCH] KVM: Optimize kvm_arch_vcpu_ioctl_run function
In-Reply-To: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
References: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
Message-ID: <17097df45c7fe76ee3c09ac180b844d2@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: tianjia.zhang@linux.alibaba.com, pbonzini@redhat.com,
 sean.j.christopherson@intel.com, vkuznets@redhat.com, wanpengli@tencent.com,
 jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
 kvmarm@lists.cs.columbia.edu, mingo@redhat.com, bp@alien8.de,
 linux-arm-kernel@lists.infradead.org, hpa@zytor.com, pbonzini@redhat.com,
 vkuznets@redhat.com, tglx@linutronix.de, jmattson@google.com
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

Tianjia,

On 2020-04-13 04:45, Tianjia Zhang wrote:
> kvm_arch_vcpu_ioctl_run() is only called in the file kvm_main.c,
> where vcpu->run is the kvm_run parameter, so it has been replaced.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++++----
>  virt/kvm/arm/arm.c | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3bf2ecafd027..70e3f4abbd4d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8726,18 +8726,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu
> *vcpu, struct kvm_run *kvm_run)
>  		r = -EAGAIN;
>  		if (signal_pending(current)) {
>  			r = -EINTR;
> -			vcpu->run->exit_reason = KVM_EXIT_INTR;
> +			kvm_run->exit_reason = KVM_EXIT_INTR;
>  			++vcpu->stat.signal_exits;
>  		}
>  		goto out;
>  	}
> 
> -	if (vcpu->run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
> +	if (kvm_run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
>  		r = -EINVAL;
>  		goto out;
>  	}
> 
> -	if (vcpu->run->kvm_dirty_regs) {
> +	if (kvm_run->kvm_dirty_regs) {
>  		r = sync_regs(vcpu);
>  		if (r != 0)
>  			goto out;
> @@ -8767,7 +8767,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu
> *vcpu, struct kvm_run *kvm_run)
> 
>  out:
>  	kvm_put_guest_fpu(vcpu);
> -	if (vcpu->run->kvm_valid_regs)
> +	if (kvm_run->kvm_valid_regs)
>  		store_regs(vcpu);
>  	post_kvm_run_save(vcpu);
>  	kvm_sigset_deactivate(vcpu);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 48d0ec44ad77..ab9d7966a4c8 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -659,7 +659,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu,
> struct kvm_run *run)
>  		return ret;
> 
>  	if (run->exit_reason == KVM_EXIT_MMIO) {
> -		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
> +		ret = kvm_handle_mmio_return(vcpu, run);
>  		if (ret)
>  			return ret;
>  	}

Do you have any number supporting the idea that you are optimizing 
anything
here? Performance, code size, register pressure or any other relevant 
metric?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
