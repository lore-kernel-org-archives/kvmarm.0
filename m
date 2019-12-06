Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C34C43603
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 10:35:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E71B62173E
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 10:35:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E71B62173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64CEB4AF0E;
	Fri,  6 Dec 2019 05:35:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZQCb5BtL3kyV; Fri,  6 Dec 2019 05:35:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46A5F4AF15;
	Fri,  6 Dec 2019 05:35:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3A544AF0E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 05:35:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kbyiTAw5UW4z for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 05:35:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C136B4AF0C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 05:35:08 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D2181FB;
 Fri,  6 Dec 2019 02:35:08 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A7783F718;
 Fri,  6 Dec 2019 02:35:07 -0800 (PST)
Date: Fri, 6 Dec 2019 10:35:05 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [RFC 1/3] KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is
 unset
Message-ID: <20191206103505.GM18399@e119886-lin.cambridge.arm.com>
References: <20191204204426.9628-1-eric.auger@redhat.com>
 <20191204204426.9628-2-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191204204426.9628-2-eric.auger@redhat.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Dec 04, 2019 at 09:44:24PM +0100, Eric Auger wrote:
> The specification says PMSWINC increments PMEVCNTR<n>_EL1 by 1
> if PMEVCNTR<n>_EL0 is enabled and configured to count SW_INCR.
> 
> For PMEVCNTR<n>_EL0 to be enabled, we need both PMCNTENSET to
> be set for the corresponding event counter but we also need
> the PMCR.E bit to be set.
> 
> Fixes: 7a0adc7064b8 ("arm64: KVM: Add access handler for PMSWINC register")
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  virt/kvm/arm/pmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 8731dfeced8b..c3f8b059881e 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -486,6 +486,9 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
>  	if (val == 0)
>  		return;
>  
> +	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> +		return;
> +

Reviewed-by: Andrew Murray <andrew.murray@arm.com>


>  	enable = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
>  	for (i = 0; i < ARMV8_PMU_CYCLE_IDX; i++) {
>  		if (!(val & BIT(i)))
> -- 
> 2.20.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
