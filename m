Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4220C3AB286
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 19:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785354393; cv=none; b=YMDmZq0h/NPR2tcFEkxpDur5KnRz/M8voIrZ2nTNA4E9QesYed4mE7VgNyWv3wPeyeIebunN16B2Id/mOVFUdkP5i7vKbtUuVxEjgpoUFOYBNO/FSrgAawm7Q3rffR/X/OrkPbK3LXj7J0b5yDB4z8OKh/BrWoE30B2jAwkBFr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785354393; c=relaxed/simple;
	bh=MTsW4DPZPh15sIO/nZBnNM4EnhVhCyLOHMDWXXit5kI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YghOxTM/KW0g9EtYKci8kiQKO/8DW2sbo2q0RyuxF3Cf0Xu+V21LJJiJN131HkqtCGIyoXPUc02sDnQRay6QJb4GUHK4v6+5Q5ryt+O9v2qte6SRjwquQjwQ5gh9xN6iaHIwIXpAG3HJgqNruFbAhuEp+OZCEptZQkR+ze3tAo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NCtNlzdm; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NCtNlzdm"
X-Forwarded-Encrypted: i=1; AHgh+RrCQcYQrkNg3v0CThUlFNgkLmTnyvC10M2nDnsDTCIghC7fe3DUghsW1vmS66/g3CNM0ZsK8Uk=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785354386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m7NYxbVQukXWkUZPHzw13nh5/XBlWOt6m2oUVluhMlA=;
	b=NCtNlzdmhftlkTDwtpLz9CqjXGWtc2IpCHBnhQhU+8/PZE6YAuYGXEzNcdM69U628tD+PS
	steD/dlYv4PDniHz5M1zcCJ6POdgM5Q46alQ5buT176CkywC5qjyrhVHbpvdkcZ5NCiY98
	9OLo0Ws/+oSP7oYyHzUZ9mG03GJmvFo=
X-Gm-Message-State: AOJu0Yz68dyc51xqDfHu/2KgmHSSM1GLkhrkLNEnq+QSZhMh1nRx9EE1
	a3kyLMFYjTNMp/flWhTuimCfopvkJzoYg4+F30Z0jHfBZBwx/x3j1wdN+dpLxfbG+L71R7Qon4b
	F61F33LZf1ZVT6/EmTVyYZJzSYIjHjkItTP3Tpl4r
X-Received: by 2002:a05:622a:5145:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-52b3741055amr1691401cf.0.1785354377611; Wed, 29 Jul 2026
 12:46:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp> <20260720-hybrid-v9-16-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260720-hybrid-v9-16-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 29 Jul 2026 20:45:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyTOCyZRRsGj3hbzk6H=ZPZTfTCYQpv+o0MpcoLAXS95A@mail.gmail.com>
X-Gm-Features: AUfX_mz5uV-Ty8nXNE0Bq2AH3IvUn36RDUN3WfgUMxDQ01Xo6HoyBjFL8QvNB8Y
Message-ID: <CA+EHjTyTOCyZRRsGj3hbzk6H=ZPZTfTCYQpv+o0MpcoLAXS95A@mail.gmail.com>
Subject: Re: [PATCH v9 16/16] KVM: arm64: selftests: Test PMU_V3_FIXED_COUNTERS_ONLY
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

On Mon, 20 Jul 2026 at 06:39, Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> Assert the following:
> - FIXED_COUNTERS_ONLY is unset at initialization.
> - FIXED_COUNTERS_ONLY can be set.
> - Setting an event filter when FIXED_COUNTERS_ONLY has already been set
>   results in EBUSY.
> - Setting FIXED_COUNTERS_ONLY when an event filter has already been set
>   results in EBUSY.
> - Setting FIXED_COUNTERS_ONLY when a VCPU has already run results in
>   EBUSY.
>
> Run the existing PMU and MDCR_EL2 tests in fixed-only mode. Verify that
> enabling the mode preserves the userspace MDCR_EL2 value until a
> subsequent KVM_ARM_VCPU_INIT resets HPMN to zero.
>
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  .../selftests/kvm/arm64/vpmu_counter_access.c      | 166 +++++++++++++++++----
>  1 file changed, 137 insertions(+), 29 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> index 73f04e4c6ca3..b5f8ce8d3451 100644
> --- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> @@ -411,12 +411,7 @@ static void create_vpmu_vm(void *guest_code)
>  {
>         struct kvm_vcpu_init init;
>         u8 pmuver, ec;
> -       u64 dfr0, irq = 23;
> -       struct kvm_device_attr irq_attr = {
> -               .group = KVM_ARM_VCPU_PMU_V3_CTRL,
> -               .attr = KVM_ARM_VCPU_PMU_V3_IRQ,
> -               .addr = (u64)&irq,
> -       };
> +       u64 dfr0;
>
>         /* The test creates the vpmu_vm multiple times. Ensure a clean state */
>         memset(&vpmu_vm, 0, sizeof(vpmu_vm));
> @@ -442,8 +437,6 @@ static void create_vpmu_vm(void *guest_code)
>         TEST_ASSERT(pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF &&
>                     pmuver >= ID_AA64DFR0_EL1_PMUVer_IMP,
>                     "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
> -
> -       vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
>  }
>
>  static void destroy_vpmu_vm(void)
> @@ -494,13 +487,22 @@ static void set_nr_counters(struct kvm_vcpu *vcpu,
>  }
>
>  static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters,
> +                                                bool fixed_counters_only,
>                                                  bool expect_fail)
>  {
>         struct kvm_vcpu *vcpu;
> +       u64 irq = 23;
>
>         create_vpmu_vm(guest_code);
>         vcpu = vpmu_vm.vcpu;
>
> +       if (fixed_counters_only)
> +               vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                                    KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
> +
> +       vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                            KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
> +
>         set_nr_counters(vcpu, nr_counters, expect_fail);
>
>         vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL, KVM_ARM_VCPU_PMU_V3_INIT, NULL);
> @@ -510,15 +512,15 @@ static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters,
>   * Create a guest with one vCPU, set the PMCR_EL0.N for the vCPU to @pmcr_n,
>   * and run the test.
>   */
> -static void run_access_test(u64 pmcr_n)
> +static void run_access_test(u64 pmcr_n, bool fixed_counters_only)
>  {
>         u64 sp;
>         struct kvm_vcpu *vcpu;
>         struct kvm_vcpu_init init;
>
> -       pr_debug("Test with pmcr_n %lu\n", pmcr_n);
> +       pr_debug("Test with pmcr_n %lu, fixed_counters_only %d\n", pmcr_n, fixed_counters_only);
>
> -       test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
> +       test_create_vpmu_vm_with_nr_counters(pmcr_n, fixed_counters_only, false);
>         vcpu = vpmu_vm.vcpu;
>
>         /* Save the initial sp to restore them later to run the guest again */
> @@ -552,14 +554,14 @@ static struct pmreg_sets validity_check_reg_sets[] = {
>   * Create a VM, and check if KVM handles the userspace accesses of
>   * the PMU register sets in @validity_check_reg_sets[] correctly.
>   */
> -static void run_pmregs_validity_test(u64 pmcr_n)
> +static void run_pmregs_validity_test(u64 pmcr_n, bool fixed_counters_only)
>  {
>         int i;
>         struct kvm_vcpu *vcpu;
>         u64 set_reg_id, clr_reg_id, reg_val;
>         u64 valid_counters_mask, max_counters_mask;
>
> -       test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
> +       test_create_vpmu_vm_with_nr_counters(pmcr_n, fixed_counters_only, false);
>         vcpu = vpmu_vm.vcpu;
>
>         valid_counters_mask = get_counters_mask(pmcr_n);
> @@ -604,13 +606,15 @@ static void run_pmregs_validity_test(u64 pmcr_n)
>         destroy_vpmu_vm();
>  }
>
> -static void run_mdcr_el2_validity_test(u64 pmcr_n)
> +static void run_mdcr_el2_validity_test(u64 pmcr_n, bool fixed_counters_only)
>  {
>         struct kvm_vcpu_init init;
>         struct kvm_vcpu *vcpu;
>         u64 expected_mdcr, mdcr;
> +       u64 irq = 23;
>
> -       pr_debug("MDCR_EL2 test with pmcr_n %lu\n", pmcr_n);
> +       pr_debug("MDCR_EL2 test with pmcr_n %lu, fixed_counters_only %d\n",
> +                pmcr_n, fixed_counters_only);
>
>         create_vpmu_vm(guest_code);
>         if (!vm_supports_el2(vpmu_vm.vm)) {
> @@ -631,6 +635,16 @@ static void run_mdcr_el2_validity_test(u64 pmcr_n)
>                     "MDCR_EL2 was not properly updated after HPMN write (expected 0x%lx, got 0x%lx)",
>                     expected_mdcr, mdcr);
>
> +       if (fixed_counters_only) {
> +               vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                                    KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
> +
> +               mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
> +               TEST_ASSERT(mdcr == expected_mdcr,
> +                           "MDCR_EL2 changed after PMU_V3_FIXED_COUNTERS_ONLY (expected 0x%lx, got 0x%lx)",
> +                           expected_mdcr, mdcr);
> +       }
> +
>         set_nr_counters(vcpu, pmcr_n, false);
>
>         mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
> @@ -638,6 +652,9 @@ static void run_mdcr_el2_validity_test(u64 pmcr_n)
>                     "MDCR_EL2 changed after PMU_V3_SET_NR_COUNTERS (expected 0x%lx, got 0x%lx)",
>                     expected_mdcr, mdcr);
>
> +       vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                            KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
> +
>         vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
>                              KVM_ARM_VCPU_PMU_V3_INIT, NULL);
>
> @@ -672,11 +689,11 @@ static void run_mdcr_el2_validity_test(u64 pmcr_n)
>   * the vCPU to @pmcr_n, which is larger than the host value.
>   * The attempt should fail as @pmcr_n is too big to set for the vCPU.
>   */
> -static void run_error_test(u64 pmcr_n)
> +static void run_error_test(u64 pmcr_n, bool fixed_counters_only)
>  {
>         pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
>
> -       test_create_vpmu_vm_with_nr_counters(pmcr_n, true);
> +       test_create_vpmu_vm_with_nr_counters(pmcr_n, fixed_counters_only, true);
>         destroy_vpmu_vm();
>  }
>
> @@ -737,25 +754,116 @@ static void test_set_nr_counters_after_vcpu_run(void)
>         kvm_vm_free(vm);
>  }
>
> -int main(void)
> +static void test_config(u64 pmcr_n, bool fixed_counters_only)
> +{
> +       u64 i;
> +
> +       for (i = 0; i <= pmcr_n; i++) {
> +               run_access_test(i, fixed_counters_only);
> +               run_pmregs_validity_test(i, fixed_counters_only);
> +               run_mdcr_el2_validity_test(i, fixed_counters_only);
> +       }
> +
> +       for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
> +               run_error_test(i, fixed_counters_only);
> +}
> +
> +static void test_fixed_counters_only(void)
>  {
> -       u64 i, pmcr_n;
> +       struct kvm_pmu_event_filter filter = { .nevents = 0 };
> +       struct kvm_vm *vm;
> +       struct kvm_vcpu *running_vcpu;
> +       struct kvm_vcpu *stopped_vcpu;
> +       struct kvm_vcpu_init init;
> +       int ret;
> +       u64 irq = 23;
> +
> +       create_vpmu_vm(guest_code);
> +       ret = __vcpu_has_device_attr(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                                    KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY);
> +       if (ret) {
> +               TEST_ASSERT(ret == -1 && errno == ENXIO,
> +                           KVM_IOCTL_ERROR(KVM_HAS_DEVICE_ATTR, ret));
> +               destroy_vpmu_vm();
> +               return;
> +       }
> +
> +       /* Assert that FIXED_COUNTERS_ONLY is unset at initialization. */
> +       ret = __vcpu_device_attr_get(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                                    KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
> +       TEST_ASSERT(ret == -1 && errno == ENXIO,
> +                   KVM_IOCTL_ERROR(KVM_GET_DEVICE_ATTR, ret));
> +
> +       /* Assert that setting FIXED_COUNTERS_ONLY succeeds. */
> +       vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                            KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
> +
> +       /* Assert that FIXED_COUNTERS_ONLY is set. */
> +       vcpu_device_attr_get(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                            KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
> +
> +       /*
> +        * Setting an event filter when FIXED_COUNTERS_ONLY has already been set
> +        * results in EBUSY.
> +        */
> +       ret = __vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                                    KVM_ARM_VCPU_PMU_V3_FILTER, &filter);
> +       TEST_ASSERT(ret == -1 && errno == EBUSY,
> +                   KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
> +
> +       destroy_vpmu_vm();
> +
> +       create_vpmu_vm(guest_code);
> +
> +       /*
> +        * Assert that setting FIXED_COUNTERS_ONLY when an event filter has
> +        * already been set results in EBUSY.
> +        */
> +       vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                            KVM_ARM_VCPU_PMU_V3_FILTER, &filter);
> +
> +       ret = __vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                                    KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
> +       TEST_ASSERT(ret == -1 && errno == EBUSY,
> +                   KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
> +
> +       destroy_vpmu_vm();
> +
> +       /*
> +        * Assert that setting FIXED_COUNTERS_ONLY when a VCPU has already run
> +        * results in EBUSY.
> +        */
> +       vm = vm_create(2);
> +       vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> +       init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
> +       running_vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code_done);
> +       stopped_vcpu = aarch64_vcpu_add(vm, 1, &init, guest_code_done);
> +       kvm_arch_vm_finalize_vcpus(vm);
> +       vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                            KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
> +       vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                            KVM_ARM_VCPU_PMU_V3_INIT, NULL);
> +       vcpu_run(running_vcpu);
> +
> +       ret = __vcpu_device_attr_set(stopped_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                                    KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
> +       TEST_ASSERT(ret == -1 && errno == EBUSY,
> +                   KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
> +
> +       kvm_vm_free(vm);
> +
> +       test_config(0, true);
> +}
>
> +int main(void)
> +{
>         TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
>         TEST_REQUIRE(kvm_supports_vgic_v3());
>         TEST_REQUIRE(kvm_supports_nr_counters_attr());
>
>         test_set_nr_counters_after_vcpu_run();
> -
> -       pmcr_n = get_pmcr_n_limit();
> -       for (i = 0; i <= pmcr_n; i++) {
> -               run_access_test(i);
> -               run_pmregs_validity_test(i);
> -               run_mdcr_el2_validity_test(i);
> -       }
> -
> -       for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
> -               run_error_test(i);
> +       test_config(get_pmcr_n_limit(), false);
> +       test_fixed_counters_only();
>
>         return 0;
>  }
>
> --
> 2.55.0
>
>
