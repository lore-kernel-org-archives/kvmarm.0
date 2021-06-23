Return-Path: <SRS0=kEaE=LR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA37C48BE5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Jun 2021 11:08:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B80561026
	for <kvmarm@archiver.kernel.org>; Wed, 23 Jun 2021 11:08:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B80561026
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6C374A3A5;
	Wed, 23 Jun 2021 07:08:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sdDtsQaneGVX; Wed, 23 Jun 2021 07:08:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9466C4A3A3;
	Wed, 23 Jun 2021 07:08:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A1004081C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jun 2021 05:06:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cxO16y1vK1CH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Jun 2021 05:06:44 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B4C54080B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jun 2021 05:06:44 -0400 (EDT)
IronPort-SDR: CyABwKvoQDWP0cOPMozKUMs5TXDNlChfR4BuZgSay/b1eWBnuSE6uM0yZeaoyFZnLwTvcWWDfr
 Wg8S6Oj7mSog==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="228792333"
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; d="scan'208";a="228792333"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 23 Jun 2021 02:06:43 -0700
IronPort-SDR: g2eO6eKo7NA4GY19a7CouO+5j1o7GAnTSLroawrK3+rYpOJrEVfMjr60J7q5kjcIpvJfXcjBDr
 3E4HH0+4OM1A==
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; d="scan'208";a="487232734"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.30.127])
 ([10.255.30.127])
 by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 23 Jun 2021 02:06:38 -0700
Subject: Re: [PATCH V7 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, pbonzini@redhat.com
References: <20210622093823.8215-1-lingshan.zhu@intel.com>
 <20210622093823.8215-2-lingshan.zhu@intel.com>
 <92fdf981-68ef-92a2-b1ae-0c5f347ae460@oracle.com>
From: "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <43f6bb94-616c-f0c9-edc6-a72ea1244f59@intel.com>
Date: Wed, 23 Jun 2021 17:06:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <92fdf981-68ef-92a2-b1ae-0c5f347ae460@oracle.com>
Content-Language: en-US
X-Mailman-Approved-At: Wed, 23 Jun 2021 07:08:13 -0400
Cc: Like Xu <like.xu@linux.intel.com>, Nick Hu <nickhu@andestech.com>,
 Peter Zijlstra <peterz@infradead.org>, Marc Zyngier <maz@kernel.org>,
 linux-csky@vger.kernel.org, Guo Ren <guoren@kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, bp@alien8.de,
 xen-devel@lists.xenproject.org, linux-riscv@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kan.liang@linux.intel.com
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

Thanks Boris, I will fix this in V8

On 6/23/2021 1:31 AM, Boris Ostrovsky wrote:
>
> On 6/22/21 5:38 AM, Zhu Lingshan wrote:
>
>> -static int xen_is_user_mode(void)
>> -{
>> -	const struct xen_pmu_data *xenpmu_data = get_xenpmu_data();
>> +	state |= PERF_GUEST_ACTIVE;
>>   
>> -	if (!xenpmu_data) {
>> -		pr_warn_once("%s: pmudata not initialized\n", __func__);
>> -		return 0;
>> +	if (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_PV) {
>> +		if (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_USER)
>> +			state |= PERF_GUEST_USER;
>> +	} else {
>> +		if (!!(xenpmu_data->pmu.r.regs.cpl & 3))
>> +			state |= PERF_GUEST_USER;
>
>
> Please drop "!!", it's not needed here. And use "else if".
>
>
> With that, for Xen bits:
>
> Reviewed-by: Boris Ostrovsky <boris.ostrvsky@oracle.com>
>
> -boris
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
