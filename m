Return-Path: <SRS0=eGRX=V6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F61C32750
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 14:50:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD257216C8
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 14:50:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD257216C8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76C7D4A55F;
	Fri,  2 Aug 2019 10:50:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gPWjA2mijPrU; Fri,  2 Aug 2019 10:50:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4DEB4A555;
	Fri,  2 Aug 2019 10:50:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 147014A546
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 10:50:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8i0keZfDE2HD for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Aug 2019 10:50:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB92C4A500
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 10:50:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98F0615A2;
 Fri,  2 Aug 2019 07:50:40 -0700 (PDT)
Received: from e112269-lin.arm.com (e112269-lin.cambridge.arm.com
 [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B2C8E3F575;
 Fri,  2 Aug 2019 07:50:38 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: 
Subject: [PATCH 5/9] KVM: Allow kvm_device_ops to be const
Date: Fri,  2 Aug 2019 15:50:13 +0100
Message-Id: <20190802145017.42543-6-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802145017.42543-1-steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-doc@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Steven Price <steven.price@arm.com>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Currently a kvm_device_ops structure cannot be const without triggering
compiler warnings. However the structure doesn't need to be written to
and, by marking it const, it can be read-only in memory. Add some more
const keywords to allow this.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 include/linux/kvm_host.h | 4 ++--
 virt/kvm/kvm_main.c      | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5c5b5867024c..be31a6f8351a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1236,7 +1236,7 @@ extern unsigned int halt_poll_ns_grow_start;
 extern unsigned int halt_poll_ns_shrink;
 
 struct kvm_device {
-	struct kvm_device_ops *ops;
+	const struct kvm_device_ops *ops;
 	struct kvm *kvm;
 	void *private;
 	struct list_head vm_node;
@@ -1289,7 +1289,7 @@ struct kvm_device_ops {
 void kvm_device_get(struct kvm_device *dev);
 void kvm_device_put(struct kvm_device *dev);
 struct kvm_device *kvm_device_from_filp(struct file *filp);
-int kvm_register_device_ops(struct kvm_device_ops *ops, u32 type);
+int kvm_register_device_ops(const struct kvm_device_ops *ops, u32 type);
 void kvm_unregister_device_ops(u32 type);
 
 extern struct kvm_device_ops kvm_mpic_ops;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 887f3b0c2b60..8c12110ec87a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3035,14 +3035,14 @@ struct kvm_device *kvm_device_from_filp(struct file *filp)
 	return filp->private_data;
 }
 
-static struct kvm_device_ops *kvm_device_ops_table[KVM_DEV_TYPE_MAX] = {
+static const struct kvm_device_ops *kvm_device_ops_table[KVM_DEV_TYPE_MAX] = {
 #ifdef CONFIG_KVM_MPIC
 	[KVM_DEV_TYPE_FSL_MPIC_20]	= &kvm_mpic_ops,
 	[KVM_DEV_TYPE_FSL_MPIC_42]	= &kvm_mpic_ops,
 #endif
 };
 
-int kvm_register_device_ops(struct kvm_device_ops *ops, u32 type)
+int kvm_register_device_ops(const struct kvm_device_ops *ops, u32 type)
 {
 	if (type >= ARRAY_SIZE(kvm_device_ops_table))
 		return -ENOSPC;
@@ -3063,7 +3063,7 @@ void kvm_unregister_device_ops(u32 type)
 static int kvm_ioctl_create_device(struct kvm *kvm,
 				   struct kvm_create_device *cd)
 {
-	struct kvm_device_ops *ops = NULL;
+	const struct kvm_device_ops *ops = NULL;
 	struct kvm_device *dev;
 	bool test = cd->flags & KVM_CREATE_DEVICE_TEST;
 	int type;
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
