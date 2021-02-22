Return-Path: <SRS0=UwAz=HY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D27DC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 22 Feb 2021 15:55:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A531764ED6
	for <kvmarm@archiver.kernel.org>; Mon, 22 Feb 2021 15:55:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A531764ED6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 486134B0F1;
	Mon, 22 Feb 2021 10:55:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5IciRtT+eEu2; Mon, 22 Feb 2021 10:55:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 532F84B153;
	Mon, 22 Feb 2021 10:55:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F8224B0F1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 10:55:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6tXlHetTbCgB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Feb 2021 10:54:59 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C3374B164
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 10:54:59 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Dkmtk25jGzjPyy;
 Mon, 22 Feb 2021 23:53:34 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.88.147) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Feb 2021 23:54:43 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>,
 <iommu@lists.linux-foundation.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [RFC PATCH 5/5] KVM: arm64: Make sure pinned vmid is released on VM
 exit
Date: Mon, 22 Feb 2021 15:53:38 +0000
Message-ID: <20210222155338.26132-6-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20210222155338.26132-1-shameerali.kolothum.thodi@huawei.com>
References: <20210222155338.26132-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.47.88.147]
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, maz@kernel.org, linuxarm@openeuler.org,
 alex.williamson@redhat.com, prime.zeng@hisilicon.com,
 jonathan.cameron@huawei.com, zhangfei.gao@linaro.org
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

Since the pinned VMID space is not recycled, we need to make sure that
we release the vmid back into the pool when we are done with it.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/kvm/arm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8955968be49f..d9900ffb88f4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -181,8 +181,16 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_vgic_destroy(kvm);
 
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		if (kvm->vcpus[i]) {
-			kvm_vcpu_destroy(kvm->vcpus[i]);
+		struct kvm_vcpu *vcpu = kvm->vcpus[i];
+
+		if (vcpu) {
+			struct kvm_vmid *vmid = &vcpu->arch.hw_mmu->vmid;
+
+			if (refcount_read(&vmid->pinned)) {
+				ida_free(&kvm_pinned_vmids, vmid->vmid);
+				refcount_set(&vmid->pinned, 0);
+			}
+			kvm_vcpu_destroy(vcpu);
 			kvm->vcpus[i] = NULL;
 		}
 	}
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
