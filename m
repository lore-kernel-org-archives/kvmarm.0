Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995FCC433E2
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 09:01:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB10920738
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 09:01:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB10920738
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26A054B38C;
	Wed, 16 Sep 2020 05:01:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Tf4FUOw1vcs; Wed, 16 Sep 2020 05:01:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E7644B3AB;
	Wed, 16 Sep 2020 05:01:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FF404B252
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 22:28:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wG-jgKMamUhp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 22:28:02 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74BF64B22E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 22:28:02 -0400 (EDT)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 678E9B7BD0C502CE24B5;
 Wed, 16 Sep 2020 10:27:58 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 16 Sep 2020
 10:27:47 +0800
From: Liu Shixin <liushixin2@huawei.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, "Julien
 Thierry" <julien.thierry.kdev@gmail.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>
Subject: [PATCH -next] KVM: arm64: vgic-debug: convert to use
 DEFINE_SEQ_ATTRIBUTE macro
Date: Wed, 16 Sep 2020 10:50:23 +0800
Message-ID: <20200916025023.3992679-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Wed, 16 Sep 2020 05:01:11 -0400
Cc: Liu Shixin <liushixin2@huawei.com>, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
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

Use DEFINE_SEQ_ATTRIBUTE macro to simplify the code.

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index b13a9e3f99dd..f38c40a76251 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -260,34 +260,14 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 	return 0;
 }
 
-static const struct seq_operations vgic_debug_seq_ops = {
+static const struct seq_operations vgic_debug_sops = {
 	.start = vgic_debug_start,
 	.next  = vgic_debug_next,
 	.stop  = vgic_debug_stop,
 	.show  = vgic_debug_show
 };
 
-static int debug_open(struct inode *inode, struct file *file)
-{
-	int ret;
-	ret = seq_open(file, &vgic_debug_seq_ops);
-	if (!ret) {
-		struct seq_file *seq;
-		/* seq_open will have modified file->private_data */
-		seq = file->private_data;
-		seq->private = inode->i_private;
-	}
-
-	return ret;
-};
-
-static const struct file_operations vgic_debug_fops = {
-	.owner   = THIS_MODULE,
-	.open    = debug_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release
-};
+DEFINE_SEQ_ATTRIBUTE(vgic_debug);
 
 void vgic_debug_init(struct kvm *kvm)
 {
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
