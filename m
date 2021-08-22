Return-Path: <SRS0=jhc2=NN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552C4C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 15:25:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D88AA61262
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 15:25:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D88AA61262
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CA9C4B174;
	Sun, 22 Aug 2021 11:25:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bXJL6ODyMp5s; Sun, 22 Aug 2021 11:25:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 411D94B212;
	Sun, 22 Aug 2021 11:25:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9744C4B1F3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 11:25:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZhcrFc9xY2Y3 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 22 Aug 2021 11:25:36 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7EAE14B1AC
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 11:25:36 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 733B26112F;
 Sun, 22 Aug 2021 15:25:35 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mHpLp-006VTo-Mm; Sun, 22 Aug 2021 16:25:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 1/3] kvmtool: Abstract KVM_VM_TYPE into a weak function
Date: Sun, 22 Aug 2021 16:25:24 +0100
Message-Id: <20210822152526.1291918-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210822152526.1291918-1-maz@kernel.org>
References: <20210822152526.1291918-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
 alexandru.elisei@arm.com, will@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 Will Deacon <will@kernel.org>
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

Most architectures pass a fixed value for their VM type. However,
arm64 uses it as a parameter describing the size of the guest's
physical address space.

In order to support this, introduce a kvm__get_vm_type() helper
that only returns KVM_VM_TYPE for now.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/kvm/kvm.h | 1 +
 kvm.c             | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 56e9c8e3..ad732e56 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -114,6 +114,7 @@ int kvm__init(struct kvm *kvm);
 struct kvm *kvm__new(void);
 int kvm__recommended_cpus(struct kvm *kvm);
 int kvm__max_cpus(struct kvm *kvm);
+int kvm__get_vm_type(struct kvm *kvm);
 void kvm__init_ram(struct kvm *kvm);
 int kvm__exit(struct kvm *kvm);
 bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename);
diff --git a/kvm.c b/kvm.c
index e327541d..5bc66c8b 100644
--- a/kvm.c
+++ b/kvm.c
@@ -428,6 +428,11 @@ int kvm__max_cpus(struct kvm *kvm)
 	return ret;
 }
 
+int __attribute__((weak)) kvm__get_vm_type(struct kvm *kvm)
+{
+	return KVM_VM_TYPE;
+}
+
 int kvm__init(struct kvm *kvm)
 {
 	int ret;
@@ -461,7 +466,7 @@ int kvm__init(struct kvm *kvm)
 		goto err_sys_fd;
 	}
 
-	kvm->vm_fd = ioctl(kvm->sys_fd, KVM_CREATE_VM, KVM_VM_TYPE);
+	kvm->vm_fd = ioctl(kvm->sys_fd, KVM_CREATE_VM, kvm__get_vm_type(kvm));
 	if (kvm->vm_fd < 0) {
 		pr_err("KVM_CREATE_VM ioctl");
 		ret = kvm->vm_fd;
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
