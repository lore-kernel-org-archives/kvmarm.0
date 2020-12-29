Return-Path: <SRS0=Fui2=GB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E39D1C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 29 Dec 2020 17:16:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5BA9922209
	for <kvmarm@archiver.kernel.org>; Tue, 29 Dec 2020 17:16:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BA9922209
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6B004B2A2;
	Tue, 29 Dec 2020 12:16:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 47mofchRaDbk; Tue, 29 Dec 2020 12:16:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 843164B26D;
	Tue, 29 Dec 2020 12:16:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 017224B25A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 12:16:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jTt07kiLQPKF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Dec 2020 12:16:45 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6D1C4B24E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Dec 2020 12:16:44 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CC47A21D94;
 Tue, 29 Dec 2020 17:16:43 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kuIbx-004Ri2-Kb; Tue, 29 Dec 2020 17:16:41 +0000
MIME-Version: 1.0
Date: Tue, 29 Dec 2020 17:16:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH] KVM: arm64: Allow PSCI SYSTEM_OFF/RESET to return
In-Reply-To: <20201229160059.64135-1-dbrazdil@google.com>
References: <20201229160059.64135-1-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <229d84b8d7818a170adf489535ea2d43@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 lorenzo.pieralisi@arm.com, sudeep.holla@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Sudeep Holla <sudeep.holla@arm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Hi David,

On 2020-12-29 16:00, David Brazdil wrote:
> The KVM/arm64 PSCI relay assumes that SYSTEM_OFF and SYSTEM_RESET 
> should
> not return, as dictated by the PSCI spec. However, there is firmware 
> out
> there which breaks this assumption, leading to a hyp panic. Make KVM
> more robust to broken firmware by allowing these to return.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/psci-relay.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> index e3947846ffcb..8e7128cb7667 100644
> --- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> +++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> @@ -77,12 +77,6 @@ static unsigned long psci_forward(struct
> kvm_cpu_context *host_ctxt)
>  			 cpu_reg(host_ctxt, 2), cpu_reg(host_ctxt, 3));
>  }
> 
> -static __noreturn unsigned long psci_forward_noreturn(struct
> kvm_cpu_context *host_ctxt)
> -{
> -	psci_forward(host_ctxt);
> -	hyp_panic(); /* unreachable */
> -}
> -
>  static unsigned int find_cpu_id(u64 mpidr)
>  {
>  	unsigned int i;
> @@ -251,10 +245,13 @@ static unsigned long psci_0_2_handler(u64
> func_id, struct kvm_cpu_context *host_
>  	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
>  	case PSCI_0_2_FN64_MIGRATE_INFO_UP_CPU:
>  		return psci_forward(host_ctxt);
> +	/*
> +	 * SYSTEM_OFF/RESET should not return according to the spec.
> +	 * Allow it so as to stay robust to broken firmware.
> +	 */
>  	case PSCI_0_2_FN_SYSTEM_OFF:
>  	case PSCI_0_2_FN_SYSTEM_RESET:
> -		psci_forward_noreturn(host_ctxt);
> -		unreachable();
> +		return psci_forward(host_ctxt);
>  	case PSCI_0_2_FN64_CPU_SUSPEND:
>  		return psci_cpu_suspend(func_id, host_ctxt);
>  	case PSCI_0_2_FN64_CPU_ON:

Thanks for having tracked this.

I wonder whether we should also taint the kernel in this case,
because this is completely unexpected, and a major spec violation.

Ideally, we'd be able to detect this case and prevent pKVM from
getting initialised at all, but I guess there is no way to detect
the sucker without ... calling SYSTEM_RESET?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
