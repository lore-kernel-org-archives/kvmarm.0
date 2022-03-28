Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB60C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 28 Mar 2022 13:39:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E9EE4B1BF;
	Mon, 28 Mar 2022 09:39:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eZ5+fQ2L+rDA; Mon, 28 Mar 2022 09:39:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CABF4B1FD;
	Mon, 28 Mar 2022 09:39:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6759A40C52
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 06:38:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 46LRuRgE+HWm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Mar 2022 06:38:44 -0400 (EDT)
Received: from ha.nfschina.com (mail.nfschina.com [124.16.136.209])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0487340BD6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 06:38:43 -0400 (EDT)
Received: from localhost (unknown [127.0.0.1])
 by ha.nfschina.com (Postfix) with ESMTP id B2AE01E80D6F;
 Mon, 28 Mar 2022 18:38:04 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from ha.nfschina.com ([127.0.0.1])
 by localhost (ha.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hTti3BhPV8W4; Mon, 28 Mar 2022 18:38:02 +0800 (CST)
Received: from ubuntu.localdomain (unknown [101.228.248.165])
 (Authenticated sender: yuzhe@nfschina.com)
 by ha.nfschina.com (Postfix) with ESMTPA id 7D08B1E80D6E;
 Mon, 28 Mar 2022 18:38:01 +0800 (CST)
From: yuzhe <yuzhe@nfschina.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com
Subject: [PATCH] KVM: arm64: vgic-debug: remove unnecessary type castings
Date: Mon, 28 Mar 2022 03:38:36 -0700
Message-Id: <20220328103836.2829-1-yuzhe@nfschina.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Mailman-Approved-At: Mon, 28 Mar 2022 09:39:41 -0400
Cc: yuzhe <yuzhe@nfschina.com>, catalin.marinas@arm.com,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 liqiong@nfschina.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

remove unnecessary castings, from "void *" to "struct kvm *"

Signed-off-by: yuzhe <yuzhe@nfschina.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index f38c40a76251..927e5c1f650d 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -82,7 +82,7 @@ static bool end_of_vgic(struct vgic_state_iter *iter)
 
 static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
 {
-	struct kvm *kvm = (struct kvm *)s->private;
+	struct kvm *kvm = s->private;
 	struct vgic_state_iter *iter;
 
 	mutex_lock(&kvm->lock);
@@ -110,7 +110,7 @@ static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
 
 static void *vgic_debug_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct kvm *kvm = (struct kvm *)s->private;
+	struct kvm *kvm = s->private;
 	struct vgic_state_iter *iter = kvm->arch.vgic.iter;
 
 	++*pos;
@@ -122,7 +122,7 @@ static void *vgic_debug_next(struct seq_file *s, void *v, loff_t *pos)
 
 static void vgic_debug_stop(struct seq_file *s, void *v)
 {
-	struct kvm *kvm = (struct kvm *)s->private;
+	struct kvm *kvm = s->private;
 	struct vgic_state_iter *iter;
 
 	/*
@@ -229,7 +229,7 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
 
 static int vgic_debug_show(struct seq_file *s, void *v)
 {
-	struct kvm *kvm = (struct kvm *)s->private;
+	struct kvm *kvm = s->private;
 	struct vgic_state_iter *iter = (struct vgic_state_iter *)v;
 	struct vgic_irq *irq;
 	struct kvm_vcpu *vcpu = NULL;
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
