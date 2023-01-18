Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9A52564
	for <kvmarm@lists.linux.dev>; Wed, 18 Jan 2023 07:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674028203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sc2QbvS5LHUEHeHr3GXeISkdXx26baXFdsIw1im/Hdg=;
	b=YInOOYPZ1GcSNhhT9b10CagkzrRfMyCyCc6TIeTgLXIBvpcRvqXMpSOSMJG6r3dtv3P3Bv
	l4n87OFNMeoA+amUDgEO48UU5K9K4pv+751KqVVKmgoCc8jSSUl+NZuaNNwaYLCoUn18kB
	eJ3gR2i5NAXW9EcTwYrFsxd85/mYd44=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-212-Dc-iP7WIO2euo2lQrLgPgQ-1; Wed, 18 Jan 2023 02:50:02 -0500
X-MC-Unique: Dc-iP7WIO2euo2lQrLgPgQ-1
Received: by mail-pg1-f199.google.com with SMTP id 38-20020a630b26000000b004773803dda1so15201695pgl.17
        for <kvmarm@lists.linux.dev>; Tue, 17 Jan 2023 23:50:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sc2QbvS5LHUEHeHr3GXeISkdXx26baXFdsIw1im/Hdg=;
        b=NGUScVsVMHyyEBYVDaIxQO5XlQqPla1GV+jY5JYW1+SVTc/i8Yft6coDmjvnDunPMY
         JXDlesecV4jT/UjsV8koLP0utIqX8gPc2TCZPAQwza4Qi2x+xkwzPiq5ptgkSnKQioEi
         hTqa//MMU5yt/suO9tqH4dxt+0mrfYFlb+2tochbwTx6pCGpSQ1WpQzrWCg2fyHREc0Z
         t1n0qyWN/ofhNi0BPwINvMkavxrV1vMHkx1KGwdWD5uGhG4aKYTMnqYBKuKCrI947H2J
         7W4Yuk8kqEN8pxF021aj8IRaM7SG67yXwwifIqCYac4bfLTN8ndYmS6ahs02mvIrtpuC
         fcJg==
X-Gm-Message-State: AFqh2kqXCXUxYr0fjqg9LdnYGyDGZJw2V03gKti7YK0pMyiBBeun1hc/
	GfNEbruwbfyUaMZpzmdyURjNQXBbPT39hpvLkvAozE5QnqwP/mBz/0ZEFsDNuUngfMZ3A+3j5i6
	oxXVHSMJEBbuTSZ1F
X-Received: by 2002:a17:903:1303:b0:194:6d4b:e1da with SMTP id iy3-20020a170903130300b001946d4be1damr1463726plb.0.1674028199844;
        Tue, 17 Jan 2023 23:49:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsLeWhkZtDm3E+RDju0/hHDvZz5BOx2tfUmdpw+rX506gUsaCHlChIFIbDe4ocrlPBsPVA/rA==
X-Received: by 2002:a17:903:1303:b0:194:6d4b:e1da with SMTP id iy3-20020a170903130300b001946d4be1damr1463719plb.0.1674028199533;
        Tue, 17 Jan 2023 23:49:59 -0800 (PST)
Received: from [10.66.60.207] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a3-20020a170902900300b00189393ab02csm4931717plp.99.2023.01.17.23.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 23:49:58 -0800 (PST)
Message-ID: <acf66ec9-9de2-7d87-c237-ade895c2bb72@redhat.com>
Date: Wed, 18 Jan 2023 15:49:53 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 8/8] KVM: selftests: aarch64: vPMU register test for
 unimplemented counters
To: Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Ricardo Koller <ricarkol@google.com>, Oliver Upton <oliver.upton@linux.dev>,
 Jing Zhang <jingzhangos@google.com>,
 Raghavendra Rao Anata <rananta@google.com>
References: <20230117013542.371944-1-reijiw@google.com>
 <20230117013542.371944-9-reijiw@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230117013542.371944-9-reijiw@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Reiji,

On 1/17/23 09:35, Reiji Watanabe wrote:
> Add a new test case to the vpmu_counter_access test to check
> if PMU registers or their bits for unimplemented counters are not
> accessible or are RAZ, as expected.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>   .../kvm/aarch64/vpmu_counter_access.c         | 103 +++++++++++++++++-
>   .../selftests/kvm/include/aarch64/processor.h |   1 +
>   2 files changed, 98 insertions(+), 6 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> index 54b69c76c824..a7e34d63808b 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> @@ -5,8 +5,8 @@
>    * Copyright (c) 2022 Google LLC.
>    *
>    * This test checks if the guest can see the same number of the PMU event
> - * counters (PMCR_EL1.N) that userspace sets, and if the guest can access
> - * those counters.
> + * counters (PMCR_EL1.N) that userspace sets, if the guest can access
> + * those counters, and if the guest cannot access any other counters.
>    * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
>    */
>   #include <kvm_util.h>
> @@ -179,6 +179,51 @@ struct pmc_accessor pmc_accessors[] = {
>   	{ read_sel_evcntr, write_pmevcntrn, read_sel_evtyper, write_pmevtypern },
>   };
>   
> +#define INVALID_EC	(-1ul)
> +uint64_t expected_ec = INVALID_EC;
> +uint64_t op_end_addr;
> +
> +static void guest_sync_handler(struct ex_regs *regs)
> +{
> +	uint64_t esr, ec;
> +
> +	esr = read_sysreg(esr_el1);
> +	ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
> +	GUEST_ASSERT_4(op_end_addr && (expected_ec == ec),
> +		       regs->pc, esr, ec, expected_ec);
> +
> +	/* Will go back to op_end_addr after the handler exits */
> +	regs->pc = op_end_addr;
> +
> +	/*
> +	 * Clear op_end_addr, and setting expected_ec to INVALID_EC
> +	 * as a sign that an exception has occurred.
> +	 */
> +	op_end_addr = 0;
> +	expected_ec = INVALID_EC;
> +}
> +
> +/*
> + * Run the given operation that should trigger an exception with the
> + * given exception class. The exception handler (guest_sync_handler)
> + * will reset op_end_addr to 0, and expected_ec to INVALID_EC, and
> + * will come back to the instruction at the @done_label.
> + * The @done_label must be a unique label in this test program.
> + */
> +#define TEST_EXCEPTION(ec, ops, done_label)		\
> +{							\
> +	extern int done_label;				\
> +							\
> +	WRITE_ONCE(op_end_addr, (uint64_t)&done_label);	\
> +	GUEST_ASSERT(ec != INVALID_EC);			\
> +	WRITE_ONCE(expected_ec, ec);			\
> +	dsb(ish);					\
> +	ops;						\
> +	asm volatile(#done_label":");			\
> +	GUEST_ASSERT(!op_end_addr);			\
> +	GUEST_ASSERT(expected_ec == INVALID_EC);	\
> +}
> +
>   static void pmu_disable_reset(void)
>   {
>   	uint64_t pmcr = read_sysreg(pmcr_el0);
> @@ -352,16 +397,38 @@ static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
>   		       pmc_idx, acc, read_data, read_data_prev);
>   }
>   
> +/*
> + * Tests for reading/writing registers for the unimplemented event counter
> + * specified by @pmc_idx (>= PMCR_EL1.N).
> + */
> +static void test_access_invalid_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
> +{
> +	/*
> +	 * Reading/writing the event count/type registers should cause
> +	 * an UNDEFINED exception.
> +	 */
> +	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_cntr(pmc_idx), inv_rd_cntr);
> +	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0), inv_wr_cntr);
> +	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_typer(pmc_idx), inv_rd_typer);
> +	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_typer(pmc_idx, 0), inv_wr_typer);
> +	/*
> +	 * The bit corresponding to the (unimplemented) counter in
> +	 * {PMCNTEN,PMOVS}{SET,CLR}_EL1 registers should be RAZ.
> +	 */
> +	test_bitmap_pmu_regs(pmc_idx, 1);
> +	test_bitmap_pmu_regs(pmc_idx, 0);
> +}
> +
>   /*
>    * The guest is configured with PMUv3 with @expected_pmcr_n number of
>    * event counters.
>    * Check if @expected_pmcr_n is consistent with PMCR_EL0.N, and
> - * if reading/writing PMU registers for implemented counters can work
> - * as expected.
> + * if reading/writing PMU registers for implemented or unimplemented
> + * counters can work as expected.
>    */
>   static void guest_code(uint64_t expected_pmcr_n)
>   {
> -	uint64_t pmcr, pmcr_n;
> +	uint64_t pmcr, pmcr_n, unimp_mask;
>   	int i, pmc;
>   
>   	GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS);
> @@ -372,6 +439,14 @@ static void guest_code(uint64_t expected_pmcr_n)
>   	/* Make sure that PMCR_EL0.N indicates the value userspace set */
>   	GUEST_ASSERT_2(pmcr_n == expected_pmcr_n, pmcr_n, expected_pmcr_n);
>   
> +	/*
> +	 * Make sure that (RAZ) bits corresponding to unimplemented event
> +	 * counters in {PMCNTEN,PMOVS}{SET,CLR}_EL1 registers are reset to zero.
> +	 * (NOTE: bits for implemented event counters are reset to UNKNOWN)
> +	 */
> +	unimp_mask = GENMASK_ULL(ARMV8_PMU_MAX_GENERAL_COUNTERS - 1, pmcr_n);
> +	check_bitmap_pmu_regs(unimp_mask, false);
> +
>   	/*
>   	 * Tests for reading/writing PMU registers for implemented counters.
>   	 * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
> @@ -381,6 +456,14 @@ static void guest_code(uint64_t expected_pmcr_n)
>   			test_access_pmc_regs(&pmc_accessors[i], pmc);
>   	}
>   
> +	/*
> +	 * Tests for reading/writing PMU registers for unimplemented counters.
> +	 * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
Here should be PMEV{CNTR, TYPER}<n>.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
> +		for (pmc = pmcr_n; pmc < ARMV8_PMU_MAX_GENERAL_COUNTERS; pmc++)
> +			test_access_invalid_pmc_regs(&pmc_accessors[i], pmc);
> +	}
>   	GUEST_DONE();
>   }
>   
> @@ -394,7 +477,7 @@ static struct kvm_vm *create_vpmu_vm(void *guest_code, struct kvm_vcpu **vcpup,
>   	struct kvm_vm *vm;
>   	struct kvm_vcpu *vcpu;
>   	struct kvm_vcpu_init init;
> -	uint8_t pmuver;
> +	uint8_t pmuver, ec;
>   	uint64_t dfr0, irq = 23;
>   	struct kvm_device_attr irq_attr = {
>   		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
> @@ -407,11 +490,18 @@ static struct kvm_vm *create_vpmu_vm(void *guest_code, struct kvm_vcpu **vcpup,
>   	};
>   
>   	vm = vm_create(1);
> +	vm_init_descriptor_tables(vm);
> +	/* Catch exceptions for easier debugging */
> +	for (ec = 0; ec < ESR_EC_NUM; ec++) {
> +		vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ec,
> +					guest_sync_handler);
> +	}
>   
>   	/* Create vCPU with PMUv3 */
>   	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
>   	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
>   	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
> +	vcpu_init_descriptor_tables(vcpu);
>   	*gic_fd = vgic_v3_setup(vm, 1, 64, GICD_BASE_GPA, GICR_BASE_GPA);
>   
>   	/* Make sure that PMUv3 support is indicated in the ID register */
> @@ -480,6 +570,7 @@ static void run_test(uint64_t pmcr_n)
>   	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
>   	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
>   	aarch64_vcpu_setup(vcpu, &init);
> +	vcpu_init_descriptor_tables(vcpu);
>   	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
>   	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
>   
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 5f977528e09c..52d87809356c 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -104,6 +104,7 @@ enum {
>   #define ESR_EC_SHIFT		26
>   #define ESR_EC_MASK		(ESR_EC_NUM - 1)
>   
> +#define ESR_EC_UNKNOWN		0x0
>   #define ESR_EC_SVC64		0x15
>   #define ESR_EC_IABT		0x21
>   #define ESR_EC_DABT		0x25

-- 
Regards,
Shaoqin

