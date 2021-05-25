Return-Path: <SRS0=drPj=KU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7B0C47086
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 20:09:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 58EB861358
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 20:09:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58EB861358
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB5074A51D;
	Tue, 25 May 2021 16:09:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E53zXKkrlUob; Tue, 25 May 2021 16:09:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4850D4A522;
	Tue, 25 May 2021 16:09:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B79A84A49C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 16:09:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jT3WRQ0wHIhf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 May 2021 16:09:29 -0400 (EDT)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C3F84A3A5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 16:09:28 -0400 (EDT)
Received: by mail-pl1-f181.google.com with SMTP id v12so16931462plo.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 13:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=LKTAzky6OnQfWFPc/ks6JLApRnlm2Aj8jp5bTBQVbSQ=;
 b=Js3TO7dcEWXmAVjv24/ACwJAnm1A/bbDz7TzjY1Hue5GMQFe5YmV3TaOsabVB0NUyw
 kCFd/qcCLfGH2F5aOapzj6Iw6/Bjn0xYtClXrsm8bOSDgIGs77CyU/s/2UqzqpaiLaDx
 apftFdgLas83VnaQl0uzBLjzFwAMJ8yhpYJBqS3k7vQlNXmiQhYJBe0SeW8tWgtnAket
 v67i2Uu1cO6yVJdyH5LtPQ18zMfA59UeugErYCTIEQN2USzKUczsBCNawTOmaqey/7wx
 Vqqd2XGOj6jDeR2cRkkyii+jEQ7z5Hxt6Jun0iI3XjBYD2qxvp+BUh6E/KkBn+Nvg1fq
 LKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=LKTAzky6OnQfWFPc/ks6JLApRnlm2Aj8jp5bTBQVbSQ=;
 b=m5iZIH9uh/not2jOSEnU5Jozv1yksmwP1lOZmOUWkac8znGTrE1B6bZ8I9tApcI0uP
 StDQAVTYB1naYluY+Tda2MeiSs7TdJV+xDzNficoHVpXbvia0b8NwgLsk38S0VLrk7/w
 X0zxp3MrWLiXLeKzkPTsCw5ItLcYloma9yq3Tuj9976bTtd7Y2g35wD0+XRu4LiZtYPY
 MU9vYjic/2gHR0sPYHV4TGprdUk/xrw9PKVFN3aR3EQvmunqiKtyDwm9/K8M4kBblbOZ
 RPqDdjXwnEnkZXqY6tCh6HgpksiKkbUWKmO2HY5X577RzbbmamGA7wkUc0/JgCmw8NrL
 d0kg==
X-Gm-Message-State: AOAM531HrjQIqC5gl8NK+E/odjOSmgrAuNqZJTf8qB6zeRl5s36LI0Vw
 EKheNeC9hYobMqJoaGRkdsCstA==
X-Google-Smtp-Source: ABdhPJxCaCitapY9QA5HhLPU6O8Ne0GfT4ynCGVVn3UHDyNNW2yqwxt8jOiu4nL7gsS4D/La/sxMcg==
X-Received: by 2002:a17:90b:128d:: with SMTP id
 fw13mr27875pjb.211.1621973367122; 
 Tue, 25 May 2021 13:09:27 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id a129sm14808054pfa.36.2021.05.25.13.09.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 25 May 2021 13:09:26 -0700 (PDT)
Date: Tue, 25 May 2021 13:09:22 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 5/5] KVM: arm64: selftests: get-reg-list: Split base
 and pmu registers
Message-ID: <YK1ZcqgyLFSDH14+@google.com>
References: <20210519140726.892632-1-drjones@redhat.com>
 <20210519140726.892632-6-drjones@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210519140726.892632-6-drjones@redhat.com>
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

On Wed, May 19, 2021 at 04:07:26PM +0200, Andrew Jones wrote:
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
> ---
>  .../selftests/kvm/aarch64/get-reg-list.c      | 46 +++++++++++++++----
>  1 file changed, 38 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index dc06a28bfb74..78d8949bddbd 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -47,6 +47,7 @@ struct reg_sublist {
>  struct vcpu_config {
>  	const char *name;
>  	bool sve;
> +	bool pmu;
>  	struct reg_sublist sublists[];
>  };

I think it's possible that the number of sublists keeps increasing: it
would be very nice/useful if KVM allowed enabling/disabling more
features from userspace (besides SVE, PMU etc). In that case, it might
be easier if adding a new feature to get-reg-list just requires defining
a new config and not dealing with the internals of vcpu_config.

Do you think it's possible in general to associate a sublist to a
capability and a feature? It works for the PMU and SVE. If that is
possible, what do you think of something like this? this would be the
config for sve+pmu:

static struct vcpu_config sve_pmu_config = {
      "sve+pmu",
       .sublists = {
       { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
       { "sve", false, KVM_ARM_VCPU_SVE, KVM_CAP_ARM_SVE, true, sve_regs, ARRAY_SIZE(sve_regs), sve_rejects_set, ARRAY_SIZE(sve_rejects_set), },
       { "pmu", false, KVM_ARM_VCPU_PMU_V3, KVM_CAP_ARM_PMU_V3, false, pmu_regs, ARRAY_SIZE(pmu_regs), },
       {0},
       },
};

Appended a rough patch at the end to make this idea more concrete.

Thanks,
Ricardo

>  
> @@ -328,6 +329,8 @@ static void prepare_vcpu_init(struct vcpu_config *c, struct kvm_vcpu_init *init)
>  {
>  	if (c->sve)
>  		init->features[0] |= 1 << KVM_ARM_VCPU_SVE;
> +	if (c->pmu)
> +		init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
>  }
>  
>  static void finalize_vcpu(struct kvm_vm *vm, uint32_t vcpuid, struct vcpu_config *c)
> @@ -346,6 +349,10 @@ static void check_supported(struct vcpu_config *c)
>  		fprintf(stderr, "%s: SVE not available, skipping tests\n", c->name);
>  		exit(KSFT_SKIP);
>  	}
> +	if (c->pmu && !kvm_check_cap(KVM_CAP_ARM_PMU_V3)) {
> +		fprintf(stderr, "%s: PMU not available, skipping tests\n", c->name);
> +		exit(KSFT_SKIP);
> +	}
>  }
>  
>  static bool print_list;
> @@ -588,7 +595,7 @@ int main(int ac, char **av)
>   * The current blessed list was primed with the output of kernel version
>   * v4.15 with --core-reg-fixup and then later updated with new registers.
>   *
> - * The blessed list is up to date with kernel version v5.10-rc5
> + * The blessed list is up to date with kernel version 5.13.0-rc2
>   */
>  static __u64 base_regs[] = {
>  	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[0]),
> @@ -780,8 +787,6 @@ static __u64 base_regs[] = {
>  	ARM64_SYS_REG(3, 0, 5, 2, 0),	/* ESR_EL1 */
>  	ARM64_SYS_REG(3, 0, 6, 0, 0),	/* FAR_EL1 */
>  	ARM64_SYS_REG(3, 0, 7, 4, 0),	/* PAR_EL1 */
> -	ARM64_SYS_REG(3, 0, 9, 14, 1),	/* PMINTENSET_EL1 */
> -	ARM64_SYS_REG(3, 0, 9, 14, 2),	/* PMINTENCLR_EL1 */
>  	ARM64_SYS_REG(3, 0, 10, 2, 0),	/* MAIR_EL1 */
>  	ARM64_SYS_REG(3, 0, 10, 3, 0),	/* AMAIR_EL1 */
>  	ARM64_SYS_REG(3, 0, 12, 0, 0),	/* VBAR_EL1 */
> @@ -790,6 +795,16 @@ static __u64 base_regs[] = {
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
> @@ -799,8 +814,6 @@ static __u64 base_regs[] = {
>  	ARM64_SYS_REG(3, 3, 9, 13, 0),	/* PMCCNTR_EL0 */
>  	ARM64_SYS_REG(3, 3, 9, 14, 0),	/* PMUSERENR_EL0 */
>  	ARM64_SYS_REG(3, 3, 9, 14, 3),	/* PMOVSSET_EL0 */
> -	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
> -	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
>  	ARM64_SYS_REG(3, 3, 14, 8, 0),
>  	ARM64_SYS_REG(3, 3, 14, 8, 1),
>  	ARM64_SYS_REG(3, 3, 14, 8, 2),
> @@ -864,9 +877,6 @@ static __u64 base_regs[] = {
>  	ARM64_SYS_REG(3, 3, 14, 15, 5),
>  	ARM64_SYS_REG(3, 3, 14, 15, 6),
>  	ARM64_SYS_REG(3, 3, 14, 15, 7),	/* PMCCFILTR_EL0 */
> -	ARM64_SYS_REG(3, 4, 3, 0, 0),	/* DACR32_EL2 */
> -	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
> -	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
>  };
>  
>  static __u64 vregs[] = {
> @@ -970,6 +980,15 @@ static struct vcpu_config vregs_config = {
>  	{0},
>  	},
>  };
> +static struct vcpu_config vregs_pmu_config = {
> +	"vregs+pmu", .pmu = true,
> +	.sublists = {
> +	{ base_regs,	ARRAY_SIZE(base_regs), },
> +	{ vregs,	ARRAY_SIZE(vregs), },
> +	{ pmu_regs,	ARRAY_SIZE(pmu_regs), },
> +	{0},
> +	},
> +};
>  static struct vcpu_config sve_config = {
>  	"sve", .sve = true,
>  	.sublists = {
> @@ -978,9 +997,20 @@ static struct vcpu_config sve_config = {
>  	{0},
>  	},
>  };
> +static struct vcpu_config sve_pmu_config = {
> +	"sve+pmu", .sve = true, .pmu = true,
> +	.sublists = {
> +	{ base_regs,	ARRAY_SIZE(base_regs), },
> +	{ sve_regs,	ARRAY_SIZE(sve_regs),	sve_rejects_set,	ARRAY_SIZE(sve_rejects_set), },
> +	{ pmu_regs,	ARRAY_SIZE(pmu_regs), },
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
> 2.30.2
>

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 78d8949bddbd..33b8735bdb15 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -38,6 +38,11 @@ static struct kvm_reg_list *reg_list;
 static __u64 *blessed_reg, blessed_n;
 
 struct reg_sublist {
+       const char *name;
+       bool base;
+       int feature;
+       int capability;
+       bool finalize;
        __u64 *regs;
        __u64 regs_n;
        __u64 *rejects_set;
@@ -46,8 +51,6 @@ struct reg_sublist {
 
 struct vcpu_config {
        const char *name;
-       bool sve;
-       bool pmu;
        struct reg_sublist sublists[];
 };
 
@@ -257,10 +260,7 @@ static void print_reg(struct vcpu_config *c, __u64 id)
                printf("\tKVM_REG_ARM_FW_REG(%lld),\n", id & 0xffff);
                break;
        case KVM_REG_ARM64_SVE:
-               if (c->sve)
-                       printf("\t%s,\n", sve_id_to_str(c, id));
-               else
-                       TEST_FAIL("%s: KVM_REG_ARM64_SVE is an unexpected coproc type in reg id: 0x%llx", c->name, id);
+               printf("\t%s,\n", sve_id_to_str(c, id));
                break;
        default:
                TEST_FAIL("%s: Unexpected coproc type: 0x%llx in reg id: 0x%llx",
@@ -327,31 +327,42 @@ static void core_reg_fixup(void)
 
 static void prepare_vcpu_init(struct vcpu_config *c, struct kvm_vcpu_init *init)
 {
-       if (c->sve)
-               init->features[0] |= 1 << KVM_ARM_VCPU_SVE;
-       if (c->pmu)
-               init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
+       struct reg_sublist *s;
+
+       for_each_sublist(c, s) {
+               if (s->base)
+                       continue;
+               init->features[0] |= 1 << s->feature;
+       }
 }
 
 static void finalize_vcpu(struct kvm_vm *vm, uint32_t vcpuid, struct vcpu_config *c)
 {
+       struct reg_sublist *s;
        int feature;
 
-       if (c->sve) {
-               feature = KVM_ARM_VCPU_SVE;
-               vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_FINALIZE, &feature);
+       for_each_sublist(c, s) {
+               if (s->base)
+                       continue;
+               if (s->finalize) {
+                       feature = s->feature;
+                       vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_FINALIZE, &feature);
+               }
        }
 }
 
 static void check_supported(struct vcpu_config *c)
 {
-       if (c->sve && !kvm_check_cap(KVM_CAP_ARM_SVE)) {
-               fprintf(stderr, "%s: SVE not available, skipping tests\n", c->name);
-               exit(KSFT_SKIP);
-       }
-       if (c->pmu && !kvm_check_cap(KVM_CAP_ARM_PMU_V3)) {
-               fprintf(stderr, "%s: PMU not available, skipping tests\n", c->name);
-               exit(KSFT_SKIP);
+       struct reg_sublist *s;
+
+       for_each_sublist(c, s) {
+               if (s->base)
+                       continue;
+               if (!kvm_check_cap(s->capability)) {
+                       fprintf(stderr, "%s: %s not available, skipping tests\n", c->name, s->name);
+                       exit(KSFT_SKIP);
+
+               }
        }
 }
 
@@ -975,34 +986,34 @@ static __u64 sve_rejects_set[] = {
 static struct vcpu_config vregs_config = {
        "vregs",
        .sublists = {
-       { base_regs,    ARRAY_SIZE(base_regs), },
-       { vregs,        ARRAY_SIZE(vregs), },
+       { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
+       { "vregs", true, 0, 0, false, vregs, ARRAY_SIZE(vregs), },
        {0},
        },
 };
 static struct vcpu_config vregs_pmu_config = {
-       "vregs+pmu", .pmu = true,
+       "vregs+pmu",
        .sublists = {
-       { base_regs,    ARRAY_SIZE(base_regs), },
-       { vregs,        ARRAY_SIZE(vregs), },
-       { pmu_regs,     ARRAY_SIZE(pmu_regs), },
+       { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
+       { "vregs", true, 0, 0, false, vregs, ARRAY_SIZE(vregs), },
+       { "pmu", false, KVM_ARM_VCPU_PMU_V3, KVM_CAP_ARM_PMU_V3, false, pmu_regs, ARRAY_SIZE(pmu_regs), },
        {0},
        },
 };
 static struct vcpu_config sve_config = {
-       "sve", .sve = true,
+       "sve",
        .sublists = {
-       { base_regs,    ARRAY_SIZE(base_regs), },
-       { sve_regs,     ARRAY_SIZE(sve_regs),   sve_rejects_set,        ARRAY_SIZE(sve_rejects_set), },
+       { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
+       { "sve", false, KVM_ARM_VCPU_SVE, KVM_CAP_ARM_SVE, true, sve_regs, ARRAY_SIZE(sve_regs), sve_rejects_set, ARRAY_SIZE(sve_rejects_set), },
        {0},
        },
 };
 static struct vcpu_config sve_pmu_config = {
-       "sve+pmu", .sve = true, .pmu = true,
+       "sve+pmu",
        .sublists = {
-       { base_regs,    ARRAY_SIZE(base_regs), },
-       { sve_regs,     ARRAY_SIZE(sve_regs),   sve_rejects_set,        ARRAY_SIZE(sve_rejects_set), },
-       { pmu_regs,     ARRAY_SIZE(pmu_regs), },
+       { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
+       { "sve", false, KVM_ARM_VCPU_SVE, KVM_CAP_ARM_SVE, true, sve_regs, ARRAY_SIZE(sve_regs), sve_rejects_set, ARRAY_SIZE(sve_rejects_set), },
+       { "pmu", false, KVM_ARM_VCPU_PMU_V3, KVM_CAP_ARM_PMU_V3, false, pmu_regs, ARRAY_SIZE(pmu_regs), },
        {0},
        },
 };

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
