Return-Path: <SRS0=fRMP=K4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED51EC4708F
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 23:27:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 56358613E4
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 23:27:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56358613E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C662E4A483;
	Wed,  2 Jun 2021 19:27:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hf0zRWwT76PE; Wed,  2 Jun 2021 19:26:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E01D49F83;
	Wed,  2 Jun 2021 19:26:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4731540825
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 19:26:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 97fMTk5qPXcy for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Jun 2021 19:26:57 -0400 (EDT)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
 [209.85.210.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0044C406AD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 19:26:56 -0400 (EDT)
Received: by mail-pf1-f172.google.com with SMTP id t28so3427632pfg.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Jun 2021 16:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=qVLg4Q35iCp+LlhdPI9P9bXpg6OFtieobQceA0Gb/Xk=;
 b=htyn0vTZfw8IfuHoWZd5HiZ+suevAlDWCSkhs+BOEVeTFRufexfOiwfuxvpNaCtwuZ
 byqWD32hXz49RAK9QxzCF8WjQevSGmkmcx8I10QW2eyIk96oJsKZ5D7z76hRfo3wz7HI
 1Yo8K0oN+IJPB28T8p7kpxiDEcdwfLlP/N5xC+zMro9P9pJRH4AyRfuveOjPvdH33XGG
 Z3FZB8AkluzJC0xivxo5TRqN9GTxqlSH6FuHnkNLIc2xFhTenZo4+dimh+OJsvJ0dm1h
 z9XTytYXbExNzWv0Gb56M4irnma4K6JjGsy9CCnYV8FMpiEPcYfR2kMB2ObPujM1hiJc
 D9Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=qVLg4Q35iCp+LlhdPI9P9bXpg6OFtieobQceA0Gb/Xk=;
 b=qUilnvw/nZQf+Lle0Lza+tweEGRGgH5vG6uU2JFNdtdEV5gdlauGgtgsiT094MGG6z
 b0kx3tFXza1JsKgLWrjkeG6itIn2DwkIO7NYzchb3YFOD3BqLD2k6miDO5CbNHWZG3Zk
 QZ1GNAl2xVI93ZvMbCc/EyohWKwfADIp3CTS+KBZMVpmeKCELNWxA5I4euGr3YQUq939
 KQ4EiRFPAFiv19MDB2sFxVTNwc0GX/+0JNqcxIKz0aVvbYhPy7wI72WvbsC4FopHdQdK
 uh/VHa2PjtPS0dkw0mhTro1fAsDBalFM/bv9E0Q4xIipU3oJCauPt6NxmS8IlG7kqGv3
 oUmg==
X-Gm-Message-State: AOAM531OaYQMyNG9lO3zbPR7WyZ4iKZz6T+XnSd4YLrC9+wcP+LAHSJF
 BEEXBT96jBRy+H0rwllRBKrlrA==
X-Google-Smtp-Source: ABdhPJyFKVnJ0duxYPD4Y/Doon1B87bwqj4O5vlJHiiZBYmVCJxx+kLmIYEwIt97YKOsGmDPZN6lMA==
X-Received: by 2002:a63:f815:: with SMTP id n21mr37018823pgh.2.1622676415852; 
 Wed, 02 Jun 2021 16:26:55 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id o10sm536969pfh.67.2021.06.02.16.26.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Jun 2021 16:26:55 -0700 (PDT)
Date: Wed, 2 Jun 2021 16:26:51 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 5/5] KVM: arm64: selftests: get-reg-list: Split base
 and pmu registers
Message-ID: <YLgTu4EEnwfrtHSo@google.com>
References: <20210531103344.29325-1-drjones@redhat.com>
 <20210531103344.29325-6-drjones@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210531103344.29325-6-drjones@redhat.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, May 31, 2021 at 12:33:44PM +0200, Andrew Jones wrote:
> Since KVM commit 11663111cd49 ("KVM: arm64: Hide PMU registers from
> userspace when not available") the get-reg-list* tests have been
> failing with
> 
>   ...
>   ... There are 74 missing registers.
>   The following lines are missing registers:
>   ...
> 
> where the 74 missing registers are all PMU registers. This isn't a
> bug in KVM that the selftest found, even though it's true that a
> KVM userspace that wasn't setting the KVM_ARM_VCPU_PMU_V3 VCPU
> flag, but still expecting the PMU registers to be in the reg-list,
> would suddenly no longer have their expectations met. In that case,
> the expectations were wrong, though, so that KVM userspace needs to
> be fixed, and so does this selftest. The fix for this selftest is to
> pull the PMU registers out of the base register sublist into their
> own sublist and then create new, pmu-enabled vcpu configs which can
> be tested.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Ricardo Koller <ricarkol@google.com>

> ---
>  .../selftests/kvm/aarch64/get-reg-list.c      | 39 +++++++++++++++----
>  1 file changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index b46b8a1fdc0c..a16c8f05366c 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -637,7 +637,7 @@ int main(int ac, char **av)
>   * The current blessed list was primed with the output of kernel version
>   * v4.15 with --core-reg-fixup and then later updated with new registers.
>   *
> - * The blessed list is up to date with kernel version v5.10-rc5
> + * The blessed list is up to date with kernel version v5.13-rc3
>   */
>  static __u64 base_regs[] = {
>  	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[0]),
> @@ -829,8 +829,6 @@ static __u64 base_regs[] = {
>  	ARM64_SYS_REG(3, 0, 5, 2, 0),	/* ESR_EL1 */
>  	ARM64_SYS_REG(3, 0, 6, 0, 0),	/* FAR_EL1 */
>  	ARM64_SYS_REG(3, 0, 7, 4, 0),	/* PAR_EL1 */
> -	ARM64_SYS_REG(3, 0, 9, 14, 1),	/* PMINTENSET_EL1 */
> -	ARM64_SYS_REG(3, 0, 9, 14, 2),	/* PMINTENCLR_EL1 */
>  	ARM64_SYS_REG(3, 0, 10, 2, 0),	/* MAIR_EL1 */
>  	ARM64_SYS_REG(3, 0, 10, 3, 0),	/* AMAIR_EL1 */
>  	ARM64_SYS_REG(3, 0, 12, 0, 0),	/* VBAR_EL1 */
> @@ -839,6 +837,16 @@ static __u64 base_regs[] = {
>  	ARM64_SYS_REG(3, 0, 13, 0, 4),	/* TPIDR_EL1 */
>  	ARM64_SYS_REG(3, 0, 14, 1, 0),	/* CNTKCTL_EL1 */
>  	ARM64_SYS_REG(3, 2, 0, 0, 0),	/* CSSELR_EL1 */
> +	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
> +	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
> +	ARM64_SYS_REG(3, 4, 3, 0, 0),	/* DACR32_EL2 */
> +	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
> +	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
> +};
> +
> +static __u64 pmu_regs[] = {
> +	ARM64_SYS_REG(3, 0, 9, 14, 1),	/* PMINTENSET_EL1 */
> +	ARM64_SYS_REG(3, 0, 9, 14, 2),	/* PMINTENCLR_EL1 */
>  	ARM64_SYS_REG(3, 3, 9, 12, 0),	/* PMCR_EL0 */
>  	ARM64_SYS_REG(3, 3, 9, 12, 1),	/* PMCNTENSET_EL0 */
>  	ARM64_SYS_REG(3, 3, 9, 12, 2),	/* PMCNTENCLR_EL0 */
> @@ -848,8 +856,6 @@ static __u64 base_regs[] = {
>  	ARM64_SYS_REG(3, 3, 9, 13, 0),	/* PMCCNTR_EL0 */
>  	ARM64_SYS_REG(3, 3, 9, 14, 0),	/* PMUSERENR_EL0 */
>  	ARM64_SYS_REG(3, 3, 9, 14, 3),	/* PMOVSSET_EL0 */
> -	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
> -	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
>  	ARM64_SYS_REG(3, 3, 14, 8, 0),
>  	ARM64_SYS_REG(3, 3, 14, 8, 1),
>  	ARM64_SYS_REG(3, 3, 14, 8, 2),
> @@ -913,9 +919,6 @@ static __u64 base_regs[] = {
>  	ARM64_SYS_REG(3, 3, 14, 15, 5),
>  	ARM64_SYS_REG(3, 3, 14, 15, 6),
>  	ARM64_SYS_REG(3, 3, 14, 15, 7),	/* PMCCFILTR_EL0 */
> -	ARM64_SYS_REG(3, 4, 3, 0, 0),	/* DACR32_EL2 */
> -	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
> -	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
>  };
>  
>  static __u64 vregs[] = {
> @@ -1015,6 +1018,8 @@ static __u64 sve_rejects_set[] = {
>  	{ "base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), }
>  #define VREGS_SUBLIST \
>  	{ "vregs", .regs = vregs, .regs_n = ARRAY_SIZE(vregs), }
> +#define PMU_SUBLIST \
> +	{ "pmu", .regs = pmu_regs, .regs_n = ARRAY_SIZE(pmu_regs), }
>  #define SVE_SUBLIST \
>  	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE, .finalize = true, \
>  	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \
> @@ -1027,6 +1032,14 @@ static struct vcpu_config vregs_config = {
>  	{0},
>  	},
>  };
> +static struct vcpu_config vregs_pmu_config = {
> +	.sublists = {
> +	BASE_SUBLIST,
> +	VREGS_SUBLIST,
> +	PMU_SUBLIST,
> +	{0},
> +	},
> +};
>  static struct vcpu_config sve_config = {
>  	.sublists = {
>  	BASE_SUBLIST,
> @@ -1034,9 +1047,19 @@ static struct vcpu_config sve_config = {
>  	{0},
>  	},
>  };
> +static struct vcpu_config sve_pmu_config = {
> +	.sublists = {
> +	BASE_SUBLIST,
> +	SVE_SUBLIST,
> +	PMU_SUBLIST,
> +	{0},
> +	},
> +};
>  
>  static struct vcpu_config *vcpu_configs[] = {
>  	&vregs_config,
> +	&vregs_pmu_config,
>  	&sve_config,
> +	&sve_pmu_config,
>  };
>  static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
> -- 
> 2.31.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
