Return-Path: <SRS0=woTa=5D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FCEC2BB1D
	for <kvmarm@archiver.kernel.org>; Wed, 18 Mar 2020 03:29:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B07BB206F1
	for <kvmarm@archiver.kernel.org>; Wed, 18 Mar 2020 03:29:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B07BB206F1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A8204A4A0;
	Tue, 17 Mar 2020 23:29:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BhTEbV3SVYdj; Tue, 17 Mar 2020 23:29:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D7A04A4A9;
	Tue, 17 Mar 2020 23:29:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0DFA4A4A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2020 23:29:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3dlfkF0IRKuL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Mar 2020 23:29:09 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D0C04A49F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2020 23:29:09 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 17D9D86B7533D136EEE3;
 Wed, 18 Mar 2020 11:29:06 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Wed, 18 Mar 2020
 11:28:58 +0800
Subject: Re: [PATCH v5 18/23] KVM: arm64: GICv4.1: Add direct injection
 capability to SGI registers
To: Marc Zyngier <maz@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-19-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <9c518e1d-5a0a-5438-a37d-d9250c4e6320@huawei.com>
Date: Wed, 18 Mar 2020 11:28:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-19-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>
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

On 2020/3/5 4:33, Marc Zyngier wrote:
> Most of the GICv3 emulation code that deals with SGIs now has to be
> aware of the v4.1 capabilities in order to benefit from it.
> 
> Add such support, keyed on the interrupt having the hw flag set and
> being a SGI.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
