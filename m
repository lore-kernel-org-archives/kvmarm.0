Return-Path: <SRS0=O4n2=IX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB00DC433C1
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 09:15:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A7A361A1E
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 09:15:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A7A361A1E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3F814B434;
	Thu, 25 Mar 2021 05:15:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 37VJR05RBnqo; Thu, 25 Mar 2021 05:15:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 743064B308;
	Thu, 25 Mar 2021 05:15:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC24F4B2D9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 05:15:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2CymOaF3mFMI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 05:15:24 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BD594B289
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 05:15:23 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F5fXy13N9zlVtH;
 Thu, 25 Mar 2021 17:13:38 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.26.249) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 17:15:07 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>
Subject: [PATCH for-stable-5.10 0/2] Backport for- Work around firmware
 wrongly advertising GICv2 compatibility 
Date: Thu, 25 Mar 2021 09:14:22 +0000
Message-ID: <20210325091424.26348-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.47.26.249]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org, linuxarm@huawei.com, pbonzini@redhat.com
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

Backport 2 patches that are required on ARM64 platforms having
firmware wrongly advertising GICv2 compatibility.

Patch 1 has nvhe related conflict resolution while patch 2 is
cleanly applied.

Tested on HiSilicon D06 platform.

Marc Zyngier (2):
  KVM: arm64: Rename __vgic_v3_get_ich_vtr_el2() to
    __vgic_v3_get_gic_config()
  KVM: arm64: Workaround firmware wrongly advertising GICv2-on-v3
    compatibility

 arch/arm64/include/asm/kvm_asm.h   |  4 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  4 +--
 arch/arm64/kvm/hyp/vgic-v3-sr.c    | 40 ++++++++++++++++++++++++++++--
 arch/arm64/kvm/vgic/vgic-v3.c      | 12 ++++++---
 4 files changed, 51 insertions(+), 9 deletions(-)

-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
