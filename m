Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB8D37C0EB
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 17:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785347266; cv=none; b=DyXOxhsxsJ38zpw47qLDQDmFjHP6BDOQxzafcCN7V4wAn26WmUn1aNTWQ9qEXLcdBQDf5GTpS9+XcqzLTrchdUTEtVKRcogL9bq1/LL37hJRWAJrDcFElFoOA/Ye78cdA0R39f5MJZMnXWPt9g86M2FBfw/f9K5w7wsjzLgeTS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785347266; c=relaxed/simple;
	bh=BuAHwTI2qSZ9KYlAVj2MRWyGcPgbLsHavo3hOIRH2Kc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uQOatQPwREACGUo9urUl4rYllIVOLCVnRZx7pya20TJ5FJxmOrRrE2Of1TNVwM/Y0ZjGPOc2iXzWidb1wgGxu2aBKvT0XlonHhQzsqzFkvCHXOtwlvHrQITLtTsGsKWb3fLr34mgiIsJaJnWFGhjPPMLAbOH4erUdJ+/24qimqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LvIDRLjW; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LvIDRLjW"
X-Forwarded-Encrypted: i=1; AHgh+RrN2lLH41RE3tY+RWhSo+dkX1cQpL8fC4RPJzUyMB/+cTM+AJ7FW2F0nVuQZqEFS1ClvUWwjcU=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785347254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IeRo16GwGxWMem/Vo4ri2U5hfNnBxk9Oq5X7cUuthyE=;
	b=LvIDRLjWEGPcykfMeIYjpAZvtrEjZvqijvEHTTbqyoUJeOLPZYSyDWisDzaK88Dw+wUPqB
	PKthOESFKzBQtaKmgBPmRJ2Y4yJW3ho2Hn8cl8bXc99wkAxHuNGDOchS5Ot7HuQJl8rAms
	qbdXYWgCKMBmmri+fWsdkTcn6wkjN1g=
X-Gm-Message-State: AOJu0Yz06pAoiLE1rQcPlUBmjYVp6cs+LuhkjQXC4+3XYTLr8qO+vtgV
	B8LJzQc1hp1WqhwoBVqeGE5QQzU/4d9WG80UdbgESoXM34DZOrXHA85JoMK815+Z5IVLBIVXEWW
	GKaa+KurUB5YcC49lb/x3u95PF64SJS3ELQrNVP3A
X-Received: by 2002:a05:6512:1314:b0:5b2:a5e9:3aba with SMTP id
 2adb3069b0e04-5b2d9b614acmr37313e87.6.1785347243412; Wed, 29 Jul 2026
 10:47:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp> <20260720-hybrid-v9-8-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260720-hybrid-v9-8-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 29 Jul 2026 18:46:43 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyEnNGrZHbHKK9cW0-kOynrDqZVwRb0MeLAM=wGUYFbRw@mail.gmail.com>
X-Gm-Features: AUfX_mwpeXBo_K7R-ZzBlG5aqjhgeVn_6sJDBLp3FQhFslgMr5nn9WZIS1Jgf5E
Message-ID: <CA+EHjTyEnNGrZHbHKK9cW0-kOynrDqZVwRb0MeLAM=wGUYFbRw@mail.gmail.com>
Subject: Re: [PATCH v9 08/16] KVM: arm64: selftests: Cover PMU state in MDCR_EL2
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Steffen Eiden <seiden@linux.ibm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 20 Jul 2026 at 06:44, Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> Add MDCR_EL2 coverage to vpmu_counter_access when EL2 is available.
>
> For each configured PMCR_EL0.N value, verify that an arbitrary HPMN
> value, including one above the configured counter count, round-trips
> through KVM_SET_ONE_REG and survives SET_NR_COUNTERS. Also verify that
> HPME can be toggled without disturbing HPMN and that KVM_ARM_VCPU_INIT
> resets HPMN from the configured count.
>
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  .../selftests/kvm/arm64/vpmu_counter_access.c      | 90 ++++++++++++++++++++--
>  1 file changed, 85 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> index 3b5bb421f401..73f04e4c6ca3 100644
> --- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> @@ -25,6 +25,14 @@
>  /* The cycle counter bit position that's common among the PMU registers */
>  #define ARMV8_PMU_CYCLE_IDX            31
>
> +#ifndef MDCR_EL2_HPMN
> +#define MDCR_EL2_HPMN                  GENMASK_ULL(4, 0)
> +#endif
> +
> +#ifndef MDCR_EL2_HPME
> +#define MDCR_EL2_HPME                  BIT_ULL(7)
> +#endif
> +
>  struct vpmu_vm {
>         struct kvm_vm *vm;
>         struct kvm_vcpu *vcpu;
> @@ -466,15 +474,12 @@ static void guest_code_done(void)
>         GUEST_DONE();
>  }
>
> -static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool expect_fail)
> +static void set_nr_counters(struct kvm_vcpu *vcpu,
> +                           unsigned int nr_counters, bool expect_fail)
>  {
> -       struct kvm_vcpu *vcpu;
>         unsigned int prev;
>         int ret;
>
> -       create_vpmu_vm(guest_code);
> -       vcpu = vpmu_vm.vcpu;
> -
>         prev = get_pmcr_n(vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0)));
>
>         ret = __vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> @@ -486,6 +491,17 @@ static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool
>                             nr_counters, prev);
>         else
>                 TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
> +}
> +
> +static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters,
> +                                                bool expect_fail)
> +{
> +       struct kvm_vcpu *vcpu;
> +
> +       create_vpmu_vm(guest_code);
> +       vcpu = vpmu_vm.vcpu;
> +
> +       set_nr_counters(vcpu, nr_counters, expect_fail);
>
>         vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL, KVM_ARM_VCPU_PMU_V3_INIT, NULL);
>  }
> @@ -588,6 +604,69 @@ static void run_pmregs_validity_test(u64 pmcr_n)
>         destroy_vpmu_vm();
>  }
>
> +static void run_mdcr_el2_validity_test(u64 pmcr_n)
> +{
> +       struct kvm_vcpu_init init;
> +       struct kvm_vcpu *vcpu;
> +       u64 expected_mdcr, mdcr;
> +
> +       pr_debug("MDCR_EL2 test with pmcr_n %lu\n", pmcr_n);
> +
> +       create_vpmu_vm(guest_code);
> +       if (!vm_supports_el2(vpmu_vm.vm)) {
> +               destroy_vpmu_vm();
> +               return;
> +       }
> +
> +       vcpu = vpmu_vm.vcpu;
> +
> +       mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
> +       expected_mdcr = u64_replace_bits(mdcr, FIELD_MAX(MDCR_EL2_HPMN),
> +                                        MDCR_EL2_HPMN);
> +       vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2),
> +                    expected_mdcr);
> +
> +       mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
> +       TEST_ASSERT(mdcr == expected_mdcr,
> +                   "MDCR_EL2 was not properly updated after HPMN write (expected 0x%lx, got 0x%lx)",
> +                   expected_mdcr, mdcr);
> +
> +       set_nr_counters(vcpu, pmcr_n, false);
> +
> +       mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
> +       TEST_ASSERT(mdcr == expected_mdcr,
> +                   "MDCR_EL2 changed after PMU_V3_SET_NR_COUNTERS (expected 0x%lx, got 0x%lx)",
> +                   expected_mdcr, mdcr);
> +
> +       vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                            KVM_ARM_VCPU_PMU_V3_INIT, NULL);
> +
> +       mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
> +       TEST_ASSERT(mdcr == expected_mdcr,
> +                   "MDCR_EL2 changed after PMU_V3_INIT (expected 0x%lx, got 0x%lx)",
> +                   expected_mdcr, mdcr);
> +
> +       expected_mdcr = mdcr ^ MDCR_EL2_HPME;
> +       vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2),
> +                    expected_mdcr);
> +
> +       mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
> +       TEST_ASSERT(mdcr == expected_mdcr,
> +                   "MDCR_EL2 was not properly updated after HPME write (expected 0x%lx, got 0x%lx)",
> +                   expected_mdcr, mdcr);
> +
> +       kvm_get_default_vcpu_target(vpmu_vm.vm, &init);
> +       init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
> +       aarch64_vcpu_setup(vcpu, &init);
> +
> +       mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
> +       TEST_ASSERT(FIELD_GET(MDCR_EL2_HPMN, mdcr) == pmcr_n,
> +                   "MDCR_EL2.HPMN is not reset after INIT (expected %lu, got %lu)",
> +                   pmcr_n, FIELD_GET(MDCR_EL2_HPMN, mdcr));
> +
> +       destroy_vpmu_vm();
> +}
> +
>  /*
>   * Create a guest with one vCPU, and attempt to set the PMCR_EL0.N for
>   * the vCPU to @pmcr_n, which is larger than the host value.
> @@ -672,6 +751,7 @@ int main(void)
>         for (i = 0; i <= pmcr_n; i++) {
>                 run_access_test(i);
>                 run_pmregs_validity_test(i);
> +               run_mdcr_el2_validity_test(i);
>         }
>
>         for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
>
> --
> 2.55.0
>
>
