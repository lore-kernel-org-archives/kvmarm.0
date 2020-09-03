Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D78C433E9
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 15:56:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C8F12072A
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 15:56:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="s/yMoN+W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C8F12072A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD67B4B2F3;
	Thu,  3 Sep 2020 11:56:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gZJGs6l9xaH3; Thu,  3 Sep 2020 11:56:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95E684B2F4;
	Thu,  3 Sep 2020 11:56:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CF1D4B2CB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 11:56:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iBSU64RDJWxG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 11:56:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C5384B2F3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 11:56:16 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 350A020775;
 Thu,  3 Sep 2020 15:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599148575;
 bh=EUAnw+lWQ+cQMNjPnrjGEu/3OgEkhBEkYZ7J3y/Lfa4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=s/yMoN+W2anQfzITjpc+JTuk6Xq6VnN3WDqBgtQAQZiT/Yphxl771Tpeg6fORHqPl
 vdhN46HuDry2tT0/F2jjip/4/e0eREqymzdJG7NrJPF2YnfG+cEd+zvXBre+fkR+mA
 PP5EGIM97bGGCgaQ1AzkIROOTrNkZVlMe2P7OtT0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kDr8G-008vT9-JA; Thu, 03 Sep 2020 16:26:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 23/23] KVM: arm64: Add debugfs files for the rVIC/rVID
 implementation
Date: Thu,  3 Sep 2020 16:26:10 +0100
Message-Id: <20200903152610.1078827-24-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200903152610.1078827-1-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Christoffer.Dall@arm.com, lorenzo.pieralisi@arm.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com
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

It turns out that having these debugfs information is really
useful when trying to understand what is going wrong in a
guest, or even in the host kernel...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/rvic-cpu.c | 140 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)

diff --git a/arch/arm64/kvm/rvic-cpu.c b/arch/arm64/kvm/rvic-cpu.c
index 5fb200c637d9..0e91bf6633d5 100644
--- a/arch/arm64/kvm/rvic-cpu.c
+++ b/arch/arm64/kvm/rvic-cpu.c
@@ -6,6 +6,7 @@
  * Author: Marc Zyngier <maz@kernel.org>
  */
 
+#include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/kvm_host.h>
 #include <linux/list.h>
@@ -707,6 +708,8 @@ static int rvic_inject_userspace_irq(struct kvm *kvm, unsigned int type,
 	}
 }
 
+static void rvic_create_debugfs(struct kvm_vcpu *vcpu);
+
 static int rvic_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct rvic_vm_data *data = vcpu->kvm->arch.irqchip_data;
@@ -743,6 +746,8 @@ static int rvic_vcpu_init(struct kvm_vcpu *vcpu)
 		irq->line_level		= false;
 	}
 
+	rvic_create_debugfs(vcpu);
+
 	return 0;
 }
 
@@ -913,6 +918,8 @@ static void rvic_device_destroy(struct kvm_device *dev)
 	kfree(dev);
 }
 
+static void rvid_create_debugfs(struct kvm *kvm);
+
 static int rvic_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 {
 	struct rvic_vm_data *data;
@@ -969,6 +976,7 @@ static int rvic_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 		}
 
 		dev->kvm->arch.irqchip_data = data;
+		rvid_create_debugfs(dev->kvm);
 
 		ret = 0;
 		break;
@@ -1071,3 +1079,135 @@ int kvm_register_rvic_device(void)
 {
 	return kvm_register_device_ops(&rvic_dev_ops, KVM_DEV_TYPE_ARM_RVIC);
 }
+
+static void rvic_irq_debug_show_one(struct seq_file *s, struct rvic_irq *irq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq->lock, flags);
+
+	seq_printf(s, "%d: [%d] %c %c %ps %c %c\n",
+		   irq->intid, irq->host_irq,
+		   irq->pending ? 'P' : 'p',
+		   irq->masked ? 'M' : 'm',
+		   irq->get_line_level,
+		   irq->get_line_level ? 'x' : (irq->line_level ? 'H' : 'L'),
+		   rvic_irq_queued(irq) ? 'Q' : 'i');
+
+	spin_unlock_irqrestore(&irq->lock, flags);
+}
+
+static int rvic_irq_debug_show(struct seq_file *s, void *p)
+{
+	rvic_irq_debug_show_one(s, s->private);
+	return 0;
+}
+
+static int rvic_irq_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rvic_irq_debug_show, inode->i_private);
+}
+
+static const struct file_operations rvic_irq_debug_fops = {
+	.open		= rvic_irq_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int rvic_debug_show(struct seq_file *s, void *p)
+{
+	struct kvm_vcpu *vcpu = s->private;
+	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
+	struct rvic_irq *irq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rvic->lock, flags);
+
+	seq_printf(s, "%s\n", rvic->enabled ? "Enabled" : "Disabled");
+	seq_printf(s, "%d Trusted\n", rvic->nr_trusted);
+	seq_printf(s, "%d Total\n", rvic->nr_total);
+	list_for_each_entry(irq, &rvic->delivery, delivery_entry)
+		rvic_irq_debug_show_one(s, irq);
+
+	spin_unlock_irqrestore(&rvic->lock, flags);
+
+	return 0;
+}
+
+static int rvic_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rvic_debug_show, inode->i_private);
+}
+
+static const struct file_operations rvic_debug_fops = {
+	.open		= rvic_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void rvic_create_debugfs(struct kvm_vcpu *vcpu)
+{
+	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
+	struct dentry *rvic_root;
+	char dname[128];
+	int i;
+
+	snprintf(dname, sizeof(dname), "rvic-%d", vcpu->vcpu_id);
+	rvic_root = debugfs_create_dir(dname, vcpu->kvm->debugfs_dentry);
+	if (!rvic_root)
+		return;
+
+	debugfs_create_file("state", 0444, rvic_root, vcpu, &rvic_debug_fops);
+	for (i = 0; i < rvic->nr_total; i++) {
+		snprintf(dname, sizeof(dname), "%d", i);
+		debugfs_create_file(dname, 0444, rvic_root,
+				    rvic_get_irq(rvic, i),
+				    &rvic_irq_debug_fops);
+	}
+}
+
+static int rvid_debug_show(struct seq_file *s, void *p)
+{
+	struct kvm *kvm = s->private;
+	struct rvic_vm_data *data = kvm->arch.irqchip_data;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&data->lock, flags);
+
+	seq_printf(s, "%d Trusted\n", data->nr_trusted);
+	seq_printf(s, "%d Total\n", data->nr_total);
+
+	for (i = 0; i < rvic_nr_untrusted(data); i++) {
+		if (data->rvid_map[i].intid < data->nr_trusted)
+			continue;
+
+		seq_printf(s, "%4u: vcpu-%u %u\n",
+			   i, data->rvid_map[i].target_vcpu,
+			   data->rvid_map[i].intid);
+	}
+
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	return 0;
+}
+
+static int rvid_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rvid_debug_show, inode->i_private);
+}
+
+static const struct file_operations rvid_debug_fops = {
+	.open		= rvid_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void rvid_create_debugfs(struct kvm *kvm)
+{
+	debugfs_create_file("rvid", 0444, kvm->debugfs_dentry,
+			    kvm, &rvid_debug_fops);
+}
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
