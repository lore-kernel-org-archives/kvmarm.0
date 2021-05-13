Return-Path: <SRS0=4nKG=KI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38595C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 11:14:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 777AA611CA
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 11:14:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 777AA611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2C554B8AE;
	Thu, 13 May 2021 07:14:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gqag5rFZOwIf; Thu, 13 May 2021 07:14:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB8634B754;
	Thu, 13 May 2021 07:14:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 889E64B74F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 07:14:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yttr8U9vkk7M for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 May 2021 07:14:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5606A4B739
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 07:14:25 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 448E7613CB;
 Thu, 13 May 2021 11:14:24 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lh9IM-001C2V-Cr; Thu, 13 May 2021 12:14:22 +0100
MIME-Version: 1.0
Date: Thu, 13 May 2021 12:14:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Request PMU feature in get-reg-list
In-Reply-To: <20210513130655.73154-1-gshan@redhat.com>
References: <20210513130655.73154-1-gshan@redhat.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <d717b9272cce16c62a4e3e671bb1f068@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gshan@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, drjones@redhat.com,
 pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
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

On 2021-05-13 14:06, Gavin Shan wrote:
> Since the following commit, PMU registers are hidden from user until
> it's explicitly requested by feeding feature (KVM_ARM_VCPU_PMU_V3).
> Otherwise, 74 missing PMU registers are missing as the following
> log indicates.
> 
>    11663111cd49 ("KVM: arm64: Hide PMU registers from userspace when
> not available")
> 
>    # ./get-reg-list
>    Number blessed registers:   308
>    Number registers:           238
> 
>    There are 74 missing registers.
>    The following lines are missing registers:
> 
>       	ARM64_SYS_REG(3, 0, 9, 14, 1),
> 	ARM64_SYS_REG(3, 0, 9, 14, 2),
>              :
> 	ARM64_SYS_REG(3, 3, 14, 15, 7),
> 
> This fixes the issue of wrongly reported missing PMU registers by
> requesting it explicitly.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index 486932164cf2..6c6bdc6f5dc3 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -314,6 +314,8 @@ static void core_reg_fixup(void)
> 
>  static void prepare_vcpu_init(struct kvm_vcpu_init *init)
>  {
> +	init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
> +
>  	if (reg_list_sve())
>  		init->features[0] |= 1 << KVM_ARM_VCPU_SVE;
>  }

Please see Andrew's series[1], which actually deals with options.

         M.

[1] https://lore.kernel.org/r/20210507200416.198055-1-drjones@redhat.com
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
