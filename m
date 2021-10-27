Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F81C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 07:34:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E3AEC6109E
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 07:34:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E3AEC6109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 451914B11C;
	Wed, 27 Oct 2021 03:34:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q4h4MN-01eDi; Wed, 27 Oct 2021 03:34:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C05B54B099;
	Wed, 27 Oct 2021 03:34:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C1304A193
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 03:34:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RRLbzN3OfHNW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 03:34:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FC6F49F6C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 03:34:34 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 880B060C4A;
 Wed, 27 Oct 2021 07:34:33 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mfdSB-001qke-G2; Wed, 27 Oct 2021 08:34:31 +0100
MIME-Version: 1.0
Date: Wed, 27 Oct 2021 08:34:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: Qian Cai <quic_qiancai@quicinc.com>
Subject: Re: [PATCH] KVM: arm64: Avoid shadowing a previous local
In-Reply-To: <20211027024212.64842-1-quic_qiancai@quicinc.com>
References: <20211027024212.64842-1-quic_qiancai@quicinc.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <da6be00d39c37ad26bfad9e75e814cb1@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: quic_qiancai@quicinc.com, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-10-27 03:42, Qian Cai wrote:
> It is less-prone to have a different variable name from the one in a 
> wider
> scope. This is also flagged by GCC (W=2):
> 
> In file included from ./include/linux/kvm_host.h:39,
>                  from arch/arm64/kvm/arm.c:12:
> arch/arm64/kvm/arm.c: In function 'kvm_arch_vcpu_ioctl_run':
> ./arch/arm64/include/asm/kvm_host.h:638:26: warning: declaration of
> 'ret' shadows a previous local [-Wshadow]
>   638 |   typeof(f(__VA_ARGS__)) ret;    \
>       |                          ^~~
> arch/arm64/kvm/arm.c:852:9: note: in expansion of macro 
> 'kvm_call_hyp_ret'
>   852 |   ret = kvm_call_hyp_ret(__kvm_vcpu_run, vcpu);
>       |         ^~~~~~~~~~~~~~~~
> arch/arm64/kvm/arm.c:773:6: note: shadowed declaration is here
>   773 |  int ret;
>       |      ^~~
> 
> Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index 4be8486042a7..4693d84ccd95 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -635,16 +635,16 @@ void kvm_arm_resume_guest(struct kvm *kvm);
> 
>  #define kvm_call_hyp_ret(f, ...)					\
>  	({								\
> -		typeof(f(__VA_ARGS__)) ret;				\
> +		typeof(f(__VA_ARGS__)) __ret;				\
>  									\
>  		if (has_vhe()) {					\
> -			ret = f(__VA_ARGS__);				\
> +			__ret = f(__VA_ARGS__);				\
>  			isb();						\
>  		} else {						\
> -			ret = kvm_call_hyp_nvhe(f, ##__VA_ARGS__);	\
> +			__ret = kvm_call_hyp_nvhe(f, ##__VA_ARGS__);	\
>  		}							\
>  									\
> -		ret;							\
> +		__ret;							\
>  	})
>  #else /* __KVM_NVHE_HYPERVISOR__ */
>  #define kvm_call_hyp(f, ...) f(__VA_ARGS__)

I don't think this makes much sense. This is bound to eventually clash
with another variable, and you're back to square one.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
