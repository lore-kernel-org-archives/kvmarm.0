Return-Path: <SRS0=1uZD=C4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FB2C43463
	for <kvmarm@archiver.kernel.org>; Sat, 19 Sep 2020 11:16:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2375208C7
	for <kvmarm@archiver.kernel.org>; Sat, 19 Sep 2020 11:16:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2375208C7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F27F64B161;
	Sat, 19 Sep 2020 07:16:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I3qGUnGinXbJ; Sat, 19 Sep 2020 07:16:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F20064B2FB;
	Sat, 19 Sep 2020 07:15:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A996C4B2FB
 for <kvmarm@lists.cs.columbia.edu>; Sat, 19 Sep 2020 07:15:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R1rH-02A+0yO for <kvmarm@lists.cs.columbia.edu>;
 Sat, 19 Sep 2020 07:15:57 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E19D4B2F9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 19 Sep 2020 07:15:57 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 0BAC450C2E2CAE8B0AC4;
 Sat, 19 Sep 2020 19:15:49 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 19:15:38 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
Subject: KVM_SET_DEVICE_ATTR failed
To: <qemu-arm@nongnu.org>, <kvmarm@lists.cs.columbia.edu>,
 <kvm@vger.kernel.org>
Message-ID: <1f70926e-27dd-9e30-3d0f-770130112777@huawei.com>
Date: Sat, 19 Sep 2020 19:15:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Language: en-US
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>, Alex Williamson <alex.williamson@redhat.com>
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

I had booted a guest with an assigned virtual function, with GICv4
(direct MSI injection) enabled on my arm64 server. I got the following
QEMU error message on its shutdown:

"qemu-system-aarch64: KVM_SET_DEVICE_ATTR failed: Group 4 attr 
0x0000000000000001: Permission denied"

The problem is that the KVM_DEV_ARM_ITS_SAVE_TABLES ioctl failed while
stopping the VM.

As for the kernel side, it turned out that an LPI with irq->hw=true was
observed while saving ITT for the device. KVM simply failed the save
operation by returning -EACCES to user-space. The reason is explained in
the comment block of vgic_its_save_itt(), though I think the HW bit
should actually be checked in the KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
ioctl rather than in the ITT saving, well, it isn't much related to this
problem...

I had noticed that some vectors had been masked by guest VF-driver on
shutdown, the correspond VLPIs had therefore been unmapped and irq->hw
was cleared. But some other vectors were un-handled. I *guess* that VFIO
released these vectors *after* the KVM_DEV_ARM_ITS_SAVE_TABLES ioctl so
that we end-up trying to save the VLPI's state.

It may not be a big problem as the guest is going to shutdown anyway and
the whole guest save/restore on the GICv4.x system is not supported for
the time being... I'll look at how VFIO would release these vectors but
post it early in case this is an already known issue (and this might be
one thing need to be considered if one wants to implement migration on
the GICv4.x system).


Thanks,
Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
