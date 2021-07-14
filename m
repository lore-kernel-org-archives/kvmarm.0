Return-Path: <SRS0=5+eb=MG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E52DC07E9A
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 10:53:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A7E6F6117A
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 10:53:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7E6F6117A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 392CA4B088;
	Wed, 14 Jul 2021 06:53:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id no7JCiteWarC; Wed, 14 Jul 2021 06:53:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29CBD4A4A4;
	Wed, 14 Jul 2021 06:53:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 359C94A4A4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 06:53:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9E27m5DQuHoo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Jul 2021 06:53:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39A10407F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 06:53:45 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4320E6117A;
 Wed, 14 Jul 2021 10:53:44 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m3cWL-00DGry-4a; Wed, 14 Jul 2021 11:53:41 +0100
MIME-Version: 1.0
Date: Wed, 14 Jul 2021 11:53:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: get-reg-list: actually enable
 pmu regs in pmu sublist
In-Reply-To: <20210713203742.29680-3-drjones@redhat.com>
References: <20210713203742.29680-1-drjones@redhat.com>
 <20210713203742.29680-3-drjones@redhat.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <c06f2f53614fa7f98e33a43d117a267a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On 2021-07-13 21:37, Andrew Jones wrote:
> We reworked get-reg-list to make it easier to enable optional register
> sublists by parametrizing their vcpu feature flags as well as making
> other generalizations. That was all to make sure we enable the PMU
> registers when we want to test them. Somehow we forgot to actually
> include the PMU feature flag in the PMU sublist description though!
> Do that now.

Ah! :D

> 
> Fixes: 313673bad871 ("KVM: arm64: selftests: get-reg-list: Split base
> and pmu registers")
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index a16c8f05366c..cc898181faab 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -1019,7 +1019,8 @@ static __u64 sve_rejects_set[] = {
>  #define VREGS_SUBLIST \
>  	{ "vregs", .regs = vregs, .regs_n = ARRAY_SIZE(vregs), }
>  #define PMU_SUBLIST \
> -	{ "pmu", .regs = pmu_regs, .regs_n = ARRAY_SIZE(pmu_regs), }
> +	{ "pmu", .capability = KVM_CAP_ARM_PMU_V3, .feature = 
> KVM_ARM_VCPU_PMU_V3, \
> +	  .regs = pmu_regs, .regs_n = ARRAY_SIZE(pmu_regs), }
>  #define SVE_SUBLIST \
>  	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE,
> .finalize = true, \
>  	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \

Good timing, I'm queuing fixes. I'll pick those in a moment.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
