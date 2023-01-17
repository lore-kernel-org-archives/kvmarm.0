Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C30D1FA7
	for <kvmarm@lists.linux.dev>; Tue, 17 Jan 2023 07:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673940343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cw84Yju7w9gKFrSKtPL7xPNSf+GwDLpk8XHxQvhhr0o=;
	b=K+L+n1HoEC3KS21xO0uSurq40GeNu0Trnf68zaAmiPQTuR+1TtiSyBAG+Lj7KF9NS7suuW
	7EmCqTC2t7w6D3vIbaXmtuBS7bnqxRy+fLfBhi68kriuhLcNeu+4bqWHAxc3tz2au6qLUb
	89HpweRKwA11WUHEnPbXICTPFHtA/ms=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-267-e1rtVY4iMLmN7lSoi8TxLQ-1; Tue, 17 Jan 2023 02:25:41 -0500
X-MC-Unique: e1rtVY4iMLmN7lSoi8TxLQ-1
Received: by mail-pf1-f197.google.com with SMTP id e20-20020aa78c54000000b0058d98e07993so2214608pfd.16
        for <kvmarm@lists.linux.dev>; Mon, 16 Jan 2023 23:25:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cw84Yju7w9gKFrSKtPL7xPNSf+GwDLpk8XHxQvhhr0o=;
        b=JJWfhTP50VVXzHI8Pe40jp/1mnc0tFPcblH8jgPH8jYC5c7cjVdrwyLEYKABc5k82i
         DgJT0pocAoalnyxSfxHgOJTWtMqrwpBdUGlnT0xRIaiW3oOK/Gbm6iLxG8/S2kRW3u8o
         8/gQssYAu9DNPVDDGgjVF/fPM813TN4kZiK+9IEbiXKO2VRrTaU546mZWQWWwdIV59ta
         wCg+nerLBecdodGtZEJqst1ox/a6Tr6WQbETmUr8E0G5DiFsnCYsZk6Gk/wci9lEs9zx
         8PUTbfpd9PS441hzwp3JJ9aRLP6B5RH9w0kpzXJYHvwcpK0xUtBQfRfjzjWlLlZ52+B8
         UNPg==
X-Gm-Message-State: AFqh2kpfAJd7NmP8JBxmlNRNJQgO5WRyC0MY09ZVg9TrW2ontFHMnF8s
	EGCOfIoYFYVw3N4uueS9haKl2gBKeK+KG56Fxe1lWkyKOArytNgFFWb6qAhjWU4XfW9+htVZUn7
	tpDnszn2DB0BMkySi
X-Received: by 2002:a05:6a00:1d9f:b0:58d:b0fa:b06c with SMTP id z31-20020a056a001d9f00b0058db0fab06cmr572210pfw.2.1673940340633;
        Mon, 16 Jan 2023 23:25:40 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt0UTiKkfB6JIEw1SLnhkzfEJdF53LAEN301MosO5Q52ywY8yfSHDwLCATeOQ5pGWlB4MN0eA==
X-Received: by 2002:a05:6a00:1d9f:b0:58d:b0fa:b06c with SMTP id z31-20020a056a001d9f00b0058db0fab06cmr572198pfw.2.1673940340382;
        Mon, 16 Jan 2023 23:25:40 -0800 (PST)
Received: from [10.72.13.64] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f7-20020a623807000000b00589500f19d0sm15197326pfa.142.2023.01.16.23.25.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 23:25:39 -0800 (PST)
Message-ID: <ce52d9fc-cd1f-9863-0f3a-b83eb0c36e5d@redhat.com>
Date: Tue, 17 Jan 2023 15:25:32 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 0/8] KVM: arm64: PMU: Allow userspace to limit the
 number of PMCs on vCPU
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
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230117013542.371944-1-reijiw@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Reiji,


I have tested this patch set on an Ampere machine, and every thing works 
fine.


Tested-by: Shaoqin Huang <shahuang@redhat.com>

On 1/17/23 09:35, Reiji Watanabe wrote:
> The goal of this series is to allow userspace to limit the number
> of PMU event counters on the vCPU. We need this to support migration
> across systems that implement different numbers of counters.
>
> The number of PMU event counters is indicated in PMCR_EL0.N.
> For a vCPU with PMUv3 configured, its value will be the same as
> the host value by default. Userspace can set PMCR_EL0.N for the
> vCPU to a lower value than the host value, using KVM_SET_ONE_REG.
> However, it is practically unsupported, as KVM resets PMCR_EL0.N
> to the host value on vCPU reset and some KVM code uses the host
> value to identify (un)implemented event counters on the vCPU.
>
> This series will ensure that the PMCR_EL0.N value is preserved
> on vCPU reset and that KVM doesn't use the host value
> to identify (un)implemented event counters on the vCPU.
> This allows userspace to limit the number of the PMU event
> counters on the vCPU.
>
> Patch 1 fixes reset_pmu_reg() to ensure that (RAZ) bits of
> {PMCNTEN,PMOVS}{SET,CLR}_EL1 corresponding to unimplemented event
> counters on the vCPU are reset to zero even when PMCR_EL0.N for
> the vCPU is different from the host.
>
> Patch 2 is a minor refactoring to use the default PMU register reset
> function (reset_pmu_reg()) for PMUSERENR_EL0 and PMCCFILTR_EL0.
> (With the Patch 1 change, reset_pmu_reg() can now be used for
> those registers)
>
> Patch 3 fixes reset_pmcr() to preserve PMCR_EL0.N for the vCPU on
> vCPU reset.
>
> Patch 4 adds the sys_reg's set_user() handler for the PMCR_EL0
> to disallow userspace to set PMCR_EL0.N for the vCPU to a value
> that is greater than the host value.
>
> Patch 5-8 adds a selftest to verify reading and writing PMU registers
> for implemented or unimplemented PMU event counters on the vCPU.
>
> The series is based on v6.2-rc4.
>
> v2:
>   - Added the sys_reg's set_user() handler for the PMCR_EL0 to
>     disallow userspace to set PMCR_EL0.N for the vCPU to a value
>     that is greater than the host value (and added a new test
>     case for this behavior). [Oliver]
>   - Added to the commit log of the patch 2 that PMUSERENR_EL0 and
>     PMCCFILTR_EL0 have UNKNOWN reset values.
>
> v1: https://lore.kernel.org/all/20221230035928.3423990-1-reijiw@google.com/
>
> Reiji Watanabe (8):
>    KVM: arm64: PMU: Have reset_pmu_reg() to clear a register
>    KVM: arm64: PMU: Use reset_pmu_reg() for PMUSERENR_EL0 and
>      PMCCFILTR_EL0
>    KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value on vCPU reset
>    KVM: arm64: PMU: Disallow userspace to set PMCR.N greater than the
>      host value
>    tools: arm64: Import perf_event.h
>    KVM: selftests: aarch64: Introduce vpmu_counter_access test
>    KVM: selftests: aarch64: vPMU register test for implemented counters
>    KVM: selftests: aarch64: vPMU register test for unimplemented counters
>
>   arch/arm64/kvm/pmu-emul.c                     |   6 +
>   arch/arm64/kvm/sys_regs.c                     |  57 +-
>   tools/arch/arm64/include/asm/perf_event.h     | 258 +++++++
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../kvm/aarch64/vpmu_counter_access.c         | 644 ++++++++++++++++++
>   .../selftests/kvm/include/aarch64/processor.h |   1 +
>   6 files changed, 954 insertions(+), 13 deletions(-)
>   create mode 100644 tools/arch/arm64/include/asm/perf_event.h
>   create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
>
>
> base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4

-- 
Regards,
Shaoqin

