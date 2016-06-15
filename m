From: James Morse <james.morse@arm.com>
Subject: [PATCH] kvmtool: devices.c: Update parent when inserting into rbtree
Date: Wed, 15 Jun 2016 11:59:08 +0100
Message-ID: <1465988348-968-1-git-send-email-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 459B8412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2016 06:56:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gtw8bGQzKWAP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jun 2016 06:56:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2096A41145
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2016 06:56:47 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

When walking the devices rbtree to insert a node, we must keep track of the
parent node when we descend. If we skip this step, we always insert new
nodes with a NULL parent, bypassing __rb_insert()s rebalance code.

Things get worse when we come to walk the tree, as we can't move up a
level. This isn't a problem in practice, as all devices appear to be
inserted in-order, so our rbtree is actually a monochrome linked list.

Signed-off-by: James Morse <james.morse@arm.com>
---
 devices.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/devices.c b/devices.c
index b560a59..a7c666a 100644
--- a/devices.c
+++ b/devices.c
@@ -45,6 +45,7 @@ int device__register(struct device_header *dev)
 		int num = rb_entry(*node, struct device_header, node)->dev_num;
 		int result = dev->dev_num - num;
 
+		parent = *node;
 		if (result < 0)
 			node = &((*node)->rb_left);
 		else if (result > 0)
-- 
2.8.0.rc3
