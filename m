Return-Path: <SRS0=AgFV=KV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2A7C47088
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 14:18:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 618CA61248
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 14:18:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 618CA61248
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCDE84A4E5;
	Wed, 26 May 2021 10:18:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5kZdNAAT5jrx; Wed, 26 May 2021 10:18:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB5E040CF9;
	Wed, 26 May 2021 10:18:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CACA640CF8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 10:18:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AlD84y6VisLB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 May 2021 10:18:48 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B118440CF9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 10:18:47 -0400 (EDT)
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FqtKd6ry2zmZ6j;
 Wed, 26 May 2021 22:16:21 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 22:18:42 +0800
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 26 May 2021 22:18:42 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: arm64: Resolve all pending PC updates before immediate
 exit
Date: Wed, 26 May 2021 22:18:31 +0800
Message-ID: <20210526141831.1662-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Cc: maz@kernel.org
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

Commit 26778aaa134a ("KVM: arm64: Commit pending PC adjustemnts before
returning to userspace") fixed the PC updating issue by forcing an explicit
synchronisation of the exception state on vcpu exit to userspace.

However, we forgot to take into account the case where immediate_exit is
set by userspace and KVM_RUN will exit immediately. Fix it by resolving all
pending PC updates before returning to userspace.

Since __kvm_adjust_pc() relies on a loaded vcpu context, I moved the
immediate_exit checking right after vcpu_load(). We will get some overhead
if immediate_exit is true (which should hopefully be rare).

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---

This patch can be applied on top of kvmarm/fixes and help me to PASS all
kvm-unit-tests cases in the migration group.

 arch/arm64/kvm/arm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1126eae27400..e720148232a0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -720,11 +720,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	if (run->immediate_exit)
-		return -EINTR;
-
 	vcpu_load(vcpu);
 
+	if (run->immediate_exit) {
+		ret = -EINTR;
+		goto out;
+	}
+
 	kvm_sigset_activate(vcpu);
 
 	ret = 1;
@@ -897,6 +899,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_sigset_deactivate(vcpu);
 
+out:
 	/*
 	 * In the unlikely event that we are returning to userspace
 	 * with pending exceptions or PC adjustment, commit these
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
