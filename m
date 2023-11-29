Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD60653B5
	for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 03:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YMWfjB6U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701229869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fWBuXSLaFECWeXZmOe630vFgcCYGV2E86Z2wpbPrfbQ=;
	b=YMWfjB6UKjQNlwyN3KsZugoTPlw8EbJ1MNBBSvhWzz3sdBXFoNihTNk815b7rI2h/fm6bz
	ZgSG3Ha+LZUqWIuOidibyQZUNpVH136T1BLRRoSMbVmquX8O4pLfoZekvQ+Cy5Ec2ed1Cf
	mQs0qqgstnJ8iDVD8g5cg18H0evGpPU=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-Siwpk33dMJCaXeZSTFSibg-1; Tue, 28 Nov 2023 22:50:28 -0500
X-MC-Unique: Siwpk33dMJCaXeZSTFSibg-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-285a2ff807cso1484274a91.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 19:50:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701229827; x=1701834627;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fWBuXSLaFECWeXZmOe630vFgcCYGV2E86Z2wpbPrfbQ=;
        b=k7Ulcc3t0VXgejxoTxHrk/Bx35WlmFl8t0Behm99OyHnNI2vwh+3s0uTV9bt9meuHV
         uWk8KdcYSBFPZFDhEFebQXP7ypGmkGAf2XdslyOF/vaAN75Js3dGz7mERT8WPpM8G2Cn
         E0rdb9TiJWNbRU7nk+1nSbLo6FxGrmC3Mt5jUefFn76N8pT1lf5xAThPpBfeQ+NhgaOr
         K+BijaaMt/mLSWTI8Oa2aHC/CtMhexJmz9XM4SChgbVvSJ2UApV2vLwme18eTqnD4aNA
         /R9EwyW3byaQTgQm+ppDxSRQa967mcMS+f0vKz6rnWpGSgncvOdtbxVOwGXyT3jRmxVi
         dNKQ==
X-Gm-Message-State: AOJu0Yyy1SPDmQkc0qsLmJlf6qrp7mzubT/rYUB/erQYdjEUZCY//G0u
	iEq+5jyncGLmnWkjGXhhucJ34pPfttlXLqPRx81BKPekqlyh5f86RVs2Y4BZu5P/QWjk1CWByTu
	3sjPqkkA09ftMJOhF
X-Received: by 2002:a05:6a20:7f8c:b0:18a:f711:7c12 with SMTP id d12-20020a056a207f8c00b0018af7117c12mr19490490pzj.4.1701229827156;
        Tue, 28 Nov 2023 19:50:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHN3AX84B8X2zf2aFhXbzVZIN3DXqw4G7xwuMEZsbX3qJAM7v6wsXKhXMYWgJVAnoOpTzUcdQ==
X-Received: by 2002:a05:6a20:7f8c:b0:18a:f711:7c12 with SMTP id d12-20020a056a207f8c00b0018af7117c12mr19490474pzj.4.1701229826834;
        Tue, 28 Nov 2023 19:50:26 -0800 (PST)
Received: from [10.72.112.34] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 16-20020a17090a01d000b00285cc7a867esm323872pjd.0.2023.11.28.19.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Nov 2023 19:50:26 -0800 (PST)
Message-ID: <9538a359-60df-6214-72c0-d9112e7e7715@redhat.com>
Date: Wed, 29 Nov 2023 11:50:20 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v1 2/3] KVM: selftests: aarch64: Move the pmu helper
 function into lib/
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231123063750.2176250-1-shahuang@redhat.com>
 <20231123063750.2176250-3-shahuang@redhat.com>
 <CAJHc60wsEjjLmAVUrb3n9Tyftqi7UXWh7V1hE1E90bUXiUk+Tw@mail.gmail.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <CAJHc60wsEjjLmAVUrb3n9Tyftqi7UXWh7V1hE1E90bUXiUk+Tw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Raghavendra,

On 11/28/23 05:48, Raghavendra Rao Ananta wrote:
> Hi Shaoqin,
> 
> On Wed, Nov 22, 2023 at 10:39 PM Shaoqin Huang <shahuang@redhat.com> wrote:
>>
>> Move those pmu helper function into lib/, thus it can be used by other
>> pmu test.
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>>   .../kvm/aarch64/vpmu_counter_access.c         | 118 -----------------
>>   .../selftests/kvm/include/aarch64/vpmu.h      | 119 ++++++++++++++++++
>>   2 files changed, 119 insertions(+), 118 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
>> index 17305408a334..62d6315790ab 100644
>> --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
>> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
>> @@ -20,12 +20,6 @@
>>   #include <perf/arm_pmuv3.h>
>>   #include <linux/bitfield.h>
>>
>> -/* The max number of the PMU event counters (excluding the cycle counter) */
>> -#define ARMV8_PMU_MAX_GENERAL_COUNTERS (ARMV8_PMU_MAX_COUNTERS - 1)
>> -
>> -/* The cycle counter bit position that's common among the PMU registers */
>> -#define ARMV8_PMU_CYCLE_IDX            31
>> -
>>   static struct vpmu_vm *vpmu_vm;
>>
>>   struct pmreg_sets {
>> @@ -35,118 +29,6 @@ struct pmreg_sets {
>>
>>   #define PMREG_SET(set, clr) {.set_reg_id = set, .clr_reg_id = clr}
>>
>> -static uint64_t get_pmcr_n(uint64_t pmcr)
>> -{
>> -       return (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
>> -}
>> -
>> -static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
>> -{
>> -       *pmcr = *pmcr & ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
>> -       *pmcr |= (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
>> -}
>> -
>> -static uint64_t get_counters_mask(uint64_t n)
>> -{
>> -       uint64_t mask = BIT(ARMV8_PMU_CYCLE_IDX);
>> -
>> -       if (n)
>> -               mask |= GENMASK(n - 1, 0);
>> -       return mask;
>> -}
>> -
>> -/* Read PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
>> -static inline unsigned long read_sel_evcntr(int sel)
>> -{
>> -       write_sysreg(sel, pmselr_el0);
>> -       isb();
>> -       return read_sysreg(pmxevcntr_el0);
>> -}
>> -
>> -/* Write PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
>> -static inline void write_sel_evcntr(int sel, unsigned long val)
>> -{
>> -       write_sysreg(sel, pmselr_el0);
>> -       isb();
>> -       write_sysreg(val, pmxevcntr_el0);
>> -       isb();
>> -}
>> -
>> -/* Read PMEVTYPER<n>_EL0 through PMXEVTYPER_EL0 */
>> -static inline unsigned long read_sel_evtyper(int sel)
>> -{
>> -       write_sysreg(sel, pmselr_el0);
>> -       isb();
>> -       return read_sysreg(pmxevtyper_el0);
>> -}
>> -
>> -/* Write PMEVTYPER<n>_EL0 through PMXEVTYPER_EL0 */
>> -static inline void write_sel_evtyper(int sel, unsigned long val)
>> -{
>> -       write_sysreg(sel, pmselr_el0);
>> -       isb();
>> -       write_sysreg(val, pmxevtyper_el0);
>> -       isb();
>> -}
>> -
>> -static inline void enable_counter(int idx)
>> -{
>> -       uint64_t v = read_sysreg(pmcntenset_el0);
>> -
>> -       write_sysreg(BIT(idx) | v, pmcntenset_el0);
>> -       isb();
>> -}
>> -
>> -static inline void disable_counter(int idx)
>> -{
>> -       uint64_t v = read_sysreg(pmcntenset_el0);
>> -
>> -       write_sysreg(BIT(idx) | v, pmcntenclr_el0);
>> -       isb();
>> -}
>> -
>> -static void pmu_disable_reset(void)
>> -{
>> -       uint64_t pmcr = read_sysreg(pmcr_el0);
>> -
>> -       /* Reset all counters, disabling them */
>> -       pmcr &= ~ARMV8_PMU_PMCR_E;
>> -       write_sysreg(pmcr | ARMV8_PMU_PMCR_P, pmcr_el0);
>> -       isb();
>> -}
>> -
>> -#define RETURN_READ_PMEVCNTRN(n) \
>> -       return read_sysreg(pmevcntr##n##_el0)
>> -static unsigned long read_pmevcntrn(int n)
>> -{
>> -       PMEVN_SWITCH(n, RETURN_READ_PMEVCNTRN);
>> -       return 0;
>> -}
>> -
>> -#define WRITE_PMEVCNTRN(n) \
>> -       write_sysreg(val, pmevcntr##n##_el0)
>> -static void write_pmevcntrn(int n, unsigned long val)
>> -{
>> -       PMEVN_SWITCH(n, WRITE_PMEVCNTRN);
>> -       isb();
>> -}
>> -
>> -#define READ_PMEVTYPERN(n) \
>> -       return read_sysreg(pmevtyper##n##_el0)
>> -static unsigned long read_pmevtypern(int n)
>> -{
>> -       PMEVN_SWITCH(n, READ_PMEVTYPERN);
>> -       return 0;
>> -}
>> -
>> -#define WRITE_PMEVTYPERN(n) \
>> -       write_sysreg(val, pmevtyper##n##_el0)
>> -static void write_pmevtypern(int n, unsigned long val)
>> -{
>> -       PMEVN_SWITCH(n, WRITE_PMEVTYPERN);
>> -       isb();
>> -}
>> -
>>   /*
>>    * The pmc_accessor structure has pointers to PMEV{CNTR,TYPER}<n>_EL0
>>    * accessors that test cases will use. Each of the accessors will
>> diff --git a/tools/testing/selftests/kvm/include/aarch64/vpmu.h b/tools/testing/selftests/kvm/include/aarch64/vpmu.h
>> index 0a56183644ee..e0cc1ca1c4b7 100644
>> --- a/tools/testing/selftests/kvm/include/aarch64/vpmu.h
>> +++ b/tools/testing/selftests/kvm/include/aarch64/vpmu.h
>> @@ -1,10 +1,17 @@
>>   /* SPDX-License-Identifier: GPL-2.0 */
>>
>>   #include <kvm_util.h>
>> +#include <perf/arm_pmuv3.h>
>>
>>   #define GICD_BASE_GPA  0x8000000ULL
>>   #define GICR_BASE_GPA  0x80A0000ULL
>>
>> +/* The max number of the PMU event counters (excluding the cycle counter) */
>> +#define ARMV8_PMU_MAX_GENERAL_COUNTERS (ARMV8_PMU_MAX_COUNTERS - 1)
>> +
>> +/* The cycle counter bit position that's common among the PMU registers */
>> +#define ARMV8_PMU_CYCLE_IDX            31
>> +
>>   struct vpmu_vm {
>>          struct kvm_vm *vm;
>>          struct kvm_vcpu *vcpu;
>> @@ -14,3 +21,115 @@ struct vpmu_vm {
>>   struct vpmu_vm *create_vpmu_vm(void *guest_code);
>>
>>   void destroy_vpmu_vm(struct vpmu_vm *vpmu_vm);
>> +
>> +static inline uint64_t get_pmcr_n(uint64_t pmcr)
>> +{
>> +       return (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
>> +}
>> +
>> +static inline void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
>> +{
>> +       *pmcr = *pmcr & ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
>> +       *pmcr |= (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
>> +}
>> +
>> +static inline uint64_t get_counters_mask(uint64_t n)
>> +{
>> +       uint64_t mask = BIT(ARMV8_PMU_CYCLE_IDX);
>> +
>> +       if (n)
>> +               mask |= GENMASK(n - 1, 0);
>> +       return mask;
>> +}
>> +
>> +/* Read PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
>> +static inline unsigned long read_sel_evcntr(int sel)
>> +{
>> +       write_sysreg(sel, pmselr_el0);
>> +       isb();
>> +       return read_sysreg(pmxevcntr_el0);
>> +}
>> +
>> +/* Write PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
>> +static inline void write_sel_evcntr(int sel, unsigned long val)
>> +{
>> +       write_sysreg(sel, pmselr_el0);
>> +       isb();
>> +       write_sysreg(val, pmxevcntr_el0);
>> +       isb();
>> +}
>> +
>> +/* Read PMEVTYPER<n>_EL0 through PMXEVTYPER_EL0 */
>> +static inline unsigned long read_sel_evtyper(int sel)
>> +{
>> +       write_sysreg(sel, pmselr_el0);
>> +       isb();
>> +       return read_sysreg(pmxevtyper_el0);
>> +}
>> +
>> +/* Write PMEVTYPER<n>_EL0 through PMXEVTYPER_EL0 */
>> +static inline void write_sel_evtyper(int sel, unsigned long val)
>> +{
>> +       write_sysreg(sel, pmselr_el0);
>> +       isb();
>> +       write_sysreg(val, pmxevtyper_el0);
>> +       isb();
>> +}
>> +
>> +static inline void enable_counter(int idx)
>> +{
>> +       uint64_t v = read_sysreg(pmcntenset_el0);
>> +
>> +       write_sysreg(BIT(idx) | v, pmcntenset_el0);
>> +       isb();
>> +}
>> +
>> +static inline void disable_counter(int idx)
>> +{
>> +       uint64_t v = read_sysreg(pmcntenset_el0);
>> +
>> +       write_sysreg(BIT(idx) | v, pmcntenclr_el0);
>> +       isb();
>> +}
>> +
> As mentioned in [1], the current implementation of disable_counter()
> is buggy and would end up disabling all the counters.
> However if you intend to keep it (even though it would remain unused),
> may be change the definition something to:
> 
> static inline void disable_counter(int idx)
> {
>      write_sysreg(BIT(idx), pmcntenclr_el0);
>      isb();
> }
> 

Ok. I will integrate another patch into my seris to fix this problem.

Thanks,
Shaoqin

> Thank you.
> Raghavendra
> 
> [1]: https://lore.kernel.org/all/20231122221526.2750966-1-rananta@google.com/
> 
>> +static inline void pmu_disable_reset(void)
>> +{
>> +       uint64_t pmcr = read_sysreg(pmcr_el0);
>> +
>> +       /* Reset all counters, disabling them */
>> +       pmcr &= ~ARMV8_PMU_PMCR_E;
>> +       write_sysreg(pmcr | ARMV8_PMU_PMCR_P, pmcr_el0);
>> +       isb();
>> +}
>> +
>> +#define RETURN_READ_PMEVCNTRN(n) \
>> +       return read_sysreg(pmevcntr##n##_el0)
>> +static inline unsigned long read_pmevcntrn(int n)
>> +{
>> +       PMEVN_SWITCH(n, RETURN_READ_PMEVCNTRN);
>> +       return 0;
>> +}
>> +
>> +#define WRITE_PMEVCNTRN(n) \
>> +       write_sysreg(val, pmevcntr##n##_el0)
>> +static inline void write_pmevcntrn(int n, unsigned long val)
>> +{
>> +       PMEVN_SWITCH(n, WRITE_PMEVCNTRN);
>> +       isb();
>> +}
>> +
>> +#define READ_PMEVTYPERN(n) \
>> +       return read_sysreg(pmevtyper##n##_el0)
>> +static inline unsigned long read_pmevtypern(int n)
>> +{
>> +       PMEVN_SWITCH(n, READ_PMEVTYPERN);
>> +       return 0;
>> +}
>> +
>> +#define WRITE_PMEVTYPERN(n) \
>> +       write_sysreg(val, pmevtyper##n##_el0)
>> +static inline void write_pmevtypern(int n, unsigned long val)
>> +{
>> +       PMEVN_SWITCH(n, WRITE_PMEVTYPERN);
>> +       isb();
>> +}
>> --
>> 2.40.1
>>
>>
> 

-- 
Shaoqin

