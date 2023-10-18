Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BC4430F2
	for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 06:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MniksQDZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697612077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ws44xpujh++UeLP3dJKBJiYZxBdnuJb4IuYVHtKx0u4=;
	b=MniksQDZ9Tvmbjoygy4Vkrxnd3RHg5z3Z2H1fDbFxuorYXz4yIFoxSKiRgMyrEjKLUFJOA
	nIPRhGbpW9G56kX8rXe28dDbJAntjP0k/aLd6PpyOe/CMl1U1E/WcIYzleENINVGpM2AHb
	0qig/Hh9sS95VaFwzNAeB45/zqJWUAs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-gum7WYmHOyu6gf2uTJzShg-1; Wed, 18 Oct 2023 02:54:34 -0400
X-MC-Unique: gum7WYmHOyu6gf2uTJzShg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7740829f2beso822180285a.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 23:54:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697612073; x=1698216873;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ws44xpujh++UeLP3dJKBJiYZxBdnuJb4IuYVHtKx0u4=;
        b=Uj6WW8gUCPRCFmcAacWqwJrecDgtxe505JfEwJQPfCt3kgSQaR3IW5TUfQLhyrgucw
         NnlEtAhc8f9451JhNaJZbPyxa0ySPZ1YULXZG7V8pTsFBzBVshTBB561V3vylFZfeRWh
         BH+UeKjAigTCG57dh+E+N9dIWEbLkMMibQ/Nf2Q150YES3P6rxmM5EA1sgcCSZhq+wpO
         /vs4mDIeDd7xSLtrFwac+8c6V1zcEiEI5tqHXvfGb8dkoFpjRhGmoFTTcFVW3cimoh0c
         EpSxb/gJvKPa8pCkYw72+mIhM5x+8avERXkB2d/V1kxyE3Qt4dZaVhnurr7zt0mJbxPK
         +gdQ==
X-Gm-Message-State: AOJu0YwRDXqO7aHaPZAsFBcYvDKI+F74UlC7h/Wlxz/BgFPKiTV+qiXS
	AjHvkD4kK3m8sRtM7npj/jtN6kS+JVNt1djZTPM+Wwy2uY/o5hGegf6KL5LVvgUbC+LkBwXEHvZ
	ZLqM7oQQlAC8TgtKm
X-Received: by 2002:a05:620a:c4b:b0:778:8cce:dbf3 with SMTP id u11-20020a05620a0c4b00b007788ccedbf3mr3318537qki.46.1697612073510;
        Tue, 17 Oct 2023 23:54:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWMELTCfRDqIOtX7AHVLG36zAPI8rt7Pp0jV0lmTUM5Q7A1Fx4EeXlrDC/BJy60i8KUmcMkQ==
X-Received: by 2002:a05:620a:c4b:b0:778:8cce:dbf3 with SMTP id u11-20020a05620a0c4b00b007788ccedbf3mr3318513qki.46.1697612073174;
        Tue, 17 Oct 2023 23:54:33 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.100.204])
        by smtp.gmail.com with ESMTPSA id de26-20020a05620a371a00b007743446efd1sm1260215qkb.35.2023.10.17.23.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 23:54:32 -0700 (PDT)
Message-ID: <3e6e6c25-7b20-46b4-ffce-d34841aca209@redhat.com>
Date: Wed, 18 Oct 2023 08:54:26 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 12/12] KVM: selftests: aarch64: vPMU register test for
 unimplemented counters
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>,
 Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>,
 Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-13-rananta@google.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20231009230858.3444834-13-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Raghavendra,

On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> Add a new test case to the vpmu_counter_access test to check
> if PMU registers or their bits for unimplemented counters are not
> accessible or are RAZ, as expected.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../kvm/aarch64/vpmu_counter_access.c         | 95 +++++++++++++++++--
>  .../selftests/kvm/include/aarch64/processor.h |  1 +
>  2 files changed, 87 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> index e92af3c0db03..788386ac0894 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> @@ -5,8 +5,8 @@
>   * Copyright (c) 2022 Google LLC.
>   *
>   * This test checks if the guest can see the same number of the PMU event
> - * counters (PMCR_EL0.N) that userspace sets, and if the guest can access
> - * those counters.
> + * counters (PMCR_EL0.N) that userspace sets, if the guest can access
> + * those counters, and if the guest cannot access any other counters.
I would suggest: if the guest is prevented from accessing any other counters
>   * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
>   */
>  #include <kvm_util.h>
> @@ -131,9 +131,9 @@ static void write_pmevtypern(int n, unsigned long val)
>  }
>  
>  /*
> - * The pmc_accessor structure has pointers to PMEVT{CNTR,TYPER}<n>_EL0
> + * The pmc_accessor structure has pointers to PMEV{CNTR,TYPER}<n>_EL0
>   * accessors that test cases will use. Each of the accessors will
> - * either directly reads/writes PMEVT{CNTR,TYPER}<n>_EL0
> + * either directly reads/writes PMEV{CNTR,TYPER}<n>_EL0
I guess this should belong to the previous patch?
>   * (i.e. {read,write}_pmev{cnt,type}rn()), or reads/writes them through
>   * PMXEV{CNTR,TYPER}_EL0 (i.e. {read,write}_sel_ev{cnt,type}r()).
>   *
> @@ -291,25 +291,85 @@ static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
>  		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_data);
>  }
>  
> +#define INVALID_EC	(-1ul)
> +uint64_t expected_ec = INVALID_EC;
> +uint64_t op_end_addr;
> +
>  static void guest_sync_handler(struct ex_regs *regs)
>  {
>  	uint64_t esr, ec;
>  
>  	esr = read_sysreg(esr_el1);
>  	ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
> -	__GUEST_ASSERT(0, "PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx", regs->pc, esr, ec);
> +
> +	__GUEST_ASSERT(op_end_addr && (expected_ec == ec),
> +			"PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx; EC expected: 0x%lx",
> +			regs->pc, esr, ec, expected_ec);
> +
> +	/* Will go back to op_end_addr after the handler exits */
> +	regs->pc = op_end_addr;
> +
> +	/*
> +	 * Clear op_end_addr, and setting expected_ec to INVALID_EC
and set
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
> +/*
> + * Tests for reading/writing registers for the unimplemented event counter
> + * specified by @pmc_idx (>= PMCR_EL0.N).
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
{PMCNTEN,PMINTEN,PMOVS}{SET,CLR}
> +	 */
> +	test_bitmap_pmu_regs(pmc_idx, 1);
> +	test_bitmap_pmu_regs(pmc_idx, 0);
>  }
>  
>  /*
>   * The guest is configured with PMUv3 with @expected_pmcr_n number of
>   * event counters.
>   * Check if @expected_pmcr_n is consistent with PMCR_EL0.N, and
> - * if reading/writing PMU registers for implemented counters can work
> - * as expected.
> + * if reading/writing PMU registers for implemented or unimplemented
> + * counters can work as expected.
>   */
>  static void guest_code(uint64_t expected_pmcr_n)
>  {
> -	uint64_t pmcr, pmcr_n;
> +	uint64_t pmcr, pmcr_n, unimp_mask;
>  	int i, pmc;
>  
>  	__GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS,
> @@ -324,15 +384,32 @@ static void guest_code(uint64_t expected_pmcr_n)
>  			"Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
>  			pmcr_n, expected_pmcr_n);
>  
> +	/*
> +	 * Make sure that (RAZ) bits corresponding to unimplemented event
> +	 * counters in {PMCNTEN,PMOVS}{SET,CLR}_EL1 registers are reset to zero.
> +	 * (NOTE: bits for implemented event counters are reset to UNKNOWN)
> +	 */
> +	unimp_mask = GENMASK_ULL(ARMV8_PMU_MAX_GENERAL_COUNTERS - 1, pmcr_n);
> +	check_bitmap_pmu_regs(unimp_mask, false);
wrt above comment, this also checks pmintenset|clr_el1.
> +
>  	/*
>  	 * Tests for reading/writing PMU registers for implemented counters.
> -	 * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
> +	 * Use each combination of PMEV{CNTR,TYPER}<n>_EL0 accessor functions.
>  	 */
>  	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
>  		for (pmc = 0; pmc < pmcr_n; pmc++)
>  			test_access_pmc_regs(&pmc_accessors[i], pmc);
>  	}
>  
> +	/*
> +	 * Tests for reading/writing PMU registers for unimplemented counters.
> +	 * Use each combination of PMEV{CNTR,TYPER}<n>_EL0 accessor functions.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
> +		for (pmc = pmcr_n; pmc < ARMV8_PMU_MAX_GENERAL_COUNTERS; pmc++)
> +			test_access_invalid_pmc_regs(&pmc_accessors[i], pmc);
> +	}
> +
>  	GUEST_DONE();
>  }
>  
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index cb537253a6b9..c42d683102c7 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -104,6 +104,7 @@ enum {
>  #define ESR_EC_SHIFT		26
>  #define ESR_EC_MASK		(ESR_EC_NUM - 1)
>  
> +#define ESR_EC_UNKNOWN		0x0
>  #define ESR_EC_SVC64		0x15
>  #define ESR_EC_IABT		0x21
>  #define ESR_EC_DABT		0x25

Thanks

Eric

