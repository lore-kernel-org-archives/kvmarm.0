Return-Path: <SRS0=JhHZ=SS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97218C10F14
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 16:31:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3983820880
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 16:31:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3983820880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B55F94A4B0;
	Tue, 16 Apr 2019 12:31:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VwaBgdfbsHdu; Tue, 16 Apr 2019 12:30:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81E4D4A4AD;
	Tue, 16 Apr 2019 12:30:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A95494A4B0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 12:30:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HLR3e33GVWRu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Apr 2019 12:30:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30F984A4A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 12:30:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A27E015A2;
 Tue, 16 Apr 2019 09:30:54 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 04FD13F59C;
 Tue, 16 Apr 2019 09:30:52 -0700 (PDT)
Date: Tue, 16 Apr 2019 17:30:50 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v9 1/5] KVM: arm64: Add a vcpu flag to control ptrauth
 for guest
Message-ID: <20190416163050.GV3567@e103592.cambridge.arm.com>
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-2-git-send-email-amit.kachhap@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1555039236-10608-2-git-send-email-amit.kachhap@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190416163050.yKqfugy3q6yVfOi9VXsJ2ldkHB6ljZyNQFLPvBCYFoM@z>

On Fri, Apr 12, 2019 at 08:50:32AM +0530, Amit Daniel Kachhap wrote:
> A per vcpu flag is added to check if pointer authentication is
> enabled for the vcpu or not. This flag may be enabled according to
> the necessary user policies and host capabilities.
> 
> This patch also adds a helper to check the flag.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu

Reviewed-by: Dave Martin <Dave.Martin@arm.com>

> ---
> 
> Changes since v8:
> * Added a new per vcpu flag which will store Pointer Authentication enable
>   status instead of checking them again. [Dave Martin]
> 
>  arch/arm64/include/asm/kvm_host.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9d57cf8..31dbc7c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -355,10 +355,14 @@ struct kvm_vcpu_arch {
>  #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
>  #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
>  #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
> +#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
>  
>  #define vcpu_has_sve(vcpu) (system_supports_sve() && \
>  			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
>  
> +#define vcpu_has_ptrauth(vcpu)	\
> +			((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
> +
>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
>  
>  /*
> -- 
> 2.7.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
