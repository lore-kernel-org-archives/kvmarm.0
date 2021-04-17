Return-Path: <SRS0=JEd/=JO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F1DC433ED
	for <kvmarm@archiver.kernel.org>; Sat, 17 Apr 2021 09:00:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA8A36109F
	for <kvmarm@archiver.kernel.org>; Sat, 17 Apr 2021 09:00:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA8A36109F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DF9E4B2C6;
	Sat, 17 Apr 2021 05:00:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MTNHpjNi2GHJ; Sat, 17 Apr 2021 04:59:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 766FA4B2D2;
	Sat, 17 Apr 2021 04:59:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 966D54B2C6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Apr 2021 04:59:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id epGLAqBXvxkm for <kvmarm@lists.cs.columbia.edu>;
 Sat, 17 Apr 2021 04:59:54 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B57B4B1E6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Apr 2021 04:59:54 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FMn516YzyzPqwM;
 Sat, 17 Apr 2021 16:56:53 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 17 Apr 2021 16:59:42 +0800
Subject: Re: [PATCH v19 6/7] KVM: arm64: Add support for the KVM PTP service
To: Marc Zyngier <maz@kernel.org>
References: <20210330145430.996981-1-maz@kernel.org>
 <20210330145430.996981-7-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5aadf0b4-b9e5-8521-db60-52a0f319cf28@huawei.com>
Date: Sat, 17 Apr 2021 16:59:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210330145430.996981-7-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Cc: kernel-team@android.com, lorenzo.pieralisi@arm.com, justin.he@arm.com,
 kvm@vger.kernel.org, netdev@vger.kernel.org, richardcochran@gmail.com,
 yangbo.lu@nxp.com, sudeep.holla@arm.com, steven.price@arm.com,
 Andre.Przywara@arm.com, john.stultz@linaro.org,
 linux-arm-kernel@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com,
 tglx@linutronix.de, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
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

On 2021/3/30 22:54, Marc Zyngier wrote:
> +PTP_KVM support for arm/arm64
> +=============================
> +
> +PTP_KVM is used for high precision time sync between host and guests.
> +It relies on transferring the wall clock and counter value from the
> +host to the guest using a KVM-specific hypercall.
> +
> +* ARM_SMCCC_HYP_KVM_PTP_FUNC_ID: 0x86000001

Per include/linux/arm-smccc.h, this should be
ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID.

> +
> +This hypercall uses the SMC32/HVC32 calling convention:
> +
> +ARM_SMCCC_HYP_KVM_PTP_FUNC_ID

ditto

> +    =============    ==========    ==========
> +    Function ID:     (uint32)      0x86000001
> +    Arguments:       (uint32)      KVM_PTP_VIRT_COUNTER(0)
> +                                   KVM_PTP_PHYS_COUNTER(1)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
