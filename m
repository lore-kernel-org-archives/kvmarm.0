Return-Path: <SRS0=6NFX=5P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E673C2D0EB
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 10:44:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EFACA20716
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 10:44:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFACA20716
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A87F4B265;
	Mon, 30 Mar 2020 06:44:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0Ty2if6pavRp; Mon, 30 Mar 2020 06:43:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FB6D4B270;
	Mon, 30 Mar 2020 06:43:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F36804B1AF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 06:43:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 39z0gWAA0Jk9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Mar 2020 06:43:56 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 114094B134
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 06:43:56 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id C80DCD5780820CED5358;
 Mon, 30 Mar 2020 18:43:46 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Mon, 30 Mar 2020
 18:43:38 +0800
Subject: Re: [kvm-unit-tests PATCH v7 10/13] arm/arm64: ITS: INT functional
 tests
To: Eric Auger <eric.auger@redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-11-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <f7f1d7c4-2321-9123-2394-528af737bfa7@huawei.com>
Date: Mon, 30 Mar 2020 18:43:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200320092428.20880-11-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andre.przywara@arm.com, thuth@redhat.com,
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

On 2020/3/20 17:24, Eric Auger wrote:
> Triggers LPIs through the INT command.
> 
> the test checks the LPI hits the right CPU and triggers
> the right LPI intid, ie. the translation is correct.
> 
> Updates to the config table also are tested, along with inv
> and invall commands.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

[...]

So I've tested this series and found that the "INT" test will sometimes
fail.

"not ok 12 - gicv3: its-migration: dev2/eventid=20 triggers LPI 8195 en 
PE #3 after migration
not ok 13 - gicv3: its-migration: dev7/eventid=255 triggers LPI 8196 on 
PE #2 after migration"

 From logs:
"INFO: gicv3: its-migration: Migration complete
INT dev_id=2 event_id=20
INFO: gicv3: its-migration: No LPI received whereas (cpuid=3, 
intid=8195) was expected
FAIL: gicv3: its-migration: dev2/eventid=20 triggers LPI 8195 en PE #3 
after migration
INT dev_id=7 event_id=255
INFO: gicv3: its-migration: No LPI received whereas (cpuid=2, 
intid=8196) was expected
FAIL: gicv3: its-migration: dev7/eventid=255 triggers LPI 8196 on PE #2 
after migration"

> +static void check_lpi_stats(const char *msg)
> +{
> +	bool pass = false;
> +
> +	mdelay(100);

After changing this to 'mdelay(1000)', the above error doesn't show up
anymore. But it sounds strange that 100ms is not enough to deliver a
single LPI. I haven't dig it further but will get back here later.

> +	smp_rmb(); /* pairs with wmb in lpi_handler */
> +	if (lpi_stats.observed.cpu_id != lpi_stats.expected.cpu_id ||
> +	    lpi_stats.observed.lpi_id != lpi_stats.expected.lpi_id) {
> +		if (lpi_stats.observed.cpu_id == -1 &&
> +		    lpi_stats.observed.lpi_id == -1) {
> +			report_info("No LPI received whereas (cpuid=%d, intid=%d) "
> +				    "was expected", lpi_stats.expected.cpu_id,
> +				    lpi_stats.expected.lpi_id);
> +		} else {
> +			report_info("Unexpected LPI (cpuid=%d, intid=%d)",
> +				    lpi_stats.observed.cpu_id,
> +				    lpi_stats.observed.lpi_id);
> +		}
> +	} else {
> +		pass = true;
> +	}
> +	report(pass, "%s", msg);
> +}

This patch itself looks good to me,
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
