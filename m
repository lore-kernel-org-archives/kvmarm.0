Return-Path: <SRS0=2z/n=4T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7043DC3F2D2
	for <kvmarm@archiver.kernel.org>; Mon,  2 Mar 2020 10:50:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EEF9921D56
	for <kvmarm@archiver.kernel.org>; Mon,  2 Mar 2020 10:50:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="apw35yfz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEF9921D56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94D1B4AF7F;
	Mon,  2 Mar 2020 05:50:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hCoU5HvKp-2d; Mon,  2 Mar 2020 05:50:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BAAA4AF8C;
	Mon,  2 Mar 2020 05:50:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1146D4AF7F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2020 05:50:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4WdG1cDIFMxp for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2020 05:50:19 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 107574AEDD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2020 05:50:19 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C040621D56;
 Mon,  2 Mar 2020 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1583146217;
 bh=QKkxS8WJjpnmKv55PdXHGXEQzRWU0qw/v6LjAUUYwkc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=apw35yfzM2zjjkMW9To2es0BRLYBHJkMuR74KOS1gavu46sF8VomI0v9ERJ1AdxEf
 z9cq7bbSp3IHagBY9cF40MsPOULuh8Mk25sHzsBUSkltrEu1cL3xhZH8r0au7VoJkD
 MS0xUlrCLV7UOzug/UkAQCqFyQ7Vqggwt3QOllK0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j8ieO-009M1L-3I; Mon, 02 Mar 2020 10:50:16 +0000
MIME-Version: 1.0
Date: Mon, 02 Mar 2020 10:50:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2] KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is
 unset
In-Reply-To: <20200302104830.5593-1-eric.auger@redhat.com>
References: <20200302104830.5593-1-eric.auger@redhat.com>
Message-ID: <50e04eb9bcd607c6729919d70ae7e82f@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, eric.auger.pro@gmail.com,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, eric.auger.pro@gmail.com
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

On 2020-03-02 10:48, Eric Auger wrote:
> commit 3837407c1aa1 upstream.
> 
> The specification says PMSWINC increments PMEVCNTR<n>_EL1 by 1
> if PMEVCNTR<n>_EL0 is enabled and configured to count SW_INCR.
> 
> For PMEVCNTR<n>_EL0 to be enabled, we need both PMCNTENSET to
> be set for the corresponding event counter but we also need
> the PMCR.E bit to be set.
> 
> Fixes: 7a0adc7064b8 ("arm64: KVM: Add access handler for PMSWINC 
> register")
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Cc: <stable@vger.kernel.org> # 4.9 and 4.14 only

Reviewed-by: Marc Zyngier <maz@kernel.org>

> 
> ---
> 
> This is a backport of 3837407c1aa1 ("KVM: arm64: pmu: Don't
> increment SW_INCR if PMCR.E is unset") which did not apply on
> 4.9-stable and 4.14-stable trees. Compared to the original patch
> __vcpu_sys_reg() is replaced by vcpu_sys_reg().
> 
> v1 -> v2:
> - this patch also is candidate for 4.9-stable
> ---
>  virt/kvm/arm/pmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 69ccce308458..9a47b0cfb01d 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -299,6 +299,9 @@ void kvm_pmu_software_increment(struct kvm_vcpu
> *vcpu, u64 val)
>  	if (val == 0)
>  		return;
> 
> +	if (!(vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> +		return;
> +
>  	enable = vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
>  	for (i = 0; i < ARMV8_PMU_CYCLE_IDX; i++) {
>  		if (!(val & BIT(i)))

-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
