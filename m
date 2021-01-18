Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C7EC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 11:18:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A37E223E8
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 11:18:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A37E223E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0F1E4B1E2;
	Mon, 18 Jan 2021 06:18:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jl-+dgnbq9zE; Mon, 18 Jan 2021 06:18:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89D1C4B268;
	Mon, 18 Jan 2021 06:18:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 863D04B25A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 06:18:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8dGwhpfTlss9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 06:18:24 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 840154B1E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 06:18:24 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2481520E65;
 Mon, 18 Jan 2021 11:18:23 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l1SY8-008Sno-QZ; Mon, 18 Jan 2021 11:18:21 +0000
MIME-Version: 1.0
Date: Mon, 18 Jan 2021 11:18:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: Yejune Deng <yejune.deng@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix the return value of
 smp_call_function_single()
In-Reply-To: <20210118093137.3383-1-yejune.deng@gmail.com>
References: <20210118093137.3383-1-yejune.deng@gmail.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <af2ea1ad8df12907fa24eb4bf44c6e99@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yejune.deng@gmail.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, will@kernel.org,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-01-18 09:31, Yejune Deng wrote:
> In smp_call_function_single(), the 3rd parameter isn't the return value
> and it's always positive. But it may return a negative value. So the
> 'ret' is should be the return value of the smp_call_function_single().
> 
> In check_kvm_target_cpu(), 'phys_target' is more readable than 'ret'.
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  arch/arm64/kvm/arm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 04c44853b103..5fa5c04106de 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1815,9 +1815,9 @@ static int init_hyp_mode(void)
>  	return err;
>  }
> 
> -static void check_kvm_target_cpu(void *ret)
> +static void check_kvm_target_cpu(void *phys_target)
>  {
> -	*(int *)ret = kvm_target_cpu();
> +	*(int *)phys_target = kvm_target_cpu();
>  }
> 
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long 
> mpidr)
> @@ -1879,7 +1879,7 @@ void kvm_arch_irq_bypass_start(struct
> irq_bypass_consumer *cons)
>  int kvm_arch_init(void *opaque)
>  {
>  	int err;
> -	int ret, cpu;
> +	int ret, cpu, phys_target;
>  	bool in_hyp_mode;
> 
>  	if (!is_hyp_mode_available()) {
> @@ -1900,7 +1900,7 @@ int kvm_arch_init(void *opaque)
>  			 "Only trusted guests should be used on this system.\n");
> 
>  	for_each_online_cpu(cpu) {
> -		smp_call_function_single(cpu, check_kvm_target_cpu, &ret, 1);
> +		ret = smp_call_function_single(cpu, check_kvm_target_cpu, 
> &phys_target, 1);
>  		if (ret < 0) {
>  			kvm_err("Error, CPU %d not supported!\n", cpu);
>  			return -ENODEV;

That's not the purpose of this code. We check the target CPU
for so that we can decide to *fail* the KVM init if there is
a CPU we do not support (we definitely used to do that with
32bit), and the error message clearly states this.

So if you want to handle a cross-call failure, please do that.
But don't change the existing semantics of this code.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
