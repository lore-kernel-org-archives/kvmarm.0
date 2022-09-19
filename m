Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86D8C6FA99
	for <kvmarm@archiver.kernel.org>; Mon, 19 Sep 2022 14:32:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78ADA4B6EE;
	Mon, 19 Sep 2022 10:32:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l3ZwkFIljdk5; Mon, 19 Sep 2022 10:32:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18A634B64F;
	Mon, 19 Sep 2022 10:32:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BE0C4B601
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 10:31:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C3+BbpU+5uCO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2022 10:31:57 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03A124B125
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 10:31:56 -0400 (EDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MWRpq386lzlW1m;
 Mon, 19 Sep 2022 22:27:47 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 22:31:51 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 22:31:50 +0800
Subject: Re: [kvm-unit-tests PATCH v4 10/12] arm: pmu: test 32-bit <-> 64-bit
 transitions
To: Eric Auger <eric.auger@redhat.com>
References: <20200403071326.29932-1-eric.auger@redhat.com>
 <20200403071326.29932-11-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <cead0930-958d-222d-d5c0-6dfe6f88f52f@huawei.com>
Date: Mon, 19 Sep 2022 22:31:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200403071326.29932-11-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andre.przywara@arm.com, andrew.murray@arm.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Eric,

On 2020/4/3 15:13, Eric Auger wrote:

> +static void test_chain_promotion(void)
> +{

[...]

> +	/* start as MEM_ACCESS/CPU_CYCLES and move to CHAIN/MEM_ACCESS */
> +	pmu_reset();
> +	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2);
> +	isb();
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> +		    read_regn_el0(pmevcntr, 0));
> +
> +	/* 0 becomes CHAINED */

"1 becomes CHAINED"?

> +	write_sysreg_s(0x0, PMCNTENSET_EL0);

Writing 0 into PMCNTENSET_EL0 actually has no effect on the counter
status. What purpose does this serve?

> +	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	write_regn_el0(pmevcntr, 1, 0x0);
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> +		    read_regn_el0(pmevcntr, 0));
> +
> +	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
> +		"32b->64b: CHAIN counter incremented and no overflow");
> +
> +	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
> +		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
> +
> +	/* start as CHAIN/MEM_ACCESS and move to MEM_ACCESS/CPU_CYCLES */
> +	pmu_reset();
> +	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("counter #0=0x%lx, counter #1=0x%lx",
> +			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> +
> +	write_sysreg_s(0x0, PMCNTENSET_EL0);

Ditto

> +	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report(read_sysreg(pmovsclr_el0) == 1,
> +		"overflow is expected on counter 0");
> +	report_info("counter #0=0x%lx, counter #1=0x%lx overflow=0x%lx",
> +			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
> +			read_sysreg(pmovsclr_el0));
> +}
> +
>  #endif
>  
>  /*

Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
