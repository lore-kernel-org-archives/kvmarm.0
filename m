From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 07/33] irqchip/gic-v3-its: Macro-ize
 its_send_single_command
Date: Tue, 17 Jan 2017 10:20:28 +0000
Message-ID: <1484648454-21216-8-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D1CB4069A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IPvi-LKvKcbN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84467407F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:33 -0500 (EST)
In-Reply-To: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Most ITS commands do operate on a collection object, and require
a SYNC command to be performed on that collection in order to
guarantee the execution of the first command.

With GICv4 ITS, another set of commands perform similar operations
on a VPE object, and a VSYNC operations must be executed to guarantee
their execution.

Given the similarities (post a command, perform a synchronization
operation on a sync object), it makes sense to reuse the same
mechanism for both class of commands.

Let's start with turning its_send_single_command into a huge macro
that performs the bulk of the work, and a set of helpers that
make this macro useeable for the GICv3 ITS commands.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 82 ++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 37 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 99f6130..520b764 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -484,43 +484,51 @@ static void its_wait_for_range_completion(struct its_node *its,
 	}
 }
 
-static void its_send_single_command(struct its_node *its,
-				    its_cmd_builder_t builder,
-				    struct its_cmd_desc *desc)
-{
-	struct its_cmd_block *cmd, *sync_cmd, *next_cmd;
-	struct its_collection *sync_col;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&its->lock, flags);
-
-	cmd = its_allocate_entry(its);
-	if (!cmd) {		/* We're soooooo screewed... */
-		pr_err_ratelimited("ITS can't allocate, dropping command\n");
-		raw_spin_unlock_irqrestore(&its->lock, flags);
-		return;
-	}
-	sync_col = builder(cmd, desc);
-	its_flush_cmd(its, cmd);
-
-	if (sync_col) {
-		sync_cmd = its_allocate_entry(its);
-		if (!sync_cmd) {
-			pr_err_ratelimited("ITS can't SYNC, skipping\n");
-			goto post;
-		}
-		its_encode_cmd(sync_cmd, GITS_CMD_SYNC);
-		its_encode_target(sync_cmd, sync_col->target_address);
-		its_fixup_cmd(sync_cmd);
-		its_flush_cmd(its, sync_cmd);
-	}
-
-post:
-	next_cmd = its_post_commands(its);
-	raw_spin_unlock_irqrestore(&its->lock, flags);
-
-	its_wait_for_range_completion(its, cmd, next_cmd);
-}
+#define __its_send_single_cmd(name, buildtype, synctype, buildfn)	\
+void name(struct its_node *its,						\
+	  buildtype builder,						\
+	  struct its_cmd_desc *desc)					\
+{									\
+	struct its_cmd_block *cmd, *sync_cmd, *next_cmd;		\
+	synctype *sync_obj;						\
+	unsigned long flags;						\
+									\
+	raw_spin_lock_irqsave(&its->lock, flags);			\
+									\
+	cmd = its_allocate_entry(its);					\
+	if (!cmd) {		/* We're soooooo screewed... */		\
+		raw_spin_unlock_irqrestore(&its->lock, flags);		\
+		return;							\
+	}								\
+	sync_obj = builder(cmd, desc);					\
+	its_flush_cmd(its, cmd);					\
+									\
+	if (sync_obj) {							\
+		sync_cmd = its_allocate_entry(its);			\
+		if (!sync_cmd)						\
+			goto post;					\
+									\
+		buildfn(sync_cmd, sync_obj);				\
+		its_fixup_cmd(sync_cmd);				\
+		its_flush_cmd(its, sync_cmd);				\
+	}								\
+									\
+post:									\
+	next_cmd = its_post_commands(its);				\
+	raw_spin_unlock_irqrestore(&its->lock, flags);			\
+									\
+	its_wait_for_range_completion(its, cmd, next_cmd);		\
+}
+
+static void its_build_sync_cmd(struct its_cmd_block *sync_cmd,
+			       struct its_collection *sync_col)
+{
+	its_encode_cmd(sync_cmd, GITS_CMD_SYNC);
+	its_encode_target(sync_cmd, sync_col->target_address);
+}
+
+static __its_send_single_cmd(its_send_single_command, its_cmd_builder_t,
+			     struct its_collection, its_build_sync_cmd)
 
 static void its_send_inv(struct its_device *dev, u32 event_id)
 {
-- 
2.1.4
