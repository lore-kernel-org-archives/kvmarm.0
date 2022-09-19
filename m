Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC29DC54EE9
	for <kvmarm@archiver.kernel.org>; Mon, 19 Sep 2022 14:31:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 396D44B6F9;
	Mon, 19 Sep 2022 10:31:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GjEpD3xVRhR0; Mon, 19 Sep 2022 10:31:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6EDA4B601;
	Mon, 19 Sep 2022 10:31:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBB5D4B64F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 10:31:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GbUuLtfZpMWV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2022 10:31:35 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 358504B125
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 10:31:35 -0400 (EDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MWRrf6nWmzHnwW;
 Mon, 19 Sep 2022 22:29:22 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 22:31:30 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 22:31:29 +0800
Subject: Re: [kvm-unit-tests PATCH v4 08/12] arm: pmu: Test SW_INCR event count
To: Eric Auger <eric.auger@redhat.com>
References: <20200403071326.29932-1-eric.auger@redhat.com>
 <20200403071326.29932-9-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <64be8eda-a396-26a1-1a05-d43a3ed53c1d@huawei.com>
Date: Mon, 19 Sep 2022 22:31:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200403071326.29932-9-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

> +static void test_sw_incr(void)
> +{
> +	uint32_t events[] = {SW_INCR, SW_INCR};
> +	int i;
> +
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +		return;
> +
> +	pmu_reset();
> +
> +	write_regn_el0(pmevtyper, 0, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
> +	/* enable counters #0 and #1 */
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +
> +	for (i = 0; i < 100; i++)
> +		write_sysreg(0x1, pmswinc_el0);
> +
> +	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
> +	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> +		"PWSYNC does not increment if PMCR.E is unset");
> +
> +	pmu_reset();
> +
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +
> +	for (i = 0; i < 100; i++)
> +		write_sysreg(0x3, pmswinc_el0);
> +
> +	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");

"counter #0 after + 100 SW_INCR"

> +	report(read_regn_el0(pmevcntr, 1)  == 100,
> +		"counter #0 after + 100 SW_INCR");

"counter #1 after + 100 SW_INCR"

> +	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
> +		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> +	report(read_sysreg(pmovsclr_el0) == 0x1,
> +		"overflow reg after 100 SW_INCR");
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
