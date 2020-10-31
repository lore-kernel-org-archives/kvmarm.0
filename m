Return-Path: <SRS0=+BBk=EG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_DOTEDU_SUSP,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5CAC388F7
	for <kvmarm@archiver.kernel.org>; Sat, 31 Oct 2020 07:03:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E45B22076D
	for <kvmarm@archiver.kernel.org>; Sat, 31 Oct 2020 07:03:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E45B22076D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 288014B560;
	Sat, 31 Oct 2020 03:03:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U3qJsDDJ+Ihg; Sat, 31 Oct 2020 03:03:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED6414B4A1;
	Sat, 31 Oct 2020 03:03:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 299254B4A1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 31 Oct 2020 03:03:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V5v2NqlTsMdi for <kvmarm@lists.cs.columbia.edu>;
 Sat, 31 Oct 2020 03:03:07 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 182104B3A6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 31 Oct 2020 03:03:07 -0400 (EDT)
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.53])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CNVWD5lG7zQlsF;
 Sat, 31 Oct 2020 15:03:04 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 31 Oct 2020 15:03:03 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 31 Oct 2020 15:03:03 +0800
To: <maz@kernel.org>
From: Peng Liang <liangpeng10@huawei.com>
Subject: VM live migration failed from Linux v5.9 to Linux v5.10-rc1
Message-ID: <5ade34aa-e725-93e8-7b28-83fb25dcf896@huawei.com>
Date: Sat, 31 Oct 2020 15:03:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
Content-Language: en-US
X-Originating-IP: [10.174.185.187]
X-ClientProxiedBy: dggeme717-chm.china.huawei.com (10.1.199.113) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu
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

Hi Marc,
Sorry for disturbing you.

When I try to migrate a VM from Linux v5.9 to Linux v5.10-rc1, QEMU
reports errors like this:
  qemu-system-aarch64: write 0x603000000013c020(0x0100010011111111) to
kvm failed
  qemu-system-aarch64: error while loading state for instance 0x0 of
device 'cpu'

(The first error is added by myself:
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 8bb7318378..b361f62f7f 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -560,6 +560,7 @@ bool write_list_to_kvmstate(ARMCPU *cpu, int level)
              * "you tried to set a register which is constant with
              * a different value from what it actually contains".
              */
+            error_report("write 0x%016lx(0x%016lx) to kvm failed",
cpu->cpreg_indexes[i], cpu->cpreg_values[i]);
             ok = false;
         }
     }
)

If I try to migrate from Linux v5.10-rc1 to v5.9, then the errors are
changed to:
  qemu-system-aarch64: write 0x603000000013c020(0x0000010011111111) to
kvm failed
  error while loading state for instance 0x0 of device 'cpu'

However, the migration from v5.9 to v5.9 or from v5.10-rc1 to v5.10-rc1
are successful.

The source end and destination end of migration have the same hardware
and the same softwares except the Linux version. And of course, the
vCPUs of VMs are host-passthrough.

I found that the different register and the different field between
source and destination is ID_AA64PFR0_EL1.CSV2. I searched in git log
and found that the commit e1026237f9067 ("KVM: arm64: Set CSV2 for
guests on hardware unaffected by Spectre-v2") may be the cause of the
failure?

So do we need to make it possible to migrate VMs between Linux v5.9 and
Linux v5.10-rc1 with QEMU?

And here is the information of my environment:
CPU: Kunpeng-920
QEMU: v5.1.0, built with `../configure --target-list=aarch64-softmmu
--disable-werror`
source end:
  Linux: v5.9, configured with `make defconfig`
destination end:
  Linux: v5.10-rc1, configured with `make defconfig`

Thanks,
Peng
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
