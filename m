Return-Path: <SRS0=fdvM=VK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7D3C742A7
	for <kvmarm@archiver.kernel.org>; Sat, 13 Jul 2019 09:54:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 081FF20838
	for <kvmarm@archiver.kernel.org>; Sat, 13 Jul 2019 09:54:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 081FF20838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7075C4A51C;
	Sat, 13 Jul 2019 05:54:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o312Dgxt7e6g; Sat, 13 Jul 2019 05:54:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 804CB4A49C;
	Sat, 13 Jul 2019 05:54:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 835FE4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 13 Jul 2019 05:54:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wEiH5UNj2ebk for <kvmarm@lists.cs.columbia.edu>;
 Sat, 13 Jul 2019 05:54:09 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A5AB84A49C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 13 Jul 2019 05:54:09 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id D921CB7764657033EA41;
 Sat, 13 Jul 2019 17:54:05 +0800 (CST)
Received: from [127.0.0.1] (10.133.216.73) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Sat, 13 Jul 2019
 17:53:58 +0800
To: <qemu-arm@nongnu.org>, <qemu-devel@nongnu.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>
From: Guoheyi <guoheyi@huawei.com>
Subject: [RFC] Add virtual SDEI support in qemu
Message-ID: <1b0aa6b2-80b1-a72e-6849-7323c3b9c6bc@huawei.com>
Date: Sat, 13 Jul 2019 17:53:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
X-Originating-IP: [10.133.216.73]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <marc.zyngier@arm.com>
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

Hi folks,

Do it make sense to implement virtual SDEI in qemu? So that we can have 
the standard way for guest to handle NMI watchdog, RAS events and 
something else which involves SDEI in a physical ARM64 machine.

My basic idea is like below:

1. Change a few lines of code in kvm to allow unhandled SMC invocations 
(like SDEI) to be sent to qemu, with exit reason of KVM_EXIT_HYPERCALL, 
so we don't need to add new API.

2. qemu handles supported SDEI calls just as the spec says for what a 
hypervisor should do for a guest OS.

3. For interrupts bound to hypervisor, qemu should stop injecting the 
IRQ to guest through KVM, but jump to the registered event handler 
directly, including context saving and restoring. Some interrupts like 
virtual timer are handled by kvm directly, so we may refuse to bind such 
interrupts to SDEI events.

Any comment or suggestion will be really appreciated.

Heyi



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
