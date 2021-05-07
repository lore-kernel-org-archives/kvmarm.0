Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5A8C433B4
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 05:57:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A4C34613EA
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 05:57:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4C34613EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FC894B53D;
	Fri,  7 May 2021 01:57:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YSunAqY7+CM5; Fri,  7 May 2021 01:57:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23D5A4B53E;
	Fri,  7 May 2021 01:57:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 981784B413
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 01:57:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kx3Ov9rRyfAt for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 01:57:18 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C58044B2C8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 01:57:17 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fc04j1xbLzqSvh;
 Fri,  7 May 2021 13:53:57 +0800 (CST)
Received: from [10.67.77.175] (10.67.77.175) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0;
 Fri, 7 May 2021 13:57:04 +0800
To: <kvmarm@lists.cs.columbia.edu>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <linux-pci@vger.kernel.org>
From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: Question on guest enable msi fail when using GICv4/4.1
Message-ID: <3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com>
Date: Fri, 7 May 2021 13:57:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Language: en-US
X-Originating-IP: [10.67.77.175]
X-CFilter-Loop: Reflected
Cc: Bjorn Helgaas <bhelgaas@google.com>, Marc Zyngier <maz@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>
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

[This letter comes from Nianyao Tang]

Hi,

Using GICv4/4.1 and msi capability, guest vf driver requires 3 vectors and enable msi, will lead to
guest stuck. Qemu gets number of interrupts from Multiple Message Capable field set by guest. This
field is aligned to a power of 2(if a function requires 3 vectors, it initializes it to 2).
However, guest driver just sends 3 mapi-cmd to vits and 3 ite entries is recorded in host.
Vfio initializes msi interrupts using the number of interrupts 4 provide by qemu.
When it comes to the 4th msi without ite in vits, in irq_bypass_register_producer, producer
and consumer will __connect fail, due to find_ite fail, and do not resume guest.

Do we support this case, Guest function using msi interrupts number not aligned to a power of 2?
Or qemu should provide correct msi interrupts number?

Thanks,
Shaokun
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
