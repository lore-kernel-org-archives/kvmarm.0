Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14375C46467
	for <kvmarm@archiver.kernel.org>; Tue,  3 Jan 2023 12:40:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CE764B6B9;
	Tue,  3 Jan 2023 07:40:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CWO5y3qY9VWx; Tue,  3 Jan 2023 07:40:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1992640683;
	Tue,  3 Jan 2023 07:40:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF08E4BB65
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 07:40:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mv9x8qlZfuNM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 07:40:38 -0500 (EST)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1F684BB67
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 07:40:37 -0500 (EST)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.207])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NmXJr05nbz6HJj0;
 Tue,  3 Jan 2023 20:35:55 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 3 Jan
 2023 12:40:34 +0000
Date: Tue, 3 Jan 2023 12:40:34 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 0/7] KVM: arm64: PMU: Allow userspace to limit the
 number of PMCs on vCPU
Message-ID: <20230103124034.000027aa@Huawei.com>
In-Reply-To: <20221230035928.3423990-1-reijiw@google.com>
References: <20221230035928.3423990-1-reijiw@google.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, 29 Dec 2022 19:59:21 -0800
Reiji Watanabe <reijiw@google.com> wrote:

> The goal of this series is to allow userspace to limit the number
> of PMU event counters on the vCPU.

Hi Rieji,

Why do you want to do this?

I can conjecture a bunch of possible reasons, but they may not
match up with your use case. It would be useful to have that information
in the cover letter.

Jonathan

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
> Patch 4-7 adds a selftest to verify reading and writing PMU registers
> for implemented or unimplemented PMU event counters on the vCPU.
> 
> The series is based on kvmarm/fixes at the following commit:
>   commit aff234839f8b ("KVM: arm64: PMU: Fix PMCR_EL0 reset value")
> 
> Reiji Watanabe (7):
>   KVM: arm64: PMU: Have reset_pmu_reg() to clear a register
>   KVM: arm64: PMU: Use reset_pmu_reg() for PMUSERENR_EL0 and
>     PMCCFILTR_EL0
>   KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value on vCPU reset
>   tools: arm64: Import perf_event.h
>   KVM: selftests: aarch64: Introduce vpmu_counter_access test
>   KVM: selftests: aarch64: vPMU register test for implemented counters
>   KVM: selftests: aarch64: vPMU register test for unimplemented counters
> 
>  arch/arm64/kvm/pmu-emul.c                     |   6 +
>  arch/arm64/kvm/sys_regs.c                     |  18 +-
>  tools/arch/arm64/include/asm/perf_event.h     | 258 ++++++++
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/aarch64/vpmu_counter_access.c         | 613 ++++++++++++++++++
>  .../selftests/kvm/include/aarch64/processor.h |   1 +
>  7 files changed, 886 insertions(+), 12 deletions(-)
>  create mode 100644 tools/arch/arm64/include/asm/perf_event.h
>  create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> 
> 
> base-commit: aff234839f8b80ac101e6c2f14d0e44b236efa48

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
