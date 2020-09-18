Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8CD3C43463
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:51:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DBA5B21D20
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:51:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBA5B21D20
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AE9F4B3FC;
	Fri, 18 Sep 2020 05:51:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6FF6RYh6NpWq; Fri, 18 Sep 2020 05:51:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F39F4B3F1;
	Fri, 18 Sep 2020 05:51:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 869AE4B3F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:51:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vTdaXRbZO7n6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 05:51:54 -0400 (EDT)
Received: from huawei.com (szxga08-in.huawei.com [45.249.212.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA5294B3CA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:51:53 -0400 (EDT)
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.57])
 by Forcepoint Email with ESMTP id 4FDE4EFBB890ACBB930D;
 Fri, 18 Sep 2020 17:51:50 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 18 Sep 2020 17:51:28 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 18 Sep 2020 17:51:28 +0800
Subject: Re: [RFC v2 0/7] kvm: arm64: emulate ID registers
To: Andrew Jones <drjones@redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200918080106.5c6jqarj3mhwi3mv@kamzik.brq.redhat.com>
From: Peng Liang <liangpeng10@huawei.com>
Message-ID: <9847289d-c575-3ef6-4d6e-460227e8cc21@huawei.com>
Date: Fri, 18 Sep 2020 17:51:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918080106.5c6jqarj3mhwi3mv@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.187]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On 9/18/2020 4:01 PM, Andrew Jones wrote:
> On Thu, Sep 17, 2020 at 08:00:54PM +0800, Peng Liang wrote:
>> In AArch64, guest will read the same values of the ID regsiters with
>> host.  Both of them read the values from arm64_ftr_regs.  This patch
>> series add support to emulate and configure ID registers so that we can
>> control the value of ID registers that guest read.
>>
>> v1 -> v2:
>>  - save the ID registers in sysreg file instead of a new struct
>>  - apply a checker before setting the value to the register
>>  - add doc for new KVM_CAP_ARM_CPU_FEATURE
>>
>> Peng Liang (7):
>>   arm64: add a helper function to traverse arm64_ftr_regs
>>   arm64: introduce check_features
>>   kvm: arm64: save ID registers to sys_regs file
>>   kvm: arm64: introduce check_user
>>   kvm: arm64: implement check_user for ID registers
>>   kvm: arm64: make ID registers configurable
>>   kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
>>
>>  Documentation/virt/kvm/api.rst      |   8 +
>>  arch/arm64/include/asm/cpufeature.h |   4 +
>>  arch/arm64/include/asm/kvm_coproc.h |   2 +
>>  arch/arm64/include/asm/kvm_host.h   |   3 +
>>  arch/arm64/kernel/cpufeature.c      |  36 +++
>>  arch/arm64/kvm/arm.c                |   3 +
>>  arch/arm64/kvm/sys_regs.c           | 481 +++++++++++++++++++++++++++-
>>  arch/arm64/kvm/sys_regs.h           |   6 +
>>  include/uapi/linux/kvm.h            |   1 +
>>  9 files changed, 532 insertions(+), 12 deletions(-)
>>
>> -- 
>> 2.26.2
>>
> 
> Hi Peng,
> 
> I'd much rather see a series of patches where each patch converts a single
> ID register from using ID_SANITISED() to having its own table entry, where
> its own set_user() and reset() functions take into account its features
> using high level arm64_ftr* functions. Any ID registers that can still
> share code can certainly do so with some post-conversion refactoring.
> 
> Thanks,
> drew
> 
> .
> 
Hi Andrew,

Thank you for your advise.  I'll rework the code to use different set_user()
for different ID registers (maybe some general registers still use shareing
set_user()) and check the value defined by user space in its own set_user in
next version.

But do we need to implement reset() for ID registers?  I think ID registers
are read-only in guest and guest won't and can't change their values.  And
after 03fdfb2690099 ("KVM: arm64: Don't write junk to sysregs on reset"),
we won't write junk to sysregs on reset.  So their values won't change on
reset?

Thanks,
Peng
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
