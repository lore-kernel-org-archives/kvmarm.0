Return-Path: <SRS0=y90B=AM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D8DC433E0
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jul 2020 15:42:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 506112071A
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jul 2020 15:42:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 506112071A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=misterjones.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A33E44B34C;
	Wed,  1 Jul 2020 11:42:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3OE0WENXNn6u; Wed,  1 Jul 2020 11:42:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76A634B342;
	Wed,  1 Jul 2020 11:42:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFEF94B33F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2020 11:42:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fp74nArGEZfs for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jul 2020 11:42:10 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B44C4B33E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2020 11:42:10 -0400 (EDT)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@misterjones.org>)
 id 1jqesA-0086wK-Eg; Wed, 01 Jul 2020 16:42:06 +0100
MIME-Version: 1.0
Date: Wed, 01 Jul 2020 16:42:06 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] kvmtool: arm64: Report missing support for 32bit guests
In-Reply-To: <20200701142002.51654-1-suzuki.poulose@arm.com>
References: <20200701142002.51654-1-suzuki.poulose@arm.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <1aa7885c0d1554c8797e65b13bd05e82@misterjones.org>
X-Sender: maz@misterjones.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, kvm@vger.kernel.org,
 andre.przywara@arm.com, sami.mujawar@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, andre.przywara@arm.com,
 Sami Mujawar <sami.mujawar@arm.com>, Will Deacon <will@kernel.org>,
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

On 2020-07-01 15:20, Suzuki K Poulose wrote:
> When the host doesn't support 32bit guests, the kvmtool fails
> without a proper message on what is wrong. i.e,
> 
>  $ lkvm run -c 1 Image --aarch32
>   # lkvm run -k Image -m 256 -c 1 --name guest-105618
>   Fatal: Unable to initialise vcpu
> 
> Given that there is no other easy way to check if the host supports 
> 32bit
> guests, it is always good to report this by checking the capability, 
> rather
> than leaving the users to hunt this down by looking at the code!
> 
> After this patch:
> 
>  $ lkvm run -c 1 Image --aarch32
>   # lkvm run -k Image -m 256 -c 1 --name guest-105695
>   Fatal: 32bit guests are not supported

Fancy!

> 
> Cc: Will Deacon <will@kernel.org>
> Reported-by: Sami Mujawar <sami.mujawar@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arm/kvm-cpu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> index 554414f..2acecae 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -46,6 +46,10 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm,
> unsigned long cpu_id)
>  		.features = ARM_VCPU_FEATURE_FLAGS(kvm, cpu_id)
>  	};
> 
> +	if (kvm->cfg.arch.aarch32_guest &&
> +	    !kvm__supports_extension(kvm, KVM_CAP_ARM_EL1_32BIT))

Can you please check that this still compiles for 32bit host?

> +		die("32bit guests are not supported\n");
> +
>  	vcpu = calloc(1, sizeof(struct kvm_cpu));
>  	if (!vcpu)
>  		return NULL;

With the above detail checked,

Acked-by: Marc Zyngier <maz@kernel.org>

         M.
-- 
Who you jivin' with that Cosmik Debris?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
