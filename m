From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 58/59] irqchip/gic-v3-its: Pass its_node pointer to each command bulder
Date: Mon, 31 Jul 2017 18:26:36 +0100
Message-ID: <20170731172637.29355-59-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

In order to be able to issue command variants depending on
how broken an ITS is, let's pass the its pointer to all
command building primitives.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 58 ++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 20 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 9f32cd42238f..e22c8746ce89 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -264,10 +264,12 @@ struct its_cmd_block {
 #define ITS_CMD_QUEUE_SZ		SZ_64K
 #define ITS_CMD_QUEUE_NR_ENTRIES	(ITS_CMD_QUEUE_SZ / sizeof(struct its_cmd_block))
 
-typedef struct its_collection *(*its_cmd_builder_t)(struct its_cmd_block *,
+typedef struct its_collection *(*its_cmd_builder_t)(struct its_node *,
+						    struct its_cmd_block *,
 						    struct its_cmd_desc *);
 
-typedef struct its_vpe *(*its_cmd_vbuilder_t)(struct its_cmd_block *,
+typedef struct its_vpe *(*its_cmd_vbuilder_t)(struct its_node *,
+					      struct its_cmd_block *,
 					      struct its_cmd_desc *);
 
 static void its_mask_encode(u64 *raw_cmd, u64 val, int h, int l)
@@ -371,7 +373,8 @@ static inline void its_fixup_cmd(struct its_cmd_block *cmd)
 	cmd->raw_cmd[3] = cpu_to_le64(cmd->raw_cmd[3]);
 }
 
-static struct its_collection *its_build_mapd_cmd(struct its_cmd_block *cmd,
+static struct its_collection *its_build_mapd_cmd(struct its_node *its,
+						 struct its_cmd_block *cmd,
 						 struct its_cmd_desc *desc)
 {
 	unsigned long itt_addr;
@@ -391,7 +394,8 @@ static struct its_collection *its_build_mapd_cmd(struct its_cmd_block *cmd,
 	return NULL;
 }
 
-static struct its_collection *its_build_mapc_cmd(struct its_cmd_block *cmd,
+static struct its_collection *its_build_mapc_cmd(struct its_node *its,
+						 struct its_cmd_block *cmd,
 						 struct its_cmd_desc *desc)
 {
 	its_encode_cmd(cmd, GITS_CMD_MAPC);
@@ -404,7 +408,8 @@ static struct its_collection *its_build_mapc_cmd(struct its_cmd_block *cmd,
 	return desc->its_mapc_cmd.col;
 }
 
-static struct its_collection *its_build_mapti_cmd(struct its_cmd_block *cmd,
+static struct its_collection *its_build_mapti_cmd(struct its_node *its,
+						  struct its_cmd_block *cmd,
 						  struct its_cmd_desc *desc)
 {
 	struct its_collection *col;
@@ -423,7 +428,8 @@ static struct its_collection *its_build_mapti_cmd(struct its_cmd_block *cmd,
 	return col;
 }
 
-static struct its_collection *its_build_movi_cmd(struct its_cmd_block *cmd,
+static struct its_collection *its_build_movi_cmd(struct its_node *its,
+						 struct its_cmd_block *cmd,
 						 struct its_cmd_desc *desc)
 {
 	struct its_collection *col;
@@ -441,7 +447,8 @@ static struct its_collection *its_build_movi_cmd(struct its_cmd_block *cmd,
 	return col;
 }
 
-static struct its_collection *its_build_discard_cmd(struct its_cmd_block *cmd,
+static struct its_collection *its_build_discard_cmd(struct its_node *its,
+						    struct its_cmd_block *cmd,
 						    struct its_cmd_desc *desc)
 {
 	struct its_collection *col;
@@ -458,7 +465,8 @@ static struct its_collection *its_build_discard_cmd(struct its_cmd_block *cmd,
 	return col;
 }
 
-static struct its_collection *its_build_inv_cmd(struct its_cmd_block *cmd,
+static struct its_collection *its_build_inv_cmd(struct its_node *its,
+						struct its_cmd_block *cmd,
 						struct its_cmd_desc *desc)
 {
 	struct its_collection *col;
@@ -475,7 +483,8 @@ static struct its_collection *its_build_inv_cmd(struct its_cmd_block *cmd,
 	return col;
 }
 
-static struct its_collection *its_build_int_cmd(struct its_cmd_block *cmd,
+static struct its_collection *its_build_int_cmd(struct its_node *its,
+						struct its_cmd_block *cmd,
 						struct its_cmd_desc *desc)
 {
 	struct its_collection *col;
@@ -492,7 +501,8 @@ static struct its_collection *its_build_int_cmd(struct its_cmd_block *cmd,
 	return col;
 }
 
-static struct its_collection *its_build_clear_cmd(struct its_cmd_block *cmd,
+static struct its_collection *its_build_clear_cmd(struct its_node *its,
+						  struct its_cmd_block *cmd,
 						  struct its_cmd_desc *desc)
 {
 	struct its_collection *col;
@@ -509,7 +519,8 @@ static struct its_collection *its_build_clear_cmd(struct its_cmd_block *cmd,
 	return col;
 }
 
-static struct its_collection *its_build_invall_cmd(struct its_cmd_block *cmd,
+static struct its_collection *its_build_invall_cmd(struct its_node *its,
+						   struct its_cmd_block *cmd,
 						   struct its_cmd_desc *desc)
 {
 	its_encode_cmd(cmd, GITS_CMD_INVALL);
@@ -520,7 +531,8 @@ static struct its_collection *its_build_invall_cmd(struct its_cmd_block *cmd,
 	return NULL;
 }
 
-static struct its_vpe *its_build_vinvall_cmd(struct its_cmd_block *cmd,
+static struct its_vpe *its_build_vinvall_cmd(struct its_node *its,
+					     struct its_cmd_block *cmd,
 					     struct its_cmd_desc *desc)
 {
 	its_encode_cmd(cmd, GITS_CMD_VINVALL);
@@ -531,7 +543,8 @@ static struct its_vpe *its_build_vinvall_cmd(struct its_cmd_block *cmd,
 	return desc->its_vinvall_cmd.vpe;
 }
 
-static struct its_vpe *its_build_vmapp_cmd(struct its_cmd_block *cmd,
+static struct its_vpe *its_build_vmapp_cmd(struct its_node *its,
+					   struct its_cmd_block *cmd,
 					   struct its_cmd_desc *desc)
 {
 	unsigned long vpt_addr;
@@ -550,7 +563,8 @@ static struct its_vpe *its_build_vmapp_cmd(struct its_cmd_block *cmd,
 	return desc->its_vmapp_cmd.vpe;
 }
 
-static struct its_vpe *its_build_vmapti_cmd(struct its_cmd_block *cmd,
+static struct its_vpe *its_build_vmapti_cmd(struct its_node *its,
+					    struct its_cmd_block *cmd,
 					    struct its_cmd_desc *desc)
 {
 	u32 db;
@@ -572,7 +586,8 @@ static struct its_vpe *its_build_vmapti_cmd(struct its_cmd_block *cmd,
 	return desc->its_vmapti_cmd.vpe;
 }
 
-static struct its_vpe *its_build_vmovi_cmd(struct its_cmd_block *cmd,
+static struct its_vpe *its_build_vmovi_cmd(struct its_node *its,
+					   struct its_cmd_block *cmd,
 					   struct its_cmd_desc *desc)
 {
 	u32 db;
@@ -594,7 +609,8 @@ static struct its_vpe *its_build_vmovi_cmd(struct its_cmd_block *cmd,
 	return desc->its_vmovi_cmd.vpe;
 }
 
-static struct its_vpe *its_build_vmovp_cmd(struct its_cmd_block *cmd,
+static struct its_vpe *its_build_vmovp_cmd(struct its_node *its,
+					   struct its_cmd_block *cmd,
 					   struct its_cmd_desc *desc)
 {
 	its_encode_cmd(cmd, GITS_CMD_VMOVP);
@@ -722,7 +738,7 @@ void name(struct its_node *its,						\
 		raw_spin_unlock_irqrestore(&its->lock, flags);		\
 		return;							\
 	}								\
-	sync_obj = builder(cmd, desc);					\
+	sync_obj = builder(its, cmd, desc);				\
 	its_flush_cmd(its, cmd);					\
 									\
 	if (sync_obj) {							\
@@ -730,7 +746,7 @@ void name(struct its_node *its,						\
 		if (!sync_cmd)						\
 			goto post;					\
 									\
-		buildfn(sync_cmd, sync_obj);				\
+		buildfn(its, sync_cmd, sync_obj);			\
 		its_flush_cmd(its, sync_cmd);				\
 	}								\
 									\
@@ -741,7 +757,8 @@ post:									\
 	its_wait_for_range_completion(its, cmd, next_cmd);		\
 }
 
-static void its_build_sync_cmd(struct its_cmd_block *sync_cmd,
+static void its_build_sync_cmd(struct its_node *its,
+			       struct its_cmd_block *sync_cmd,
 			       struct its_collection *sync_col)
 {
 	its_encode_cmd(sync_cmd, GITS_CMD_SYNC);
@@ -753,7 +770,8 @@ static void its_build_sync_cmd(struct its_cmd_block *sync_cmd,
 static BUILD_SINGLE_CMD_FUNC(its_send_single_command, its_cmd_builder_t,
 			     struct its_collection, its_build_sync_cmd)
 
-static void its_build_vsync_cmd(struct its_cmd_block *sync_cmd,
+static void its_build_vsync_cmd(struct its_node *its,
+				struct its_cmd_block *sync_cmd,
 				struct its_vpe *sync_vpe)
 {
 	its_encode_cmd(sync_cmd, GITS_CMD_VSYNC);
-- 
2.11.0
