Return-Path: <SRS0=G53S=WZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D902EC3A5A1
	for <kvmarm@archiver.kernel.org>; Thu, 29 Aug 2019 02:48:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62A312173E
	for <kvmarm@archiver.kernel.org>; Thu, 29 Aug 2019 02:48:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62A312173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA4CA4A531;
	Wed, 28 Aug 2019 22:48:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6i24pE+XJmZq; Wed, 28 Aug 2019 22:48:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC8D14A53D;
	Wed, 28 Aug 2019 22:48:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 927514A531
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 22:48:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2fBl+gX9Cosp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Aug 2019 22:48:25 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A52784A520
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 22:48:25 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 7CF3ED78A60A72B8A524;
 Thu, 29 Aug 2019 10:48:22 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Thu, 29 Aug 2019
 10:48:15 +0800
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Allow more than 256 vcpus for
 KVM_IRQ_LINE
To: Marc Zyngier <maz@kernel.org>, Peter Maydell <peter.maydell@linaro.org>,
 James Morse <james.morse@arm.com>, Julien Thierry
 <julien.thierry.kdev@gmail.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20190818140710.23920-1-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <47328538-01e6-3152-01f1-ae9c923f628f@huawei.com>
Date: Thu, 29 Aug 2019 10:46:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190818140710.23920-1-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

Hi Marc,

On 2019/8/18 22:07, Marc Zyngier wrote:
> While parts of the VGIC support a large number of vcpus (we
> bravely allow up to 512), other parts are more limited.
> 
> One of these limits is visible in the KVM_IRQ_LINE ioctl, which
> only allows 256 vcpus to be signalled when using the CPU or PPI
> types. Unfortunately, we've cornered ourselves badly by allocating
> all the bits in the irq field.
> 
> Since the irq_type subfield (8 bit wide) is currently only taking
> the values 0, 1 and 2 (and we have been careful not to allow anything
> else), let's reduce this field to only 4 bits, and allocate the
> remaining 4 bits to a vcpu2_index, which acts as a multiplier:
> 
>    vcpu_id = 256 * vcpu2_index + vcpu_index
> 
> With that, and a new capability (KVM_CAP_ARM_IRQ_LINE_LAYOUT_2)
> allowing this to be discovered, it becomes possible to inject
> PPIs to up to 4096 vcpus. But please just don't.
> 
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

And tested together with Eric's patches (KVM+QEMU).


Thanks,
zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
