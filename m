Return-Path: <SRS0=iFZl=WC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D6AC31E40
	for <kvmarm@archiver.kernel.org>; Tue,  6 Aug 2019 08:55:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9CDFC2070D
	for <kvmarm@archiver.kernel.org>; Tue,  6 Aug 2019 08:55:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CDFC2070D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F6064A572;
	Tue,  6 Aug 2019 04:55:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vxzBwAKpna7t; Tue,  6 Aug 2019 04:55:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F7FC4A562;
	Tue,  6 Aug 2019 04:55:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 231EC4A531
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Aug 2019 04:55:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yTn3mIqnrHxf for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Aug 2019 04:55:26 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB47A4A4F3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Aug 2019 04:55:25 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 00BF69BDC5D9930B0BAB;
 Tue,  6 Aug 2019 16:55:23 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Tue, 6 Aug 2019
 16:55:12 +0800
Subject: Re: [PATCH 1/2] KVM: arm64: Don't write junk to sysregs on reset
To: Marc Zyngier <maz@kernel.org>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, <linux-arm-kernel@lists.infradead.org>
References: <20190805121555.130897-1-maz@kernel.org>
 <20190805121555.130897-2-maz@kernel.org>
 <01b74492-c59f-dfd9-e439-752e6b1c53dc@huawei.com>
 <7b36f1dd-e44f-af75-0e51-8f6e705e81f6@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <1a5eb1cb-99e4-6e20-576a-076ca4fd3342@huawei.com>
Date: Tue, 6 Aug 2019 16:52:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <7b36f1dd-e44f-af75-0e51-8f6e705e81f6@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
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

On 2019/8/6 16:35, Marc Zyngier wrote:
> On 06/08/2019 07:29, Zenghui Yu wrote:
>> Hi Marc,
>>
>> On 2019/8/5 20:15, Marc Zyngier wrote:
>>> At the moment, the way we reset system registers is mildly insane:
>>> We write junk to them, call the reset functions, and then check that
>>> we have something else in them.
>>>
>>> The "fun" thing is that this can happen while the guest is running
>>> (PSCI, for example). If anything in KVM has to evaluate the state
>>> of a system register while junk is in there, bad thing may happen.
>>>
>>> Let's stop doing that. Instead, we track that we have called a
>>> reset function for that register, and assume that the reset
>>> function has done something. This requires fixing a couple of
>>> sysreg refinition in the trap table.
>>>
>>> In the end, the very need of this reset check is pretty dubious,
>>> as it doesn't check everything (a lot of the sysregs leave outside of
>>> the sys_regs[] array). It may well be axed in the near future.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>
>> (Regardless of whether this check is needed or not,) I tested this patch
>> with kvm-unit-tests:
>>
>> for i in {1..100}; do QEMU=/path/to/qemu-system-aarch64 accel=kvm
>> arch=arm64 ./run_tests.sh; done
>>
>> And all the tests passed!
> 
> Great! Can I take this as a 'Tested-by:'?

Yes, please add:

Tested-by: Zenghui Yu <yuzenghui@huawei.com>


Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
