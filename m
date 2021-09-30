Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E02FC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 08:06:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E72EE61528
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 08:06:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E72EE61528
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BD6A4086D;
	Thu, 30 Sep 2021 04:06:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id txvn2KRO90do; Thu, 30 Sep 2021 04:06:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7551C4A534;
	Thu, 30 Sep 2021 04:06:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A5004086D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 04:06:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ns9Poa6ScuAY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 04:06:39 -0400 (EDT)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCFD1407F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 04:06:38 -0400 (EDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
 by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKm4p4KzQz1DHQH;
 Thu, 30 Sep 2021 16:05:14 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 16:06:34 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Thu, 30 Sep 2021 16:06:31 +0800
Subject: Re: [PATCH v7 12/15] KVM: arm64: selftests: Add basic GICv3 support
To: Raghavendra Rao Ananta <rananta@google.com>
References: <20210914223114.435273-1-rananta@google.com>
 <20210914223114.435273-13-rananta@google.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <ab2a7213-1857-6761-594d-958af864a23a@huawei.com>
Date: Thu, 30 Sep 2021 16:06:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210914223114.435273-13-rananta@google.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021/9/15 6:31, Raghavendra Rao Ananta wrote:
> +static inline void *gicr_base_gpa_cpu(void *redist_base, uint32_t cpu)
> +{
> +	/* Align all the redistributors sequentially */
> +	return redist_base + cpu * SZ_64K * 2;
> +}
> +
> +static void gicv3_cpu_init(unsigned int cpu, void *redist_base)
> +{
> +	void *sgi_base;
> +	unsigned int i;
> +	void *redist_base_cpu;
> +
> +	GUEST_ASSERT(cpu < gicv3_data.nr_cpus);
> +
> +	redist_base_cpu = gicr_base_gpa_cpu(redist_base, cpu);

This is not 'gpa' and I'd rather open-code it directly as there's
just a single caller.

Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
