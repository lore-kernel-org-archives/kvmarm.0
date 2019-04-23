Return-Path: <SRS0=x1Dw=SZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4991C282DD
	for <kvmarm@archiver.kernel.org>; Tue, 23 Apr 2019 15:45:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 73C6B217D9
	for <kvmarm@archiver.kernel.org>; Tue, 23 Apr 2019 15:45:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73C6B217D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DCDF4A4C5;
	Tue, 23 Apr 2019 11:45:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lmnOHLwR8FnD; Tue, 23 Apr 2019 11:45:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC6034A3B4;
	Tue, 23 Apr 2019 11:45:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F27D94A418
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Apr 2019 11:45:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oNmiq9uDZFOx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Apr 2019 11:45:38 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 816AD4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Apr 2019 11:45:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F11D180D;
 Tue, 23 Apr 2019 08:45:37 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 426B23F5AF;
 Tue, 23 Apr 2019 08:45:36 -0700 (PDT)
Date: Tue, 23 Apr 2019 16:45:33 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v10 4/5] KVM: arm64: Add capability to advertise ptrauth
 for guest
Message-ID: <20190423154533.GO3567@e103592.cambridge.arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-5-git-send-email-amit.kachhap@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1555994558-26349-5-git-send-email-amit.kachhap@arm.com>
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
Message-ID: <20190423154533.aJUMaKjv8XkyOM3yY8Jl1YN87oM83T-g_U61eNpdxvk@z>

On Tue, Apr 23, 2019 at 10:12:37AM +0530, Amit Daniel Kachhap wrote:
> This patch advertises the capability of two cpu feature called address
> pointer authentication and generic pointer authentication. These
> capabilities depend upon system support for pointer authentication and
> VHE mode.
> 
> The current arm64 KVM partially implements pointer authentication and
> support of address/generic authentication are tied together. However,
> separate ABI requirements for both of them is added so that any future
> isolated implementation will not require any ABI changes.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
> Changes since v9:
> * Fixed tab alignment issues [Dave Martin].
> * Clarify the api documentation [Dave Martin].
> 
>  Documentation/virtual/kvm/api.txt | 14 ++++++++++----
>  arch/arm64/kvm/reset.c            |  5 +++++
>  include/uapi/linux/kvm.h          |  2 ++
>  3 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 32afe7f..fac1887 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2763,13 +2763,19 @@ Possible features:
>  
>  	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
>  	  for arm64 only.
> -	  Both KVM_ARM_VCPU_PTRAUTH_ADDRESS and KVM_ARM_VCPU_PTRAUTH_GENERIC
> -	  must be requested or neither must be requested.
> +	  Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
> +	  If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
> +	  both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
> +	  KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
> +	  requested.
>  
>  	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
>  	  for arm64 only.
> -	  Both KVM_ARM_VCPU_PTRAUTH_ADDRESS and KVM_ARM_VCPU_PTRAUTH_GENERIC
> -	  must be requested or neither must be requested.
> +	  Depends on KVM_CAP_ARM_PTRAUTH_GENERIC.
> +	  If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
> +	  both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
> +	  KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
> +	  requested.

This looks clear now.

The description is quite heavyweight, but should be hard for people to
misunderstand.

>  	- KVM_ARM_VCPU_SVE: Enables SVE for the CPU (arm64 only).
>  	  Depends on KVM_CAP_ARM_SVE.
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 028d0c6..f0faf54 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -101,6 +101,11 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_SVE:
>  		r = system_supports_sve();
>  		break;
> +	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
> +	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> +		r = has_vhe() && system_supports_address_auth() &&
> +				 system_supports_generic_auth();
> +		break;
>  	default:
>  		r = 0;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 1d56444..4dc34f8 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -989,6 +989,8 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
>  #define KVM_CAP_HYPERV_CPUID 167
>  #define KVM_CAP_ARM_SVE 168
> +#define KVM_CAP_ARM_PTRAUTH_ADDRESS 169
> +#define KVM_CAP_ARM_PTRAUTH_GENERIC 170

[...]

Reviewed-by: Dave Martin <Dave.Martin@arm.com>

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
