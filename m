Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43007C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 12:55:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0AFC4A11C;
	Tue, 29 Mar 2022 08:55:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aTELA0feNNbZ; Tue, 29 Mar 2022 08:55:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7908249F4A;
	Tue, 29 Mar 2022 08:55:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DA8949DFF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 06:21:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XlguHELdW5cJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Mar 2022 06:21:08 -0400 (EDT)
Received: from ha.nfschina.com (unknown [124.16.136.209])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F07940FD6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 06:21:08 -0400 (EDT)
Received: from localhost (unknown [127.0.0.1])
 by ha.nfschina.com (Postfix) with ESMTP id 177B71E80D85;
 Tue, 29 Mar 2022 18:20:31 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from ha.nfschina.com ([127.0.0.1])
 by localhost (ha.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DkKIvnZ9PCZ3; Tue, 29 Mar 2022 18:20:28 +0800 (CST)
Received: from ubuntu.localdomain (unknown [101.228.248.165])
 (Authenticated sender: yuzhe@nfschina.com)
 by ha.nfschina.com (Postfix) with ESMTPA id 8DE961E80D84;
 Tue, 29 Mar 2022 18:20:27 +0800 (CST)
From: Yu Zhe <yuzhe@nfschina.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com
Subject: [PATCH] KVM: arm64: vgic: remove unnecessary type castings
Date: Tue, 29 Mar 2022 03:20:59 -0700
Message-Id: <20220329102059.268983-1-yuzhe@nfschina.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220328103836.2829-1-yuzhe@nfschina.com>
References: <20220328103836.2829-1-yuzhe@nfschina.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 29 Mar 2022 08:55:51 -0400
Cc: justin.he@arm.com, keescook@chromium.org, Yu Zhe <yuzhe@nfschina.com>,
 catalin.marinas@arm.com, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org, samitolvanen@google.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

remove unnecessary casts.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 10 +++++-----
 arch/arm64/kvm/vgic/vgic-its.c   |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index f38c40a76251..78cde687383c 100644
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
@@ -229,8 +229,8 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
 
 static int vgic_debug_show(struct seq_file *s, void *v)
 {
-	struct kvm *kvm = (struct kvm *)s->private;
-	struct vgic_state_iter *iter = (struct vgic_state_iter *)v;
+	struct kvm *kvm = s->private;
+	struct vgic_state_iter *iter = v;
 	struct vgic_irq *irq;
 	struct kvm_vcpu *vcpu = NULL;
 	unsigned long flags;
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 089fc2ffcb43..2e13402be3bd 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2143,7 +2143,7 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 				void *ptr, void *opaque)
 {
-	struct its_device *dev = (struct its_device *)opaque;
+	struct its_device *dev = opaque;
 	struct its_collection *collection;
 	struct kvm *kvm = its->dev->kvm;
 	struct kvm_vcpu *vcpu = NULL;
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
