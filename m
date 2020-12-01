Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0518C64E7C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 12:25:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3FBDC221FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 12:25:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FBDC221FE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE9144B33C;
	Wed,  2 Dec 2020 07:25:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LH9vpg1p-oSz; Wed,  2 Dec 2020 07:25:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B4094B351;
	Wed,  2 Dec 2020 07:25:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAAFE4C253
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:33:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m+OMuYFtxPmk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 08:33:37 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E3D04C251
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:33:37 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Cljhz3sStzhl60;
 Tue,  1 Dec 2020 21:33:07 +0800 (CST)
Received: from huawei.com (10.174.185.226) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 1 Dec 2020
 21:33:18 +0800
From: Xingang Wang <wangxingang5@huawei.com>
To: <eric.auger@redhat.com>
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Date: Tue, 1 Dec 2020 13:33:10 +0000
Message-ID: <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
X-Mailer: git-send-email 2.6.4.windows.1
In-Reply-To: <20201118112151.25412-8-eric.auger@redhat.com>
References: <20201118112151.25412-8-eric.auger@redhat.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Wed, 02 Dec 2020 07:25:22 -0500
Cc: xieyingtai@huawei.com, jean-philippe@linaro.org, kvm@vger.kernel.org,
 maz@kernel.org, joro@8bytes.org, will@kernel.org,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 vivek.gautam@arm.com, alex.williamson@redhat.com, zhangfei.gao@linaro.org,
 robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

Hi Eric

On  Wed, 18 Nov 2020 12:21:43, Eric Auger wrote:
>@@ -1710,7 +1710,11 @@ static void arm_smmu_tlb_inv_context(void *cookie)
> 	 * insertion to guarantee those are observed before the TLBI. Do be
> 	 * careful, 007.
> 	 */
>-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>+	if (ext_asid >= 0) { /* guest stage 1 invalidation */
>+		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
>+		cmd.tlbi.asid	= ext_asid;
>+		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
>+	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {

Found a problem here, the cmd for guest stage 1 invalidation is built,
but it is not delivered to smmu.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
