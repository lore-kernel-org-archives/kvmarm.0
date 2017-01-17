From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 05/33] irqchip/gic-v3-its: Zero command on allocation
Date: Tue, 17 Jan 2017 10:20:26 +0000
Message-ID: <1484648454-21216-6-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83403405DA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b3qeSzp99S1g for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF1F4405E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:30 -0500 (EST)
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

When reusing commands from the ring buffer, it would be better
to zero them out, even if the ITS should ignore the unused
fields.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 2ca27f6..9304dd2 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -426,6 +426,12 @@ static struct its_cmd_block *its_allocate_entry(struct its_node *its)
 	if (its->cmd_write == (its->cmd_base + ITS_CMD_QUEUE_NR_ENTRIES))
 		its->cmd_write = its->cmd_base;
 
+	/* Clear command  */
+	cmd->raw_cmd[0] = 0;
+	cmd->raw_cmd[1] = 0;
+	cmd->raw_cmd[2] = 0;
+	cmd->raw_cmd[3] = 0;
+
 	return cmd;
 }
 
-- 
2.1.4
